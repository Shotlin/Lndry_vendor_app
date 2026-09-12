// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderItemImpl _$$OrderItemImplFromJson(Map<String, dynamic> json) =>
    _$OrderItemImpl(
      serviceId: json['serviceId'] as String,
      serviceName: json['serviceName'] as String,
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      notes: json['notes'] as String?,
      unit: json['unit'] as String? ?? 'piece',
      orderLineId: json['orderLineId'] as String?,
    );

Map<String, dynamic> _$$OrderItemImplToJson(_$OrderItemImpl instance) =>
    <String, dynamic>{
      'serviceId': instance.serviceId,
      'serviceName': instance.serviceName,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
      'totalPrice': instance.totalPrice,
      'notes': instance.notes,
      'unit': instance.unit,
      'orderLineId': instance.orderLineId,
    };

_$OrderModelImpl _$$OrderModelImplFromJson(Map<String, dynamic> json) =>
    _$OrderModelImpl(
      id: json['id'] as String,
      orderNumber: json['orderNumber'] as String? ?? '',
      customerId: json['customerId'] as String,
      customerName: json['customerName'] as String? ?? '',
      customerPhone: json['customerPhone'] as String? ?? '',
      deliveryAddressText: json['deliveryAddressText'] as String? ?? '',
      vendorId: json['vendorId'] as String,
      deliveryPartnerId: json['deliveryPartnerId'] as String?,
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: $enumDecode(_$OrderStatusEnumMap, json['status']),
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      platformFee: (json['platformFee'] as num?)?.toDouble() ?? 0.0,
      gstAmount: (json['gstAmount'] as num?)?.toDouble() ?? 0.0,
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 0.0,
      handlingFee: (json['handlingFee'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      vendorCommissionEnabled:
          json['vendorCommissionEnabled'] as bool? ?? false,
      vendorCommissionType:
          json['vendorCommissionType'] as String? ?? 'PERCENT',
      vendorCommissionRate:
          (json['vendorCommissionRate'] as num?)?.toDouble() ?? 0.0,
      vendorCommissionAmount:
          (json['vendorCommissionAmount'] as num?)?.toDouble() ?? 0.0,
      vendorGstOnCommissionEnabled:
          json['vendorGstOnCommissionEnabled'] as bool? ?? false,
      vendorGstRate: (json['vendorGstRate'] as num?)?.toDouble() ?? 0.0,
      vendorGstOnCommissionAmount:
          (json['vendorGstOnCommissionAmount'] as num?)?.toDouble() ?? 0.0,
      vendorPayoutAmount:
          (json['vendorPayoutAmount'] as num?)?.toDouble() ?? 0.0,
      paymentMethod:
          $enumDecodeNullable(_$PaymentMethodEnumMap, json['paymentMethod']) ??
              PaymentMethod.upi,
      isPaid: json['isPaid'] as bool? ?? false,
      pickupAddressId: json['pickupAddressId'] as String? ?? '',
      deliveryAddressId: json['deliveryAddressId'] as String? ?? '',
      scheduledPickupAt: json['scheduledPickupAt'] == null
          ? null
          : DateTime.parse(json['scheduledPickupAt'] as String),
      estimatedDeliveryAt: json['estimatedDeliveryAt'] == null
          ? null
          : DateTime.parse(json['estimatedDeliveryAt'] as String),
      pickedUpAt: json['pickedUpAt'] == null
          ? null
          : DateTime.parse(json['pickedUpAt'] as String),
      deliveredAt: json['deliveredAt'] == null
          ? null
          : DateTime.parse(json['deliveredAt'] as String),
      cancellationReason: json['cancellationReason'] as String?,
      vendorRejectionReason: json['vendorRejectionReason'] as String?,
      customerNotes: json['customerNotes'] as String?,
      customerRating: (json['customerRating'] as num?)?.toDouble(),
      deliveryRating: (json['deliveryRating'] as num?)?.toDouble(),
      customerReview: json['customerReview'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$OrderModelImplToJson(_$OrderModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderNumber': instance.orderNumber,
      'customerId': instance.customerId,
      'customerName': instance.customerName,
      'customerPhone': instance.customerPhone,
      'deliveryAddressText': instance.deliveryAddressText,
      'vendorId': instance.vendorId,
      'deliveryPartnerId': instance.deliveryPartnerId,
      'items': instance.items,
      'status': _$OrderStatusEnumMap[instance.status]!,
      'subtotal': instance.subtotal,
      'platformFee': instance.platformFee,
      'gstAmount': instance.gstAmount,
      'deliveryFee': instance.deliveryFee,
      'handlingFee': instance.handlingFee,
      'total': instance.total,
      'vendorCommissionEnabled': instance.vendorCommissionEnabled,
      'vendorCommissionType': instance.vendorCommissionType,
      'vendorCommissionRate': instance.vendorCommissionRate,
      'vendorCommissionAmount': instance.vendorCommissionAmount,
      'vendorGstOnCommissionEnabled': instance.vendorGstOnCommissionEnabled,
      'vendorGstRate': instance.vendorGstRate,
      'vendorGstOnCommissionAmount': instance.vendorGstOnCommissionAmount,
      'vendorPayoutAmount': instance.vendorPayoutAmount,
      'paymentMethod': _$PaymentMethodEnumMap[instance.paymentMethod]!,
      'isPaid': instance.isPaid,
      'pickupAddressId': instance.pickupAddressId,
      'deliveryAddressId': instance.deliveryAddressId,
      'scheduledPickupAt': instance.scheduledPickupAt?.toIso8601String(),
      'estimatedDeliveryAt': instance.estimatedDeliveryAt?.toIso8601String(),
      'pickedUpAt': instance.pickedUpAt?.toIso8601String(),
      'deliveredAt': instance.deliveredAt?.toIso8601String(),
      'cancellationReason': instance.cancellationReason,
      'vendorRejectionReason': instance.vendorRejectionReason,
      'customerNotes': instance.customerNotes,
      'customerRating': instance.customerRating,
      'deliveryRating': instance.deliveryRating,
      'customerReview': instance.customerReview,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$OrderStatusEnumMap = {
  OrderStatus.paymentPending: 'PAYMENT_PENDING',
  OrderStatus.paymentFailed: 'PAYMENT_FAILED',
  OrderStatus.waitingForVendorConfirmation: 'WAITING_FOR_VENDOR_CONFIRMATION',
  OrderStatus.vendorAccepted: 'VENDOR_ACCEPTED',
  OrderStatus.pickupAssigned: 'PICKUP_ASSIGNED',
  OrderStatus.goingForPickup: 'GOING_FOR_PICKUP',
  OrderStatus.pickupOtpVerified: 'PICKUP_OTP_VERIFIED',
  OrderStatus.pickedUp: 'PICKED_UP',
  OrderStatus.receivedAtVendor: 'RECEIVED_AT_VENDOR',
  OrderStatus.reconciliationPending: 'RECONCILIATION_PENDING',
  OrderStatus.reconciliationDisputed: 'RECONCILIATION_DISPUTED',
  OrderStatus.processing: 'PROCESSING',
  OrderStatus.packed: 'PACKED',
  OrderStatus.deliveryAssigned: 'DELIVERY_ASSIGNED',
  OrderStatus.outForDelivery: 'OUT_FOR_DELIVERY',
  OrderStatus.deliveryOtpVerified: 'DELIVERY_OTP_VERIFIED',
  OrderStatus.delivered: 'DELIVERED',
  OrderStatus.vendorRejected: 'VENDOR_REJECTED',
  OrderStatus.autoRejected: 'AUTO_REJECTED',
  OrderStatus.customerCancelled: 'CUSTOMER_CANCELLED',
  OrderStatus.adminCancelled: 'ADMIN_CANCELLED',
  OrderStatus.refundPending: 'REFUND_PENDING',
  OrderStatus.refunded: 'REFUNDED',
};

const _$PaymentMethodEnumMap = {
  PaymentMethod.upi: 'upi',
  PaymentMethod.card: 'card',
  PaymentMethod.wallet: 'wallet',
  PaymentMethod.cod: 'cod',
};
