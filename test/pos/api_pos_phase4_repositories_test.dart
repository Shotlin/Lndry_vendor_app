import 'package:flutter_test/flutter_test.dart';
import 'package:lndry_vendor_app/api/repositories/api_pos_repositories.dart';
import 'package:lndry_vendor_app/features/pos/orders/order_errors.dart';
import 'package:lndry_vendor_app/models/pos/pos_money_model.dart';

import 'contract_http.dart';

/// Contract tests: the fixtures are REAL responses captured from a running Lndry_backend (Phase 4 build).
void main() {
  group('search', () {
    test('customers, orders and garment tags are read as sent', () async {
      final t = makeContractDio()
        ..http.on('GET', '/vendor/pos/search', 'search_orders');
      final r = await ApiPosSearchRepository(t.dio).search('LND-26');
      expect(r.orders, hasLength(2));
      expect(r.orders.first.orderNumber, startsWith('LND-'));
      expect(r.orders.first.totalPaise, 16000);
      expect(r.orders.first.placedAt, isNotNull);
      expect(r.customers, isEmpty);
      expect(r.isEmpty, isFalse);
      expect(t.http.last('GET', '/vendor/pos/search').queryParameters, {'q': 'LND-26'});
    });
    test('a customer hit', () async {
      final t = makeContractDio()..http.on('GET', '/vendor/pos/search', 'search');
      final r = await ApiPosSearchRepository(t.dio).search('Asha');
      expect(r.customers.single.name, 'Asha Rao');
      expect(r.customers.single.phone, '9811122233');
    });
    test('the server refuses one letter, in plain words', () async {
      final t = makeContractDio()..http.on('GET', '/vendor/pos/search', 'search_short', status: 400);
      await expectLater(ApiPosSearchRepository(t.dio).search('a'), throwsA(predicate((e) => errorCodeOf(e) == 'VALIDATION_ERROR')));
    });
  });

  group('expenses', () {
    test('list: integer paise, DATE cut to a day, mode and status', () async {
      final t = makeContractDio()..http.on('GET', '/vendor/expenses', 'expenses_list');
      final list = await ApiPosExpenseRepository(t.dio).listExpenses(from: '2026-10-11', to: '2026-10-11');
      expect(list, hasLength(2));
      final tea = list.firstWhere((e) => e.name == 'Tea');
      expect(tea.amountPaise, 3000);
      expect(tea.paymentMode, 'UPI');
      expect(tea.date, matches(RegExp(r'^\d{4}-\d{2}-\d{2}$')));
      expect(tea.cancelled, isFalse);
      final bill = list.firstWhere((e) => e.name == 'Electricity bill');
      expect(bill.notes, 'October');
      expect(t.http.last('GET', '/vendor/expenses').queryParameters, containsPair('from', '2026-10-11'));
    });
    test('create sends whole paise and only the filled fields', () async {
      final t = makeContractDio()..http.on('POST', '/vendor/expenses', 'expense_create', status: 201);
      final e = await ApiPosExpenseRepository(t.dio).createExpense(const ExpenseDraft(name: ' Electricity bill ', date: '2026-10-11', amountPaise: 25000, category: 'UTILITIES', paymentMode: 'CASH'));
      expect(e.amountPaise, 25000);
      expect(t.http.last('POST', '/vendor/expenses').data, {'expenseName': 'Electricity bill', 'expenseDate': '2026-10-11', 'amountPaise': 25000, 'category': 'UTILITIES', 'paymentMode': 'CASH'});
    });
    test('a blank name is refused by the server with a sentence', () async {
      final t = makeContractDio()..http.on('POST', '/vendor/expenses', 'expense_error', status: 400);
      await expectLater(
          ApiPosExpenseRepository(t.dio).createExpense(const ExpenseDraft(name: ' ', date: '2026-10-11', amountPaise: 100, category: 'OTHER', paymentMode: 'CASH')), throwsA(isA<Object>()));
    });
  });

  group('cash drawer', () {
    test('no open shift is null, not an error', () async {
      final t = makeContractDio()..http.on('GET', '/vendor/cash-shifts/current', 'shift_none');
      expect(await ApiPosExpenseRepository(t.dio).currentShift(), isNull);
    });
    test('open shift: expected cash is the server\'s figure', () async {
      final t = makeContractDio()..http.on('GET', '/vendor/cash-shifts/current', 'shift_current');
      final s = (await ApiPosExpenseRepository(t.dio).currentShift())!;
      expect(s.open, isTrue);
      expect(s.openingCashPaise, 50000);
      expect(s.collectionsPaise, 0);
      expect(s.expensesPaise, 25000);
      expect(s.expectedCashPaise, 25000);
      expect(s.countedCashPaise, isNull);
    });
    test('a wrong count needs approval: the code is readable', () async {
      final t = makeContractDio()..http.on('POST', '/vendor/cash-shifts/abc/close', 'shift_close_variance', status: 400);
      await expectLater(ApiPosExpenseRepository(t.dio).closeShift('abc', countedCashPaise: 1), throwsA(predicate((e) => errorCodeOf(e) == 'VARIANCE_APPROVAL_REQUIRED')));
    });
    test('close sends the approval only when given', () async {
      final t = makeContractDio()..http.on('POST', '/vendor/cash-shifts/abc/close', 'shift_close_ok');
      final s = await ApiPosExpenseRepository(t.dio).closeShift('abc', countedCashPaise: 25000);
      expect(s.open, isFalse);
      expect(s.variancePaise, 0);
      expect(t.http.last('POST', '/vendor/cash-shifts/abc/close').data, {'countedCashPaise': 25000});
      await ApiPosExpenseRepository(t.dio).closeShift('abc', countedCashPaise: 100, note: 'short', approvedBy: 'Raj');
      expect(t.http.last('POST', '/vendor/cash-shifts/abc/close').data, {'countedCashPaise': 100, 'note': 'short', 'supervisorApproved': true, 'supervisorActor': 'Raj'});
    });
    test('history', () async {
      final t = makeContractDio()..http.on('GET', '/vendor/cash-shifts', 'shifts_list');
      final l = await ApiPosExpenseRepository(t.dio).listShifts();
      expect(l.single.open, isFalse);
      expect(l.single.closedAt, isNotNull);
    });
  });

  group('report', () {
    test('every number as sent; nothing invented', () async {
      final t = makeContractDio()..http.on('GET', '/vendor/pos/report', 'report');
      final r = await ApiPosReportRepository(t.dio).report(from: '2026-10-11', to: '2026-10-11');
      expect(r.days, 1);
      expect(r.orderCount, 2);
      expect(r.revenuePaise, 32000);
      expect(r.collectionPaise, 16000);
      expect(r.duesPaise, 16000);
      expect(r.expensesPaise, 28000);
      expect(r.netPaise, -12000);
      expect(r.paymentMix.cashPaise, 16000);
      expect(r.paymentMix.upiPaise, 0);
      expect(r.ordersByStatus.booked, 2);
      expect(r.topGarments.single.name, 'Shirt');
      expect(r.topGarments.single.qty, 4);
      expect(r.expenseByCategory.map((c) => c.category), ['UTILITIES', 'TEA']);
      expect(r.daily.single.revenuePaise, 32000);
    });
    test('an older server without the report: figures are null, not 0', () {
      final r = PosReport.fromJson({'from': 'a', 'to': 'b'});
      expect(r.revenuePaise, isNull);
      expect(r.paymentMix.cashPaise, isNull);
      expect(r.ordersByStatus.booked, isNull);
    });
    test('a backwards range is refused in words', () async {
      final t = makeContractDio()..http.on('GET', '/vendor/pos/report', 'report_error', status: 400);
      await expectLater(ApiPosReportRepository(t.dio).report(from: '2026-10-11', to: '2020-01-01'), throwsA(predicate((e) => errorCodeOf(e) == 'VALIDATION_ERROR')));
    });
    test('CSV comes back as text; an HTML error page is refused', () async {
      final t = makeContractDio()..http.onText('GET', '/vendor/pos/counter-sales/export', fixtureText('report_export.csv'));
      final csv = await ApiPosReportRepository(t.dio).exportCsv(from: '2026-10-11', to: '2026-10-11');
      expect(csv.split('\n').first, startsWith('Order Number,Placed At'));
      expect(csv.split('\n'), hasLength(3));
      t.http.onText('GET', '/vendor/pos/counter-sales/export', '<html>proxy error</html>');
      await expectLater(ApiPosReportRepository(t.dio).exportCsv(from: 'a', to: 'b'), throwsA(isA<Object>()));
    });
  });

  group('customers and settings', () {
    test('customer detail: orders with dues, ledger balance', () async {
      final t = makeContractDio()..http.on('GET', '/vendor/counter/customers/u1', 'customer_detail');
      final d = await ApiPosCustomersRepository(t.dio).detail('u1');
      expect(d.customer.name, 'Asha Rao');
      expect(d.orders, hasLength(2));
      expect(d.ledgerBalancePaise, 16000);
      expect(d.ordersWithDue, hasLength(1));
      expect(d.ordersWithDue.single.balancePaise, 16000);
      expect(d.ordersWithDue.fold<int>(0, (s, o) => s + o.balancePaise), d.ledgerBalancePaise);
    });
    test('no saved templates: Epic\'s four defaults', () async {
      final t = makeContractDio()..http.on('GET', '/vendor/pos-settings', 'pos_settings');
      final l = await ApiPosSettingsRepository(t.dio).messageTemplates();
      expect(l.map((m) => m.key), ['order-booked', 'order-processing', 'order-done', 'order-delivered']);
    });
    test('staff list', () async {
      final t = makeContractDio()..http.on('GET', '/vendor/employees', 'employees');
      final s = await ApiPosSettingsRepository(t.dio).staff();
      expect(s.single.role, 'VENDOR_OWNER');
      expect(s.single.active, isTrue);
      expect(s.single.displayName, s.single.phone);
    });
  });
}
