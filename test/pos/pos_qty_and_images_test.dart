import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lndry_vendor_app/features/pos/booking/garment_grid.dart';
import 'package:lndry_vendor_app/features/pos/core/pos_image.dart';
import 'package:lndry_vendor_app/features/pos/core/qty.dart';
import 'package:lndry_vendor_app/l10n/generated/app_localizations.dart';
import 'package:lndry_vendor_app/models/pos/pos_catalogue_model.dart';
import 'package:lndry_vendor_app/models/pos/pos_order_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'book_order_controller_test.dart' show make, pause;

// 1x1 transparent PNG
const _png = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==';

Widget _app(Widget child) => MaterialApp(
      localizationsDelegates: const [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: Center(child: child)),
    );

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('quantity text', () {
    test('whole numbers have no decimals, fractions keep at most two', () {
      expect(fmtQty(2), '2');
      expect(fmtQty(2.0), '2');
      expect(fmtQty(0.6), '0.6');
      expect(fmtQty(1.2), '1.2');
      expect(fmtQty(1.25), '1.25');
      expect(fmtQty(1.256), '1.26');
      expect(fmtQty(0.1 + 0.2), '0.3');
    });
    test('typed amounts: comma or dot, 0.1 to 9999 only', () {
      expect(parseQty('0.6'), 0.6);
      expect(parseQty(' 1,2 '), 1.2);
      expect(parseQty('1.256'), 1.26);
      expect(parseQty('0'), isNull);
      expect(parseQty('0.05'), isNull);
      expect(parseQty('10000'), isNull);
      expect(parseQty('abc'), isNull);
      expect(parseQty(''), isNull);
    });
    test('a cart line keeps decimals through JSON', () {
      final l = CartLine.fromJson({'garmentId': 'g', 'serviceId': 's', 'qty': 1.2});
      expect(l.qty, 1.2);
      expect(l.toJson()['qty'], 1.2);
      expect(CartLine.fromJson({'garmentId': 'g', 'serviceId': 's', 'qty': 3}).qty, 3);
    });
  });

  group('controller with fractional quantities', () {
    test('0.6 kg and 1.2 kg are sent to the server as typed', () async {
      final t = await make();
      t.c.selectService('s-dry');
      t.c.setQty('g-shirt', 's-dry', 0.6);
      await pause(80);
      expect(t.repo.quoteRequests.last.lines.single.qty, 0.6);
      t.c.setQty('g-shirt', 's-dry', 1.2);
      await pause(80);
      expect(t.repo.quoteRequests.last.lines.single.qty, 1.2);
      expect(t.c.state.totalQty, 1.2);
    });
    test('quantities are kept to two decimals, capped, and zero or junk removes the line', () async {
      final t = await make();
      t.c.selectService('s-dry');
      t.c.setQty('g-shirt', 's-dry', 1.256);
      expect(t.c.state.qtyOf('g-shirt', 's-dry'), 1.26);
      t.c.setQty('g-shirt', 's-dry', 50000);
      expect(t.c.state.qtyOf('g-shirt', 's-dry'), 9999);
      t.c.setQty('g-shirt', 's-dry', double.nan);
      expect(t.c.state.lines, isEmpty);
      t.c.setQty('g-shirt', 's-dry', 2);
      t.c.setQty('g-shirt', 's-dry', 0);
      expect(t.c.state.lines, isEmpty);
    });
  });

  group('QtyStepper', () {
    testWidgets('a piece item goes up and down by one and has no typing box', (t) async {
      final seen = <double>[];
      await t.pumpWidget(_app(QtyStepper(qty: 2, name: 'Shirt', onChanged: seen.add)));
      await t.tap(find.byTooltip('Add one Shirt'));
      await t.tap(find.byTooltip('Remove one Shirt'));
      expect(seen, [3, 1]);
      await t.tap(find.text('2'));
      await t.pump();
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('a kg item goes by half a kilo and removes below the smallest amount', (t) async {
      final seen = <double>[];
      await t.pumpWidget(_app(QtyStepper(qty: 1, name: 'Wash & Fold', decimal: true, unitLabel: 'kg', onChanged: seen.add)));
      await t.tap(find.byTooltip('Add one Wash & Fold'));
      await t.tap(find.byTooltip('Remove one Wash & Fold'));
      expect(seen, [1.5, 0.5]);
      seen.clear();
      await t.pumpWidget(_app(QtyStepper(qty: 0.5, name: 'Wash & Fold', decimal: true, unitLabel: 'kg', onChanged: seen.add)));
      await t.tap(find.byTooltip('Remove one Wash & Fold'));
      expect(seen, [0]);
      seen.clear();
      await t.pumpWidget(_app(QtyStepper(qty: 0.6, name: 'Wash & Fold', decimal: true, unitLabel: 'kg', onChanged: seen.add)));
      await t.tap(find.byTooltip('Remove one Wash & Fold'));
      expect(seen, [0.1]);
    });

    testWidgets('tapping the number of a kg item opens a box to type 0.6 or 1.2', (t) async {
      final seen = <double>[];
      await t.pumpWidget(_app(QtyStepper(qty: 1, name: 'Wash & Fold', decimal: true, unitLabel: 'kg', onChanged: seen.add)));
      await t.tap(find.text('1'));
      await t.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      await t.enterText(find.byType(TextField), '0.6');
      await t.tap(find.widgetWithText(FilledButton, 'Set'));
      await t.pumpAndSettle();
      expect(seen, [0.6]);

      await t.tap(find.text('1'));
      await t.pumpAndSettle();
      await t.enterText(find.byType(TextField), '1,2');
      await t.tap(find.widgetWithText(FilledButton, 'Set'));
      await t.pumpAndSettle();
      expect(seen, [0.6, 1.2]);
    });

    testWidgets('an unusable amount is refused with a message and nothing changes', (t) async {
      final seen = <double>[];
      await t.pumpWidget(_app(QtyStepper(qty: 1, name: 'Carpet', decimal: true, unitLabel: 'sq ft', onChanged: seen.add)));
      await t.tap(find.text('1'));
      await t.pumpAndSettle();
      await t.enterText(find.byType(TextField), '0');
      await t.tap(find.widgetWithText(FilledButton, 'Set'));
      await t.pumpAndSettle();
      expect(find.text('Enter an amount from 0.1 to 9999'), findsOneWidget);
      expect(seen, isEmpty);
      await t.tap(find.text('Cancel'));
      await t.pumpAndSettle();
      expect(seen, isEmpty);
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('the spoken label carries the amount and unit', (t) async {
      final handle = t.ensureSemantics();
      await t.pumpWidget(_app(QtyStepper(qty: 1.2, name: 'Wash & Fold', decimal: true, unitLabel: 'kg', onChanged: (_) {})));
      expect(t.getSemantics(find.byType(QtyStepper)).label, contains('Wash & Fold, quantity 1.2 kg'));
      handle.dispose();
    });
  });

  group('pictures', () {
    test('the catalogue reads image links and falls back to the category picture', () {
      final cat = PosCatalogue.fromJson({
        'categories': [
          {'id': 'c1', 'name': 'Laundry Service', 'imageUrl': 'https://img.test/c1.webp'},
          {'id': 'c2', 'name': 'Accessories', 'imageUrl': ''},
        ],
        'garments': [
          {'id': 'g1', 'name': 'Wash & Fold', 'categoryId': 'c1', 'unit': 'kg', 'imageUrl': 'https://img.test/g1.webp'},
          {'id': 'g2', 'name': 'Steam Iron', 'categoryId': 'c1', 'unit': 'piece'},
          {'id': 'g3', 'name': 'Office Bag', 'categoryId': 'c2', 'unit': 'piece'},
        ],
      });
      expect(cat.imageOf(cat.garment('g1')!), 'https://img.test/g1.webp'); // its own picture first
      expect(cat.imageOf(cat.garment('g2')!), 'https://img.test/c1.webp'); // else its category's
      expect(cat.imageOf(cat.garment('g3')!), isNull); // an empty link is "no picture"
      expect(cat.garment('g1')!.isCountable, isFalse);
    });

    testWidgets('a shop-uploaded picture (data link) is drawn', (t) async {
      await t.pumpWidget(_app(const PosImage(url: 'data:image/png;base64,$_png', name: 'Shirt')));
      expect(find.byType(Image), findsOneWidget);
      expect(find.text('S'), findsNothing);
    });

    testWidgets('no picture, a desktop asset path or a damaged picture shows the first letter, never an error', (t) async {
      await t.pumpWidget(_app(const Column(children: [
        PosImage(url: null, name: 'Shirt'),
        PosImage(url: '/assets/visuals/shirt.png', name: 'Trouser'),
        PosImage(url: 'data:image/png;base64,@@@', name: 'Kurta'),
      ])));
      expect(find.text('S'), findsOneWidget);
      expect(find.text('T'), findsOneWidget);
      expect(find.text('K'), findsOneWidget);
      expect(find.byType(Image), findsNothing);
    });

    testWidgets('an item tile shows the picture and a kg item shows its decimal stepper', (t) async {
      await t.pumpWidget(_app(SizedBox(
        width: 190,
        height: 156,
        child: GarmentTile(
          garment: const PosGarment(id: 'g1', name: 'Wash & Fold', unit: 'kg'),
          ratePaise: 8000,
          qty: 1.5,
          imageUrl: 'data:image/png;base64,$_png',
          onSetQty: (_) {},
        ),
      )));
      expect(find.byType(Image), findsOneWidget);
      expect(find.text('Wash & Fold'), findsOneWidget);
      expect(find.text('1.5'), findsOneWidget);
    });
  });
}
