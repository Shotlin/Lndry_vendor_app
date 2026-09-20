import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_provider.dart';
import 'device_permissions.dart';
import 'storage_service.dart';

/// Talks to the phone. Swappable so the ask-once rules can be tested.
abstract class PermissionPlatform {
  Future<PermissionOutcome> notificationStatus();
  Future<PermissionOutcome> requestNotification();
  Future<PermissionOutcome> locationStatus();
  Future<PermissionOutcome> requestLocation();
}

class DevicePermissionPlatform implements PermissionPlatform {
  const DevicePermissionPlatform();
  @override
  Future<PermissionOutcome> notificationStatus() => DevicePermissions.notifications();
  @override
  Future<PermissionOutcome> requestNotification() => DevicePermissions.requestNotifications();
  @override
  Future<PermissionOutcome> locationStatus() => DevicePermissions.location();
  @override
  Future<PermissionOutcome> requestLocation() => DevicePermissions.requestLocation();
}

/// Raises the phone's own permission dialogs — notifications first, then
/// location, one after the other — and nothing else: no explanation screen.
///
/// Rules:
///  * A permission that is already decided (allowed, or blocked in Settings)
///    is never asked.
///  * Each permission is asked at most once, ever; the answer is remembered, so
///    a "Don't allow" does not turn into a prompt on every launch.
///  * Denying never blocks the app. Features that need a permission explain and
///    offer "Open Settings" at the moment they are used.
class PermissionPrompter {
  PermissionPrompter({
    required StorageService storage,
    PermissionPlatform platform = const DevicePermissionPlatform(),
    this.onNotificationsGranted,
    this.onLocationGranted,
  })  : _storage = storage,
        _platform = platform;

  static const notificationsAskedKey = 'perm_notifications_asked';
  static const locationAskedKey = 'perm_location_asked';

  final StorageService _storage;
  final PermissionPlatform _platform;

  /// Called only right after the user allows notifications (register the FCM token).
  final Future<void> Function()? onNotificationsGranted;

  /// Called only right after the user allows location (unused in the Partner
  /// app: the shop location is captured in the flow that needs it).
  final Future<void> Function()? onLocationGranted;

  Future<void>? _inFlight;

  /// Ask for whatever is still undecided. Safe to call repeatedly; concurrent
  /// calls share one run so two system dialogs never appear together.
  Future<void> runIfNeeded() => _inFlight ??= _run().whenComplete(() => _inFlight = null);

  Future<void> _run() async {
    await _ask(
      askedKey: notificationsAskedKey,
      status: _platform.notificationStatus,
      request: _platform.requestNotification,
      onGranted: onNotificationsGranted,
    );
    // The second dialog only starts once the first has been answered.
    await _ask(
      askedKey: locationAskedKey,
      status: _platform.locationStatus,
      request: _platform.requestLocation,
      onGranted: onLocationGranted,
    );
  }

  Future<void> _ask({
    required String askedKey,
    required Future<PermissionOutcome> Function() status,
    required Future<PermissionOutcome> Function() request,
    required Future<void> Function()? onGranted,
  }) async {
    try {
      final current = await status();
      if (current != PermissionOutcome.denied) {
        // Allowed, or blocked in Settings: nothing to ask, nothing to repeat.
        await _storage.saveBool(askedKey, value: true);
        return;
      }
      if (_storage.getBool(askedKey) ?? false) return; // asked before

      // Remember first: even if the app is killed with the dialog open, the
      // next launch will not ask again.
      await _storage.saveBool(askedKey, value: true);
      final result = await request();
      if (result == PermissionOutcome.granted) {
        try {
          await onGranted?.call();
        } catch (_) {/* a follow-up failing must never affect the flow */}
      }
    } catch (_) {
      // A permission problem must never stop the app from opening.
    }
  }
}

final permissionPrompterProvider = Provider<PermissionPrompter>((ref) {
  return PermissionPrompter(
    storage: ref.read(storageServiceProvider),
    // Notifications allowed → register/refresh the FCM token with the backend
    // (new orders and captain job offers depend on it).
    onNotificationsGranted: () => ref.read(authProvider.notifier).syncPushToken(),
  );
});
