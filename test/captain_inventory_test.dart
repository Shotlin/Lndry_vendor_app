import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lndry_vendor_app/api/repositories/api_vendor_repository.dart';
import 'package:lndry_vendor_app/core/network/api_exception.dart';
import 'package:lndry_vendor_app/core/network/friendly_error.dart';
import 'package:lndry_vendor_app/core/utils/phone_input.dart';
import 'package:lndry_vendor_app/features/inventory/presentation/pages/inventory_page.dart';
import 'package:lndry_vendor_app/features/riders/presentation/pages/rider_management_page.dart';
import 'package:lndry_vendor_app/l10n/generated/app_localizations.dart';
import 'package:lndry_vendor_app/models/models.dart';
import 'package:lndry_vendor_app/providers/access_provider.dart';
import 'package:lndry_vendor_app/repositories/repositories.dart';

/// Stands in for the backend: whatever it holds survives the screen closing,
/// exactly like the real server.
class _Server extends Fake implements VendorRepository {
  final riders = <EmployeeModel>[];
  String? createdPhone;
  Object? createError;

  var inventory = <InventoryItem>[
    const InventoryItem(id: 'a', name: 'Liquid Detergent', quantity: 24, minThreshold: 5, unit: 'Liters'),
    const InventoryItem(id: 'b', name: 'Premium Bleach', quantity: 3, minThreshold: 5, unit: 'Liters'),
  ];
  Object? adjustError;
  int adjustCalls = 0;

  @override
  Future<List<EmployeeModel>> getRiders() async => List.of(riders);

  @override
  Future<EmployeeModel> createRider({required String name, required String phone}) async {
    if (createError != null) throw createError!;
    createdPhone = phone;
    final rider = EmployeeModel(
      id: 'r${riders.length}',
      vendorId: 'v',
      userId: 'u',
      name: name,
      email: '',
      phone: phone,
      role: 'VENDOR_RIDER',
    );
    riders.add(rider);
    return rider;
  }

  @override
  Future<MyAccess> getMyAccess() async => MyAccess.owner;

  @override
  Future<List<InventoryItem>> getInventory() async => List.of(inventory);

  @override
  Future<InventoryItem> adjustInventoryQuantity(String id, int delta) async {
    adjustCalls++;
    if (adjustError != null) throw adjustError!;
    final i = inventory.indexWhere((e) => e.id == id);
    inventory[i] = inventory[i].copyWith(quantity: (inventory[i].quantity + delta).clamp(0, 1 << 30));
    return inventory[i];
  }

  @override
  Future<InventoryItem> createInventoryItem({
    required String name,
    required int quantity,
    required int minThreshold,
    required String unit,
  }) async {
    final item = InventoryItem(id: 'n${inventory.length}', name: name, quantity: quantity, minThreshold: minThreshold, unit: unit);
    inventory.add(item);
    return item;
  }
}

Widget _app(Widget page, _Server server) {
  final router = GoRouter(routes: [GoRoute(path: '/', builder: (_, __) => page)]);
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

DioException _bad(int status, {String? message}) {
  final options = RequestOptions(path: '/vendor/employees');
  final api = ApiException(message: message ?? 'Request failed', statusCode: status);
  return DioException(
    requestOptions: options,
    response: Response(requestOptions: options, statusCode: status, data: message == null ? '<html>Bad Gateway</html>' : {'message': message}),
    type: DioExceptionType.badResponse,
    error: api,
    message: 'This exception was thrown because the response has a status code of $status and RequestOptions.validateStatus was configured to throw for this status code.',
  );
}

void main() {
  group('friendlyError', () {
    test('a 502 becomes a short sentence — never DioException text', () {
      final text = friendlyError(_bad(502));
      expect(text, 'The server is busy right now. Please try again in a moment.');
      expect(text, isNot(contains('DioException')));
      expect(text, isNot(contains('status code')));
      expect(text, isNot(contains('developer.mozilla')));
    });

    test('no connection / timeout / unknown', () {
      expect(
        friendlyError(DioException(requestOptions: RequestOptions(path: '/x'), type: DioExceptionType.connectionError)),
        contains("Couldn't reach the server"),
      );
      expect(
        friendlyError(DioException(requestOptions: RequestOptions(path: '/x'), type: DioExceptionType.receiveTimeout)),
        contains('took too long'),
      );
      expect(friendlyError(StateError('Bad state: boom')), 'Something went wrong. Please try again.');
      expect(friendlyError(const ApiException(message: 'Unknown error', statusCode: 400)), 'Something went wrong. Please try again.');
    });

    test('a message written for people is kept', () {
      const msg = 'This phone number is already added to your shop as a captain.';
      expect(friendlyError(const ApiException(message: msg, statusCode: 400)), msg);
      expect(friendlyError(_bad(400, message: msg)), msg);
      expect(friendlyError(Exception('Please choose a slot')), 'Please choose a slot');
    });
  });

  group('phone field', () {
    const f = TenDigitPhoneFormatter();
    TextEditingValue run(String text) => f.formatEditUpdate(TextEditingValue.empty, TextEditingValue(text: text));

    test('digits only, at most 10', () {
      expect(run('98765abc43210').text, '9876543210');
      expect(run('66666666666666666666').text, '6666666666');
      expect(run('98 76-54').text, '987654');
      expect(run('+91 98765 43210').text, '9876543210');
      expect(run('919876543210').text, '9876543210');
      expect(run('abc').text, '');
    });

    test('valid only with exactly 10 digits', () {
      expect(isValidTenDigitPhone('9876543210'), isTrue);
      expect(isValidTenDigitPhone('987654321'), isFalse);
      expect(isValidTenDigitPhone('98765432101'), isFalse);
      expect(isValidTenDigitPhone('98765abcde'), isFalse);
      expect(isValidTenDigitPhone(''), isFalse);
    });
  });

  group('Add Captain', () {
    Future<void> openForm(WidgetTester tester, _Server server) async {
      await tester.pumpWidget(_app(const RiderManagementPage(), server));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(FloatingActionButton).evaluate().isNotEmpty ? find.byType(FloatingActionButton) : find.text('Add Captain').first);
      await tester.pumpAndSettle();
    }

    testWidgets('the field takes digits only and stops at 10', (tester) async {
      final server = _Server();
      await openForm(tester, server);
      final phone = find.widgetWithText(TextFormField, 'Phone Number');
      await tester.enterText(phone, '98a76 5432109999');
      await tester.pump();
      expect(tester.widget<TextField>(find.descendant(of: phone, matching: find.byType(TextField))).controller!.text, '9876543210');
    });

    testWidgets('fewer than 10 digits is refused with the plain message and nothing is sent', (tester) async {
      final server = _Server();
      await openForm(tester, server);
      await tester.enterText(find.widgetWithText(TextFormField, 'Full Name'), 'Sayan');
      await tester.enterText(find.widgetWithText(TextFormField, 'Phone Number'), '977584');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add Captain'));
      await tester.pumpAndSettle();
      expect(find.text('Enter a valid 10-digit mobile number.'), findsOneWidget);
      expect(server.createdPhone, isNull);
    });

    testWidgets('exactly 10 digits is sent', (tester) async {
      final server = _Server();
      await openForm(tester, server);
      await tester.enterText(find.widgetWithText(TextFormField, 'Full Name'), 'Sayan');
      await tester.enterText(find.widgetWithText(TextFormField, 'Phone Number'), '9775845585');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add Captain'));
      await tester.pumpAndSettle();
      expect(server.createdPhone, '9775845585');
    });

    testWidgets('a 502 shows one short message, not the exception', (tester) async {
      final server = _Server()..createError = _bad(502);
      await openForm(tester, server);
      await tester.enterText(find.widgetWithText(TextFormField, 'Full Name'), 'Sayan');
      await tester.enterText(find.widgetWithText(TextFormField, 'Phone Number'), '9775845585');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add Captain'));
      await tester.pumpAndSettle();
      expect(find.textContaining('The server is busy right now'), findsOneWidget);
      expect(find.textContaining('DioException'), findsNothing);
      expect(find.textContaining('ApiException'), findsNothing);
      expect(find.textContaining('status code'), findsNothing);
    });
  });

  group('Operational Supplies', () {
    testWidgets('a + is saved on the server and is still there when the screen is reopened', (tester) async {
      final server = _Server();
      await tester.pumpWidget(_app(const InventoryPage(), server));
      await tester.pumpAndSettle();
      expect(find.text('24'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add_circle_outline_rounded).first);
      await tester.pumpAndSettle();
      expect(find.text('25'), findsOneWidget);
      expect(server.inventory.first.quantity, 25, reason: 'the server holds the new quantity');

      // Leave the screen and come back with a brand-new app state: only the server remembers.
      await tester.pumpWidget(const SizedBox());
      await tester.pumpWidget(_app(const InventoryPage(), server));
      await tester.pumpAndSettle();
      expect(find.text('25'), findsOneWidget);
    });

    testWidgets('a − also persists, and never goes below zero', (tester) async {
      final server = _Server();
      server.inventory = [const InventoryItem(id: 'z', name: 'Starch Spray', quantity: 1, minThreshold: 3, unit: 'Cans')];
      await tester.pumpWidget(_app(const InventoryPage(), server));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.remove_circle_outline_rounded));
      await tester.pumpAndSettle();
      expect(server.inventory.single.quantity, 0);
      final calls = server.adjustCalls;
      await tester.tap(find.byIcon(Icons.remove_circle_outline_rounded));
      await tester.pumpAndSettle();
      expect(server.inventory.single.quantity, 0);
      expect(server.adjustCalls, calls, reason: 'nothing to send at zero');
    });

    testWidgets('if the server refuses, the screen shows what the server holds and a short message', (tester) async {
      final server = _Server()..adjustError = _bad(502);
      await tester.pumpWidget(_app(const InventoryPage(), server));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.add_circle_outline_rounded).first);
      await tester.pumpAndSettle();
      expect(find.text('24'), findsOneWidget, reason: 'back to the saved value');
      expect(find.text('25'), findsNothing);
      expect(find.textContaining('The server is busy right now'), findsOneWidget);
      expect(find.textContaining('DioException'), findsNothing);
    });

    testWidgets('a new supply is only added once the server has it', (tester) async {
      final server = _Server();
      await tester.pumpWidget(_app(const InventoryPage(), server));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.enterText(find.widgetWithText(TextFormField, 'Item Name'), 'Hanger Clips');
      await tester.enterText(find.widgetWithText(TextFormField, 'Initial Qty'), '40');
      await tester.enterText(find.widgetWithText(TextFormField, 'Min Limit'), '10');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add Item'));
      await tester.pumpAndSettle();
      expect(server.inventory.map((i) => i.name), contains('Hanger Clips'));
      expect(server.inventory.last.quantity, 40);
      expect(server.inventory.last.minThreshold, 10);
      expect(find.text('Hanger Clips'), findsOneWidget);
    });
  });
}
