import 'pos_customer_model.dart';

int _int(Object? v) => v is num ? v.toInt() : 0;

/// How the order reaches the customer. Backend `store_orders.delivery_mode`.
enum DeliveryMode {
  walkIn('WALK_IN'),
  homeDelivery('HOME_DELIVERY'),
  pickup('PICKUP');

  const DeliveryMode(this.wire);
  final String wire;

  static DeliveryMode parse(Object? v) {
    final s = v?.toString().toUpperCase();
    for (final m in DeliveryMode.values) {
      if (m.wire == s) return m;
    }
    return DeliveryMode.walkIn;
  }
}

/// How the customer pays when the order is saved. The word on screen for [online] is "Online"
/// (the backend calls it UPI).
enum PosPaymentMode {
  cash('CASH'),
  online('UPI'),
  wallet('WALLET'),
  payLater('PAY_LATER');

  const PosPaymentMode(this.wire);
  final String wire;

  static PosPaymentMode parse(Object? v) {
    final s = v?.toString().toUpperCase();
    for (final m in PosPaymentMode.values) {
      if (m.wire == s) return m;
    }
    return PosPaymentMode.payLater;
  }
}

/// One garment + service in the cart. Only the quantity is the app's; the price comes from the server.
class CartLine {
  const CartLine({required this.garmentId, required this.serviceId, required this.qty});
  factory CartLine.fromJson(Map<String, dynamic> j) =>
      CartLine(garmentId: j['garmentId'].toString(), serviceId: j['serviceId'].toString(), qty: _int(j['qty']));

  final String garmentId;
  final String serviceId;
  final int qty;

  CartLine withQty(int q) => CartLine(garmentId: garmentId, serviceId: serviceId, qty: q);
  bool matches(String g, String s) => garmentId == g && serviceId == s;
  Map<String, dynamic> toJson() => {'garmentId': garmentId, 'serviceId': serviceId, 'qty': qty};
}

/// A priced line, as the server computed it.
class QuoteLine {
  const QuoteLine({
    required this.garmentId,
    required this.serviceId,
    required this.name,
    required this.serviceName,
    required this.unit,
    required this.qty,
    required this.ratePaise,
    required this.amountPaise,
  });
  factory QuoteLine.fromJson(Map<String, dynamic> j) => QuoteLine(
        garmentId: j['garmentId'].toString(),
        serviceId: j['serviceId'].toString(),
        name: (j['name'] ?? '').toString(),
        serviceName: (j['serviceName'] ?? '').toString(),
        unit: (j['unit'] ?? 'piece').toString(),
        qty: _int(j['qty']),
        ratePaise: _int(j['ratePaise']),
        amountPaise: _int(j['amountPaise']),
      );
  final String garmentId;
  final String serviceId;
  final String name;
  final String serviceName;
  final String unit;
  final int qty;
  final int ratePaise;
  final int amountPaise;
}

/// A charge or discount line of the bill, e.g. "Discount (10%)" 800.
class QuoteAdjustment {
  const QuoteAdjustment({required this.label, required this.amountPaise});
  factory QuoteAdjustment.fromJson(Map<String, dynamic> j) => QuoteAdjustment(label: (j['label'] ?? '').toString(), amountPaise: _int(j['amountPaise']));
  final String label;
  final int amountPaise;
}

/// The server's price for the cart. Every amount is paise and is shown exactly as received.
class PosQuote {
  const PosQuote({
    required this.lines,
    required this.subtotalPaise,
    required this.chargesPaise,
    required this.discountsPaise,
    required this.taxPaise,
    required this.taxRateBps,
    required this.totalPaise,
    this.charges = const [],
    this.discounts = const [],
  });

  factory PosQuote.fromJson(Map<String, dynamic> j) {
    List<QuoteAdjustment> adj(Object? raw) =>
        (raw is List ? raw : const <dynamic>[]).whereType<Map<String, dynamic>>().map(QuoteAdjustment.fromJson).toList(growable: false);
    final breakdown = j['breakdown'] is Map<String, dynamic> ? j['breakdown'] as Map<String, dynamic> : const <String, dynamic>{};
    return PosQuote(
      lines: (j['items'] is List ? j['items'] as List : const <dynamic>[]).whereType<Map<String, dynamic>>().map(QuoteLine.fromJson).toList(growable: false),
      subtotalPaise: _int(j['subtotalPaise']),
      chargesPaise: _int(j['chargesPaise']),
      discountsPaise: _int(j['discountsPaise']),
      taxPaise: _int(j['taxPaise']),
      taxRateBps: _int(j['taxRateBps']),
      totalPaise: _int(j['totalPaise']),
      charges: adj(breakdown['charges']),
      discounts: adj(breakdown['discounts']),
    );
  }

  final List<QuoteLine> lines;
  final int subtotalPaise;
  final int chargesPaise;
  final int discountsPaise;
  final int taxPaise;
  final int taxRateBps;
  final int totalPaise;
  final List<QuoteAdjustment> charges;
  final List<QuoteAdjustment> discounts;

  QuoteLine? lineFor(String garmentId, String serviceId) {
    for (final l in lines) {
      if (l.garmentId == garmentId && l.serviceId == serviceId) return l;
    }
    return null;
  }
}

/// Everything the server needs to price (and later book) a cart.
class OrderRequest {
  const OrderRequest({
    required this.lines,
    this.customerId,
    this.expectedDeliveryDate,
    this.deliveryMode = DeliveryMode.walkIn,
    this.isExpress = false,
    this.paymentMode = PosPaymentMode.payLater,
    this.notes = '',
    this.chargeRuleIds = const [],
    this.discountRuleIds = const [],
    this.taxRatePercent,
  });

  final List<CartLine> lines;
  final String? customerId;
  final String? expectedDeliveryDate;
  final DeliveryMode deliveryMode;
  final bool isExpress;
  final PosPaymentMode paymentMode;
  final String notes;
  final List<String> chargeRuleIds;
  final List<String> discountRuleIds;

  /// The GST rate the owner picked (e.g. 18), passed through to the server. The app never applies it.
  final num? taxRatePercent;

  Map<String, dynamic> toJson() => {
        'items': [for (final l in lines) l.toJson()],
        if (customerId != null) 'customer': {'id': customerId},
        if (expectedDeliveryDate != null) 'expectedDeliveryDate': expectedDeliveryDate,
        'deliveryMode': deliveryMode.wire,
        'isExpress': isExpress,
        'paymentMode': paymentMode.wire,
        if (notes.trim().isNotEmpty) 'notes': notes.trim(),
        if (chargeRuleIds.isNotEmpty) 'chargeRuleIds': chargeRuleIds,
        if (discountRuleIds.isNotEmpty) 'discountRuleIds': discountRuleIds,
        if (taxRatePercent != null && taxRatePercent! > 0) 'taxRatePercent': taxRatePercent,
      };

  /// What the server prices: the cart and the rules. Delivery date, payment and remarks do not change the
  /// price, so changing them must not trigger a new quote.
  String get priceKey {
    final lines = [for (final l in this.lines) '${l.garmentId}:${l.serviceId}:${l.qty}']..sort();
    final c = [...chargeRuleIds]..sort();
    final d = [...discountRuleIds]..sort();
    return '${customerId ?? '-'}|${lines.join(',')}|${c.join(',')}|${d.join(',')}|${taxRatePercent ?? 0}';
  }
}

/// The order the server created (the booking response).
class BookedOrder {
  const BookedOrder({
    required this.id,
    required this.orderNumber,
    required this.totalPaise,
    required this.amountPaidPaise,
    required this.paymentStatus,
    required this.status,
    required this.customer,
    this.deliveryMode = DeliveryMode.walkIn,
    this.isExpress = false,
    this.expectedDeliveryDate,
  });

  factory BookedOrder.fromJson(Map<String, dynamic> j) {
    final c = j['customer'];
    return BookedOrder(
      id: j['id'].toString(),
      orderNumber: (j['orderNumber'] ?? '').toString(),
      totalPaise: _int(j['totalPaise']),
      amountPaidPaise: _int(j['amountPaidPaise']),
      paymentStatus: (j['paymentStatus'] ?? '').toString(),
      status: (j['status'] ?? '').toString(),
      customer: c is Map<String, dynamic> ? PosCustomer.fromJson(c) : const PosCustomer(id: '', name: '', phone: ''),
      deliveryMode: DeliveryMode.parse(j['deliveryMode']),
      isExpress: j['isExpress'] == true,
      expectedDeliveryDate: j['expectedDeliveryDate']?.toString(),
    );
  }

  final String id;
  final String orderNumber;
  final int totalPaise;
  final int amountPaidPaise;
  final String paymentStatus;
  final String status;
  final PosCustomer customer;
  final DeliveryMode deliveryMode;
  final bool isExpress;
  final String? expectedDeliveryDate;

  /// Still to collect (both numbers are the server's).
  int get balancePaise => totalPaise > amountPaidPaise ? totalPaise - amountPaidPaise : 0;
  bool get isPaid => paymentStatus == 'PAID';
}
