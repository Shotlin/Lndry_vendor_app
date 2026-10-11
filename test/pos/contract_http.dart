import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:lndry_vendor_app/core/network/api_exception.dart';

/// Reads a REAL backend response saved in test/pos/fixtures.
String fixtureText(String file) => File('test/pos/fixtures/$file').readAsStringSync();

/// An in-memory server for contract tests: each route answers with a captured fixture (`name.json`) or raw text.
class FixtureServer implements HttpClientAdapter {
  final Map<String, ({int status, String body, String type})> routes = {};
  final List<RequestOptions> requests = [];

  void on(String method, String path, String fixtureName, {int status = 200}) =>
      routes['$method $path'] = (status: status, body: fixtureText('$fixtureName.json'), type: 'application/json');

  void onText(String method, String path, String text, {int status = 200, String type = 'text/csv'}) =>
      routes['$method $path'] = (status: status, body: text, type: type);

  RequestOptions last(String method, String path) => requests.lastWhere((r) => r.method == method && r.path == path);

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
    final headers = {Headers.contentTypeHeader: [hit.type]};
    return options.responseType == ResponseType.bytes
        ? ResponseBody.fromBytes(utf8.encode(hit.body), hit.status, headers: headers)
        : ResponseBody.fromString(hit.body, hit.status, headers: headers);
  }
}

/// A Dio the way the app builds it: a failed call arrives as a DioException whose `.error` is an ApiException.
({Dio dio, FixtureServer http}) makeContractDio() {
  final http = FixtureServer();
  final dio = Dio(BaseOptions(baseUrl: 'http://test/api/v1'))..httpClientAdapter = http;
  dio.interceptors.add(InterceptorsWrapper(onError: (e, handler) {
    final data = e.response?.data;
    final exception = data is Map<String, dynamic>
        ? ApiException(message: (data['message'] ?? '').toString(), statusCode: e.response?.statusCode, code: data['code']?.toString())
        : ApiException(message: e.message ?? 'Request failed', statusCode: e.response?.statusCode);
    handler.next(DioException(requestOptions: e.requestOptions, response: e.response, type: e.type, error: exception, message: exception.message));
  }));
  return (dio: dio, http: http);
}
