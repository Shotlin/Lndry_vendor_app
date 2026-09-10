// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VendorModelImpl _$$VendorModelImplFromJson(Map<String, dynamic> json) =>
    _$VendorModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      ownerName: json['ownerName'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      address: AddressModel.fromJson(json['address'] as Map<String, dynamic>),
      categoryIds: (json['categoryIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      coverImageUrl: json['coverImageUrl'] as String?,
      logoUrl: json['logoUrl'] as String?,
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      isOpen: json['isOpen'] as bool? ?? true,
      isVerified: json['isVerified'] as bool? ?? false,
      minOrderAmount: (json['minOrderAmount'] as num?)?.toDouble() ?? 99.0,
      deliveryRadiusKm: (json['deliveryRadiusKm'] as num?)?.toDouble() ?? 10.0,
      estimatedTurnaroundHours:
          (json['estimatedTurnaroundHours'] as num?)?.toInt() ?? 24,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      distanceKm: (json['distanceKm'] as num?)?.toDouble(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$VendorModelImplToJson(_$VendorModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'ownerName': instance.ownerName,
      'phone': instance.phone,
      'email': instance.email,
      'address': instance.address,
      'categoryIds': instance.categoryIds,
      'coverImageUrl': instance.coverImageUrl,
      'logoUrl': instance.logoUrl,
      'averageRating': instance.averageRating,
      'reviewCount': instance.reviewCount,
      'isOpen': instance.isOpen,
      'isVerified': instance.isVerified,
      'minOrderAmount': instance.minOrderAmount,
      'deliveryRadiusKm': instance.deliveryRadiusKm,
      'estimatedTurnaroundHours': instance.estimatedTurnaroundHours,
      'tags': instance.tags,
      'distanceKm': instance.distanceKm,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_$CategoryModelImpl _$$CategoryModelImplFromJson(Map<String, dynamic> json) =>
    _$CategoryModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String? ?? '#4F6AF5',
      imageUrl: json['imageUrl'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$CategoryModelImplToJson(_$CategoryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'icon': instance.icon,
      'color': instance.color,
      'imageUrl': instance.imageUrl,
      'isActive': instance.isActive,
      'sortOrder': instance.sortOrder,
    };

_$CartItemImpl _$$CartItemImplFromJson(Map<String, dynamic> json) =>
    _$CartItemImpl(
      id: json['id'] as String,
      serviceId: json['serviceId'] as String,
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$$CartItemImplToJson(_$CartItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'serviceId': instance.serviceId,
      'quantity': instance.quantity,
    };

_$NotificationModelImpl _$$NotificationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationModelImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String?,
      title: json['title'] as String,
      body: json['body'] as String,
      type: json['type'] as String? ?? 'general',
      imageUrl: json['image_url'] as String?,
      deepLink: json['deep_link'] as String?,
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$NotificationModelImplToJson(
        _$NotificationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'title': instance.title,
      'body': instance.body,
      'type': instance.type,
      'image_url': instance.imageUrl,
      'deep_link': instance.deepLink,
      'is_read': instance.isRead,
      'created_at': instance.createdAt.toIso8601String(),
    };
