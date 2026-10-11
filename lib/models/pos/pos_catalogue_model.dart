int? _int(Object? v) => v is num ? v.toInt() : null;
bool _active(Map<String, dynamic> j) => j['active'] != false;

class PosCategory {
  const PosCategory({required this.id, required this.name, this.parentId, this.active = true});
  factory PosCategory.fromJson(Map<String, dynamic> j) =>
      PosCategory(id: j['id'].toString(), name: (j['name'] ?? '').toString(), parentId: j['parentId']?.toString(), active: _active(j));
  final String id;
  final String name;
  final String? parentId;
  final bool active;
}

class PosService {
  const PosService({required this.id, required this.name, this.active = true});
  factory PosService.fromJson(Map<String, dynamic> j) => PosService(id: j['id'].toString(), name: (j['name'] ?? '').toString(), active: _active(j));
  final String id;
  final String name;
  final bool active;
}

/// Units a garment can be priced in (what the backend accepts).
const List<String> kPosUnits = ['piece', 'kg', 'pair', 'sqft'];

class PosGarment {
  const PosGarment({required this.id, required this.name, this.categoryId, this.unit = 'piece', this.active = true});
  factory PosGarment.fromJson(Map<String, dynamic> j) => PosGarment(
        id: j['id'].toString(),
        name: (j['name'] ?? '').toString(),
        categoryId: j['categoryId']?.toString(),
        unit: (j['unit'] ?? 'piece').toString().toLowerCase(),
        active: _active(j),
      );
  final String id;
  final String name;
  final String? categoryId;
  final String unit;
  final bool active;

  /// Pieces and pairs are counted in whole numbers; the stepper adds one either way.
  bool get isCountable => unit == 'piece' || unit == 'pair';
}

class PosPrice {
  const PosPrice({required this.id, required this.garmentId, required this.serviceId, required this.ratePaise, this.customerUserId, this.active = true});
  factory PosPrice.fromJson(Map<String, dynamic> j) => PosPrice(
        id: j['id'].toString(),
        garmentId: j['garmentId'].toString(),
        serviceId: j['serviceId'].toString(),
        ratePaise: _int(j['ratePaise']) ?? 0,
        customerUserId: j['customerUserId']?.toString(),
        active: _active(j),
      );
  final String id;
  final String garmentId;
  final String serviceId;
  final int ratePaise;

  /// A price set for one customer only. The shop-wide price has no customer.
  final String? customerUserId;
  final bool active;
}

class PosTaxRule {
  const PosTaxRule({required this.id, required this.name, required this.rateBps, this.active = true});
  factory PosTaxRule.fromJson(Map<String, dynamic> j) =>
      PosTaxRule(id: j['id'].toString(), name: (j['name'] ?? '').toString(), rateBps: _int(j['rateBps']) ?? 0, active: _active(j));
  final String id;
  final String name;
  final int rateBps;
  final bool active;
}

/// The shop's price list (`GET /vendor/pos-catalogue`).
class PosCatalogue {
  const PosCatalogue({this.categories = const [], this.services = const [], this.garments = const [], this.prices = const [], this.taxRules = const []});

  factory PosCatalogue.fromJson(Map<String, dynamic> j) {
    List<T> list<T>(String key, T Function(Map<String, dynamic>) f) =>
        (j[key] is List ? (j[key] as List) : const <dynamic>[]).whereType<Map<String, dynamic>>().map(f).toList(growable: false);
    return PosCatalogue(
      categories: list('categories', PosCategory.fromJson),
      services: list('services', PosService.fromJson),
      garments: list('garments', PosGarment.fromJson),
      prices: list('prices', PosPrice.fromJson),
      taxRules: list('taxRules', PosTaxRule.fromJson),
    );
  }

  final List<PosCategory> categories;
  final List<PosService> services;
  final List<PosGarment> garments;
  final List<PosPrice> prices;
  final List<PosTaxRule> taxRules;

  List<PosService> get activeServices => services.where((s) => s.active).toList(growable: false);
  List<PosCategory> get activeCategories => categories.where((c) => c.active).toList(growable: false);
  List<PosTaxRule> get activeTaxRules => taxRules.where((t) => t.active).toList(growable: false);

  PosGarment? garment(String id) {
    for (final g in garments) {
      if (g.id == id) return g;
    }
    return null;
  }

  PosService? service(String id) {
    for (final s in services) {
      if (s.id == id) return s;
    }
    return null;
  }

  /// The shop-wide price of (garment, service); `null` when the shop has none. Customer-specific prices
  /// are applied by the server, so they are not shown here.
  PosPrice? priceOf(String garmentId, String serviceId) {
    for (final p in prices) {
      if (p.active && p.customerUserId == null && p.garmentId == garmentId && p.serviceId == serviceId) return p;
    }
    return null;
  }

  /// Garments that can be sold with [serviceId] (they have a shop-wide price for it), narrowed by
  /// category (a parent category includes its children) and by a name search.
  List<PosGarment> garmentsFor({required String? serviceId, String? categoryId, String search = ''}) {
    if (serviceId == null) return const [];
    final needle = search.trim().toLowerCase();
    final inCategory = <String>{
      if (categoryId != null) categoryId,
      if (categoryId != null) ...categories.where((c) => c.parentId == categoryId).map((c) => c.id),
    };
    return garments.where((g) {
      if (!g.active) return false;
      if (priceOf(g.id, serviceId) == null) return false;
      if (categoryId != null && !inCategory.contains(g.categoryId)) return false;
      return needle.isEmpty || g.name.toLowerCase().contains(needle);
    }).toList(growable: false);
  }
}

/// A charge or a discount the shop saved (`/vendor/adjustment-rules/charge|discount`).
class PosAdjustmentRule {
  const PosAdjustmentRule({required this.id, required this.name, required this.isPercentage, this.flatPaise, this.percentageBps, this.active = true});
  factory PosAdjustmentRule.fromJson(Map<String, dynamic> j) => PosAdjustmentRule(
        id: j['id'].toString(),
        name: (j['name'] ?? '').toString(),
        isPercentage: (j['type'] ?? '').toString().toUpperCase() == 'PERCENTAGE',
        flatPaise: _int(j['flatAmountPaise']),
        percentageBps: _int(j['percentageBps']),
        active: _active(j),
      );
  final String id;
  final String name;
  final bool isPercentage;
  final int? flatPaise;
  final int? percentageBps;
  final bool active;
}
