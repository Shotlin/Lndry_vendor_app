import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/network.dart';
import '../../models/pos/app_mode_model.dart';
import '../../repositories/abstract/app_mode_repository.dart';

class ApiAppModeRepository implements AppModeRepository {
  ApiAppModeRepository(this._dio);
  final Dio _dio;

  Map<String, dynamic> _data(Response<dynamic> resp) {
    final body = resp.data;
    if (body is! Map<String, dynamic>) {
      throw const ApiException(message: 'Unexpected answer from the server');
    }
    final data = body['data'];
    return data is Map<String, dynamic> ? data : body;
  }

  AppModeInfo _info(Map<String, dynamic> data) {
    final raw = data['appMode'];
    if (raw is! Map<String, dynamic>) {
      throw const ApiException(message: 'Unexpected answer from the server');
    }
    return AppModeInfo.fromJson(raw);
  }

  @override
  Future<AppModeInfo> getAppMode() async => _info(_data(await _dio.get('/vendor/app-mode')));

  @override
  Future<PosStartResult> startPosOnboarding() async {
    final data = _data(await _dio.post('/vendor/pos-onboarding/start', data: <String, dynamic>{}));
    return PosStartResult(
      info: _info(data),
      created: data['created'] == true,
      needsTokenRefresh: data['needsTokenRefresh'] == true,
    );
  }

  @override
  Future<PosOnboardingState> getPosOnboarding() async {
    final data = _data(await _dio.get('/vendor/pos-onboarding'));
    final raw = data['onboarding'];
    if (raw is! Map<String, dynamic>) throw const ApiException(message: 'Unexpected answer from the server');
    return PosOnboardingState.fromJson(raw);
  }

  @override
  Future<PosOnboardingState> savePosOnboardingStep(String step, Map<String, dynamic> data) async {
    final res = _data(await _dio.patch('/vendor/pos-onboarding', data: {'step': step, 'data': data}));
    final raw = res['onboarding'];
    if (raw is! Map<String, dynamic>) throw const ApiException(message: 'Unexpected answer from the server');
    return PosOnboardingState.fromJson(raw);
  }

  @override
  Future<PosCompleteResult> completePosOnboarding() async {
    final data = _data(await _dio.post('/vendor/pos-onboarding/complete', data: <String, dynamic>{}));
    final starter = data['starterPricelist'];
    return PosCompleteResult(
      info: _info(data),
      starterCounts: starter is Map ? starter.map((k, v) => MapEntry(k.toString(), (v as num).toInt())) : null,
    );
  }
}

final appModeRepositoryProvider = Provider<AppModeRepository>(
  (ref) => ApiAppModeRepository(ref.watch(dioClientProvider)),
);
