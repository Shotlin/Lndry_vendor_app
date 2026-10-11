import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lndry_vendor_app/core/router/app_routes.dart';
import 'package:lndry_vendor_app/core/router/vendor_router.dart';
import 'package:lndry_vendor_app/models/models.dart';
import 'package:lndry_vendor_app/models/pos/app_mode_model.dart';
import 'package:lndry_vendor_app/providers/app_mode_provider.dart';
import 'package:lndry_vendor_app/providers/auth_provider.dart';

/// The app's REAL redirect function (auth + staff access + mode rules together) run against
/// placeholder screens. This is the "does the right person land on the right UI" matrix.

AppModeState _mode(VendorOffering o, PosOnboardingStatus s, {AppMode? selected, bool needsOnboarding = false}) {
  final allowed = switch (o) {
    VendorOffering.marketplace => [AppMode.marketplace],
    VendorOffering.pos => s == PosOnboardingStatus.completed ? [AppMode.pos] : <AppMode>[],
    VendorOffering.both => s == PosOnboardingStatus.completed ? [AppMode.marketplace, AppMode.pos] : [AppMode.marketplace],
  };
  return AppModeState(
    status: AppModeStatus.ready,
    selected: selected,
    info: AppModeInfo(hasVendor: true, vendorId: 'v1', role: 'VENDOR_OWNER', offering: o, posOnboardingStatus: s, allowedModes: allowed, needsPosOnboarding: needsOnboarding),
  );
}

const _owner = AuthAuthenticated(VendorModel(
  id: 'v1',
  name: 'Shop',
  description: '',
  ownerName: 'Owner',
  phone: '9999999999',
  address: AddressModel(id: 'a', userId: 'u', line1: 'x', city: 'c', state: 's', pincode: '400001', type: AddressType.home),
), shopRole: 'VENDOR_OWNER');

const _rider = AuthAuthenticated(VendorModel(
  id: 'v1',
  name: 'Shop',
  description: '',
  ownerName: 'Owner',
  phone: '9999999999',
  address: AddressModel(id: 'a', userId: 'u', line1: 'x', city: 'c', state: 's', pincode: '400001', type: AddressType.home),
), shopRole: 'VENDOR_RIDER');

Future<String> _landing(
  WidgetTester tester, {
  required String start,
  required AuthState auth,
  AppModeState? mode,
}) async {
  final paths = <String>{
    AppRoutes.splash, AppRoutes.login, AppRoutes.otp, AppRoutes.profileSetup, AppRoutes.chooseProduct, AppRoutes.modeCheck,
    AppRoutes.dashboard, AppRoutes.orders, AppRoutes.services, AppRoutes.pricing, AppRoutes.employees, AppRoutes.analytics,
    AppRoutes.profile, AppRoutes.riderJobs,
    AppRoutes.posOnboarding, AppRoutes.posHome, AppRoutes.posOrders, AppRoutes.posSearch, AppRoutes.posExpense, AppRoutes.posReport, AppRoutes.posSettings,
  };
  final router = GoRouter(
    initialLocation: start,
    redirect: (context, state) => vendorRedirectForTest(context, state, auth, MyAccess.owner, appMode: mode),
    routes: [for (final p in paths) GoRoute(path: p, builder: (_, __) => Text('screen:$p'))],
  );
  await tester.pumpWidget(MaterialApp.router(routerConfig: router));
  await tester.pumpAndSettle();
  return router.routeInformationProvider.value.uri.path;
}

void main() {
  const done = PosOnboardingStatus.completed;

  group('POS rules OFF (appMode == null): behaviour is byte-for-byte what it was before POS mode', () {
    testWidgets('owner on /orders stays; login goes to dashboard', (t) async {
      expect(await _landing(t, start: AppRoutes.orders, auth: _owner), AppRoutes.orders);
      expect(await _landing(t, start: AppRoutes.login, auth: _owner), AppRoutes.dashboard);
    });
    testWidgets('new user goes to the application wizard, not the choice screen', (t) async {
      expect(await _landing(t, start: AppRoutes.dashboard, auth: const AuthNeedsVendorApplication('9999999999')), AppRoutes.profileSetup);
    });
  });

  group('marketplace vendor', () {
    final m = _mode(VendorOffering.marketplace, PosOnboardingStatus.notStarted);
    testWidgets('keeps every marketplace screen', (t) async {
      for (final p in [AppRoutes.dashboard, AppRoutes.orders, AppRoutes.services, AppRoutes.pricing, AppRoutes.analytics]) {
        expect(await _landing(t, start: p, auth: _owner, mode: m), p, reason: p);
      }
    });
    testWidgets('cannot open POS by typing a /pos path', (t) async {
      expect(await _landing(t, start: AppRoutes.posHome, auth: _owner, mode: m), AppRoutes.dashboard);
      expect(await _landing(t, start: AppRoutes.posSettings, auth: _owner, mode: m), AppRoutes.dashboard);
    });
  });

  group('POS-only vendor', () {
    testWidgets('finished setup: lands in POS and cannot reach marketplace screens', (t) async {
      final m = _mode(VendorOffering.pos, done);
      expect(await _landing(t, start: AppRoutes.dashboard, auth: _owner, mode: m), AppRoutes.posHome);
      expect(await _landing(t, start: AppRoutes.orders, auth: _owner, mode: m), AppRoutes.posHome);
      expect(await _landing(t, start: AppRoutes.login, auth: _owner, mode: m), AppRoutes.posHome);
      expect(await _landing(t, start: AppRoutes.posReport, auth: _owner, mode: m), AppRoutes.posReport);
    });
    testWidgets('unfinished setup: everything leads to onboarding', (t) async {
      final m = _mode(VendorOffering.pos, PosOnboardingStatus.inProgress);
      expect(await _landing(t, start: AppRoutes.dashboard, auth: _owner, mode: m), AppRoutes.posOnboarding);
      expect(await _landing(t, start: AppRoutes.posHome, auth: _owner, mode: m), AppRoutes.posOnboarding);
    });
  });

  group('BOTH vendor', () {
    testWidgets('switching modes moves between the two UIs', (t) async {
      expect(await _landing(t, start: AppRoutes.login, auth: _owner, mode: _mode(VendorOffering.both, done)), AppRoutes.dashboard);
      final pos = _mode(VendorOffering.both, done, selected: AppMode.pos);
      expect(await _landing(t, start: AppRoutes.login, auth: _owner, mode: pos), AppRoutes.posHome);
      expect(await _landing(t, start: AppRoutes.orders, auth: _owner, mode: pos), AppRoutes.posHome);
      final mkt = _mode(VendorOffering.both, done, selected: AppMode.marketplace);
      expect(await _landing(t, start: AppRoutes.posHome, auth: _owner, mode: mkt), AppRoutes.dashboard);
    });
    testWidgets('finishing POS setup started from Settings is reachable while marketplace stays usable', (t) async {
      final m = _mode(VendorOffering.both, PosOnboardingStatus.inProgress, needsOnboarding: true);
      expect(await _landing(t, start: AppRoutes.posOnboarding, auth: _owner, mode: m), AppRoutes.posOnboarding);
      expect(await _landing(t, start: AppRoutes.orders, auth: _owner, mode: m), AppRoutes.orders);
    });
  });

  group('waiting for the backend', () {
    testWidgets('signed-in users wait on /mode-check until modes are known', (t) async {
      expect(await _landing(t, start: AppRoutes.dashboard, auth: _owner, mode: const AppModeState(status: AppModeStatus.loading)), AppRoutes.modeCheck);
    });
    testWidgets('a failed lookup falls back to marketplace — never stuck, never POS', (t) async {
      const failed = AppModeState(status: AppModeStatus.failed);
      expect(await _landing(t, start: AppRoutes.modeCheck, auth: _owner, mode: failed), AppRoutes.dashboard);
      expect(await _landing(t, start: AppRoutes.posHome, auth: _owner, mode: failed), AppRoutes.dashboard);
    });
  });

  group('captains are never affected by modes', () {
    testWidgets('a captain stays on captain jobs whatever the mode says', (t) async {
      for (final m in [null, _mode(VendorOffering.pos, done), const AppModeState(status: AppModeStatus.loading)]) {
        expect(await _landing(t, start: AppRoutes.dashboard, auth: _rider, mode: m), AppRoutes.riderJobs);
        expect(await _landing(t, start: AppRoutes.posHome, auth: _rider, mode: m), AppRoutes.riderJobs);
      }
    });
  });

  group('signed out', () {
    testWidgets('POS, choice and mode-check pages need a login', (t) async {
      for (final p in [AppRoutes.posHome, AppRoutes.posOnboarding, AppRoutes.posSettings, AppRoutes.chooseProduct, AppRoutes.modeCheck]) {
        final landing = await _landing(t, start: p, auth: const AuthUnauthenticated(), mode: const AppModeState());
        expect(landing, AppRoutes.login, reason: p);
      }
    });
  });

  group('new user (no shop yet)', () {
    const newUser = AuthNeedsVendorApplication('9999999999');
    testWidgets('sees the Marketplace-or-POS choice first', (t) async {
      const m = AppModeState(status: AppModeStatus.ready);
      expect(await _landing(t, start: AppRoutes.dashboard, auth: newUser, mode: m), AppRoutes.chooseProduct);
      expect(await _landing(t, start: AppRoutes.profileSetup, auth: newUser, mode: m), AppRoutes.chooseProduct);
      expect(await _landing(t, start: AppRoutes.chooseProduct, auth: newUser, mode: m), AppRoutes.chooseProduct);
    });
    testWidgets('after choosing Marketplace the application wizard opens and stays', (t) async {
      const m = AppModeState(status: AppModeStatus.ready, marketplaceChosen: true);
      expect(await _landing(t, start: AppRoutes.chooseProduct, auth: newUser, mode: m), AppRoutes.profileSetup);
      expect(await _landing(t, start: AppRoutes.profileSetup, auth: newUser, mode: m), AppRoutes.profileSetup);
    });
  });
}
