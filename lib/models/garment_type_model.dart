/// An admin-published subcategory (e.g. "Wash & Fold") under a service
/// category. Read-only from the vendor's perspective — only admin can
/// create/edit/delete these; a vendor can only pick one and set their own
/// price for it (see [GarmentRateUpsertItem] in the vendor repository).
class GarmentTypeModel {
  const GarmentTypeModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.unit,
    this.demoPrice,
    this.thumbnailUrl,
    this.isActive = true,
  });

  final String id;
  final String name;
  final String categoryId;
  final String unit;
  /// Admin's reference/demo price — shown to the vendor as a suggestion
  /// only. Never enforced; the vendor's own rate lives in vendor_service_rates.
  final double? demoPrice;
  final String? thumbnailUrl;
  final bool isActive;

  factory GarmentTypeModel.fromJson(Map<String, dynamic> json) {
    double? toDouble(dynamic val) {
      if (val == null) return null;
      if (val is num) return val.toDouble();
      if (val is String) return double.tryParse(val);
      return null;
    }

    return GarmentTypeModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      categoryId: json['category_id'] as String? ?? '',
      unit: json['unit'] as String? ?? 'piece',
      demoPrice: toDouble(json['cost_price']),
      thumbnailUrl: json['thumbnail_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}
