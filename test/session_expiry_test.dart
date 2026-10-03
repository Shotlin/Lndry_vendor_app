import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lndry_vendor_app/core/constants/app_constants.dart';
import 'package:lndry_vendor_app/core/network/network.dart';
import 'package:lndry_vendor_app/core/services/storage_service.dart';
import 'package:lndry_vendor_app/models/models.dart';
import 'package:lndry_vendor_app/providers/auth_provider.dart';
import 'package:lndry_vendor_app/repositories/repositories.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Storage extends StorageService {
  _Storage({required super.prefs});
  final Map<String, String> secure = {};
  @override
  Future<void> saveSecure(String key, String value) async => secure[key] = value;
  @override
  Future<String?> getSecure(String key) async => secure[key];
  @override
  Future<void> deleteSecure(String key) async => secure.remove(key);
  @override
  Future<void> deleteAllSecure() async => secure.clear();
  @override
  Future<Map<String, String>> getAllSecure() async => Map.of(secure);
}

class _Repo implements VendorRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Auth extends AuthNotifier {
  _Auth(super.repo, super.storage);
  void signIn() => state = const AuthAuthenticated(
        VendorModel(
          id: 'v1',
          name: 'Shop',
          description: '',
          ownerName: 'Owner',
          phone: '9999999999',
          address: AddressModel(
            id: 'a', userId: 'u', line1: 'x', city: 'c', state: 's',
            pincode: '400001', type: AddressType.home,
          ),
        ),
        shopRole: 'VENDOR_OWNER',
      );
}

/// Protected calls answer 401 unless they carry the renewed token; the
/// refresh endpoint answers with [refreshStatus] (200 = a new token pair,
/// 0 = no internet).
class _Adapter implements HttpClientAdapter {
  _Adapter({required this.refreshStatus});
  final int refreshStatus;
  @override
  void close({bool force = false}) {}
  @override
  Future<ResponseBody> fetch(RequestOptions o, Stream<Uint8List>? s,
      Future<void>? c) async {
    ResponseBody json(int code, Map<String, dynamic> b) => ResponseBody.fromString(
        jsonEncode(b), code,
        headers: {Headers.contentTypeHeader: ['application/json']});
    if (o.path.contains('refresh-token')) {
      if (refreshStatus == 200) {
        return json(200, {
          'success': true,
          'data': {'accessToken': 'new-a', 'refreshToken': 'new-r'}
        });
      }
      if (refreshStatus == 0) {
        throw DioException(requestOptions: o, type: DioExceptionType.connectionError);
      }
      return json(refreshStatus, {'success': false, 'message': 'no'});
    }
    if (o.headers['Authorization'] == 'Bearer new-a') {
      return json(200, {'success': true, 'data': {}});
    }
    return json(401, {'success': false, 'message': 'Unauthorized'});
  }
}

void main() {
  late _Storage storage;
  late _Auth auth;
  late ProviderContainer container;
  late bool noticeRaised;

  Future<void> setUpSession({required int refreshStatus, String? refresh = 'old-r'}) async {
    SharedPreferences.setMockInitialValues({'fresh_install_reset_done_v3': true});
    final prefs = await SharedPreferences.getInstance();
    storage = _Storage(prefs: prefs);
    auth = _Auth(_Repo(), storage);
    noticeRaised = false;
    auth.onSessionExpired = () => noticeRaised = true;
    await Future<void>.delayed(const Duration(milliseconds: 100));
    // Set up the saved login only after the notifier's own startup is done.
    storage.secure
      ..clear()
      ..[AppConstants.keyAccessToken] = 'old-a';
    if (refresh != null) storage.secure[AppConstants.keyRefreshToken] = refresh;
    auth.signIn();
    container = ProviderContainer(overrides: [
      storageServiceProvider.overrideWithValue(storage),
      authProvider.overrideWith((ref) => auth),
    ]);
    container.read(dioClientProvider).httpClientAdapter =
        _Adapter(refreshStatus: refreshStatus);
  }

  Future<Response<dynamic>> callProtected() => container
      .read(dioClientProvider)
      .post<dynamic>('/vendor/orders', data: {});

  tearDown(() => container.dispose());

  test('a rejected refresh ends the session and flags the login notice', () async {
    await setUpSession(refreshStatus: 401);
    await expectLater(callProtected(), throwsA(isA<DioException>()));
    expect(container.read(authProvider), isA<AuthUnauthenticated>());
    expect(noticeRaised, isTrue);
    expect(storage.secure, isEmpty);
  });

  test('a missing refresh token ends the session too', () async {
    await setUpSession(refreshStatus: 200, refresh: null);
    await expectLater(callProtected(), throwsA(isA<DioException>()));
    expect(container.read(authProvider), isA<AuthUnauthenticated>());
  });

  test('no internet during refresh keeps the user signed in', () async {
    await setUpSession(refreshStatus: 0);
    await expectLater(callProtected(), throwsA(isA<DioException>()));
    expect(container.read(authProvider), isA<AuthAuthenticated>());
    expect(noticeRaised, isFalse);
    expect(storage.secure[AppConstants.keyRefreshToken], 'old-r');
  });

  test('a server error during refresh keeps the user signed in', () async {
    await setUpSession(refreshStatus: 503);
    await expectLater(callProtected(), throwsA(isA<DioException>()));
    expect(container.read(authProvider), isA<AuthAuthenticated>());
    expect(storage.secure[AppConstants.keyRefreshToken], 'old-r');
  });

  test('a good refresh retries the request and stays signed in', () async {
    await setUpSession(refreshStatus: 200);
    final r = await callProtected();
    expect(r.statusCode, 200);
    expect(container.read(authProvider), isA<AuthAuthenticated>());
    expect(storage.secure[AppConstants.keyRefreshToken], 'new-r');
  });

  test('expiring twice (several failing calls at once) raises the notice once', () async {
    await setUpSession(refreshStatus: 401);
    await auth.handleSessionExpired();
    noticeRaised = false;
    await auth.handleSessionExpired();
    expect(noticeRaised, isFalse);
  });
}
