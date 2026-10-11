import 'package:flutter/widgets.dart' show Locale;
import 'package:flutter_test/flutter_test.dart';
import 'package:lndry_vendor_app/features/pos/core/pos_widgets.dart';
import 'package:lndry_vendor_app/features/pos/orders/order_state.dart';
import 'package:lndry_vendor_app/features/pos/orders/whatsapp.dart';
import 'package:lndry_vendor_app/l10n/generated/app_localizations.dart';
import 'package:lndry_vendor_app/models/pos/pos_customer_model.dart';
import 'package:lndry_vendor_app/models/pos/pos_order_model.dart';

import 'pos_fakes.dart';

void main() {
  group('phase = backend status + payment status (Master Plan §5)', () {
    // status, payment status → phase
    const table = <(String, String, OrderPhase)>[
      ('BOOKED', 'UNPAID', OrderPhase.booked),
      ('BOOKED', 'PAID', OrderPhase.booked),
      ('PICKED_UP', 'UNPAID', OrderPhase.booked),
      ('IN_PROCESS', 'PART_PAID', OrderPhase.processing),
      ('READY', 'UNPAID', OrderPhase.ready),
      ('OUT_FOR_DELIVERY', 'PAID', OrderPhase.outForDelivery),
      ('DELIVERED', 'UNPAID', OrderPhase.delivered),
      ('DELIVERED', 'PART_PAID', OrderPhase.delivered),
      (
        'DELIVERED',
        'PAID',
        OrderPhase.complete
      ), // "Order Complete" = delivered AND paid
      ('CANCELLED', 'PAID', OrderPhase.cancelled),
      ('CANCELLED', 'UNPAID', OrderPhase.cancelled),
      ('SOMETHING_NEW', 'PAID', OrderPhase.unknown),
    ];
    for (final (status, pay, phase) in table) {
      test('$status + $pay → $phase',
          () => expect(orderPhaseOf(status, pay), phase));
    }

    test(
        'every phase has a tone, and colour is never the only signal (a label exists in every language)',
        () {
      for (final p in OrderPhase.values) {
        expect(toneOfPhase(p), isA<PosTone>());
      }
      expect(toneOfPhase(OrderPhase.cancelled), PosTone.danger);
      expect(toneOfPhase(OrderPhase.complete), PosTone.success);
      expect(toneOfPayment('PAID'), PosTone.success);
      expect(toneOfPayment('PART_PAID'), PosTone.attention);
      expect(toneOfPayment('UNPAID'), PosTone.danger);
    });
  });

  group('what can be done to an order', () {
    test(
        'open orders can be edited, cancelled and collected on; finished ones cannot (except collecting a balance)',
        () {
      for (final s in [
        'BOOKED',
        'PICKED_UP',
        'IN_PROCESS',
        'READY',
        'OUT_FOR_DELIVERY'
      ]) {
        final o = makeOrder(status: s, paid: 1000);
        expect(o.canEdit && o.canCancel && o.canCollect, isTrue, reason: s);
        expect(o.isClosed, isFalse);
      }
      final delivered = makeOrder(status: 'DELIVERED', paid: 1000);
      expect(delivered.isClosed, isTrue);
      expect(delivered.canEdit, isFalse);
      expect(delivered.canCancel, isFalse);
      expect(delivered.canCollect, isTrue,
          reason:
              'a delivered order that still owes money can be collected on');
      final cancelled = makeOrder(status: 'CANCELLED', paid: 0);
      expect(cancelled.canCollect, isFalse);
      expect(cancelled.balancePaise, 0,
          reason: 'a cancelled order owes nothing');
      expect(makeOrder(status: 'DELIVERED', paid: 16000).canCollect, isFalse);
    });

    test(
        'the A4 invoice exists only after delivery; the mini bill until the order is cancelled',
        () {
      expect([
        for (final s in [
          'BOOKED',
          'IN_PROCESS',
          'READY',
          'OUT_FOR_DELIVERY',
          'DELIVERED',
          'CANCELLED'
        ])
          makeOrder(status: s).hasInvoice
      ], [
        false,
        false,
        false,
        false,
        true,
        false
      ]);
      expect([
        for (final s in [
          'BOOKED',
          'IN_PROCESS',
          'READY',
          'OUT_FOR_DELIVERY',
          'DELIVERED',
          'CANCELLED'
        ])
          makeOrder(status: s).hasMiniBill
      ], [
        true,
        true,
        true,
        true,
        true,
        false
      ]);
    });
  });

  group('the next step', () {
    test(
        'Booked → Processing → Ready → (Out for delivery →) Delivered, then nothing',
        () {
      expect(nextStepOf(makeOrder(status: 'BOOKED')),
          const NextStep(NextStepKind.startProcessing, 'IN_PROCESS'));
      expect(nextStepOf(makeOrder(status: 'PICKED_UP')),
          const NextStep(NextStepKind.startProcessing, 'IN_PROCESS'));
      expect(nextStepOf(makeOrder(status: 'IN_PROCESS')),
          const NextStep(NextStepKind.markReady, 'READY'));
      expect(nextStepOf(makeOrder(status: 'READY')),
          const NextStep(NextStepKind.deliver, 'DELIVERED'));
      expect(nextStepOf(makeOrder(status: 'READY', mode: DeliveryMode.pickup)),
          const NextStep(NextStepKind.deliver, 'DELIVERED'));
      expect(
          nextStepOf(makeOrder(
              status: 'OUT_FOR_DELIVERY', mode: DeliveryMode.homeDelivery)),
          const NextStep(NextStepKind.deliver, 'DELIVERED'));
      expect(nextStepOf(makeOrder(status: 'DELIVERED')), isNull);
      expect(nextStepOf(makeOrder(status: 'CANCELLED')), isNull);
    });

    test('a ready HOME DELIVERY order goes out for delivery first', () {
      expect(
          nextStepOf(
              makeOrder(status: 'READY', mode: DeliveryMode.homeDelivery)),
          const NextStep(NextStepKind.sendOut, 'OUT_FOR_DELIVERY'));
    });

    test(
        'every step the app sends is a move the backend allows (BOOKED→IN_PROCESS→READY→OUT_FOR_DELIVERY|DELIVERED→DELIVERED)',
        () {
      // The server's NEXT_STATES, copied from vendor-counter-orders.service.js.
      const allowed = {
        'BOOKED': ['PICKED_UP', 'IN_PROCESS', 'CANCELLED'],
        'PICKED_UP': ['IN_PROCESS', 'CANCELLED'],
        'IN_PROCESS': ['READY', 'CANCELLED'],
        'READY': ['OUT_FOR_DELIVERY', 'DELIVERED', 'CANCELLED'],
        'OUT_FOR_DELIVERY': ['DELIVERED', 'READY'],
      };
      for (final s in allowed.keys) {
        for (final mode in DeliveryMode.values) {
          final step = nextStepOf(makeOrder(status: s, mode: mode))!;
          expect(allowed[s], contains(step.targetState), reason: '$s/$mode');
        }
      }
    });
  });

  group('tabs', () {
    test('Booked / In Process / Done cover every OPEN status exactly once', () {
      final all = [for (final t in OrderTab.values) ...t.statuses];
      expect(all.toSet(),
          {'BOOKED', 'PICKED_UP', 'IN_PROCESS', 'READY', 'OUT_FOR_DELIVERY'});
      expect(all.length, all.toSet().length);
    });
  });

  group('timeline progress', () {
    int pct(String status, int paid) =>
        progressPercent(makeOrder(status: status, paid: paid, total: 16000));

    test('20 / 40 / 60 / 80 / 100 along the way', () {
      expect(pct('BOOKED', 0), 20);
      expect(pct('IN_PROCESS', 0), 40);
      expect(pct('READY', 0), 60);
      expect(pct('OUT_FOR_DELIVERY', 0), 60);
      expect(pct('DELIVERED', 0), 80);
      expect(pct('DELIVERED', 16000), 100);
    });
    test('a cancelled order is at 0 and has no stages reached', () {
      expect(pct('CANCELLED', 5000), 0);
      expect(stagesReached(makeOrder(status: 'CANCELLED')), 0);
    });
    test('paid in full but not delivered is NOT complete',
        () => expect(pct('READY', 16000), 60));
    test('the stages are the five the screen shows',
        () => expect(OrderStage.values.length, 5));
  });

  group('server fields → balance (never computed from items)', () {
    test('balance = total − paid, never negative', () {
      expect(makeOrder(total: 16000, paid: 5000).balancePaise, 11000);
      expect(makeOrder(total: 16000, paid: 16000).balancePaise, 0);
      expect(makeOrder(total: 16000, paid: 20000).balancePaise, 0);
    });
  });

  group('WhatsApp', () {
    test('a 10-digit Indian number gets 91',
        () => expect(whatsAppNumber('9811122233'), '919811122233'));
    test('+91, spaces, dashes and a leading 0 are cleaned up', () {
      expect(whatsAppNumber('+91 98111-22233'), '919811122233');
      expect(whatsAppNumber('09811122233'), '919811122233');
      expect(whatsAppNumber('919811122233'), '919811122233');
    });
    test('no usable number → null (no dead button)', () {
      expect(whatsAppNumber(''), isNull);
      expect(whatsAppNumber('12345'), isNull);
      expect(whatsAppUri('abc', 'hi'), isNull);
    });
    test('the link is wa.me/<number>?text=<message>, the message encoded', () {
      final u = whatsAppUri('9811122233', 'Hello & thanks 100%')!;
      expect(u.host, 'wa.me');
      expect(u.path, '/919811122233');
      expect(u.queryParameters['text'], 'Hello & thanks 100%');
      expect(u.toString(), contains('text=Hello%20%26%20thanks%20100%25'));
    });

    test(
        'message: says who, which order, the state in words and the server\'s balance — in English and Hindi',
        () {
      final en = lookupAppLocalizations(const Locale('en'));
      final hi = lookupAppLocalizations(const Locale('hi'));
      final due = makeOrder(
          number: 'LND-1', status: 'IN_PROCESS', total: 23000, paid: 5000);
      final m =
          buildWhatsAppMessage(en, order: due, shopName: 'Sparkle Laundry');
      expect(
          m,
          allOf(
              contains('Asha Verma'),
              contains('LND-1'),
              contains('Processing'),
              contains('₹230'),
              contains('₹180'),
              contains('Sparkle Laundry')));
      expect(
          buildWhatsAppMessage(hi, order: due, shopName: 'Sparkle Laundry'),
          allOf(contains('Asha Verma'), contains('प्रोसेस में'),
              contains('₹180')));
      final paid = makeOrder(
          number: 'LND-2', status: 'DELIVERED', total: 23000, paid: 23000);
      final p = buildWhatsAppMessage(en, order: paid, shopName: '');
      expect(
          p,
          allOf(contains('Order Complete'), contains('fully paid'),
              contains('LNDRY'), isNot(contains('balance'))));
    });

    test(
        'a customer with no name is greeted politely, not with their phone number as a name',
        () {
      final en = lookupAppLocalizations(const Locale('en'));
      final o = makeOrder(
          customer: const PosCustomer(id: 'u', name: '', phone: '9811122233'));
      expect(buildWhatsAppMessage(en, order: o, shopName: 'S'),
          startsWith('Hello there,'));
    });
  });
}
