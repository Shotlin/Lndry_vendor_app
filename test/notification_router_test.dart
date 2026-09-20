import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lndry_vendor_app/core/notifications/notification_router.dart';
import 'package:lndry_vendor_app/core/notifications/notification_target.dart';
import 'package:lndry_vendor_app/core/services/storage_service.dart';
import 'package:lndry_vendor_app/models/models.dart';
import 'package:lndry_vendor_app/providers/auth_provider.dart';
import 'package:lndry_vendor_app/repositories/repositories.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Only the call under test is real; anything else the app might touch is ignored.
class _Repo implements VendorRepository {
  final List<Map<String, String?>> opened = [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<void> reportNotificationOpened({
    String? deliveryId,
    String? notificationId,
    String? campaignId,
  }) async {
    opened.add({'delivery': deliveryId, 'notification': notificationId, 'campaign': campaignId});
  }
}

class _Storage extends StorageService {
  _Storage({required super.prefs});
  final Map<String, String> _secure = {};
  @override
  Future<void> saveSecure(String key, String value) async => _secure[key] = value;
  @override
  Future<String?> getSecure(String key) async => _secure[key];
  @override
  Future<void> deleteSecure(String key) async => _secure.remove(key);
  @override
  Future<void> deleteAllSecure() async => _secure.clear();
  @override
  Future<Map<String, String>> getAllSecure() async => Map.of(_secure);
}

class _Auth extends AuthNotifier {
  _Auth(super.repo, super.storage);
  void set(AuthState s) => state = s;
}

VendorModel _vendor() => const VendorModel(
      id: 'v1',
      name: 'Shop',
      description: '',
      ownerName: 'Owner',
      phone: '9999999999',
      address: AddressModel(
        id: 'a', userId: 'u', line1: 'x', city: 'c', state: 's', pincode: '400001',
        type: AddressType.home,
      ),
    );

AuthState _owner() => AuthAuthenticated(_vendor(), shopRole: 'VENDOR_OWNER');
AuthState _captain() => AuthAuthenticated(_vendor(), shopRole: 'VENDOR_RIDER');

Map<String, dynamic> _tap(String route, {String type = 'order_details', String delivery = 'd1', String order = 'abc'}) => {
      'type': type,
      'deepLink': route,
      'orderId': order,
      'deliveryId': delivery,
      'notificationId': 'n1',
    };

void main() {
  group('NotificationTarget (role aware)', () {
    test('a vendor opens the order, a captain opens the job', () {
      final t = NotificationTarget.fromData({'type': 'order_details', 'orderId': 'abc'})!;
      expect(t.routeFor('VENDOR_OWNER'), '/orders/details/abc');
      expect(t.routeFor('VENDOR_STAFF'), '/orders/details/abc');
      expect(t.routeFor('VENDOR_RIDER'), '/rider/jobs/abc');
    });

    test('every order-screen link type opens the right screen for the role', () {
      for (final type in ['order_details', 'order_tracking', 'order_approval', 'order_payment', 'order_review']) {
        final t = NotificationTarget.fromData({'type': type, 'orderId': 'ord-7'})!;
        expect(t.routeFor('VENDOR_OWNER'), '/orders/details/ord-7', reason: type);
        expect(t.routeFor('VENDOR_RIDER'), '/rider/jobs/ord-7', reason: type);
      }
    });

    test('a route written for the other role is mapped, never rejected', () {
      final vendorRoute = NotificationTarget.fromData(_tap('/orders/details/abc'))!;
      expect(vendorRoute.routeFor('VENDOR_RIDER'), '/rider/jobs/abc');
      final captainRoute = NotificationTarget.fromData(_tap('/rider/jobs/abc'))!;
      expect(captainRoute.routeFor('VENDOR_OWNER'), '/orders/details/abc');
    });

    test('screens that do not exist for the role fall back to the notification list', () {
      final wallet = NotificationTarget.fromData({'type': 'wallet', 'deepLink': '/profile/wallet'})!;
      expect(wallet.routeFor('VENDOR_OWNER'), '/profile/notifications');
      expect(wallet.routeFor('VENDOR_RIDER'), '/profile/notifications');
      // A captain never reaches the vendor-only management screens.
      final mgmt = NotificationTarget.fromData({'type': 'route', 'deepLink': '/employees'})!;
      expect(mgmt.routeFor('VENDOR_OWNER'), '/employees');
      expect(mgmt.routeFor('VENDOR_RIDER'), '/profile/notifications');
    });

    test('crafted routes are never opened', () {
      for (final bad in ['https://evil.example', '/admin', '//x', '/orders/details/../x']) {
        final t = NotificationTarget.fromData({'type': 'route', 'deepLink': bad})!;
        expect(t.routeFor('VENDOR_OWNER'), '/profile/notifications', reason: bad);
      }
    });

    test('unrelated pushes are ignored; "open the app" pushes have no route', () {
      expect(NotificationTarget.fromData({'foo': 'bar'}), isNull);
      expect(NotificationTarget.fromData({'type': 'none', 'deliveryId': 'd'})!.routeFor('VENDOR_OWNER'), isNull);
    });
  });

  group('NotificationRouter', () {
    late _Repo repo;
    late _Auth auth;
    late GoRouter router;
    late NotificationRouter nr;

    Future<void> setUpRouter(WidgetTester tester, {String initial = '/dashboard'}) async {
      SharedPreferences.setMockInitialValues({});
      final storage = _Storage(prefs: await SharedPreferences.getInstance());
      repo = _Repo();
      auth = _Auth(repo, storage);
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
      router = GoRouter(initialLocation: initial, routes: [
        GoRoute(path: '/', builder: (_, __) => const Scaffold(body: Text('SPLASH'))),
        GoRoute(path: '/dashboard', builder: (_, __) => const Scaffold(body: Text('DASHBOARD'))),
        GoRoute(path: '/orders/details/:id', builder: (_, s) => Scaffold(body: Text('ORDER ${s.pathParameters['id']}'))),
        GoRoute(path: '/rider/jobs', builder: (_, __) => const Scaffold(body: Text('JOBS'))),
        GoRoute(path: '/rider/jobs/:id', builder: (_, s) => Scaffold(body: Text('JOB ${s.pathParameters['id']}'))),
        GoRoute(path: '/profile/notifications', builder: (_, __) => const Scaffold(body: Text('INBOX'))),
        GoRoute(path: '/login', builder: (_, s) => Scaffold(body: Text('LOGIN ${s.uri.queryParameters['returnTo']}'))),
      ]);
      final container = ProviderContainer(overrides: [
        vendorRepositoryProvider.overrideWithValue(repo),
        storageServiceProvider.overrideWithValue(storage),
        authProvider.overrideWith((ref) => auth),
      ]);
      addTearDown(container.dispose);
      nr = container.read(notificationRouterProvider)..attachForTest(router);
      await tester.pumpWidget(UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ));
      await tester.pumpAndSettle();
    }

    testWidgets('vendor: tap opens the order and reports the open', (tester) async {
      await setUpRouter(tester);
      auth.set(_owner());
      nr.tapForTest(_tap('/orders/details/abc'));
      await tester.pumpAndSettle();
      expect(find.text('ORDER abc'), findsOneWidget);
      expect(repo.opened, [{'delivery': 'd1', 'notification': 'n1', 'campaign': null}]);
      router.pop();
      await tester.pumpAndSettle();
      expect(find.text('DASHBOARD'), findsOneWidget);
    });

    testWidgets('captain: the same order notification opens the job screen', (tester) async {
      await setUpRouter(tester, initial: '/rider/jobs');
      auth.set(_captain());
      nr.tapForTest(_tap('/orders/details/abc'));
      await tester.pumpAndSettle();
      expect(find.text('JOB abc'), findsOneWidget);
    });

    testWidgets('signed out: sign in first, carrying the destination', (tester) async {
      await setUpRouter(tester);
      auth.set(const AuthUnauthenticated());
      nr.tapForTest(_tap('/rider/jobs/abc'));
      await tester.pumpAndSettle();
      expect(find.text('LOGIN /rider/jobs/abc'), findsOneWidget);
      expect(repo.opened, isEmpty);
      auth.set(_captain());
      nr.tryConsume();
      expect(repo.opened.length, 1);
    });

    testWidgets('killed-app launch: waits out the splash, then opens the destination', (tester) async {
      await setUpRouter(tester, initial: '/');
      auth.set(_owner());
      nr.tapForTest(_tap('/orders/details/abc'));
      await tester.pumpAndSettle();
      expect(find.text('SPLASH'), findsOneWidget);
      router.go('/dashboard');
      await tester.pumpAndSettle();
      expect(find.text('ORDER abc'), findsOneWidget);
    });

    testWidgets('waits for the session to be restored before deciding', (tester) async {
      await setUpRouter(tester);
      auth.set(const AuthLoading());
      nr.tapForTest(_tap('/orders/details/abc'));
      await tester.pumpAndSettle();
      expect(find.text('DASHBOARD'), findsOneWidget);
      auth.set(_owner());
      nr.tryConsume();
      await tester.pumpAndSettle();
      expect(find.text('ORDER abc'), findsOneWidget);
    });

    testWidgets('the same message is handled once', (tester) async {
      await setUpRouter(tester);
      auth.set(_owner());
      nr.tapForTest(_tap('/orders/details/abc'), messageId: 'm1');
      await tester.pumpAndSettle();
      router.pop();
      await tester.pumpAndSettle();
      nr.tapForTest(_tap('/orders/details/abc'), messageId: 'm1');
      await tester.pumpAndSettle();
      expect(find.text('DASHBOARD'), findsOneWidget);
      expect(repo.opened.length, 1);
    });

    testWidgets('an in-app inbox tap uses the same path', (tester) async {
      await setUpRouter(tester);
      auth.set(_owner());
      nr.openRoute('/orders/details/zz');
      await tester.pumpAndSettle();
      expect(find.text('ORDER zz'), findsOneWidget);
    });
  });
}
