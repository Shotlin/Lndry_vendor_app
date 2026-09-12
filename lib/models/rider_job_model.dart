/// A single garment/service line on a rider's job, used to drive the
/// pickup photo-capture business rule: weight('kg') lines share one
/// grouped photo; piece/pair lines each need their own dedicated photo.
class RiderJobLineModel {
  const RiderJobLineModel({
    required this.id,
    required this.garmentName,
    required this.unit,
    required this.quantity,
  });

  final String id;
  final String garmentName;
  final String unit;
  final int quantity;

  /// True for units priced by a continuous measurement (kg, sq ft) rather
  /// than a discrete count — these take an exact decimal correction, never
  /// a +/- stepper.
  bool get isWeightBased {
    final u = unit.toLowerCase();
    return u == 'kg' || u == 'sqft';
  }

  /// Display suffix for the confirmed quantity/measurement.
  String get unitLabel => unit.toLowerCase() == 'sqft' ? 'sq ft' : 'kg';

  factory RiderJobLineModel.fromJson(Map<String, dynamic> json) {
    return RiderJobLineModel(
      id: json['id'] as String? ?? '',
      garmentName: json['garment_name'] as String? ?? 'Item',
      unit: json['unit'] as String? ?? 'piece',
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    );
  }
}

/// A pickup or delivery job assigned to the logged-in rider.
class RiderJobModel {
  const RiderJobModel({
    required this.assignmentId,
    required this.orderId,
    required this.orderNumber,
    required this.assignmentType,
    required this.orderStatus,
    this.customerName,
    this.customerPhone,
    required this.addressLine,
    this.lat,
    this.lng,
    this.scheduledLabel,
    this.assignedAt,
    this.lines = const [],
    this.paymentMethod,
    this.balanceDuePaise,
    this.offerExpiresAt,
  });

  final String assignmentId;
  final String orderId;
  final String orderNumber;

  /// 'PICKUP' or 'DELIVERY'.
  final String assignmentType;
  final String orderStatus;
  final String? customerName;
  final String? customerPhone;
  final String addressLine;
  final double? lat;
  final double? lng;
  final String? scheduledLabel;
  final DateTime? assignedAt;
  final List<RiderJobLineModel> lines;

  /// 'COD' or 'ONLINE' — governs how the delivery-leg balance is settled.
  final String? paymentMethod;
  final int? balanceDuePaise;

  /// Set only for a pending offer (GET /vendor/rider/offers) — when the
  /// broadcast will automatically re-fire if nobody's accepted by then.
  /// Null for a confirmed job (GET /vendor/rider/jobs).
  final DateTime? offerExpiresAt;

  bool get isPickup => assignmentType == 'PICKUP';
  bool get hasLocation => lat != null && lng != null;
  bool get isCod => paymentMethod == 'COD';
  bool get hasBalanceDue => (balanceDuePaise ?? 0) > 0;

  /// True once the rider has pressed "Start Pickup"/"Start Delivery" (order
  /// moved past its initial *_ASSIGNED state) — used to keep a job the
  /// rider is already mid-way through easy to find again if they reopen
  /// the app with several jobs queued, instead of it looking identical to
  /// one they haven't started yet.
  bool get isInProgress => isPickup
      ? orderStatus != 'PICKUP_ASSIGNED'
      : orderStatus != 'DELIVERY_ASSIGNED';

  factory RiderJobModel.fromJson(Map<String, dynamic> json) {
    return RiderJobModel(
      assignmentId: json['assignment_id'] as String? ?? '',
      orderId: json['order_id'] as String? ?? '',
      orderNumber: json['order_number'] as String? ?? '',
      assignmentType: json['assignment_type'] as String? ?? 'PICKUP',
      orderStatus: json['order_status'] as String? ?? '',
      customerName: json['customer_name'] as String?,
      customerPhone: json['customer_phone'] as String?,
      addressLine: json['address_line'] as String? ?? '',
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      scheduledLabel: json['scheduled_label'] as String?,
      assignedAt: json['assigned_at'] != null
          ? DateTime.tryParse(json['assigned_at'] as String)
          : null,
      lines: (json['lines'] as List<dynamic>?)
              ?.map((e) => RiderJobLineModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      paymentMethod: json['payment_method'] as String?,
      balanceDuePaise: (json['balance_due_paise'] as num?)?.toInt(),
      offerExpiresAt: json['offer_expires_at'] != null
          ? DateTime.tryParse(json['offer_expires_at'] as String)
          : null,
    );
  }
}
