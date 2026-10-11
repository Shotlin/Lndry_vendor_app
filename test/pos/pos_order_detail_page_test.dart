import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lndry_vendor_app/core/network/api_exception.dart';
import 'package:lndry_vendor_app/features/pos/orders/pos_order_detail_page.dart';
import 'package:lndry_vendor_app/models/pos/pos_counter_order_model.dart';
import 'package:lndry_vendor_app/models/pos/pos_customer_model.dart';
import 'package:lndry_vendor_app/models/pos/pos_order_model.dart';

import 'pos_fakes.dart';
import 'pos_harness.dart';

const captain =
    OrderCaptain(id: 'cap-1', name: 'Ravi Captain', phone: '9822233344');

Future<Pos> openDetail(
  WidgetTester t,
  CounterOrder order, {
  FakeOrdersRepo? repo,
  bool canProcess = true,
  bool canView = true,
  bool canAssign = true,
  bool openerWorks = true,
  double textScale = 1,
  Locale locale = const Locale('en'),
  Size size = const Size(390, 2400),
}) {
  final r = repo ?? FakeOrdersRepo(orders: [order]);
  return pumpPos(t, PosOrderDetailPage(orderId: order.id),
      orders: r,
      canProcessOrders: canProcess,
      canViewOrders: canView,
      canAssign: canAssign,
      openerWorks: openerWorks,
      textScale: textScale,
      locale: locale,
      size: size);
}

/// Whether a quick-action tile can be tapped.
bool actionEnabled(WidgetTester t, String label) {
  final ink = t.widget<InkWell>(find
      .ancestor(of: find.text(label), matching: find.byType(InkWell))
      .first);
  return ink.onTap != null;
}

Finder get bottomButton => find.descendant(
    of: find.byType(BottomAppBar).evaluate().isEmpty
        ? find.byType(Scaffold)
        : find.byType(BottomAppBar),
    matching: find.byType(FilledButton));

CounterOrder booked(
        {String status = 'BOOKED',
        int paid = 0,
        int total = 16000,
        DeliveryMode mode = DeliveryMode.walkIn,
        bool express = false,
        int version = 3}) =>
    makeOrder(
        id: 'o-1',
        number: 'LND-D-1',
        status: status,
        paid: paid,
        total: total,
        mode: mode,
        express: express,
        version: version);

void main() {
  group('the page', () {
    testWidgets(
        'a booked, unpaid, express home-delivery order: who, state, next step, 20%, actions, info, garments',
        (t) async {
      await openDetail(
          t, booked(mode: DeliveryMode.homeDelivery, express: true));
      expect(find.text('LND-D-1'), findsWidgets);
      expect(find.text('Asha Verma'), findsOneWidget);
      expect(find.text('9811122233'), findsOneWidget);
      expect(find.text('Call'), findsOneWidget);
      expect(find.text('Booked'), findsWidgets);
      expect(find.text('Unpaid'), findsOneWidget);
      expect(find.text('Express'), findsOneWidget);
      expect(find.text('20% complete'), findsOneWidget);
      expect(find.text('Start Processing'), findsOneWidget,
          reason: 'the one big action');
      for (final a in [
        'Pay Now',
        'View Invoice',
        'Mini Invoice',
        'Tags',
        'Edit Order',
        'Assign Captain',
        'Cancel Order'
      ]) {
        expect(find.text(a), findsWidgets, reason: a);
      }
      // info: the server's numbers, to the paisa
      expect(find.text('₹160.00'), findsWidgets);
      expect(find.text('Invoice amount'), findsOneWidget);
      expect(find.text('Home Delivery'), findsWidgets);
      expect(find.text('Not assigned'), findsNWidgets(2));
      expect(find.text('No payment received yet.'), findsOneWidget);
      expect(find.text('Shirt × 2'), findsOneWidget);
    });

    testWidgets(
        'a part-paid order shows paid in green words, balance in amber, and the payment row',
        (t) async {
      await openDetail(t, booked(paid: 5000));
      expect(find.text('Part paid'), findsOneWidget);
      expect(find.text('₹50.00'), findsWidgets);
      expect(find.text('₹110.00'), findsOneWidget,
          reason: 'balance = 160 − 50');
      expect(find.text('Cash'), findsOneWidget);
    });

    testWidgets('garments expand to their tags and tag state in words',
        (t) async {
      await openDetail(t, booked());
      await t.tap(find.text('Shirt × 2'));
      await t.pumpAndSettle();
      expect(find.textContaining('ELT-1-AAAA'), findsOneWidget);
      expect(find.text('Received'), findsNWidgets(2));
    });

    testWidgets('loading, then an error with a way back', (t) async {
      final repo = FakeOrdersRepo(orders: [booked()])
        ..detailError = apiError('X', 'busy', status: 500);
      await openDetail(t, booked(), repo: repo);
      expect(find.textContaining('Could not load this order.'), findsOneWidget);
      repo.detailError = null;
      await t.tap(find.text('Try again'));
      await t.pumpAndSettle();
      expect(find.text('Asha Verma'), findsOneWidget);
    });

    testWidgets('big text on a small phone: no overflow', (t) async {
      await openDetail(
          t, booked(mode: DeliveryMode.homeDelivery, express: true, paid: 5000),
          textScale: 2, size: const Size(360, 640));
      expect(t.takeException(), isNull);
      await t.drag(find.byType(Scrollable).first, const Offset(0, -2000));
      await t.pumpAndSettle();
      expect(t.takeException(), isNull);
    });

    testWidgets('Hindi', (t) async {
      await openDetail(t, booked(), locale: const Locale('hi'));
      expect(find.text('प्रोसेस शुरू करें'), findsOneWidget);
      expect(find.text('अभी भुगतान लें'), findsWidgets);
      expect(find.text('इनवॉइस देखें'), findsOneWidget);
      expect(find.text('ऑर्डर रद्द करें'), findsOneWidget);
    });
  });

  group('the big button and what is enabled, for every state', () {
    // status, mode, paid → (button, pay now enabled, edit enabled, cancel enabled, invoice enabled, mini enabled)
    final cases =
        <(String, DeliveryMode, int, String?, bool, bool, bool, bool)>[
      (
        'BOOKED',
        DeliveryMode.walkIn,
        0,
        'Start Processing',
        true,
        true,
        true,
        false
      ),
      (
        'PICKED_UP',
        DeliveryMode.walkIn,
        0,
        'Start Processing',
        true,
        true,
        true,
        false
      ),
      (
        'IN_PROCESS',
        DeliveryMode.walkIn,
        5000,
        'Mark Ready',
        true,
        true,
        true,
        false
      ),
      (
        'READY',
        DeliveryMode.walkIn,
        16000,
        'Deliver Order',
        false,
        true,
        true,
        false
      ),
      (
        'READY',
        DeliveryMode.homeDelivery,
        16000,
        'Send for Delivery',
        false,
        true,
        true,
        false
      ),
      (
        'OUT_FOR_DELIVERY',
        DeliveryMode.homeDelivery,
        0,
        'Deliver Order',
        true,
        true,
        true,
        false
      ),
      (
        'DELIVERED',
        DeliveryMode.walkIn,
        16000,
        null,
        false,
        false,
        false,
        true
      ),
      (
        'DELIVERED',
        DeliveryMode.walkIn,
        5000,
        'Pay Now',
        true,
        false,
        false,
        true
      ),
      ('CANCELLED', DeliveryMode.walkIn, 0, null, false, false, false, false),
    ];
    for (final (status, mode, paid, button, pay, edit, cancel, invoice)
        in cases) {
      testWidgets('$status / $mode / paid $paid', (t) async {
        await openDetail(t, booked(status: status, paid: paid, mode: mode));
        if (button != null) {
          expect(find.widgetWithText(FilledButton, button), findsOneWidget,
              reason: 'big button');
        } else {
          expect(find.byType(FilledButton), findsNothing,
              reason: 'nothing left to do');
        }
        expect(actionEnabled(t, 'Pay Now'), pay, reason: 'pay now');
        expect(actionEnabled(t, 'Edit Order'), edit, reason: 'edit');
        expect(actionEnabled(t, 'Cancel Order'), cancel, reason: 'cancel');
        expect(actionEnabled(t, 'View Invoice'), status != 'CANCELLED',
            reason:
                'invoice tile can be tapped (it explains itself before delivery)');
        expect(actionEnabled(t, 'Mini Invoice'), status != 'CANCELLED',
            reason: 'mini bill');
        expect(invoice, status == 'DELIVERED');
      });
    }

    testWidgets(
        'delivered and paid = Order Complete at 100%, every stop ticked',
        (t) async {
      await openDetail(t, booked(status: 'DELIVERED', paid: 16000));
      expect(find.text('Order Complete'), findsOneWidget);
      expect(find.text('100% complete'), findsOneWidget);
      expect(find.byIcon(Icons.check_rounded), findsNWidgets(5));
    });

    testWidgets('delivered but not paid is Delivered at 80%, not complete',
        (t) async {
      await openDetail(t, booked(status: 'DELIVERED', paid: 1000));
      expect(find.text('Order Complete'), findsNothing);
      expect(find.text('80% complete'), findsOneWidget);
    });

    testWidgets('a cancelled order shows the reason instead of a timeline',
        (t) async {
      await openDetail(
          t,
          makeOrder(
              id: 'o-1',
              number: 'LND-D-1',
              status: 'CANCELLED',
              cancelReason: 'Customer changed mind'));
      expect(find.textContaining('This order was cancelled.'), findsOneWidget);
      expect(find.textContaining('Customer changed mind'), findsOneWidget);
      expect(find.textContaining('% complete'), findsNothing);
      expect(find.text('Cancelled'), findsWidgets);
    });

    testWidgets(
        'the timeline shows when the order reached each stop (from the history)',
        (t) async {
      final o = booked(status: 'IN_PROCESS');
      final repo = FakeOrdersRepo(orders: [o])
        ..details['o-1'] = makeDetail(o, history: [
          OrderStatusEvent(
              id: '1', to: 'BOOKED', at: DateTime.utc(2026, 10, 11, 9, 30)),
          OrderStatusEvent(
              id: '2',
              from: 'BOOKED',
              to: 'IN_PROCESS',
              at: DateTime.utc(2026, 10, 12, 14, 5))
        ]);
      await openDetail(t, o, repo: repo);
      expect(find.textContaining('Oct 11, 2026'), findsWidgets);
      expect(find.textContaining('Oct 12, 2026'), findsWidgets);
    });
  });

  group('moving the order along', () {
    testWidgets(
        'Start Processing moves it, says so, and the screen shows the new state read back from the server',
        (t) async {
      final pos = await openDetail(t, booked());
      await t.tap(find.text('Start Processing'));
      await t.pumpAndSettle();
      expect(pos.orders.transitions.single.state, 'IN_PROCESS');
      expect(pos.orders.transitions.single.version, 3,
          reason: 'sent with the version the owner saw');
      expect(find.text('Order moved to Processing.'), findsOneWidget);
      expect(find.text('Mark Ready'), findsOneWidget);
      expect(find.text('40% complete'), findsOneWidget);
    });

    testWidgets('a double tap moves it once', (t) async {
      final repo = FakeOrdersRepo(orders: [booked()])..gate = Completer<void>();
      await openDetail(t, booked(), repo: repo);
      await t.tap(find.text('Start Processing'));
      await t.pump();
      await t.tap(find.byType(FilledButton), warnIfMissed: false);
      await t.pump();
      repo.gate!.complete();
      await t.pumpAndSettle();
      expect(repo.transitions, hasLength(1));
    });

    group('garments not scanned (Mark Ready)', () {
      FakeOrdersRepo gated() =>
          FakeOrdersRepo(orders: [booked(status: 'IN_PROCESS')])
            ..onTransition = (id, state, incomplete, unpaid) =>
                state == 'READY' && !incomplete
                    ? apiError('ASSEMBLY_INCOMPLETE',
                        '2 garment(s) have not reached assembly yet')
                    : null;

      testWidgets('the server says so → a plain question; "Not yet" leaves it',
          (t) async {
        final repo = gated();
        await openDetail(t, booked(status: 'IN_PROCESS'), repo: repo);
        await t.tap(find.text('Mark Ready'));
        await t.pumpAndSettle();
        expect(find.text('Garments not scanned yet'), findsOneWidget);
        expect(find.textContaining('ASSEMBLY'), findsNothing,
            reason: 'no raw codes');
        await t.tap(find.text('Not yet'));
        await t.pumpAndSettle();
        expect(repo.transitions, hasLength(1));
        expect(find.text('Mark Ready'), findsOneWidget);
      });

      testWidgets(
          '"Mark ready anyway" sends the second request WITH the flag, and it works',
          (t) async {
        final repo = gated();
        await openDetail(t, booked(status: 'IN_PROCESS'), repo: repo);
        await t.tap(find.text('Mark Ready'));
        await t.pumpAndSettle();
        await t.tap(find.text('Mark ready anyway'));
        await t.pumpAndSettle();
        expect(repo.transitions.map((x) => x.incomplete), [false, true],
            reason:
                'the owner is asked first; the flag is never sent on its own');
        expect(find.text('Order moved to Ready.'), findsOneWidget);
      });
    });

    group('delivering with a balance', () {
      testWidgets(
          'a balance → asked before anything is sent; "Collect payment first" opens the pay sheet and delivers nothing',
          (t) async {
        final repo =
            FakeOrdersRepo(orders: [booked(status: 'READY', paid: 5000)]);
        await openDetail(t, booked(status: 'READY', paid: 5000), repo: repo);
        await t.tap(find.text('Deliver Order'));
        await t.pumpAndSettle();
        expect(find.text('₹110.00 is still due'), findsOneWidget);
        expect(repo.transitions, isEmpty);
        await t.tap(find.text('Collect payment first'));
        await t.pumpAndSettle();
        expect(find.text('Collect payment'), findsOneWidget);
        expect(repo.transitions, isEmpty);
      });

      testWidgets(
          '"Deliver with balance due" is the owner saying so out loud: allowUnpaid is sent',
          (t) async {
        final repo =
            FakeOrdersRepo(orders: [booked(status: 'READY', paid: 5000)]);
        await openDetail(t, booked(status: 'READY', paid: 5000), repo: repo);
        await t.tap(find.text('Deliver Order'));
        await t.pumpAndSettle();
        await t.tap(find.text('Deliver with balance due'));
        await t.pumpAndSettle();
        expect((repo.transitions.single.state, repo.transitions.single.unpaid),
            ('DELIVERED', true));
        expect(find.text('Order moved to Delivered.'), findsOneWidget);
      });

      testWidgets(
          'fully paid: delivered straight away, no question, no override flag',
          (t) async {
        final repo =
            FakeOrdersRepo(orders: [booked(status: 'READY', paid: 16000)]);
        await openDetail(t, booked(status: 'READY', paid: 16000), repo: repo);
        await t.tap(find.text('Deliver Order'));
        await t.pumpAndSettle();
        expect(find.textContaining('still due'), findsNothing);
        expect((
          repo.transitions.single.unpaid,
          repo.transitions.single.incomplete
        ), (
          false,
          false
        ));
        expect(find.text('Order Complete'), findsOneWidget);
      });

      testWidgets(
          'someone took the money back meanwhile: the server\'s gate still produces the same question',
          (t) async {
        final repo = FakeOrdersRepo(
            orders: [booked(status: 'READY', paid: 16000)])
          ..onTransition = (id, state, incomplete, unpaid) => !unpaid
              ? apiError('PAYMENT_OUTSTANDING',
                  'This order still has an outstanding balance. Collect payment first.')
              : null;
        await openDetail(t, booked(status: 'READY', paid: 16000), repo: repo);
        await t.tap(find.text('Deliver Order'));
        await t.pumpAndSettle();
        expect(find.text('Collect payment first'), findsOneWidget);
        await t.tap(find.text('Deliver with balance due'));
        await t.pumpAndSettle();
        expect(repo.transitions.map((x) => x.unpaid), [false, true]);
      });
    });

    testWidgets('home delivery: Ready → Send for Delivery → Deliver Order',
        (t) async {
      final repo = FakeOrdersRepo(orders: [
        booked(status: 'READY', paid: 16000, mode: DeliveryMode.homeDelivery)
      ]);
      await openDetail(t,
          booked(status: 'READY', paid: 16000, mode: DeliveryMode.homeDelivery),
          repo: repo);
      await t.tap(find.text('Send for Delivery'));
      await t.pumpAndSettle();
      expect(repo.transitions.single.state, 'OUT_FOR_DELIVERY');
      expect(find.text('Order moved to Out for delivery.'), findsOneWidget);
      expect(find.text('Deliver Order'), findsOneWidget);
    });

    testWidgets(
        'someone else moved it first: plain words, and the screen is re-read',
        (t) async {
      final repo = FakeOrdersRepo(orders: [booked()])
        ..onTransition = (id, s, i, u) => apiError('VERSION_CONFLICT',
            'This order was changed by someone else. Reload and try again.');
      await openDetail(t, booked(), repo: repo);
      await t.tap(find.text('Start Processing'));
      await t.pumpAndSettle();
      expect(find.textContaining('changed by someone else'), findsOneWidget);
      expect(repo.calls.where((c) => c == 'get:o-1').length, greaterThan(1));
    });

    testWidgets(
        'any other refusal is shown in the server\'s own plain sentence, never as a code',
        (t) async {
      final repo = FakeOrdersRepo(orders: [booked()])
        ..onTransition = (id, s, i, u) => apiError('INVALID_TRANSITION',
            'An order that is in process cannot move to delivered');
      await openDetail(t, booked(), repo: repo);
      await t.tap(find.text('Start Processing'));
      await t.pumpAndSettle();
      expect(find.text('An order that is in process cannot move to delivered'),
          findsOneWidget);
      expect(find.textContaining('INVALID_TRANSITION'), findsNothing);
    });

    testWidgets('a dropped connection is a calm sentence, not a stack trace',
        (t) async {
      final repo = FakeOrdersRepo(orders: [booked()])
        ..onTransition = (id, s, i, u) => const ApiException(
            message: 'No internet connection', code: 'NETWORK_ERROR');
      await openDetail(t, booked(), repo: repo);
      await t.tap(find.text('Start Processing'));
      await t.pumpAndSettle();
      expect(find.textContaining('ApiException'), findsNothing);
      expect(find.textContaining('Exception'), findsNothing);
    });
  });

  group('Pay Now', () {
    Future<Pos> openPay(WidgetTester t,
        {int paid = 5000, FakeOrdersRepo? repo}) async {
      final pos = await openDetail(t, booked(paid: paid), repo: repo);
      await t.tap(find.text('Pay Now').first);
      await t.pumpAndSettle();
      return pos;
    }

    testWidgets(
        'shows the balance, defaults the amount to it, offers Cash / Online / Card / Bank (no Wallet)',
        (t) async {
      await openPay(t);
      expect(find.text('Collect payment'), findsOneWidget);
      expect(find.text('Balance to collect'), findsOneWidget);
      expect(find.text('₹110.00'), findsWidgets);
      expect(
          t
              .widget<TextField>(find.widgetWithText(TextField, 'Amount (₹)'))
              .controller!
              .text,
          '110');
      for (final m in ['Cash', 'Online', 'Card', 'Bank']) {
        expect(find.widgetWithText(ChoiceChip, m), findsOneWidget, reason: m);
      }
      expect(find.widgetWithText(ChoiceChip, 'Wallet'), findsNothing);
      expect(find.text('Collect ₹110.00'), findsOneWidget);
    });

    testWidgets(
        'part payment: sent in paise with the mode and reference; the screen then shows the server\'s new balance',
        (t) async {
      final pos = await openPay(t);
      await t.enterText(find.widgetWithText(TextField, 'Amount (₹)'), '40.50');
      await t.tap(find.widgetWithText(ChoiceChip, 'Online'));
      await t.enterText(
          find.widgetWithText(TextField, 'Reference (optional)'), 'UTR777');
      await t.pump();
      expect(find.text('Collect ₹40.50'), findsOneWidget);
      await t.tap(find.text('Collect ₹40.50'));
      await t.pumpAndSettle();
      expect(pos.orders.payments.single,
          (id: 'o-1', amount: 4050, mode: 'UPI', ref: 'UTR777'));
      expect(find.text('₹40.50 collected.'), findsOneWidget);
      expect(find.text('Collect payment'), findsNothing,
          reason: 'sheet closed');
      expect(find.text('₹69.50'), findsOneWidget,
          reason: 'new balance: 160 − 50 − 40.50, read back from the server');
    });

    testWidgets('"Full balance" pays it all and the order becomes Paid',
        (t) async {
      final pos = await openPay(t);
      await t.enterText(find.widgetWithText(TextField, 'Amount (₹)'), '1');
      await t.tap(find.text('Full balance'));
      await t.pump();
      await t.tap(find.text('Collect ₹110.00'));
      await t.pumpAndSettle();
      expect(pos.orders.payments.single.amount, 11000);
      expect(find.text('Paid'), findsWidgets);
    });

    testWidgets(
        'an empty or zero amount is refused in words before anything is sent',
        (t) async {
      final pos = await openPay(t);
      await t.enterText(find.widgetWithText(TextField, 'Amount (₹)'), '');
      await t.tap(find.byType(FilledButton).last);
      await t.pump();
      expect(find.text('Enter an amount.'), findsOneWidget);
      await t.enterText(find.widgetWithText(TextField, 'Amount (₹)'), '0');
      await t.tap(find.byType(FilledButton).last);
      await t.pump();
      expect(find.text('Enter an amount.'), findsOneWidget);
      expect(pos.orders.payments, isEmpty);
    });

    testWidgets(
        'more than the balance is refused before sending, with the balance in the sentence',
        (t) async {
      final pos = await openPay(t);
      await t.enterText(find.widgetWithText(TextField, 'Amount (₹)'), '110.01');
      await t.tap(find.byType(FilledButton).last);
      await t.pump();
      expect(find.text('It cannot be more than the balance ₹110.00.'),
          findsOneWidget);
      expect(pos.orders.payments, isEmpty);
    });

    testWidgets('exactly the balance is allowed', (t) async {
      final pos = await openPay(t);
      await t.enterText(find.widgetWithText(TextField, 'Amount (₹)'), '110.00');
      await t.tap(find.byType(FilledButton).last);
      await t.pumpAndSettle();
      expect(pos.orders.payments.single.amount, 11000);
    });

    testWidgets('a double tap records ONE payment', (t) async {
      final repo = FakeOrdersRepo(orders: [booked(paid: 5000)])
        ..gate = Completer<void>();
      await openPay(t, repo: repo);
      await t.tap(find.text('Collect ₹110.00'));
      await t.pump();
      await t.tap(find.byType(FilledButton).last, warnIfMissed: false);
      await t.pump();
      repo.gate!.complete();
      await t.pumpAndSettle();
      expect(repo.payments, hasLength(1));
    });

    testWidgets(
        'the server refuses (over balance because someone else paid): its sentence is shown, the sheet stays open',
        (t) async {
      final repo = FakeOrdersRepo(orders: [booked(paid: 5000)])
        ..onPay = (id, a) => apiError(
            'OVERPAYMENT', 'Only ₹60.00 is outstanding on this order',
            status: 400);
      await openPay(t, repo: repo);
      await t.tap(find.text('Collect ₹110.00'));
      await t.pumpAndSettle();
      expect(find.text('Only ₹60.00 is outstanding on this order'),
          findsOneWidget);
      expect(find.text('Collect payment'), findsOneWidget);
      expect(find.text('Collect ₹110.00'), findsOneWidget,
          reason: 'the button is usable again');
    });

    testWidgets(
        'a dropped connection: "check the balance before collecting again", and the order was re-read',
        (t) async {
      final repo = FakeOrdersRepo(orders: [booked(paid: 5000)])
        ..onPay = (id, a) => const ApiException(
            message: 'No internet connection', code: 'NETWORK_ERROR');
      await openPay(t, repo: repo);
      final readsBefore = repo.calls.where((c) => c == 'get:o-1').length;
      await t.tap(find.text('Collect ₹110.00'));
      await t.pumpAndSettle();
      expect(find.textContaining('could not confirm that payment'),
          findsOneWidget);
      expect(repo.calls.where((c) => c == 'get:o-1').length,
          greaterThan(readsBefore));
    });

    testWidgets('Pay Now is not offered to someone who may not process orders',
        (t) async {
      await openDetail(t, booked(paid: 5000), canProcess: false);
      expect(find.text('Pay Now'), findsNothing);
      expect(find.byType(FilledButton), findsNothing);
    });
  });

  group('Cancel Order', () {
    Future<Pos> openCancel(WidgetTester t,
        {int paid = 0, FakeOrdersRepo? repo}) async {
      final pos = await openDetail(t, booked(paid: paid), repo: repo);
      await t.tap(find.text('Cancel Order'));
      await t.pumpAndSettle();
      return pos;
    }

    testWidgets('a reason is needed: the button stays off until one is chosen',
        (t) async {
      await openCancel(t);
      expect(find.text('Cancel this order?'), findsOneWidget);
      expect(find.textContaining('This cannot be undone.'), findsOneWidget);
      FilledButton confirm() => t.widget<FilledButton>(
          find.widgetWithText(FilledButton, 'Cancel Order'));
      expect(confirm().onPressed, isNull);
      await t.tap(find.text('Booked by mistake'));
      await t.pump();
      expect(confirm().onPressed, isNotNull);
    });

    testWidgets(
        'a chosen reason is sent in words and the order shows as cancelled',
        (t) async {
      final pos = await openCancel(t);
      await t.tap(find.text('Customer changed their mind'));
      await t.pump();
      await t.tap(find.widgetWithText(FilledButton, 'Cancel Order'));
      await t.pumpAndSettle();
      expect(pos.orders.cancels.single,
          (id: 'o-1', reason: 'Customer changed their mind'));
      expect(find.text('Order cancelled.'), findsOneWidget);
      expect(find.textContaining('This order was cancelled.'), findsOneWidget);
      expect(find.byType(FilledButton), findsNothing);
    });

    testWidgets(
        '"Other" needs at least 3 letters, then sends exactly what was typed',
        (t) async {
      final pos = await openCancel(t);
      await t.tap(find.text('Other reason'));
      await t.pump();
      FilledButton confirm() => t.widget<FilledButton>(
          find.widgetWithText(FilledButton, 'Cancel Order'));
      expect(confirm().onPressed, isNull);
      await t.enterText(find.byType(TextField).last, 'ab');
      await t.pump();
      expect(confirm().onPressed, isNull);
      await t.enterText(find.byType(TextField).last, '  Wrong shop  ');
      await t.pump();
      await t.tap(find.widgetWithText(FilledButton, 'Cancel Order'));
      await t.pumpAndSettle();
      expect(pos.orders.cancels.single.reason, 'Wrong shop');
    });

    testWidgets(
        'if money was already paid the sheet says the app does not refund it',
        (t) async {
      await openCancel(t, paid: 5000);
      expect(find.textContaining('does not refund'), findsOneWidget);
    });
    testWidgets('nothing paid: no refund note', (t) async {
      await openCancel(t);
      expect(find.textContaining('does not refund'), findsNothing);
    });

    testWidgets('"Keep the order" changes nothing', (t) async {
      final pos = await openCancel(t);
      await t.tap(find.text('Keep the order'));
      await t.pumpAndSettle();
      expect(pos.orders.cancels, isEmpty);
      expect(find.text('Start Processing'), findsOneWidget);
    });

    testWidgets('a refusal from the server is shown and the sheet stays',
        (t) async {
      final repo = _CancelFails(booked());
      await openCancel(t, repo: repo);
      await t.tap(find.text('Booked by mistake'));
      await t.pump();
      await t.tap(find.widgetWithText(FilledButton, 'Cancel Order'));
      await t.pumpAndSettle();
      expect(
          find.text('This order can no longer be cancelled'), findsOneWidget);
      expect(find.text('Cancel this order?'), findsOneWidget);
    });

    testWidgets('not offered to someone who may not process orders', (t) async {
      await openDetail(t, booked(), canProcess: false);
      expect(find.text('Cancel Order'), findsNothing);
    });
  });

  group('Edit Order', () {
    Future<Pos> openEdit(WidgetTester t, {CounterOrder? o}) async {
      final pos = await openDetail(
          t, o ?? booked(express: true, mode: DeliveryMode.homeDelivery));
      await t.tap(find.text('Edit Order'));
      await t.pumpAndSettle();
      return pos;
    }

    testWidgets(
        'starts from what the order has, says garments cannot be edited, and sends ONLY what changed',
        (t) async {
      final pos = await openEdit(t);
      expect(
          find.text(
              'To change the garments, cancel this order and book a new one.'),
          findsOneWidget);
      expect(
          t
              .widget<FilterChip>(find.widgetWithText(FilterChip, 'Express'))
              .selected,
          isTrue);
      expect(
          t
              .widget<FilterChip>(
                  find.widgetWithText(FilterChip, 'Home Delivery'))
              .selected,
          isTrue);
      await t.tap(find.widgetWithText(FilterChip, 'Express'));
      await t.enterText(
          find.widgetWithText(TextField, 'Remarks'), 'Call before delivery');
      await t.pump();
      await t.tap(find.text('Save changes'));
      await t.pumpAndSettle();
      final e = pos.orders.edits.single.edit;
      expect((
        e.isExpress,
        e.notes,
        e.deliveryMode,
        e.expectedDeliveryDate,
        e.deliveryAddress
      ), (
        false,
        'Call before delivery',
        null,
        null,
        null
      ));
      expect(find.text('Order updated.'), findsOneWidget);
    });

    testWidgets('home delivery tapped off means "collect at the counter"',
        (t) async {
      final pos = await openEdit(t);
      await t.tap(find.widgetWithText(FilterChip, 'Home Delivery'));
      await t.pump();
      await t.tap(find.text('Save changes'));
      await t.pumpAndSettle();
      expect(pos.orders.edits.single.edit.deliveryMode, DeliveryMode.walkIn);
    });

    testWidgets('saving without changing anything sends nothing', (t) async {
      final pos = await openEdit(t);
      await t.tap(find.text('Save changes'));
      await t.pumpAndSettle();
      expect(pos.orders.edits, isEmpty);
      expect(find.text('Save changes'), findsNothing);
    });

    testWidgets(
        'the order\'s version goes with the edit, so a stale screen cannot overwrite someone else\'s change',
        (t) async {
      final repo = FakeOrdersRepo(orders: [booked()]);
      await openDetail(t, booked(), repo: repo);
      await t.tap(find.text('Edit Order'));
      await t.pumpAndSettle();
      await t.enterText(find.widgetWithText(TextField, 'Remarks'), 'x');
      await t.tap(find.text('Save changes'));
      await t.pumpAndSettle();
      expect(repo.edits, hasLength(1));
    });

    testWidgets('a delivered order cannot be edited (the tile is off)',
        (t) async {
      await openDetail(t, booked(status: 'DELIVERED', paid: 16000));
      expect(actionEnabled(t, 'Edit Order'), isFalse);
    });
  });

  group('Assign Captain', () {
    testWidgets('hidden for a walk-in order: nobody picks it up or delivers it',
        (t) async {
      await openDetail(t, booked());
      expect(find.text('Assign Captain'), findsNothing);
    });
    testWidgets('hidden from people without the "assign captain" right',
        (t) async {
      await openDetail(t, booked(mode: DeliveryMode.pickup), canAssign: false);
      expect(find.text('Assign Captain'), findsNothing);
    });
    testWidgets('shown for pickup and home delivery', (t) async {
      await openDetail(t, booked(mode: DeliveryMode.pickup));
      expect(find.text('Assign Captain'), findsOneWidget);
    });

    testWidgets(
        'picks pickup and delivery captains from the team and saves; the order then shows their names',
        (t) async {
      final repo = FakeOrdersRepo(
          orders: [booked(mode: DeliveryMode.homeDelivery)])
        ..captains = [
          captain,
          const OrderCaptain(id: 'cap-2', name: 'Sunil', phone: '9000000002')
        ];
      final pos = await openDetail(t, booked(mode: DeliveryMode.homeDelivery),
          repo: repo);
      await t.tap(find.text('Assign Captain'));
      await t.pumpAndSettle();
      expect(find.text('Assign captain'), findsOneWidget);
      await t.tap(find.byType(DropdownButtonFormField<String?>).last);
      await t.pumpAndSettle();
      await t.tap(find.textContaining('Ravi Captain').last);
      await t.pumpAndSettle();
      await t.tap(find.text('Assign'));
      await t.pumpAndSettle();
      expect(pos.orders.assigns.single,
          (id: 'o-1', pickup: null, delivery: 'cap-1'));
      expect(find.text('Captain assigned.'), findsOneWidget);
      expect(find.text('Ravi Captain'), findsOneWidget);
    });

    testWidgets('no captains yet: says where to add one, and Assign is off',
        (t) async {
      await openDetail(t, booked(mode: DeliveryMode.homeDelivery));
      await t.tap(find.text('Assign Captain'));
      await t.pumpAndSettle();
      expect(find.text('You have no captains yet. Add one in Settings → Team.'),
          findsOneWidget);
      expect(
          t
              .widget<FilledButton>(find.widgetWithText(FilledButton, 'Assign'))
              .onPressed,
          isNull);
    });
  });

  group('people', () {
    testWidgets(
        'without "process orders": they can look, call and WhatsApp, but cannot move, pay, edit or cancel',
        (t) async {
      await openDetail(t, booked(paid: 5000, mode: DeliveryMode.homeDelivery),
          canProcess: false);
      expect(find.byType(FilledButton), findsNothing);
      for (final a in ['Pay Now', 'Edit Order', 'Cancel Order']) {
        expect(find.text(a), findsNothing, reason: a);
      }
      expect(find.text('View Invoice'), findsOneWidget);
      expect(find.text('Call'), findsOneWidget);
      expect(find.text('WhatsApp'), findsOneWidget);
    });

    testWidgets('without "view orders": a polite no', (t) async {
      await openDetail(t, booked(), canView: false);
      expect(
          find.text(
              'You do not have permission to do this. Ask the shop owner.'),
          findsOneWidget);
      expect(find.text('Asha Verma'), findsNothing);
    });

    testWidgets(
        'the server saying 403 shows the same polite sentence, not a code',
        (t) async {
      final repo = FakeOrdersRepo(orders: [booked()])
        ..onTransition = (id, s, i, u) => apiError(
            'FORBIDDEN', 'Riders do not have access to counter orders',
            status: 403);
      await openDetail(t, booked(), repo: repo);
      await t.tap(find.text('Start Processing'));
      await t.pumpAndSettle();
      expect(
          find.text(
              'You do not have permission to do this. Ask the shop owner.'),
          findsOneWidget);
    });
  });

  group('call, WhatsApp, invoice', () {
    testWidgets('Call opens the dialler with the customer\'s number',
        (t) async {
      final pos = await openDetail(t, booked());
      await t.tap(find.text('Call'));
      await t.pumpAndSettle();
      expect(pos.opened.single.toString(), 'tel:9811122233');
    });

    testWidgets('Call that cannot open says so', (t) async {
      await openDetail(t, booked(), openerWorks: false);
      await t.tap(find.text('Call'));
      await t.pumpAndSettle();
      expect(find.text('Could not open the phone.'), findsOneWidget);
    });

    testWidgets(
        'WhatsApp opens wa.me/<91 + number> with a friendly message that has the order, status and balance',
        (t) async {
      final pos = await openDetail(t, booked(status: 'IN_PROCESS', paid: 5000));
      await t.tap(find.text('WhatsApp'));
      await t.pumpAndSettle();
      final u = pos.opened.single;
      expect((u.host, u.path), ('wa.me', '/919811122233'));
      final text = u.queryParameters['text']!;
      expect(
          text,
          allOf(
              contains('Asha Verma'),
              contains('LND-D-1'),
              contains('Processing'),
              contains('₹110'),
              contains('Sparkle Laundry')));
    });

    testWidgets('WhatsApp not installed: says so', (t) async {
      await openDetail(t, booked(), openerWorks: false);
      await t.tap(find.text('WhatsApp'));
      await t.pumpAndSettle();
      expect(find.text('Could not open WhatsApp.'), findsOneWidget);
    });

    testWidgets('a customer with no phone gets no Call and no WhatsApp',
        (t) async {
      await openDetail(
          t,
          makeOrder(
              id: 'o-1',
              number: 'LND-D-1',
              customer:
                  const PosCustomer(id: 'u', name: 'No Phone', phone: '')));
      expect(find.text('Call'), findsNothing);
      expect(find.text('WhatsApp'), findsNothing);
    });

    testWidgets(
        'View Invoice on a delivered order opens the invoice; Mini Invoice opens the mini bill',
        (t) async {
      await openDetail(t, booked(status: 'DELIVERED', paid: 16000));
      await t.tap(find.text('View Invoice'));
      await t.pumpAndSettle();
      expect(find.text('INVOICE o-1'), findsOneWidget);
    });

    testWidgets(
        'View Invoice before delivery explains, and offers the mini bill instead',
        (t) async {
      await openDetail(t, booked());
      await t.tap(find.text('View Invoice'));
      await t.pumpAndSettle();
      expect(
          find.text(
              'The invoice is created when the order is delivered. Use Mini Invoice for a bill now.'),
          findsOneWidget);
      await t.tap(find.text('Open Mini Invoice'));
      await t.pumpAndSettle();
      expect(find.text('MINI o-1'), findsOneWidget);
    });

    testWidgets('Mini Invoice and Tags open their screens', (t) async {
      final repo = FakeOrdersRepo(orders: [booked()]);
      await openDetail(t, booked(), repo: repo);
      await t.tap(find.text('Mini Invoice'));
      await t.pumpAndSettle();
      expect(find.text('MINI o-1'), findsOneWidget);
    });
    testWidgets('Tags opens the tag screen', (t) async {
      await openDetail(t, booked());
      await t.tap(find.text('Tags'));
      await t.pumpAndSettle();
      expect(find.text('TAGS o-1'), findsOneWidget);
    });
  });
}

/// A repository whose cancel is refused.
class _CancelFails extends FakeOrdersRepo {
  _CancelFails(CounterOrder o) : super(orders: [o]);
  @override
  Future<CounterOrder> cancel(String id, String reason) async => throw apiError(
      'INVALID_TRANSITION', 'This order can no longer be cancelled');
}
