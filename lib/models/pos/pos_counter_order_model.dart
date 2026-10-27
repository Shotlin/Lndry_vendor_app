import 'pos_customer_model.dart';
import 'pos_order_model.dart';

int _int(Object? v) => v is num ? v.toInt() : 0;
String _str(Object? v) => (v ?? '').toString();
DateTime? _time(Object? v) =>
    v == null ? null : DateTime.tryParse(v.toString())?.toLocal();

/// One garment + service on a saved order, as the server priced it.
class CounterOrderItem {
  const CounterOrderItem(
      {required this.name,
      required this.serviceName,
      required this.unit,
      required this.qty,
      required this.ratePaise,
      required this.amountPaise,
      this.garmentId = '',
      this.serviceId = ''});

  factory CounterOrderItem.fromJson(Map<String, dynamic> j) => CounterOrderItem(
        garmentId: _str(j['garmentId']),
        serviceId: _str(j['serviceId']),
        name: _str(j['name']),
        serviceName: _str(j['serviceName']),
        unit: j['unit'] == null ? 'piece' : _str(j['unit']),
        qty: j['qty'] is num ? (j['qty'] as num) : 0,
        ratePaise: _int(j['ratePaise']),
        amountPaise: _int(j['amountPaise']),
      );

  final String garmentId;
  final String serviceId;
  final String name;
  final String serviceName;
  final String unit;

  /// A count of pieces, or a measure (kg / sq ft) — so not forced to an int.
  final num qty;
  final int ratePaise;
  final int amountPaise;

  /// `3`, or `2.5` — no trailing `.0`.
  String get qtyText => qty == qty.roundToDouble() ? '${qty.toInt()}' : '$qty';
}

/// A captain (the shop's own pickup/delivery person) on an order or in the picker.
class OrderCaptain {
  const OrderCaptain(
      {required this.id, required this.name, required this.phone});
  factory OrderCaptain.fromJson(Map<String, dynamic> j) => OrderCaptain(
      id: _str(j['id']), name: _str(j['name']), phone: _str(j['phone']));

  /// A row of `GET /vendor/employees?role=VENDOR_RIDER` (the team list uses snake_case).
  factory OrderCaptain.fromEmployee(Map<String, dynamic> j) => OrderCaptain(
      id: _str(j['id']),
      name: _str(j['user_name'] ?? j['name']),
      phone: _str(j['user_phone'] ?? j['phone']));

  final String id;
  final String name;
  final String phone;
}

/// A counter order, in the list and in the detail. Every amount is the server's paise.
class CounterOrder {
  const CounterOrder({
    required this.id,
    required this.orderNumber,
    required this.customer,
    required this.items,
    required this.subtotalPaise,
    required this.chargesPaise,
    required this.discountsPaise,
    required this.taxPaise,
    required this.taxRateBps,
    required this.totalPaise,
    required this.amountPaidPaise,
    required this.paymentStatus,
    required this.status,
    required this.deliveryMode,
    required this.isExpress,
    this.version,
    this.paymentMode,
    this.expectedDeliveryDate,
    this.orderDate,
    this.deliveryAddress,
    this.notes,
    this.cancelReason,
    this.pickupCaptain,
    this.deliveryCaptain,
    this.placedAt,
    this.updatedAt,
  });

  factory CounterOrder.fromJson(Map<String, dynamic> j) {
    OrderCaptain? captain(Object? v) =>
        v is Map<String, dynamic> ? OrderCaptain.fromJson(v) : null;
    final c = j['customer'];
    return CounterOrder(
      id: _str(j['id']),
      orderNumber: _str(j['orderNumber']),
      customer: c is Map<String, dynamic>
          ? PosCustomer.fromJson(c)
          : const PosCustomer(id: '', name: '', phone: ''),
      items: (j['items'] is List ? j['items'] as List : const <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .map(CounterOrderItem.fromJson)
          .toList(growable: false),
      subtotalPaise: _int(j['subtotalPaise']),
      chargesPaise: _int(j['chargesPaise']),
      discountsPaise: _int(j['discountsPaise']),
      taxPaise: _int(j['taxPaise']),
      taxRateBps: _int(j['taxRateBps']),
      totalPaise: _int(j['totalPaise']),
      amountPaidPaise: _int(j['amountPaidPaise']),
      paymentStatus: _str(j['paymentStatus']),
      paymentMode: j['paymentMode']?.toString(),
      status: _str(j['status']),
      version: j['version'] is num ? (j['version'] as num).toInt() : null,
      deliveryMode: DeliveryMode.parse(j['deliveryMode']),
      isExpress: j['isExpress'] == true,
      expectedDeliveryDate: j['expectedDeliveryDate']?.toString(),
      orderDate: j['orderDate']?.toString(),
      deliveryAddress: j['deliveryAddress']?.toString(),
      notes: j['notes']?.toString(),
      cancelReason: j['cancelReason']?.toString(),
      pickupCaptain: captain(j['pickupRider']),
      deliveryCaptain: captain(j['deliveryRider']),
      placedAt: _time(j['placedAt']),
      updatedAt: _time(j['updatedAt']),
    );
  }

  final String id;
  final String orderNumber;
  final PosCustomer customer;
  final List<CounterOrderItem> items;
  final int subtotalPaise;
  final int chargesPaise;
  final int discountsPaise;
  final int taxPaise;
  final int taxRateBps;
  final int totalPaise;
  final int amountPaidPaise;

  /// `UNPAID` / `PART_PAID` / `PAID` (the server works it out).
  final String paymentStatus;
  final String? paymentMode;

  /// The backend's status: BOOKED, PICKED_UP, IN_PROCESS, READY, OUT_FOR_DELIVERY, DELIVERED, CANCELLED.
  final String status;
  final int? version;
  final DeliveryMode deliveryMode;
  final bool isExpress;

  /// `YYYY-MM-DD`.
  final String? expectedDeliveryDate;
  final String? orderDate;
  final String? deliveryAddress;
  final String? notes;
  final String? cancelReason;
  final OrderCaptain? pickupCaptain;
  final OrderCaptain? deliveryCaptain;
  final DateTime? placedAt;
  final DateTime? updatedAt;

  /// Still to collect: the server's two numbers subtracted. A cancelled order owes nothing.
  int get balancePaise => status == 'CANCELLED' || totalPaise <= amountPaidPaise
      ? 0
      : totalPaise - amountPaidPaise;
  bool get isPaid => paymentStatus == 'PAID';
  int get pieceCount => items.fold<int>(0, (n, i) => n + i.qty.ceil());
}

/// One recorded payment (`GET …/payments`, also inside the detail).
class OrderPayment {
  const OrderPayment(
      {required this.id,
      required this.amountPaise,
      required this.mode,
      this.reference,
      this.createdAt});
  factory OrderPayment.fromJson(Map<String, dynamic> j) => OrderPayment(
        id: _str(j['id']),
        amountPaise: _int(j['amountPaise']),
        mode: _str(j['mode']),
        reference: j['reference']?.toString(),
        createdAt: _time(j['createdAt']),
      );
  final String id;
  final int amountPaise;

  /// CASH / UPI / CARD / BANK / WALLET.
  final String mode;
  final String? reference;
  final DateTime? createdAt;
}

/// One step in the order's history. The first event has `from == null` (the booking).
class OrderStatusEvent {
  const OrderStatusEvent(
      {required this.id,
      required this.to,
      this.from,
      this.note,
      this.by,
      this.at});
  factory OrderStatusEvent.fromJson(Map<String, dynamic> j) => OrderStatusEvent(
      id: _str(j['id']),
      from: j['from']?.toString(),
      to: _str(j['to']),
      note: j['note']?.toString(),
      by: j['by']?.toString(),
      at: _time(j['at']));
  final String id;
  final String? from;
  final String to;
  final String? note;
  final String? by;
  final DateTime? at;
}

/// A tagged garment of the order (its tag code is what gets printed).
class GarmentUnit {
  const GarmentUnit(
      {required this.id,
      required this.tagCode,
      required this.sequence,
      required this.itemIndex,
      required this.state,
      required this.garmentName});
  factory GarmentUnit.fromJson(Map<String, dynamic> j) => GarmentUnit(
        id: _str(j['id']),
        tagCode: _str(j['tagCode']),
        sequence: _int(j['sequence']),
        itemIndex: _int(j['itemIndex']),
        state: _str(j['state']),
        garmentName: _str(j['garmentName']),
      );
  final String id;
  final String tagCode;
  final int sequence;

  /// Which line of the order this garment belongs to.
  final int itemIndex;

  /// INTAKE, SORTED, PROCESSING, QC, ASSEMBLY, RACKED, DISPATCHED, DELIVERED, CANCELLED, MISSING, REWASH…
  final String state;
  final String garmentName;
}

/// `GET /vendor/counter/orders/:id` — the order with everything behind it.
class OrderDetail {
  const OrderDetail(
      {required this.order,
      required this.history,
      required this.units,
      required this.payments});

  factory OrderDetail.fromJson(Map<String, dynamic> j) {
    List<T> list<T>(Object? raw, T Function(Map<String, dynamic>) f) =>
        (raw is List ? raw : const <dynamic>[])
            .whereType<Map<String, dynamic>>()
            .map(f)
            .toList(growable: false);
    final o = j['order'];
    if (o is! Map<String, dynamic>) {
      throw const FormatException('order missing');
    }
    return OrderDetail(
      order: CounterOrder.fromJson(o),
      history: list(j['history'], OrderStatusEvent.fromJson),
      units: list(j['units'], GarmentUnit.fromJson),
      payments: list(j['payments'], OrderPayment.fromJson),
    );
  }

  final CounterOrder order;
  final List<OrderStatusEvent> history;
  final List<GarmentUnit> units;
  final List<OrderPayment> payments;

  /// When the order reached [status] (the latest such event), if it did.
  DateTime? reachedAt(String status) {
    for (final e in history.reversed) {
      if (e.to == status) return e.at;
    }
    return null;
  }
}

/// The bits of Orders-list filtering the person can pick. `null` = no filter.
class OrderFilter {
  const OrderFilter(
      {this.statuses = const [],
      this.search = '',
      this.from,
      this.to,
      this.deliveryMode,
      this.express = false,
      this.paymentDue = false,
      this.tile});

  /// Backend statuses to include; empty = all.
  final List<String> statuses;
  final String search;

  /// `YYYY-MM-DD` (inclusive) — the day the order was placed.
  final String? from;
  final String? to;
  final DeliveryMode? deliveryMode;
  final bool express;
  final bool paymentDue;

  /// One of the Home tiles (`pendingOrders`, `expressOrders`, …): the server lists exactly the orders that tile counts.
  final String? tile;

  OrderFilter copyWith(
          {List<String>? statuses,
          String? search,
          String? from,
          String? to,
          bool clearDates = false,
          DeliveryMode? deliveryMode,
          bool clearMode = false,
          bool? express,
          bool? paymentDue,
          String? tile,
          bool clearTile = false}) =>
      OrderFilter(
        statuses: statuses ?? this.statuses,
        search: search ?? this.search,
        from: clearDates ? null : (from ?? this.from),
        to: clearDates ? null : (to ?? this.to),
        deliveryMode: clearMode ? null : (deliveryMode ?? this.deliveryMode),
        express: express ?? this.express,
        paymentDue: paymentDue ?? this.paymentDue,
        tile: clearTile ? null : (tile ?? this.tile),
      );

  /// How many of the extra filters (not the tab, not the search text) are on — shown on the Filter button.
  int get activeExtras =>
      (from != null || to != null ? 1 : 0) +
      (deliveryMode != null ? 1 : 0) +
      (express ? 1 : 0) +
      (paymentDue ? 1 : 0);

  Map<String, dynamic> toQuery({required int limit, required int offset}) => {
        if (statuses.isNotEmpty) 'status': statuses.join(','),
        if (search.trim().isNotEmpty) 'search': search.trim(),
        if (from != null) 'from': from,
        if (to != null) 'to': to,
        if (deliveryMode != null) 'deliveryMode': deliveryMode!.wire,
        if (express) 'express': 'true',
        if (paymentDue) 'paymentDue': 'true',
        if (tile != null) 'tile': tile,
        'limit': limit,
        'offset': offset,
      };

  @override
  bool operator ==(Object other) =>
      other is OrderFilter &&
      other.statuses.join(',') == statuses.join(',') &&
      other.search == search &&
      other.from == from &&
      other.to == to &&
      other.deliveryMode == deliveryMode &&
      other.express == express &&
      other.paymentDue == paymentDue &&
      other.tile == tile;

  @override
  int get hashCode => Object.hash(statuses.join(','), search, from, to,
      deliveryMode, express, paymentDue, tile);
}

/// What to send to `PATCH /orders/:id`. Only what changed is sent.
class OrderEdit {
  const OrderEdit(
      {this.expectedDeliveryDate,
      this.deliveryMode,
      this.isExpress,
      this.notes,
      this.deliveryAddress,
      this.items});
  final String? expectedDeliveryDate;
  final DeliveryMode? deliveryMode;
  final bool? isExpress;
  final String? notes;
  final String? deliveryAddress;

  /// The whole new list of garment lines; null leaves the garments alone.
  final List<CartLine>? items;

  bool get isEmpty =>
      expectedDeliveryDate == null &&
      deliveryMode == null &&
      isExpress == null &&
      notes == null &&
      deliveryAddress == null &&
      items == null;

  Map<String, dynamic> toJson() => {
        if (expectedDeliveryDate != null)
          'expectedDeliveryDate': expectedDeliveryDate,
        if (deliveryMode != null) 'deliveryMode': deliveryMode!.wire,
        if (isExpress != null) 'isExpress': isExpress,
        if (notes != null) 'notes': notes,
        if (deliveryAddress != null) 'deliveryAddress': deliveryAddress,
        if (items != null) 'items': [for (final l in items!) l.toJson()],
      };
}

/// What an edited garment list would cost, as the server priced it — nothing is saved by asking.
class OrderEditPreview {
  const OrderEditPreview({
    required this.subtotalPaise,
    required this.chargesPaise,
    required this.discountsPaise,
    required this.taxPaise,
    required this.totalPaise,
    required this.previousTotalPaise,
    required this.amountPaidPaise,
  });

  factory OrderEditPreview.fromJson(Map<String, dynamic> j) => OrderEditPreview(
    subtotalPaise: _int(j['subtotalPaise']),
    chargesPaise: _int(j['chargesPaise']),
    discountsPaise: _int(j['discountsPaise']),
    taxPaise: _int(j['taxPaise']),
    totalPaise: _int(j['totalPaise']),
    previousTotalPaise: _int(j['previousTotalPaise']),
    amountPaidPaise: _int(j['amountPaidPaise']),
  );

  final int subtotalPaise;
  final int chargesPaise;
  final int discountsPaise;
  final int taxPaise;
  final int totalPaise;
  final int previousTotalPaise;
  final int amountPaidPaise;

  int get differencePaise => totalPaise - previousTotalPaise;
}
