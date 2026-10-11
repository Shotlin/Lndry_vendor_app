import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/repositories/api_app_mode_repository.dart';
import '../core/services/storage_service.dart';
import '../models/pos/app_mode_model.dart';
import '../repositories/abstract/app_mode_repository.dart';
import 'auth_provider.dart';

enum AppModeStatus { idle, loading, ready, failed }

/// What the app knows about modes right now.
///
/// * [info] comes from the backend and says which modes are ALLOWED for this vendor.
/// * [selected] is the mode this person last chose ON THIS DEVICE; it is only honoured
///   while it is still allowed (an admin can take POS away at any time).
/// * A failed or old backend (no `/vendor/app-mode`) means [AppModeStatus.failed] and the app
///   behaves exactly as it did before POS mode existed: marketplace.
class AppModeState {
  const AppModeState({
    this.status = AppModeStatus.idle,
    this.info,
    this.selected,
    this.marketplaceChosen = false,
    this.errorMessage,
  });

  final AppModeStatus status;
  final AppModeInfo? info;
  final AppMode? selected;

  /// A brand-new user (no vendor yet) already picked "Marketplace" and may fill the
  /// application wizard instead of seeing the choice screen again.
  final bool marketplaceChosen;
  final String? errorMessage;

  bool get resolved => status == AppModeStatus.ready || status == AppModeStatus.failed;

  List<AppMode> get allowed => info?.allowedModes ?? const [AppMode.marketplace];

  /// POS-only shop whose POS setup is not finished: it has no usable mode yet.
  bool get mustFinishPosOnboarding {
    final i = info;
    return i != null && i.hasVendor && i.offering == VendorOffering.pos && i.posOnboardingStatus != PosOnboardingStatus.completed;
  }

  /// The mode whose screens are shown.
  AppMode get effective {
    final s = selected;
    if (s != null && allowed.contains(s)) return s;
    return allowed.isNotEmpty ? allowed.first : AppMode.marketplace;
  }

  bool get canSwitch => allowed.length > 1;

  AppModeState copyWith({
    AppModeStatus? status,
    AppModeInfo? info,
    AppMode? selected,
    bool clearSelected = false,
    bool? marketplaceChosen,
    String? errorMessage,
    bool clearError = false,
  }) =>
      AppModeState(
        status: status ?? this.status,
        info: info ?? this.info,
        selected: clearSelected ? null : (selected ?? this.selected),
        marketplaceChosen: marketplaceChosen ?? this.marketplaceChosen,
        errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      );
}

String appModePrefKey(String vendorId) => 'app_mode_v1:$vendorId';
const String kMarketplaceChoicePhoneKey = 'pos_choice_marketplace_phone';

class AppModeNotifier extends StateNotifier<AppModeState> {
  AppModeNotifier(this._ref, this._repo, this._storage) : super(const AppModeState());

  final Ref _ref;
  final AppModeRepository _repo;
  final StorageService _storage;
  bool _loading = false;

  /// Called whenever the sign-in state changes.
  void onAuthChanged(AuthState auth) {
    if (auth is AuthAuthenticated) {
      if (auth.shopRole == 'VENDOR_RIDER') {
        // Captains never see modes.
        state = const AppModeState(status: AppModeStatus.ready, info: AppModeInfo(hasVendor: true));
        return;
      }
      if (state.status == AppModeStatus.idle || state.status == AppModeStatus.failed) {
        load();
      }
    } else if (auth is AuthNeedsVendorApplication) {
      final chosen = _storage.getString(kMarketplaceChoicePhoneKey) == auth.phone && auth.phone.isNotEmpty;
      state = AppModeState(
        status: AppModeStatus.ready,
        info: const AppModeInfo(hasVendor: false, canStartPos: true, allowedModes: []),
        marketplaceChosen: chosen,
      );
    } else if (auth is AuthUnauthenticated || auth is AuthError) {
      state = const AppModeState();
    }
  }

  /// Reads the vendor's modes from the backend. Keeps what it already knows if the request fails,
  /// so a bad signal never takes a mode away; with nothing known it falls back to marketplace.
  Future<void> load() async {
    if (_loading) return;
    _loading = true;
    if (state.info == null) state = state.copyWith(status: AppModeStatus.loading, clearError: true);
    try {
      final info = await _repo.getAppMode();
      if (!mounted) return;
      final saved = info.vendorId == null ? null : AppMode.parse(_storage.getString(appModePrefKey(info.vendorId!)));
      state = AppModeState(
        status: AppModeStatus.ready,
        info: info,
        selected: saved,
        marketplaceChosen: state.marketplaceChosen,
      );
    } catch (e) {
      if (!mounted) return;
      state = state.info != null
          ? state.copyWith(status: AppModeStatus.ready)
          : state.copyWith(status: AppModeStatus.failed, errorMessage: e.toString());
    } finally {
      _loading = false;
    }
  }

  /// Switch the visible mode. Returns false (and changes nothing) if [mode] is not allowed.
  Future<bool> setMode(AppMode mode) async {
    if (!state.allowed.contains(mode)) return false;
    final vendorId = state.info?.vendorId;
    if (vendorId != null) await _storage.saveString(appModePrefKey(vendorId), mode.wire);
    state = state.copyWith(selected: mode);
    return true;
  }

  /// "Marketplace" on the first-run choice screen.
  Future<void> chooseMarketplaceApplication(String phone) async {
    await _storage.saveString(kMarketplaceChoicePhoneKey, phone);
    state = state.copyWith(marketplaceChosen: true);
  }

  /// "Run my shop (POS)" for a user with no shop yet: creates the POS shop, renews the login so it
  /// carries the new shop, then loads the modes.
  Future<void> startPosAsNewUser() async {
    final result = await _repo.startPosOnboarding();
    if (result.needsTokenRefresh) {
      await _ref.read(authProvider.notifier).adoptNewVendorSession();
    }
    state = state.copyWith(status: AppModeStatus.idle, clearSelected: true);
    await load();
  }

  /// "Get POS for my shop" for an existing marketplace owner.
  Future<void> startPosAsExistingVendor() async {
    await _repo.startPosOnboarding();
    await load();
  }

  /// After the wizard finishes: POS is now allowed — open it.
  void adoptCompleted(AppModeInfo info) {
    final vendorId = info.vendorId;
    state = AppModeState(status: AppModeStatus.ready, info: info, selected: AppMode.pos, marketplaceChosen: state.marketplaceChosen);
    if (vendorId != null) _storage.saveString(appModePrefKey(vendorId), AppMode.pos.wire);
  }
}

final appModeProvider = StateNotifierProvider<AppModeNotifier, AppModeState>((ref) {
  final notifier = AppModeNotifier(ref, ref.watch(appModeRepositoryProvider), ref.watch(storageServiceProvider));
  ref.listen<AuthState>(authProvider, (_, next) => notifier.onAuthChanged(next), fireImmediately: true);
  return notifier;
});
