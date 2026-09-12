import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../config/config.dart';
import '../../core/network/network.dart';
import '../../core/services/storage_service.dart';
import '../../core/constants/app_constants.dart';
import '../../models/models.dart';
import '../../shared/repositories/base_repository.dart';
import '../../repositories/abstract/vendor_repository.dart';
import 'demo_vendor_repository.dart';

class ApiVendorRepository implements VendorRepository {
  ApiVendorRepository({
    required Dio dio,
    required StorageService storage,
  })  : _dio = dio,
        _storage = storage;

  final Dio _dio;
  final StorageService _storage;

  // -- Helpers
  Map<String, dynamic> _extractData(Map<String, dynamic> response) {
    if (response['success'] == true) {
      return (response['data'] as Map<String, dynamic>?) ?? response;
    }
    return response;
  }

  List<dynamic> _extractList(Map<String, dynamic> response) {
    if (response['success'] == true) {
      return (response['data'] as List<dynamic>?) ?? [];
    }
    if (response['data'] is List) {
      return response['data'] as List<dynamic>;
    }
    return [];
  }

  // -- Auth
  @override
  Future<SendOtpResult> sendOtp(String phone) async {
    final apiPhone = phone.startsWith('+') ? phone : '+91$phone';
    final resp = await _dio.post(
      ApiEndpoints.sendOtp,
      data: {'phone': apiPhone, 'role': 'vendor'},
    );
    final data = _extractData(resp.data as Map<String, dynamic>);
    return SendOtpResult(
      challengeId: data['challenge_id'] as String? ??
          data['challengeId'] as String? ??
          '',
      expiresIn: (data['expires_in'] as num?)?.toInt() ??
          (data['expiresIn'] as num?)?.toInt() ??
          300,
      devOtp: data['otp'] as String?,
    );
  }

  @override
  Future<VerifyOtpVendorResult> verifyOtp({
    required String phone,
    required String otp,
    String? challengeId,
    Map<String, dynamic>? device,
  }) async {
    final apiPhone = phone.startsWith('+') ? phone : '+91$phone';
    final body = <String, dynamic>{
      'phone': apiPhone,
      'otp': otp,
      if (challengeId != null) 'challenge_id': challengeId,
      if (device != null) 'device': device,
      'role': 'vendor',
    };
    final resp = await _dio.post(ApiEndpoints.verifyOtp, data: body);
    final data = _extractData(resp.data as Map<String, dynamic>);

    final accessToken = data['accessToken'] as String? ?? '';
    final refreshToken = data['refreshToken'] as String? ?? '';
    final vendorJson = data['vendor'] as Map<String, dynamic>? ?? {};
    final vendor = _parseVendor(vendorJson);

    // Persist tokens securely
    if (accessToken.isNotEmpty) {
      await _storage.saveSecure(AppConstants.keyAccessToken, accessToken);
    }
    if (refreshToken.isNotEmpty) {
      await _storage.saveSecure(AppConstants.keyRefreshToken, refreshToken);
    }

    final userJson = data['user'] as Map<String, dynamic>? ?? {};
    final userPhone = userJson['phone'] as String? ?? '';
    final shopRole =
        userJson['shop_role'] as String? ?? userJson['shopRole'] as String?;
    final permissions = (userJson['permissions'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        const <String>[];

    return VerifyOtpVendorResult(
      accessToken: accessToken,
      refreshToken: refreshToken,
      vendor: vendor,
      userPhone: userPhone.isNotEmpty ? userPhone : null,
      shopRole: shopRole,
      permissions: permissions,
    );
  }

  @override
  Future<TokenPair> refreshTokens() async {
    final currentRefresh = await _storage.getSecure(AppConstants.keyRefreshToken);
    if (currentRefresh == null || currentRefresh.isEmpty) {
      throw const ApiException(message: 'No refresh token available');
    }
    final resp = await _dio.post(
      ApiEndpoints.refreshToken,
      data: {'refreshToken': currentRefresh},
    );
    final data = _extractData(resp.data as Map<String, dynamic>);
    final accessToken = data['accessToken'] as String? ?? '';
    final refreshToken = data['refreshToken'] as String? ?? '';

    return TokenPair(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  @override
  Future<void> logout() async {
    try {
      final currentRefresh = await _storage.getSecure(AppConstants.keyRefreshToken);
      if (currentRefresh != null && currentRefresh.isNotEmpty) {
        await _dio.post(
          ApiEndpoints.logout,
          data: {'refreshToken': currentRefresh},
        );
      }
    } finally {
      await _storage.clearSession();
    }
  }

  // -- Profile
  @override
  Future<VendorModel> getProfile() async {
    final resp = await _dio.get('/vendor/profile');
    final json = _extractData(resp.data as Map<String, dynamic>);
    return _parseVendor(json);
  }

  @override
  Future<VendorModel> updateProfile({
    required String name,
    required String email,
    String? description,
    String? addressLine1,
    String? city,
    String? state,
    String? pincode,
    String? logoUrl,
    String? bannerUrl,
  }) async {
    final data = <String, dynamic>{};
    if (name.isNotEmpty) data['name'] = name;
    if (email.isNotEmpty) data['email'] = email;
    if (description != null) data['description'] = description;
    if (addressLine1 != null) data['address_line1'] = addressLine1;
    if (city != null) data['city'] = city;
    if (state != null) data['state'] = state;
    if (pincode != null) data['pincode'] = pincode;
    if (logoUrl != null) data['logo_url'] = logoUrl;
    if (bannerUrl != null) data['banner_url'] = bannerUrl;

    final resp = await _dio.patch('/vendor/profile', data: data);
    final json = _extractData(resp.data as Map<String, dynamic>);
    return _parseVendor(json);
  }

  @override
  Future<String> uploadImage(XFile file, {String? folder}) async {
    // `folder` must precede `image` — @fastify/multipart only captures text
    // fields that arrive before the first file part in the stream (same
    // constraint as uploadApplicationDocument above).
    final formData = FormData.fromMap({
      if (folder != null) 'folder': folder,
      'image': await MultipartFile.fromFile(file.path, filename: file.name),
    });
    final resp = await _dio.post('/uploads/image', data: formData);
    final json = _extractData(resp.data as Map<String, dynamic>);
    return json['url'] as String? ?? '';
  }

  @override
  Future<VendorModel> toggleStoreOpen(bool isOpen) async {
    final resp = await _dio.patch('/vendor/profile', data: {'is_open': isOpen});
    final json = _extractData(resp.data as Map<String, dynamic>);
    return _parseVendor(json);
  }

  @override
  Future<void> publishProfile() async {
    await _dio.post('/vendor/profile/publish', data: const {});
  }

  // -- Onboarding application (wizard)
  @override
  Future<VendorApplicationModel> getOrCreateApplication() async {
    try {
      return await getApplicationMe();
    } on DioException catch (e) {
      // The error interceptor wraps the parsed ApiException inside
      // DioException.error rather than throwing it directly, so the status
      // code must be read off the DioException itself.
      if (e.response?.statusCode == 404) {
        // The backend's schema requires a JSON object body even though every
        // field is optional — an empty/missing body fails validation.
        final resp = await _dio.post('/vendor/applications', data: <String, dynamic>{});
        final json = _extractData(resp.data as Map<String, dynamic>);
        return _parseApplication(json, missingSteps: const []);
      }
      rethrow;
    }
  }

  @override
  Future<VendorApplicationModel> getApplicationMe() async {
    final resp = await _dio.get('/vendor/applications/me');
    final data = _extractData(resp.data as Map<String, dynamic>);
    final app = data['application'] as Map<String, dynamic>? ?? data;
    final missing = (data['missing_steps'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        const [];
    return _parseApplication(app, missingSteps: missing);
  }

  @override
  Future<VendorApplicationModel> updateApplicationOwner(
    String appId, {
    String? ownerName,
    String? email,
    String? phone,
    String? bankAccountNumber,
    String? bankIfsc,
    String? bankName,
    String? bankHolderName,
  }) async {
    final data = <String, dynamic>{};
    if (ownerName != null) data['owner_name'] = ownerName;
    if (email != null) data['email'] = email;
    if (phone != null) data['phone'] = phone;
    if (bankAccountNumber != null) data['bank_account_number'] = bankAccountNumber;
    if (bankIfsc != null) data['bank_ifsc'] = bankIfsc;
    if (bankName != null) data['bank_name'] = bankName;
    if (bankHolderName != null) data['bank_holder_name'] = bankHolderName;
    final resp = await _dio.patch('/vendor/applications/$appId/owner', data: data);
    final json = _extractData(resp.data as Map<String, dynamic>);
    return _parseApplication(json, missingSteps: const []);
  }

  @override
  Future<VendorApplicationModel> updateApplicationBusiness(
    String appId, {
    String? name,
    String? description,
    String? gstNumber,
    String? panNumber,
  }) async {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (description != null) data['description'] = description;
    if (gstNumber != null) data['gst_number'] = gstNumber;
    if (panNumber != null) data['pan_number'] = panNumber;
    final resp = await _dio.patch('/vendor/applications/$appId/business', data: data);
    final json = _extractData(resp.data as Map<String, dynamic>);
    return _parseApplication(json, missingSteps: const []);
  }

  @override
  Future<VendorApplicationModel> updateApplicationLocation(
    String appId, {
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? pincode,
    double? lat,
    double? lng,
  }) async {
    final data = <String, dynamic>{};
    if (addressLine1 != null) data['address_line1'] = addressLine1;
    if (addressLine2 != null) data['address_line2'] = addressLine2;
    if (city != null) data['city'] = city;
    if (state != null) data['state'] = state;
    if (pincode != null) data['pincode'] = pincode;
    if (lat != null) data['lat'] = lat;
    if (lng != null) data['lng'] = lng;
    final resp = await _dio.patch('/vendor/applications/$appId/location', data: data);
    final json = _extractData(resp.data as Map<String, dynamic>);
    return _parseApplication(json, missingSteps: const []);
  }

  @override
  Future<VendorApplicationModel> updateApplicationRadius(
    String appId,
    double requestedRadiusKm, {
    int? requestedDailyCapacity,
  }) async {
    final resp = await _dio.patch(
      '/vendor/applications/$appId/radius',
      data: {
        'requested_radius_km': requestedRadiusKm,
        if (requestedDailyCapacity != null) 'requested_daily_capacity': requestedDailyCapacity,
      },
    );
    final json = _extractData(resp.data as Map<String, dynamic>);
    return _parseApplication(json, missingSteps: const []);
  }

  @override
  Future<String> uploadApplicationDocument(
    String appId, {
    required String documentType,
    required XFile file,
  }) async {
    // `document_type` must be added before `file` — the backend's
    // @fastify/multipart only captures text fields that arrive before the
    // first file part in the stream, and FormData.fromMap preserves
    // insertion order.
    final formData = FormData.fromMap({
      'document_type': documentType,
      'file': await MultipartFile.fromFile(file.path, filename: file.name),
    });
    final resp = await _dio.post('/vendor/applications/$appId/documents', data: formData);
    final json = _extractData(resp.data as Map<String, dynamic>);
    return json['document_id'] as String? ?? '';
  }

  @override
  Future<void> deleteApplicationDocument(String appId, String documentId) async {
    await _dio.delete('/vendor/applications/$appId/documents/$documentId');
  }

  @override
  Future<VendorApplicationModel> submitApplication(String appId) async {
    await _dio.post('/vendor/applications/$appId/submit', data: const {});
    return getApplicationMe();
  }

  @override
  Future<VendorApplicationModel> resubmitApplication(String appId) async {
    await _dio.post('/vendor/applications/$appId/resubmit', data: const {});
    return getApplicationMe();
  }

  // -- Service categories (real, backend-fetched)
  @override
  Future<List<CategoryModel>> getServiceCategories() async {
    final resp = await _dio.get(ApiEndpoints.categories);
    final list = _extractList(resp.data as Map<String, dynamic>);
    return list.map((e) {
      final m = e as Map<String, dynamic>;
      return CategoryModel(
        id: m['id'] as String? ?? '',
        name: m['name'] as String? ?? '',
        description: m['description'] as String? ?? '',
        icon: m['image_url'] as String? ?? '',
        imageUrl: m['image_url'] as String?,
        isActive: m['is_active'] as bool? ?? true,
        sortOrder: _toInt(m['sort_order']) ?? 0,
      );
    }).toList();
  }

  @override
  Future<List<GarmentTypeModel>> getGarmentTypes(String categoryId) async {
    final resp = await _dio.get(ApiEndpoints.garmentTypes, queryParameters: {
      'category': categoryId,
      'limit': 100,
      'status': 'active',
    });
    final list = _extractList(resp.data as Map<String, dynamic>);
    return list.map((e) => GarmentTypeModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  // -- Services
  @override
  Future<List<ServiceModel>> getMyServices() async {
    final resp = await _dio.get('/vendor/services');
    final list = _extractList(resp.data as Map<String, dynamic>);
    return list.map((e) => _parseService(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<ServiceModel> addService(ServiceModel service) async {
    final payload = <String, dynamic>{
      'category_id': service.categoryId ?? service.category.id,
      'category': service.category.name,
      'name': service.name,
      'description': service.description,
      // Omitted (not sent as 0) when null — the DB column is constrained
      // to NULL or >= 0.01, and this legacy field isn't used by the
      // subcategory-rate pricing model anyway.
      if (service.pricePerPiece != null) 'price_per_piece': (service.pricePerPiece! * 100).toInt(),
      'min_weight_kg': service.minWeightKg,
    };
    debugPrint('Outgoing POST /vendor/services request: $payload');
    final resp = await _dio.post('/vendor/services', data: payload);
    final json = _extractData(resp.data as Map<String, dynamic>);
    return _parseService(json);
  }

  @override
  Future<ServiceModel> updateService(ServiceModel service) async {
    final payload = <String, dynamic>{
      'category_id': service.categoryId ?? service.category.id,
      'category': service.category.name,
      'name': service.name,
      'description': service.description,
      if (service.pricePerPiece != null) 'price_per_piece': (service.pricePerPiece! * 100).toInt(),
      'min_weight_kg': service.minWeightKg,
      'is_available': service.isAvailable,
    };
    debugPrint('Outgoing PATCH /vendor/services/${service.id} request: $payload');
    final resp = await _dio.patch('/vendor/services/${service.id}', data: payload);
    final json = _extractData(resp.data as Map<String, dynamic>);
    return _parseService(json);
  }

  @override
  Future<void> toggleServiceAvailability(String serviceId, bool isAvailable) async {
    await _dio.patch('/vendor/services/$serviceId', data: {
      'is_available': isAvailable,
    });
  }

  @override
  Future<void> deleteService(String serviceId) async {
    await _dio.delete('/vendor/services/$serviceId');
  }

  @override
  Future<Map<String, dynamic>> getServiceDetails(String serviceId) async {
    final resp = await _dio.get('/vendor/services/$serviceId');
    return _extractData(resp.data as Map<String, dynamic>);
  }

  @override
  Future<void> addGarmentRate(
    String serviceId, {
    String? garmentTypeId,
    String? garmentTypeName,
    required double rate,
    String? rateUnit,
  }) async {
    final data = <String, dynamic>{
      'rate_paise': (rate * 100).toInt(),
      if (garmentTypeId != null) 'garment_type_id': garmentTypeId,
      if (garmentTypeName != null) 'garment_type_name': garmentTypeName,
      if (rateUnit != null) 'rate_unit': rateUnit,
    };
    await _dio.post('/vendor/services/$serviceId/garment-rates', data: data);
  }

  @override
  Future<void> deleteGarmentRate(String serviceId, String garmentTypeId) async {
    await _dio.delete('/vendor/services/$serviceId/garment-rates/$garmentTypeId');
  }

  @override
  Future<void> bulkUpsertGarmentRates(String serviceId, List<GarmentRateUpsertItem> items) async {
    await _dio.post('/vendor/services/$serviceId/garment-rates/bulk', data: {
      'garment_rates': items
          .map((i) => {
                'garment_type_id': i.garmentTypeId,
                'rate_paise': i.ratePaise,
                'is_available': i.isActive,
              })
          .toList(),
    });
  }

  // -- Orders
  @override
  Future<OrderModel> getOrder(String orderId) async {
    final resp = await _dio.get('/vendor/orders/$orderId');
    final json = _extractData(resp.data as Map<String, dynamic>);
    return _parseOrder(json);
  }

  @override
  Future<PaginatedResponse<OrderModel>> getIncomingOrders({
    PaginationParams params = const PaginationParams(),
    String? status,
  }) async {
    final resp = await _dio.get(
      '/vendor/orders',
      queryParameters: {
        'page': params.page,
        'limit': params.pageSize,
        if (status != null) 'status': status,
      },
    );
    final body = resp.data as Map<String, dynamic>;
    final list = _extractList(body);
    final pagination = body['pagination'] as Map<String, dynamic>?;

    final orders =
        list.map((e) => _parseOrder(e as Map<String, dynamic>)).toList();
    return PaginatedResponse(
      items: orders,
      meta: PaginationMeta(
        currentPage: (pagination?['page'] as int?) ?? params.page,
        totalPages: (pagination?['totalPages'] as int?) ?? 1,
        totalItems: (pagination?['total'] as int?) ?? list.length,
        pageSize: (pagination?['limit'] as int?) ?? params.pageSize,
      ),
    );
  }

  @override
  Future<OrderModel> acceptOrder(String orderId) async {
    final resp = await _dio.post('/vendor/orders/$orderId/accept', data: const {});
    final json = _extractData(resp.data as Map<String, dynamic>);
    return _parseOrder(json);
  }

  @override
  Future<OrderModel> rejectOrder(String orderId, {String? reason}) async {
    final resp = await _dio.post(
      '/vendor/orders/$orderId/reject',
      data: reason != null ? {'reason': reason} : const {},
    );
    final json = _extractData(resp.data as Map<String, dynamic>);
    return _parseOrder(json);
  }

  @override
  Future<OrderModel> assignRider(String orderId, String employeeId) async {
    await _dio.post(
      '/vendor/orders/$orderId/assign-rider',
      data: {'employee_id': employeeId},
    );
    return getOrder(orderId);
  }

  @override
  Future<void> broadcastRider(String orderId) async {
    await _dio.post('/vendor/orders/$orderId/broadcast-rider', data: const {});
  }

  @override
  Future<void> acceptJobOffer(String orderId) async {
    await _dio.post('/vendor/rider/offers/$orderId/accept', data: const {});
  }

  @override
  Future<OrderModel> markOrderReady(String orderId) async {
    return updateProcessingStage(orderId, 'PACKED');
  }

  @override
  Future<OrderModel> updateProcessingStage(String orderId, String stage) async {
    final resp = await _dio.post(
      '/vendor/orders/$orderId/processing-stage',
      data: {'status': stage},
    );
    final json = _extractData(resp.data as Map<String, dynamic>);
    return _parseOrder(json);
  }

  @override
  Future<Map<String, dynamic>> reconcileOrder(
    String orderId, {
    List<Map<String, dynamic>>? lines,
    double? confirmedWeightKg,
    String? adjustmentReason,
    required List<String> photoUrls,
    List<Map<String, dynamic>>? newLines,
  }) async {
    final body = <String, dynamic>{'photo_urls': photoUrls};
    if (lines != null) body['lines'] = lines;
    if (confirmedWeightKg != null) body['confirmed_weight_kg'] = confirmedWeightKg;
    if (adjustmentReason != null) body['adjustment_reason'] = adjustmentReason;
    if (newLines != null && newLines.isNotEmpty) body['new_lines'] = newLines;

    final resp = await _dio.post(
      '/vendor/orders/$orderId/reconcile',
      data: body,
    );
    return _extractData(resp.data as Map<String, dynamic>);
  }

  @override
  Future<List<ReclassifyOption>> getVendorServiceCatalog() async {
    // Auth-scoped to the calling vendor — was previously (wrongly) hitting
    // the public /discovery/vendors/:vendorId/services endpoint, which has
    // no images/category and isn't guaranteed to match this vendor's real,
    // reconciliation-eligible rate list.
    final resp = await _dio.get('/vendor/services/catalogue');
    final list = _extractList(resp.data as Map<String, dynamic>);
    return list.map((e) {
      final m = e as Map<String, dynamic>;
      return ReclassifyOption(
        garmentTypeId: m['garment_type_id'] as String? ?? '',
        garmentName: m['garment_name'] as String? ?? 'Item',
        unit: m['unit'] as String? ?? 'piece',
        ratePaise: (m['rate_paise'] as num?)?.toInt() ?? 0,
        serviceName: m['service_name'] as String? ?? '',
        categoryName: m['category_name'] as String?,
        imageUrl: m['image_url'] as String?,
      );
    }).where((o) => o.garmentTypeId.isNotEmpty).toList();
  }

  @override
  Future<Map<String, dynamic>> getDashboardStats() async {
    final resp = await _dio.get('/vendor/orders/stats');
    return _extractData(resp.data as Map<String, dynamic>);
  }

  // -- Device Tokens
  @override
  Future<void> registerDevice({
    required String deviceId,
    required String platform,
    required String fcmToken,
  }) async {
    // The backend's registerTokenSchema requires exactly {token, platform}
    // — {device_id, fcm_token} previously failed AJV validation (400) on
    // every call, so vendor push notifications were silently never wired up.
    await _dio.post(ApiEndpoints.registerDeviceToken, data: {
      'token': fcmToken,
      'platform': platform,
    });
  }

  @override
  Future<void> unregisterDevice(String deviceId) async {
    await _dio.delete('${ApiEndpoints.devices}/$deviceId');
  }

  @override
  Future<List<NotificationModel>> getNotifications({int page = 1, int limit = 20}) async {
    final resp = await _dio.get(ApiEndpoints.notifications, queryParameters: {
      'page': page,
      'limit': limit,
    });
    final data = _extractData(resp.data as Map<String, dynamic>);
    final list = (data['notifications'] as List<dynamic>? ?? []);
    return list.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> markNotificationRead(String notificationId) async {
    await _dio.patch(ApiEndpoints.markNotificationRead(notificationId));
  }

  @override
  Future<void> markAllNotificationsRead() async {
    await _dio.patch(ApiEndpoints.markAllRead);
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    await _dio.delete('${ApiEndpoints.notifications}/$notificationId');
  }

  List<String> _mapUiPermissionsToBackend(List<String> uiPermissions) {
    final backend = <String>[];
    for (final p in uiPermissions) {
      switch (p) {
        case 'orders:read':
          backend.add('shop_orders.view');
          break;
        case 'orders:write':
          backend.addAll(['shop_orders.view', 'shop_orders.update_status', 'shop_orders.assign_rider', 'shop_orders.cancel']);
          break;
        case 'catalog:write':
          backend.addAll(['vendor_services.create', 'vendor_services.update', 'vendor_services.delete', 'vendor_services.view']);
          break;
        case 'staff:write':
          backend.addAll(['vendor_staff.create', 'vendor_staff.update', 'vendor_staff.delete', 'vendor_staff.view']);
          break;
        default:
          backend.add(p);
      }
    }
    return backend.toSet().toList();
  }

  List<String> _mapBackendPermissionsToUi(List<String> backendPermissions) {
    final ui = <String>[];
    final backendSet = backendPermissions.toSet();
    if (backendSet.contains('shop_orders.view')) {
      ui.add('orders:read');
    }
    if (backendSet.contains('shop_orders.update_status')) {
      ui.add('orders:write');
    }
    if (backendSet.contains('vendor_services.create') ||
        backendSet.contains('vendor_services.update')) {
      ui.add('catalog:write');
    }
    if (backendSet.contains('vendor_staff.create') ||
        backendSet.contains('vendor_staff.update')) {
      ui.add('staff:write');
    }
    return ui;
  }

  EmployeeModel _parseEmployee(Map<String, dynamic> json) {
    final mappedJson = Map<String, dynamic>.from(json);
    if (mappedJson['permissions'] != null) {
      mappedJson['permissions'] = _mapBackendPermissionsToUi(
        (mappedJson['permissions'] as List<dynamic>).map((e) => e.toString()).toList(),
      );
    }
    return EmployeeModel.fromJson(mappedJson);
  }

  // -- Employees
  @override
  Future<List<EmployeeModel>> getEmployees() async {
    final resp = await _dio.get('/vendor/employees');
    final data = _extractData(resp.data as Map<String, dynamic>);
    final list = data['staff'] as List<dynamic>? ?? [];
    return list.map((e) => _parseEmployee(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<EmployeeModel> createEmployee({
    required String name,
    required String email,
    required String role,
    String? phone,
    List<String>? permissions,
  }) async {
    final resp = await _dio.post('/vendor/employees', data: {
      'name': name,
      'email': email,
      'role': role,
      if (phone != null) 'phone': phone,
      if (permissions != null) 'permissions': _mapUiPermissionsToBackend(permissions),
    });
    final json = _extractData(resp.data as Map<String, dynamic>);
    return _parseEmployee(json);
  }

  @override
  Future<EmployeeModel> updateEmployee(
    String id, {
    required String role,
    required List<String> permissions,
    required bool isActive,
  }) async {
    final resp = await _dio.patch('/vendor/employees/$id', data: {
      'role': role,
      'permissions': _mapUiPermissionsToBackend(permissions),
      'is_active': isActive,
    });
    final json = _extractData(resp.data as Map<String, dynamic>);
    return _parseEmployee(json);
  }

  @override
  Future<void> deleteEmployee(String id) async {
    await _dio.delete('/vendor/employees/$id');
  }

  @override
  Future<void> resetEmployeePassword(String id, String newPassword) async {
    await _dio.post('/vendor/employees/$id/reset-password', data: {
      'password': newPassword,
    });
  }

  @override
  Future<List<EmployeeModel>> getRiders() async {
    final resp = await _dio.get(
      '/vendor/employees',
      queryParameters: {'role': 'VENDOR_RIDER'},
    );
    final data = _extractData(resp.data as Map<String, dynamic>);
    final list = data['staff'] as List<dynamic>? ?? [];
    return list.map((e) => _parseEmployee(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<EmployeeModel> createRider({
    required String name,
    required String phone,
  }) async {
    final resp = await _dio.post('/vendor/employees', data: {
      'name': name,
      'phone': phone,
      'role': 'VENDOR_RIDER',
    });
    final json = _extractData(resp.data as Map<String, dynamic>);
    return _parseEmployee(json);
  }

  @override
  Future<List<RiderJobModel>> getRiderJobs() async {
    final resp = await _dio.get('/vendor/rider/jobs');
    final list = _extractList(resp.data as Map<String, dynamic>);
    return list
        .map((e) => RiderJobModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<RiderJobModel> getRiderJobDetail(String orderId) async {
    final resp = await _dio.get('/vendor/rider/jobs/$orderId');
    final data = _extractData(resp.data as Map<String, dynamic>);
    return RiderJobModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<List<RiderJobModel>> getJobOffers() async {
    final resp = await _dio.get('/vendor/rider/offers');
    final list = _extractList(resp.data as Map<String, dynamic>);
    return list
        .map((e) => RiderJobModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> startPickup(String orderId) async {
    // Fastify's JSON body parser 400s on a truly empty body even though this
    // route has no fields to send — an empty object satisfies it.
    await _dio.post('/vendor/rider/jobs/$orderId/start-pickup', data: {});
  }

  @override
  Future<void> startDelivery(String orderId) async {
    await _dio.post('/vendor/rider/jobs/$orderId/start-delivery', data: {});
  }

  @override
  Future<void> submitPickupMeasurements(
    String orderId, {
    double? confirmedWeightKg,
    required List<Map<String, dynamic>> lines,
  }) async {
    final body = <String, dynamic>{'lines': lines};
    if (confirmedWeightKg != null) body['confirmed_weight_kg'] = confirmedWeightKg;
    await _dio.post(
      '/vendor/rider/jobs/$orderId/measurements',
      data: body,
    );
  }

  @override
  Future<void> submitPickupPhotos(
    String orderId,
    List<Map<String, dynamic>> photos,
  ) async {
    await _dio.post(
      '/vendor/rider/jobs/$orderId/pickup-photos',
      data: {'photos': photos},
    );
  }

  @override
  Future<void> verifyPickupOtp(String orderId, String otp) async {
    await _dio.post(
      '/vendor/rider/jobs/$orderId/pickup-otp/verify',
      data: {'otp': otp},
    );
  }

  @override
  Future<Map<String, dynamic>> collectBalance(String orderId) async {
    final resp = await _dio.post(
      '/vendor/rider/jobs/$orderId/collect-balance',
      data: {},
    );
    return _extractData(resp.data as Map<String, dynamic>);
  }

  @override
  Future<void> submitDeliveryPhotos(
    String orderId,
    List<Map<String, dynamic>> photos,
  ) async {
    await _dio.post(
      '/vendor/rider/jobs/$orderId/delivery-photos',
      data: {'photos': photos},
    );
  }

  @override
  Future<void> verifyDeliveryOtp(String orderId, String otp) async {
    await _dio.post(
      '/vendor/rider/jobs/$orderId/delivery-otp/verify',
      data: {'otp': otp},
    );
  }

  // -- Capacity & Slots
  @override
  Future<Map<String, dynamic>> getCapacity() async {
    final resp = await _dio.get('/vendor/capacity');
    return _extractData(resp.data as Map<String, dynamic>);
  }

  @override
  Future<void> requestCapacityChange(int maxOrdersPerDay) async {
    // Same URL/verb as before — only the backend's interpretation changed,
    // from an instant write to creating a pending capacity_requests row.
    await _dio.put('/vendor/capacity/daily-limit', data: {
      'max_orders_per_day': maxOrdersPerDay,
    });
  }

  @override
  Future<List<PickupSlotModel>> getPickupSlots() async {
    final resp = await _dio.get('/vendor/pickup-slots');
    final list = _extractList(resp.data as Map<String, dynamic>);
    return list.map((e) => PickupSlotModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<PickupSlotModel> createPickupSlot({
    required int dayOfWeek,
    required String startTime,
    required String endTime,
    int? maxOrders,
  }) async {
    final resp = await _dio.post('/vendor/pickup-slots', data: {
      'day_of_week': dayOfWeek,
      'start': startTime,
      'end': endTime,
      if (maxOrders != null) 'max_orders': maxOrders,
    });
    final json = _extractData(resp.data as Map<String, dynamic>);
    return PickupSlotModel.fromJson(json);
  }

  @override
  Future<PickupSlotModel> updatePickupSlot(
    String id, {
    int? maxOrders,
    bool? isActive,
  }) async {
    final data = <String, dynamic>{};
    if (maxOrders != null) data['max_orders'] = maxOrders;
    if (isActive != null) data['is_active'] = isActive;

    final resp = await _dio.patch('/vendor/pickup-slots/$id', data: data);
    final json = _extractData(resp.data as Map<String, dynamic>);
    return PickupSlotModel.fromJson(json);
  }

  @override
  Future<void> deletePickupSlot(String id) async {
    await _dio.delete('/vendor/pickup-slots/$id');
  }

  // -- Parsers
  double? _toDouble(dynamic val) {
    if (val == null) return null;
    if (val is num) return val.toDouble();
    if (val is String) return double.tryParse(val);
    return null;
  }

  int? _toInt(dynamic val) {
    if (val == null) return null;
    if (val is num) return val.toInt();
    if (val is String) return int.tryParse(val);
    return null;
  }

  VendorModel _parseVendor(Map<String, dynamic> json) => VendorModel(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        email: json['email'] as String?,
        isVerified: json['is_verified'] as bool? ?? json['isVerified'] as bool? ?? false,
        isOpen: json['is_open'] as bool? ?? json['isOpen'] as bool? ?? true,
        description: json['description'] as String? ?? '',
        ownerName: json['owner_name'] as String? ?? json['ownerName'] as String? ?? '',
        logoUrl: json['logo_url'] as String? ?? json['logoUrl'] as String?,
        coverImageUrl: json['banner_url'] as String? ?? json['bannerUrl'] as String? ?? json['coverImageUrl'] as String?,
        averageRating: _toDouble(json['rating']) ?? _toDouble(json['average_rating']) ?? _toDouble(json['averageRating']),
        reviewCount: _toInt(json['review_count']) ?? _toInt(json['reviewCount']) ?? 0,
        estimatedTurnaroundHours: _toInt(json['estimated_turnaround_hours']) ?? _toInt(json['estimatedTurnaroundHours']) ?? 24,
        address: json['address'] != null
            ? AddressModel.fromJson(json['address'] as Map<String, dynamic>)
            : AddressModel(
                id: json['id'] as String? ?? '',
                userId: '',
                line1: json['address_line1'] as String? ?? '',
                line2: json['address_line2'] as String?,
                city: json['city'] as String? ?? '',
                state: json['state'] as String? ?? '',
                pincode: json['pincode'] as String? ?? '',
                type: AddressType.other,
                coordinates: (json['lat'] != null && json['lng'] != null)
                    ? LatLng(
                        latitude: _toDouble(json['lat']) ?? 0.0,
                        longitude: _toDouble(json['lng']) ?? 0.0,
                      )
                    : null,
              ),
      );

  ServiceModel _parseService(Map<String, dynamic> json) {
    final catEnum = _parseServiceCategory(
        json['category_name'] as String? ?? json['category'] as String?);
    return ServiceModel(
      id: json['id'] as String? ?? '',
      vendorId:
          json['vendor_id'] as String? ?? json['vendorId'] as String? ?? '',
      name: json['name'] as String? ?? json['category_name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: catEnum,
      categoryId: json['category_id'] as String? ??
          json['categoryId'] as String? ??
          catEnum.id,
      minWeightKg: _toDouble(json['min_weight_kg']) ??
          _toDouble(json['minWeightKg']) ??
          1.0,
      isAvailable: json['is_available'] as bool? ??
          json['isAvailable'] as bool? ??
          true,
      pricePerPiece: (_toDouble(json['price_per_piece']) ??
              _toDouble(json['pricePerPiece']) ??
              0.0) /
          100.0,
      approvalStatus: json['approval_status'] as String? ?? json['approvalStatus'] as String?,
      rejectionReason: json['rejection_reason'] as String? ?? json['rejectionReason'] as String?,
      latestOverrideReason: json['latest_override_reason'] as String?,
      latestOverrideAt: json['latest_override_at'] != null
          ? DateTime.tryParse(json['latest_override_at'] as String)
          : null,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  /// payable_amount_paise is the confirmed final payable total; falls back to
  /// the pre-confirmation estimate, then to the plain-rupee total_amount for
  /// orders that predate the paise-denominated fields.
  double _parseOrderTotal(Map<String, dynamic> json) {
    final paiseTotal = _toDouble(json['payable_amount_paise']) ??
        _toDouble(json['estimated_amount_paise']);
    if (paiseTotal != null && paiseTotal > 0) return paiseTotal / 100.0;
    return _toDouble(json['total_amount']) ?? _toDouble(json['totalAmount']) ?? 0.0;
  }

  /// Formats the `delivery_address` jsonb snapshot stored on the order into
  /// a single display line — this is the address the pickup was placed
  /// against, not a live lookup, so it stays accurate even if the customer
  /// edits/deletes the address later.
  String _formatDeliveryAddress(Map<String, dynamic> json) {
    final addr = json['delivery_address'] ?? json['deliveryAddress'];
    if (addr is! Map) return '';
    final line1 = addr['addressLine1'] ?? addr['address_line1'];
    final city = addr['city'];
    final state = addr['state'];
    final pincode = addr['pincode'];
    final parts = [line1, city, state]
        .whereType<String>()
        .where((s) => s.isNotEmpty)
        .join(', ');
    if (pincode is String && pincode.isNotEmpty) {
      return parts.isEmpty ? pincode : '$parts - $pincode';
    }
    return parts;
  }

  OrderModel _parseOrder(Map<String, dynamic> json) => OrderModel(
        id: json['id'] as String? ?? '',
        orderNumber: json['order_number'] as String? ?? json['orderNumber'] as String? ?? '',
        customerId: json['customer_id'] as String? ?? json['customerId'] as String? ?? '',
        customerName: json['customer_name'] as String? ?? json['customerName'] as String? ?? '',
        customerPhone: json['customer_phone'] as String? ?? json['customerPhone'] as String? ?? '',
        deliveryAddressText: _formatDeliveryAddress(json),
        customerRating: _toDouble(json['vendor_rating']),
        deliveryRating: _toDouble(json['delivery_rating']),
        customerReview: json['review_comment'] as String?,
        vendorId: json['vendor_id'] as String? ?? json['vendorId'] as String? ?? '',
        status: _parseOrderStatus(json['status'] as String?),
        subtotal: _toDouble(json['subtotal']) ?? 0.0,
        platformFee: _toDouble(json['platform_fee']) ?? _toDouble(json['platformFee']) ?? 0.0,
        gstAmount: _toDouble(json['tax_amount']) ?? _toDouble(json['gstAmount']) ?? 0.0,
        deliveryFee: _toDouble(json['delivery_fee']) ?? _toDouble(json['deliveryFee']) ?? 0.0,
        handlingFee: _toDouble(json['handling_fee']) ?? _toDouble(json['handlingFee']) ?? 0.0,
        total: _parseOrderTotal(json),
        vendorCommissionEnabled: json['vendor_commission_enabled'] as bool? ?? false,
        vendorCommissionType: json['vendor_commission_type'] as String? ?? 'PERCENT',
        vendorCommissionRate: _toDouble(json['vendor_commission_rate']) ?? 0.0,
        vendorCommissionAmount: _toDouble(json['vendor_commission_amount']) ?? 0.0,
        vendorGstOnCommissionEnabled: json['vendor_gst_on_commission_enabled'] as bool? ?? false,
        vendorGstRate: _toDouble(json['vendor_gst_rate']) ?? 0.0,
        vendorGstOnCommissionAmount: _toDouble(json['vendor_gst_on_commission_amount']) ?? 0.0,
        vendorPayoutAmount: _toDouble(json['vendor_payout_amount']) ?? 0.0,
        paymentMethod: _parsePaymentMethod(
            json['payment_method'] as String? ?? json['paymentMethod'] as String?),
        isPaid: (json['payment_status'] as String? ?? json['paymentStatus'] as String?)
                ?.toUpperCase() ==
            'PAID',
        // `lines` is the live order_lines table (real, stable `id` per row —
        // the identity rider measurement/vendor reconciliation submissions
        // key against). `items` is a static JSONB snapshot taken at checkout
        // with no such id, kept only as a fallback for any response shape
        // that hasn't been updated to include `lines` yet.
        items: ((json['lines'] as List<dynamic>?) ?? (json['items'] as List<dynamic>?))
                ?.map((e) {
                  final m = e as Map<String, dynamic>;
                  return OrderItem(
                    serviceId: m['garment_type_id'] as String? ??
                        m['service_id'] as String? ??
                        m['serviceId'] as String? ??
                        '',
                    serviceName: m['garment_type_name'] as String? ??
                        m['name'] as String? ??
                        m['service_name'] as String? ??
                        m['serviceName'] as String? ??
                        'Item',
                    quantity: _toInt(m['confirmed_quantity']) ??
                        _toInt(m['quantity']) ??
                        _toInt(m['estimated_quantity']) ??
                        1,
                    unitPrice: _toDouble(m['rate_paise']) != null
                        ? _toDouble(m['rate_paise'])! / 100.0
                        : (_toDouble(m['unit_price']) ?? _toDouble(m['unitPrice']) ?? 0.0),
                    totalPrice: _toDouble(m['total_paise']) != null
                        ? _toDouble(m['total_paise'])! / 100.0
                        : (_toDouble(m['total_price']) ?? _toDouble(m['totalPrice']) ?? 0.0),
                    notes: m['notes'] as String?,
                    unit: m['unit'] as String? ?? m['garment_unit'] as String? ?? 'piece',
                    orderLineId: m['id'] as String?,
                  );
                })
                .toList() ??
            [],
        createdAt: DateTime.tryParse(
                json['created_at'] as String? ?? json['createdAt'] as String? ?? '') ??
            DateTime.now(),
        pendingReconciliation: _parsePendingReconciliation(json['latestReconciliation']),
        pickupAssignment: _parseRiderAssignment(json['pickupAssignment']),
        deliveryAssignment: _parseRiderAssignment(json['deliveryAssignment']),
      );

  RiderAssignmentView? _parseRiderAssignment(dynamic raw) {
    if (raw is! Map<String, dynamic>) return null;
    final status = raw['status'] as String?;
    if (status == null) return null;
    return RiderAssignmentView(
      riderName: raw['riderName'] as String?,
      riderPhone: raw['riderPhone'] as String?,
      status: status,
      isBroadcastOffer: raw['isBroadcastOffer'] as bool? ?? false,
      offerExpiresAt: DateTime.tryParse(raw['offerExpiresAt'] as String? ?? ''),
    );
  }

  VendorReconciliationView? _parsePendingReconciliation(dynamic raw) {
    if (raw is! Map<String, dynamic>) return null;
    final status = raw['status'] as String?;
    // Only shown while it's the thing actually blocking the order (or was
    // the most recent thing to — disputed) — an already-applied rider
    // measurement or a long-accepted proposal isn't "the latest re-
    // evaluation" in the sense this UI cares about.
    if (status != 'PENDING_CUSTOMER' && status != 'REJECTED') return null;

    final lineChanges = (raw['line_changes'] as List<dynamic>?)
            ?.map((e) {
              final m = e as Map<String, dynamic>;
              return VendorReconciliationLineChange(
                previousName: m['previous_name'] as String?,
                proposedName: m['proposed_name'] as String?,
                proposedUnit: m['proposed_unit'] as String?,
                proposedQuantity: (m['proposed_quantity'] as num?) ?? 0,
                isNew: m['is_new'] as bool? ?? false,
                isReclassified: m['is_reclassified'] as bool? ?? false,
              );
            })
            .toList() ??
        [];

    return VendorReconciliationView(
      status: status ?? 'PENDING_CUSTOMER',
      proposedPayableAmountPaise: _toInt(raw['proposed_payable_amount_paise']) ?? 0,
      previousPayableAmountPaise: _toInt(raw['previous_payable_amount_paise']) ?? 0,
      reason: raw['reason'] as String?,
      photos: (raw['photos'] as List<dynamic>?)?.map((p) => p.toString()).toList() ?? [],
      lineChanges: lineChanges,
    );
  }

  PaymentMethod _parsePaymentMethod(String? raw) {
    switch (raw?.toUpperCase().trim()) {
      case 'COD':
      case 'CASH':
        return PaymentMethod.cod;
      case 'CARD':
      case 'CREDIT_CARD':
      case 'DEBIT_CARD':
        return PaymentMethod.card;
      case 'WALLET':
        return PaymentMethod.wallet;
      case 'UPI':
      case 'ONLINE':
      case 'NET_BANKING':
      default:
        return PaymentMethod.upi;
    }
  }

  VendorApplicationModel _parseApplication(
    Map<String, dynamic> json, {
    required List<String> missingSteps,
  }) {
    final docs = (json['documents'] as List<dynamic>?)
            ?.map((e) => _parseApplicationDocument(e as Map<String, dynamic>))
            .toList() ??
        const <VendorApplicationDocumentModel>[];
    return VendorApplicationModel(
      id: json['id'] as String? ?? '',
      ownerId: json['owner_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      status: json['status'] as String? ?? 'DRAFT',
      ownerName: json['owner_name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      bankAccountNumber: json['bank_account_number'] as String?,
      bankIfsc: json['bank_ifsc'] as String?,
      bankName: json['bank_name'] as String?,
      bankHolderName: json['bank_holder_name'] as String?,
      description: json['description'] as String?,
      gstNumber: json['gst_number'] as String?,
      panNumber: json['pan_number'] as String?,
      addressLine1: json['address_line1'] as String?,
      addressLine2: json['address_line2'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      pincode: json['pincode'] as String?,
      lat: _toDouble(json['lat']),
      lng: _toDouble(json['lng']),
      requestedServiceRadiusKm: _toDouble(json['requested_service_radius_km']) ?? 5.0,
      approvedServiceRadiusKm: _toDouble(json['approved_service_radius_km']),
      requestedDailyCapacity: json['requested_daily_capacity'] as int?,
      rejectionReason: json['rejection_reason'] as String?,
      correctionSections: (json['correction_sections'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      documents: docs,
      missingSteps: missingSteps,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at'] as String? ?? ''),
    );
  }

  VendorApplicationDocumentModel _parseApplicationDocument(Map<String, dynamic> json) =>
      VendorApplicationDocumentModel(
        id: json['id'] as String? ?? '',
        documentType: json['document_type'] as String? ?? '',
        status: json['status'] as String? ?? 'PENDING',
        rejectionReason: json['rejection_reason'] as String?,
      );

  @visibleForTesting
  VendorModel parseVendorForTest(Map<String, dynamic> json) => _parseVendor(json);

  @visibleForTesting
  ServiceModel parseServiceForTest(Map<String, dynamic> json) => _parseService(json);

  @visibleForTesting
  OrderModel parseOrderForTest(Map<String, dynamic> json) => _parseOrder(json);

  @visibleForTesting
  VendorApplicationModel parseApplicationForTest(
    Map<String, dynamic> json, {
    List<String> missingSteps = const [],
  }) =>
      _parseApplication(json, missingSteps: missingSteps);

  ServiceCategory _parseServiceCategory(String? category) {
    if (category == null) return ServiceCategory.wash;
    final lower = category.toLowerCase().trim();
    return switch (lower) {
      // Canonical API values
      'wash' => ServiceCategory.wash,
      'iron' || 'ironing' => ServiceCategory.iron,
      'wash_iron' || 'wash & iron' || 'wash and iron' => ServiceCategory.washAndIron,
      'dry_clean' || 'dry_cleaning' || 'dry clean' => ServiceCategory.dryClean,
      'fold' || 'wash_fold' || 'wash & fold' || 'wash and fold' => ServiceCategory.fold,
      'premium' || 'premium_garment_care' || 'premium garment care' => ServiceCategory.premium,
      // Additional backend category names from service_categories table
      'blanket cleaning' || 'blanket_cleaning' || 'blanket' => ServiceCategory.premium,
      'carpet cleaning' || 'carpet_cleaning' || 'carpet' => ServiceCategory.premium,
      'curtain cleaning' || 'curtain_cleaning' || 'curtain' => ServiceCategory.premium,
      'shoe care' || 'shoe_care' || 'shoe carejjjjjj' => ServiceCategory.premium,
      // Unknown → default to wash
      _ => ServiceCategory.wash,
    };
  }

  OrderStatus _parseOrderStatus(String? status) {
    if (status == null) return OrderStatus.waitingForVendorConfirmation;
    final lower = status.toLowerCase();
    return switch (lower) {
      'payment_pending' => OrderStatus.paymentPending,
      'payment_failed' => OrderStatus.paymentFailed,
      'waiting_for_vendor_confirmation' || 'waiting_vendor_confirmation' => OrderStatus.waitingForVendorConfirmation,
      'vendor_accepted' => OrderStatus.vendorAccepted,
      'pickup_assigned' => OrderStatus.pickupAssigned,
      'going_for_pickup' => OrderStatus.goingForPickup,
      'pickup_otp_verified' => OrderStatus.pickupOtpVerified,
      'picked_up' => OrderStatus.pickedUp,
      'received_at_vendor' => OrderStatus.receivedAtVendor,
      'reconciliation_pending' => OrderStatus.reconciliationPending,
      'reconciliation_disputed' => OrderStatus.reconciliationDisputed,
      'processing' || 'washing' || 'drying' || 'ironing' => OrderStatus.processing,
      'packed' => OrderStatus.packed,
      'delivery_assigned' => OrderStatus.deliveryAssigned,
      'out_for_delivery' => OrderStatus.outForDelivery,
      'delivery_otp_verified' => OrderStatus.deliveryOtpVerified,
      'delivered' => OrderStatus.delivered,
      'vendor_rejected' => OrderStatus.vendorRejected,
      'auto_rejected' => OrderStatus.autoRejected,
      'customer_cancelled' => OrderStatus.customerCancelled,
      'admin_cancelled' => OrderStatus.adminCancelled,
      'refund_pending' => OrderStatus.refundPending,
      'refunded' => OrderStatus.refunded,
      _ => OrderStatus.waitingForVendorConfirmation,
    };
  }

  @override
  Future<Map<String, dynamic>> getAnalyticsSummary({String period = 'week'}) async {
    final resp = await _dio.get(
      '/vendor/analytics/summary',
      queryParameters: {'period': period},
    );
    return _extractData(resp.data as Map<String, dynamic>);
  }

  @override
  Future<Map<int, Map<String, dynamic>>> getWorkingHours() async {
    final resp = await _dio.get('/vendor/profile');
    final json = _extractData(resp.data as Map<String, dynamic>);

    // operating_hours.schedule is stored as { "0": {...}, "1": {...}, ... }
    final rawHours = json['operating_hours'] as Map<String, dynamic>?;
    final schedule = rawHours?['schedule'] as Map<String, dynamic>? ?? {};

    final result = <int, Map<String, dynamic>>{};
    for (int day = 0; day < 7; day++) {
      final dayData = schedule[day.toString()] as Map<String, dynamic>?;
      result[day] = {
        'isOpen': dayData?['isOpen'] as bool? ?? true,
        'openTime': dayData?['openTime'] as String? ?? '08:00',
        'closeTime': dayData?['closeTime'] as String? ?? '20:00',
      };
    }
    return result;
  }

  @override
  Future<void> updateWorkingHours(
    int dayOfWeek, {
    required bool isOpen,
    required String openTime,
    required String closeTime,
  }) async {
    // Fetch current operating_hours so we can merge just the one day
    final profileResp = await _dio.get('/vendor/profile');
    final profileJson = _extractData(profileResp.data as Map<String, dynamic>);
    final rawHours = profileJson['operating_hours'] as Map<String, dynamic>? ?? {};
    final schedule =
        Map<String, dynamic>.from(rawHours['schedule'] as Map<String, dynamic>? ?? {});

    schedule[dayOfWeek.toString()] = {
      'isOpen': isOpen,
      'openTime': openTime,
      'closeTime': closeTime,
    };

    await _dio.patch('/vendor/profile', data: {
      'operating_hours': {
        ...rawHours,
        'schedule': schedule,
      },
    });
  }

  // -- Support Tickets
  @override
  Future<Map<String, dynamic>> createSupportTicket({
    required String title,
    required String description,
    required String category,
  }) async {
    final resp = await _dio.post('/vendor/support-tickets', data: {
      'title': title,
      'description': description,
      'category': category,
    });
    return _extractData(resp.data as Map<String, dynamic>);
  }

  @override
  Future<List<Map<String, dynamic>>> getSupportTickets() async {
    final resp = await _dio.get('/vendor/support-tickets');
    final list = _extractList(resp.data as Map<String, dynamic>);
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  @override
  Future<Map<String, dynamic>> getSupportTicket(String id) async {
    final resp = await _dio.get('/vendor/support-tickets/$id');
    return _extractData(resp.data as Map<String, dynamic>);
  }

  @override
  Future<Map<String, dynamic>> rateSupportTicket(String id, int rating) async {
    final resp = await _dio.post('/vendor/support-tickets/$id/rate', data: {
      'rating': rating,
    });
    return _extractData(resp.data as Map<String, dynamic>);
  }

  @override
  Future<Map<String, dynamic>> followUpSupportTicket(String id, String message) async {
    final resp = await _dio.post('/vendor/support-tickets/$id/follow-up', data: {
      'message': message,
    });
    return _extractData(resp.data as Map<String, dynamic>);
  }
}

// ── Provider ────────────────────────────────────────────────────────────────────

final vendorRepositoryProvider = Provider<VendorRepository>((ref) {
  final storage = ref.watch(storageServiceProvider);
  if (Env.demoMode) {
    return DemoVendorRepository(storage: storage);
  }
  final dio = ref.watch(dioClientProvider);
  return ApiVendorRepository(dio: dio, storage: storage);
});
