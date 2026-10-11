import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lndry_vendor_app/features/pos/whatsapp/whatsapp_sheet.dart';
import 'package:lndry_vendor_app/features/pos/whatsapp/whatsapp_templates.dart';
import 'package:lndry_vendor_app/models/pos/pos_settings_model.dart';

import 'pos_fakes.dart';
import 'pos_harness.dart';
import 'pos_money_fakes.dart';

Widget host(List orders, {String phone = '9811122233'}) => Builder(
      builder: (context) => Scaffold(
        body: Center(
          child: FilledButton(
            onPressed: () => showWhatsAppSheet(context, customerName: 'Asha Verma', phone: phone, orders: List.of(orders.cast())),
            child: const Text('OPEN'),
          ),
        ),
      ),
    );

void main() {
  group('fillTemplate', () {
    test('fills known placeholders; unknown ones disappear instead of showing {Like}', () {
      expect(fillTemplate('Hi {CustomerName}, {InvoiceUrl}\nBye', {'CustomerName': 'Asha'}), 'Hi Asha,\nBye');
    });
    test('repeated placeholder and blank-line tidy', () {
      expect(fillTemplate('{Brand} {Brand}\n\n\n\nEnd {Missing}', {'Brand': 'Sparkle'}), 'Sparkle Sparkle\n\nEnd');
    });
  });

  test('a template is filled from the SERVER\'s order numbers', () {
    final o = makeOrder(number: 'LND-77', total: 16000, paid: 5000, expected: '2026-10-13');
    final msg = buildTemplateMessage(kDefaultMessageTemplates[2], o, shopName: 'Sparkle', dateText: (d) => 'D:$d');
    expect(msg, contains('Hello Asha Verma, your Sparkle order #LND-77 is ready for collection.'));
    expect(msg, contains('Items: 2'));
    expect(msg, contains('Balance due: ₹110'));
    expect(msg, isNot(contains('{')));
  });

  testWidgets('a saved message opens WhatsApp with the text ready (spaces as %20)', (tester) async {
    final o = makeOrder(number: 'LND-77', total: 16000, paid: 5000);
    final p = await pumpPos(tester, host([o]));
    await tester.tap(find.text('OPEN'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Order Done'));
    await tester.pumpAndSettle();
    final uri = p.opened.single;
    expect(uri.host, 'wa.me');
    expect(uri.path, '/919811122233');
    expect(Uri.decodeComponent(uri.query.substring(5)), contains('order #LND-77 is ready for collection'));
    expect(uri.toString(), isNot(contains('+')));
    expect(find.text('Message Asha Verma'), findsNothing, reason: 'sheet closes after opening WhatsApp');
  });

  testWidgets('payment reminder only appears when money is due, and carries the balance', (tester) async {
    final paid = makeOrder(total: 8000, paid: 8000);
    await pumpPos(tester, host([paid]));
    await tester.tap(find.text('OPEN'));
    await tester.pumpAndSettle();
    expect(find.text('Payment reminder'), findsNothing);

    final due = makeOrder(total: 16000, paid: 5000);
    final p = await pumpPos(tester, host([due]));
    await tester.tap(find.text('OPEN'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Payment reminder'));
    await tester.pumpAndSettle();
    expect(Uri.decodeComponent(p.opened.single.query), contains('₹110'));
  });

  testWidgets('no orders: only a plain chat; cancelled orders are not talked about', (tester) async {
    await pumpPos(tester, host([makeOrder(status: 'CANCELLED')]));
    await tester.tap(find.text('OPEN'));
    await tester.pumpAndSettle();
    expect(find.textContaining('has no order yet'), findsOneWidget);
    expect(find.text('Order Done'), findsNothing);
    expect(find.text('Just open the chat'), findsOneWidget);
  });

  testWidgets('the shop\'s own wording is used when saved', (tester) async {
    final money = MoneyFakes()..settings.templates = const [MessageTemplate(key: 'order-done', label: 'Ready!', body: 'Ready: {OrderNo}')];
    final p = await pumpPos(tester, host([makeOrder(number: 'LND-5')]), money: money);
    await tester.tap(find.text('OPEN'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ready!'));
    await tester.pumpAndSettle();
    expect(Uri.decodeComponent(p.opened.single.query), 'text=Ready: LND-5');
  });

  testWidgets('WhatsApp missing on the phone: a plain sentence, sheet stays', (tester) async {
    final p = await pumpPos(tester, host([makeOrder()]), openerWorks: false);
    await tester.tap(find.text('OPEN'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Just open the chat'));
    await tester.pumpAndSettle();
    expect(find.text('Could not open WhatsApp.'), findsOneWidget);
    expect(p.opened, hasLength(1));
    expect(find.text('Message Asha Verma'), findsOneWidget);
  });

  testWidgets('templates that fail to load show retry; the plain chat still works', (tester) async {
    final money = MoneyFakes()..settings.templatesError = StateError('offline');
    await pumpPos(tester, host([makeOrder()]), money: money);
    await tester.tap(find.text('OPEN'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Could not load your saved messages'), findsOneWidget);
    expect(find.text('Just open the chat'), findsOneWidget);
  });
}
