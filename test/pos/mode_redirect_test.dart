import 'package:flutter_test/flutter_test.dart';
import 'package:lndry_vendor_app/core/router/app_routes.dart';
import 'package:lndry_vendor_app/core/router/mode_redirect.dart';
import 'package:lndry_vendor_app/models/pos/app_mode_model.dart';
import 'package:lndry_vendor_app/providers/app_mode_provider.dart';

AppModeState ready(
  VendorOffering offering,
  PosOnboardingStatus status, {
  AppMode? selected,
  String role = 'VENDOR_OWNER',
  bool needsOnboarding = false,
}) {
  final allowed = switch (offering) {
    VendorOffering.marketplace => [AppMode.marketplace],
    VendorOffering.pos => status == PosOnboardingStatus.completed ? [AppMode.pos] : <AppMode>[],
    VendorOffering.both => status == PosOnboardingStatus.completed ? [AppMode.marketplace, AppMode.pos] : [AppMode.marketplace],
  };
  return AppModeState(
    status: AppModeStatus.ready,
    selected: selected,
    info: AppModeInfo(
      hasVendor: true,
      vendorId: 'v1',
      role: role,
      offering: offering,
      posOnboardingStatus: status,
      allowedModes: allowed,
      needsPosOnboarding: needsOnboarding,
      canStartPos: offering == VendorOffering.marketplace,
    ),
  );
}

String? go(String path, AppModeState m, {String? returnTo}) => modeRedirect(path: path, mode: m, safeReturnTo: returnTo).to;
bool handled(String path, AppModeState m) => modeRedirect(path: path, mode: m).handled;

void main() {
  const done = PosOnboardingStatus.completed;
  const started = PosOnboardingStatus.inProgress;

  group('while the answer is unknown', () {
    for (final status in [AppModeStatus.idle, AppModeStatus.loading]) {
      final m = AppModeState(status: status);
      test('$status: everything waits on /mode-check, so the wrong UI never flashes', () {
        for (final p in [AppRoutes.dashboard, AppRoutes.orders, AppRoutes.posHome, AppRoutes.login, '/orders/details/9']) {
          expect(go(p, m), AppRoutes.modeCheck, reason: p);
        }
        expect(modeRedirect(path: AppRoutes.modeCheck, mode: m), (handled: true, to: null)); // stay
      });
    }
    test('the splash screen is never redirected', () {
      expect(handled(AppRoutes.splash, const AppModeState()), isFalse);
      expect(handled(AppRoutes.splash, ready(VendorOffering.pos, done)), isFalse);
    });
  });

  group('backend unreachable or too old (failed) behaves exactly like before POS mode existed', () {
    const failed = AppModeState(status: AppModeStatus.failed);
    test('marketplace screens are untouched', () {
      expect(failed.effective, AppMode.marketplace);
      for (final p in [AppRoutes.dashboard, AppRoutes.orders, AppRoutes.pricing, AppRoutes.employees, '/orders/details/1']) {
        expect(handled(p, failed), isFalse, reason: p);
      }
    });
    test('POS screens are off limits', () {
      expect(go(AppRoutes.posHome, failed), AppRoutes.dashboard);
      expect(go(AppRoutes.posOnboarding, failed), AppRoutes.dashboard);
    });
    test('entry pages lead to the dashboard (or the saved returnTo)', () {
      expect(go(AppRoutes.login, failed), AppRoutes.dashboard);
      expect(go(AppRoutes.modeCheck, failed, returnTo: '/orders'), '/orders');
    });
  });

  group('MARKETPLACE vendor', () {
    final m = ready(VendorOffering.marketplace, PosOnboardingStatus.notStarted);
    test('marketplace is untouched; POS paths bounce to the dashboard', () {
      expect(handled(AppRoutes.dashboard, m), isFalse);
      expect(handled(AppRoutes.orders, m), isFalse);
      expect(go(AppRoutes.posHome, m), AppRoutes.dashboard);
      expect(go(AppRoutes.posSettings, m), AppRoutes.dashboard);
      expect(go('/pos/anything/deep', m), AppRoutes.dashboard);
    });
    test('even a saved "pos" choice cannot unlock POS that is not allowed', () {
      final sneaky = ready(VendorOffering.marketplace, PosOnboardingStatus.notStarted, selected: AppMode.pos);
      expect(sneaky.effective, AppMode.marketplace);
      expect(go(AppRoutes.posHome, sneaky), AppRoutes.dashboard);
    });
    test('login / mode-check / choose-product / profile-setup all lead to the dashboard', () {
      for (final p in [AppRoutes.login, AppRoutes.otp, AppRoutes.modeCheck, AppRoutes.chooseProduct, AppRoutes.profileSetup]) {
        expect(go(p, m), AppRoutes.dashboard, reason: p);
      }
      expect(go(AppRoutes.login, m, returnTo: '/orders'), '/orders');
    });
    test('a path that merely starts with "/pos" is not a POS path', () {
      expect(isPosPath('/posted'), isFalse);
      expect(isPosPath('/pos'), isTrue);
      expect(isPosPath('/pos/home'), isTrue);
      expect(handled('/posted', m), isFalse);
    });
  });

  group('POS-only vendor', () {
    test('setup unfinished: every route leads to onboarding, onboarding itself stays', () {
      for (final status in [PosOnboardingStatus.notStarted, started]) {
        final m = ready(VendorOffering.pos, status);
        expect(m.mustFinishPosOnboarding, isTrue);
        for (final p in [AppRoutes.dashboard, AppRoutes.posHome, AppRoutes.login, AppRoutes.orders]) {
          expect(go(p, m), AppRoutes.posOnboarding, reason: p);
        }
        expect(modeRedirect(path: AppRoutes.posOnboarding, mode: m), (handled: true, to: null));
      }
    });
    test('setup complete: marketplace paths go to POS Home; POS paths are left alone', () {
      final m = ready(VendorOffering.pos, done);
      expect(m.mustFinishPosOnboarding, isFalse);
      expect(m.effective, AppMode.pos);
      for (final p in [AppRoutes.dashboard, AppRoutes.orders, AppRoutes.services, AppRoutes.profile, '/profile/settings', '/orders/details/3', AppRoutes.employees]) {
        expect(go(p, m), AppRoutes.posHome, reason: p);
      }
      for (final p in [AppRoutes.posHome, AppRoutes.posOrders, AppRoutes.posSettings]) {
        expect(handled(p, m), isFalse, reason: p);
      }
    });
    test('login lands on POS Home and ignores a marketplace returnTo', () {
      final m = ready(VendorOffering.pos, done);
      expect(go(AppRoutes.login, m, returnTo: '/orders'), AppRoutes.posHome);
      expect(go(AppRoutes.modeCheck, m), AppRoutes.posHome);
    });
  });

  group('BOTH vendor', () {
    test('defaults to marketplace until the user picks POS', () {
      final m = ready(VendorOffering.both, done);
      expect(m.effective, AppMode.marketplace);
      expect(m.canSwitch, isTrue);
      expect(go(AppRoutes.login, m), AppRoutes.dashboard);
      expect(go(AppRoutes.posHome, m), AppRoutes.dashboard);
    });
    test('after picking POS the POS UI is shown, and back to marketplace works', () {
      final pos = ready(VendorOffering.both, done, selected: AppMode.pos);
      expect(pos.effective, AppMode.pos);
      expect(go(AppRoutes.dashboard, pos), AppRoutes.posHome);
      expect(handled(AppRoutes.posOrders, pos), isFalse);
      final mkt = ready(VendorOffering.both, done, selected: AppMode.marketplace);
      expect(go(AppRoutes.posHome, mkt), AppRoutes.dashboard);
      expect(handled(AppRoutes.orders, mkt), isFalse);
    });
    test('POS taken away by an admin: a saved "pos" choice is ignored', () {
      final m = ready(VendorOffering.both, started, selected: AppMode.pos);
      expect(m.allowed, [AppMode.marketplace]);
      expect(m.effective, AppMode.marketplace);
      expect(go(AppRoutes.posHome, m), AppRoutes.dashboard);
    });
    test('POS setup started from Settings: marketplace stays, but /pos/onboarding is allowed', () {
      final m = ready(VendorOffering.both, started, needsOnboarding: true);
      expect(m.mustFinishPosOnboarding, isFalse); // not POS-only: marketplace still works
      expect(handled(AppRoutes.dashboard, m), isFalse);
      expect(modeRedirect(path: AppRoutes.posOnboarding, mode: m), (handled: true, to: null));
      expect(go(AppRoutes.posHome, m), AppRoutes.dashboard);
    });
    test('/pos/onboarding is NOT reachable when no POS setup is pending', () {
      final m = ready(VendorOffering.both, done);
      expect(go(AppRoutes.posOnboarding, m), AppRoutes.dashboard);
    });
  });

  group('new user (no shop yet)', () {
    const choiceMade = AppModeState(status: AppModeStatus.ready, marketplaceChosen: true);
    const noChoice = AppModeState(status: AppModeStatus.ready);
    test('must pick Marketplace or POS first', () {
      expect(newUserRedirect(path: AppRoutes.profileSetup, mode: noChoice).to, AppRoutes.chooseProduct);
      expect(newUserRedirect(path: AppRoutes.dashboard, mode: noChoice).to, AppRoutes.chooseProduct);
      expect(newUserRedirect(path: AppRoutes.chooseProduct, mode: noChoice), (handled: true, to: null));
    });
    test('after choosing Marketplace the application wizard opens', () {
      expect(newUserRedirect(path: AppRoutes.chooseProduct, mode: choiceMade).to, AppRoutes.profileSetup);
      expect(newUserRedirect(path: AppRoutes.dashboard, mode: choiceMade).to, AppRoutes.profileSetup);
      expect(newUserRedirect(path: AppRoutes.profileSetup, mode: choiceMade), (handled: true, to: null));
    });
  });

  group('effective-mode selection', () {
    test('POS-only with a stale "marketplace" saved choice shows POS', () {
      expect(ready(VendorOffering.pos, done, selected: AppMode.marketplace).effective, AppMode.pos);
    });
    test('no info yet: allowed falls back to marketplace', () {
      const m = AppModeState();
      expect(m.allowed, [AppMode.marketplace]);
      expect(m.effective, AppMode.marketplace);
      expect(m.canSwitch, isFalse);
      expect(m.mustFinishPosOnboarding, isFalse);
    });
  });

  group('Book Order screen (/pos/book) follows the same rules as every POS page', () {
    test('POS mode: allowed as it is', () {
      final m = ready(VendorOffering.pos, done);
      expect(handled(AppRoutes.posBook, m), isFalse);
      final both = ready(VendorOffering.both, done, selected: AppMode.pos);
      expect(handled(AppRoutes.posBook, both), isFalse);
    });
    test('Marketplace mode: sent back to the marketplace home', () {
      expect(go(AppRoutes.posBook, ready(VendorOffering.marketplace, PosOnboardingStatus.notStarted)), AppRoutes.dashboard);
      expect(go(AppRoutes.posBook, ready(VendorOffering.both, done, selected: AppMode.marketplace)), AppRoutes.dashboard);
    });
    test('a POS shop that has not finished setup cannot book', () {
      expect(go(AppRoutes.posBook, ready(VendorOffering.pos, started, needsOnboarding: true)), AppRoutes.posOnboarding);
    });
    test('is a POS path', () => expect(isPosPath(AppRoutes.posBook), isTrue));
  });
}
