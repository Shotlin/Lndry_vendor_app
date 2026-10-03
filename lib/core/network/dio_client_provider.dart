// ignore_for_file: inference_failure_on_function_invocation

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../config/env.dart';
import '../services/storage_service.dart';
import '../services/splash_diag.dart';
import '../constants/app_constants.dart';
import 'api_response.dart';
import 'api_exception.dart';
import 'api_endpoints.dart';
import '../../providers/auth_provider.dart';
// No mock imports needed for production-only client

// ── Dio Client Provider ─────────────────────────────────────────────────────────

final dioClientProvider = Provider<Dio>((ref) {
  final storage = ref.watch(storageServiceProvider);
  final dio = _createDio(storage, ref);
  return dio;
});

Dio _createDio(StorageService storage, Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: Env.baseUrl,
      connectTimeout: const Duration(milliseconds: Env.connectTimeoutMs),
      receiveTimeout: const Duration(milliseconds: Env.receiveTimeoutMs),
      sendTimeout: const Duration(milliseconds: Env.receiveTimeoutMs),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  // ── Diagnostic interceptor for the splash-hang investigation (2026-09-16)
  // — logs every request/response/error made through this client so the
  // actual HTTP traffic during startup is visible instead of guessed at.
  // Temporary; remove alongside splash_diag.dart once that investigation
  // is closed.
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      splashDiag('http_request', {'method': options.method, 'path': options.path});
      handler.next(options);
    },
    onResponse: (response, handler) {
      splashDiag('http_response', {
        'status': response.statusCode,
        'path': response.requestOptions.path,
      });
      handler.next(response);
    },
    onError: (error, handler) {
      splashDiag('http_error', {
        'type': error.type.toString(),
        'status': error.response?.statusCode,
        'path': error.requestOptions.path,
      });
      handler.next(error);
    },
  ));

  // ── Auth interceptor: inject Bearer token ──────────────────────────────────
  dio.interceptors.add(QueuedInterceptorsWrapper(
    onRequest: (options, handler) async {
      // Don't add auth header for auth endpoints
      final path = options.path;
      if (_isPublicEndpoint(path)) {
        return handler.next(options);
      }

      try {
        final token = await storage.getSecure(AppConstants.keyAccessToken);
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
      } catch (_) {
        // Secure storage read failed; proceed without token
      }

      return handler.next(options);
    },
    onError: (error, handler) async {
      // A 401 on a signed-in request means the access token is no longer
      // valid: try to renew it once with the refresh token.
      final path = error.requestOptions.path;
      if (error.response?.statusCode != 401 || _isPublicEndpoint(path)) {
        return handler.next(error);
      }
      splashDiag('http_401_handler_start', {'path': path});

      final refreshToken =
          await storage.getSecure(AppConstants.keyRefreshToken);
      if (refreshToken == null || refreshToken.isEmpty) {
        // Nothing to renew with: the session is over.
        _expireSession(ref);
        return handler.next(error);
      }

      String? newAccess;
      try {
        final refreshDio = Dio(
          BaseOptions(
            baseUrl: Env.baseUrl,
            connectTimeout: const Duration(milliseconds: Env.connectTimeoutMs),
            receiveTimeout: const Duration(milliseconds: Env.receiveTimeoutMs),
          ),
        )..httpClientAdapter = dio.httpClientAdapter;
        splashDiag('http_401_refresh_attempt');
        final resp = await refreshDio.post(
          ApiEndpoints.refreshToken,
          data: {'refreshToken': refreshToken},
        );
        splashDiag('http_401_refresh_response', {'status': resp.statusCode});
        final data = resp.data as Map<String, dynamic>?;
        final body = data?['data'] as Map<String, dynamic>?;
        newAccess = body?['accessToken'] as String?;
        final newRefresh = body?['refreshToken'] as String?;
        if (newAccess != null) {
          await storage.saveSecure(AppConstants.keyAccessToken, newAccess);
          if (newRefresh != null) {
            await storage.saveSecure(AppConstants.keyRefreshToken, newRefresh);
          }
        }
      } on DioException catch (e) {
        // Only a definite "this session is not valid" answer ends the
        // session. No internet / timeout / server error must never sign the
        // person out — they just retry later.
        final code = e.response?.statusCode;
        splashDiag('http_401_refresh_failed', {'status': code});
        if (code == 400 || code == 401 || code == 403) _expireSession(ref);
        return handler.next(error);
      } catch (e) {
        splashDiag('http_401_refresh_failed', {'error': e.toString()});
        return handler.next(error);
      }

      if (newAccess == null) {
        _expireSession(ref);
        return handler.next(error);
      }

      // Retry the original request with the new token.
      try {
        error.requestOptions.headers['Authorization'] = 'Bearer $newAccess';
        splashDiag('http_401_retry_refetch', {'path': path});
        final retryResponse = await dio.fetch<dynamic>(error.requestOptions);
        splashDiag('http_401_retry_refetch_done');
        return handler.resolve(retryResponse);
      } on DioException catch (retryError) {
        return handler.next(retryError);
      }
    },
  ));

  // ── Error interceptor: parse structured API errors ─────────────────────────
  dio.interceptors.add(InterceptorsWrapper(
    onError: (error, handler) {
      // Real backend connection error handling only
      final apiException = _parseError(error);
      error = DioException(
        requestOptions: error.requestOptions,
        response: error.response,
        type: error.type,
        error: apiException,
        message: apiException.message,
      );
      handler.next(error);
    },
  ));

  // ── Logging interceptor (debug only) ──────────────────────────────────────
  if (Env.enableNetworkLogging) {
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: false,
        requestBody: false,
        responseBody: false,
        responseHeader: false,
        compact: true,
      ),
    );
  }

  return dio;
}

// ── Helpers ────────────────────────────────────────────────────────────────────

/// The login can't be renewed any more (expired, revoked, or signed in
/// somewhere else): sign out in the app so the router sends the person to the
/// login screen and they see why, instead of every screen failing with a
/// misleading connection error.
void _expireSession(Ref ref) {
  try {
    ref.read(authProvider.notifier).handleSessionExpired();
  } catch (_) {}
}

/// Paths that do not require an auth token.
bool _isPublicEndpoint(String path) {
  final normalized = path.replaceAll(Env.baseUrl, '');
  return normalized.startsWith('/auth/send-otp') ||
      normalized.startsWith('/auth/verify-otp') ||
      normalized.startsWith('/auth/refresh-token') ||
      normalized.startsWith('/service-categories') ||
      normalized.startsWith('/discovery') ||
      normalized.startsWith('/banners') ||
      normalized.startsWith('/theme') ||
      normalized.startsWith('/tip-presets') ||
      normalized.startsWith('/payment-offers') ||
      normalized.startsWith('/garment-types') ||
      normalized.startsWith('/garment_rates') ||
      normalized.startsWith('/health');
}

/// Parse a [DioException] into a structured [ApiException].
ApiException _parseError(DioException error) {
  // Timeout
  if (error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.receiveTimeout ||
      error.type == DioExceptionType.sendTimeout) {
    return ApiException.timeout();
  }

  // No internet / connection refused
  if (error.type == DioExceptionType.connectionError ||
      error.type == DioExceptionType.unknown) {
    return ApiException.networkError(
      error.message ?? 'No internet connection',
    );
  }

  // Try parsing structured error body
  final response = error.response;
  if (response != null && response.data is Map<String, dynamic>) {
    final apiError = ApiError.fromJson(response.data as Map<String, dynamic>);
    return ApiException.fromApiError(
      apiError,
      statusCode: response.statusCode,
    );
  }

  // Fallback
  return ApiException(
    message: error.message ?? 'Request failed',
    statusCode: response?.statusCode,
  );
}

// ── Helper: create a Dio instance that can be used outside providers ───────────
/// Useful for one-shot requests (e.g. refresh token) where the full provider
/// infrastructure is not needed.
Dio createSimpleDio() => Dio(
      BaseOptions(
        baseUrl: Env.baseUrl,
        connectTimeout: const Duration(milliseconds: Env.connectTimeoutMs),
        receiveTimeout: const Duration(milliseconds: Env.receiveTimeoutMs),
      ),
    );
