import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lndry_vendor_app/api/repositories/api_app_mode_repository.dart';
import 'package:lndry_vendor_app/core/network/network.dart';
import 'package:lndry_vendor_app/core/router/app_routes.dart';
import 'package:lndry_vendor_app/core/services/storage_service.dart';
import 'package:lndry_vendor_app/features/pos/core/pos_placeholder_page.dart';
import 'package:lndry_vendor_app/features/pos/core/pos_shell.dart';
import 'package:lndry_vendor_app/features/pos/mode/mode_switch_section.dart';
import 'package:lndry_vendor_app/features/pos/onboarding/choose_product_page.dart';
import 'package:lndry_vendor_app/features/pos/onboarding/pos_onboarding_page.dart';
import 'package:lndry_vendor_app/l10n/generated/app_localizations.dart';
import 'package:lndry_vendor_app/models/pos/app_mode_model.dart';
import 'package:lndry_vendor_app/providers/app_mode_provider.dart';
import 'package:lndry_vendor_app/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fakes.dart';

class Env {
  Env(this.c, this.repo, this.auth, this.storage);
  final ProviderContainer c;
  final FakeAppModeRepo repo;
  final FakeAuth auth;
  final MemStorage storage;
  AppModeState get mode => c.read(appModeProvider);
}

enum Who { owner, staff, newUser, signedOut }

Future<Env> pumpPage(
  WidgetTester tester,
  Widget page, {
  FakeAppModeRepo? repo,
  Who who = Who.owner,
  Locale locale = const Locale('en'),
  Map<String, Object> prefs = const {},
}) async {
  tester.view.physicalSize = const Size(780, 1688);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);

  SharedPreferences.setMockInitialValues(prefs);
  final storage = MemStorage(prefs: await SharedPreferences.getInstance());
  final fake = repo ?? FakeAppModeRepo(mode: who == Who.staff ? info(role: 'VENDOR_STAFF') : info());
  final auth = FakeAuth(storage);
  final c = ProviderContainer(overrides: [
    storageServiceProvider.overrideWithValue(storage),
    appModeRepositoryProvider.overrideWithValue(fake),
    authProvider.overrideWith((ref) => auth),
  ]);
  addTearDown(c.dispose);
  c.read(authProvider);
  await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
  c.read(appModeProvider);
  switch (who) {
    case Who.owner:
    case Who.staff:
      auth.signInOwner();
      await tester.runAsync(() => c.read(appModeProvider.notifier).load());
    case Who.newUser:
      auth.newUser('9999999999');
    case Who.signedOut:
      break;
  }

  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, __) => page),
      GoRoute(path: AppRoutes.posHome, builder: (_, __) => const Text('POS HOME SCREEN')),
      GoRoute(path: AppRoutes.posOnboarding, builder: (_, __) => const Text('ONBOARDING SCREEN')),
    ],
  );
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: c,
      child: MaterialApp.router(
        locale: locale,
        localizationsDelegates: const [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    ),
  );
  await tester.pumpAndSettle();
  return Env(c, fake, auth, storage);
}

/// A POS shop part-way through setup. Its shop name is the "My Shop" placeholder the backend creates, so the
/// wizard starts with an empty name field (a real shop name would be pre-filled).
FakeAppModeRepo incomplete({String shop = 'My Shop'}) =>
    FakeAppModeRepo(mode: info(offering: 'POS', status: 'IN_PROGRESS', allowed: const [], needsOnboarding: true, shop: shop));

/// Records compare their maps by identity-ish typing; compare the parts explicitly.
void expectSaved((String, Map<String, dynamic>) actual, String step, Map<String, dynamic> body) {
  expect(actual.$1, step);
  expect(actual.$2, equals(body));
}

Finder field(String label) => find.widgetWithText(TextFormField, label);
Finder button(String text) => find.widgetWithText(FilledButton, text);

Future<void> fillShop(WidgetTester t) async {
  await t.enterText(field('Shop name'), 'Sparkle Laundry');
  await t.enterText(field('Owner name'), 'Ravi Kumar');
  await t.enterText(field('Shop address'), '12 MG Road');
  await t.enterText(field('City'), 'Pune');
}

void main() {
  group('Marketplace-or-POS choice (new user)', () {
    testWidgets('shows both options in plain words, plus the "both" hint', (t) async {
      await pumpPage(t, const ChooseProductPage(), who: Who.newUser);
      expect(find.text('What do you need?'), findsOneWidget);
      expect(find.text('Get customers'), findsOneWidget);
      expect(find.text('Run my shop (POS)'), findsOneWidget);
      expect(find.textContaining('Want both?'), findsOneWidget);
      expect(find.text('Log out'), findsOneWidget);
    });

    testWidgets('speaks Hindi when the app language is Hindi', (t) async {
      await pumpPage(t, const ChooseProductPage(), who: Who.newUser, locale: const Locale('hi'));
      expect(find.text('आपको क्या चाहिए?'), findsOneWidget);
      expect(find.text('ग्राहक पाएं'), findsOneWidget);
    });

    testWidgets('Marketplace is remembered so the application wizard can open', (t) async {
      final e = await pumpPage(t, const ChooseProductPage(), who: Who.newUser);
      await t.tap(find.text('Get customers'));
      await t.pumpAndSettle();
      expect(e.mode.marketplaceChosen, isTrue);
      expect(e.repo.startCalls, 0, reason: 'no POS shop must be created');
    });

    testWidgets('POS creates the shop once and renews the login', (t) async {
      final repo = incomplete()
        ..startResult = PosStartResult(info: info(offering: 'POS', status: 'IN_PROGRESS', allowed: const []), created: true, needsTokenRefresh: true);
      final e = await pumpPage(t, const ChooseProductPage(), who: Who.newUser, repo: repo);
      await t.tap(find.text('Run my shop (POS)'));
      await t.pumpAndSettle();
      expect(repo.startCalls, 1);
      expect(e.auth.adoptCalls, 1);
      expect(e.mode.mustFinishPosOnboarding, isTrue);
    });

    testWidgets('a failure shows a plain message with Retry, and Retry tries again', (t) async {
      final repo = FakeAppModeRepo()..startError = const ApiException(message: 'You already have a marketplace application.', statusCode: 409);
      await pumpPage(t, const ChooseProductPage(), who: Who.newUser, repo: repo);
      await t.tap(find.text('Run my shop (POS)'));
      await t.pumpAndSettle();
      expect(find.text('You already have a marketplace application.'), findsOneWidget);
      repo.startError = null;
      await t.tap(find.text('Retry'));
      await t.pumpAndSettle();
      expect(repo.startCalls, 2);
      expect(find.text('You already have a marketplace application.'), findsNothing);
    });

    testWidgets('a technical failure never shows raw error text', (t) async {
      final repo = FakeAppModeRepo()..startError = const ApiException(message: 'SequelizeConnectionError: ECONNRESET at 10.0.0.4', statusCode: 500);
      await pumpPage(t, const ChooseProductPage(), who: Who.newUser, repo: repo);
      await t.tap(find.text('Run my shop (POS)'));
      await t.pumpAndSettle();
      expect(find.textContaining('Sequelize'), findsNothing);
      expect(find.textContaining('ECONNRESET'), findsNothing);
      expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
    });
  });

  group('POS onboarding wizard', () {
    testWidgets('starts at step 1 of 4 with the shop fields', (t) async {
      await pumpPage(t, const PosOnboardingPage(), repo: incomplete());
      expect(find.text('Step 1 of 4'), findsOneWidget);
      expect(find.text('Shop details'), findsOneWidget);
      for (final label in ['Shop name', 'Owner name', 'Shop address', 'City', 'State (optional)', 'Pincode (optional)']) {
        expect(field(label), findsOneWidget, reason: label);
      }
      expect(button('Next'), findsOneWidget);
    });

    testWidgets('empty required fields block Next, show plain messages, and nothing is saved', (t) async {
      final e = await pumpPage(t, const PosOnboardingPage(), repo: incomplete());
      await t.tap(button('Next'));
      await t.pumpAndSettle();
      expect(find.text('Enter your shop name'), findsOneWidget);
      expect(find.text('Enter the owner name'), findsOneWidget);
      expect(find.text('Enter your shop address'), findsOneWidget);
      expect(find.text('Enter your city'), findsOneWidget);
      expect(e.repo.saved, isEmpty);
      expect(find.text('Step 1 of 4'), findsOneWidget);
    });

    testWidgets('a bad pincode is caught on the phone', (t) async {
      final e = await pumpPage(t, const PosOnboardingPage(), repo: incomplete());
      await fillShop(t);
      await t.enterText(field('Pincode (optional)'), '4110');
      await t.tap(button('Next'));
      await t.pumpAndSettle();
      expect(find.text('Pincode must be 6 digits'), findsOneWidget);
      expect(e.repo.saved, isEmpty);
    });

    testWidgets('walks all four steps, saving each exactly as the backend expects, then finishes', (t) async {
      final e = await pumpPage(t, const PosOnboardingPage(), repo: incomplete());

      await fillShop(t);
      await t.enterText(field('Pincode (optional)'), '411001');
      await t.tap(button('Next'));
      await t.pumpAndSettle();
      expectSaved(e.repo.saved.last, 'shop', {'name': 'Sparkle Laundry', 'ownerName': 'Ravi Kumar', 'addressLine1': '12 MG Road', 'city': 'Pune', 'pincode': '411001'});
      expect(find.text('Step 2 of 4'), findsOneWidget);
      expect(find.text('Tax & payments'), findsOneWidget);

      // GST on: the GSTIN field appears and is required
      expect(field('GSTIN (15 characters)'), findsNothing);
      await t.tap(find.byType(Switch));
      await t.pumpAndSettle();
      await t.enterText(field('GSTIN (15 characters)'), 'BAD');
      await t.tap(button('Next'));
      await t.pumpAndSettle();
      expect(find.text('Enter a valid 15-character GSTIN'), findsOneWidget);
      expect(e.repo.saved, hasLength(1));
      await t.enterText(field('GSTIN (15 characters)'), '27abcde1234f1z5');
      await t.enterText(find.widgetWithText(TextFormField, 'UPI ID (optional)'), 'ravi@okbank');
      await t.tap(button('Next'));
      await t.pumpAndSettle();
      expectSaved(e.repo.saved.last, 'tax', {'gstEnabled': true, 'gstin': '27ABCDE1234F1Z5', 'upiId': 'ravi@okbank', 'currency': 'INR', 'invoicePrefix': 'INV'});

      // Counter: pick a printer, keep the defaults
      expect(find.text('Step 3 of 4'), findsOneWidget);
      await t.tap(find.text('Thermal 58 mm'));
      await t.pumpAndSettle();
      await t.tap(button('Next'));
      await t.pumpAndSettle();
      expectSaved(e.repo.saved.last, 'counter', {'printerProfile': 'thermal-58mm', 'orderSeriesPrefix': 'LN', 'defaultDeliveryDays': 3});

      // Price list: the last step says "Finish setup"
      expect(find.text('Step 4 of 4'), findsOneWidget);
      expect(button('Next'), findsNothing);
      await t.tap(button('Finish setup'));
      await t.pumpAndSettle();
      expectSaved(e.repo.saved.last, 'pricelist', {'choice': 'starter'});
      expect(e.repo.completeCalls, 1);

      // Done screen, then straight into POS
      expect(find.text('Your shop is ready!'), findsOneWidget);
      expect(find.text('13 sample garments were added. Please check their prices.'), findsOneWidget);
      expect(e.mode.effective, AppMode.pos);
      await t.tap(button('Open POS'));
      await t.pumpAndSettle();
      expect(find.text('POS HOME SCREEN'), findsOneWidget);
    });

    testWidgets('"I will add my own" sends choice=own and no starter note is shown', (t) async {
      final repo = incomplete()
        ..onboarding = const PosOnboardingState(status: PosOnboardingStatus.inProgress, nextStep: 'pricelist')
        ..completeResult = PosCompleteResult(info: info(offering: 'POS', allowed: const ['POS']));
      await pumpPage(t, const PosOnboardingPage(), repo: repo);
      expect(find.text('Step 4 of 4'), findsOneWidget);
      await t.tap(find.text('I will add my own'));
      await t.pumpAndSettle();
      await t.tap(button('Finish setup'));
      await t.pumpAndSettle();
      expectSaved(repo.saved.last, 'pricelist', {'choice': 'own'});
      expect(find.text('Your shop is ready!'), findsOneWidget);
      expect(find.textContaining('sample garments'), findsNothing);
    });

    testWidgets('resumes at the first unfinished step with earlier answers filled in', (t) async {
      final repo = incomplete()
        ..onboarding = PosOnboardingState.fromJson({
          'status': 'IN_PROGRESS',
          'nextStep': 'counter',
          'data': {
            'shop': {'name': 'Sparkle Laundry', 'ownerName': 'Ravi', 'addressLine1': '12 MG Road', 'city': 'Pune'},
            'tax': {'gstEnabled': false, 'invoicePrefix': 'SPK'},
          },
        });
      await pumpPage(t, const PosOnboardingPage(), repo: repo);
      expect(find.text('Step 3 of 4'), findsOneWidget);
      expect(find.text('Counter setup'), findsOneWidget);
      // going back shows what was typed before
      await t.tap(find.byTooltip('Back'));
      await t.pumpAndSettle();
      expect(find.text('Step 2 of 4'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'SPK'), findsOneWidget);
      await t.tap(find.byTooltip('Back'));
      await t.pumpAndSettle();
      expect(find.widgetWithText(TextFormField, 'Sparkle Laundry'), findsOneWidget);
      expect(find.byTooltip('Back'), findsNothing, reason: 'nothing before step 1');
    });

    testWidgets('an existing shop\'s real name IS pre-filled (marketplace owner adding POS)', (t) async {
      await pumpPage(t, const PosOnboardingPage(), repo: incomplete(shop: 'Asha Laundry'));
      expect(find.widgetWithText(TextFormField, 'Asha Laundry'), findsOneWidget);
    });

    testWidgets('a placeholder shop name ("My Shop") is not pre-filled', (t) async {
      await pumpPage(t, const PosOnboardingPage(), repo: incomplete());
      expect(find.widgetWithText(TextFormField, 'My Shop'), findsNothing);
    });

    testWidgets('a save failure keeps the owner on the step with a plain message; fixing it and retrying works', (t) async {
      final repo = incomplete()
        ..saveError = const ApiException(message: 'Enter your shop address.', statusCode: 400);
      await pumpPage(t, const PosOnboardingPage(), repo: repo);
      await fillShop(t);
      await t.tap(button('Next'));
      await t.pumpAndSettle();
      expect(find.text('Step 1 of 4'), findsOneWidget);
      expect(find.text('Enter your shop address.'), findsOneWidget);
      repo.saveError = null;
      await t.tap(button('Next'));
      await t.pumpAndSettle();
      expect(find.text('Step 2 of 4'), findsOneWidget);
      expect(find.text('Enter your shop address.'), findsNothing);
    });

    testWidgets('a failed load shows a plain error with Retry; Retry opens the form', (t) async {
      final repo = incomplete()..onboardingError = const ApiException(message: 'Timed out', statusCode: null, code: 'TIMEOUT');
      await pumpPage(t, const PosOnboardingPage(), repo: repo);
      expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
      expect(find.byType(TextFormField), findsNothing);
      repo.onboardingError = null;
      await t.tap(find.text('Retry'));
      await t.pumpAndSettle();
      expect(find.text('Step 1 of 4'), findsOneWidget);
      expect(find.byType(TextFormField), findsWidgets);
    });

    testWidgets('only the owner can set POS up: staff get a plain explanation and no form', (t) async {
      await pumpPage(t, const PosOnboardingPage(), who: Who.staff);
      expect(find.text('Ask the shop owner'), findsOneWidget);
      expect(find.text('POS setup must be finished by the shop owner.'), findsOneWidget);
      expect(find.byType(TextFormField), findsNothing);
    });

    testWidgets('every step is usable in Hindi', (t) async {
      await pumpPage(t, const PosOnboardingPage(), locale: const Locale('hi'), repo: incomplete());
      expect(find.text('दुकान की जानकारी'), findsOneWidget);
      expect(find.text('आगे'), findsOneWidget);
      await t.tap(find.text('आगे'));
      await t.pumpAndSettle();
      expect(find.text('अपनी दुकान का नाम लिखें'), findsOneWidget);
    });
  });

  group('Settings: App mode section', () {
    testWidgets('staff of a marketplace-only shop see nothing', (t) async {
      final repo = FakeAppModeRepo(mode: info(offering: 'MARKETPLACE', status: 'NOT_STARTED', allowed: const ['MARKETPLACE'], role: 'VENDOR_STAFF', canStart: true));
      await pumpPage(t, const Scaffold(body: ModeSwitchSection()), repo: repo);
      expect(find.text('App mode'), findsNothing);
      expect(find.text('Get POS for my shop'), findsNothing, reason: 'only the owner can add POS');
    });

    testWidgets('staff of a BOTH shop can switch mode but never start or finish POS setup', (t) async {
      final repo = FakeAppModeRepo(mode: info(role: 'VENDOR_STAFF', status: 'IN_PROGRESS', allowed: const ['MARKETPLACE', 'POS'], needsOnboarding: true));
      await pumpPage(t, const Scaffold(body: ModeSwitchSection()), repo: repo);
      expect(find.byType(SegmentedButton<AppMode>), findsOneWidget);
      expect(find.text('Finish POS setup'), findsNothing);
      expect(find.text('Get POS for my shop'), findsNothing);
    });

    testWidgets('renders nothing for a marketplace-only vendor when the lookup failed (old backend)', (t) async {
      final repo = FakeAppModeRepo()..getError = Exception('404');
      await pumpPage(t, const Scaffold(body: ModeSwitchSection()), repo: repo);
      expect(find.text('App mode'), findsNothing);
    });

    testWidgets('a marketplace owner is offered "Get POS for my shop", which starts setup and opens it', (t) async {
      final repo = FakeAppModeRepo(mode: info(offering: 'MARKETPLACE', status: 'NOT_STARTED', allowed: const ['MARKETPLACE'], canStart: true));
      final e = await pumpPage(t, const Scaffold(body: ModeSwitchSection()), repo: repo);
      expect(find.text('Get POS for my shop'), findsOneWidget);
      expect(find.byType(SegmentedButton<AppMode>), findsNothing, reason: 'nothing to switch to yet');
      repo.mode = info(status: 'IN_PROGRESS', allowed: const ['MARKETPLACE'], needsOnboarding: true);
      await t.tap(find.text('Get POS for my shop'));
      await t.pumpAndSettle();
      expect(e.repo.startCalls, 1);
      expect(find.text('ONBOARDING SCREEN'), findsOneWidget);
    });

    testWidgets('the Get-POS tile is its own screen-reader target (not merged into the card)', (t) async {
      final repo = FakeAppModeRepo(mode: info(offering: 'MARKETPLACE', status: 'NOT_STARTED', allowed: const ['MARKETPLACE'], canStart: true));
      final handle = t.ensureSemantics();
      await pumpPage(t, const Scaffold(body: ModeSwitchSection()), repo: repo);
      final node = t.getSemantics(find.widgetWithText(ListTile, 'Get POS for my shop'));
      expect(node.label, startsWith('Get POS for my shop'));
      expect(node.label, isNot(contains('App mode')), reason: 'the card title must not be merged into the tile');
      expect(node.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
      handle.dispose();
    });

    testWidgets('a BOTH vendor gets a switch; choosing POS changes the effective mode and says so', (t) async {
      final e = await pumpPage(t, const Scaffold(body: ModeSwitchSection()));
      expect(find.byType(SegmentedButton<AppMode>), findsOneWidget);
      expect(find.text('Marketplace'), findsOneWidget);
      expect(find.text('POS (Counter)'), findsOneWidget);
      expect(e.mode.effective, AppMode.marketplace);
      await t.tap(find.text('POS (Counter)'));
      await t.pumpAndSettle();
      expect(e.mode.effective, AppMode.pos);
      expect(find.text('Switched to POS (Counter)'), findsOneWidget);
      expect(e.storage.getString(appModePrefKey('v1')), 'POS');
    });

    testWidgets('a half-finished POS setup shows "Finish POS setup" (marketplace stays usable)', (t) async {
      final repo = FakeAppModeRepo(mode: info(status: 'IN_PROGRESS', allowed: const ['MARKETPLACE'], needsOnboarding: true));
      await pumpPage(t, const Scaffold(body: ModeSwitchSection()), repo: repo);
      expect(find.text('Finish POS setup'), findsOneWidget);
      expect(find.byType(SegmentedButton<AppMode>), findsNothing);
      await t.tap(find.text('Finish POS setup'));
      await t.pumpAndSettle();
      expect(find.text('ONBOARDING SCREEN'), findsOneWidget);
    });
  });

  group('POS shell', () {
    testWidgets('six tabs, every icon has a word, and switching tabs works', (t) async {
      final router = GoRouter(
        initialLocation: AppRoutes.posHome,
        routes: [
          StatefulShellRoute.indexedStack(
            builder: (_, __, shell) => PosShell(navigationShell: shell),
            branches: [
              for (final p in [AppRoutes.posHome, AppRoutes.posOrders, AppRoutes.posSearch, AppRoutes.posExpense, AppRoutes.posReport, AppRoutes.posSettings])
                StatefulShellBranch(routes: [
                  GoRoute(path: p, builder: (c, __) => PosPlaceholderPage(title: 'page:$p', icon: Icons.circle)),
                ]),
            ],
          ),
        ],
      );
      t.view.physicalSize = const Size(780, 1688);
      t.view.devicePixelRatio = 2;
      addTearDown(t.view.reset);
      await t.pumpWidget(MaterialApp.router(
        localizationsDelegates: const [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ));
      await t.pumpAndSettle();
      for (final label in ['Home', 'Order', 'Search', 'Expense', 'Report', 'Setting']) {
        expect(find.descendant(of: find.byType(NavigationBar), matching: find.text(label)), findsOneWidget, reason: label);
      }
      expect(find.text('page:${AppRoutes.posHome}'), findsOneWidget);
      await t.tap(find.descendant(of: find.byType(NavigationBar), matching: find.text('Expense')));
      await t.pumpAndSettle();
      expect(find.text('page:${AppRoutes.posExpense}'), findsOneWidget);
      expect(find.text('Coming soon'), findsOneWidget);
    });
  });
}
