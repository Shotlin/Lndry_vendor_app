import 'dart:async';

import 'package:lndry_vendor_app/models/pos/pos_catalogue_model.dart';
import 'package:lndry_vendor_app/models/pos/pos_customer_model.dart';
import 'package:lndry_vendor_app/models/pos/pos_dashboard_model.dart';
import 'package:lndry_vendor_app/models/pos/pos_order_model.dart';
import 'package:lndry_vendor_app/repositories/abstract/pos_repositories.dart';

/// A tiny price list: 2 garments × 2 services (Shirt 80/30, Saree 150/—).
PosCatalogue sampleCatalogue({List<PosTaxRule> tax = const []}) => PosCatalogue(
      categories: const [PosCategory(id: 'c-men', name: 'Men'), PosCategory(id: 'c-women', name: 'Women')],
      services: const [PosService(id: 's-dry', name: 'Dry Cleaning'), PosService(id: 's-wash', name: 'Wash & Fold')],
      garments: const [
        PosGarment(id: 'g-shirt', name: 'Shirt', categoryId: 'c-men'),
        PosGarment(id: 'g-saree', name: 'Saree', categoryId: 'c-women'),
      ],
      prices: const [
        PosPrice(id: 'p1', garmentId: 'g-shirt', serviceId: 's-dry', ratePaise: 8000),
        PosPrice(id: 'p2', garmentId: 'g-shirt', serviceId: 's-wash', ratePaise: 3000),
        PosPrice(id: 'p3', garmentId: 'g-saree', serviceId: 's-dry', ratePaise: 15000),
      ],
      taxRules: tax,
    );

const sampleCustomer = PosCustomer(id: 'u-1', name: 'Asha Verma', phone: '9811122233');

/// Prices the way the real server does for these two garments, so tests can compare totals.
PosQuote priceLikeServer(OrderRequest r, {int chargePaise = 0, int discountPaise = 0, int taxBps = 0}) {
  final cat = sampleCatalogue();
  final lines = <QuoteLine>[];
  var subtotal = 0;
  for (final l in r.lines) {
    final price = cat.priceOf(l.garmentId, l.serviceId)!;
    final amount = price.ratePaise * l.qty;
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
    return onQuote != null ? onQuote!(request) : Future.value(priceLikeServer(request));
  }

  @override
  Future<BookedOrder> book(OrderRequest request, {required String idempotencyKey}) {
    bookCalls.add((request: request, key: idempotencyKey));
    if (onBook != null) return onBook!(request, idempotencyKey);
    final q = priceLikeServer(request);
    return Future.value(BookedOrder(
      id: 'o-1',
      orderNumber: 'LND-261011-TEST',
      totalPaise: q.totalPaise,
      amountPaidPaise: request.paymentMode == PosPaymentMode.payLater ? 0 : q.totalPaise,
      paymentStatus: request.paymentMode == PosPaymentMode.payLater ? 'UNPAID' : 'PAID',
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
    return customers.where((c) => n.isEmpty || c.name.toLowerCase().contains(n) || c.phone.contains(n)).toList();
  }

  @override
  Future<PosCustomer> createCustomer({required String name, required String phone}) async {
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
    return result ?? const PosDashboard(asOf: '2026-10-11', home: PosHomeStats());
  }
}

class FakeCatalogueRepo implements PosCatalogueRepository {
  FakeCatalogueRepo({PosCatalogue? catalogue}) : catalogue = catalogue ?? sampleCatalogue();
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
  Future<PosGarment> createGarment({required String name, required String unit, String? categoryId}) async {
    calls.add('garment:$name:$unit:$categoryId');
    return PosGarment(id: 'g-new-$name', name: name, categoryId: categoryId, unit: unit);
  }

  @override
  Future<PosPrice> createPrice({required String garmentId, required String serviceId, required int ratePaise}) async {
    calls.add('price:$garmentId:$serviceId:$ratePaise');
    if (priceError != null) throw priceError!;
    return PosPrice(id: 'p-new', garmentId: garmentId, serviceId: serviceId, ratePaise: ratePaise);
  }

  @override
  Future<PosPrice> updatePrice({required String priceId, required int ratePaise}) async {
    calls.add('update:$priceId:$ratePaise');
    return PosPrice(id: priceId, garmentId: 'g', serviceId: 's', ratePaise: ratePaise);
  }

  @override
  Future<List<PosAdjustmentRule>> listRules(String kind) async => kind == 'charge' ? charges : discounts;
}
