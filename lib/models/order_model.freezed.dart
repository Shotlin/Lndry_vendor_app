// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) {
  return _OrderItem.fromJson(json);
}

/// @nodoc
mixin _$OrderItem {
  String get serviceId => throw _privateConstructorUsedError;
  String get serviceName => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get unitPrice => throw _privateConstructorUsedError;
  double get totalPrice => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// 'kg' / 'piece' / 'pair' — determines the rider pickup-photo
  /// grouping rule (kg items share one photo; piece/pair items each
  /// need their own).
  String get unit => throw _privateConstructorUsedError;

  /// Real `order_lines.id` — the stable identity used by rider
  /// measurement/vendor reconciliation submissions. `serviceId` is
  /// the garment_type_id from the static items snapshot and is not
  /// guaranteed unique per order, so this is used instead wherever
  /// a specific order line must be addressed.
  String? get orderLineId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrderItemCopyWith<OrderItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderItemCopyWith<$Res> {
  factory $OrderItemCopyWith(OrderItem value, $Res Function(OrderItem) then) =
      _$OrderItemCopyWithImpl<$Res, OrderItem>;
  @useResult
  $Res call(
      {String serviceId,
      String serviceName,
      int quantity,
      double unitPrice,
      double totalPrice,
      String? notes,
      String unit,
      String? orderLineId});
}

/// @nodoc
class _$OrderItemCopyWithImpl<$Res, $Val extends OrderItem>
    implements $OrderItemCopyWith<$Res> {
  _$OrderItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? serviceId = null,
    Object? serviceName = null,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? totalPrice = null,
    Object? notes = freezed,
    Object? unit = null,
    Object? orderLineId = freezed,
  }) {
    return _then(_value.copyWith(
      serviceId: null == serviceId
          ? _value.serviceId
          : serviceId // ignore: cast_nullable_to_non_nullable
              as String,
      serviceName: null == serviceName
          ? _value.serviceName
          : serviceName // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      orderLineId: freezed == orderLineId
          ? _value.orderLineId
          : orderLineId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderItemImplCopyWith<$Res>
    implements $OrderItemCopyWith<$Res> {
  factory _$$OrderItemImplCopyWith(
          _$OrderItemImpl value, $Res Function(_$OrderItemImpl) then) =
      __$$OrderItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String serviceId,
      String serviceName,
      int quantity,
      double unitPrice,
      double totalPrice,
      String? notes,
      String unit,
      String? orderLineId});
}

/// @nodoc
class __$$OrderItemImplCopyWithImpl<$Res>
    extends _$OrderItemCopyWithImpl<$Res, _$OrderItemImpl>
    implements _$$OrderItemImplCopyWith<$Res> {
  __$$OrderItemImplCopyWithImpl(
      _$OrderItemImpl _value, $Res Function(_$OrderItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? serviceId = null,
    Object? serviceName = null,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? totalPrice = null,
    Object? notes = freezed,
    Object? unit = null,
    Object? orderLineId = freezed,
  }) {
    return _then(_$OrderItemImpl(
      serviceId: null == serviceId
          ? _value.serviceId
          : serviceId // ignore: cast_nullable_to_non_nullable
              as String,
      serviceName: null == serviceName
          ? _value.serviceName
          : serviceName // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      orderLineId: freezed == orderLineId
          ? _value.orderLineId
          : orderLineId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderItemImpl implements _OrderItem {
  const _$OrderItemImpl(
      {required this.serviceId,
      required this.serviceName,
      required this.quantity,
      this.unitPrice = 0.0,
      this.totalPrice = 0.0,
      this.notes,
      this.unit = 'piece',
      this.orderLineId});

  factory _$OrderItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderItemImplFromJson(json);

  @override
  final String serviceId;
  @override
  final String serviceName;
  @override
  final int quantity;
  @override
  @JsonKey()
  final double unitPrice;
  @override
  @JsonKey()
  final double totalPrice;
  @override
  final String? notes;

  /// 'kg' / 'piece' / 'pair' — determines the rider pickup-photo
  /// grouping rule (kg items share one photo; piece/pair items each
  /// need their own).
  @override
  @JsonKey()
  final String unit;

  /// Real `order_lines.id` — the stable identity used by rider
  /// measurement/vendor reconciliation submissions. `serviceId` is
  /// the garment_type_id from the static items snapshot and is not
  /// guaranteed unique per order, so this is used instead wherever
  /// a specific order line must be addressed.
  @override
  final String? orderLineId;

  @override
  String toString() {
    return 'OrderItem(serviceId: $serviceId, serviceName: $serviceName, quantity: $quantity, unitPrice: $unitPrice, totalPrice: $totalPrice, notes: $notes, unit: $unit, orderLineId: $orderLineId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderItemImpl &&
            (identical(other.serviceId, serviceId) ||
                other.serviceId == serviceId) &&
            (identical(other.serviceName, serviceName) ||
                other.serviceName == serviceName) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.orderLineId, orderLineId) ||
                other.orderLineId == orderLineId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, serviceId, serviceName, quantity,
      unitPrice, totalPrice, notes, unit, orderLineId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderItemImplCopyWith<_$OrderItemImpl> get copyWith =>
      __$$OrderItemImplCopyWithImpl<_$OrderItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderItemImplToJson(
      this,
    );
  }
}

abstract class _OrderItem implements OrderItem {
  const factory _OrderItem(
      {required final String serviceId,
      required final String serviceName,
      required final int quantity,
      final double unitPrice,
      final double totalPrice,
      final String? notes,
      final String unit,
      final String? orderLineId}) = _$OrderItemImpl;

  factory _OrderItem.fromJson(Map<String, dynamic> json) =
      _$OrderItemImpl.fromJson;

  @override
  String get serviceId;
  @override
  String get serviceName;
  @override
  int get quantity;
  @override
  double get unitPrice;
  @override
  double get totalPrice;
  @override
  String? get notes;
  @override

  /// 'kg' / 'piece' / 'pair' — determines the rider pickup-photo
  /// grouping rule (kg items share one photo; piece/pair items each
  /// need their own).
  String get unit;
  @override

  /// Real `order_lines.id` — the stable identity used by rider
  /// measurement/vendor reconciliation submissions. `serviceId` is
  /// the garment_type_id from the static items snapshot and is not
  /// guaranteed unique per order, so this is used instead wherever
  /// a specific order line must be addressed.
  String? get orderLineId;
  @override
  @JsonKey(ignore: true)
  _$$OrderItemImplCopyWith<_$OrderItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) {
  return _OrderModel.fromJson(json);
}

/// @nodoc
mixin _$OrderModel {
  String get id => throw _privateConstructorUsedError;
  String get orderNumber => throw _privateConstructorUsedError;
  String get customerId => throw _privateConstructorUsedError;
  String get customerName => throw _privateConstructorUsedError;
  String get customerPhone => throw _privateConstructorUsedError;
  String get deliveryAddressText => throw _privateConstructorUsedError;
  String get vendorId => throw _privateConstructorUsedError;
  String? get deliveryPartnerId => throw _privateConstructorUsedError;
  List<OrderItem> get items => throw _privateConstructorUsedError;
  OrderStatus get status => throw _privateConstructorUsedError;
  double get subtotal => throw _privateConstructorUsedError;
  double get platformFee => throw _privateConstructorUsedError;
  double get gstAmount => throw _privateConstructorUsedError;

  /// Baked into `total` but was historically never parsed/shown as its
  /// own line — surfaced so the price breakdown always reconciles with
  /// the displayed total (same class of bug handlingFee was added for).
  double get deliveryFee => throw _privateConstructorUsedError;

  /// Flat/percentage fee configured per-vendor (fee-settings), baked into
  /// `total` but historically never shown as its own line — surfaced so
  /// the price breakdown always reconciles with the displayed total.
  double get handlingFee => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;
  PaymentMethod get paymentMethod => throw _privateConstructorUsedError;
  bool get isPaid => throw _privateConstructorUsedError;
  String get pickupAddressId => throw _privateConstructorUsedError;
  String get deliveryAddressId => throw _privateConstructorUsedError;
  DateTime? get scheduledPickupAt => throw _privateConstructorUsedError;
  DateTime? get estimatedDeliveryAt => throw _privateConstructorUsedError;
  DateTime? get pickedUpAt => throw _privateConstructorUsedError;
  DateTime? get deliveredAt => throw _privateConstructorUsedError;
  String? get cancellationReason => throw _privateConstructorUsedError;
  String? get vendorRejectionReason => throw _privateConstructorUsedError;
  String? get customerNotes => throw _privateConstructorUsedError;
  double? get customerRating => throw _privateConstructorUsedError;
  double? get deliveryRating => throw _privateConstructorUsedError;
  String? get customerReview => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// The reconciliation currently governing this order's approval state
  /// (status RECONCILIATION_PENDING/RECONCILIATION_DISPUTED) — carries
  /// exactly what the vendor submitted, so the order-detail screen keeps
  /// showing it instead of reverting to stale pre-reconciliation data
  /// while the customer's decision is still outstanding.
  @JsonKey(includeFromJson: false, includeToJson: false)
  VendorReconciliationView? get pendingReconciliation =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrderModelCopyWith<OrderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderModelCopyWith<$Res> {
  factory $OrderModelCopyWith(
          OrderModel value, $Res Function(OrderModel) then) =
      _$OrderModelCopyWithImpl<$Res, OrderModel>;
  @useResult
  $Res call(
      {String id,
      String orderNumber,
      String customerId,
      String customerName,
      String customerPhone,
      String deliveryAddressText,
      String vendorId,
      String? deliveryPartnerId,
      List<OrderItem> items,
      OrderStatus status,
      double subtotal,
      double platformFee,
      double gstAmount,
      double deliveryFee,
      double handlingFee,
      double total,
      PaymentMethod paymentMethod,
      bool isPaid,
      String pickupAddressId,
      String deliveryAddressId,
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
      DateTime createdAt,
      DateTime? updatedAt,
      @JsonKey(includeFromJson: false, includeToJson: false)
      VendorReconciliationView? pendingReconciliation});
}

/// @nodoc
class _$OrderModelCopyWithImpl<$Res, $Val extends OrderModel>
    implements $OrderModelCopyWith<$Res> {
  _$OrderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? customerId = null,
    Object? customerName = null,
    Object? customerPhone = null,
    Object? deliveryAddressText = null,
    Object? vendorId = null,
    Object? deliveryPartnerId = freezed,
    Object? items = null,
    Object? status = null,
    Object? subtotal = null,
    Object? platformFee = null,
    Object? gstAmount = null,
    Object? deliveryFee = null,
    Object? handlingFee = null,
    Object? total = null,
    Object? paymentMethod = null,
    Object? isPaid = null,
    Object? pickupAddressId = null,
    Object? deliveryAddressId = null,
    Object? scheduledPickupAt = freezed,
    Object? estimatedDeliveryAt = freezed,
    Object? pickedUpAt = freezed,
    Object? deliveredAt = freezed,
    Object? cancellationReason = freezed,
    Object? vendorRejectionReason = freezed,
    Object? customerNotes = freezed,
    Object? customerRating = freezed,
    Object? deliveryRating = freezed,
    Object? customerReview = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? pendingReconciliation = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      customerName: null == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      customerPhone: null == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String,
      deliveryAddressText: null == deliveryAddressText
          ? _value.deliveryAddressText
          : deliveryAddressText // ignore: cast_nullable_to_non_nullable
              as String,
      vendorId: null == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String,
      deliveryPartnerId: freezed == deliveryPartnerId
          ? _value.deliveryPartnerId
          : deliveryPartnerId // ignore: cast_nullable_to_non_nullable
              as String?,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<OrderItem>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as OrderStatus,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      platformFee: null == platformFee
          ? _value.platformFee
          : platformFee // ignore: cast_nullable_to_non_nullable
              as double,
      gstAmount: null == gstAmount
          ? _value.gstAmount
          : gstAmount // ignore: cast_nullable_to_non_nullable
              as double,
      deliveryFee: null == deliveryFee
          ? _value.deliveryFee
          : deliveryFee // ignore: cast_nullable_to_non_nullable
              as double,
      handlingFee: null == handlingFee
          ? _value.handlingFee
          : handlingFee // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as PaymentMethod,
      isPaid: null == isPaid
          ? _value.isPaid
          : isPaid // ignore: cast_nullable_to_non_nullable
              as bool,
      pickupAddressId: null == pickupAddressId
          ? _value.pickupAddressId
          : pickupAddressId // ignore: cast_nullable_to_non_nullable
              as String,
      deliveryAddressId: null == deliveryAddressId
          ? _value.deliveryAddressId
          : deliveryAddressId // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledPickupAt: freezed == scheduledPickupAt
          ? _value.scheduledPickupAt
          : scheduledPickupAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      estimatedDeliveryAt: freezed == estimatedDeliveryAt
          ? _value.estimatedDeliveryAt
          : estimatedDeliveryAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      pickedUpAt: freezed == pickedUpAt
          ? _value.pickedUpAt
          : pickedUpAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deliveredAt: freezed == deliveredAt
          ? _value.deliveredAt
          : deliveredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      cancellationReason: freezed == cancellationReason
          ? _value.cancellationReason
          : cancellationReason // ignore: cast_nullable_to_non_nullable
              as String?,
      vendorRejectionReason: freezed == vendorRejectionReason
          ? _value.vendorRejectionReason
          : vendorRejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      customerNotes: freezed == customerNotes
          ? _value.customerNotes
          : customerNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      customerRating: freezed == customerRating
          ? _value.customerRating
          : customerRating // ignore: cast_nullable_to_non_nullable
              as double?,
      deliveryRating: freezed == deliveryRating
          ? _value.deliveryRating
          : deliveryRating // ignore: cast_nullable_to_non_nullable
              as double?,
      customerReview: freezed == customerReview
          ? _value.customerReview
          : customerReview // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      pendingReconciliation: freezed == pendingReconciliation
          ? _value.pendingReconciliation
          : pendingReconciliation // ignore: cast_nullable_to_non_nullable
              as VendorReconciliationView?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderModelImplCopyWith<$Res>
    implements $OrderModelCopyWith<$Res> {
  factory _$$OrderModelImplCopyWith(
          _$OrderModelImpl value, $Res Function(_$OrderModelImpl) then) =
      __$$OrderModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String orderNumber,
      String customerId,
      String customerName,
      String customerPhone,
      String deliveryAddressText,
      String vendorId,
      String? deliveryPartnerId,
      List<OrderItem> items,
      OrderStatus status,
      double subtotal,
      double platformFee,
      double gstAmount,
      double deliveryFee,
      double handlingFee,
      double total,
      PaymentMethod paymentMethod,
      bool isPaid,
      String pickupAddressId,
      String deliveryAddressId,
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
      DateTime createdAt,
      DateTime? updatedAt,
      @JsonKey(includeFromJson: false, includeToJson: false)
      VendorReconciliationView? pendingReconciliation});
}

/// @nodoc
class __$$OrderModelImplCopyWithImpl<$Res>
    extends _$OrderModelCopyWithImpl<$Res, _$OrderModelImpl>
    implements _$$OrderModelImplCopyWith<$Res> {
  __$$OrderModelImplCopyWithImpl(
      _$OrderModelImpl _value, $Res Function(_$OrderModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? customerId = null,
    Object? customerName = null,
    Object? customerPhone = null,
    Object? deliveryAddressText = null,
    Object? vendorId = null,
    Object? deliveryPartnerId = freezed,
    Object? items = null,
    Object? status = null,
    Object? subtotal = null,
    Object? platformFee = null,
    Object? gstAmount = null,
    Object? deliveryFee = null,
    Object? handlingFee = null,
    Object? total = null,
    Object? paymentMethod = null,
    Object? isPaid = null,
    Object? pickupAddressId = null,
    Object? deliveryAddressId = null,
    Object? scheduledPickupAt = freezed,
    Object? estimatedDeliveryAt = freezed,
    Object? pickedUpAt = freezed,
    Object? deliveredAt = freezed,
    Object? cancellationReason = freezed,
    Object? vendorRejectionReason = freezed,
    Object? customerNotes = freezed,
    Object? customerRating = freezed,
    Object? deliveryRating = freezed,
    Object? customerReview = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? pendingReconciliation = freezed,
  }) {
    return _then(_$OrderModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      customerName: null == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      customerPhone: null == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String,
      deliveryAddressText: null == deliveryAddressText
          ? _value.deliveryAddressText
          : deliveryAddressText // ignore: cast_nullable_to_non_nullable
              as String,
      vendorId: null == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String,
      deliveryPartnerId: freezed == deliveryPartnerId
          ? _value.deliveryPartnerId
          : deliveryPartnerId // ignore: cast_nullable_to_non_nullable
              as String?,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<OrderItem>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as OrderStatus,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      platformFee: null == platformFee
          ? _value.platformFee
          : platformFee // ignore: cast_nullable_to_non_nullable
              as double,
      gstAmount: null == gstAmount
          ? _value.gstAmount
          : gstAmount // ignore: cast_nullable_to_non_nullable
              as double,
      deliveryFee: null == deliveryFee
          ? _value.deliveryFee
          : deliveryFee // ignore: cast_nullable_to_non_nullable
              as double,
      handlingFee: null == handlingFee
          ? _value.handlingFee
          : handlingFee // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as PaymentMethod,
      isPaid: null == isPaid
          ? _value.isPaid
          : isPaid // ignore: cast_nullable_to_non_nullable
              as bool,
      pickupAddressId: null == pickupAddressId
          ? _value.pickupAddressId
          : pickupAddressId // ignore: cast_nullable_to_non_nullable
              as String,
      deliveryAddressId: null == deliveryAddressId
          ? _value.deliveryAddressId
          : deliveryAddressId // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledPickupAt: freezed == scheduledPickupAt
          ? _value.scheduledPickupAt
          : scheduledPickupAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      estimatedDeliveryAt: freezed == estimatedDeliveryAt
          ? _value.estimatedDeliveryAt
          : estimatedDeliveryAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      pickedUpAt: freezed == pickedUpAt
          ? _value.pickedUpAt
          : pickedUpAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deliveredAt: freezed == deliveredAt
          ? _value.deliveredAt
          : deliveredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      cancellationReason: freezed == cancellationReason
          ? _value.cancellationReason
          : cancellationReason // ignore: cast_nullable_to_non_nullable
              as String?,
      vendorRejectionReason: freezed == vendorRejectionReason
          ? _value.vendorRejectionReason
          : vendorRejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      customerNotes: freezed == customerNotes
          ? _value.customerNotes
          : customerNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      customerRating: freezed == customerRating
          ? _value.customerRating
          : customerRating // ignore: cast_nullable_to_non_nullable
              as double?,
      deliveryRating: freezed == deliveryRating
          ? _value.deliveryRating
          : deliveryRating // ignore: cast_nullable_to_non_nullable
              as double?,
      customerReview: freezed == customerReview
          ? _value.customerReview
          : customerReview // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      pendingReconciliation: freezed == pendingReconciliation
          ? _value.pendingReconciliation
          : pendingReconciliation // ignore: cast_nullable_to_non_nullable
              as VendorReconciliationView?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderModelImpl implements _OrderModel {
  const _$OrderModelImpl(
      {required this.id,
      this.orderNumber = '',
      required this.customerId,
      this.customerName = '',
      this.customerPhone = '',
      this.deliveryAddressText = '',
      required this.vendorId,
      this.deliveryPartnerId,
      required final List<OrderItem> items,
      required this.status,
      this.subtotal = 0.0,
      this.platformFee = 0.0,
      this.gstAmount = 0.0,
      this.deliveryFee = 0.0,
      this.handlingFee = 0.0,
      this.total = 0.0,
      this.paymentMethod = PaymentMethod.upi,
      this.isPaid = false,
      this.pickupAddressId = '',
      this.deliveryAddressId = '',
      this.scheduledPickupAt,
      this.estimatedDeliveryAt,
      this.pickedUpAt,
      this.deliveredAt,
      this.cancellationReason,
      this.vendorRejectionReason,
      this.customerNotes,
      this.customerRating,
      this.deliveryRating,
      this.customerReview,
      required this.createdAt,
      this.updatedAt,
      @JsonKey(includeFromJson: false, includeToJson: false)
      this.pendingReconciliation})
      : _items = items;

  factory _$OrderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey()
  final String orderNumber;
  @override
  final String customerId;
  @override
  @JsonKey()
  final String customerName;
  @override
  @JsonKey()
  final String customerPhone;
  @override
  @JsonKey()
  final String deliveryAddressText;
  @override
  final String vendorId;
  @override
  final String? deliveryPartnerId;
  final List<OrderItem> _items;
  @override
  List<OrderItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final OrderStatus status;
  @override
  @JsonKey()
  final double subtotal;
  @override
  @JsonKey()
  final double platformFee;
  @override
  @JsonKey()
  final double gstAmount;

  /// Baked into `total` but was historically never parsed/shown as its
  /// own line — surfaced so the price breakdown always reconciles with
  /// the displayed total (same class of bug handlingFee was added for).
  @override
  @JsonKey()
  final double deliveryFee;

  /// Flat/percentage fee configured per-vendor (fee-settings), baked into
  /// `total` but historically never shown as its own line — surfaced so
  /// the price breakdown always reconciles with the displayed total.
  @override
  @JsonKey()
  final double handlingFee;
  @override
  @JsonKey()
  final double total;
  @override
  @JsonKey()
  final PaymentMethod paymentMethod;
  @override
  @JsonKey()
  final bool isPaid;
  @override
  @JsonKey()
  final String pickupAddressId;
  @override
  @JsonKey()
  final String deliveryAddressId;
  @override
  final DateTime? scheduledPickupAt;
  @override
  final DateTime? estimatedDeliveryAt;
  @override
  final DateTime? pickedUpAt;
  @override
  final DateTime? deliveredAt;
  @override
  final String? cancellationReason;
  @override
  final String? vendorRejectionReason;
  @override
  final String? customerNotes;
  @override
  final double? customerRating;
  @override
  final double? deliveryRating;
  @override
  final String? customerReview;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  /// The reconciliation currently governing this order's approval state
  /// (status RECONCILIATION_PENDING/RECONCILIATION_DISPUTED) — carries
  /// exactly what the vendor submitted, so the order-detail screen keeps
  /// showing it instead of reverting to stale pre-reconciliation data
  /// while the customer's decision is still outstanding.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final VendorReconciliationView? pendingReconciliation;

  @override
  String toString() {
    return 'OrderModel(id: $id, orderNumber: $orderNumber, customerId: $customerId, customerName: $customerName, customerPhone: $customerPhone, deliveryAddressText: $deliveryAddressText, vendorId: $vendorId, deliveryPartnerId: $deliveryPartnerId, items: $items, status: $status, subtotal: $subtotal, platformFee: $platformFee, gstAmount: $gstAmount, deliveryFee: $deliveryFee, handlingFee: $handlingFee, total: $total, paymentMethod: $paymentMethod, isPaid: $isPaid, pickupAddressId: $pickupAddressId, deliveryAddressId: $deliveryAddressId, scheduledPickupAt: $scheduledPickupAt, estimatedDeliveryAt: $estimatedDeliveryAt, pickedUpAt: $pickedUpAt, deliveredAt: $deliveredAt, cancellationReason: $cancellationReason, vendorRejectionReason: $vendorRejectionReason, customerNotes: $customerNotes, customerRating: $customerRating, deliveryRating: $deliveryRating, customerReview: $customerReview, createdAt: $createdAt, updatedAt: $updatedAt, pendingReconciliation: $pendingReconciliation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.deliveryAddressText, deliveryAddressText) ||
                other.deliveryAddressText == deliveryAddressText) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.deliveryPartnerId, deliveryPartnerId) ||
                other.deliveryPartnerId == deliveryPartnerId) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.platformFee, platformFee) ||
                other.platformFee == platformFee) &&
            (identical(other.gstAmount, gstAmount) ||
                other.gstAmount == gstAmount) &&
            (identical(other.deliveryFee, deliveryFee) ||
                other.deliveryFee == deliveryFee) &&
            (identical(other.handlingFee, handlingFee) ||
                other.handlingFee == handlingFee) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.isPaid, isPaid) || other.isPaid == isPaid) &&
            (identical(other.pickupAddressId, pickupAddressId) ||
                other.pickupAddressId == pickupAddressId) &&
            (identical(other.deliveryAddressId, deliveryAddressId) ||
                other.deliveryAddressId == deliveryAddressId) &&
            (identical(other.scheduledPickupAt, scheduledPickupAt) ||
                other.scheduledPickupAt == scheduledPickupAt) &&
            (identical(other.estimatedDeliveryAt, estimatedDeliveryAt) ||
                other.estimatedDeliveryAt == estimatedDeliveryAt) &&
            (identical(other.pickedUpAt, pickedUpAt) ||
                other.pickedUpAt == pickedUpAt) &&
            (identical(other.deliveredAt, deliveredAt) ||
                other.deliveredAt == deliveredAt) &&
            (identical(other.cancellationReason, cancellationReason) ||
                other.cancellationReason == cancellationReason) &&
            (identical(other.vendorRejectionReason, vendorRejectionReason) ||
                other.vendorRejectionReason == vendorRejectionReason) &&
            (identical(other.customerNotes, customerNotes) ||
                other.customerNotes == customerNotes) &&
            (identical(other.customerRating, customerRating) ||
                other.customerRating == customerRating) &&
            (identical(other.deliveryRating, deliveryRating) ||
                other.deliveryRating == deliveryRating) &&
            (identical(other.customerReview, customerReview) ||
                other.customerReview == customerReview) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.pendingReconciliation, pendingReconciliation) ||
                other.pendingReconciliation == pendingReconciliation));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        orderNumber,
        customerId,
        customerName,
        customerPhone,
        deliveryAddressText,
        vendorId,
        deliveryPartnerId,
        const DeepCollectionEquality().hash(_items),
        status,
        subtotal,
        platformFee,
        gstAmount,
        deliveryFee,
        handlingFee,
        total,
        paymentMethod,
        isPaid,
        pickupAddressId,
        deliveryAddressId,
        scheduledPickupAt,
        estimatedDeliveryAt,
        pickedUpAt,
        deliveredAt,
        cancellationReason,
        vendorRejectionReason,
        customerNotes,
        customerRating,
        deliveryRating,
        customerReview,
        createdAt,
        updatedAt,
        pendingReconciliation
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderModelImplCopyWith<_$OrderModelImpl> get copyWith =>
      __$$OrderModelImplCopyWithImpl<_$OrderModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderModelImplToJson(
      this,
    );
  }
}

abstract class _OrderModel implements OrderModel {
  const factory _OrderModel(
          {required final String id,
          final String orderNumber,
          required final String customerId,
          final String customerName,
          final String customerPhone,
          final String deliveryAddressText,
          required final String vendorId,
          final String? deliveryPartnerId,
          required final List<OrderItem> items,
          required final OrderStatus status,
          final double subtotal,
          final double platformFee,
          final double gstAmount,
          final double deliveryFee,
          final double handlingFee,
          final double total,
          final PaymentMethod paymentMethod,
          final bool isPaid,
          final String pickupAddressId,
          final String deliveryAddressId,
          final DateTime? scheduledPickupAt,
          final DateTime? estimatedDeliveryAt,
          final DateTime? pickedUpAt,
          final DateTime? deliveredAt,
          final String? cancellationReason,
          final String? vendorRejectionReason,
          final String? customerNotes,
          final double? customerRating,
          final double? deliveryRating,
          final String? customerReview,
          required final DateTime createdAt,
          final DateTime? updatedAt,
          @JsonKey(includeFromJson: false, includeToJson: false)
          final VendorReconciliationView? pendingReconciliation}) =
      _$OrderModelImpl;

  factory _OrderModel.fromJson(Map<String, dynamic> json) =
      _$OrderModelImpl.fromJson;

  @override
  String get id;
  @override
  String get orderNumber;
  @override
  String get customerId;
  @override
  String get customerName;
  @override
  String get customerPhone;
  @override
  String get deliveryAddressText;
  @override
  String get vendorId;
  @override
  String? get deliveryPartnerId;
  @override
  List<OrderItem> get items;
  @override
  OrderStatus get status;
  @override
  double get subtotal;
  @override
  double get platformFee;
  @override
  double get gstAmount;
  @override

  /// Baked into `total` but was historically never parsed/shown as its
  /// own line — surfaced so the price breakdown always reconciles with
  /// the displayed total (same class of bug handlingFee was added for).
  double get deliveryFee;
  @override

  /// Flat/percentage fee configured per-vendor (fee-settings), baked into
  /// `total` but historically never shown as its own line — surfaced so
  /// the price breakdown always reconciles with the displayed total.
  double get handlingFee;
  @override
  double get total;
  @override
  PaymentMethod get paymentMethod;
  @override
  bool get isPaid;
  @override
  String get pickupAddressId;
  @override
  String get deliveryAddressId;
  @override
  DateTime? get scheduledPickupAt;
  @override
  DateTime? get estimatedDeliveryAt;
  @override
  DateTime? get pickedUpAt;
  @override
  DateTime? get deliveredAt;
  @override
  String? get cancellationReason;
  @override
  String? get vendorRejectionReason;
  @override
  String? get customerNotes;
  @override
  double? get customerRating;
  @override
  double? get deliveryRating;
  @override
  String? get customerReview;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override

  /// The reconciliation currently governing this order's approval state
  /// (status RECONCILIATION_PENDING/RECONCILIATION_DISPUTED) — carries
  /// exactly what the vendor submitted, so the order-detail screen keeps
  /// showing it instead of reverting to stale pre-reconciliation data
  /// while the customer's decision is still outstanding.
  @JsonKey(includeFromJson: false, includeToJson: false)
  VendorReconciliationView? get pendingReconciliation;
  @override
  @JsonKey(ignore: true)
  _$$OrderModelImplCopyWith<_$OrderModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
