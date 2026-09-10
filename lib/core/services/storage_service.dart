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

  // Same flaky-Keystore hang as getSecure below — bound it so a stuck
  // write degrades to "token wasn't saved, user re-logs in next launch"
  // instead of freezing whatever screen triggered it (e.g. OTP verify).
  Future<void> saveSecure(String key, String value) => _secure
      .write(key: key, value: value)
      .timeout(const Duration(seconds: 5), onTimeout: () {});

  // Some devices have a flaky/slow Android Keystore that can hang this
  // read indefinitely (seen on Unisoc-based budget chipsets) — nothing
  // throws, so an unguarded read strands every caller forever (the splash
  // screen, the auth-header interceptor, token refresh). Falling back to
  // null on timeout lets callers degrade to their normal "no token" path
  // instead of hanging.
  Future<String?> getSecure(String key) => _secure
      .read(key: key)
      .timeout(const Duration(seconds: 5), onTimeout: () => null);

  // deleteSecure/deleteAllSecure hit the same Keystore path as
  // saveSecure/getSecure above — guarded for the same reason. This one
  // matters most on a fresh install: clearSession() below calls it before
  // any read/write, so an unguarded hang here strands the app one step
  // earlier than the read/write guards can help with.
  Future<void> deleteSecure(String key) =>
      _secure.delete(key: key).timeout(const Duration(seconds: 5), onTimeout: () {});

  Future<void> deleteAllSecure() =>
      _secure.deleteAll().timeout(const Duration(seconds: 5), onTimeout: () {});

  Future<Map<String, String>> getAllSecure() => _secure
      .readAll()
      .timeout(const Duration(seconds: 5), onTimeout: () => const {});

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
