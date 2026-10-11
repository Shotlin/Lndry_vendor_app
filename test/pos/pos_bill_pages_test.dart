import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lndry_vendor_app/features/pos/orders/bill_pages.dart';
import 'package:lndry_vendor_app/features/pos/orders/tag_pdf.dart';
import 'package:lndry_vendor_app/models/pos/pos_counter_order_model.dart';

import 'pos_fakes.dart';
import 'pos_harness.dart';

void main() {
  group('Invoice / Mini bill screen', () {
    testWidgets(
        'the A4 invoice is fetched from the server and handed to the viewer (share / print live there)',
        (t) async {
      final pos = await pumpPos(t, const BillPage(orderId: 'o-1', mini: false),
          orders: FakeOrdersRepo(
              orders: [makeOrder(status: 'DELIVERED', paid: 16000)]));
      expect(find.text('Invoice'), findsOneWidget);
      expect(find.text('PDF Invoice-o-1.pdf'), findsOneWidget);
      expect(pos.orders.pdfCalls, ['invoice:o-1']);
      expect(find.text('58 mm'), findsNothing,
          reason: 'paper size is for the mini bill only');
    });

    testWidgets(
        'the mini bill defaults to 80 mm and switches to 58 mm, fetching again',
        (t) async {
      final pos = await pumpPos(t, const BillPage(orderId: 'o-1', mini: true),
          orders: FakeOrdersRepo(orders: [makeOrder()]));
      expect(find.text('Mini bill'), findsOneWidget);
      expect(find.text('PDF Bill-o-1-80.pdf'), findsOneWidget);
      await t.tap(find.text('58 mm'));
      await t.pumpAndSettle();
      expect(find.text('PDF Bill-o-1-58.pdf'), findsOneWidget);
      expect(pos.orders.pdfCalls, ['mini:o-1:80', 'mini:o-1:58']);
      expect(
          t
              .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, '58 mm'))
              .selected,
          isTrue);
    });

    testWidgets('a refusal is shown in the server\'s own words with Try again',
        (t) async {
      final repo = FakeOrdersRepo(orders: [makeOrder()])
        ..pdfError = apiError('INVOICE_NOT_AVAILABLE',
            'The invoice is created when the order is delivered. Use the mini bill until then.');
      await pumpPos(t, const BillPage(orderId: 'o-1', mini: false),
          orders: repo);
      expect(
          find.textContaining('Could not prepare the bill.'), findsOneWidget);
      expect(find.textContaining('created when the order is delivered'),
          findsOneWidget);
      repo.pdfError = null;
      await t.tap(find.text('Try again'));
      await t.pumpAndSettle();
      expect(find.text('PDF Invoice-o-1.pdf'), findsOneWidget);
    });

    testWidgets('Hindi title', (t) async {
      await pumpPos(t, const BillPage(orderId: 'o-1', mini: true),
          orders: FakeOrdersRepo(orders: [makeOrder()]),
          locale: const Locale('hi'));
      expect(find.text('मिनी बिल'), findsOneWidget);
    });
  });

  group('Tags screen', () {
    FakeOrdersRepo repoWithTags() =>
        FakeOrdersRepo(orders: [makeOrder(number: 'LND-T-1')]);

    testWidgets('lists each garment with its tag code and state in words',
        (t) async {
      await pumpPos(t, const TagsPage(orderId: 'o-1'), orders: repoWithTags());
      expect(find.text('Garment tags'), findsOneWidget);
      expect(find.text('Shirt  #1'), findsOneWidget);
      expect(find.text('ELT-1-AAAA'), findsOneWidget);
      expect(find.text('ELT-1-BBBB'), findsOneWidget);
      expect(find.text('Received'), findsNWidgets(2));
      expect(find.text('Print or share tags'), findsOneWidget);
    });

    testWidgets(
        'Print or share tags: logs a print job, opens the tag PDF; printing marks the job printed',
        (t) async {
      final pos = await pumpPos(t, const TagsPage(orderId: 'o-1'),
          orders: repoWithTags());
      await t.tap(find.text('Print or share tags'));
      await t.pumpAndSettle();
      expect(find.text('PDF Tags-LND-T-1.pdf'), findsOneWidget);
      expect(find.text('Tags for order LND-T-1'), findsOneWidget);
      expect(pos.orders.printJobs, ['create:o-1:2']);
      await t.tap(find.text('SIMULATE PRINTED'));
      await t.pumpAndSettle();
      expect(pos.orders.printJobs, ['create:o-1:2', 'printed:job-1']);
    });

    testWidgets('if the print history cannot be written the tags still open',
        (t) async {
      final repo = _NoPrintLog(makeOrder(number: 'LND-T-1'));
      await pumpPos(t, const TagsPage(orderId: 'o-1'), orders: repo);
      await t.tap(find.text('Print or share tags'));
      await t.pumpAndSettle();
      expect(find.text('PDF Tags-LND-T-1.pdf'), findsOneWidget);
      expect(find.text('SIMULATE PRINTED'), findsNothing,
          reason: 'no job to mark');
    });

    testWidgets('an order with no tags says so and offers no print button',
        (t) async {
      final repo = repoWithTags();
      repo.details['o-1'] =
          makeDetail(makeOrder(number: 'LND-T-1'), units: const []);
      await pumpPos(t, const TagsPage(orderId: 'o-1'), orders: repo);
      expect(find.text('This order has no tags.'), findsOneWidget);
      expect(find.text('Print or share tags'), findsNothing);
    });

    testWidgets('a load error has a way back', (t) async {
      final repo = repoWithTags()
        ..detailError = apiError('X', 'busy', status: 500);
      await pumpPos(t, const TagsPage(orderId: 'o-1'), orders: repo);
      expect(find.textContaining('Could not load this order.'), findsOneWidget);
      repo.detailError = null;
      await t.tap(find.text('Try again'));
      await t.pumpAndSettle();
      expect(find.text('ELT-1-AAAA'), findsOneWidget);
    });
  });

  group('tag label PDF', () {
    const items = [
      CounterOrderItem(
          name: 'Shirt',
          serviceName: 'Dry Cleaning',
          unit: 'piece',
          qty: 2,
          ratePaise: 8000,
          amountPaise: 16000)
    ];

    /// The page count the document declares (`/Type/Pages … /Count N`).
    int pages(List<int> pdf) => int.parse(
        RegExp(r'/Count (\d+)').firstMatch(latin1.decode(pdf))!.group(1)!);

    test('one page per garment, a real PDF', () async {
      final bytes = await buildTagsPdf(
        orderNumber: 'LND-T-1',
        shopName: 'Sparkle',
        items: items,
        units: const [
          GarmentUnit(
              id: 'u1',
              tagCode: 'ELT-1-AAAA',
              sequence: 1,
              itemIndex: 0,
              state: 'INTAKE',
              garmentName: 'Shirt'),
          GarmentUnit(
              id: 'u2',
              tagCode: 'ELT-1-BBBB',
              sequence: 2,
              itemIndex: 0,
              state: 'INTAKE',
              garmentName: 'Shirt'),
          GarmentUnit(
              id: 'u3',
              tagCode: 'ELT-1-CCCC',
              sequence: 1,
              itemIndex: 1,
              state: 'INTAKE',
              garmentName: 'Saree'),
        ],
      );
      expect(latin1.decode(bytes.sublist(0, 5)), '%PDF-');
      expect(pages(bytes), 3);
    });

    test('garment names in other scripts do not break the label', () async {
      final bytes = await buildTagsPdf(
        orderNumber: 'LND-T-1',
        shopName: 'चमक लॉन्ड्री',
        items: items,
        units: const [
          GarmentUnit(
              id: 'u1',
              tagCode: 'ELT-1-AAAA',
              sequence: 1,
              itemIndex: 0,
              state: 'INTAKE',
              garmentName: 'कमीज़ Shirt')
        ],
      );
      expect(pages(bytes), 1);
    });

    test(
        'an order with no tags is an empty-page-free document the screen never asks for',
        () async {
      // The screen offers no button without tags; the builder must still not crash.
      final bytes = await buildTagsPdf(
          orderNumber: 'X', shopName: '', items: const [], units: const []);
      expect(bytes, isNotEmpty);
    });
  });
}

class _NoPrintLog extends FakeOrdersRepo {
  _NoPrintLog(CounterOrder o) : super(orders: [o]);
  @override
  Future<String?> createTagPrintJob(
          String orderId, List<String> garmentUnitIds) async =>
      throw apiError('X', 'down', status: 500);
}
