import 'pos_customer_model.dart';

/// `GET /vendor/pos/search?q=` — customers, orders and garment tags that match one box of text.
class PosSearchResults {
  const PosSearchResults({this.customers = const [], this.orders = const [], this.garments = const []});

  factory PosSearchResults.fromJson(Map<String, dynamic> j) => PosSearchResults(
        customers: _list(j['customers']).map(PosCustomer.fromJson).toList(growable: false),
        orders: _list(j['orders']).map(SearchOrder.fromJson).toList(growable: false),
        garments: _list(j['garmentUnits']).map(SearchGarment.fromJson).toList(growable: false),
      );

  final List<PosCustomer> customers;
  final List<SearchOrder> orders;
  final List<SearchGarment> garments;

  bool get isEmpty => customers.isEmpty && orders.isEmpty && garments.isEmpty;
}

List<Map<String, dynamic>> _list(Object? v) => v is List ? v.whereType<Map<String, dynamic>>().toList(growable: false) : const [];

class SearchOrder {
  const SearchOrder({required this.id, required this.orderNumber, required this.totalPaise, this.placedAt});

  factory SearchOrder.fromJson(Map<String, dynamic> j) => SearchOrder(
        id: j['id'].toString(),
        orderNumber: (j['orderNumber'] ?? '').toString(),
        totalPaise: j['totalPaise'] is num ? (j['totalPaise'] as num).toInt() : 0,
        placedAt: DateTime.tryParse((j['placedAt'] ?? '').toString())?.toLocal(),
      );

  final String id;
  final String orderNumber;
  final int totalPaise;
  final DateTime? placedAt;
}

/// A garment tag (QR / barcode text) and the order it belongs to.
class SearchGarment {
  const SearchGarment({required this.id, required this.tagCode, required this.state, required this.orderId});

  factory SearchGarment.fromJson(Map<String, dynamic> j) => SearchGarment(
        id: j['id'].toString(),
        tagCode: (j['tagCode'] ?? '').toString(),
        state: (j['state'] ?? '').toString(),
        orderId: (j['orderId'] ?? '').toString(),
      );

  final String id;
  final String tagCode;
  final String state;
  final String orderId;
}
