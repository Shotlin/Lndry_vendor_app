import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lndry_vendor_app/api/repositories/api_pos_repositories.dart';
import 'package:lndry_vendor_app/core/network/api_exception.dart';
import 'package:lndry_vendor_app/features/pos/orders/order_errors.dart';
import 'package:lndry_vendor_app/features/pos/orders/order_state.dart';
import 'package:lndry_vendor_app/models/pos/pos_counter_order_model.dart';
import 'package:lndry_vendor_app/models/pos/pos_order_model.dart';

/// Contract tests: every `order_*.json` in test/pos/fixtures is a REAL response captured from a running Lndry_backend
/// (the Phase 3 build). They prove the Dart models read exactly what the server sends, and that the app reads the
/// server's error CODES the way the screens rely on.
String fixture(String name) =>
    File('test/pos/fixtures/$name.json').readAsStringSync();

class _Adapter implements HttpClientAdapter {
  final Map<String, ({int status, Object body, String type})> routes = {};
  final List<RequestOptions> requests = [];

  void on(String method, String path, String fixtureName, {int status = 200}) =>
      routes['$method $path'] = (
        status: status,
        body: fixture(fixtureName),
        type: 'application/json'
      );
  void onBytes(String method, String path, List<int> bytes,
      {int status = 200,
      String type = 'application/pdf',
      Map<String, List<String>> headers = const {}}) {
    routes['$method $path'] = (status: status, body: bytes, type: type);
    _headers['$method $path'] = headers;
  }

  final Map<String, Map<String, List<String>>> _headers = {};

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    requests.add(options);
    final key = '${options.method} ${options.path}';
    final hit = routes[key];
    final h = {
      Headers.contentTypeHeader: [hit?.type ?? 'application/json'],
      ...?_headers[key],
    };
    if (hit == null) {
      return ResponseBody.fromString(
          jsonEncode({'success': false, 'message': 'no route $key'}), 404,
          headers: h);
    }
    final body = hit.body;
    return body is String
        ? ResponseBody.fromString(body, hit.status, headers: h)
        : ResponseBody.fromBytes(body as List<int>, hit.status, headers: h);
  }
}

/// A Dio the way the app builds it: a failed call arrives as a DioException whose `.error` is an ApiException.
({Dio dio, _Adapter http}) make() {
  final http = _Adapter();
  final dio = Dio(BaseOptions(baseUrl: 'http://test/api/v1'))
    ..httpClientAdapter = http;
  dio.interceptors.add(InterceptorsWrapper(onError: (e, handler) {
    final data = e.response?.data;
    final exception = data is Map<String, dynamic>
        ? ApiException(
            message: (data['message'] ?? '').toString(),
            statusCode: e.response?.statusCode,
            code: data['code']?.toString())
        : ApiException(
            message: e.message ?? 'Request failed',
            statusCode: e.response?.statusCode);
    handler.next(DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        type: e.type,
        error: exception,
        message: exception.message));
  }));
  return (dio: dio, http: http);
}

void main() {
  group('list', () {
    test('two real orders: money, flags, customer, items, captain, dates',
        () async {
      final t = make()..http.on('GET', '/vendor/counter/orders', 'order_list');
      final list =
          await ApiPosOrdersRepository(t.dio).listOrders(const OrderFilter());
      expect(list, hasLength(2));
      final a = list.firstWhere((o) => o.isExpress);
      expect(a.status, 'BOOKED');
      expect(a.deliveryMode, DeliveryMode.homeDelivery);
      expect(a.totalPaise, 16000);
      expect(a.amountPaidPaise, 5000);
      expect(a.balancePaise, 11000);
      expect(a.paymentStatus, 'PART_PAID');
      expect(a.phase, OrderPhase.booked);
      expect(a.customer.name, 'Asha Verma');
      expect(a.customer.phone, '9811122233');
      expect(a.items.single.name, 'Shirt');
      expect(a.items.single.serviceName, 'Dry Cleaning');
      expect(a.items.single.qty, 2);
      expect(a.items.single.amountPaise, 16000);
      expect(a.pieceCount, 2);
      expect(a.pickupCaptain?.name, 'Ravi Captain');
      expect(a.expectedDeliveryDate, matches(RegExp(r'^\d{4}-\d{2}-\d{2}$')));
      expect(a.placedAt, isNotNull);
      expect(a.notes, 'Handle with care');
      final b = list.firstWhere((o) => !o.isExpress);
      expect(b.deliveryMode, DeliveryMode.walkIn);
      expect(b.paymentStatus, 'UNPAID');
      expect(b.pickupCaptain, isNull);
    });

    test(
        'the filter becomes the server\'s query: status list, search, express, due, tile, paging',
        () async {
      final t = make()..http.on('GET', '/vendor/counter/orders', 'order_list');
      await ApiPosOrdersRepository(t.dio).listOrders(
        const OrderFilter(
            statuses: ['BOOKED', 'PICKED_UP'],
            search: ' asha ',
            from: '2026-10-01',
            to: '2026-10-11',
            deliveryMode: DeliveryMode.homeDelivery,
            express: true,
            paymentDue: true,
            tile: 'pendingOrders'),
        limit: 30,
        offset: 60,
      );
      expect(t.http.requests.single.queryParameters, {
        'status': 'BOOKED,PICKED_UP',
        'search': 'asha',
        'from': '2026-10-01',
        'to': '2026-10-11',
        'deliveryMode': 'HOME_DELIVERY',
        'express': 'true',
        'paymentDue': 'true',
        'tile': 'pendingOrders',
        'limit': 30,
        'offset': 60,
      });
    });

    test('an empty filter sends only the paging', () async {
      final t = make()..http.on('GET', '/vendor/counter/orders', 'order_list');
      await ApiPosOrdersRepository(t.dio).listOrders(const OrderFilter());
      expect(
          t.http.requests.single.queryParameters, {'limit': 30, 'offset': 0});
    });
  });

  group('detail', () {
    test('order + history + garment tags + payments', () async {
      final t = make()
        ..http.on('GET', '/vendor/counter/orders/o1', 'order_detail_booked');
      final d = await ApiPosOrdersRepository(t.dio).getOrder('o1');
      expect(d.order.balancePaise, 11000);
      expect(d.order.pickupCaptain?.phone, '9822233344');
      expect(d.history.single.to, 'BOOKED');
      expect(d.history.single.from, isNull,
          reason: 'the booking event has no "from"');
      expect(d.reachedAt('BOOKED'), isNotNull);
      expect(d.reachedAt('DELIVERED'), isNull);
      expect(d.units, hasLength(2));
      expect(d.units.first.tagCode, startsWith('ELT-'));
      expect(d.units.first.state, 'INTAKE');
      expect(d.units.first.itemIndex, 0);
      expect(d.payments.single.mode, 'CASH');
      expect(d.payments.single.amountPaise, 5000);
    });

    test('an answer without an order is an error, not a blank screen',
        () async {
      final t = make()
        ..http.routes['GET /vendor/counter/orders/o1'] = (
          status: 200,
          body: '{"success":true,"data":{}}',
          type: 'application/json'
        );
      await expectLater(ApiPosOrdersRepository(t.dio).getOrder('o1'),
          throwsA(isA<FormatException>()));
    });
  });

  group('moving, paying, cancelling, editing, assigning', () {
    test(
        'transition sends the state and the flags only when set; reads the order back',
        () async {
      final t = make()
        ..http
            .on('POST', '/vendor/counter/orders/o1/transition', 'order_ready');
      final repo = ApiPosOrdersRepository(t.dio);
      final o = await repo.transition('o1', 'READY',
          allowIncomplete: true, version: 3);
      expect(o.status, 'READY');
      expect(t.http.requests.single.data,
          {'state': 'READY', 'allowIncomplete': true, 'version': 3});
      await repo.transition('o1', 'READY');
      expect(t.http.requests.last.data, {'state': 'READY'},
          reason: 'no override flag unless the owner agreed');
    });

    test(
        'part payment: the order and the payment list come back as the server has them',
        () async {
      final t = make()
        ..http.on(
            'POST', '/vendor/counter/orders/o1/payments', 'order_payment_ok');
      final r = await ApiPosOrdersRepository(t.dio).collectPayment('o1',
          amountPaise: 1000, mode: 'UPI', reference: ' UTR1 ');
      expect(t.http.requests.single.data,
          {'amountPaise': 1000, 'mode': 'UPI', 'reference': 'UTR1'});
      expect(r.order.amountPaidPaise, 6000);
      expect(r.order.balancePaise, 10000);
      expect(r.order.paymentStatus, 'PART_PAID');
      expect(r.payments.map((p) => p.mode), ['CASH', 'UPI']);
      expect(
          r.payments.map((p) => p.amountPaise).reduce((a, b) => a + b), 6000);
    });

    test('a blank reference is not sent', () async {
      final t = make()
        ..http.on(
            'POST', '/vendor/counter/orders/o1/payments', 'order_payment_ok');
      await ApiPosOrdersRepository(t.dio).collectPayment('o1',
          amountPaise: 1000, mode: 'CASH', reference: '  ');
      expect(
          t.http.requests.single.data, {'amountPaise': 1000, 'mode': 'CASH'});
    });

    test('cancel + edit + assign read the order back', () async {
      final t = make()
        ..http.on('POST', '/vendor/counter/orders/o2/cancel', 'order_cancel_ok')
        ..http.on('PATCH', '/vendor/counter/orders/o1', 'order_patch_ok')
        ..http.on('POST', '/vendor/counter/orders/o1/assign', 'order_patch_ok');
      final repo = ApiPosOrdersRepository(t.dio);
      final c = await repo.cancel('o2', 'Customer changed mind');
      expect(c.status, 'CANCELLED');
      expect(c.cancelReason, 'Customer changed mind');
      expect(c.phase, OrderPhase.cancelled);
      expect(c.balancePaise, 0);
      final e = await repo.updateOrder('o1',
          const OrderEdit(notes: 'Call before delivery', isExpress: false),
          version: 4);
      expect(t.http.requests[1].data,
          {'isExpress': false, 'notes': 'Call before delivery', 'version': 4});
      expect(e.notes, 'Call before delivery');
      expect(e.isExpress, isFalse);
      await repo.assignCaptain('o1', pickupCaptainId: 'e1');
      expect(t.http.requests[2].data, {'pickupRiderId': 'e1'});
    });

    test('an edit with nothing in it says so',
        () => expect(const OrderEdit().isEmpty, isTrue));
  });

  group('captains', () {
    test('the team list (snake_case rows) → captains with name and phone',
        () async {
      final t = make()..http.on('GET', '/vendor/employees', 'order_captains');
      final c = await ApiPosOrdersRepository(t.dio).listCaptains();
      expect(c.single.name, 'Ravi Captain');
      expect(c.single.phone, '9822233344');
      expect(t.http.requests.single.queryParameters, {'role': 'VENDOR_RIDER'});
    });
  });

  group('the server\'s refusals reach the screens as codes the app understands',
      () {
    Future<Object> error(String method, String path, String fixtureName,
        int status, Future<void> Function(ApiPosOrdersRepository) call) async {
      final t = make()..http.on(method, path, fixtureName, status: status);
      try {
        await call(ApiPosOrdersRepository(t.dio));
      } catch (e) {
        return e;
      }
      fail('expected an error');
    }

    test('overpayment', () async {
      final e = await error(
          'POST',
          '/vendor/counter/orders/o1/payments',
          'order_error_overpay',
          400,
          (r) => r.collectPayment('o1', amountPaise: 99999999, mode: 'CASH'));
      expect(errorCodeOf(e), 'OVERPAYMENT');
    });
    test('skipping a step', () async {
      final e = await error(
          'POST',
          '/vendor/counter/orders/o1/transition',
          'order_error_invalid_transition',
          409,
          (r) => r.transition('o1', 'DELIVERED'));
      expect(errorCodeOf(e), 'INVALID_TRANSITION');
    });
    test('garments not scanned yet → the "mark ready anyway" gate', () async {
      final e = await error('POST', '/vendor/counter/orders/o1/transition',
          'order_error_assembly', 409, (r) => r.transition('o1', 'READY'));
      expect(errorCodeOf(e), 'ASSEMBLY_INCOMPLETE');
    });
    test('delivering with a balance → the "collect first" gate', () async {
      final e = await error('POST', '/vendor/counter/orders/o1/transition',
          'order_error_unpaid', 409, (r) => r.transition('o1', 'DELIVERED'));
      expect(errorCodeOf(e), 'PAYMENT_OUTSTANDING');
    });
    test('a cancel reason that is too short is a plain-words 400', () async {
      final e = await error('POST', '/vendor/counter/orders/o1/cancel',
          'order_error_cancel_short', 400, (r) => r.cancel('o1', 'x'));
      expect(errorCodeOf(e), 'VALIDATION_ERROR');
      expect((e as DioException).message, contains('reason'));
    });
    test('no code → null; a dropped connection is a network problem', () {
      expect(errorCodeOf(Exception('x')), isNull);
      expect(isNetworkProblem(const ApiException(message: 'offline')), isTrue);
      expect(
          isNetworkProblem(const ApiException(message: 'no', statusCode: 400)),
          isFalse);
    });
  });

  group('PDF', () {
    final pdf =
        Uint8List.fromList(utf8.encode('%PDF-1.3\n1 0 obj <<>> endobj'));

    test(
        'the invoice and the mini bill ask the server for the right format and paper',
        () async {
      final t = make()
        ..http
            .onBytes('GET', '/vendor/counter/orders/o1/invoice', pdf, headers: {
          'content-disposition': ['inline; filename="Bill-LND-1.pdf"']
        });
      final repo = ApiPosOrdersRepository(t.dio);
      final a = await repo.invoicePdf('o1');
      expect(a.bytes, pdf);
      expect(a.fileName, 'Bill-LND-1.pdf');
      expect(t.http.requests.last.queryParameters, {'format': 'full'});
      await repo.miniBillPdf('o1', paperMm: 58);
      expect(t.http.requests.last.queryParameters,
          {'format': 'mini', 'paper': 58});
      await repo.miniBillPdf('o1', paperMm: 99);
      expect(
          t.http.requests.last.queryParameters, {'format': 'mini', 'paper': 80},
          reason: 'any other size is 80 mm');
    });

    test('a refusal arrives as bytes: its sentence is kept, with the code',
        () async {
      final body = utf8.encode(
          '{"success":false,"message":"The invoice is created when the order is delivered. Use the mini bill until then.","code":"INVOICE_NOT_AVAILABLE"}');
      final t = make()
        ..http.onBytes('GET', '/vendor/counter/orders/o1/invoice', body,
            status: 409, type: 'application/json');
      try {
        await ApiPosOrdersRepository(t.dio).invoicePdf('o1');
        fail('should have thrown');
      } on ApiException catch (e) {
        expect(e.code, 'INVOICE_NOT_AVAILABLE');
        expect(e.statusCode, 409);
        expect(e.message, contains('delivered'));
      }
    });

    test('something that is not a PDF is refused, not shown', () async {
      final t = make()
        ..http.onBytes('GET', '/vendor/counter/orders/o1/invoice',
            utf8.encode('<html>login</html>'));
      await expectLater(ApiPosOrdersRepository(t.dio).invoicePdf('o1'),
          throwsA(isA<ApiException>()));
    });
  });
}
