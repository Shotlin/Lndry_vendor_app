import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

// ── Canonical Order Status ────────────────────────────────────────────────────
/// 21-state canonical LNDRY order lifecycle per spec §6.
/// Internal status → customer label mapping is in [OrderStatusX.customerLabel].
enum OrderStatus {
  @JsonValue('PAYMENT_PENDING')
  paymentPending,

  @JsonValue('PAYMENT_FAILED')
  paymentFailed,

  @JsonValue('WAITING_FOR_VENDOR_CONFIRMATION')
  waitingForVendorConfirmation,

  @JsonValue('VENDOR_ACCEPTED')
  vendorAccepted,

  @JsonValue('PICKUP_ASSIGNED')
  pickupAssigned,

  @JsonValue('GOING_FOR_PICKUP')
  goingForPickup,

  @JsonValue('PICKUP_OTP_VERIFIED')
  pickupOtpVerified,

  @JsonValue('PICKED_UP')
  pickedUp,

  @JsonValue('RECEIVED_AT_VENDOR')
  receivedAtVendor,

  @JsonValue('RECONCILIATION_PENDING')
  reconciliationPending,

  @JsonValue('RECONCILIATION_DISPUTED')
  reconciliationDisputed,

  @JsonValue('PROCESSING')
  processing,

  @JsonValue('PACKED')
  packed,

  @JsonValue('DELIVERY_ASSIGNED')
  deliveryAssigned,

  @JsonValue('OUT_FOR_DELIVERY')
  outForDelivery,

  @JsonValue('DELIVERY_OTP_VERIFIED')
  deliveryOtpVerified,

  @JsonValue('DELIVERED')
  delivered,

  @JsonValue('VENDOR_REJECTED')
  vendorRejected,

  @JsonValue('AUTO_REJECTED')
  autoRejected,

  @JsonValue('CUSTOMER_CANCELLED')
  customerCancelled,

  @JsonValue('ADMIN_CANCELLED')
  adminCancelled,

  @JsonValue('REFUND_PENDING')
  refundPending,

  @JsonValue('REFUNDED')
  refunded,
}

extension OrderStatusX on OrderStatus {
  /// Customer-facing label per spec §6 canonical mapping table.
  String get label => switch (this) {
        OrderStatus.paymentPending => 'Payment Pending',
        OrderStatus.paymentFailed => 'Payment Failed',
        OrderStatus.waitingForVendorConfirmation => 'Waiting for Vendor Confirmation',
        OrderStatus.vendorAccepted => 'Scheduled',
        OrderStatus.pickupAssigned => 'Scheduled',
        OrderStatus.goingForPickup => 'Pickup Partner Coming',
        OrderStatus.pickupOtpVerified => 'Picked Up',
        OrderStatus.pickedUp => 'Picked Up',
        OrderStatus.receivedAtVendor => 'At Partner',
        OrderStatus.reconciliationPending => 'Re-evaluation Submitted — Waiting for Customer Approval',
        OrderStatus.reconciliationDisputed => 'Customer Disputed Re-evaluation',
        OrderStatus.processing => 'Processing',
        OrderStatus.packed => 'Packed',
        OrderStatus.deliveryAssigned => 'Out for Delivery',
        OrderStatus.outForDelivery => 'Out for Delivery',
        OrderStatus.deliveryOtpVerified => 'Delivered',
        OrderStatus.delivered => 'Delivered',
        OrderStatus.vendorRejected => 'Rejected by Vendor',
        OrderStatus.autoRejected => 'Auto-Rejected',
        OrderStatus.customerCancelled => 'Cancelled',
        OrderStatus.adminCancelled => 'Cancelled',
        OrderStatus.refundPending => 'Refund Pending',
        OrderStatus.refunded => 'Refunded',
      };

  /// Whether this order is still in progress (not a terminal state).
  bool get isActive => switch (this) {
        OrderStatus.delivered ||
        OrderStatus.deliveryOtpVerified ||
        OrderStatus.vendorRejected ||
        OrderStatus.autoRejected ||
        OrderStatus.customerCancelled ||
        OrderStatus.adminCancelled ||
        OrderStatus.refunded =>
          false,
        _ => true,
      };

  /// Whether the customer can cancel at this stage.
  bool get isCancellable => switch (this) {
        OrderStatus.waitingForVendorConfirmation ||
        OrderStatus.vendorAccepted ||
        OrderStatus.pickupAssigned =>
          true,
        _ => false,
      };

  /// Whether the order ended in a rejection that allows selecting another vendor.
  bool get isRejected =>
      this == OrderStatus.vendorRejected || this == OrderStatus.autoRejected;

  /// Whether this is a terminal failure/completion state.
  bool get isTerminal => !isActive;

  /// Whether a refund is applicable or pending.
  bool get hasRefundState =>
      this == OrderStatus.refundPending || this == OrderStatus.refunded;

  /// Pickup OTP should be visible at these statuses (backend visibility=true
  /// is the authoritative source; this is a client-side hint only).
  bool get showPickupOtpHint =>
      this == OrderStatus.goingForPickup || this == OrderStatus.pickupAssigned;

  /// Delivery OTP should be visible at these statuses.
  bool get showDeliveryOtpHint =>
      this == OrderStatus.outForDelivery || this == OrderStatus.deliveryAssigned;
}

// ── Payment Method ─────────────────────────────────────────────────────────────
/// Razorpay-supported payment methods plus Cash on Delivery, which checkout
/// still offers and the backend stores as `payment_method = 'COD'`.
enum PaymentMethod {
  @JsonValue('upi')
  upi,

  @JsonValue('card')
  card,

  @JsonValue('wallet')
  wallet, // Razorpay-supported wallet only; not LNDRY stored-value wallet

  @JsonValue('cod')
  cod,
}

extension PaymentMethodX on PaymentMethod {
  String get label => switch (this) {
        PaymentMethod.upi => 'UPI',
        PaymentMethod.card => 'Card',
        PaymentMethod.wallet => 'Wallet',
        PaymentMethod.cod => 'Cash on Delivery',
      };
}

// ── Order Item ─────────────────────────────────────────────────────────────────
/// A single service/garment line in an order.
/// NOTE: unitPrice and totalPrice are stored in PAISE (integer) per spec §6.
/// When backend is integrated these will be MoneyPaise = int.
/// For mock phase they remain double to avoid breaking existing mock JSON.
@freezed
class OrderItem with _$OrderItem {
  const factory OrderItem({
    required String serviceId,
    required String serviceName,
    required int quantity,
    @Default(0.0) double unitPrice,
    @Default(0.0) double totalPrice,
    String? notes,
    /// 'kg' / 'piece' / 'pair' — determines the rider pickup-photo
    /// grouping rule (kg items share one photo; piece/pair items each
    /// need their own).
    @Default('piece') String unit,
    /// Real `order_lines.id` — the stable identity used by rider
    /// measurement/vendor reconciliation submissions. `serviceId` is
    /// the garment_type_id from the static items snapshot and is not
    /// guaranteed unique per order, so this is used instead wherever
    /// a specific order line must be addressed.
    String? orderLineId,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
}

// ── Order Model ────────────────────────────────────────────────────────────────
/// Core customer order entity.
/// Money fields are double in mock phase; will become integer paise when
/// ApiCustomerRepository is wired (see spec §6 Money rule).
@freezed
class OrderModel with _$OrderModel {
  const factory OrderModel({
    required String id,
    @Default('') String orderNumber,
    required String customerId,
    @Default('') String customerName,
    @Default('') String customerPhone,
    @Default('') String deliveryAddressText,
    required String vendorId,
    String? deliveryPartnerId,
    required List<OrderItem> items,
    required OrderStatus status,
    @Default(0.0) double subtotal,
    @Default(0.0) double platformFee,
    @Default(0.0) double gstAmount,
    /// Baked into `total` but was historically never parsed/shown as its
    /// own line — surfaced so the price breakdown always reconciles with
    /// the displayed total (same class of bug handlingFee was added for).
    @Default(0.0) double deliveryFee,
    /// Flat/percentage fee configured per-vendor (fee-settings), baked into
    /// `total` but historically never shown as its own line — surfaced so
    /// the price breakdown always reconciles with the displayed total.
    @Default(0.0) double handlingFee,
    @Default(0.0) double total,
    @Default(PaymentMethod.upi) PaymentMethod paymentMethod,
    @Default(false) bool isPaid,
    @Default('') String pickupAddressId,
    @Default('') String deliveryAddressId,
    DateTime? scheduledPickupAt,
    DateTime? estimatedDeliveryAt,
    DateTime? pickedUpAt,
    DateTime? deliveredAt,
    String? cancellationReason,
    String? vendorRejectionReason,
    String? customerNotes,
    double? customerRating,
    double? deliveryRating,
    String? customerReview,
    required DateTime createdAt,
    DateTime? updatedAt,
    /// The reconciliation currently governing this order's approval state
    /// (status RECONCILIATION_PENDING/RECONCILIATION_DISPUTED) — carries
    /// exactly what the vendor submitted, so the order-detail screen keeps
    /// showing it instead of reverting to stale pre-reconciliation data
    /// while the customer's decision is still outstanding.
    @JsonKey(includeFromJson: false, includeToJson: false)
    VendorReconciliationView? pendingReconciliation,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(_normalizeOrderJson(json));
}

Map<String, dynamic> _normalizeOrderJson(Map<String, dynamic> json) {
  final normalized = Map<String, dynamic>.from(json);
  if (json['status'] is String) {
    normalized['status'] = _normalizeStatus(json['status'] as String);
  }
  if (json['paymentMethod'] is String) {
    normalized['paymentMethod'] =
        _normalizePaymentMethod(json['paymentMethod'] as String);
  }
  return normalized;
}

/// Normalizes an order status string to match the canonical enum values.
/// Handles case-insensitive matching and provides a safe fallback for
/// unknown or malformed statuses so the UI never crashes on parsing.
String _normalizeStatus(String raw) {
  final upper = raw.toUpperCase().trim();
  // Map of known aliases for backwards compatibility.
  const aliases = <String, String>{
    'CONFIRMED': 'VENDOR_ACCEPTED',
  };
  // Canonical status strings from _$OrderStatusEnumMap.
  const validStatuses = <String>[
    'PAYMENT_PENDING',
    'PAYMENT_FAILED',
    'WAITING_FOR_VENDOR_CONFIRMATION',
    'VENDOR_ACCEPTED',
    'PICKUP_ASSIGNED',
    'GOING_FOR_PICKUP',
    'PICKUP_OTP_VERIFIED',
    'PICKED_UP',
    'RECEIVED_AT_VENDOR',
    'RECONCILIATION_PENDING',
    'RECONCILIATION_DISPUTED',
    'PROCESSING',
    'PACKED',
    'DELIVERY_ASSIGNED',
    'OUT_FOR_DELIVERY',
    'DELIVERY_OTP_VERIFIED',
    'DELIVERED',
    'VENDOR_REJECTED',
    'AUTO_REJECTED',
    'CUSTOMER_CANCELLED',
    'ADMIN_CANCELLED',
    'REFUND_PENDING',
    'REFUNDED',
  ];

  // Check aliases first.
  if (aliases.containsKey(upper)) return aliases[upper]!;
  // Check direct match (case-insensitive).
  for (final v in validStatuses) {
    if (v == upper) return v;
  }
  // Safe fallback — unknown status defaults to PAYMENT_PENDING.
  return 'PAYMENT_PENDING';
}

/// Normalizes a payment method string to match the canonical enum values.
/// Handles case-insensitive matching and provides a safe fallback.
String _normalizePaymentMethod(String raw) {
  final upper = raw.toUpperCase().trim();
  // Map of known aliases/legacy values.
  const aliases = <String, String>{
    'CASH': 'cod',
    'COD': 'cod',
    'CREDIT_CARD': 'card',
    'DEBIT_CARD': 'card',
    'NET_BANKING': 'upi',
  };
  // Canonical payment method strings.
  const validMethods = <String>['upi', 'card', 'wallet', 'cod'];

  // Check aliases first (case-insensitive).
  if (aliases.containsKey(upper)) return aliases[upper]!;
  // Check direct match (case-insensitive).
  for (final v in validMethods) {
    if (v.toUpperCase() == upper) return v;
  }
  // Safe fallback.
  return 'upi';
}

/// Plain (non-Freezed) view of a reconciliation proposal, for the vendor's
/// own order-detail screen — parsed manually in `_parseOrder`, not via
/// `.fromJson`, so no codegen involvement needed here.
class VendorReconciliationView {
  const VendorReconciliationView({
    required this.status,
    required this.proposedPayableAmountPaise,
    required this.previousPayableAmountPaise,
    this.reason,
    required this.photos,
    required this.lineChanges,
  });

  /// 'PENDING_CUSTOMER' | 'ACCEPTED' | 'REJECTED' | 'APPLIED'.
  final String status;
  final int proposedPayableAmountPaise;
  final int previousPayableAmountPaise;
  final String? reason;
  final List<String> photos;
  final List<VendorReconciliationLineChange> lineChanges;
}

class VendorReconciliationLineChange {
  const VendorReconciliationLineChange({
    this.previousName,
    this.proposedName,
    this.proposedUnit,
    required this.proposedQuantity,
    required this.isNew,
    required this.isReclassified,
  });

  final String? previousName;
  final String? proposedName;
  final String? proposedUnit;
  final num proposedQuantity;
  final bool isNew;
  final bool isReclassified;

  String get displayName => proposedName ?? previousName ?? 'Item';

  String get quantityLabel {
    final u = (proposedUnit ?? '').toLowerCase();
    final suffix = u == 'kg' ? ' kg' : (u == 'sqft' ? ' sq ft' : '');
    var s = proposedQuantity.toStringAsFixed(2);
    s = s.replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
    return '$s$suffix';
  }
}
