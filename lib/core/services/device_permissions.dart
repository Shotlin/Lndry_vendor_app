import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';

/// Where a runtime permission stands right now.
enum PermissionOutcome {
  granted,
  denied,

  /// The system will no longer show its dialog; only the app's Settings page
  /// can change it.
  blocked,
}

/// Raw access to the two OS permissions the app uses: location (geolocator)
/// and notifications (Firebase Messaging). Nothing here decides *when* to ask —
/// see `PermissionPrompter` for that.
abstract final class DevicePermissions {
  static Future<PermissionOutcome> location() async {
    try {
      return _fromLocation(await Geolocator.checkPermission());
    } catch (_) {
      return PermissionOutcome.denied;
    }
  }

  static Future<PermissionOutcome> requestLocation() async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      return _fromLocation(permission);
    } catch (_) {
      return PermissionOutcome.denied;
    }
  }

  static Future<PermissionOutcome> notifications() async {
    try {
      // Without a Firebase project there is nothing to ask for.
      if (Firebase.apps.isEmpty) return PermissionOutcome.granted;
      final settings = await FirebaseMessaging.instance.getNotificationSettings();
      return _fromNotification(settings.authorizationStatus);
    } catch (_) {
      return PermissionOutcome.denied;
    }
  }

  static Future<PermissionOutcome> requestNotifications() async {
    try {
      if (Firebase.apps.isEmpty) return PermissionOutcome.granted;
      final settings = await FirebaseMessaging.instance.requestPermission();
      return _fromNotification(settings.authorizationStatus);
    } catch (_) {
      return PermissionOutcome.denied;
    }
  }

  static PermissionOutcome _fromLocation(LocationPermission p) {
    switch (p) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        return PermissionOutcome.granted;
      case LocationPermission.deniedForever:
        return PermissionOutcome.blocked;
      case LocationPermission.denied:
      case LocationPermission.unableToDetermine:
        return PermissionOutcome.denied;
    }
  }

  static PermissionOutcome _fromNotification(AuthorizationStatus s) {
    switch (s) {
      case AuthorizationStatus.authorized:
      case AuthorizationStatus.provisional:
        return PermissionOutcome.granted;
      case AuthorizationStatus.denied:
      case AuthorizationStatus.notDetermined:
        return PermissionOutcome.denied;
    }
  }
}
