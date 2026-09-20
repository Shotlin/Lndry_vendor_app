import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import '../../repositories/repositories.dart';
import '../router/vendor_router.dart';
import '../services/storage_service.dart';
import 'notification_target.dart';

final notificationRouterProvider =
    Provider<NotificationRouter>((ref) => NotificationRouter(ref));

/// The ONE place push notifications are handled in the Partner app (vendors and
/// captains):
/// foreground display, taps from the background, a launch from a killed app,
/// duplicate suppression, sign-in-then-continue, and tap reporting. Screens
/// never navigate from a notification themselves — they call [openRoute].
class NotificationRouter {
  NotificationRouter(this._ref);

  final Ref _ref;
  final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();

  static const _channelId = 'lndry_notifications';
  static const _lastTapKey = 'notif_last_tap_key';
  static const _pendingTtl = Duration(minutes: 10);
  static const _bootPaths = {'/', '/onboarding', '/permissions'};
  static const _tabRoots = {'/dashboard', '/orders', '/profile', '/services', '/analytics', '/rider/jobs'};

  GoRouter? _router;
  bool _started = false;
  NotificationTarget? _pending;
  DateTime? _pendingAt;
  final List<NotificationTarget> _unreported = [];
  final List<String> _recent = [];

  /// Wire everything up once the router exists (called from the bootstrap widget).
  Future<void> start(GoRouter router) async {
    if (_started) return;
    _started = true;
    _router = router;
    // Every navigation change is a chance to deliver a waiting notification
    // (e.g. once the splash screen has finished).
    router.routerDelegate.addListener(tryConsume);

    // Firebase message handling comes FIRST and does not wait for the local
    // (foreground) notification plugin: a tap that launched the app must be
    // picked up even if that plugin is slow or fails to initialise.
    final localReady = _initLocal();
    if (Firebase.apps.isNotEmpty) {
      final fm = FirebaseMessaging.instance;
      FirebaseMessaging.onMessage.listen(_onForeground);
      FirebaseMessaging.onMessageOpenedApp
          .listen((m) => _onTap(m.data, messageId: m.messageId));
      try {
        // iOS shows foreground notifications itself once told to.
        await fm.setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
      } catch (_) {}
      await _checkLaunchMessage(fm);
      // Some devices hand over the launch message a moment late; asking again
      // is harmless (a message is only ever handled once).
      Future<void>.delayed(const Duration(seconds: 2), () => _checkLaunchMessage(fm));
    }

    try {
      await localReady;
      final launch = await _local.getNotificationAppLaunchDetails();
      if (launch?.didNotificationLaunchApp ?? false) {
        _onLocalPayload(launch!.notificationResponse?.payload);
      }
    } catch (_) {}
  }

  /// The notification that launched the app from a killed state, if any.
  Future<void> _checkLaunchMessage(FirebaseMessaging fm) async {
    try {
      final initial = await fm
          .getInitialMessage()
          .timeout(const Duration(seconds: 3), onTimeout: () => null);
      if (initial != null) _onTap(initial.data, messageId: initial.messageId);
    } catch (_) {}
  }

  /// Test seam: attach a router without touching Firebase or the platform.
  @visibleForTesting
  void attachForTest(GoRouter router) {
    _started = true;
    _router = router;
    router.routerDelegate.addListener(tryConsume);
  }

  /// Test seam: simulate the user tapping a notification carrying [data].
  @visibleForTesting
  void tapForTest(Map<String, dynamic> data, {String? messageId}) =>
      _onTap(data, messageId: messageId);

  /// A destination chosen inside the app (e.g. tapping an inbox item) goes
  /// through the same guard and sign-in handling as a real notification tap.
  void openRoute(String? route) {
    final target = NotificationTarget.forRoute(route);
    if (target == null) return;
    _pending = target;
    _pendingAt = DateTime.now();
    tryConsume();
  }

  // ── Local (foreground) notifications ─────────────────────────────────────

  Future<void> _initLocal() async {
    try {
      await _local.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('ic_stat_lndry'),
          iOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          ),
        ),
        onDidReceiveNotificationResponse: (r) => _onLocalPayload(r.payload),
      );
      await _local
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(const AndroidNotificationChannel(
            _channelId,
            'LNDRY notifications',
            importance: Importance.high,
          ));
    } catch (e) {
      debugPrint('[LNDRY] local notifications unavailable: $e');
    }
  }

  Future<void> _onForeground(RemoteMessage m) async {
    final n = m.notification;
    if (n == null && NotificationTarget.fromData(m.data) == null) return;
    // iOS presents it natively (see start()); showing it again would duplicate.
    if (Platform.isIOS) return;

    final key = 'fg:${m.messageId ?? m.data['deliveryId'] ?? m.hashCode}';
    if (!_markSeen(key)) return;

    try {
      await _local.show(
        id: (m.messageId ?? key).hashCode & 0x7fffffff,
        title: n?.title ?? m.data['title']?.toString(),
        body: n?.body ?? m.data['body']?.toString(),
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            'LNDRY notifications',
            importance: Importance.high,
            priority: Priority.high,
            icon: 'ic_stat_lndry',
            styleInformation:
                n?.body == null ? null : BigTextStyleInformation(n!.body!),
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        payload: jsonEncode({
          ...m.data,
          if (m.messageId != null) 'messageId': m.messageId,
        }),
      );
    } catch (e) {
      debugPrint('[LNDRY] could not show foreground notification: $e');
    }
  }

  void _onLocalPayload(String? payload) {
    if (payload == null || payload.isEmpty) return;
    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map) {
        _onTap(Map<String, dynamic>.from(decoded),
            messageId: decoded['messageId']?.toString());
      }
    } catch (_) {}
  }

  // ── Taps ──────────────────────────────────────────────────────────────────

  void _onTap(Map<String, dynamic> data, {String? messageId}) {
    final target = NotificationTarget.fromData(data, messageId: messageId);
    if (target == null) return; // not one of ours
    if (!_claimTap(target.dedupeKey)) return; // already handled
    _pending = target;
    _pendingAt = DateTime.now();
    if (target.hasReportableId) _unreported.add(target);
    tryConsume();
  }

  /// Deliver the waiting notification if the app is ready for it. Safe to call
  /// at any time; it does nothing until the right moment.
  void tryConsume() {
    final router = _router;
    if (router == null) return;
    final auth = _ref.read(authProvider);

    if (auth is AuthAuthenticated) _flushReports();

    final target = _pending;
    if (target == null) return;
    if (_pendingAt != null &&
        DateTime.now().difference(_pendingAt!) > _pendingTtl) {
      _pending = null;
      return;
    }
    // Wait out the splash / first-run screens so the route is not swallowed.
    if (_bootPaths.contains(router.routeInformationProvider.value.uri.path)) {
      return;
    }
    if (auth is AuthInitial || auth is AuthLoading) return;

    if (auth is AuthAuthenticated) {
      _pending = null;
      final route = target.routeFor(auth.shopRole);
      if (route != null) {
        // Tab roots replace the current tab; detail screens stack on top so
        // Back returns to where the user was.
        _tabRoots.contains(route) ? router.go(route) : router.push(route);
      }
      return;
    }
    if (auth is AuthUnauthenticated || auth is AuthError) {
      _pending = null;
      // Sign in first, then continue to the original destination. Which
      // screen that is depends on the role that signs in, so carry the
      // backend's resolved route (the redirect after login re-checks it).
      final route = target.candidateRoute ??
          NotificationRoutes.forLink(target.type, target.params);
      if (route != null && route != '/dashboard') {
        router.go(loginLocation(returnTo: route));
      }
      return;
    }
    // Mid sign-in (OTP / vendor application …): keep waiting.
  }

  // ── Bookkeeping ───────────────────────────────────────────────────────────

  bool _markSeen(String key) {
    if (_recent.contains(key)) return false;
    _recent.add(key);
    if (_recent.length > 60) _recent.removeAt(0);
    return true;
  }

  /// A tap is handled once: in this session (memory) and across restarts
  /// (the launch message can be replayed by the OS).
  bool _claimTap(String key) {
    if (!_markSeen('tap:$key')) return false;
    try {
      final storage = _ref.read(storageServiceProvider);
      if (storage.getString(_lastTapKey) == key) return false;
      unawaited(storage.saveString(_lastTapKey, key));
    } catch (_) {}
    return true;
  }

  void _flushReports() {
    if (_unreported.isEmpty) return;
    final batch = List<NotificationTarget>.of(_unreported);
    _unreported.clear();
    final repo = _ref.read(vendorRepositoryProvider);
    for (final t in batch) {
      unawaited(repo
          .reportNotificationOpened(
            deliveryId: t.deliveryId,
            notificationId: t.notificationId,
            campaignId: t.campaignId,
          )
          .catchError((_) {}));
    }
  }
}
