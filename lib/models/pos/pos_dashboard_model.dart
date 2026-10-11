int? _int(Object? v) => v is num ? v.toInt() : null;

/// The tiles on POS Home (`GET /vendor/pos/dashboard` → `data.home`).
///
/// Every field is nullable on purpose: an older backend that does not send a tile gives `null`, and the
/// screen then shows "—". A missing number is never shown as 0.
class PosHomeStats {
  const PosHomeStats({
    this.todayRevenuePaise,
    this.todayCollectionPaise,
    this.collectionDuePaise,
    this.onlineOrderRequests,
    this.washingToStore,
    this.bookingsToday,
    this.deliveriesToday,
    this.deliveredToday,
    this.pendingOrders,
    this.unassignedPickups,
    this.upcomingDeliveries,
    this.unassignedDeliveries,
    this.expressOrders,
  });

  factory PosHomeStats.fromJson(Map<String, dynamic> j) => PosHomeStats(
        todayRevenuePaise: _int(j['todayRevenuePaise']),
        todayCollectionPaise: _int(j['todayCollectionPaise']),
        collectionDuePaise: _int(j['collectionDuePaise']),
        onlineOrderRequests: _int(j['onlineOrderRequests']),
        washingToStore: _int(j['washingToStore']),
        bookingsToday: _int(j['bookingsToday']),
        deliveriesToday: _int(j['deliveriesToday']),
        deliveredToday: _int(j['deliveredToday']),
        pendingOrders: _int(j['pendingOrders']),
        unassignedPickups: _int(j['unassignedPickups']),
        upcomingDeliveries: _int(j['upcomingDeliveries']),
        unassignedDeliveries: _int(j['unassignedDeliveries']),
        expressOrders: _int(j['expressOrders']),
      );

  final int? todayRevenuePaise;
  final int? todayCollectionPaise;
  final int? collectionDuePaise;
  final int? onlineOrderRequests;
  final int? washingToStore;
  final int? bookingsToday;
  final int? deliveriesToday;
  final int? deliveredToday;
  final int? pendingOrders;
  final int? unassignedPickups;
  final int? upcomingDeliveries;
  final int? unassignedDeliveries;
  final int? expressOrders;
}

class PosDashboard {
  const PosDashboard({required this.asOf, required this.home});

  factory PosDashboard.fromJson(Map<String, dynamic> j) {
    final home = j['home'];
    return PosDashboard(
      asOf: j['asOf']?.toString(),
      home: home is Map<String, dynamic> ? PosHomeStats.fromJson(home) : const PosHomeStats(),
    );
  }

  /// `YYYY-MM-DD`, the server's "today".
  final String? asOf;
  final PosHomeStats home;
}
