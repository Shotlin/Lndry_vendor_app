/// Why a wizard field was rejected. The screen turns these into translated sentences; keeping them as
/// plain values keeps the rules testable without any UI. The backend validates again — these only
/// save the owner a round trip.
enum PosFieldError { shopName, ownerName, address, city, pincode, gstin, upi, prefix, days }

abstract final class PosValidators {
  PosValidators._();

  static final RegExp _gstin = RegExp(r'^\d{2}[A-Z]{5}\d{4}[A-Z][1-9A-Z]Z[0-9A-Z]$');
  static final RegExp _upi = RegExp(r'^[a-zA-Z0-9.\-_]{2,256}@[a-zA-Z]{2,64}$');
  static final RegExp _prefix = RegExp(r'^[A-Z0-9]{1,6}$');
  static final RegExp _pincode = RegExp(r'^\d{6}$');

  static String clean(String? v) => (v ?? '').trim().replaceAll(RegExp(r'\s+'), ' ');

  static PosFieldError? shopName(String? v) {
    final t = clean(v);
    return t.length < 2 || t.length > 200 ? PosFieldError.shopName : null;
  }

  static PosFieldError? ownerName(String? v) {
    final t = clean(v);
    return t.length < 2 || t.length > 120 ? PosFieldError.ownerName : null;
  }

  static PosFieldError? address(String? v) {
    final t = clean(v);
    return t.length < 3 || t.length > 255 ? PosFieldError.address : null;
  }

  static PosFieldError? city(String? v) {
    final t = clean(v);
    return t.length < 2 || t.length > 100 ? PosFieldError.city : null;
  }

  /// Optional: empty is fine.
  static PosFieldError? pincode(String? v) {
    final t = clean(v);
    return t.isEmpty || _pincode.hasMatch(t) ? null : PosFieldError.pincode;
  }

  /// Required only when GST is switched on.
  static PosFieldError? gstin(String? v, {required bool gstEnabled}) {
    if (!gstEnabled) return null;
    return _gstin.hasMatch(clean(v).toUpperCase()) ? null : PosFieldError.gstin;
  }

  /// Optional: empty is fine.
  static PosFieldError? upi(String? v) {
    final t = clean(v);
    return t.isEmpty || _upi.hasMatch(t) ? null : PosFieldError.upi;
  }

  /// Optional (defaults apply): empty is fine.
  static PosFieldError? prefix(String? v) {
    final t = clean(v).toUpperCase();
    return t.isEmpty || _prefix.hasMatch(t) ? null : PosFieldError.prefix;
  }

  static PosFieldError? deliveryDays(String? v) {
    final t = clean(v);
    if (t.isEmpty) return null;
    final n = int.tryParse(t);
    return n == null || n < 0 || n > 30 ? PosFieldError.days : null;
  }
}

/// Builds the exact request bodies the backend expects for each wizard step.
abstract final class PosOnboardingPayloads {
  PosOnboardingPayloads._();

  static Map<String, dynamic> shop({
    required String name,
    required String ownerName,
    required String addressLine1,
    required String city,
    String state = '',
    String pincode = '',
  }) =>
      {
        'name': PosValidators.clean(name),
        'ownerName': PosValidators.clean(ownerName),
        'addressLine1': PosValidators.clean(addressLine1),
        'city': PosValidators.clean(city),
        if (PosValidators.clean(state).isNotEmpty) 'state': PosValidators.clean(state),
        if (PosValidators.clean(pincode).isNotEmpty) 'pincode': PosValidators.clean(pincode),
      };

  static Map<String, dynamic> tax({
    required bool gstEnabled,
    String gstin = '',
    String upiId = '',
    String invoicePrefix = '',
  }) =>
      {
        'gstEnabled': gstEnabled,
        if (gstEnabled) 'gstin': PosValidators.clean(gstin).toUpperCase(),
        if (PosValidators.clean(upiId).isNotEmpty) 'upiId': PosValidators.clean(upiId),
        'currency': 'INR',
        if (PosValidators.clean(invoicePrefix).isNotEmpty) 'invoicePrefix': PosValidators.clean(invoicePrefix).toUpperCase(),
      };

  static Map<String, dynamic> counter({
    required String printerProfile,
    String orderSeriesPrefix = '',
    String deliveryDays = '',
  }) =>
      {
        'printerProfile': printerProfile,
        if (PosValidators.clean(orderSeriesPrefix).isNotEmpty) 'orderSeriesPrefix': PosValidators.clean(orderSeriesPrefix).toUpperCase(),
        if (PosValidators.clean(deliveryDays).isNotEmpty) 'defaultDeliveryDays': int.parse(PosValidators.clean(deliveryDays)),
      };

  static Map<String, dynamic> pricelist({required bool starter}) => {'choice': starter ? 'starter' : 'own'};
}

/// The four wizard steps, in the order the backend expects them.
const List<String> kPosOnboardingSteps = ['shop', 'tax', 'counter', 'pricelist'];

/// Printer options the backend accepts, in display order.
const List<String> kPosPrinterProfiles = ['none', 'system-default', 'thermal-58mm', 'thermal-80mm'];

/// Which wizard page to open: the first saved-step gap, else the last page.
int posResumeStepIndex(String? nextStep) {
  final i = nextStep == null ? -1 : kPosOnboardingSteps.indexOf(nextStep);
  return i < 0 ? kPosOnboardingSteps.length - 1 : i;
}
