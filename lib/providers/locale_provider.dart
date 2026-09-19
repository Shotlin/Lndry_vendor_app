import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_constants.dart';
import '../core/network/friendly_error.dart';
import '../core/services/storage_service.dart';

const _hinglishLocale = Locale.fromSubtags(languageCode: 'hi', scriptCode: 'Latn');

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier(this._storage) : super(_restore(_storage)) {
    activeErrorLocale = state;
  }

  final StorageService _storage;

  static Locale _restore(StorageService storage) {
    final saved = storage.getString(AppConstants.keyLocale);
    return switch (saved) {
      'hi' => const Locale('hi'),
      'hi-Latn' => _hinglishLocale,
      _ => const Locale('en'),
    };
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    activeErrorLocale = locale;
    final code = locale.scriptCode == 'Latn' ? 'hi-Latn' : locale.languageCode;
    await _storage.saveString(AppConstants.keyLocale, code);
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return LocaleNotifier(storage);
});
