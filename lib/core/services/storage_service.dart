import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// StorageService provider
final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError(
    'StorageService must be overridden in ProviderScope overrides.',
  );
});

/// SharedPreferences provider — initialized before runApp
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'SharedPreferences must be overridden in ProviderScope overrides.',
  );
});

/// Unified storage service combining SharedPreferences (non-sensitive)
/// and FlutterSecureStorage (sensitive data like tokens).
class StorageService {
  StorageService({
    required SharedPreferences prefs,
  })  : _prefs = prefs,
        // encryptedSharedPreferences routes through Jetpack Security's
        // EncryptedSharedPreferences, which has a long history of hanging
        // (not throwing — just never returning) during Keystore key
        // generation on certain Android builds/chipsets, especially very
        // new Android versions on budget SoCs. Leaving it at the plugin's
        // default (false) uses AndroidKeyStore-backed per-value AES
        // encryption directly instead, which is the broadly-compatible
        // path and avoids that failure mode.
        _secure = const FlutterSecureStorage(
          iOptions: IOSOptions(
            accessibility: KeychainAccessibility.first_unlock,
          ),
        );

  final SharedPreferences _prefs;
  final FlutterSecureStorage _secure;

  // ── SharedPreferences (non-sensitive) ─────────────────────────────────────

  Future<bool> saveString(String key, String value) =>
      _prefs.setString(key, value);

  String? getString(String key) => _prefs.getString(key);

  Future<bool> saveBool(String key, {required bool value}) =>
      _prefs.setBool(key, value);

  bool? getBool(String key) => _prefs.getBool(key);

  Future<bool> saveInt(String key, int value) =>
      _prefs.setInt(key, value);

  int? getInt(String key) => _prefs.getInt(key);

  Future<bool> saveDouble(String key, double value) =>
      _prefs.setDouble(key, value);

  double? getDouble(String key) => _prefs.getDouble(key);

  Future<bool> saveStringList(String key, List<String> value) =>
      _prefs.setStringList(key, value);

  List<String>? getStringList(String key) => _prefs.getStringList(key);

  Future<bool> remove(String key) => _prefs.remove(key);

  Future<bool> clearAll() => _prefs.clear();

  bool containsKey(String key) => _prefs.containsKey(key);

  // ── FlutterSecureStorage (sensitive) ──────────────────────────────────────
  //
  // Every method here is guarded against TWO independent Android Keystore
  // failure modes, not just one:
  //  1. Hanging indefinitely instead of returning (seen on Unisoc-based
  //     budget chipsets) — guarded with a 5s .timeout().
  //  2. Throwing instead of returning — confirmed live 2026-09-16 via a
  //     remote device stuck on the splash screen: its diagnostic trail
  //     stopped dead immediately after the app tried to read a stored
  //     token, with none of the several timeout-based safety nets added
  //     earlier ever getting a chance to fire, because a *thrown*
  //     exception unwinds the calling function immediately rather than
  //     waiting around for a timer to rescue it. The classic trigger: the
  //     app is reinstalled, Android's own backup/restore brings back the
  //     *encrypted bytes* from the old install (this app doesn't disable
  //     that), but the AES key that encrypted them lived in the old
  //     install's Keystore entry, which is gone — decrypting the restored
  //     ciphertext with a new key throws (commonly BAD_DECRYPT /
  //     KeyPermanentlyInvalidated on Android), not hangs. A `.timeout()`
  //     does nothing for a call that fails fast.
  // Every method below now catches both: any failure, slow or immediate,
  // degrades to the same safe fallback a caller already treats as normal
  // ("no token stored") instead of propagating an exception that a
  // fire-and-forget caller (e.g. AuthNotifier's constructor calling
  // _init() without awaiting it) has no way to catch at all.

  Future<void> saveSecure(String key, String value) async {
    try {
      await _secure
          .write(key: key, value: value)
          .timeout(const Duration(seconds: 5), onTimeout: () {});
    } catch (_) {
      // Not saved; caller's next read correctly sees "no token".
    }
  }

  Future<String?> getSecure(String key) async {
    try {
      return await _secure
          .read(key: key)
          .timeout(const Duration(seconds: 5), onTimeout: () => null);
    } catch (_) {
      return null;
    }
  }

  Future<void> deleteSecure(String key) async {
    try {
      await _secure.delete(key: key).timeout(const Duration(seconds: 5), onTimeout: () {});
    } catch (_) {
      // Nothing usable was there anyway from the caller's perspective.
    }
  }

  Future<void> deleteAllSecure() async {
    try {
      await _secure.deleteAll().timeout(const Duration(seconds: 5), onTimeout: () {});
    } catch (_) {}
  }

  Future<Map<String, String>> getAllSecure() async {
    try {
      return await _secure
          .readAll()
          .timeout(const Duration(seconds: 5), onTimeout: () => const {});
    } catch (_) {
      return const {};
    }
  }

  // ── Convenience ───────────────────────────────────────────────────────────

  Future<void> clearSession() async {
    await Future.wait([
      deleteSecure('access_token'),
      deleteSecure('refresh_token'),
      remove('user_id'),
      remove('user_role'),
    ]);
  }
}
