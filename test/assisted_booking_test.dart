import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lndry_vendor_app/api/repositories/api_vendor_repository.dart';
import 'package:lndry_vendor_app/core/extensions/order_extensions.dart';
import 'package:lndry_vendor_app/core/services/storage_service.dart';
import 'package:lndry_vendor_app/features/orders/presentation/pages/order_details_page.dart';
import 'package:lndry_vendor_app/features/orders/presentation/pages/orders_page.dart';
import 'package:lndry_vendor_app/l10n/generated/app_localizations.dart';
import 'package:lndry_vendor_app/models/models.dart';
import 'package:lndry_vendor_app/providers/access_provider.dart';
import 'package:lndry_vendor_app/repositories/repositories.dart';
import 'package:lndry_vendor_app/shared/repositories/base_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// "Book With Expert Check" (assisted booking), vendor side: the customer
/// chose no services, so the vendor picks them through the EXISTING
/// re-evaluation flow. These tests pin what the vendor sees and can do.

OrderModel _order({
  String bookingType = 'ASSISTED',
  OrderStatus status = OrderStatus.receivedAtVendor,
  List<OrderItem> items = const [],
}) =>
    OrderModel(
      id: 'o1',
      orderNumber: 'LNDR-20260921-XYZ',
      customerId: 'c',
      vendorId: 'v',
      items: items,
      status: status,
      total: 34,
      bookingType: bookingType,
      createdAt: DateTime(2026, 9, 21),
    );

class _Server extends Fake implements VendorRepository {
  _Server(this.order);
  OrderModel order;
  Map<String, dynamic>? reconcileArgs;

  static const wash = ReclassifyOption(
    garmentTypeId: 'g-shirt',
    garmentName: 'Shirt',
    unit: 'piece',
    ratePaise: 5000,
    serviceName: 'Dry Clean',
    categoryName: 'Men',
  );

  @override
  Future<OrderModel> getOrder(String orderId) async => order;

  @override
  Future<PaginatedResponse<OrderModel>> getIncomingOrders({PaginationParams params = const PaginationParams(), String? status}) async =>
      PaginatedResponse(
        items: [order],
        meta: const PaginationMeta(currentPage: 1, totalPages: 1, totalItems: 1, pageSize: 20),
      );

  @override
  Future<List<ReclassifyOption>> getVendorServiceCatalog() async => const [wash];

  @override
  Future<List<ReconciliationProblemType>> getReconciliationProblemTypes() async => const [];

  @override
  Future<Map<String, dynamic>> getDashboardStats() async => {};

  @override
  Future<Map<String, dynamic>> reconcileOrder(
    String orderId, {
    List<Map<String, dynamic>>? lines,
    double? confirmedWeightKg,
    String? adjustmentReason,
    required List<String> photoUrls,
    List<Map<String, dynamic>>? newLines,
    List<Map<String, dynamic>>? problems,
  }) async {
    reconcileArgs = {'lines': lines, 'newLines': newLines, 'photoUrls': photoUrls, 'problems': problems};
    return {};
  }

  @override
  Future<MyAccess> getMyAccess() async => MyAccess.owner;
}

Widget _app(_Server server, Widget Function() page) {
  final router = GoRouter(
    initialLocation: '/orders/details/o1',
    routes: [
      GoRoute(path: '/orders/details/:id', builder: (_, __) => page()),
      GoRoute(path: '/orders', builder: (_, __) => page()),
    ],
  );
  return ProviderScope(
    overrides: [
      vendorRepositoryProvider.overrideWithValue(server),
      myAccessProvider.overrideWith((ref) => MyAccessNotifier(server, shopRole: 'VENDOR_OWNER', signedIn: true)),
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

void _tall(WidgetTester tester) {
  tester.view.physicalSize = const Size(780, 2600);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
}

ElevatedButton _submitButton(WidgetTester tester) =>
    tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Submit for Customer Approval'));

void main() {
  group('parsing', () {
    late ApiVendorRepository repo;
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      repo = ApiVendorRepository(dio: Dio(), storage: StorageService(prefs: await SharedPreferences.getInstance()));
    });

    test('reads booking_type from the backend and knows an unpriced assisted order', () {
      final o = repo.parseOrderForTest({'id': 'o1', 'order_number': 'LNDR-1', 'status': 'RECEIVED_AT_VENDOR', 'booking_type': 'ASSISTED', 'lines': []});
      expect(o.isAssisted, isTrue);
      expect(o.awaitingServiceSelection, isTrue);
    });

    test('once services exist, or for a normal order, it is not awaiting selection', () {
      final priced = repo.parseOrderForTest({
        'id': 'o1',
        'status': 'PROCESSING',
        'booking_type': 'ASSISTED',
        'lines': [
          {'id': 'l1', 'name': 'Shirt', 'quantity': 2, 'rate_paise': 5000, 'total_paise': 10000, 'unit': 'piece'},
        ],
      });
      expect(priced.isAssisted, isTrue);
      expect(priced.awaitingServiceSelection, isFalse);

      final normal = repo.parseOrderForTest({'id': 'o2', 'status': 'RECEIVED_AT_VENDOR', 'lines': []});
      expect(normal.isAssisted, isFalse);
      expect(normal.awaitingServiceSelection, isFalse);
    });
  });

  group('order details', () {
    testWidgets('is clearly labelled, has no fake price, and offers only "Choose Services"', (tester) async {
      _tall(tester);
      await tester.pumpWidget(_app(_Server(_order()), () => const OrderDetailsPage(orderId: 'o1')));
      await tester.pumpAndSettle();

      expect(find.text('Assisted Booking / Service Selection Required'), findsOneWidget);
      expect(find.textContaining('No services selected yet'), findsOneWidget);
      // Processing cannot start before the services are chosen and approved.
      expect(find.text('Start Processing'), findsNothing);
      expect(find.text('Choose Services'), findsWidgets);
    });

    testWidgets('a normal order is unchanged: no assisted label, Start Processing still offered', (tester) async {
      _tall(tester);
      await tester.pumpWidget(_app(_Server(_order(bookingType: 'STANDARD')), () => const OrderDetailsPage(orderId: 'o1')));
      await tester.pumpAndSettle();

      expect(find.text('Assisted Booking / Service Selection Required'), findsNothing);
      expect(find.text('Start Processing'), findsOneWidget);
    });

    testWidgets('choosing services goes through the normal re-evaluation, with no problem report required', (tester) async {
      _tall(tester);
      final server = _Server(_order());
      await tester.pumpWidget(_app(server, () => const OrderDetailsPage(orderId: 'o1')));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Choose Services'));
      await tester.pumpAndSettle();
      expect(find.text('Choose services'), findsOneWidget);

      // Nothing chosen yet → cannot be sent for approval.
      expect(_submitButton(tester).onPressed, isNull);

      // Add a service (existing Add Service flow) with a quantity.
      await tester.tap(find.text('Add Service'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Shirt'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, '3');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
      await tester.pumpAndSettle();

      // Now it can be submitted — no "report a problem" needed for an assisted order.
      expect(_submitButton(tester).onPressed, isNotNull);
      await tester.tap(find.widgetWithText(ElevatedButton, 'Submit for Customer Approval'));
      await tester.pumpAndSettle();

      expect(server.reconcileArgs, isNotNull, reason: 'goes to the existing reconcile endpoint');
      expect(server.reconcileArgs!['newLines'], [
        {'garment_type_id': 'g-shirt', 'quantity': 3.0},
      ]);
      expect(server.reconcileArgs!['problems'], isNull);
      expect(server.reconcileArgs!['photoUrls'], isEmpty);
    });

    testWidgets('a normal order still needs a problem report before it can be submitted', (tester) async {
      _tall(tester);
      final item = const OrderItem(serviceId: 's', serviceName: 'Wash', quantity: 2, unitPrice: 50, totalPrice: 100, orderLineId: 'l1');
      await tester.pumpWidget(_app(_Server(_order(bookingType: 'STANDARD', items: [item])), () => const OrderDetailsPage(orderId: 'o1')));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(OutlinedButton, 'Reconcile items'));
      await tester.pumpAndSettle();
      expect(_submitButton(tester).onPressed, isNull, reason: 'unchanged rule for orders the customer specified');
    });
  });

  group('orders list', () {
    testWidgets('marks the order, says a service must be selected, and shows no fee-only price', (tester) async {
      _tall(tester);
      await tester.pumpWidget(_app(_Server(_order(status: OrderStatus.waitingForVendorConfirmation)), () => const OrdersPage()));
      await tester.pumpAndSettle();

      expect(find.text('Assisted Booking'), findsOneWidget);
      expect(find.text('Service selection required'), findsOneWidget);
      expect(find.text('To be evaluated'), findsOneWidget);
      expect(find.text('₹34.00'), findsNothing);
    });
  });
}
