import 'package:freezed_annotation/freezed_annotation.dart';

part 'vendor_application_model.freezed.dart';
part 'vendor_application_model.g.dart';

/// A single KYC/onboarding document attached to a [VendorApplicationModel].
@freezed
class VendorApplicationDocumentModel with _$VendorApplicationDocumentModel {
  const factory VendorApplicationDocumentModel({
    required String id,
    required String documentType,
    @Default('PENDING') String status,
    String? rejectionReason,
  }) = _VendorApplicationDocumentModel;

  factory VendorApplicationDocumentModel.fromJson(Map<String, dynamic> json) =>
      _$VendorApplicationDocumentModelFromJson(json);
}

/// A vendor's in-progress or submitted onboarding application.
@freezed
class VendorApplicationModel with _$VendorApplicationModel {
  const factory VendorApplicationModel({
    required String id,
    required String ownerId,
    required String name,
    @Default('DRAFT') String status,
    String? ownerName,
    String? email,
    String? phone,
    String? bankAccountNumber,
    String? bankIfsc,
    String? bankName,
    String? bankHolderName,
    String? description,
    String? gstNumber,
    String? panNumber,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? pincode,
    double? lat,
    double? lng,
    @Default(5.0) double requestedServiceRadiusKm,
    double? approvedServiceRadiusKm,
    int? requestedDailyCapacity,
    String? rejectionReason,
    @Default([]) List<String> correctionSections,
    @Default([]) List<VendorApplicationDocumentModel> documents,
    @Default([]) List<String> missingSteps,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _VendorApplicationModel;

  factory VendorApplicationModel.fromJson(Map<String, dynamic> json) =>
      _$VendorApplicationModelFromJson(json);
}
