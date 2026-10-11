import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lndry_vendor_app/api/repositories/api_app_mode_repository.dart';
import 'package:lndry_vendor_app/models/pos/app_mode_model.dart';

/// Contract test: the fixtures in test/pos/fixtures are REAL responses captured from a running
/// Lndry_backend (see docs/vendor-app-mode.md). They prove the Dart side parses exactly what the
/// server sends — no hand-written mock that could drift from the API.
String fixture(String name) => File('test/pos/fixtures/$name.json').readAsStringSync();

class _Adapter implements HttpClientAdapter {
  final Map<String, ({int status, String body})> routes = {};
  final List<RequestOptions> requests = [];

  void on(String method, String path, String fixtureName, {int status = 200}) =>
      routes['$method $path'] = (status: status, body: fixture(fixtureName));

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    requests.add(options);
    final hit = routes['${options.method} ${options.path}'];
    if (hit == null) {
      return ResponseBody.fromString(jsonEncode({'success': false, 'message': 'no route ${options.method} ${options.path}'}), 404,
          headers: {Headers.contentTypeHeader: ['application/json']});
    }
    return ResponseBody.fromString(hit.body, hit.status, headers: {
      Headers.contentTypeHeader: ['application/json']
    });
  }
}

({ApiAppModeRepository repo, _Adapter http}) make() {
  final http = _Adapter();
  final dio = Dio(BaseOptions(baseUrl: 'http://test/api/v1'))..httpClientAdapter = http;
  return (repo: ApiAppModeRepository(dio), http: http);
}

void main() {
  test('a user with no shop yet: hasVendor=false, can start POS, no modes', () async {
    final t = make()..http.on('GET', '/vendor/app-mode', 'app_mode_new_user');
    final info = await t.repo.getAppMode();
    expect(info.hasVendor, isFalse);
    expect(info.offering, isNull);
    expect(info.canStartPos, isTrue);
    expect(info.allowedModes, isEmpty);
    expect(info.posOnboardingStatus, PosOnboardingStatus.notStarted);
  });

  test('start: a new POS-only shop is created and the login must be renewed', () async {
    final t = make()..http.on('POST', '/vendor/pos-onboarding/start', 'start_created');
    final r = await t.repo.startPosOnboarding();
    expect(r.created, isTrue);
    expect(r.needsTokenRefresh, isTrue);
    expect(r.info.offering, VendorOffering.pos);
    expect(r.info.posOnboardingStatus, PosOnboardingStatus.inProgress);
    expect(r.info.role, 'VENDOR_OWNER');
    expect(r.info.vendorType, 'STANDARD');
    expect(r.info.appSync, isFalse);
    expect(r.info.walletAccess, isFalse);
    expect(r.info.allowedModes, isEmpty, reason: 'POS is only allowed once setup is complete');
    expect(r.info.needsPosOnboarding, isTrue);
    expect(t.http.requests.single.data, isA<Map<String, dynamic>>(), reason: 'an empty JSON body is sent, never a null body');
  });

  test('start again is idempotent: same shop, not created, no renewal', () async {
    final t = make()
      ..http.on('POST', '/vendor/pos-onboarding/start', 'start_created');
    final first = await t.repo.startPosOnboarding();
    final t2 = make()..http.on('POST', '/vendor/pos-onboarding/start', 'start_again');
    final again = await t2.repo.startPosOnboarding();
    expect(again.created, isFalse);
    expect(again.needsTokenRefresh, isFalse);
    expect(again.info.vendorId, first.info.vendorId);
  });

  test('get onboarding: fresh shop has everything missing and starts at "shop"', () async {
    final t = make()..http.on('GET', '/vendor/pos-onboarding', 'onboarding_fresh');
    final s = await t.repo.getPosOnboarding();
    expect(s.status, PosOnboardingStatus.inProgress);
    expect(s.missingSteps, ['shop', 'tax', 'counter', 'pricelist']);
    expect(s.nextStep, 'shop');
    expect(s.data, isEmpty);
  });

  test('save step: sends {step, data} and parses the saved answers + next step', () async {
    final t = make()..http.on('PATCH', '/vendor/pos-onboarding', 'save_shop');
    final s = await t.repo.savePosOnboardingStep('shop', {'name': 'Fixture Laundry'});
    expect(t.http.requests.single.data, {'step': 'shop', 'data': {'name': 'Fixture Laundry'}});
    expect(s.step('shop')['name'], 'Fixture Laundry');
    expect(s.step('shop')['pincode'], '411001');
    expect(s.nextStep, 'tax');
    expect(s.missingSteps, ['tax', 'counter', 'pricelist']);
  });

  test('complete: POS becomes allowed and the starter price list counts come through', () async {
    final t = make()..http.on('POST', '/vendor/pos-onboarding/complete', 'complete_starter');
    final r = await t.repo.completePosOnboarding();
    expect(r.info.posOnboardingStatus, PosOnboardingStatus.completed);
    expect(r.info.allowedModes, [AppMode.pos]);
    expect(r.info.needsPosOnboarding, isFalse);
    expect(r.starterCounts, {'categories': 3, 'services': 4, 'garments': 13, 'prices': 36});
  });

  test('app-mode after completion: shop name from the wizard, POS only', () async {
    final t = make()..http.on('GET', '/vendor/app-mode', 'app_mode_pos_completed');
    final info = await t.repo.getAppMode();
    expect(info.shopName, 'Fixture Laundry');
    expect(info.allowedModes, [AppMode.pos]);
    expect(info.canSwitchMode, isFalse);
  });

  test('a validation error surfaces as a DioException carrying the server\'s plain message', () async {
    final t = make()..http.on('PATCH', '/vendor/pos-onboarding', 'error_validation', status: 400);
    try {
      await t.repo.savePosOnboardingStep('tax', {'gstEnabled': true, 'gstin': 'BAD'});
      fail('should have thrown');
    } on DioException catch (e) {
      expect(e.response?.statusCode, 400);
      expect((e.response?.data as Map<String, dynamic>)['message'], 'Enter a valid 15-character GSTIN, or turn GST off.');
      expect((e.response?.data as Map<String, dynamic>)['code'], 'VALIDATION_ERROR');
    }
  });

  test('an unexpected body (HTML error page, empty) is a clear error, not a crash in the UI layer', () async {
    final http = _Adapter();
    final dio = Dio(BaseOptions(baseUrl: 'http://test'))..httpClientAdapter = http;
    final repo = ApiAppModeRepository(dio);
    http.routes['GET /vendor/app-mode'] = (status: 200, body: jsonEncode({'success': true, 'data': {'nothing': true}}));
    await expectLater(repo.getAppMode(), throwsA(anything));
  });
}
