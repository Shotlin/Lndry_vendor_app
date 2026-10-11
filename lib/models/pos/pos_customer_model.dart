class PosCustomer {
  const PosCustomer({required this.id, required this.name, required this.phone, this.orderCount, this.spentPaise});

  factory PosCustomer.fromJson(Map<String, dynamic> j) => PosCustomer(
        id: j['id'].toString(),
        name: (j['name'] ?? '').toString(),
        phone: (j['phone'] ?? '').toString(),
        orderCount: j['orderCount'] is num ? (j['orderCount'] as num).toInt() : null,
        spentPaise: j['spentPaise'] is num ? (j['spentPaise'] as num).toInt() : null,
      );

  final String id;
  final String name;
  final String phone;
  final int? orderCount;
  final int? spentPaise;

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'phone': phone};

  /// Name, or the phone when the customer has no name yet.
  String get displayName => name.trim().isEmpty ? phone : name;
}
