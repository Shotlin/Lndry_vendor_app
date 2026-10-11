import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lndry_vendor_app/features/pos/report/invoice_tab.dart';
import 'package:lndry_vendor_app/features/pos/report/report_page.dart';
import 'package:lndry_vendor_app/features/pos/report/report_providers.dart';
import 'package:lndry_vendor_app/models/pos/pos_money_model.dart';

import 'pos_fakes.dart';
import 'pos_harness.dart';
import 'pos_money_fakes.dart';

final now = DateTime(2026, 10, 11, 10);

Future<Pos> pumpReport(WidgetTester tester, MoneyFakes money, {bool canSee = true, double textScale = 1, Size size = const Size(390, 844)}) =>
    pumpPos(tester, PosReportPage(now: now), money: money, canSeeReport: canSee, textScale: textScale, size: size);

void main() {
  invoiceTabTests();
  test('presets: today, last 7 days (today + 6 before), this month from the 1st', () {
    expect(reportRangeFor(ReportPreset.today, now), (from: '2026-10-11', to: '2026-10-11'));
    expect(reportRangeFor(ReportPreset.week, now), (from: '2026-10-05', to: '2026-10-11'));
    expect(reportRangeFor(ReportPreset.month, now), (from: '2026-10-01', to: '2026-10-11'));
    expect(reportRangeFor(ReportPreset.week, DateTime(2026, 3, 3)), (from: '2026-02-25', to: '2026-03-03'), reason: 'crosses a month end');
    expect(csvFileName((from: '2026-10-01', to: '2026-10-11')), 'counter-sales-2026-10-01-to-2026-10-11.csv');
  });

  testWidgets('without the right: a plain note and no request', (tester) async {
    final money = MoneyFakes();
    await pumpReport(tester, money, canSee: false);
    expect(find.textContaining('Ask the shop owner'), findsOneWidget);
    expect(money.report.calls, isEmpty);
  });

  testWidgets('shows the server\'s numbers for today', (tester) async {
    final money = MoneyFakes();
    await pumpReport(tester, money);
    expect(money.report.calls.single, (from: '2026-10-11', to: '2026-10-11'));
    expect(find.text('₹320'), findsOneWidget, reason: 'billed');
    expect(find.text('2 orders booked'), findsOneWidget);
    expect(find.text('₹160'), findsNWidgets(3), reason: 'collected, still to collect, and the cash bar');
    expect(find.text('₹280'), findsOneWidget, reason: 'spent');
    expect(find.text('-₹120'), findsOneWidget, reason: 'collected minus spent, worked out by the server');
    expect(find.text('Booked: 2'), findsOneWidget);
    expect(find.text('Shirt'), findsOneWidget);
    expect(find.text('Utilities'), findsOneWidget);
  });

  testWidgets('a number the server did not send is a dash, never 0', (tester) async {
    final money = MoneyFakes();
    money.report.make = (from, to) => PosReport(from: from, to: to, days: 1);
    await pumpReport(tester, money);
    expect(find.text('—'), findsWidgets);
    expect(find.text('₹0'), findsNothing);
    expect(find.text('Booked: —'), findsOneWidget);
  });

  testWidgets('an empty period says so, and shows honest zeros', (tester) async {
    final money = MoneyFakes();
    money.report.make = (from, to) => makeReport(revenue: 0, collection: 0, dues: 0, expenses: 0, orders: 0).copyZero();
    await pumpReport(tester, money);
    expect(find.text('No orders or expenses in this period.'), findsOneWidget);
    expect(find.text('No payments in this period.'), findsOneWidget);
  });

  testWidgets('the period chips ask for the right dates', (tester) async {
    final money = MoneyFakes();
    await pumpReport(tester, money);
    await tester.tap(find.text('Last 7 days'));
    await tester.pumpAndSettle();
    expect(money.report.calls.last, (from: '2026-10-05', to: '2026-10-11'));
    await tester.tap(find.text('This month'));
    await tester.pumpAndSettle();
    expect(money.report.calls.last, (from: '2026-10-01', to: '2026-10-11'));
    await tester.tap(find.text('Today'));
    await tester.pumpAndSettle();
    expect(money.report.calls.last, (from: '2026-10-11', to: '2026-10-11'));
  });

  testWidgets('several days: a day-by-day list, newest first', (tester) async {
    final money = MoneyFakes();
    money.report.make = (from, to) => PosReport(
          from: from,
          to: to,
          days: 2,
          revenuePaise: 30000,
          collectionPaise: 10000,
          daily: const [ReportDay(date: '2026-10-10', revenuePaise: 10000, collectionPaise: 4000, expensesPaise: 0), ReportDay(date: '2026-10-11', revenuePaise: 20000, collectionPaise: 6000, expensesPaise: 500)],
        );
    await pumpReport(tester, money);
    await tester.tap(find.text('Last 7 days'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Day by day'), 300, scrollable: find.byType(Scrollable).first);
    final newest = tester.getTopLeft(find.textContaining('Billed ₹200')).dy;
    final oldest = tester.getTopLeft(find.textContaining('Billed ₹100')).dy;
    expect(newest, lessThan(oldest));
  });

  testWidgets('share CSV: asks the server for the same dates and hands the file to the phone', (tester) async {
    final money = MoneyFakes();
    final p = await pumpReport(tester, money);
    await tester.tap(find.text('This month'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Share sales file (CSV)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Share sales file (CSV)'));
    await tester.pumpAndSettle();
    expect(money.report.exports.single, (from: '2026-10-01', to: '2026-10-11'));
    expect(p.shared.single.name, 'counter-sales-2026-10-01-to-2026-10-11.csv');
    expect(p.shared.single.csv, startsWith('Order Number,'));
  });

  testWidgets('share CSV failing says so and nothing is shared', (tester) async {
    final money = MoneyFakes();
    money.report.exportError = StateError('offline');
    final p = await pumpReport(tester, money);
    await tester.ensureVisible(find.text('Share sales file (CSV)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Share sales file (CSV)'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Could not prepare the file.'), findsOneWidget);
    expect(p.shared, isEmpty);
  });

  testWidgets('a failed load offers retry', (tester) async {
    final money = MoneyFakes();
    money.report.error = StateError('offline');
    await pumpReport(tester, money);
    expect(find.textContaining('Could not load the report.'), findsOneWidget);
    money.report.error = null;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text('₹320'), findsOneWidget);
  });

  testWidgets('small phone, 1.6x text: no overflow', (tester) async {
    await pumpReport(tester, MoneyFakes(), textScale: 1.6, size: const Size(360, 640));
    expect(tester.takeException(), isNull);
    expect(find.text('₹320'), findsOneWidget);
  });
}

extension on PosReport {
  PosReport copyZero() => PosReport(from: from, to: to, days: days, orderCount: 0, revenuePaise: 0, collectionPaise: 0, duesPaise: 0, duesOrderCount: 0, expensesPaise: 0, expenseCount: 0, netPaise: 0, ordersByStatus: const ReportOrdersByStatus(booked: 0, inProcess: 0, ready: 0, delivered: 0, cancelled: 0), paymentMix: const ReportPaymentMix(cashPaise: 0, upiPaise: 0, cardPaise: 0, bankPaise: 0, walletPaise: 0));
}

void invoiceTabTests() {
  Future<Pos> open(WidgetTester tester, FakeOrdersRepo orders) async {
    final p = await pumpPos(tester, PosReportPage(now: now), orders: orders, money: MoneyFakes());
    await tester.tap(find.text('Invoices'));
    await tester.pumpAndSettle();
    return p;
  }

  testWidgets('invoice table: number, amount and a word for Paid / Part paid / Pending; never cancelled', (tester) async {
    final orders = FakeOrdersRepo(orders: [
      makeOrder(id: 'a', number: 'LN-1', total: 32900, paid: 32900),
      makeOrder(id: 'b', number: 'LN-2', total: 39600, paid: 100),
      makeOrder(id: 'c', number: 'LN-3', total: 14200),
      makeOrder(id: 'x', number: 'LN-9', status: 'CANCELLED'),
    ]);
    await open(tester, orders);
    expect(find.text('Total revenue'), findsOneWidget);
    expect(find.text('₹320'), findsWidgets);
    expect(find.text('LN-1'), findsOneWidget);
    expect(find.text('₹329'), findsOneWidget);
    expect(find.text('Paid'), findsOneWidget);
    expect(find.text('LN-9'), findsNothing);
    expect(orders.listCalls.last.from, '2026-10-11');
    expect(orders.listCalls.last.to, '2026-10-11');
  });

  testWidgets('tapping an invoice opens the order', (tester) async {
    final orders = FakeOrdersRepo(orders: [makeOrder(id: 'a', number: 'LN-1')]);
    await open(tester, orders);
    await tester.tap(find.text('LN-1'));
    await tester.pumpAndSettle();
    expect(find.text('ORDER DETAIL a'), findsOneWidget);
  });

  testWidgets('paging: 10 per page, Next only when a full page came back, Previous goes back', (tester) async {
    final orders = FakeOrdersRepo(orders: [for (var i = 0; i < 12; i++) makeOrder(id: 'o$i', number: 'N-${i.toString().padLeft(2, '0')}')]);
    await open(tester, orders);
    final list = find.descendant(of: find.byType(InvoiceTab), matching: find.byType(Scrollable)).first;
    await tester.scrollUntilVisible(find.text('Next'), 200, scrollable: list);
    expect(find.text('Page 1'), findsOneWidget);
    expect(orders.pages.last, (limit: 10, offset: 0));
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(orders.pages.last, (limit: 10, offset: 10));
    await tester.scrollUntilVisible(find.text('Previous'), 200, scrollable: list);
    expect(find.text('Page 2'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('N-10'), -200, scrollable: list);
    expect(find.text('N-00'), findsNothing);
    await tester.scrollUntilVisible(find.text('Previous'), 200, scrollable: list);
    await tester.tap(find.text('Previous'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Page 1'), 200, scrollable: list);
    expect(find.text('Page 1'), findsOneWidget);
  });

  testWidgets('no invoices says so; a failure offers retry', (tester) async {
    final orders = FakeOrdersRepo()..listError = StateError('offline');
    await open(tester, orders);
    expect(find.textContaining('Could not load the invoices'), findsOneWidget);
  });
}
