import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lndry_vendor_app/api/repositories/api_vendor_repository.dart';
import 'package:lndry_vendor_app/core/extensions/order_extensions.dart';
import 'package:lndry_vendor_app/core/router/app_routes.dart';
import 'package:lndry_vendor_app/core/router/vendor_router.dart';
import 'package:lndry_vendor_app/features/employees/presentation/pages/employees_page.dart';
import 'package:lndry_vendor_app/l10n/generated/app_localizations.dart';
import 'package:lndry_vendor_app/models/models.dart';
import 'package:lndry_vendor_app/providers/auth_provider.dart';
import 'package:lndry_vendor_app/repositories/repositories.dart';

const _catalogJson = {
  'modules': [
    {
      'key': 'orders',
      'label': 'Orders',
      'items': [
        {'key': 'orders.view', 'label': 'View orders', 'permissions': ['shop_orders.view']},
        {
          'key': 'orders.accept_reject',
          'label': 'Accept / reject new orders',
          'permissions': ['shop_orders.accept_reject'],
        },
        {
          'key': 'orders.reevaluate',
          'label': 'Re-evaluation',
          'permissions': ['shop_orders.reevaluate'],
        },
      ],
    },
    {
      'key': 'catalogue',
      'label': 'Catalogue & pricing',
      'items': [
        {'key': 'catalogue.view', 'label': 'View services & pricing', 'permissions': ['vendor_services.view']},
      ],
    },
  ],
};

EmployeeModel _emp(String id, String name, String role, {List<String> perms = const []}) => EmployeeModel(
      id: id,
      vendorId: 'v1',
      userId: 'u$id',
      name: name,
      email: '$name@example.com',
      phone: '9000000000',
      role: role,
      permissions: perms,
    );

/// A repository that behaves like the backend's role filter: `getStaff`
/// only ever returns staff, `getRiders` only captains.
class _FakeRepo extends Fake implements VendorRepository {
  final all = <EmployeeModel>[
    _emp('1', 'Asha Staff', 'VENDOR_STAFF', perms: ['shop_orders.view']),
    _emp('2', 'Ravi Captain', 'VENDOR_RIDER'),
  ];
  Map<String, dynamic>? created;

  @override
  Future<List<EmployeeModel>> getStaff() async => all.where((e) => e.role == 'VENDOR_STAFF').toList();

  @override
  Future<List<EmployeeModel>> getRiders() async => all.where((e) => e.role == 'VENDOR_RIDER').toList();

  @override
  Future<PermissionCatalog> getPermissionCatalog() async => PermissionCatalog.fromJson(_catalogJson);

  @override
  Future<MyAccess> getMyAccess() async => MyAccess.owner;

  @override
  Future<EmployeeModel> createEmployee({
    required String name,
    required String email,
    required String role,
    String? phone,
    List<String>? permissions,
  }) async {
    created = {'name': name, 'email': email, 'role': role, 'phone': phone, 'permissions': permissions};
    final e = _emp('9', name, role, perms: permissions ?? const []);
    all.add(e);
    return e;
  }
}

Widget _app(Widget home, {required _FakeRepo repo}) {
  // The page uses go_router (back button), so it lives inside a real router.
  final router = GoRouter(
    initialLocation: '/employees',
    routes: [
      GoRoute(path: '/employees', builder: (_, __) => home),
      GoRoute(path: '/profile', builder: (_, __) => const SizedBox()),
    ],
  );
  return ProviderScope(
    overrides: [vendorRepositoryProvider.overrideWithValue(repo)],
    child: ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, __) => MaterialApp.router(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    ),
  );
}

VendorModel _vendor() => const VendorModel(
      id: 'v1',
      name: 'Shop',
      description: '',
      ownerName: 'Owner',
      phone: '9999999999',
      address: AddressModel(
        id: 'a',
        userId: 'u',
        line1: 'x',
        city: 'c',
        state: 's',
        pincode: '400001',
        type: AddressType.home,
      ),
    );

/// Runs the app's real redirect rules against placeholder screens and returns
/// where [start] ends up.
Future<String> _landing(
  WidgetTester tester, {
  required String start,
  required AuthState auth,
  required MyAccess access,
}) async {
  final paths = [
    AppRoutes.dashboard,
    AppRoutes.orders,
    AppRoutes.services,
    AppRoutes.slots,
    AppRoutes.analytics,
    AppRoutes.employees,
    AppRoutes.riderManagement,
    AppRoutes.riderJobs,
    AppRoutes.login,
  ];
  final router = GoRouter(
    initialLocation: start,
    redirect: (context, state) => vendorRedirectForTest(context, state, auth, access),
    routes: [
      for (final p in paths) GoRoute(path: p, builder: (_, __) => Text('screen:$p')),
    ],
  );
  await tester.pumpWidget(MaterialApp.router(routerConfig: router));
  await tester.pumpAndSettle();
  return router.routeInformationProvider.value.uri.path;
}

void main() {
  group('order number', () {
    test('shows the customer-facing LNDR number, never a slice of the internal id', () {
      final order = OrderModel(
        id: 'e62a5f38-9b1c-4d6e-8f00-aaaaaaaaaaaa',
        orderNumber: 'LNDR-20260919-43T',
        customerId: 'c',
        vendorId: 'v',
        items: const [],
        status: OrderStatus.waitingForVendorConfirmation,
        createdAt: DateTime(2026, 9, 19),
      );
      expect(order.displayNumber, 'LNDR-20260919-43T');
      expect(order.displayNumber.toLowerCase().contains('e62a5f38'), isFalse);
    });

    test('a missing number is a dash, not the database id', () {
      final order = OrderModel(
        id: 'e62a5f38-9b1c-4d6e-8f00-aaaaaaaaaaaa',
        customerId: 'c',
        vendorId: 'v',
        items: const [],
        status: OrderStatus.waitingForVendorConfirmation,
        createdAt: DateTime(2026, 9, 19),
      );
      expect(order.displayNumber, '—');
    });
  });

  group('routing', () {
    testWidgets('Captain Management opens for the owner (does not bounce to Home)', (tester) async {
      final where = await _landing(
        tester,
        start: AppRoutes.riderManagement,
        auth: AuthAuthenticated(_vendor(), shopRole: 'VENDOR_OWNER'),
        access: MyAccess.owner,
      );
      expect(where, AppRoutes.riderManagement);
    });

    testWidgets('Staff Management opens for the owner', (tester) async {
      final where = await _landing(
        tester,
        start: AppRoutes.employees,
        auth: AuthAuthenticated(_vendor(), shopRole: 'VENDOR_OWNER'),
        access: MyAccess.owner,
      );
      expect(where, AppRoutes.employees);
    });

    testWidgets('staff cannot reach Staff or Captain Management', (tester) async {
      const staff = MyAccess(loaded: true, role: 'VENDOR_STAFF', modules: {'orders'});
      for (final path in [AppRoutes.employees, AppRoutes.riderManagement]) {
        final where = await _landing(
          tester,
          start: path,
          auth: AuthAuthenticated(_vendor(), shopRole: 'VENDOR_STAFF'),
          access: staff,
        );
        expect(where, AppRoutes.dashboard, reason: '$path must be owner-only');
      }
    });

    testWidgets('staff reach only the modules they were granted', (tester) async {
      const staff = MyAccess(loaded: true, role: 'VENDOR_STAFF', modules: {'orders'});
      final auth = AuthAuthenticated(_vendor(), shopRole: 'VENDOR_STAFF');
      expect(await _landing(tester, start: AppRoutes.orders, auth: auth, access: staff), AppRoutes.orders);
      expect(await _landing(tester, start: AppRoutes.services, auth: auth, access: staff), AppRoutes.dashboard);
      expect(await _landing(tester, start: AppRoutes.analytics, auth: auth, access: staff), AppRoutes.dashboard);
    });

    testWidgets('a captain is kept in the captain workflow', (tester) async {
      final where = await _landing(
        tester,
        start: AppRoutes.dashboard,
        auth: AuthAuthenticated(_vendor(), shopRole: 'VENDOR_RIDER'),
        access: const MyAccess(loaded: true, role: 'VENDOR_RIDER'),
      );
      expect(where, AppRoutes.riderJobs);
    });
  });

  group('access model', () {
    test('owner has everything; staff only what the backend says', () {
      expect(MyAccess.owner.can('orders.reevaluate'), isTrue);
      expect(MyAccess.owner.canModule('inventory'), isTrue);
      final staff = MyAccess.fromJson({
        'role': 'VENDOR_STAFF',
        'is_owner': false,
        'allowed_modules': ['orders'],
        'allowed_items': ['orders.view', 'orders.accept_reject'],
      });
      expect(staff.can('orders.accept_reject'), isTrue);
      expect(staff.can('orders.reevaluate'), isFalse);
      expect(staff.canModule('catalogue'), isFalse);
    });
  });

  group('Staff Management', () {
    testWidgets('lists staff only — a captain never appears here', (tester) async {
      final repo = _FakeRepo();
      await tester.pumpWidget(_app(const EmployeesPage(), repo: repo));
      await tester.pumpAndSettle();

      expect(find.text('Asha Staff'), findsOneWidget);
      expect(find.text('Ravi Captain'), findsNothing);
    });

    testWidgets('the empty list scrolls and is not a fixed grey block', (tester) async {
      final repo = _FakeRepo()..all.clear();
      await tester.pumpWidget(_app(const EmployeesPage(), repo: repo));
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Add Staff'), findsOneWidget);
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, isNot(const Color(0xFFF8F9FD)));
    });

    testWidgets('the form shows the backend permission catalog and saves raw permission strings', (tester) async {
      final repo = _FakeRepo();
      await tester.pumpWidget(_app(const EmployeesPage(), repo: repo));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add Staff'));
      await tester.pumpAndSettle();

      // Rendered from the catalog: module headings and each item.
      expect(find.text('ORDERS'), findsOneWidget);
      expect(find.text('Re-evaluation'), findsWidgets);

      await tester.enterText(find.widgetWithText(TextFormField, 'Full Name'), 'New Person');
      await tester.enterText(find.widgetWithText(TextFormField, 'Email Address'), 'new@example.com');
      await tester.enterText(find.byType(TextFormField).at(2), '98765 43210');

      // Turn on Re-evaluation (the view permission is on by default).
      await tester.ensureVisible(find.widgetWithText(SwitchListTile, 'Re-evaluation'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(SwitchListTile, 'Re-evaluation'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Invite Staff').last);
      await tester.tap(find.text('Invite Staff').last);
      await tester.pumpAndSettle();

      expect(repo.created, isNotNull);
      expect(repo.created!['role'], 'VENDOR_STAFF', reason: 'this screen can only create staff');
      expect(repo.created!['phone'], '9876543210');
      expect(
        (repo.created!['permissions'] as List).toSet(),
        {'shop_orders.view', 'shop_orders.reevaluate'},
      );
    });

    testWidgets('a phone number is required for a new staff member', (tester) async {
      final repo = _FakeRepo();
      await tester.pumpWidget(_app(const EmployeesPage(), repo: repo));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add Staff'));
      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextFormField, 'Full Name'), 'No Phone');
      await tester.enterText(find.widgetWithText(TextFormField, 'Email Address'), 'np@example.com');
      await tester.ensureVisible(find.text('Invite Staff').last);
      await tester.tap(find.text('Invite Staff').last);
      await tester.pumpAndSettle();

      expect(repo.created, isNull);
    });
  });
}
