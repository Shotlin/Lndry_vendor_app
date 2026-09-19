/// One operational supply (detergent, hangers, …) as the server holds it.
///
/// The server is the single source of truth: the quantity, unit and minimum
/// limit here are always whatever the backend last returned.
class InventoryItem {
  const InventoryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.minThreshold,
    required this.unit,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) => InventoryItem(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        quantity: (json['quantity'] as num?)?.toInt() ?? 0,
        minThreshold: (json['minThreshold'] as num?)?.toInt() ?? 0,
        unit: json['unit'] as String? ?? '',
      );

  final String id;
  final String name;
  final int quantity;
  final int minThreshold;
  final String unit;

  bool get isLowStock => quantity <= minThreshold;

  InventoryItem copyWith({int? quantity}) => InventoryItem(
        id: id,
        name: name,
        quantity: quantity ?? this.quantity,
        minThreshold: minThreshold,
        unit: unit,
      );
}
