/// Which LNDRY products a vendor may use in the Vendor App (backend `vendors.offering`).
/// A different thing from the vendor *type* (Standard / Partner / Exclusive).
enum VendorOffering {
  marketplace('MARKETPLACE'),
  pos('POS'),
  both('BOTH');

  const VendorOffering(this.wire);
  final String wire;

  static VendorOffering? parse(Object? value) {
    final v = value?.toString().toUpperCase();
    for (final o in VendorOffering.values) {
      if (o.wire == v) return o;
    }
    return null;
  }
}

enum PosOnboardingStatus {
  notStarted('NOT_STARTED'),
  inProgress('IN_PROGRESS'),
  completed('COMPLETED');

  const PosOnboardingStatus(this.wire);
  final String wire;

  static PosOnboardingStatus parse(Object? value) {
    final v = value?.toString().toUpperCase();
    for (final s in PosOnboardingStatus.values) {
      if (s.wire == v) return s;
    }
    return PosOnboardingStatus.notStarted;
  }
}

/// The two UIs of the app. The user picks one on this device (only among the allowed ones).
enum AppMode {
  marketplace('MARKETPLACE'),
  pos('POS');

  const AppMode(this.wire);
  final String wire;

  static AppMode? parse(Object? value) {
    final v = value?.toString().toUpperCase();
    for (final m in AppMode.values) {
      if (m.wire == v) return m;
    }
    return null;
  }
}

/// Answer of `GET /vendor/app-mode`.
class AppModeInfo {
  const AppModeInfo({
    required this.hasVendor,
    this.vendorId,
    this.shopName,
    this.role,
    this.offering,
    this.posOnboardingStatus = PosOnboardingStatus.notStarted,
    this.posPlanName,
    this.posValidTo,
    this.allowedModes = const [AppMode.marketplace],
    this.needsPosOnboarding = false,
    this.canStartPos = false,
    this.vendorType = 'STANDARD',
    this.appSync = false,
    this.walletAccess = false,
  });

  /// Defensive: a missing/odd field never throws — an unknown shape means "marketplace", the
  /// behaviour every existing vendor had before POS mode existed.
  factory AppModeInfo.fromJson(Map<String, dynamic> json) {
    final modes = <AppMode>[];
    final raw = json['allowedModes'];
    if (raw is List) {
      for (final m in raw) {
        final parsed = AppMode.parse(m);
        if (parsed != null && !modes.contains(parsed)) modes.add(parsed);
      }
    }
    DateTime? validTo;
    final validToRaw = json['posValidTo']?.toString();
    if (validToRaw != null && validToRaw.length >= 10) {
      final d = DateTime.tryParse(validToRaw.substring(0, 10));
      if (d != null) validTo = DateTime(d.year, d.month, d.day);
    }
    return AppModeInfo(
      hasVendor: json['hasVendor'] == true,
      vendorId: json['vendorId'] as String?,
      shopName: json['shopName'] as String?,
      role: json['role'] as String?,
      offering: VendorOffering.parse(json['offering']),
      posOnboardingStatus: PosOnboardingStatus.parse(json['posOnboardingStatus']),
      posPlanName: json['posPlanName'] as String?,
      posValidTo: validTo,
      allowedModes: modes,
      needsPosOnboarding: json['needsPosOnboarding'] == true,
      canStartPos: json['canStartPos'] == true,
      vendorType: (json['vendorType'] as String?) ?? 'STANDARD',
      appSync: json['appSync'] == true,
      walletAccess: json['walletAccess'] == true,
    );
  }

  final bool hasVendor;
  final String? vendorId;
  final String? shopName;
  final String? role;
  final VendorOffering? offering;
  final PosOnboardingStatus posOnboardingStatus;
  final String? posPlanName;

  /// Plan end date, date only (`YYYY-MM-DD` on the wire).
  final DateTime? posValidTo;

  /// POS is listed only after POS onboarding is complete.
  final List<AppMode> allowedModes;
  final bool needsPosOnboarding;
  final bool canStartPos;
  final String vendorType;
  final bool appSync;
  final bool walletAccess;

  bool get canSwitchMode => allowedModes.length > 1;
  bool get isOwner => role == 'VENDOR_OWNER';

}

/// Saved answers of the POS setup wizard (`GET /vendor/pos-onboarding`).
class PosOnboardingState {
  const PosOnboardingState({
    required this.status,
    this.data = const {},
    this.missingSteps = const [],
    this.nextStep,
  });

  factory PosOnboardingState.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final data = <String, Map<String, dynamic>>{};
    if (rawData is Map) {
      rawData.forEach((key, value) {
        if (value is Map) data[key.toString()] = Map<String, dynamic>.from(value);
      });
    }
    return PosOnboardingState(
      status: PosOnboardingStatus.parse(json['status']),
      data: data,
      missingSteps: (json['missingSteps'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      nextStep: json['nextStep'] as String?,
    );
  }

  final PosOnboardingStatus status;
  final Map<String, Map<String, dynamic>> data;
  final List<String> missingSteps;
  final String? nextStep;

  Map<String, dynamic> step(String name) => data[name] ?? const {};

}

/// Result of `POST /vendor/pos-onboarding/start`.
class PosStartResult {
  const PosStartResult({required this.info, required this.created, required this.needsTokenRefresh});
  final AppModeInfo info;
  final bool created;

  /// The access token issued at login has no shop claims until refreshed.
  final bool needsTokenRefresh;
}

/// Result of `POST /vendor/pos-onboarding/complete`.
class PosCompleteResult {
  const PosCompleteResult({required this.info, this.starterCounts});
  final AppModeInfo info;
  final Map<String, int>? starterCounts;
}
