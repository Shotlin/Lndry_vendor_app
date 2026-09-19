import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

import '../../l10n/generated/app_localizations.dart';
import 'api_exception.dart';

/// The language the app is currently showing, kept in step by `LocaleNotifier`
/// so errors caught far from a `BuildContext` can still be shown in it.
Locale activeErrorLocale = const Locale('en');

/// Turns anything that can be thrown while talking to the backend into ONE
/// short sentence that is safe to show a person.
///
/// Users never see `DioException`, HTTP status text, stack traces or class
/// names. A message the backend wrote for people (e.g. "This phone number is
/// already added to your shop as a captain.") is passed through; anything
/// technical — a 5xx, a gateway error, a timeout, a dropped connection, an
/// unknown exception — becomes a plain, translated sentence instead.
String friendlyError(Object? error) {
  final l10n = lookupAppLocalizations(activeErrorLocale);

  final api = _apiExceptionOf(error);
  if (api != null) {
    if (api.code == 'TIMEOUT') return l10n.errorTimeout;
    final status = api.statusCode;
    if (status == null) return l10n.errorNetwork;
    if (status >= 500) return l10n.errorServerBusy;
    return _readable(api.message) ?? l10n.errorGeneric;
  }

  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return l10n.errorTimeout;
      case DioExceptionType.connectionError:
        return l10n.errorNetwork;
      default:
        break;
    }
    final status = error.response?.statusCode;
    if (status != null && status >= 500) return l10n.errorServerBusy;
    final data = error.response?.data;
    if (data is Map && data['message'] is String) {
      final message = _readable(data['message'] as String);
      if (message != null) return message;
    }
    return l10n.errorGeneric;
  }

  // A programming Error (StateError, TypeError, …) is never meant for people.
  if (error is Error) return l10n.errorGeneric;

  // Some code throws Exception('A sentence meant for people'); keep those,
  // drop the "Exception: " prefix, and hide anything that looks technical.
  final text = error?.toString() ?? '';
  final stripped = text.startsWith('Exception: ') ? text.substring(11) : text;
  return _readable(stripped) ?? l10n.errorGeneric;
}

ApiException? _apiExceptionOf(Object? error) {
  if (error is ApiException) return error;
  if (error is DioException && error.error is ApiException) {
    return error.error as ApiException;
  }
  return null;
}

/// The message if it is a short sentence a person can read; null if it looks
/// like framework/HTTP output.
String? _readable(String? raw) {
  final message = raw?.trim() ?? '';
  if (message.isEmpty || message.length > 160) return null;
  const technical = [
    'DioException',
    'DioError',
    'RequestOptions',
    'ApiException',
    'status code',
    'Http status',
    'Exception',
    'Error:',
    'Instance of',
    'Null check',
    'type \'',
    'package:',
    'dart:',
    'developer.mozilla.org',
    'content-type',
    'application/json',
    'Body cannot',
    'Unhandled',
    'StackTrace',
  ];
  for (final marker in technical) {
    if (message.contains(marker)) return null;
  }
  if (message == 'Unknown error' || message == 'Request failed') return null;
  return message;
}
