import 'dart:async';
import 'dart:typed_data';

import 'package:lndry_vendor_app/core/network/api_exception.dart';
import 'package:lndry_vendor_app/models/pos/pos_catalogue_model.dart';
import 'package:lndry_vendor_app/models/pos/pos_counter_order_model.dart';
import 'package:lndry_vendor_app/models/pos/pos_customer_model.dart';
import 'package:lndry_vendor_app/models/pos/pos_dashboard_model.dart';
import 'package:lndry_vendor_app/models/pos/pos_order_model.dart';
import 'package:lndry_vendor_app/repositories/abstract/pos_repositories.dart';

/// A tiny price list: 2 garments × 2 services (Shirt 80/30, Saree 150/—).
PosCatalogue sampleCatalogue({List<PosTaxRule> tax = const []}) => PosCatalogue(
      categories: const [
        PosCategory(id: 'c-men', name: 'Men'),
        PosCategory(id: 'c-women', name: 'Women')
      ],
      services: const [
        PosService(id: 's-dry', name: 'Dry Cleaning'),
        PosService(id: 's-wash', name: 'Wash & Fold')
      ],
      garments: const [
        PosGarment(id: 'g-shirt', name: 'Shirt', categoryId: 'c-men'),
        PosGarment(id: 'g-saree', name: 'Saree', categoryId: 'c-women'),
      ],
      prices: const [
        PosPrice(
            id: 'p1',
            garmentId: 'g-shirt',
            serviceId: 's-dry',
            ratePaise: 8000),
        PosPrice(
            id: 'p2',
            garmentId: 'g-shirt',
            serviceId: 's-wash',
            ratePaise: 3000),
        PosPrice(
            id: 'p3',
            garmentId: 'g-saree',
            serviceId: 's-dry',
            ratePaise: 15000),
      ],
      taxRules: tax,
    );

const sampleCustomer =
    PosCustomer(id: 'u-1', name: 'Asha Verma', phone: '9811122233');

/// Prices the way the real server does for these two garments, so tests can compare totals.
PosQuote priceLikeServer(OrderRequest r,
    {int chargePaise = 0, int discountPaise = 0, int taxBps = 0}) {
  final cat = sampleCatalogue();
  final lines = <QuoteLine>[];
  var subtotal = 0;
  for (final l in r.lines) {
    final price = cat.priceOf(l.garmentId, l.serviceId)!;
    final amount = (price.ratePaise * l.qty).round();
    subtotal += amount;
    lines.add(QuoteLine(
      garmentId: l.garmentId,
      serviceId: l.serviceId,
      name: cat.garment(l.garmentId)!.name,
      serviceName: cat.service(l.serviceId)!.name,
      unit: 'piece',
      qty: l.qty,
      ratePaise: price.ratePaise,
      amountPaise: amount,
    ));
  }
  final taxable = subtotal + chargePaise - discountPaise;
  final tax = (taxable * taxBps / 10000).round();
  return PosQuote(
    lines: lines,
    subtotalPaise: subtotal,
    chargesPaise: chargePaise,
    discountsPaise: discountPaise,
    taxPaise: tax,
    taxRateBps: taxBps,
    totalPaise: taxable + tax,
  );
}

class FakeCounterRepo implements PosCounterRepository {
  final List<OrderRequest> quoteRequests = [];
  final List<({OrderRequest request, String key})> bookCalls = [];
  final List<String> customerSearches = [];

  /// Override to control a quote (e.g. return a [Completer]'s future to finish it later).
  Future<PosQuote> Function(OrderRequest r)? onQuote;
  Future<BookedOrder> Function(OrderRequest r, String key)? onBook;
  List<PosCustomer> customers = const [sampleCustomer];
  Object? createError;

  @override
  Future<PosQuote> quote(OrderRequest request) {
    quoteRequests.add(request);
    return onQuote != null
        ? onQuote!(request)
        : Future.value(priceLikeServer(request));
  }

  @override
  Future<BookedOrder> book(OrderRequest request,
      {required String idempotencyKey}) {
    bookCalls.add((request: request, key: idempotencyKey));
    if (onBook != null) return onBook!(request, idempotencyKey);
    final q = priceLikeServer(request);
    return Future.value(BookedOrder(
      id: 'o-1',
      orderNumber: 'LND-261011-TEST',
      totalPaise: q.totalPaise,
      amountPaidPaise:
          request.paymentMode == PosPaymentMode.payLater ? 0 : q.totalPaise,
      paymentStatus:
          request.paymentMode == PosPaymentMode.payLater ? 'UNPAID' : 'PAID',
      status: 'BOOKED',
      customer: sampleCustomer,
      deliveryMode: request.deliveryMode,
      isExpress: request.isExpress,
      expectedDeliveryDate: request.expectedDeliveryDate,
    ));
  }

  @override
  Future<List<PosCustomer>> searchCustomers(String search) async {
    customerSearches.add(search);
    final n = search.toLowerCase();
    return customers
        .where((c) =>
            n.isEmpty ||
            c.name.toLowerCase().contains(n) ||
            c.phone.contains(n))
        .toList();
  }

  @override
  Future<PosCustomer> createCustomer(
      {required String name, required String phone}) async {
    if (createError != null) throw createError!;
    return PosCustomer(id: 'u-new', name: name, phone: phone);
  }
}

class FakeDashboardRepo implements PosDashboardRepository {
  FakeDashboardRepo([this.result]);
  PosDashboard? result;
  Object? error;
  Completer<PosDashboard>? gate;
  int calls = 0;

  @override
  Future<PosDashboard> getDashboard() async {
    calls++;
    if (gate != null) return gate!.future;
    if (error != null) throw error!;
    return result ??
        const PosDashboard(asOf: '2026-10-11', home: PosHomeStats());
  }
}

class FakeCatalogueRepo implements PosCatalogueRepository {
  FakeCatalogueRepo({PosCatalogue? catalogue})
      : catalogue = catalogue ?? sampleCatalogue();
  PosCatalogue catalogue;
  Object? loadError;
  List<PosAdjustmentRule> charges = const [];
  List<PosAdjustmentRule> discounts = const [];
  final List<String> calls = [];
  Object? priceError;

  @override
  Future<PosCatalogue> getCatalogue() async {
    calls.add('get');
    if (loadError != null) throw loadError!;
    return catalogue;
  }

  @override
  Future<PosCategory> createCategory(String name) async {
    calls.add('category:$name');
    return PosCategory(id: 'c-new-$name', name: name);
  }

  @override
  Future<PosService> createService(String name) async {
    calls.add('service:$name');
    return PosService(id: 's-new-$name', name: name);
  }

  @override
  Future<PosGarment> createGarment(
      {required String name, required String unit, String? categoryId}) async {
    calls.add('garment:$name:$unit:$categoryId');
    return PosGarment(
        id: 'g-new-$name', name: name, categoryId: categoryId, unit: unit);
  }

  @override
  Future<PosPrice> createPrice(
      {required String garmentId,
      required String serviceId,
      required int ratePaise}) async {
    calls.add('price:$garmentId:$serviceId:$ratePaise');
    if (priceError != null) throw priceError!;
    return PosPrice(
        id: 'p-new',
        garmentId: garmentId,
        serviceId: serviceId,
        ratePaise: ratePaise);
  }

  @override
  Future<PosPrice> updatePrice(
      {required String priceId, required int ratePaise}) async {
    calls.add('update:$priceId:$ratePaise');
    return PosPrice(
        id: priceId, garmentId: 'g', serviceId: 's', ratePaise: ratePaise);
  }

  @override
  Future<List<PosAdjustmentRule>> listRules(String kind) async =>
      kind == 'charge' ? charges : discounts;
}

// ── Orders ────────────────────────────────────────────────────────────────

/// A counter order with sensible defaults; override what the test is about.
CounterOrder makeOrder({
  String id = 'o-1',
  String number = 'LND-261011-AAAA',
  String status = 'BOOKED',
  int total = 16000,
  int paid = 0,
  String? paymentStatus,
  DeliveryMode mode = DeliveryMode.walkIn,
  bool express = false,
  PosCustomer customer = sampleCustomer,
  String? expected = '2026-10-13',
  String? notes,
  int version = 1,
  OrderCaptain? pickup,
  OrderCaptain? delivery,
  String? cancelReason,
  List<CounterOrderItem>? items,
}) =>
    CounterOrder(
      id: id,
      orderNumber: number,
      customer: customer,
      items: items ??
          const [
            CounterOrderItem(
                name: 'Shirt',
                serviceName: 'Dry Cleaning',
                unit: 'piece',
                qty: 2,
                ratePaise: 8000,
                amountPaise: 16000)
          ],
      subtotalPaise: total,
      chargesPaise: 0,
      discountsPaise: 0,
      taxPaise: 0,
      taxRateBps: 0,
      totalPaise: total,
      amountPaidPaise: paid,
      paymentStatus: paymentStatus ??
          (paid <= 0 ? 'UNPAID' : (paid >= total ? 'PAID' : 'PART_PAID')),
      status: status,
      version: version,
      deliveryMode: mode,
      isExpress: express,
      expectedDeliveryDate: expected,
      notes: notes,
      cancelReason: cancelReason,
      pickupCaptain: pickup,
      deliveryCaptain: delivery,
      placedAt: DateTime.utc(2026, 10, 11, 9, 30),
      updatedAt: DateTime.utc(2026, 10, 11, 9, 30),
    );

OrderDetail makeDetail(
  CounterOrder o, {
  List<OrderStatusEvent>? history,
  List<GarmentUnit>? units,
  List<OrderPayment>? payments,
}) =>
    OrderDetail(
      order: o,
      history: history ??
          [
            OrderStatusEvent(
                id: 'e1', to: 'BOOKED', at: DateTime.utc(2026, 10, 11, 9, 30))
          ],
      units: units ??
          const [
            GarmentUnit(
                id: 'u1',
                tagCode: 'ELT-1-AAAA',
                sequence: 1,
                itemIndex: 0,
                state: 'INTAKE',
                garmentName: 'Shirt'),
            GarmentUnit(
                id: 'u2',
                tagCode: 'ELT-1-BBBB',
                sequence: 2,
                itemIndex: 0,
                state: 'INTAKE',
                garmentName: 'Shirt'),
          ],
      payments: payments ??
          (o.amountPaidPaise > 0
              ? [
                  OrderPayment(
                      id: 'p1',
                      amountPaise: o.amountPaidPaise,
                      mode: 'CASH',
                      createdAt: DateTime.utc(2026, 10, 11, 10))
                ]
              : const []),
    );

ApiException apiError(String code, String message, {int status = 409}) =>
    ApiException(message: message, statusCode: status, code: code);

/// An orders repository whose answers a test scripts. Orders live in [orders]; actions change them like the server does.
class FakeOrdersRepo implements PosOrdersRepository {
  FakeOrdersRepo({List<CounterOrder>? orders}) : orders = orders ?? [];
  List<CounterOrder> orders;
  final Map<String, OrderDetail> details = {};
  final List<OrderFilter> listCalls = [];
  final List<({int limit, int offset})> pages = [];
  final List<String> calls = [];
  final List<
      ({
        String id,
        String state,
        bool incomplete,
        bool unpaid,
        int? version
      })> transitions = [];
  final List<({String id, int amount, String mode, String? ref})> payments = [];
  final List<({String id, String reason})> cancels = [];
  final List<({String id, OrderEdit edit})> edits = [];
  List<OrderCaptain> captains = const [];
  List<GarmentUnit> units = const [];
  Object? listError;
  Object? detailError;

  /// Return an error to throw for a transition / payment, or `null` to let it work.
  Object? Function(String id, String state, bool incomplete, bool unpaid)?
      onTransition;
  Object? Function(String id, int amount)? onPay;
  Completer<void>? gate;

  /// Filters the way the server does for the parts the tests use (status list, search, express, paymentDue, paging).
  @override
  Future<List<CounterOrder>> listOrders(OrderFilter f,
      {int limit = 30, int offset = 0}) async {
    listCalls.add(f);
    pages.add((limit: limit, offset: offset));
    if (listError != null) throw listError!;
    var r = orders
        .where((o) => f.statuses.isEmpty || f.statuses.contains(o.status));
    if (f.express) r = r.where((o) => o.isExpress);
    if (f.paymentDue) r = r.where((o) => o.balancePaise > 0);
    if (f.search.isNotEmpty) {
      final n = f.search.toLowerCase();
      r = r.where((o) =>
          o.orderNumber.toLowerCase().contains(n) ||
          o.customer.name.toLowerCase().contains(n) ||
          o.customer.phone.contains(n));
    }
    return r.skip(offset).take(limit).toList();
  }

  @override
  Future<OrderDetail> getOrder(String id) async {
    calls.add('get:$id');
    if (detailError != null) throw detailError!;
    final order = orders.firstWhere((o) => o.id == id);
    return details[id] != null && details[id]!.order.version == order.version
        ? details[id]!
        : makeDetail(order, units: units.isEmpty ? null : units);
  }

  void _replace(CounterOrder o) =>
      orders = [for (final x in orders) x.id == o.id ? o : x];
  CounterOrder _get(String id) => orders.firstWhere((o) => o.id == id);

  CounterOrder _copy(CounterOrder o,
          {String? status,
          int? paid,
          int? version,
          String? cancelReason,
          DeliveryMode? mode,
          bool? express,
          String? notes,
          String? expected,
          OrderCaptain? pickup,
          OrderCaptain? delivery}) =>
      makeOrder(
        id: o.id,
        number: o.orderNumber,
        status: status ?? o.status,
        total: o.totalPaise,
        paid: paid ?? o.amountPaidPaise,
        mode: mode ?? o.deliveryMode,
        express: express ?? o.isExpress,
        customer: o.customer,
        expected: expected ?? o.expectedDeliveryDate,
        notes: notes ?? o.notes,
        version: version ?? (o.version ?? 0) + 1,
        pickup: pickup ?? o.pickupCaptain,
        delivery: delivery ?? o.deliveryCaptain,
        cancelReason: cancelReason ?? o.cancelReason,
        items: o.items,
      );

  @override
  Future<CounterOrder> transition(String id, String state,
      {bool allowIncomplete = false,
      bool allowUnpaid = false,
      int? version}) async {
    transitions.add((
      id: id,
      state: state,
      incomplete: allowIncomplete,
      unpaid: allowUnpaid,
      version: version
    ));
    if (gate != null) await gate!.future;
    final err = onTransition?.call(id, state, allowIncomplete, allowUnpaid);
    if (err != null) throw err;
    final next = _copy(_get(id), status: state);
    _replace(next);
    return next;
  }

  @override
  Future<({CounterOrder order, List<OrderPayment> payments})> collectPayment(
      String id,
      {required int amountPaise,
      required String mode,
      String? reference}) async {
    payments.add((id: id, amount: amountPaise, mode: mode, ref: reference));
    if (gate != null) await gate!.future;
    final err = onPay?.call(id, amountPaise);
    if (err != null) throw err;
    final o = _get(id);
    if (amountPaise > o.balancePaise) {
      throw apiError(
          'OVERPAYMENT', 'Only ${o.balancePaise} is outstanding on this order',
          status: 400);
    }
    final next = _copy(o, paid: o.amountPaidPaise + amountPaise);
    _replace(next);
    return (
      order: next,
      payments: [
        OrderPayment(id: 'p-new', amountPaise: amountPaise, mode: mode)
      ]
    );
  }

  @override
  Future<CounterOrder> cancel(String id, String reason) async {
    cancels.add((id: id, reason: reason));
    final next = _copy(_get(id), status: 'CANCELLED', cancelReason: reason);
    _replace(next);
    return next;
  }

  @override
  Future<CounterOrder> updateOrder(String id, OrderEdit edit,
      {int? version}) async {
    edits.add((id: id, edit: edit));
    final next = _copy(_get(id),
        mode: edit.deliveryMode,
        express: edit.isExpress,
        notes: edit.notes,
        expected: edit.expectedDeliveryDate);
    _replace(next);
    return next;
  }

  final List<({String id, String? pickup, String? delivery})> assigns = [];

  @override
  Future<CounterOrder> assignCaptain(String id,
      {String? pickupCaptainId, String? deliveryCaptainId}) async {
    assigns.add((id: id, pickup: pickupCaptainId, delivery: deliveryCaptainId));
    OrderCaptain? find(String? cid) =>
        cid == null ? null : captains.firstWhere((c) => c.id == cid);
    final next = _copy(_get(id),
        pickup: find(pickupCaptainId), delivery: find(deliveryCaptainId));
    _replace(next);
    return next;
  }

  @override
  Future<List<OrderCaptain>> listCaptains() async => captains;

  final List<String> printJobs = [];
  @override
  Future<String?> createTagPrintJob(
      String orderId, List<String> garmentUnitIds) async {
    printJobs.add('create:$orderId:${garmentUnitIds.length}');
    return 'job-1';
  }

  @override
  Future<void> markPrintJobPrinted(String jobId) async =>
      printJobs.add('printed:$jobId');

  Object? pdfError;
  final List<String> pdfCalls = [];
  PosPdf _pdf(String name) => PosPdf(
      bytes: Uint8List.fromList('%PDF-1.4 test'.codeUnits), fileName: name);

  @override
  Future<PosPdf> invoicePdf(String id) async {
    pdfCalls.add('invoice:$id');
    if (pdfError != null) throw pdfError!;
    return _pdf('Invoice-$id.pdf');
  }

  @override
  Future<PosPdf> miniBillPdf(String id, {int paperMm = 80}) async {
    pdfCalls.add('mini:$id:$paperMm');
    if (pdfError != null) throw pdfError!;
    return _pdf('Bill-$id-$paperMm.pdf');
  }
}
