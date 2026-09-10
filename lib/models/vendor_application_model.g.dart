// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_application_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VendorApplicationDocumentModelImpl
    _$$VendorApplicationDocumentModelImplFromJson(Map<String, dynamic> json) =>
        _$VendorApplicationDocumentModelImpl(
          id: json['id'] as String,
          documentType: json['documentType'] as String,
          status: json['status'] as String? ?? 'PENDING',
          rejectionReason: json['rejectionReason'] as String?,
        );

Map<String, dynamic> _$$VendorApplicationDocumentModelImplToJson(
        _$VendorApplicationDocumentModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'documentType': instance.documentType,
      'status': instance.status,
      'rejectionReason': instance.rejectionReason,
    };

_$VendorApplicationModelImpl _$$VendorApplicationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$VendorApplicationModelImpl(
      id: json['id'] as String,
      ownerId: json['ownerId'] as String,
      name: json['name'] as String,
      status: json['status'] as String? ?? 'DRAFT',
      ownerName: json['ownerName'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      bankAccountNumber: json['bankAccountNumber'] as String?,
      bankIfsc: json['bankIfsc'] as String?,
      bankName: json['bankName'] as String?,
      bankHolderName: json['bankHolderName'] as String?,
      description: json['description'] as String?,
      gstNumber: json['gstNumber'] as String?,
      panNumber: json['panNumber'] as String?,
      addressLine1: json['addressLine1'] as String?,
      addressLine2: json['addressLine2'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      pincode: json['pincode'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      requestedServiceRadiusKm:
          (json['requestedServiceRadiusKm'] as num?)?.toDouble() ?? 5.0,
      approvedServiceRadiusKm:
          (json['approvedServiceRadiusKm'] as num?)?.toDouble(),
      requestedDailyCapacity: (json['requestedDailyCapacity'] as num?)?.toInt(),
      rejectionReason: json['rejectionReason'] as String?,
      correctionSections: (json['correctionSections'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      documents: (json['documents'] as List<dynamic>?)
              ?.map((e) => VendorApplicationDocumentModel.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          const [],
      missingSteps: (json['missingSteps'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$VendorApplicationModelImplToJson(
        _$VendorApplicationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ownerId': instance.ownerId,
      'name': instance.name,
      'status': instance.status,
      'ownerName': instance.ownerName,
      'email': instance.email,
      'phone': instance.phone,
      'bankAccountNumber': instance.bankAccountNumber,
      'bankIfsc': instance.bankIfsc,
      'bankName': instance.bankName,
      'bankHolderName': instance.bankHolderName,
      'description': instance.description,
      'gstNumber': instance.gstNumber,
      'panNumber': instance.panNumber,
      'addressLine1': instance.addressLine1,
      'addressLine2': instance.addressLine2,
      'city': instance.city,
      'state': instance.state,
      'pincode': instance.pincode,
      'lat': instance.lat,
      'lng': instance.lng,
      'requestedServiceRadiusKm': instance.requestedServiceRadiusKm,
      'approvedServiceRadiusKm': instance.approvedServiceRadiusKm,
      'requestedDailyCapacity': instance.requestedDailyCapacity,
      'rejectionReason': instance.rejectionReason,
      'correctionSections': instance.correctionSections,
      'documents': instance.documents,
      'missingSteps': instance.missingSteps,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
