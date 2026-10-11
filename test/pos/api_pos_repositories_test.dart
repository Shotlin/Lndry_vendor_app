import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lndry_vendor_app/api/repositories/api_pos_repositories.dart';
import 'package:lndry_vendor_app/models/pos/pos_catalogue_model.dart';
import 'package:lndry_vendor_app/models/pos/pos_dashboard_model.dart';
import 'package:lndry_vendor_app/models/pos/pos_order_model.dart';

/// Contract tests: every fixture in test/pos/fixtures/pos_*.json is a REAL response captured from a running
/// Lndry_backend (migration 153 applied). They prove the Dart models read exactly what the server sends.
String fixture(String name) => File('test/pos/fixtures/$name.json').readAsStringSync();

class _Adapter implements HttpClientAdapter {
  final Map<String, ({int status, String body})> routes = {};
  final List<RequestOptions> requests = [];

  void on(String method, String path, String fixtureName, {int status = 200}) => routes['$method $path'] = (status: status, body: fixture(fixtureName));

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    requests.add(options);
    final hit = routes['${options.method} ${options.path}'];
    final h = {
      Headers.contentTypeHeader: ['application/json']
    };
    if (hit == null) return ResponseBody.fromString(jsonEncode({'success': false, 'message': 'no route ${options.method} ${options.path}'}), 404, headers: h);
    return ResponseBody.fromString(hit.body, hit.status, headers: h);
  }
}

({Dio dio, _Adapter http}) make() {
  final http = _Adapter();
  return (dio: Dio(BaseOptions(baseUrl: 'http://test/api/v1'))..httpClientAdapter = http, http: http);
}

void main() {
  group('dashboard', () {
    test('an empty shop: every tile is a real 0 (not null)', () async {
      final t = make()..http.on('GET', '/vendor/pos/dashboard', 'pos_dashboard_empty');
      final d = await ApiPosDashboardRepository(t.dio).getDashboard();
      expect(d.asOf, matches(RegExp(r'^\d{4}-\d{2}-\d{2}$')));
      final h = d.home;
      for (final v in [h.todayRevenuePaise, h.todayCollectionPaise, h.collectionDuePaise, h.onlineOrderRequests, h.washingToStore, h.bookingsToday, h.deliveriesToday, h.deliveredToday, h.pendingOrders, h.unassignedPickups, h.upcomingDeliveries, h.unassignedDeliveries, h.expressOrders]) {
        expect(v, 0);
      }
    });

    test('a shop with one unpaid express order', () async {
      final t = make()..http.on('GET', '/vendor/pos/dashboard', 'pos_dashboard_data');
      final h = (await ApiPosDashboardRepository(t.dio).getDashboard()).home;
      expect(h.bookingsToday, 1);
      expect(h.pendingOrders, 1);
      expect(h.expressOrders, 1);
      expect(h.todayRevenuePaise, 23000);
      expect(h.todayCollectionPaise, 0);
      expect(h.collectionDuePaise, 23000);
    });

    test('an old backend with no `home` block gives nulls (screen shows dashes)', () {
      final d = PosDashboard.fromJson({'asOf': '2026-10-11', 'counterSalesToday': {'count': 0}});
      expect(d.home.bookingsToday, isNull);
      expect(d.home.todayRevenuePaise, isNull);
    });
  });

  group('catalogue', () {
    test('parses categories, services, garments and prices; shop-wide prices are found', () async {
      final t = make()..http.on('GET', '/vendor/pos-catalogue', 'pos_catalogue');
      final c = await ApiPosCatalogueRepository(t.dio).getCatalogue();
      expect(c.activeServices.map((s) => s.name), containsAll(['Dry Cleaning', 'Wash & Fold']));
      expect(c.garments.length, 4);
      final shirt = c.garments.firstWhere((g) => g.name == 'Shirt');
      final dry = c.services.firstWhere((s) => s.name == 'Dry Cleaning');
      expect(c.priceOf(shirt.id, dry.id)!.ratePaise, 8000);
      expect(shirt.unit, 'piece');
      expect(shirt.isCountable, isTrue);
      expect(c.garmentsFor(serviceId: dry.id).length, greaterThan(0));
      expect(c.garmentsFor(serviceId: dry.id, search: 'shirt').map((g) => g.name), contains('Shirt'));
      expect(c.garmentsFor(serviceId: null), isEmpty);
    });

    test('charge rules', () async {
      final t = make()..http.on('GET', '/vendor/adjustment-rules/charge', 'pos_rules_charge');
      final rules = await ApiPosCatalogueRepository(t.dio).listRules('charge');
      expect(rules.single.name, 'Express charge');
      expect(rules.single.isPercentage, isTrue);
      expect(rules.single.percentageBps, 1000);
      expect(rules.single.flatPaise, isNull);
    });
  });

  group('customers', () {
    test('recent customers', () async {
      final t = make()..http.on('GET', '/vendor/counter/customers', 'pos_customers');
      final list = await ApiPosCounterRepository(t.dio).searchCustomers('');
      expect(list.single.name, 'Asha Verma');
      expect(list.single.phone, '9811122233');
      expect(list.single.orderCount, 1);
      expect(list.single.spentPaise, 23000);
      expect(t.http.requests.single.queryParameters, isEmpty, reason: 'an empty search sends no search param');
    });

    test('search text is trimmed and sent', () async {
      final t = make()..http.on('GET', '/vendor/counter/customers', 'pos_customers');
      await ApiPosCounterRepository(t.dio).searchCustomers('  asha ');
      expect(t.http.requests.single.queryParameters, {'search': 'asha'});
    });

    test('create', () async {
      final t = make()..http.on('POST', '/vendor/counter/customers', 'pos_customer_create', status: 201);
      final c = await ApiPosCounterRepository(t.dio).createCustomer(name: 'Asha Verma', phone: '9811122233');
      expect(c.id, isNotEmpty);
      expect(t.http.requests.single.data, {'name': 'Asha Verma', 'phone': '9811122233'});
    });
  });

  group('quote and booking', () {
    const request = OrderRequest(
      lines: [CartLine(garmentId: 'g', serviceId: 's', qty: 2)],
      customerId: 'u',
      expectedDeliveryDate: '2026-10-15',
      deliveryMode: DeliveryMode.homeDelivery,
      isExpress: true,
      paymentMode: PosPaymentMode.online,
      notes: ' hi ',
    );

    test('quote: every figure of the server answer, in paise', () async {
      final t = make()..http.on('POST', '/vendor/counter/orders/quote', 'pos_quote');
      final q = await ApiPosCounterRepository(t.dio).quote(request);
      expect(q.lines.length, 2);
      expect(q.lines.first.name, 'Shirt');
      expect(q.lines.first.qty, 2);
      expect(q.lines.first.ratePaise, 8000);
      expect(q.lines.first.amountPaise, 16000);
      expect(q.subtotalPaise, 23000);
      expect(q.totalPaise, 23000);
      expect(q.taxPaise, 0);
      expect(q.charges, isEmpty);
      expect(q.lineFor(q.lines.last.garmentId, q.lines.last.serviceId)!.amountPaise, 7000);
    });

    test('the request body carries exactly what the backend contract needs', () async {
      final t = make()..http.on('POST', '/vendor/counter/orders/quote', 'pos_quote');
      await ApiPosCounterRepository(t.dio).quote(request);
      expect(t.http.requests.single.data, {
        'items': [
          {'garmentId': 'g', 'serviceId': 's', 'qty': 2}
        ],
        'customer': {'id': 'u'},
        'expectedDeliveryDate': '2026-10-15',
        'deliveryMode': 'HOME_DELIVERY',
        'isExpress': true,
        'paymentMode': 'UPI',
        'notes': 'hi',
      });
    });

    test('book: parses the order and sends the Idempotency-Key header', () async {
      final t = make()..http.on('POST', '/vendor/counter/orders', 'pos_book', status: 201);
      final o = await ApiPosCounterRepository(t.dio).book(request, idempotencyKey: '3f1c2d4e-5a6b-4c7d-8e9f-0a1b2c3d4e5f');
      expect(o.orderNumber, matches(RegExp(r'^LND-\d{6}-[A-Z0-9]{4}$')));
      expect(o.status, 'BOOKED');
      expect(o.totalPaise, 23000);
      expect(o.amountPaidPaise, 0);
      expect(o.balancePaise, 23000);
      expect(o.isPaid, isFalse);
      expect(o.paymentStatus, 'UNPAID');
      expect(o.deliveryMode, DeliveryMode.homeDelivery);
      expect(o.isExpress, isTrue);
      expect(o.expectedDeliveryDate, '2026-10-15');
      expect(o.customer.name, 'Asha Verma');
      expect(t.http.requests.single.headers['Idempotency-Key'], '3f1c2d4e-5a6b-4c7d-8e9f-0a1b2c3d4e5f');
    });

    test('server refusals keep the server\'s own words', () async {
      final t = make()..http.on('POST', '/vendor/counter/orders/quote', 'pos_error_noprice', status: 400);
      await expectLater(
        ApiPosCounterRepository(t.dio).quote(request),
        throwsA(isA<DioException>().having((e) => (e.response!.data as Map)['message'], 'message', 'No active price exists for this garment and service.')),
      );
    });

    test('a body that is not the expected shape is an error, not a crash', () async {
      final t = make()..http.on('POST', '/vendor/counter/orders/quote', 'pos_error_validation');
      await expectLater(ApiPosCounterRepository(t.dio).quote(request), throwsA(isA<Exception>()));
    });
  });

  group('OrderRequest.priceKey', () {
    const a = CartLine(garmentId: 'g1', serviceId: 's', qty: 1);
    const b = CartLine(garmentId: 'g2', serviceId: 's', qty: 3);
    test('does not depend on line order or rule order', () {
      expect(const OrderRequest(lines: [a, b], chargeRuleIds: ['x', 'y']).priceKey, const OrderRequest(lines: [b, a], chargeRuleIds: ['y', 'x']).priceKey);
    });
    test('changes with qty, customer, rules and GST', () {
      final base = const OrderRequest(lines: [a]).priceKey;
      expect(const OrderRequest(lines: [CartLine(garmentId: 'g1', serviceId: 's', qty: 2)]).priceKey, isNot(base));
      expect(const OrderRequest(lines: [a], customerId: 'u').priceKey, isNot(base));
      expect(const OrderRequest(lines: [a], chargeRuleIds: ['c']).priceKey, isNot(base));
      expect(const OrderRequest(lines: [a], discountRuleIds: ['d']).priceKey, isNot(base));
      expect(const OrderRequest(lines: [a], taxRatePercent: 18).priceKey, isNot(base));
    });
    test('does not change with date, payment, remarks, delivery mode or express', () {
      final base = const OrderRequest(lines: [a]).priceKey;
      expect(const OrderRequest(lines: [a], expectedDeliveryDate: '2026-01-01', paymentMode: PosPaymentMode.cash, notes: 'x', deliveryMode: DeliveryMode.pickup, isExpress: true).priceKey, base);
    });
    test('a GST rate of 0 is the same as none', () {
      expect(const OrderRequest(lines: [a], taxRatePercent: 0).toJson().containsKey('taxRatePercent'), isFalse);
    });
  });

  group('enums', () {
    test('wire values and tolerant parsing', () {
      expect(DeliveryMode.parse('home_delivery'), DeliveryMode.homeDelivery);
      expect(DeliveryMode.parse(null), DeliveryMode.walkIn);
      expect(DeliveryMode.parse('???'), DeliveryMode.walkIn);
      expect(PosPaymentMode.online.wire, 'UPI');
      expect(PosPaymentMode.parse('PAY_LATER'), PosPaymentMode.payLater);
      expect(PosPaymentMode.parse(null), PosPaymentMode.payLater);
    });
  });

  group('catalogue helpers', () {
    test('a parent category includes its children', () {
      const c = PosCatalogue(
        categories: [PosCategory(id: 'p', name: 'Men'), PosCategory(id: 'k', name: 'Shirts', parentId: 'p')],
        garments: [PosGarment(id: 'g', name: 'Polo', categoryId: 'k')],
        prices: [PosPrice(id: '1', garmentId: 'g', serviceId: 's', ratePaise: 100)],
      );
      expect(c.garmentsFor(serviceId: 's', categoryId: 'p').map((g) => g.id), ['g']);
      expect(c.garmentsFor(serviceId: 's', categoryId: 'other'), isEmpty);
    });
    test('customer-only prices and inactive prices are not shop prices', () {
      const c = PosCatalogue(prices: [
        PosPrice(id: '1', garmentId: 'g', serviceId: 's', ratePaise: 100, customerUserId: 'u'),
        PosPrice(id: '2', garmentId: 'g', serviceId: 's2', ratePaise: 100, active: false),
      ]);
      expect(c.priceOf('g', 's'), isNull);
      expect(c.priceOf('g', 's2'), isNull);
    });
  });
}
