import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lndry_vendor_app/api/repositories/api_vendor_repository.dart';
import 'package:lndry_vendor_app/features/orders/presentation/pages/order_details_page.dart';
import 'package:lndry_vendor_app/features/riders/presentation/pages/rider_management_page.dart';
import 'package:lndry_vendor_app/l10n/generated/app_localizations.dart';
import 'package:lndry_vendor_app/models/models.dart';
import 'package:lndry_vendor_app/providers/access_provider.dart';
import 'package:lndry_vendor_app/repositories/repositories.dart';

class _Server extends Fake implements VendorRepository {
  final captains = <EmployeeModel>[
    const EmployeeModel(id: 'c1', vendorId: 'v', userId: 'u1', name: 'sanu', email: '', phone: '9775845599', role: 'VENDOR_RIDER'),
  ];
  String? assignedTo;

  @override
  Future<OrderModel> getOrder(String orderId) async => OrderModel(
        id: orderId,
        orderNumber: 'LNDR-20260919-43T',
        customerId: 'c',
        vendorId: 'v',
        items: const [],
        status: OrderStatus.vendorAccepted,
        createdAt: DateTime(2026, 9, 19),
      );

  @override
  Future<List<EmployeeModel>> getRiders() async => List.of(captains);

  @override
  Future<EmployeeModel> createRider({required String name, required String phone}) async {
    final c = EmployeeModel(id: 'c${captains.length + 1}', vendorId: 'v', userId: 'u', name: name, email: '', phone: phone, role: 'VENDOR_RIDER');
    captains.add(c);
    return c;
  }

  @override
  Future<OrderModel> assignRider(String orderId, String employeeId) async {
    assignedTo = employeeId;
    return getOrder(orderId);
  }

  @override
  Future<MyAccess> getMyAccess() async => MyAccess.owner;
}

Widget _app(_Server server, {MyAccess? access}) {
  final router = GoRouter(
    initialLocation: '/orders/details/o1',
    routes: [
      GoRoute(path: '/orders/details/:id', builder: (_, s) => OrderDetailsPage(orderId: s.pathParameters['id']!)),
      GoRoute(
        path: '/rider-management',
        builder: (_, s) => RiderManagementPage(openAddOnStart: s.uri.queryParameters['add'] == '1'),
      ),
    ],
  );
  return ProviderScope(
    overrides: [
      vendorRepositoryProvider.overrideWithValue(server),
      myAccessProvider.overrideWith((ref) {
        final n = MyAccessNotifier(server, shopRole: 'VENDOR_OWNER', signedIn: true);
        return n;
      }),
    ],
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

void main() {
  testWidgets('Add Captain from the Assign Captain sheet, then Back returns to the same sheet with the new captain', (tester) async {
    tester.view.physicalSize = const Size(780, 1688);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    final server = _Server();
    await tester.pumpWidget(_app(server));
    await tester.pumpAndSettle();

    // Open Assign Captain.
    expect(find.textContaining('LNDR-20260919-43T'), findsOneWidget);
    await tester.tap(find.text('Assign'));
    await tester.pumpAndSettle();
    expect(find.text('Assign Captain'), findsWidgets);
    expect(find.text('sanu'), findsOneWidget);
    expect(find.text('Add Captain'), findsOneWidget, reason: 'the quick option sits at the bottom of the sheet');

    // Tap it: the existing Captain Management form opens, nothing is duplicated on the order screen.
    await tester.tap(find.text('Add Captain'));
    await tester.pumpAndSettle();
    expect(find.text('Captain Management'), findsOneWidget);
    expect(find.text('The captain logs in with this phone number, the same way you do.'), findsOneWidget, reason: 'the Add Captain form opened by itself');

    await tester.enterText(find.widgetWithText(TextFormField, 'Full Name'), 'Ravi');
    await tester.enterText(find.widgetWithText(TextFormField, 'Phone Number'), '9876543210');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Add Captain'));
    await tester.pumpAndSettle();
    expect(server.captains.map((c) => c.name), contains('Ravi'), reason: 'saved through the normal Captain Management logic');
    expect(find.text('Ravi'), findsOneWidget, reason: 'listed on the Captain Management page too');

    // Back (the app bar arrow) goes straight back to this order and reopens Assign Captain, list refreshed.
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();
    expect(find.textContaining('LNDR-20260919-43T'), findsOneWidget, reason: 'same order, not Home');
    expect(find.text('Assign Captain'), findsWidgets);
    expect(find.text('Ravi'), findsOneWidget, reason: 'new captain is in the list without any manual refresh');
    expect(find.text('sanu'), findsOneWidget);

    // ...and can be picked for this order right away.
    await tester.tap(find.text('Ravi'));
    await tester.pumpAndSettle();
    expect(server.assignedTo, 'c2');
  });

  testWidgets('the sheet scrolls so the last captain and Add Captain are reachable with many captains on a small screen', (tester) async {
    tester.view.physicalSize = const Size(600, 900); // small phone
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    final server = _Server();
    for (var i = 0; i < 14; i++) {
      server.captains.add(EmployeeModel(id: 'x$i', vendorId: 'v', userId: 'u$i', name: 'Captain $i', email: '', phone: '90000000$i'.padRight(10, '0').substring(0, 10), role: 'VENDOR_RIDER'));
    }
    await tester.pumpWidget(_app(server));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Assign'));
    await tester.pumpAndSettle();

    final add = find.text('Add Captain');
    expect(find.text('Captain 13').hitTestable(), findsNothing, reason: 'starts off-screen');
    await tester.scrollUntilVisible(add, 200, scrollable: find.descendant(of: find.byType(BottomSheet), matching: find.byType(Scrollable)).first);
    await tester.pumpAndSettle();
    expect(add.hitTestable(), findsOneWidget);
    expect(find.text('Captain 13').hitTestable(), findsOneWidget, reason: 'every captain is reachable');
  });
}
