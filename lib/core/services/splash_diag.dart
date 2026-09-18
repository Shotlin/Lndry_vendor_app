import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../config/env.dart';

/// Temporary diagnostics for the splash-hang investigation (2026-09-16) —
/// the affected tester device is remote with no physical access available.
/// Two independent channels, so this works even if the device can't reach
/// the network at all (which the server-log channel alone can't tell us):
///   1. [splashDiagLastStep] — updated synchronously, no network involved.
///      splash_page.dart displays it on-screen, so whatever step it's
///      frozen on is directly visible in a screenshot or screen recording,
///      the same way the first video already showed us the symptom.
///   2. A best-effort ping to the backend, readable with:
///        docker compose logs api | grep VENDOR_SPLASH_DIAG
///      Fire-and-forget with a 3s timeout and a swallowed error — it can
///      never itself add a hang or crash risk to the flow it's diagnosing,
///      but it also proves nothing if the device has no network path to
///      the server at all (channel 1 covers that case).
/// Delete this file, its call sites, and splash_page.dart's step text once
/// this investigation is closed.
final String _diagSessionId = DateTime.now().millisecondsSinceEpoch.toString();

final ValueNotifier<String> splashDiagLastStep = ValueNotifier<String>('starting…');

final Dio _diagDio = Dio(
  BaseOptions(
    baseUrl: Env.socketBaseUrl,
    connectTimeout: const Duration(seconds: 3),
    receiveTimeout: const Duration(seconds: 3),
    sendTimeout: const Duration(seconds: 3),
  ),
);

void splashDiag(String step, [Map<String, dynamic>? extra]) {
  splashDiagLastStep.value = step;
  unawaited(_pingDiag(step, extra));
}

Future<void> _pingDiag(String step, Map<String, dynamic>? extra) async {
  try {
    await _diagDio.post<void>(
      '/health/diag',
      data: {
        'app': 'vendor',
        'sessionId': _diagSessionId,
        'step': step,
        if (extra != null) 'extra': extra,
      },
    );
  } catch (_) {
    // Best-effort only — a failed diagnostic ping must never surface.
  }
}
