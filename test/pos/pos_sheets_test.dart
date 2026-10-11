import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lndry_vendor_app/features/pos/booking/add_garment_price_sheet.dart';
import 'package:lndry_vendor_app/features/pos/customers/add_customer_sheet.dart';
import 'package:lndry_vendor_app/features/pos/customers/customer_picker.dart';
import 'package:lndry_vendor_app/features/pos/customers/phone.dart';
import 'package:lndry_vendor_app/models/pos/pos_customer_model.dart';

import 'pos_fakes.dart';
import 'pos_harness.dart';

/// A page with a button that opens [open] and prints what the sheet returned.
Widget opener(Future<Object?> Function(BuildContext) open, ValueNotifier<Object?> result) => Builder(
      builder: (context) => Scaffold(
        body: Center(
          child: FilledButton(
            onPressed: () async => result.value = await open(context),
            child: const Text('OPEN'),
          ),
        ),
      ),
    );

void main() {
  group('normalizeMobile', () {
    test('accepts the usual ways of writing an Indian mobile', () {
      for (final ok in ['9811122233', '98111 22233', '+91 98111-22233', '919811122233', '09811122233', ' 98111 22233 ']) {
        expect(normalizeMobile(ok), '9811122233', reason: ok);
      }
    });
    test('rejects everything else', () {
      for (final bad in ['', '12345', '98111222', '981112223344', 'abcdefghij', '+1 9811122233', null]) {
        expect(normalizeMobile(bad), isNull, reason: '$bad');
      }
    });
  });

  group('customer picker', () {
    testWidgets('lists recent customers when nothing is typed, and returns the one tapped', (t) async {
      final result = ValueNotifier<Object?>(null);
      final pos = await pumpPos(t, opener((c) => showCustomerPicker(c), result));
      await t.tap(find.text('OPEN'));
      await t.pumpAndSettle();
      expect(find.text('Recent customers'), findsOneWidget);
      expect(find.text('Asha Verma'), findsOneWidget);
      expect(pos.counter.customerSearches, ['']);
      await t.tap(find.text('Asha Verma'));
      await t.pumpAndSettle();
      expect((result.value as PosCustomer).id, 'u-1');
    });

    testWidgets('typing searches after a short pause (one request, not one per letter)', (t) async {
      final result = ValueNotifier<Object?>(null);
      final pos = await pumpPos(t, opener((c) => showCustomerPicker(c), result));
      await t.tap(find.text('OPEN'));
      await t.pumpAndSettle();
      for (final text in ['a', 'as', 'ash']) {
        await t.enterText(find.byType(TextField), text);
        await t.pump(const Duration(milliseconds: 100));
      }
      await t.pump(const Duration(milliseconds: 400));
      await t.pumpAndSettle();
      expect(pos.counter.customerSearches, ['', 'ash']);
    });

    testWidgets('no match says so; a full phone number offers to add it', (t) async {
      final result = ValueNotifier<Object?>(null);
      await pumpPos(t, opener((c) => showCustomerPicker(c), result));
      await t.tap(find.text('OPEN'));
      await t.pumpAndSettle();
      await t.enterText(find.byType(TextField), 'zzz');
      await t.pump(const Duration(milliseconds: 400));
      await t.pumpAndSettle();
      expect(find.text('No customer found.'), findsOneWidget);

      await t.enterText(find.byType(TextField), '9000011111');
      await t.pump(const Duration(milliseconds: 400));
      await t.pumpAndSettle();
      expect(find.text('Add 9000011111 as a new customer'), findsOneWidget);
      await t.tap(find.text('Add 9000011111 as a new customer'));
      await t.pumpAndSettle();
      // the Add Customer sheet opens with the phone filled in
      expect(t.widget<TextFormField>(find.widgetWithText(TextFormField, 'Mobile number (10 digits)')).controller!.text, '9000011111');
      await t.enterText(find.widgetWithText(TextFormField, 'Customer name'), 'Ravi');
      await t.tap(find.widgetWithText(FilledButton, 'Add Customer'));
      await t.pumpAndSettle();
      expect((result.value as PosCustomer).name, 'Ravi');
      expect((result.value as PosCustomer).phone, '9000011111');
    });

    testWidgets('an existing customer typed by phone is not offered again as "new"', (t) async {
      final result = ValueNotifier<Object?>(null);
      await pumpPos(t, opener((c) => showCustomerPicker(c), result));
      await t.tap(find.text('OPEN'));
      await t.pumpAndSettle();
      await t.enterText(find.byType(TextField), '9811122233');
      await t.pump(const Duration(milliseconds: 400));
      await t.pumpAndSettle();
      expect(find.textContaining('as a new customer'), findsNothing);
      expect(find.text('Asha Verma'), findsOneWidget);
    });

    testWidgets('a failing search is explained and retried', (t) async {
      final result = ValueNotifier<Object?>(null);
      final counter = _FlakyCustomers();
      await pumpPos(t, opener((c) => showCustomerPicker(c), result), counter: counter);
      await t.tap(find.text('OPEN'));
      await t.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Try again'), findsOneWidget);
      counter.fail = false;
      await t.tap(find.text('Try again'));
      await t.pumpAndSettle();
      expect(find.text('Asha Verma'), findsOneWidget);
    });
  });

  group('add customer sheet', () {
    testWidgets('validates name and phone before calling the server', (t) async {
      final result = ValueNotifier<Object?>(null);
      final pos = await pumpPos(t, opener((c) => showAddCustomerSheet(c), result));
      await t.tap(find.text('OPEN'));
      await t.pumpAndSettle();
      await t.tap(find.widgetWithText(FilledButton, 'Add Customer'));
      await t.pumpAndSettle();
      expect(find.text("Enter the customer's name"), findsOneWidget);
      expect(find.text('Enter a 10-digit mobile number'), findsOneWidget);
      await t.enterText(find.widgetWithText(TextFormField, 'Customer name'), 'Ravi');
      await t.enterText(find.widgetWithText(TextFormField, 'Mobile number (10 digits)'), '98765');
      await t.tap(find.widgetWithText(FilledButton, 'Add Customer'));
      await t.pumpAndSettle();
      expect(find.text('Enter a 10-digit mobile number'), findsOneWidget);
      expect(result.value, isNull);
      expect(pos.counter.customerSearches, isEmpty);
    });

    testWidgets('sends the cleaned number and returns the customer', (t) async {
      final result = ValueNotifier<Object?>(null);
      await pumpPos(t, opener((c) => showAddCustomerSheet(c), result));
      await t.tap(find.text('OPEN'));
      await t.pumpAndSettle();
      await t.enterText(find.widgetWithText(TextFormField, 'Customer name'), '  Ravi  Kumar ');
      await t.enterText(find.widgetWithText(TextFormField, 'Mobile number (10 digits)'), '+91 98765-43210');
      await t.tap(find.widgetWithText(FilledButton, 'Add Customer'));
      await t.pumpAndSettle();
      final c = result.value as PosCustomer;
      expect(c.phone, '9876543210');
      expect(c.name, 'Ravi Kumar');
    });

    testWidgets('a server refusal is shown in words and the sheet stays open', (t) async {
      final result = ValueNotifier<Object?>(null);
      final counter = FakeCounterRepo()..createError = Exception('nope');
      await pumpPos(t, opener((c) => showAddCustomerSheet(c), result), counter: counter);
      await t.tap(find.text('OPEN'));
      await t.pumpAndSettle();
      await t.enterText(find.widgetWithText(TextFormField, 'Customer name'), 'Ravi');
      await t.enterText(find.widgetWithText(TextFormField, 'Mobile number (10 digits)'), '9876543210');
      await t.tap(find.widgetWithText(FilledButton, 'Add Customer'));
      await t.pumpAndSettle();
      expect(find.byType(AddCustomerSheet), findsOneWidget);
      expect(find.textContaining('Exception'), findsNothing);
      expect(result.value, isNull);
    });
  });

  group('add garment price sheet', () {
    Future<Pos> open(WidgetTester t, ValueNotifier<Object?> result, {String? garmentId, String? serviceId, FakeCatalogueRepo? cat}) async {
      final pos = await pumpPos(t, opener((c) => showAddGarmentPriceSheet(c, garmentId: garmentId, serviceId: serviceId), result), catalogue: cat);
      await t.tap(find.text('OPEN'));
      await t.pumpAndSettle();
      return pos;
    }

    Future<void> pick(WidgetTester t, String label, String option) async {
      await t.tap(find.widgetWithText(DropdownButtonFormField<String>, label));
      await t.pumpAndSettle();
      await t.tap(find.text(option).last);
      await t.pumpAndSettle();
    }

    testWidgets('needs a garment, a service and a valid price', (t) async {
      final result = ValueNotifier<Object?>(null);
      final pos = await open(t, result);
      await t.tap(find.widgetWithText(FilledButton, 'Add'));
      await t.pumpAndSettle();
      expect(find.text('Choose a garment'), findsOneWidget);
      await pick(t, 'Garment', 'Saree');
      await t.tap(find.widgetWithText(FilledButton, 'Add'));
      await t.pumpAndSettle();
      expect(find.text('Choose a service'), findsOneWidget);
      await pick(t, 'Service', 'Wash & Fold');
      await t.enterText(find.widgetWithText(TextField, 'Price (₹)'), '0');
      await t.tap(find.widgetWithText(FilledButton, 'Add'));
      await t.pumpAndSettle();
      expect(find.text('Enter a price like 80 or 80.50'), findsOneWidget);
      expect(pos.catalogue.calls.where((c) => c.startsWith('price')), isEmpty);
    });

    testWidgets('adds a new price in paise and closes with true', (t) async {
      final result = ValueNotifier<Object?>(null);
      final pos = await open(t, result);
      await pick(t, 'Garment', 'Saree');
      await pick(t, 'Service', 'Wash & Fold');
      await t.enterText(find.widgetWithText(TextField, 'Price (₹)'), '120.50');
      await t.tap(find.widgetWithText(FilledButton, 'Add'));
      await t.pumpAndSettle();
      expect(pos.catalogue.calls, contains('price:g-saree:s-wash:12050'));
      expect(result.value, true);
    });

    testWidgets('an existing garment keeps its category and unit (they are read-only)', (t) async {
      final result = ValueNotifier<Object?>(null);
      await open(t, result);
      await pick(t, 'Garment', 'Shirt');
      final category = t.widget<DropdownButtonFormField<String>>(find.widgetWithText(DropdownButtonFormField<String>, 'Category'));
      expect(category.onChanged, isNull);
      final unit = t.widget<DropdownButtonFormField<String>>(find.widgetWithText(DropdownButtonFormField<String>, 'Unit'));
      expect(unit.onChanged, isNull);
    });

    testWidgets('opened on an existing price it shows it and saves a change instead of a duplicate', (t) async {
      final result = ValueNotifier<Object?>(null);
      final pos = await open(t, result, garmentId: 'g-shirt', serviceId: 's-dry');
      expect(find.text('Change price'), findsOneWidget);
      expect(find.text('Current price ₹80'), findsOneWidget);
      expect(t.widget<TextField>(find.widgetWithText(TextField, 'Price (₹)')).controller!.text, '80');
      await t.enterText(find.widgetWithText(TextField, 'Price (₹)'), '95');
      await t.tap(find.widgetWithText(FilledButton, 'Save price'));
      await t.pumpAndSettle();
      expect(pos.catalogue.calls, contains('update:p1:9500'));
      expect(pos.catalogue.calls.where((c) => c.startsWith('price:')), isEmpty);
      expect(result.value, true);
    });

    testWidgets('inline + creates a garment with the chosen category and unit, then selects it', (t) async {
      final result = ValueNotifier<Object?>(null);
      final pos = await open(t, result);
      await pick(t, 'Category', 'Women');
      await pick(t, 'Unit', 'Kilogram');
      await t.tap(find.byTooltip('Create new: Garment'));
      await t.pumpAndSettle();
      await t.enterText(find.byType(TextField).last, 'Curtain');
      await t.tap(find.widgetWithText(FilledButton, 'Create'));
      await t.pumpAndSettle();
      expect(pos.catalogue.calls, contains('garment:Curtain:kg:c-women'));
    });

    testWidgets('inline + for a name that is too short is refused before any request', (t) async {
      final result = ValueNotifier<Object?>(null);
      final pos = await open(t, result);
      await t.tap(find.byTooltip('Create new: Service'));
      await t.pumpAndSettle();
      await t.enterText(find.byType(TextField).last, 'x');
      await t.tap(find.widgetWithText(FilledButton, 'Create'));
      await t.pumpAndSettle();
      expect(find.text('Enter a name'), findsOneWidget);
      expect(pos.catalogue.calls.where((c) => c.startsWith('service')), isEmpty);
    });

    testWidgets('a duplicate-price refusal from the server is shown and nothing closes', (t) async {
      final result = ValueNotifier<Object?>(null);
      final cat = FakeCatalogueRepo()..priceError = Exception('dup');
      await open(t, result, cat: cat);
      await pick(t, 'Garment', 'Saree');
      await pick(t, 'Service', 'Wash & Fold');
      await t.enterText(find.widgetWithText(TextField, 'Price (₹)'), '10');
      await t.tap(find.widgetWithText(FilledButton, 'Add'));
      await t.pumpAndSettle();
      expect(find.byType(AddGarmentPriceSheet), findsOneWidget);
      expect(result.value, isNull);
    });
  });
}

class _FlakyCustomers extends FakeCounterRepo {
  bool fail = true;
  @override
  Future<List<PosCustomer>> searchCustomers(String search) async {
    if (fail) throw Exception('offline');
    return super.searchCustomers(search);
  }
}
