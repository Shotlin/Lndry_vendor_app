import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/network.dart';
import '../../models/pos/pos_catalogue_model.dart';
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

final posDashboardRepositoryProvider = Provider<PosDashboardRepository>((ref) => ApiPosDashboardRepository(ref.watch(dioClientProvider)));
final posCatalogueRepositoryProvider = Provider<PosCatalogueRepository>((ref) => ApiPosCatalogueRepository(ref.watch(dioClientProvider)));
final posCounterRepositoryProvider = Provider<PosCounterRepository>((ref) => ApiPosCounterRepository(ref.watch(dioClientProvider)));
