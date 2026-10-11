import '../../models/pos/app_mode_model.dart';
import '../../providers/app_mode_provider.dart';
import 'app_routes.dart';

/// Outcome of the mode rules for one navigation.
///  * [handled] false → the mode rules have nothing to say; the normal rules continue.
///  * [handled] true, [to] null → stay on the current page.
///  * [handled] true, [to] set → go there.
typedef ModeDecision = ({bool handled, String? to});

const ModeDecision _unhandled = (handled: false, to: null);
const ModeDecision _stay = (handled: true, to: null);
ModeDecision _go(String to) => (handled: true, to: to);

bool isPosPath(String path) => path == '/pos' || path.startsWith('/pos/');

/// Which screen set a signed-in (non-captain) user may be on, given their modes.
/// Pure function of its inputs so the whole matrix can be unit-tested.
///
/// [safeReturnTo] is an already-validated in-app location (or null) to resume after login.
ModeDecision modeRedirect({
  required String path,
  required AppModeState mode,
  String? safeReturnTo,
}) {
  // The splash screen decides for itself when to leave.
  if (path == AppRoutes.splash) return _unhandled;

  // Wait for the backend's answer before choosing a UI, so the wrong one never flashes.
  if (!mode.resolved) {
    return path == AppRoutes.modeCheck ? _stay : _go(AppRoutes.modeCheck);
  }

  // A POS-only shop that has not finished POS setup has nowhere else to go.
  if (mode.mustFinishPosOnboarding) {
    return path == AppRoutes.posOnboarding ? _stay : _go(AppRoutes.posOnboarding);
  }

  final effective = mode.effective;
  final home = effective == AppMode.pos ? AppRoutes.posHome : AppRoutes.dashboard;

  // Pages that only make sense before a mode is settled.
  final isEntryPage = path == AppRoutes.login ||
      path == AppRoutes.otp ||
      path == AppRoutes.modeCheck ||
      path == AppRoutes.chooseProduct ||
      path == AppRoutes.profileSetup;
  if (isEntryPage) {
    return _go(effective == AppMode.pos ? home : (safeReturnTo ?? home));
  }

  if (effective == AppMode.pos) {
    return isPosPath(path) ? _unhandled : _go(AppRoutes.posHome);
  }

  // Marketplace is showing: POS screens are off limits, except finishing a POS setup the
  // owner started from Settings ("Get POS" / "Finish POS setup").
  if (isPosPath(path)) {
    final finishing = path == AppRoutes.posOnboarding && (mode.info?.needsPosOnboarding ?? false);
    return finishing ? _stay : _go(AppRoutes.dashboard);
  }
  return _unhandled;
}

/// Rule for a user who has no shop yet ([AuthNeedsVendorApplication]).
ModeDecision newUserRedirect({required String path, required AppModeState mode}) {
  if (mode.marketplaceChosen) {
    return path == AppRoutes.profileSetup ? _stay : _go(AppRoutes.profileSetup);
  }
  return path == AppRoutes.chooseProduct ? _stay : _go(AppRoutes.chooseProduct);
}
