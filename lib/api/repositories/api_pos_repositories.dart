import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/network.dart';
import '../../models/pos/pos_catalogue_model.dart';
import '../../models/pos/pos_counter_order_model.dart';
import '../../models/pos/pos_customer_model.dart';
import '../../models/pos/pos_dashboard_model.dart';
import '../../models/pos/pos_order_model.dart';
import '../../repositories/abstract/pos_repositories.dart';

/// Reads `{ success, message, data }` and returns `data`. Anything else is an unexpected answer.
Map<String, dynamic> _dataMap(Response<dynamic> resp) {
  final body = resp.data;
  final data = body is Map<String, dynamic> ? body['data'] : null;
  if (data is! Map<String, dynamic>) throw const ApiException(message: 'Unexpected answer from the server');
  return data;
}

List<dynamic> _dataList(Response<dynamic> resp) {
  final body = resp.data;
  final data = body is Map<String, dynamic> ? body['data'] : null;
  if (data is! List) throw const ApiException(message: 'Unexpected answer from the server');
  return data;
}

Map<String, dynamic> _part(Map<String, dynamic> data, String key) {
  final v = data[key];
  if (v is! Map<String, dynamic>) throw const ApiException(message: 'Unexpected answer from the server');
  return v;
}

class ApiPosDashboardRepository implements PosDashboardRepository {
  ApiPosDashboardRepository(this._dio);
  final Dio _dio;

  @override
  Future<PosDashboard> getDashboard() async => PosDashboard.fromJson(_dataMap(await _dio.get('/vendor/pos/dashboard')));
}

class ApiPosCatalogueRepository implements PosCatalogueRepository {
  ApiPosCatalogueRepository(this._dio);
  final Dio _dio;

  @override
  Future<PosCatalogue> getCatalogue() async => PosCatalogue.fromJson(_dataMap(await _dio.get('/vendor/pos-catalogue')));

  @override
  Future<PosCategory> createCategory(String name) async =>
      PosCategory.fromJson(_part(_dataMap(await _dio.post('/vendor/pos-catalogue/categories', data: {'name': name})), 'category'));

  @override
  Future<PosService> createService(String name) async =>
      PosService.fromJson(_part(_dataMap(await _dio.post('/vendor/pos-catalogue/services', data: {'name': name})), 'service'));

  @override
  Future<PosGarment> createGarment({required String name, required String unit, String? categoryId}) async => PosGarment.fromJson(_part(
      _dataMap(await _dio.post('/vendor/pos-catalogue/garments', data: {'name': name, 'unit': unit, if (categoryId != null) 'categoryId': categoryId})),
      'garment'));

  @override
  Future<PosPrice> createPrice({required String garmentId, required String serviceId, required int ratePaise}) async => PosPrice.fromJson(_part(
      _dataMap(await _dio.post('/vendor/pos-catalogue/prices', data: {'garmentId': garmentId, 'serviceId': serviceId, 'ratePaise': ratePaise})),
      'price'));

  @override
  Future<PosPrice> updatePrice({required String priceId, required int ratePaise}) async =>
      PosPrice.fromJson(_part(_dataMap(await _dio.put('/vendor/pos-catalogue/prices/$priceId', data: {'ratePaise': ratePaise})), 'price'));

  @override
  Future<List<PosAdjustmentRule>> listRules(String kind) async =>
      _dataList(await _dio.get('/vendor/adjustment-rules/$kind')).whereType<Map<String, dynamic>>().map(PosAdjustmentRule.fromJson).toList(growable: false);
}

class ApiPosCounterRepository implements PosCounterRepository {
  ApiPosCounterRepository(this._dio);
  final Dio _dio;

  @override
  Future<List<PosCustomer>> searchCustomers(String search) async {
    final resp = await _dio.get<dynamic>('/vendor/counter/customers', queryParameters: {if (search.trim().isNotEmpty) 'search': search.trim()});
    return _dataList(resp).whereType<Map<String, dynamic>>().map(PosCustomer.fromJson).toList(growable: false);
  }

  @override
  Future<PosCustomer> createCustomer({required String name, required String phone}) async =>
      PosCustomer.fromJson(_part(_dataMap(await _dio.post('/vendor/counter/customers', data: {'name': name, 'phone': phone})), 'customer'));

  @override
  Future<PosQuote> quote(OrderRequest request) async =>
      PosQuote.fromJson(_part(_dataMap(await _dio.post('/vendor/counter/orders/quote', data: request.toJson())), 'quote'));

  @override
  Future<BookedOrder> book(OrderRequest request, {required String idempotencyKey}) async => BookedOrder.fromJson(_part(
      _dataMap(await _dio.post('/vendor/counter/orders', data: request.toJson(), options: Options(headers: {'Idempotency-Key': idempotencyKey}))),
      'order'));
}

class ApiPosOrdersRepository implements PosOrdersRepository {
  ApiPosOrdersRepository(this._dio);
  final Dio _dio;

  @override
  Future<List<CounterOrder>> listOrders(OrderFilter filter, {int limit = 30, int offset = 0}) async {
    final resp = await _dio.get<dynamic>('/vendor/counter/orders', queryParameters: filter.toQuery(limit: limit, offset: offset));
    return _dataList(resp).whereType<Map<String, dynamic>>().map(CounterOrder.fromJson).toList(growable: false);
  }

  @override
  Future<OrderDetail> getOrder(String id) async => OrderDetail.fromJson(_dataMap(await _dio.get('/vendor/counter/orders/$id')));

  @override
  Future<CounterOrder> updateOrder(String id, OrderEdit edit, {int? version}) async =>
      CounterOrder.fromJson(_part(_dataMap(await _dio.patch('/vendor/counter/orders/$id', data: {...edit.toJson(), if (version != null) 'version': version})), 'order'));

  @override
  Future<CounterOrder> transition(String id, String state, {bool allowIncomplete = false, bool allowUnpaid = false, int? version}) async =>
      CounterOrder.fromJson(_part(
          _dataMap(await _dio.post('/vendor/counter/orders/$id/transition', data: {
            'state': state,
            if (allowIncomplete) 'allowIncomplete': true,
            if (allowUnpaid) 'allowUnpaid': true,
            if (version != null) 'version': version,
          })),
          'order'));

  @override
  Future<CounterOrder> cancel(String id, String reason) async =>
      CounterOrder.fromJson(_part(_dataMap(await _dio.post('/vendor/counter/orders/$id/cancel', data: {'reason': reason})), 'order'));

  @override
  Future<CounterOrder> assignCaptain(String id, {String? pickupCaptainId, String? deliveryCaptainId}) async => CounterOrder.fromJson(_part(
      _dataMap(await _dio.post('/vendor/counter/orders/$id/assign', data: {
        if (pickupCaptainId != null) 'pickupRiderId': pickupCaptainId,
        if (deliveryCaptainId != null) 'deliveryRiderId': deliveryCaptainId,
      })),
      'order'));

  @override
  Future<({CounterOrder order, List<OrderPayment> payments})> collectPayment(String id, {required int amountPaise, required String mode, String? reference}) async {
    final data = _dataMap(await _dio.post('/vendor/counter/orders/$id/payments', data: {
      'amountPaise': amountPaise,
      'mode': mode,
      if (reference != null && reference.trim().isNotEmpty) 'reference': reference.trim(),
    }));
    return (
      order: CounterOrder.fromJson(_part(data, 'order')),
      payments: (data['payments'] is List ? data['payments'] as List : const <dynamic>[]).whereType<Map<String, dynamic>>().map(OrderPayment.fromJson).toList(growable: false),
    );
  }

  @override
  Future<List<OrderCaptain>> listCaptains() async {
    final data = _dataMap(await _dio.get('/vendor/employees', queryParameters: {'role': 'VENDOR_RIDER'}));
    final staff = data['staff'];
    if (staff is! List) throw const ApiException(message: 'Unexpected answer from the server');
    return staff.whereType<Map<String, dynamic>>().where((e) => e['is_active'] != false).map(OrderCaptain.fromEmployee).toList(growable: false);
  }

  @override
  Future<List<GarmentUnit>> listGarmentUnits(String orderId) async =>
      _dataList(await _dio.get('/vendor/counter/garment-units', queryParameters: {'orderId': orderId})).whereType<Map<String, dynamic>>().map(GarmentUnit.fromJson).toList(growable: false);

  @override
  Future<String?> createTagPrintJob(String orderId, List<String> garmentUnitIds) async {
    final data = _dataMap(await _dio.post('/vendor/print-jobs', data: {'orderId': orderId, 'documentType': 'GARMENT_TAG', 'garmentUnitIds': garmentUnitIds, 'status': 'PENDING'}));
    return data['id']?.toString();
  }

  @override
  Future<void> markPrintJobPrinted(String jobId) async {
    await _dio.put<dynamic>('/vendor/print-jobs/$jobId/status', data: {'status': 'PRINTED'});
  }

  @override
  Future<PosPdf> invoicePdf(String id) => _pdf('/vendor/counter/orders/$id/invoice', const {'format': 'full'}, 'Invoice.pdf');

  @override
  Future<PosPdf> miniBillPdf(String id, {int paperMm = 80}) => _pdf('/vendor/counter/orders/$id/invoice', {'format': 'mini', 'paper': paperMm == 58 ? 58 : 80}, 'Bill.pdf');

  /// Downloads a PDF. A refusal arrives as JSON bytes; its sentence is kept so the person can read why.
  Future<PosPdf> _pdf(String path, Map<String, dynamic> query, String fallbackName) async {
    try {
      final resp = await _dio.get<List<int>>(path, queryParameters: query, options: Options(responseType: ResponseType.bytes));
      final bytes = Uint8List.fromList(resp.data ?? const <int>[]);
      if (bytes.length < 5 || String.fromCharCodes(bytes.sublist(0, 5)) != '%PDF-') throw const ApiException(message: 'Unexpected answer from the server');
      final disposition = resp.headers.value('content-disposition') ?? '';
      final name = RegExp(r'filename="([^"]+)"').firstMatch(disposition)?.group(1) ?? fallbackName;
      return PosPdf(bytes: bytes, fileName: name);
    } on DioException catch (e) {
      final raw = e.response?.data;
      if (raw is List<int>) {
        try {
          final body = jsonDecode(utf8.decode(raw));
          if (body is Map<String, dynamic> && body['message'] is String) {
            throw ApiException(message: body['message'] as String, statusCode: e.response?.statusCode, code: body['code']?.toString());
          }
        } on FormatException {
          // Not JSON: fall through to the original error.
        }
      }
      rethrow;
    }
  }
}

final posDashboardRepositoryProvider = Provider<PosDashboardRepository>((ref) => ApiPosDashboardRepository(ref.watch(dioClientProvider)));
final posCatalogueRepositoryProvider = Provider<PosCatalogueRepository>((ref) => ApiPosCatalogueRepository(ref.watch(dioClientProvider)));
final posCounterRepositoryProvider = Provider<PosCounterRepository>((ref) => ApiPosCounterRepository(ref.watch(dioClientProvider)));

final posOrdersRepositoryProvider = Provider<PosOrdersRepository>((ref) => ApiPosOrdersRepository(ref.watch(dioClientProvider)));
