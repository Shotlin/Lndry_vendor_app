import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lndry_vendor_app/features/pos/core/pos_settings_lists.dart';
import 'package:lndry_vendor_app/features/pos/core/pos_settings_page.dart';
import 'package:lndry_vendor_app/l10n/generated/app_localizations.dart';
import 'package:lndry_vendor_app/models/pos/pos_catalogue_model.dart';
import 'package:lndry_vendor_app/models/pos/pos_settings_model.dart';
import 'package:lndry_vendor_app/providers/locale_provider.dart';

import 'pos_fakes.dart';
import 'pos_harness.dart';
import 'pos_money_fakes.dart';

void main() {
  testWidgets('shows my-shop and this-app sections with plain-word tiles', (tester) async {
    await pumpPos(tester, const PosSettingsPage(), size: const Size(390, 1600));
    for (final t in ['My shop', 'Customers', 'Price list', 'Extra charges and discounts', 'WhatsApp messages', 'Team', 'This app', 'Language']) {
      expect(find.text(t), findsWidgets, reason: t);
    }
  });

  testWidgets('staff without catalogue rights never see Price list', (tester) async {
    await pumpPos(tester, const PosSettingsPage(), canManage: false);
    expect(find.text('Price list'), findsNothing);
    expect(find.text('Customers'), findsWidgets);
  });

  testWidgets('Customers opens the customers screen', (tester) async {
    await pumpPos(tester, const PosSettingsPage());
    await tester.tap(find.text('Customers').first);
    await tester.pumpAndSettle();
    expect(find.text('CUSTOMERS SCREEN'), findsOneWidget);
  });

  testWidgets('Price list opens Add Garment Price (which can also create a new garment)', (tester) async {
    await pumpPos(tester, const PosSettingsPage());
    await tester.tap(find.text('Price list'));
    await tester.pumpAndSettle();
    expect(find.text('Add Garment Price'), findsWidgets);
  });

  testWidgets('language: pick Hinglish and the setting changes and is remembered', (tester) async {
    final p = await pumpPos(tester, const PosSettingsPage(), size: const Size(390, 1600));
    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hinglish').last);
    await tester.pumpAndSettle();
    final l = p.c.read(localeProvider);
    expect(l.languageCode, 'hi');
    expect(l.scriptCode, 'Latn');
  });

  testWidgets('team page: roles in words, phone only when there is a name, inactive marked', (tester) async {
    final money = MoneyFakes()
      ..settings.team = const [
        PosStaffMember(id: '1', name: 'Raj Kumar', phone: '9000000001', role: 'VENDOR_OWNER', active: true),
        PosStaffMember(id: '2', name: '', phone: '9000000002', role: 'VENDOR_RIDER', active: false),
      ];
    await pumpPos(tester, const PosTeamPage(), money: money);
    expect(find.text('Raj Kumar'), findsOneWidget);
    expect(find.text('Owner · 9000000001'), findsOneWidget);
    expect(find.textContaining('Captain'), findsOneWidget);
    expect(find.textContaining('Not active'), findsOneWidget);
  });

  testWidgets('messages page shows the words customers receive', (tester) async {
    await pumpPos(tester, const PosMessagesPage());
    expect(find.text('Order Booked'), findsOneWidget);
    expect(find.textContaining('{OrderNo}'), findsWidgets);
  });

  testWidgets('messages and team failures offer retry', (tester) async {
    final money = MoneyFakes()
      ..settings.templatesError = StateError('x')
      ..settings.staffError = StateError('x');
    await pumpPos(tester, const PosMessagesPage(), money: money);
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('rule values are written in words: flat rupees, percent with decimals', (tester) async {
    late String flat, pct, whole;
    await pumpPos(tester, Builder(builder: (context) {
      final l10n = AppLocalizations.of(context);
      flat = ruleValueText(l10n, const PosAdjustmentRule(id: '1', name: 'a', isPercentage: false, flatPaise: 5000));
      pct = ruleValueText(l10n, const PosAdjustmentRule(id: '2', name: 'b', isPercentage: true, percentageBps: 750));
      whole = ruleValueText(l10n, const PosAdjustmentRule(id: '3', name: 'c', isPercentage: true, percentageBps: 1000));
      return const SizedBox();
    }));
    expect(flat, '₹50 flat');
    expect(pct, '7.5% of the bill');
    expect(whole, '10% of the bill');
  });

  testWidgets('rules page lists charges and discounts', (tester) async {
    final cat = FakeCatalogueRepo();
    await pumpPos(tester, const PosRulesPage(), catalogue: cat);
    expect(find.text('Extra charges'), findsOneWidget);
    expect(find.text('Discounts'), findsOneWidget);
  });

  testWidgets('small phone, large text: no overflow', (tester) async {
    await pumpPos(tester, const PosSettingsPage(), textScale: 1.6, size: const Size(360, 640));
    expect(tester.takeException(), isNull);
  });
}
