import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';
import '../core/services/storage_service.dart';
import '../core/constants/app_constants.dart';
import '../core/network/network.dart';
import '../repositories/repositories.dart';

/// Extracts a user-facing message from a caught error. The Dio error
/// interceptor (`dio_client_provider.dart`) wraps the parsed [ApiException]
/// inside `DioException.error` rather than throwing it directly, so a plain
/// `on ApiException catch` never matches — this must be unwrapped explicitly.
String _extractErrorMessage(Object e, String fallback) {
  if (e is DioException && e.error is ApiException) {
    return (e.error as ApiException).message;
  }
  if (e is ApiException) return e.message;
  return fallback;
}

// ── Auth State ────────────────────────────────────────────────────────────────

sealed class AuthState {
  const AuthState();
}

/// App just launched; determining session state.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Any async auth operation is in progress.
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// OTP sent; waiting for user to enter code.
class AuthOtpSent extends AuthState {
  const AuthOtpSent({
    required this.phone,
    required this.challengeId,
    this.devOtp,
  });

  final String phone;

  /// Backend challenge ID for this OTP session.
  final String challengeId;

  /// Dev-only OTP value (populated in mock/dev mode; null in production).
  final String? devOtp;
}

/// OTP verified; vendor authenticated.
///
/// [shopRole] is the logged-in user's role on this vendor's staff roster
/// ('VENDOR_OWNER' / 'VENDOR_STAFF' / 'VENDOR_RIDER') — it determines
/// whether the app shows the full vendor dashboard or the restricted
/// rider job-fulfillment view. Null for sessions predating this field
/// (falls back to full-dashboard behavior).
class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.vendor, {this.shopRole, this.permissions = const []});
  final VendorModel vendor;
  final String? shopRole;
  final List<String> permissions;
}

/// Not signed in; needs login.
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// OTP verified but no vendor record exists yet; must complete the
/// onboarding application wizard.
class AuthNeedsVendorApplication extends AuthState {
  const AuthNeedsVendorApplication(this.phone);
  final String phone;
}

/// An auth operation failed; [message] is safe to display.
class AuthError extends AuthState {
  const AuthError(this.message);
  final String message;
}

// ── Auth Notifier ─────────────────────────────────────────────────────────────

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repo, this._storage) : super(const AuthInitial()) {
    _init();
  }

  final VendorRepository _repo;
  final StorageService _storage;

  // Helper to override the vendor's business phone number with the OTP login number
  VendorModel _mergeAuthPhone(VendorModel vendor) {
    final authPhone = _storage.getString('auth_user_phone');
    if (authPhone != null && authPhone.isNotEmpty) {
      return vendor.copyWith(phone: authPhone);
    }
    return vendor;
  }

  // ── Shop role persistence ─────────────────────────────────────────────────
  // Only the verify-otp response carries a fresh shopRole (it's part of the
  // JWT issued at login) — every other call site here just refreshes the
  // vendor's business profile for an already-established session, so they
  // read back whatever was last saved rather than losing it.
  Future<void> _saveShopRole(String? shopRole, List<String> permissions) async {
    await _storage.saveString('auth_shop_role', shopRole ?? '');
    await _storage.saveStringList('auth_shop_permissions', permissions);
  }

  String? _currentShopRole() {
    final role = _storage.getString('auth_shop_role');
    return (role == null || role.isEmpty) ? null : role;
  }

  List<String> _currentPermissions() {
    return _storage.getStringList('auth_shop_permissions') ?? const [];
  }

  // ── Initialisation (session restore via stored tokens) ──────────────────────

  Future<void> _init() async {
    state = const AuthLoading();

    // One-time session reset for fresh installs (clears stale dev data).
    final resetDone = _storage.getBool('vendor_fresh_install_reset_done_v1') ?? false;
    if (!resetDone) {
      await _storage.clearSession();
      await _clearVendorPrefs();
      await _storage.saveBool('vendor_fresh_install_reset_done_v1', value: true);
    }

    // Try reading stored tokens from secure storage.
    final accessToken = await _storage.getSecure(AppConstants.keyAccessToken);
    final refreshToken = await _storage.getSecure(AppConstants.keyRefreshToken);

    if (accessToken == null && refreshToken == null) {
      state = const AuthUnauthenticated();
      return;
    }

    // Attempt to restore session by refreshing the token pair.
    try {
      final pair = await _repo.refreshTokens();

      // Store refreshed tokens
      await _storage.saveSecure(AppConstants.keyAccessToken, pair.accessToken);
      await _storage.saveSecure(AppConstants.keyRefreshToken, pair.refreshToken);

      // Fetch vendor profile. A 404 here means the tokens are valid but no
      // vendor record exists yet (never finished onboarding) — that's not a
      // session failure, so it must not clear the tokens.
      try {
        final vendor = await _repo.getProfile();
        await _saveVendorPrefs(vendor);
        await _registerDeviceIfPossible();
        state = AuthAuthenticated(
          _mergeAuthPhone(vendor),
          shopRole: _currentShopRole(),
          permissions: _currentPermissions(),
        );
      } on DioException catch (e) {
        // The error interceptor wraps the parsed ApiException inside
        // DioException.error rather than throwing it directly, so the
        // status code must be read off the DioException itself.
        if (e.response?.statusCode == 404) {
          final phone = _storage.getString('auth_user_phone') ??
              _storage.getString('vendor_phone') ??
              '';
          state = AuthNeedsVendorApplication(phone);
          return;
        }
        rethrow;
      }
    } catch (_) {
      // Token refresh failed — clear everything and go to login.
      await _storage.clearSession();
      await _clearVendorPrefs();
      state = const AuthUnauthenticated();
    }
  }

  // ── OTP flow ───────────────────────────────────────────────────────────────

  /// Requests an OTP for [phone] via the active repository.
  Future<void> sendOtp(String phone) async {
    state = const AuthLoading();
    try {
      final result = await _repo.sendOtp(phone);
      state = AuthOtpSent(
        phone: phone,
        challengeId: result.challengeId,
        devOtp: result.devOtp,
      );
    } catch (e) {
      state = AuthError(_extractErrorMessage(e, 'Failed to send OTP. Please try again.'));
    }
  }

  /// Verifies OTP [code] against the active challenge.
  Future<void> verifyOtp(String code) async {
    final prev = state;
    if (prev is! AuthOtpSent) return;

    state = const AuthLoading();
    try {
      final result = await _repo.verifyOtp(
        phone: prev.phone,
        otp: code,
        challengeId: prev.challengeId,
      );

      // Persist tokens
      await _storage.saveSecure(AppConstants.keyAccessToken, result.accessToken);
      await _storage.saveSecure(AppConstants.keyRefreshToken, result.refreshToken);

      // Priority 1: result.userPhone from response.
      // Priority 2: prev.phone (login input phone).
      final authPhone = result.userPhone ?? prev.phone;
      await _storage.saveString('auth_user_phone', authPhone);
      await _saveShopRole(result.shopRole, result.permissions);

      // A newly registered phone in the vendor app always begins by
      // completing its vendor application. Do this from the authoritative
      // OTP response instead of depending on a subsequent profile request:
      // it prevents a new account from briefly entering the dashboard and
      // showing failed operational calls when a profile endpoint responds
      // unexpectedly. A pre-invited rider is the one exception — riders use
      // the job flow, not owner onboarding.
      if (result.isNewUser && result.shopRole != 'VENDOR_RIDER') {
        state = AuthNeedsVendorApplication(authPhone);
        return;
      }

      // Load the full vendor profile immediately using the verified session.
      // A 404 means this phone has no vendor record yet — route to the
      // onboarding wizard instead of surfacing it as an error; tokens are
      // already persisted above so the wizard's authenticated calls work.
      try {
        final vendor = await _repo.getProfile();
        await _saveVendorPrefs(vendor);
        await _registerDeviceIfPossible();
        state = AuthAuthenticated(
          _mergeAuthPhone(vendor),
          shopRole: result.shopRole,
          permissions: result.permissions,
        );
      } on DioException catch (e) {
        if (e.response?.statusCode == 404) {
          state = AuthNeedsVendorApplication(authPhone);
          return;
        }
        rethrow;
      }
    } catch (e) {
      state = AuthError(_extractErrorMessage(e, 'Verification failed. Please try again.'));
    }
  }

  /// Restores [AuthOtpSent] for the previous phone after an error.
  void restoreOtpState(String phone, String challengeId, {String? devOtp}) {
    state = AuthOtpSent(phone: phone, challengeId: challengeId, devOtp: devOtp);
  }

  /// Re-checks the vendor profile and transitions to [AuthAuthenticated] if
  /// one now exists. Needed right after the backend's ALLOW_AUTO_APPROVE_VENDOR
  /// dev flag promotes an application to a live vendor instantly (normally
  /// this only happens on the next login, once an admin has approved it).
  /// Returns whether the profile is now approved.
  Future<bool> refreshProfileIfApproved() async {
    try {
      final vendor = await _repo.getProfile();
      await _saveVendorPrefs(vendor);
      await _registerDeviceIfPossible();
      state = AuthAuthenticated(
        _mergeAuthPhone(vendor),
        shopRole: _currentShopRole(),
        permissions: _currentPermissions(),
      );
      return true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return false;
      rethrow;
    }
  }

  /// Clears a transient error back to unauthenticated.
  void clearError() {
    if (state is AuthError) {
      state = const AuthUnauthenticated();
    }
  }

  // ── Profile update (for authenticated vendors) ───────────────────────────────

  Future<void> updateAuthenticatedVendor({
    required String name,
    required String email,
    String? description,
    String? addressLine1,
    String? city,
    String? stateStr,
    String? pincode,
    String? logoUrl,
    String? bannerUrl,
  }) async {
    final prev = state;
    if (prev is! AuthAuthenticated) return;

    try {
      await _repo.updateProfile(
        name: name,
        email: email,
        description: description,
        addressLine1: addressLine1,
        city: city,
        state: stateStr,
        pincode: pincode,
        logoUrl: logoUrl,
        bannerUrl: bannerUrl,
      );
      // Immediately fetch the latest profile from the API
      final fresh = await _repo.getProfile();
      await _saveVendorPrefs(fresh);
      state = AuthAuthenticated(
        _mergeAuthPhone(fresh),
        shopRole: _currentShopRole(),
        permissions: _currentPermissions(),
      );
    } catch (e) {
      // Fallback: update locally if API fails
      final updated = prev.vendor.copyWith(
        name: name,
        email: email,
        description: description ?? prev.vendor.description,
        logoUrl: logoUrl ?? prev.vendor.logoUrl,
        coverImageUrl: bannerUrl ?? prev.vendor.coverImageUrl,
        address: prev.vendor.address.copyWith(
          line1: addressLine1 ?? prev.vendor.address.line1,
          city: city ?? prev.vendor.address.city,
          state: stateStr ?? prev.vendor.address.state,
          pincode: pincode ?? prev.vendor.address.pincode,
        ),
      );
      await _storage.saveString('vendor_name', name);
      await _storage.saveString('vendor_email', email);
      state = AuthAuthenticated(
        _mergeAuthPhone(updated),
        shopRole: prev.shopRole,
        permissions: prev.permissions,
      );
    }
  }

  Future<void> toggleStoreOpen(bool isOpen) async {
    final prev = state;
    if (prev is! AuthAuthenticated) return;
    final updated = await _repo.toggleStoreOpen(isOpen);
    state = AuthAuthenticated(
      _mergeAuthPhone(updated),
      shopRole: prev.shopRole,
      permissions: prev.permissions,
    );
  }

  Future<void> refreshProfile() async {
    final prev = state;
    if (prev is! AuthAuthenticated) return;
    final updated = await _repo.getProfile();
    await _saveVendorPrefs(updated);
    state = AuthAuthenticated(
      _mergeAuthPhone(updated),
      shopRole: prev.shopRole,
      permissions: prev.permissions,
    );
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    String? description,
    String? addressLine1,
    String? city,
    String? stateStr,
    String? pincode,
    String? logoUrl,
    String? bannerUrl,
  }) async {
    await updateAuthenticatedVendor(
      name: name,
      email: email,
      description: description,
      addressLine1: addressLine1,
      city: city,
      stateStr: stateStr,
      pincode: pincode,
      logoUrl: logoUrl,
      bannerUrl: bannerUrl,
    );
  }

  // ── Logout ────────────────────────────────────────────────────────────────

  Future<void> logout() async {
    final deviceId = _storage.getString('device_id');
    if (deviceId != null && deviceId.isNotEmpty) {
      try {
        await _repo.unregisterDevice(deviceId);
      } catch (_) {}
    }
    try {
      await _repo.logout();
    } catch (_) {
      // Best-effort server-side invalidation
    }
    await _storage.clearSession();
    await _clearVendorPrefs();
    state = const AuthUnauthenticated();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Future<void> _saveVendorPrefs(VendorModel vendor) async {
    await Future.wait([
      _storage.saveString(AppConstants.keyUserId, vendor.id),
      _storage.saveString('vendor_name', vendor.name),
      _storage.saveString('vendor_email', vendor.email ?? ''),
      _storage.saveString('vendor_phone', vendor.phone),
    ]);
  }

  Future<void> _clearVendorPrefs() async {
    await Future.wait([
      _storage.remove('vendor_name'),
      _storage.remove('vendor_email'),
      _storage.remove('vendor_phone'),
      _storage.remove('auth_user_phone'),
      _storage.remove('auth_shop_role'),
      _storage.remove('auth_shop_permissions'),
    ]);
  }

  Future<void> _registerDeviceIfPossible() async {
    try {
      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission();
      final token = await messaging.getToken();
      if (token == null || token.isEmpty) return;

      var deviceId = _storage.getString('device_id');
      if (deviceId == null || deviceId.isEmpty) {
        deviceId = const Uuid().v4();
        await _storage.saveString('device_id', deviceId);
      }

      final platform = Platform.isAndroid
          ? 'android'
          : Platform.isIOS
              ? 'ios'
              : 'android';
      await _repo.registerDevice(
        deviceId: deviceId,
        platform: platform,
        fcmToken: token,
      );
    } catch (_) {
      // Firebase config is optional for local/dev builds; auth must continue.
    }
  }
}

// ── Providers ─────────────────────────────────────────────────────────────────

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = ref.watch(vendorRepositoryProvider);
  final storage = ref.watch(storageServiceProvider);
  return AuthNotifier(repo, storage);
});

/// Convenience provider: returns the current authenticated vendor, or null.
final currentVendorProvider = Provider<VendorModel?>((ref) {
  final s = ref.watch(authProvider);
  return switch (s) {
    AuthAuthenticated(:final vendor) => vendor,
    _ => null,
  };
});

/// Convenience provider: the logged-in user's shop role, or null.
final currentShopRoleProvider = Provider<String?>((ref) {
  final s = ref.watch(authProvider);
  return switch (s) {
    AuthAuthenticated(:final shopRole) => shopRole,
    _ => null,
  };
});

/// Whether the logged-in session is a vendor-owned rider (restricted view)
/// rather than a full vendor dashboard user.
final isRiderProvider = Provider<bool>((ref) {
  return ref.watch(currentShopRoleProvider) == 'VENDOR_RIDER';
});
