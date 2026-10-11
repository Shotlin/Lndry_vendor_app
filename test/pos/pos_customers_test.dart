import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lndry_vendor_app/features/pos/customers/customer_detail_page.dart';
import 'package:lndry_vendor_app/features/pos/customers/customers_page.dart';
import 'package:lndry_vendor_app/models/pos/pos_customer_model.dart';

import 'pos_fakes.dart';
import 'pos_harness.dart';
import 'pos_money_fakes.dart';

const asha = PosCustomer(id: 'u-1', name: 'Asha Verma', phone: '9811122233', orderCount: 3, spentPaise: 48000);
const bina = PosCustomer(id: 'u-2', name: 'Bina Shah', phone: '9000000002', orderCount: 1, spentPaise: 12000);

void main() {
  group('customers list', () {
    testWidgets('shows name, phone, orders and spend; tap opens the profile', (tester) async {
      final counter = FakeCounterRepo()..customers = [asha, bina];
      await pumpPos(tester, const PosCustomersPage(), counter: counter);
      expect(find.text('Asha Verma'), findsOneWidget);
      expect(find.textContaining('9811122233'), findsOneWidget);
      expect(find.textContaining('3 orders · ₹480'), findsOneWidget);
      await tester.tap(find.text('Bina Shah'));
      await tester.pumpAndSettle();
      expect(find.text('CUSTOMER u-2'), findsOneWidget);
    });

    testWidgets('A-Z: letter headers, the strip jumps to a letter, rows have labelled Call and Profile', (tester) async {
      final counter = FakeCounterRepo()
        ..customers = [
          for (var i = 0; i < 12; i++) PosCustomer(id: 'a$i', name: 'Aa${String.fromCharCode(97 + i)}', phone: '90000000$i${i}'),
          const PosCustomer(id: 'z1', name: 'Zoya Khan', phone: '9111111111'),
          const PosCustomer(id: 'n1', name: '9 Number First', phone: '9222222222'),
        ];
      final p = await pumpPos(tester, const PosCustomersPage(), counter: counter);
      expect(find.text('A'), findsWidgets);
      expect(find.text('Zoya Khan'), findsNothing, reason: 'far down the list');
      await tester.tap(find.widgetWithText(InkWell, 'Z').last);
      await tester.pumpAndSettle();
      expect(find.text('Zoya Khan'), findsOneWidget);
      await tester.tap(find.text('Call').first);
      await tester.pumpAndSettle();
      expect(p.opened.single.scheme, 'tel');
      await tester.tap(find.text('Profile').first);
      await tester.pumpAndSettle();
      expect(find.textContaining('CUSTOMER '), findsOneWidget);
    });

    test('letterOf', () {
      expect(letterOf('asha'), 'A');
      expect(letterOf('  bina'), 'B');
      expect(letterOf('9 Number'), '#');
      expect(letterOf(''), '#');
    });

    testWidgets('search narrows the list; no match says so', (tester) async {
      final counter = FakeCounterRepo()..customers = [asha, bina];
      await pumpPos(tester, const PosCustomersPage(), counter: counter);
      await tester.enterText(find.byType(TextField), 'bin');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      expect(find.text('Asha Verma'), findsNothing);
      expect(find.text('Bina Shah'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'zzz');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      expect(find.textContaining('No customer matches "zzz"'), findsOneWidget);
    });

    testWidgets('empty shop tells what to do', (tester) async {
      final counter = FakeCounterRepo()..customers = const [];
      await pumpPos(tester, const PosCustomersPage(), counter: counter);
      expect(find.textContaining('No customers yet'), findsOneWidget);
    });

    testWidgets('large text on a small phone: no overflow', (tester) async {
      final counter = FakeCounterRepo()..customers = [asha, bina];
      await pumpPos(tester, const PosCustomersPage(), counter: counter, textScale: 1.6, size: const Size(360, 640));
      expect(tester.takeException(), isNull);
    });
  });

  group('customer detail', () {
    PosFixtureOrders orders() => PosFixtureOrders(
          due: makeOrder(id: 'o-due', number: 'LND-1', total: 16000, paid: 5000),
          paid: makeOrder(id: 'o-paid', number: 'LND-2', total: 8000, paid: 8000),
          cancelled: makeOrder(id: 'o-x', number: 'LND-3', total: 9000, status: 'CANCELLED'),
        );

    testWidgets('what they owe is the sum of the server\'s balances; tapping an order goes to Pay Now', (tester) async {
      final o = orders();
      final money = MoneyFakes()..customers.details['u-1'] = makeCustomerDetail(orders: [o.due, o.paid, o.cancelled], ledger: 11000);
      await pumpPos(tester, const PosCustomerDetailPage(customerId: 'u-1'), money: money);
      expect(find.text('Asha Verma'), findsWidgets);
      expect(find.text('Owes ₹110'), findsOneWidget);
      expect(find.text('Order LND-1'), findsOneWidget, reason: 'only the order with a balance is in "To collect"');
      expect(find.text('Order LND-2'), findsNothing);
      expect(find.text('Order LND-3'), findsNothing);
      await tester.tap(find.text('Order LND-1'));
      await tester.pumpAndSettle();
      expect(find.text('ORDER DETAIL o-due'), findsOneWidget);
    });

    testWidgets('nobody owes: says all paid, and still lists the history', (tester) async {
      final o = orders();
      final money = MoneyFakes()..customers.details['u-1'] = makeCustomerDetail(orders: [o.paid]);
      await pumpPos(tester, const PosCustomerDetailPage(customerId: 'u-1'), money: money);
      expect(find.text('Nothing is due. All paid.'), findsOneWidget);
      expect(find.text('Order history'), findsOneWidget);
      expect(find.textContaining('LND-2'), findsWidgets);
    });

    testWidgets('Call opens the dialler; a phone that cannot open says so', (tester) async {
      final money = MoneyFakes()..customers.details['u-1'] = makeCustomerDetail();
      final p = await pumpPos(tester, const PosCustomerDetailPage(customerId: 'u-1'), money: money);
      await tester.tap(find.text('Call'));
      await tester.pumpAndSettle();
      expect(p.opened.single.toString(), 'tel:9811122233');
    });

    testWidgets('WhatsApp opens the message sheet', (tester) async {
      final o = orders();
      final money = MoneyFakes()..customers.details['u-1'] = makeCustomerDetail(orders: [o.due]);
      await pumpPos(tester, const PosCustomerDetailPage(customerId: 'u-1'), money: money);
      await tester.tap(find.text('WhatsApp'));
      await tester.pumpAndSettle();
      expect(find.text('Message Asha Verma'), findsOneWidget);
      expect(find.text('About order LND-1'), findsOneWidget);
    });

    testWidgets('an unknown customer says not found', (tester) async {
      await pumpPos(tester, const PosCustomerDetailPage(customerId: 'nope'));
      expect(find.text('This customer was not found.'), findsOneWidget);
    });

    testWidgets('a network failure offers retry', (tester) async {
      final money = MoneyFakes()..customers.error = StateError('offline');
      await pumpPos(tester, const PosCustomerDetailPage(customerId: 'u-1'), money: money);
      expect(find.text('Try again'), findsOneWidget);
    });
  });
}

class PosFixtureOrders {
  PosFixtureOrders({required this.due, required this.paid, required this.cancelled});
  final dynamic due;
  final dynamic paid;
  final dynamic cancelled;
}
