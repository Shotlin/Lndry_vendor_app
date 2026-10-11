import '../../models/pos/app_mode_model.dart';

/// Which modes a vendor may use + POS onboarding. Backed by `/vendor/app-mode` and
/// `/vendor/pos-onboarding/*` (see Lndry_backend `docs/vendor-app-mode.md`).
abstract class AppModeRepository {
  Future<AppModeInfo> getAppMode();
  Future<PosStartResult> startPosOnboarding();
  Future<PosOnboardingState> getPosOnboarding();

  /// Saves one wizard step; [step] is `shop`, `tax`, `counter` or `pricelist`.
  Future<PosOnboardingState> savePosOnboardingStep(String step, Map<String, dynamic> data);
  Future<PosCompleteResult> completePosOnboarding();
}
