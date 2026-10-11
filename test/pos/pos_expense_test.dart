import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lndry_vendor_app/features/pos/expense/expense_logic.dart';
import 'package:lndry_vendor_app/features/pos/expense/expense_page.dart';
import 'package:lndry_vendor_app/features/pos/expense/expense_providers.dart';

import 'pos_fakes.dart';
import 'pos_harness.dart';
import 'pos_money_fakes.dart';

final now = DateTime(2026, 10, 11, 10);

Future<Pos> pumpExpense(WidgetTester tester, MoneyFakes money, {bool canUseCash = true, double textScale = 1, Size size = const Size(390, 844)}) =>
    pumpPos(tester, PosExpensePage(now: now), money: money, canUseCash: canUseCash, textScale: textScale, size: size);

Finder field(String label) => find.widgetWithText(TextField, label);

void main() {
  group('rules', () {
    test('range: today is one day, month starts on the 1st', () {
      expect(rangeFor(ExpenseRange.today, now), (from: '2026-10-11', to: '2026-10-11'));
      expect(rangeFor(ExpenseRange.month, now), (from: '2026-10-01', to: '2026-10-11'));
    });
    test('amount must be a plain positive rupee amount; paise are exact', () {
      ExpenseCheck c(String a, {String name = 'Tea', bool reason = false, String? why}) =>
          checkExpense(name: name, amountText: a, category: 'TEA', mode: 'CASH', date: '2026-10-11', needReason: reason, reason: why);
      expect(c('250').draft!.amountPaise, 25000);
      expect(c('99.50').draft!.amountPaise, 9950);
      expect(c('0').problem, ExpenseProblem.amount);
      expect(c('-5').problem, ExpenseProblem.amount);
      expect(c('abc').problem, ExpenseProblem.amount);
      expect(c('').problem, ExpenseProblem.amount);
      expect(c('10', name: '   ').problem, ExpenseProblem.name);
      expect(c('10', reason: true).problem, ExpenseProblem.reason);
      expect(c('10', reason: true, why: 'typo').ok, isTrue);
    });
    test('drawer: short is negative, extra positive; any difference needs approval', () {
      expect(drawerDifference(expectedPaise: 25000, countedPaise: 24000), -1000);
      expect(drawerDifference(expectedPaise: 25000, countedPaise: 25500), 500);
      expect(drawerNeedsApproval(0), isFalse);
      expect(drawerNeedsApproval(-1), isTrue);
    });
  });

  testWidgets('without the right: a plain note, and nothing is loaded', (tester) async {
    final money = MoneyFakes();
    await pumpExpense(tester, money, canUseCash: false);
    expect(find.textContaining('Ask the shop owner'), findsOneWidget);
    expect(money.expense.listCalls, isEmpty);
  });

  testWidgets('closed drawer: open it with the cash in it; the card then shows the server\'s numbers', (tester) async {
    final money = MoneyFakes();
    await pumpExpense(tester, money);
    expect(find.textContaining('The cash drawer is closed'), findsOneWidget);
    await tester.tap(find.text('Open cash drawer'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open drawer'));
    await tester.pumpAndSettle();
    expect(find.text('Enter an amount like 250 or 99.50.'), findsOneWidget);
    expect(money.expense.openedWith, isNull);
    await tester.enterText(field('How much cash is in the drawer now?'), '500');
    await tester.tap(find.text('Open drawer'));
    await tester.pumpAndSettle();
    expect(money.expense.openedWith, 50000);
    expect(find.text('Cash drawer opened.'), findsOneWidget);
    expect(find.text('Cash that should be in the drawer'), findsOneWidget);
    expect(find.text('₹500'), findsWidgets);
  });

  testWidgets('closing: a matching count closes with no approval; the app never sends an approval it was not asked for', (tester) async {
    final money = MoneyFakes(expense: FakeExpenseRepo(shift: makeShift(opening: 50000, collections: 20000, expenses: 5000)));
    await pumpExpense(tester, money);
    expect(find.text('₹650'), findsWidgets, reason: 'should be 500 + 200 - 50, from the server');
    await tester.tap(find.text('Close cash drawer'));
    await tester.pumpAndSettle();
    expect(find.text('Should be: ₹650'), findsOneWidget);
    await tester.enterText(field('Cash you counted (₹)'), '650');
    await tester.pump();
    expect(find.text('It matches. Nothing is missing.'), findsOneWidget);
    await tester.tap(find.text('Close drawer'));
    await tester.pumpAndSettle();
    expect(money.expense.closeCalls.single, (counted: 65000, note: null, approvedBy: null));
    expect(find.text('Cash drawer closed.'), findsOneWidget);
    expect(find.textContaining('The cash drawer is closed'), findsOneWidget);
  });

  testWidgets('closing: a difference is said in words and needs a reason and a name before anything is sent', (tester) async {
    final money = MoneyFakes(expense: FakeExpenseRepo(shift: makeShift(opening: 50000)));
    await pumpExpense(tester, money);
    await tester.tap(find.text('Close cash drawer'));
    await tester.pumpAndSettle();
    await tester.enterText(field('Cash you counted (₹)'), '480');
    await tester.pump();
    expect(find.text('₹20 less than it should be.'), findsOneWidget);
    await tester.tap(find.text('Close drawer'));
    await tester.pumpAndSettle();
    expect(find.text('Write why it is different and who approved it.'), findsWidgets);
    expect(money.expense.closeCalls, isEmpty);
    await tester.enterText(field('Why is it different?'), 'Gave change');
    await tester.enterText(field('Approved by (name)'), 'Raj');
    await tester.tap(find.text('Close drawer'));
    await tester.pumpAndSettle();
    expect(money.expense.closeCalls.single, (counted: 48000, note: 'Gave change', approvedBy: 'Raj'));
  });

  testWidgets('more cash than expected is also a difference', (tester) async {
    final money = MoneyFakes(expense: FakeExpenseRepo(shift: makeShift(opening: 50000)));
    await pumpExpense(tester, money);
    await tester.tap(find.text('Close cash drawer'));
    await tester.pumpAndSettle();
    await tester.enterText(field('Cash you counted (₹)'), '525.50');
    await tester.pump();
    expect(find.text('₹25.50 more than it should be.'), findsOneWidget);
  });

  testWidgets('add expense: validation first, then one save with exact paise; double tap saves once', (tester) async {
    final gate = Completer<void>();
    final repo = FakeExpenseRepo();
    final money = MoneyFakes(expense: repo);
    await pumpExpense(tester, money);
    await tester.tap(find.text('Add Expense'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save Expense'));
    await tester.pumpAndSettle();
    expect(find.text('Write what the expense was for.'), findsOneWidget);
    await tester.enterText(field('What was it for?'), 'Electricity bill');
    await tester.tap(find.text('Save Expense'));
    await tester.pumpAndSettle();
    expect(find.text('Enter an amount like 250 or 99.50.'), findsOneWidget);
    expect(repo.created, isEmpty);
    await tester.enterText(field('Amount (₹)'), '1,250.50');
    await tester.tap(find.text('Electricity'));
    await tester.tap(find.text('UPI'));
    await tester.tap(find.text('Save Expense'));
    await tester.tap(find.text('Save Expense'), warnIfMissed: false);
    gate.complete();
    await tester.pumpAndSettle();
    expect(repo.created, hasLength(1));
    expect(repo.created.single.amountPaise, 125050);
    expect(repo.created.single.category, 'ELECTRICITY');
    expect(repo.created.single.paymentMode, 'UPI');
    expect(repo.created.single.date, '2026-10-11');
    expect(find.text('Expense saved.'), findsOneWidget);
    expect(find.text('Electricity bill'), findsOneWidget);
    expect(find.text('Spent: ₹1,250.50'), findsOneWidget);
  });

  testWidgets('a failed save keeps the form and says why', (tester) async {
    final repo = FakeExpenseRepo()..saveError = apiError('VALIDATION_ERROR', 'amountPaise must be greater than zero', status: 400);
    await pumpExpense(tester, MoneyFakes(expense: repo));
    await tester.tap(find.text('Add Expense'));
    await tester.pumpAndSettle();
    await tester.enterText(field('What was it for?'), 'Tea');
    await tester.enterText(field('Amount (₹)'), '30');
    await tester.tap(find.text('Save Expense'));
    await tester.pumpAndSettle();
    expect(find.textContaining('amountPaise must be greater than zero'), findsOneWidget);
    expect(find.text('Save Expense'), findsOneWidget, reason: 'the sheet stays open');
    expect(find.widgetWithText(TextField, 'Tea'), findsOneWidget);
  });

  testWidgets('cancel needs a reason; the cancelled expense stays visible and is not counted', (tester) async {
    final repo = FakeExpenseRepo(expenses: [makeExpense(id: 'a', name: 'Tea', amount: 3000), makeExpense(id: 'b', name: 'Rent', amount: 500000, category: 'RENT')]);
    await pumpExpense(tester, MoneyFakes(expense: repo));
    expect(find.text('Spent: ₹5,030'), findsOneWidget);
    await tester.tap(find.text('Rent'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel expense'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Cancel expense'));
    await tester.pumpAndSettle();
    expect(find.text('Please write a reason.'), findsOneWidget);
    expect(repo.cancelled, isEmpty);
    await tester.enterText(field('Why is it cancelled?'), 'Paid twice');
    await tester.tap(find.widgetWithText(FilledButton, 'Cancel expense'));
    await tester.pumpAndSettle();
    expect(repo.cancelled.single, (id: 'b', reason: 'Paid twice'));
    expect(find.text('Cancelled'), findsOneWidget);
    expect(find.text('Spent: ₹30'), findsOneWidget);
  });

  testWidgets('edit sends the reason', (tester) async {
    final repo = FakeExpenseRepo(expenses: [makeExpense(id: 'a', name: 'Tea', amount: 3000)]);
    await pumpExpense(tester, MoneyFakes(expense: repo));
    await tester.tap(find.text('Tea'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit expense'));
    await tester.pumpAndSettle();
    await tester.enterText(field('Amount (₹)'), '45');
    await tester.tap(find.text('Save Expense'));
    await tester.pumpAndSettle();
    expect(find.text('Please write a reason.'), findsOneWidget);
    await tester.enterText(field('Why are you changing it?'), 'Wrong amount');
    await tester.tap(find.text('Save Expense'));
    await tester.pumpAndSettle();
    expect(repo.updated.single.reason, 'Wrong amount');
    expect(repo.updated.single.draft.amountPaise, 4500);
  });

  testWidgets('This month asks the server for the 1st to today', (tester) async {
    final repo = FakeExpenseRepo(expenses: [makeExpense(date: '2026-10-03', name: 'Soap')]);
    await pumpExpense(tester, MoneyFakes(expense: repo));
    expect(find.text('Soap'), findsNothing);
    await tester.tap(find.text('This month'));
    await tester.pumpAndSettle();
    expect(repo.listCalls.last, (from: '2026-10-01', to: '2026-10-11'));
    expect(find.text('Soap'), findsOneWidget);
  });

  testWidgets('empty period and a load failure with retry', (tester) async {
    final repo = FakeExpenseRepo()..listError = StateError('offline');
    await pumpExpense(tester, MoneyFakes(expense: repo));
    expect(find.textContaining('Could not load expenses'), findsOneWidget);
    repo.listError = null;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.textContaining('No expenses in this period'), findsOneWidget);
  });

  testWidgets('earlier drawers show counted cash and whether it matched', (tester) async {
    final repo = FakeExpenseRepo()..history = [makeShift(id: 'h1', open: false, counted: 24000, expected: 25000, variance: -1000), makeShift(id: 'h2', open: false, counted: 5000, expected: 5000, variance: 0)];
    await pumpExpense(tester, MoneyFakes(expense: repo));
    expect(find.text('Earlier drawers'), findsOneWidget);
    expect(find.textContaining('Counted ₹240 · ₹10 short'), findsOneWidget);
    expect(find.textContaining('Counted ₹50 · matched'), findsOneWidget);
  });

  testWidgets('small phone, 1.6x text, Hindi-length words: no overflow with the drawer open', (tester) async {
    final repo = FakeExpenseRepo(shift: makeShift(opening: 50000, collections: 123456, expenses: 7890), expenses: [makeExpense(name: 'A very long expense name for the electricity and water bill of the shop')]);
    await pumpExpense(tester, MoneyFakes(expense: repo), textScale: 1.6, size: const Size(360, 640));
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Add Expense'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
