import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lndry_vendor_app/api/repositories/api_app_mode_repository.dart';
import 'package:lndry_vendor_app/core/services/storage_service.dart';
import 'package:lndry_vendor_app/models/pos/app_mode_model.dart';
import 'package:lndry_vendor_app/providers/app_mode_provider.dart';
import 'package:lndry_vendor_app/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fakes.dart';

Future<({ProviderContainer c, FakeAppModeRepo repo, FakeAuth auth, MemStorage storage})> setup({
  FakeAppModeRepo? repo,
  Map<String, Object> prefs = const {},
}) async {
  SharedPreferences.setMockInitialValues(prefs);
  final storage = MemStorage(prefs: await SharedPreferences.getInstance());
  final fake = repo ?? FakeAppModeRepo();
  final auth = FakeAuth(storage);
  final c = ProviderContainer(overrides: [
    storageServiceProvider.overrideWithValue(storage),
    appModeRepositoryProvider.overrideWithValue(fake),
    authProvider.overrideWith((ref) => auth),
  ]);
  addTearDown(c.dispose);
  // AuthNotifier restores its session in the background from its constructor and, finding no
  // tokens, finishes by setting "signed out". Let that happen BEFORE a test drives the state,
  // otherwise it would overwrite the test's sign-in.
  c.read(authProvider);
  await Future<void>.delayed(const Duration(milliseconds: 50));
  return (c: c, repo: fake, auth: auth, storage: storage);
}

/// Waits for the notifier's own async load (auth listener kicks it off).
Future<void> settle(ProviderContainer c) async {
  for (var i = 0; i < 20; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  test('starts idle and does nothing while signed out', () async {
    final t = await setup();
    expect(t.c.read(appModeProvider).status, AppModeStatus.idle);
    expect(t.repo.getCalls, 0);
  });

  test('signing in loads the modes once', () async {
    final t = await setup();
    t.c.read(appModeProvider);
    t.auth.signInOwner();
    await settle(t.c);
    final s = t.c.read(appModeProvider);
    expect(s.status, AppModeStatus.ready);
    expect(s.info?.shopName, 'Sparkle');
    expect(s.allowed, [AppMode.marketplace, AppMode.pos]);
    expect(t.repo.getCalls, 1);
  });

  test('a saved choice for THIS vendor is restored; another vendor\'s is not', () async {
    final t = await setup(prefs: {appModePrefKey('v1'): 'POS', appModePrefKey('other'): 'MARKETPLACE'});
    t.c.read(appModeProvider);
    t.auth.signInOwner();
    await settle(t.c);
    expect(t.c.read(appModeProvider).effective, AppMode.pos);

    final t2 = await setup(prefs: {appModePrefKey('someone-else'): 'POS'});
    t2.c.read(appModeProvider);
    t2.auth.signInOwner();
    await settle(t2.c);
    expect(t2.c.read(appModeProvider).selected, isNull);
    expect(t2.c.read(appModeProvider).effective, AppMode.marketplace);
  });

  test('a saved POS choice is ignored once POS is no longer allowed', () async {
    final t = await setup(
      repo: FakeAppModeRepo(mode: info(allowed: const ['MARKETPLACE'], status: 'IN_PROGRESS')),
      prefs: {appModePrefKey('v1'): 'POS'},
    );
    t.c.read(appModeProvider);
    t.auth.signInOwner();
    await settle(t.c);
    final s = t.c.read(appModeProvider);
    expect(s.selected, AppMode.pos); // remembered…
    expect(s.effective, AppMode.marketplace); // …but never honoured
  });

  test('setMode switches, persists per vendor, and refuses a mode that is not allowed', () async {
    final t = await setup();
    final n = t.c.read(appModeProvider.notifier);
    t.auth.signInOwner();
    await settle(t.c);
    expect(await n.setMode(AppMode.pos), isTrue);
    expect(t.c.read(appModeProvider).effective, AppMode.pos);
    expect(t.storage.getString(appModePrefKey('v1')), 'POS');
    expect(await n.setMode(AppMode.marketplace), isTrue);
    expect(t.storage.getString(appModePrefKey('v1')), 'MARKETPLACE');

    final only = await setup(repo: FakeAppModeRepo(mode: info(offering: 'MARKETPLACE', allowed: const ['MARKETPLACE'], status: 'NOT_STARTED', canStart: true)));
    only.c.read(appModeProvider);
    only.auth.signInOwner();
    await settle(only.c);
    expect(await only.c.read(appModeProvider.notifier).setMode(AppMode.pos), isFalse);
    expect(only.c.read(appModeProvider).effective, AppMode.marketplace);
    expect(only.storage.getString(appModePrefKey('v1')), isNull);
  });

  test('a failed lookup (offline / old backend) falls back to marketplace, never POS', () async {
    final repo = FakeAppModeRepo()..getError = Exception('404');
    final t = await setup(repo: repo, prefs: {appModePrefKey('v1'): 'POS'});
    t.c.read(appModeProvider);
    t.auth.signInOwner();
    await settle(t.c);
    final s = t.c.read(appModeProvider);
    expect(s.status, AppModeStatus.failed);
    expect(s.resolved, isTrue);
    expect(s.effective, AppMode.marketplace);
    expect(s.canSwitch, isFalse);
  });

  test('a later failure keeps what was already known (a bad signal never takes a mode away)', () async {
    final t = await setup();
    final n = t.c.read(appModeProvider.notifier);
    t.auth.signInOwner();
    await settle(t.c);
    t.repo.getError = Exception('offline');
    await n.load();
    final s = t.c.read(appModeProvider);
    expect(s.status, AppModeStatus.ready);
    expect(s.allowed, [AppMode.marketplace, AppMode.pos]);
  });

  test('a failed lookup is retried on the next sign-in event', () async {
    final repo = FakeAppModeRepo()..getError = Exception('offline');
    final t = await setup(repo: repo);
    t.c.read(appModeProvider);
    t.auth.signInOwner();
    await settle(t.c);
    expect(t.c.read(appModeProvider).status, AppModeStatus.failed);
    repo.getError = null;
    t.auth.signInOwner();
    await settle(t.c);
    expect(t.c.read(appModeProvider).status, AppModeStatus.ready);
  });

  test('concurrent loads collapse into one request', () async {
    final t = await setup();
    final n = t.c.read(appModeProvider.notifier);
    await Future.wait([n.load(), n.load(), n.load()]);
    expect(t.repo.getCalls, 1);
  });

  test('captains skip the lookup entirely', () async {
    final t = await setup();
    t.c.read(appModeProvider);
    t.auth.signInRider();
    await settle(t.c);
    expect(t.repo.getCalls, 0);
    expect(t.c.read(appModeProvider).resolved, isTrue);
    expect(t.c.read(appModeProvider).effective, AppMode.marketplace);
  });

  test('signing out resets everything', () async {
    final t = await setup(prefs: {appModePrefKey('v1'): 'POS'});
    t.c.read(appModeProvider);
    t.auth.signInOwner();
    await settle(t.c);
    t.auth.signOut();
    await settle(t.c);
    final s = t.c.read(appModeProvider);
    expect(s.status, AppModeStatus.idle);
    expect(s.info, isNull);
    expect(s.selected, isNull);
  });

  group('new user', () {
    test('is ready immediately with no lookup, and has not chosen yet', () async {
      final t = await setup();
      t.c.read(appModeProvider);
      t.auth.newUser('9999999999');
      await settle(t.c);
      final s = t.c.read(appModeProvider);
      expect(s.status, AppModeStatus.ready);
      expect(s.info?.hasVendor, isFalse);
      expect(s.marketplaceChosen, isFalse);
      expect(t.repo.getCalls, 0);
    });

    test('choosing Marketplace is remembered for that phone only', () async {
      final t = await setup();
      final n = t.c.read(appModeProvider.notifier);
      t.auth.newUser('9999999999');
      await settle(t.c);
      await n.chooseMarketplaceApplication('9999999999');
      expect(t.c.read(appModeProvider).marketplaceChosen, isTrue);
      expect(t.storage.getString(kMarketplaceChoicePhoneKey), '9999999999');

      // a different person on the same phone does not inherit the choice
      t.auth.signOut();
      t.auth.newUser('8888888888');
      await settle(t.c);
      expect(t.c.read(appModeProvider).marketplaceChosen, isFalse);
      // …but the same phone coming back does (restart mid-application)
      t.auth.newUser('9999999999');
      await settle(t.c);
      expect(t.c.read(appModeProvider).marketplaceChosen, isTrue);
    });

    test('choosing POS creates the shop, renews the login once, then loads the modes', () async {
      final repo = FakeAppModeRepo(mode: info(offering: 'POS', status: 'IN_PROGRESS', allowed: const [], needsOnboarding: true))
        ..startResult = PosStartResult(info: info(offering: 'POS', status: 'IN_PROGRESS', allowed: const []), created: true, needsTokenRefresh: true);
      final t = await setup(repo: repo);
      final n = t.c.read(appModeProvider.notifier);
      t.auth.newUser('9999999999');
      await settle(t.c);
      await n.startPosAsNewUser();
      expect(repo.startCalls, 1);
      expect(t.auth.adoptCalls, 1);
      final s = t.c.read(appModeProvider);
      expect(s.info?.offering, VendorOffering.pos);
      expect(s.mustFinishPosOnboarding, isTrue);
    });

    test('no token renewal when the backend says none is needed', () async {
      final t = await setup();
      final n = t.c.read(appModeProvider.notifier);
      t.auth.signInOwner();
      await settle(t.c);
      await n.startPosAsNewUser();
      expect(t.auth.adoptCalls, 0);
    });

    test('a failure surfaces to the caller and does not leave a half state', () async {
      final repo = FakeAppModeRepo()..startError = Exception('409');
      final t = await setup(repo: repo);
      final n = t.c.read(appModeProvider.notifier);
      t.auth.newUser('9999999999');
      await settle(t.c);
      await expectLater(n.startPosAsNewUser(), throwsException);
      expect(t.c.read(appModeProvider).info?.hasVendor, isFalse);
      expect(t.auth.adoptCalls, 0);
    });
  });

  test('"Get POS" for an existing vendor starts onboarding then reloads the modes', () async {
    final repo = FakeAppModeRepo(mode: info(offering: 'MARKETPLACE', status: 'NOT_STARTED', allowed: const ['MARKETPLACE'], canStart: true));
    final t = await setup(repo: repo);
    final n = t.c.read(appModeProvider.notifier);
    t.auth.signInOwner();
    await settle(t.c);
    repo.mode = info(status: 'IN_PROGRESS', allowed: const ['MARKETPLACE'], needsOnboarding: true);
    await n.startPosAsExistingVendor();
    expect(repo.startCalls, 1);
    expect(t.c.read(appModeProvider).info?.needsPosOnboarding, isTrue);
    expect(t.c.read(appModeProvider).mustFinishPosOnboarding, isFalse); // BOTH keeps marketplace usable
  });

  test('finishing the wizard opens POS and remembers it', () async {
    final t = await setup(repo: FakeAppModeRepo(mode: info(offering: 'POS', status: 'IN_PROGRESS', allowed: const [], needsOnboarding: true)));
    final n = t.c.read(appModeProvider.notifier);
    t.auth.signInOwner();
    await settle(t.c);
    expect(t.c.read(appModeProvider).mustFinishPosOnboarding, isTrue);
    n.adoptCompleted(info(offering: 'POS', allowed: const ['POS']));
    final s = t.c.read(appModeProvider);
    expect(s.mustFinishPosOnboarding, isFalse);
    expect(s.effective, AppMode.pos);
    expect(t.storage.getString(appModePrefKey('v1')), 'POS');
  });
}
