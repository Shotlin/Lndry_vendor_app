import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lndry_vendor_app/features/pos/search/pos_search_page.dart';
import 'package:lndry_vendor_app/models/pos/pos_customer_model.dart';
import 'package:lndry_vendor_app/models/pos/pos_search_model.dart';

import 'pos_harness.dart';
import 'pos_money_fakes.dart';

PosSearchResults sample() => PosSearchResults(
      customers: const [PosCustomer(id: 'u-1', name: 'Asha Verma', phone: '9811122233')],
      orders: [SearchOrder(id: 'o-9', orderNumber: 'LND-261011-AAAA', totalPaise: 16000, placedAt: DateTime.utc(2026, 10, 11))],
      garments: const [SearchGarment(id: 'g1', tagCode: 'ELT-1-AAAA', state: 'IN_PROCESS', orderId: 'o-9')],
    );

void main() {
  testWidgets('before typing: hint, all-customers button, no server call', (tester) async {
    final p = await pumpPos(tester, const PosSearchPage());
    expect(find.text('Type at least 2 letters or numbers to search.'), findsOneWidget);
    expect(find.text('All customers'), findsOneWidget);
    expect(p.money.search.queries, isEmpty);
  });

  testWidgets('one letter does not search; two do, after a short pause; results grouped', (tester) async {
    final money = MoneyFakes()..search.results = sample();
    final p = await pumpPos(tester, const PosSearchPage(), money: money);
    await tester.enterText(find.byType(TextField), 'A');
    await tester.pump(const Duration(seconds: 1));
    expect(money.search.queries, isEmpty);
    await tester.enterText(find.byType(TextField), 'As');
    await tester.pump(const Duration(milliseconds: 100));
    expect(money.search.queries, isEmpty, reason: 'still waiting for the pause');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    expect(money.search.queries, ['As']);
    expect(find.text('Orders'), findsOneWidget);
    expect(find.text('Customers'), findsOneWidget);
    expect(find.text('Garment tags'), findsOneWidget);
    expect(find.text('LND-261011-AAAA'), findsOneWidget);
    expect(find.text('Asha Verma'), findsOneWidget);
    expect(find.textContaining('ELT-1-AAAA'), findsOneWidget);
    expect(p.money.search.queries, hasLength(1));
  });

  testWidgets('a slow old answer never replaces a newer one', (tester) async {
    final slow = Completer<PosSearchResults>();
    final money = MoneyFakes();
    money.search.onSearch = (q) => q == 'Ash' ? slow.future : Future.value(PosSearchResults(customers: const [PosCustomer(id: 'u-2', name: 'Bina Shah', phone: '9000000002')]));
    await pumpPos(tester, const PosSearchPage(), money: money);
    await tester.enterText(find.byType(TextField), 'Ash');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.enterText(find.byType(TextField), 'Bin');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    expect(find.text('Bina Shah'), findsOneWidget);
    slow.complete(sample());
    await tester.pumpAndSettle();
    expect(find.text('Bina Shah'), findsOneWidget);
    expect(find.text('Asha Verma'), findsNothing);
  });

  testWidgets('nothing found says what to do', (tester) async {
    await pumpPos(tester, const PosSearchPage());
    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.textContaining('Nothing found for "zzz"'), findsOneWidget);
  });

  testWidgets('a failure shows a retry that works', (tester) async {
    final money = MoneyFakes()..search.error = StateError('boom');
    await pumpPos(tester, const PosSearchPage(), money: money);
    await tester.enterText(find.byType(TextField), 'Asha');
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.textContaining('Could not search'), findsOneWidget);
    money.search.error = null;
    money.search.results = sample();
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text('Asha Verma'), findsOneWidget);
  });

  testWidgets('tapping an order opens it, a customer opens the profile, a tag opens its order; the search is remembered', (tester) async {
    final money = MoneyFakes()..search.results = sample();
    final p = await pumpPos(tester, const PosSearchPage(), money: money);
    await tester.enterText(find.byType(TextField), 'LND');
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('LND-261011-AAAA'));
    await tester.pumpAndSettle();
    expect(find.text('ORDER DETAIL o-9'), findsOneWidget);
    p.router.pop();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Asha Verma'));
    await tester.pumpAndSettle();
    expect(find.text('CUSTOMER u-1'), findsOneWidget);
    p.router.pop();
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('ELT-1-AAAA'));
    await tester.pumpAndSettle();
    expect(find.text('ORDER DETAIL o-9'), findsOneWidget);
    expect(p.storage.getStringList('pos_recent_searches_v1_v1'), ['LND']);
  });

  testWidgets('recent searches come back, tap to repeat, Clear forgets them', (tester) async {
    final money = MoneyFakes()..search.results = sample();
    final p = await pumpPos(tester, const PosSearchPage(), money: money, prefs: {'pos_recent_searches_v1_v1': ['Asha', '9811']});
    expect(find.text('Recent searches'), findsOneWidget);
    expect(find.text('Asha'), findsOneWidget);
    await tester.tap(find.text('9811'));
    await tester.pumpAndSettle();
    expect(money.search.queries, ['9811']);
    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();
    expect(find.text('Recent searches'), findsNothing);
    expect(p.storage.getStringList('pos_recent_searches_v1_v1'), isNull);
  });

  testWidgets('All customers opens the customers list', (tester) async {
    await pumpPos(tester, const PosSearchPage());
    await tester.tap(find.text('All customers'));
    await tester.pumpAndSettle();
    expect(find.text('CUSTOMERS SCREEN'), findsOneWidget);
  });

  testWidgets('large text and Hindi: no overflow', (tester) async {
    final money = MoneyFakes()..search.results = sample();
    await pumpPos(tester, const PosSearchPage(), money: money, textScale: 1.6, locale: const Locale('hi'), size: const Size(360, 640));
    await tester.enterText(find.byType(TextField), 'Asha');
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Asha Verma'), findsOneWidget);
  });
}
