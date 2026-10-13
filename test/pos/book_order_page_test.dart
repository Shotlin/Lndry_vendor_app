import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lndry_vendor_app/features/pos/booking/book_order_controller.dart';
import 'package:lndry_vendor_app/features/pos/booking/book_order_page.dart';
import 'package:lndry_vendor_app/features/pos/booking/garment_grid.dart';
import 'package:lndry_vendor_app/models/pos/pos_catalogue_model.dart';
import 'package:lndry_vendor_app/models/pos/pos_order_model.dart';

import 'pos_fakes.dart';
import 'pos_harness.dart';

Future<void> settleQuote(WidgetTester t) async {
  await t.pump(const Duration(milliseconds: 400));
  await t.pumpAndSettle();
}

/// The page is a lazily built scroll view: bring a widget on screen before looking for it.
Future<void> reveal(WidgetTester t, Finder f) async {
  await t.scrollUntilVisible(f, 250, scrollable: find.byType(Scrollable).first, maxScrolls: 40);
  await t.pumpAndSettle();
}

Finder stepperWithQty(int n) => find.byWidgetPredicate((w) => w is QtyStepper && w.qty == n);

Finder saveButton() => find.widgetWithText(FilledButton, 'Save Order');

void main() {
  testWidgets('empty cart: Save is off and says what to do', (t) async {
    await pumpPos(t, const BookOrderPage());
    expect(find.text('Book Order'), findsWidgets);
    expect(tester(t, saveButton()).onPressed, isNull);
    expect(find.text('Add at least one garment.'), findsOneWidget);
    await reveal(t, find.text('Tap a garment above to add it.'));
    expect(find.text('Tap a garment above to add it.'), findsOneWidget);
  });

  testWidgets('services, categories and only garments that have a price for the service', (t) async {
    await pumpPos(t, const BookOrderPage());
    expect(find.text('Dry Cleaning'), findsWidgets);
    expect(find.text('Wash & Fold'), findsOneWidget);
    expect(find.text('Shirt'), findsOneWidget);
    expect(find.text('Saree'), findsOneWidget);
    await t.tap(find.widgetWithText(ChoiceChip, 'Wash & Fold'));
    await t.pumpAndSettle();
    expect(find.text('Shirt'), findsOneWidget);
    expect(find.text('Saree'), findsNothing, reason: 'the saree has no Wash & Fold price');
    expect(find.text('₹30'), findsOneWidget);
  });

  testWidgets('category chip narrows the grid; search narrows it further; no match is explained', (t) async {
    await pumpPos(t, const BookOrderPage());
    await t.tap(find.widgetWithText(ChoiceChip, 'Women'));
    await t.pumpAndSettle();
    expect(find.text('Shirt'), findsNothing);
    expect(find.text('Saree'), findsOneWidget);
    await t.tap(find.widgetWithText(ChoiceChip, 'All'));
    await t.pumpAndSettle();
    await t.enterText(find.byType(TextField).first, 'sar');
    await t.pumpAndSettle();
    expect(find.text('Shirt'), findsNothing);
    expect(find.text('Saree'), findsOneWidget);
    await t.enterText(find.byType(TextField).first, 'zzz');
    await t.pumpAndSettle();
    expect(find.text('No garment matches "zzz".'), findsOneWidget);
  });

  testWidgets('tapping a garment adds it; the SERVER total is the only total shown', (t) async {
    final counter = FakeCounterRepo()
      ..onQuote = (r) async => const PosQuote(lines: [], subtotalPaise: 8000, chargesPaise: 0, discountsPaise: 800, taxPaise: 1296, taxRateBps: 1800, totalPaise: 8496);
    await pumpPos(t, const BookOrderPage(), counter: counter);
    await t.tap(find.text('Shirt'));
    await settleQuote(t);
    expect(counter.quoteRequests.length, 1);
    expect(counter.quoteRequests.single.toJson()['items'], [
      {'garmentId': 'g-shirt', 'serviceId': 's-dry', 'qty': 1}
    ]);
    // 8496 is not 8000 + anything the app could compute; it must be the server's number, in the bar and the bill.
    expect(find.text('₹84.96'), findsWidgets);
    await reveal(t, find.text('Selected Garments'));
    expect(find.text('Selected Garments'), findsOneWidget);
    await reveal(t, find.text('Tax (18%)'));
    expect(find.text('Tax (18%)'), findsOneWidget);
    expect(find.text('₹12.96'), findsOneWidget);
    expect(find.text('-₹8'), findsOneWidget);
  });

  testWidgets('+ and − change the quantity, − at 1 removes, the bin removes', (t) async {
    final counter = FakeCounterRepo();
    final pos = await pumpPos(t, const BookOrderPage(), counter: counter);
    await t.tap(find.text('Shirt'));
    await settleQuote(t);
    // the tile now shows a stepper, and the cart row has one too
    expect(stepperWithQty(1), findsWidgets);
    await t.tap(find.byTooltip('Add one Shirt').first);
    await settleQuote(t);
    expect(stepperWithQty(2), findsWidgets);
    expect(pos.c.read(bookOrderControllerProvider).qtyOf('g-shirt', 's-dry'), 2);
    expect(counter.quoteRequests.last.lines.single.qty, 2);
    await t.tap(find.byTooltip('Remove one Shirt').first);
    await settleQuote(t);
    expect(counter.quoteRequests.last.lines.single.qty, 1);
    await reveal(t, find.byTooltip('Remove Shirt'));
    await t.tap(find.byTooltip('Remove Shirt'));
    await settleQuote(t);
    await reveal(t, find.text('Tap a garment above to add it.'));
    expect(find.text('Tap a garment above to add it.'), findsOneWidget);
    expect(tester(t, saveButton()).onPressed, isNull);
  });

  testWidgets('the same garment in a second service is its own line', (t) async {
    final pos = await pumpPos(t, const BookOrderPage());
    await t.tap(find.text('Shirt'));
    await settleQuote(t);
    await t.tap(find.widgetWithText(ChoiceChip, 'Wash & Fold'));
    await t.pumpAndSettle();
    await t.tap(find.text('Shirt'));
    await settleQuote(t);
    final lines = pos.c.read(bookOrderControllerProvider).lines;
    expect(lines.map((l) => '${l.garmentId}/${l.serviceId}/${l.qty.toInt()}'), ['g-shirt/s-dry/1', 'g-shirt/s-wash/1']);
    await reveal(t, find.text('Selected Garments'));
    expect(find.byTooltip('Remove Shirt'), findsNWidgets(2));
  });

  testWidgets('payment: Cash, Online, Pay Later; no Wallet, even for a shop that has wallet access', (t) async {
    await pumpPos(t, const BookOrderPage(), info: shopInfo(wallet: true));
    await t.scrollUntilVisible(find.text('Pay Later'), 300, scrollable: find.byType(Scrollable).first);
    expect(find.text('Cash'), findsOneWidget);
    expect(find.text('Online'), findsOneWidget);
    expect(find.text('Pay Later'), findsOneWidget);
    expect(find.text('Wallet'), findsNothing);
    expect(find.text('No payment now. Collect it later.'), findsOneWidget);
    await t.tap(find.text('Cash'));
    await t.pumpAndSettle();
    expect(find.text('The full amount is received now.'), findsOneWidget);
  });

  testWidgets('a restored draft: customer and cart are back, Save works and books what is on screen', (t) async {
    final counter = FakeCounterRepo();
    await pumpPos(t, const BookOrderPage(), counter: counter, prefs: {draftKeyFor('v1'): draftWith(payment: 'CASH')});
    await settleQuote(t);
    expect(find.text('Asha Verma'), findsOneWidget);
    expect(find.text('9811122233'), findsOneWidget);
    expect(find.text('Your last unsaved order was restored.'), findsOneWidget);
    expect(tester(t, saveButton()).onPressed, isNotNull);

    await t.tap(find.widgetWithText(ChoiceChip, 'Wash & Fold')); // a different service must not disturb the cart
    await t.pumpAndSettle();
    await t.tap(find.widgetWithText(FilterChip, 'Home Delivery'));
    await t.tap(find.widgetWithText(FilterChip, 'Express'));
    await t.pumpAndSettle();

    await t.tap(saveButton());
    await t.pumpAndSettle();
    expect(counter.bookCalls.length, 1);
    final body = counter.bookCalls.single.request.toJson();
    expect(body['paymentMode'], 'CASH');
    expect(body['deliveryMode'], 'HOME_DELIVERY');
    expect(body['isExpress'], true);
    expect(body['customer'], {'id': 'u-1'});
    expect(counter.bookCalls.single.key, matches(RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$')), reason: 'the server requires a UUID v4');

    expect(find.text('Order saved'), findsOneWidget);
    expect(find.text('Order LND-261011-TEST for Asha Verma'), findsOneWidget);
    expect(find.text('₹80'), findsWidgets); // total = paid (cash), balance 0
    await t.tap(find.text('Book Another'));
    await t.pumpAndSettle();
    expect(find.text('Order saved'), findsNothing);
    expect(find.text('Choose customer'), findsWidgets);
    await reveal(t, find.text('Tap a garment above to add it.'));
    expect(find.text('Tap a garment above to add it.'), findsOneWidget);
  });

  testWidgets('View Order goes to the Orders tab', (t) async {
    await pumpPos(t, const BookOrderPage(), prefs: {draftKeyFor('v1'): draftWith()});
    await settleQuote(t);
    await t.tap(saveButton());
    await t.pumpAndSettle();
    await t.tap(find.text('View Order'));
    await t.pumpAndSettle();
    expect(find.text('ORDERS SCREEN'), findsOneWidget);
  });

  testWidgets('a failed save shows plain words, keeps the cart and can be retried', (t) async {
    final counter = FakeCounterRepo()..onBook = (r, k) async => throw Exception('socket');
    await pumpPos(t, const BookOrderPage(), counter: counter, prefs: {draftKeyFor('v1'): draftWith()});
    await settleQuote(t);
    await t.tap(saveButton());
    await t.pumpAndSettle();
    expect(find.text('Order saved'), findsNothing);
    expect(find.textContaining('Exception'), findsNothing);
    expect(find.text('Shirt'), findsWidgets);
    counter.onBook = null;
    await t.tap(saveButton());
    await t.pumpAndSettle();
    expect(find.text('Order saved'), findsOneWidget);
    expect(counter.bookCalls.map((c) => c.key).toSet().length, 1, reason: 'a retry of the same order reuses the same key');
  });

  testWidgets('a quote error is explained and Try again recovers', (t) async {
    final counter = FakeCounterRepo()..onQuote = (r) async => throw Exception('down');
    await pumpPos(t, const BookOrderPage(), counter: counter, prefs: {draftKeyFor('v1'): draftWith()});
    await settleQuote(t);
    await reveal(t, find.text('Try again'));
    expect(tester(t, saveButton()).onPressed, isNull);
    counter.onQuote = null;
    await t.tap(find.text('Try again'));
    await settleQuote(t);
    expect(tester(t, saveButton()).onPressed, isNotNull);
  });

  testWidgets('only a shop that has charge/discount/GST rules sees that section', (t) async {
    await pumpPos(t, const BookOrderPage());
    expect(find.text('Charges, discount & GST'), findsNothing);
  });

  testWidgets('GST choices appear when the shop has tax rules and are sent to the server as a rate', (t) async {
    final cat = FakeCatalogueRepo(catalogue: sampleCatalogue(tax: const [PosTaxRule(id: 't1', name: 'GST', rateBps: 1800)]));
    final counter = FakeCounterRepo();
    await pumpPos(t, const BookOrderPage(), catalogue: cat, counter: counter, prefs: {draftKeyFor('v1'): draftWith()});
    await settleQuote(t);
    await reveal(t, find.widgetWithText(ChoiceChip, 'GST (18%)'));
    await t.tap(find.widgetWithText(ChoiceChip, 'GST (18%)'));
    await settleQuote(t);
    expect(counter.quoteRequests.last.toJson()['taxRatePercent'], 18);
  });

  testWidgets('charges and discounts the shop saved can be picked', (t) async {
    final cat = FakeCatalogueRepo()
      ..charges = const [PosAdjustmentRule(id: 'c1', name: 'Express', isPercentage: true, percentageBps: 1000)]
      ..discounts = const [PosAdjustmentRule(id: 'd1', name: 'Festival', isPercentage: false, flatPaise: 500)];
    final counter = FakeCounterRepo();
    await pumpPos(t, const BookOrderPage(), catalogue: cat, counter: counter, prefs: {draftKeyFor('v1'): draftWith()});
    await settleQuote(t);
    await reveal(t, find.widgetWithText(FilterChip, 'Express (10%)'));
    await t.tap(find.widgetWithText(FilterChip, 'Express (10%)'));
    await settleQuote(t);
    await t.tap(find.widgetWithText(FilterChip, 'Festival (₹5)'));
    await settleQuote(t);
    final last = counter.quoteRequests.last.toJson();
    expect(last['chargeRuleIds'], ['c1']);
    expect(last['discountRuleIds'], ['d1']);
  });

  testWidgets('a draft garment whose price was removed is dropped with a notice', (t) async {
    final cat = FakeCatalogueRepo(catalogue: const PosCatalogue(services: [PosService(id: 's-dry', name: 'Dry Cleaning')], garments: [PosGarment(id: 'g-other', name: 'Coat')], prices: [PosPrice(id: 'p', garmentId: 'g-other', serviceId: 's-dry', ratePaise: 20000)]));
    await pumpPos(t, const BookOrderPage(), catalogue: cat, prefs: {draftKeyFor('v1'): draftWith()}, settle: false);
    await t.pump();
    await t.pump(const Duration(milliseconds: 50));
    expect(find.text('1 garments were removed because their price is no longer in your list.'), findsOneWidget);
    await t.pumpAndSettle(const Duration(seconds: 6));
    await reveal(t, find.text('Tap a garment above to add it.'));
    expect(find.text('Tap a garment above to add it.'), findsOneWidget);
  });

  testWidgets('Clear asks first, then empties the order', (t) async {
    final pos = await pumpPos(t, const BookOrderPage(), prefs: {draftKeyFor('v1'): draftWith()});
    await settleQuote(t);
    await t.tap(find.text('Clear'));
    await t.pumpAndSettle();
    expect(find.text('Clear this order?'), findsOneWidget);
    await t.tap(find.text('Cancel'));
    await t.pumpAndSettle();
    expect(find.text('Asha Verma'), findsOneWidget);
    await t.tap(find.text('Clear'));
    await t.pumpAndSettle();
    await t.tap(find.widgetWithText(FilledButton, 'Clear'));
    await t.pumpAndSettle();
    expect(find.text('Asha Verma'), findsNothing);
    expect(pos.storage.getString(draftKeyFor('v1')), isNull);
  });

  testWidgets('staff without catalogue rights: no "+" for prices and no "Change price"', (t) async {
    await pumpPos(t, const BookOrderPage(), canManage: false, prefs: {draftKeyFor('v1'): draftWith()});
    await settleQuote(t);
    expect(find.byTooltip('Add Garment Price'), findsNothing);
    await reveal(t, find.text('Selected Garments'));
    expect(find.text('Change price'), findsNothing);
  });

  testWidgets('the owner can change the price of a cart line', (t) async {
    await pumpPos(t, const BookOrderPage(), prefs: {draftKeyFor('v1'): draftWith()});
    await settleQuote(t);
    expect(find.byTooltip('Add Garment Price'), findsOneWidget);
    await reveal(t, find.text('Change price'));
    await t.tap(find.text('Change price'));
    await t.pumpAndSettle();
    expect(find.text('Current price ₹80'), findsOneWidget);
  });

  testWidgets('an empty price list explains itself', (t) async {
    await pumpPos(t, const BookOrderPage(), catalogue: FakeCatalogueRepo(catalogue: const PosCatalogue()));
    expect(find.textContaining('no services yet'), findsOneWidget);
  });

  testWidgets('the price list failing to load can be retried', (t) async {
    final cat = FakeCatalogueRepo()..loadError = Exception('x');
    await pumpPos(t, const BookOrderPage(), catalogue: cat);
    expect(find.textContaining('Could not load your price list'), findsOneWidget);
    cat.loadError = null;
    await t.tap(find.text('Try again'));
    await t.pumpAndSettle();
    expect(find.text('Shirt'), findsOneWidget);
  });

  testWidgets('Hindi', (t) async {
    await pumpPos(t, const BookOrderPage(), locale: const Locale('hi'));
    expect(find.text('ऑर्डर सेव करें'), findsOneWidget);
    expect(find.text('ग्राहक चुनें'), findsWidgets);
  });

  testWidgets('200% text on a 320 px phone: no overflow, Save still reachable', (t) async {
    await pumpPos(t, const BookOrderPage(), textScale: 2, size: const Size(320, 640), prefs: {draftKeyFor('v1'): draftWith()});
    await settleQuote(t);
    expect(t.takeException(), isNull);
    expect(saveButton(), findsOneWidget);
    await t.drag(find.byType(Scrollable).first, const Offset(0, -2000));
    await t.pumpAndSettle();
    expect(t.takeException(), isNull);
  });

  testWidgets('dark theme', (t) async {
    await pumpPos(t, const BookOrderPage(), prefs: {draftKeyFor('v1'): draftWith()});
    await settleQuote(t);
    expect(t.takeException(), isNull);
  });
}

FilledButton tester(WidgetTester t, Finder f) => t.widget<FilledButton>(f);
