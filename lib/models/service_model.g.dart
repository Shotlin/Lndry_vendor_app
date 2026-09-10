// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServiceModelImpl _$$ServiceModelImplFromJson(Map<String, dynamic> json) =>
    _$ServiceModelImpl(
      id: json['id'] as String,
      vendorId: json['vendorId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: $enumDecode(_$ServiceCategoryEnumMap, json['category']),
      categoryId: json['category_id'] as String?,
      pricePerKg: (json['pricePerKg'] as num?)?.toDouble(),
      pricePerPiece: (json['pricePerPiece'] as num?)?.toDouble(),
      minWeightKg: (json['minWeightKg'] as num).toDouble(),
      isAvailable: json['isAvailable'] as bool? ?? true,
      approvalStatus: json['approval_status'] as String?,
      rejectionReason: json['rejection_reason'] as String?,
      latestOverrideReason: json['latest_override_reason'] as String?,
      latestOverrideAt: json['latest_override_at'] == null
          ? null
          : DateTime.parse(json['latest_override_at'] as String),
      imageUrl: json['imageUrl'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      estimatedDuration: json['estimatedDuration'] == null
          ? null
          : Duration(microseconds: (json['estimatedDuration'] as num).toInt()),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ServiceModelImplToJson(_$ServiceModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vendorId': instance.vendorId,
      'name': instance.name,
      'description': instance.description,
      'category': _$ServiceCategoryEnumMap[instance.category]!,
      'category_id': instance.categoryId,
      'pricePerKg': instance.pricePerKg,
      'pricePerPiece': instance.pricePerPiece,
      'minWeightKg': instance.minWeightKg,
      'isAvailable': instance.isAvailable,
      'approval_status': instance.approvalStatus,
      'rejection_reason': instance.rejectionReason,
      'latest_override_reason': instance.latestOverrideReason,
      'latest_override_at': instance.latestOverrideAt?.toIso8601String(),
      'imageUrl': instance.imageUrl,
      'tags': instance.tags,
      'averageRating': instance.averageRating,
      'reviewCount': instance.reviewCount,
      'estimatedDuration': instance.estimatedDuration?.inMicroseconds,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$ServiceCategoryEnumMap = {
  ServiceCategory.wash: 'wash',
  ServiceCategory.iron: 'iron',
  ServiceCategory.washAndIron: 'wash_iron',
  ServiceCategory.dryClean: 'dry_clean',
  ServiceCategory.fold: 'fold',
  ServiceCategory.premium: 'premium',
};
