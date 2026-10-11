import 'pos_counter_order_model.dart';
import 'pos_customer_model.dart';

/// `GET /vendor/counter/customers/:id` — one customer with their orders and what they still owe.
class PosCustomerDetail {
  const PosCustomerDetail({required this.customer, this.orders = const [], this.ledgerBalancePaise, this.notes = '', this.servicePreferences = '', this.preferredContact, this.addresses = const []});

  factory PosCustomerDetail.fromJson(Map<String, dynamic> j) {
    final c = j['customer'];
    if (c is! Map<String, dynamic>) throw const FormatException('customer missing');
    final orders = j['orders'];
    final addresses = j['addresses'];
    return PosCustomerDetail(
      customer: PosCustomer.fromJson(c),
      orders: orders is List ? orders.whereType<Map<String, dynamic>>().map(CounterOrder.fromJson).toList(growable: false) : const [],
      ledgerBalancePaise: j['ledgerBalancePaise'] is num ? (j['ledgerBalancePaise'] as num).toInt() : null,
      notes: (j['notes'] ?? '').toString(),
      servicePreferences: (j['servicePreferences'] ?? '').toString(),
      preferredContact: j['preferredContact']?.toString(),
      addresses: addresses is List ? addresses.whereType<Map<String, dynamic>>().map(CustomerAddress.fromJson).toList(growable: false) : const [],
    );
  }

  final PosCustomer customer;
  final List<CounterOrder> orders;

  /// What the ledger says the customer owes (`null` if the server did not send it).
  final int? ledgerBalancePaise;
  final String notes;
  final String servicePreferences;
  final String? preferredContact;
  final List<CustomerAddress> addresses;

  /// Orders that still have a balance to collect (not cancelled). The sum is worked out from the server's per-order balances.
  List<CounterOrder> get ordersWithDue => orders.where((o) => o.balancePaise > 0 && o.status != 'CANCELLED').toList(growable: false);
}

class CustomerAddress {
  const CustomerAddress({required this.id, required this.line, this.label = '', this.isDefault = false});
  factory CustomerAddress.fromJson(Map<String, dynamic> j) {
    final parts = <String>[for (final k in ['addressLine1', 'addressLine2', 'landmark', 'city', 'pincode']) if ((j[k] ?? '').toString().trim().isNotEmpty) j[k].toString().trim()];
    return CustomerAddress(id: j['id'].toString(), line: parts.join(', '), label: (j['label'] ?? '').toString(), isDefault: j['isDefault'] == true);
  }
  final String id;
  final String line;
  final String label;
  final bool isDefault;
}
