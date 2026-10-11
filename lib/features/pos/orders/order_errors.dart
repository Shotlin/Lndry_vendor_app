import 'package:dio/dio.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/friendly_error.dart';
import '../../../l10n/generated/app_localizations.dart';

/// The backend's error code (`INVALID_TRANSITION`, `ASSEMBLY_INCOMPLETE`, …) behind anything thrown by a call, if any.
String? errorCodeOf(Object? error) {
  if (error is ApiException) return error.code;
  if (error is DioException && error.error is ApiException) {
    return (error.error as ApiException).code;
  }
  return null;
}

bool isNetworkProblem(Object? error) {
  if (error is ApiException) return error.statusCode == null;
  if (error is DioException) {
    return error.error is ApiException
        ? (error.error as ApiException).statusCode == null
        : error.response == null;
  }
  return false;
}

/// One plain sentence for a failed order action. Codes are never shown: the backend's own sentence (written for people)
/// is passed through, except for the two cases the app can say better itself.
String orderErrorText(Object? error, AppLocalizations l10n) {
  switch (errorCodeOf(error)) {
    case 'VERSION_CONFLICT':
      return l10n.posOrdChanged;
    case 'FORBIDDEN':
      return l10n.posNoPermission;
  }
  return friendlyError(error);
}
