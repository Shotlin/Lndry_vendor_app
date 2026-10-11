import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:lndry_vendor_app/features/pos/booking/book_order_controller.dart';
import 'package:lndry_vendor_app/features/pos/booking/book_order_state.dart';
import 'package:lndry_vendor_app/models/pos/pos_catalogue_model.dart';
import 'package:lndry_vendor_app/models/pos/pos_order_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fakes.dart';
import 'pos_fakes.dart';

final _now = DateTime(2026, 10, 11, 10);

Future<({BookOrderController c, FakeCounterRepo repo, MemStorage storage, List<String> keys})> make({
  Map<String, Object> prefs = const {},
  FakeCounterRepo? repo,
  Duration delay = const Duration(milliseconds: 5),
}) async {
  SharedPreferences.setMockInitialValues(prefs);
  final storage = MemStorage(prefs: await SharedPreferences.getInstance());
  final r = repo ?? FakeCounterRepo();
  final keys = <String>[];
  var n = 0;
  final c = BookOrderController(
    repo: r,
    storage: storage,
    vendorId: 'v1',
    now: () => _now,
    quoteDelay: delay,
    newKey: () {
      final k = 'key-${++n}';
      keys.add(k);
      return k;
    },
  );
  addTearDown(c.dispose);
  return (c: c, repo: r, storage: storage, keys: keys);
}

Future<void> pause([int ms = 40]) => Future<void>.delayed(Duration(milliseconds: ms));

void main() {
  group('choices', () {
    test('default delivery date is 2 days after today', () async {
      final t = await make();
      expect(t.c.state.expectedDate, '2026-10-13');
    });

    test('Home Delivery and Pickup toggle on/off and exclude each other', () async {
      final t = await make();
      t.c.toggleDeliveryMode(DeliveryMode.homeDelivery);
      expect(t.c.state.deliveryMode, DeliveryMode.homeDelivery);
      t.c.toggleDeliveryMode(DeliveryMode.pickup);
      expect(t.c.state.deliveryMode, DeliveryMode.pickup);
      t.c.toggleDeliveryMode(DeliveryMode.pickup);
      expect(t.c.state.deliveryMode, DeliveryMode.walkIn);
    });

    test('express is independent of the delivery mode', () async {
      final t = await make();
      t.c.toggleDeliveryMode(DeliveryMode.homeDelivery);
      t.c.setExpress(value: true);
      expect(t.c.state.isExpress, isTrue);
      expect(t.c.state.deliveryMode, DeliveryMode.homeDelivery);
    });
  });

  group('cart', () {
    test('add increments, stepper changes qty, zero removes', () async {
      final t = await make();
      t.c.selectService('s-dry');
      t.c.add('g-shirt');
      t.c.add('g-shirt');
      expect(t.c.state.qtyOf('g-shirt', 's-dry'), 2);
      t.c.setQty('g-shirt', 's-dry', 5);
      expect(t.c.state.totalQty, 5);
      t.c.setQty('g-shirt', 's-dry', 0);
      expect(t.c.state.lines, isEmpty);
    });

    test('same garment in two services are two lines', () async {
      final t = await make();
      t.c.selectService('s-dry');
      t.c.add('g-shirt');
      t.c.selectService('s-wash');
      t.c.add('g-shirt');
      expect(t.c.state.lines.length, 2);
      expect(t.c.state.qtyOf('g-shirt', 's-dry'), 1);
      expect(t.c.state.qtyOf('g-shirt', 's-wash'), 1);
    });

    test('add does nothing before a service is chosen', () async {
      final t = await make();
      t.c.add('g-shirt');
      expect(t.c.state.lines, isEmpty);
    });

    test('a line keeps its place while the stepper changes it', () async {
      final t = await make();
      t.c.setQty('g-shirt', 's-dry', 1);
      t.c.setQty('g-saree', 's-dry', 1);
      t.c.setQty('g-shirt', 's-dry', 3);
      expect(t.c.state.lines.map((l) => l.garmentId), ['g-shirt', 'g-saree']);
    });
  });

  group('server quote', () {
    test('rapid taps send ONE quote for the final cart (debounce)', () async {
      final t = await make();
      t.c.selectService('s-dry');
      t.c.add('g-shirt');
      t.c.add('g-shirt');
      t.c.add('g-shirt');
      await pause();
      expect(t.repo.quoteRequests.length, 1);
      expect(t.repo.quoteRequests.single.lines.single.qty, 3);
      expect(t.c.state.quoteStatus, QuoteStatus.ready);
      expect(t.c.state.quote!.totalPaise, 24000);
    });

    test('the screen shows the server total, not a local one', () async {
      final t = await make();
      t.repo.onQuote = (r) async => PosQuote(
            lines: const [],
            subtotalPaise: 24000,
            chargesPaise: 0,
            discountsPaise: 2400,
            taxPaise: 3888,
            taxRateBps: 1800,
            totalPaise: 25488,
          );
      t.c.setQty('g-shirt', 's-dry', 3);
      await pause();
      expect(t.c.state.quote!.totalPaise, 25488);
    });

    test('an older, slower answer never overwrites a newer cart', () async {
      final t = await make(delay: Duration.zero);
      final first = Completer<PosQuote>();
      var call = 0;
      t.repo.onQuote = (r) {
        call++;
        return call == 1 ? first.future : Future.value(priceLikeServer(r));
      };
      t.c.setQty('g-shirt', 's-dry', 1); // slow answer pending
      t.c.setQty('g-shirt', 's-dry', 2); // newer cart answers first
      await pause(10);
      expect(t.c.state.quote!.totalPaise, 16000);
      first.complete(priceLikeServer(const OrderRequest(lines: [CartLine(garmentId: 'g-shirt', serviceId: 's-dry', qty: 1)])));
      await pause(10);
      expect(t.c.state.quote!.totalPaise, 16000, reason: 'the old 1-shirt answer (8000) must be ignored');
    });

    test('emptying the cart clears the quote and sends nothing', () async {
      final t = await make();
      t.c.setQty('g-shirt', 's-dry', 1);
      await pause();
      t.c.setQty('g-shirt', 's-dry', 0);
      await pause();
      expect(t.c.state.quote, isNull);
      expect(t.c.state.quoteStatus, QuoteStatus.idle);
      expect(t.repo.quoteRequests.length, 1);
    });

    test('a failed quote is shown in plain words and can be retried', () async {
      final t = await make();
      t.repo.onQuote = (r) async => throw Exception('boom');
      t.c.setQty('g-shirt', 's-dry', 1);
      await pause();
      expect(t.c.state.quoteStatus, QuoteStatus.failed);
      expect(t.c.state.quoteError, isNotNull);
      expect(t.c.state.canSave, isFalse);
      t.repo.onQuote = null;
      t.c.retryQuote();
      await pause();
      expect(t.c.state.quoteStatus, QuoteStatus.ready);
    });

    test('delivery date, payment and remarks do not trigger a new quote', () async {
      final t = await make();
      t.c.setQty('g-shirt', 's-dry', 1);
      await pause();
      t.c.setDate(DateTime(2026, 10, 20));
      t.c.setPayment(PosPaymentMode.cash);
      t.c.setNotes('Fold nicely');
      t.c.toggleDeliveryMode(DeliveryMode.homeDelivery);
      t.c.setExpress(value: true);
      await pause();
      expect(t.repo.quoteRequests.length, 1);
    });

    test('rules, GST and customer do trigger a new quote with the right body', () async {
      final t = await make();
      t.c.setQty('g-shirt', 's-dry', 1);
      await pause();
      t.c.toggleCharge('ch-1');
      await pause();
      t.c.toggleDiscount('di-1');
      await pause();
      t.c.selectTax(const PosTaxRule(id: 't1', name: 'GST 18%', rateBps: 1800));
      await pause();
      t.c.setCustomer(sampleCustomer);
      await pause();
      final last = t.repo.quoteRequests.last.toJson();
      expect(last['chargeRuleIds'], ['ch-1']);
      expect(last['discountRuleIds'], ['di-1']);
      expect(last['taxRatePercent'], 18);
      expect((last['customer'] as Map)['id'], 'u-1');
      expect(t.repo.quoteRequests.length, 5);
    });
  });

  group('canSave', () {
    test('needs a customer, a non-empty cart and a quote for exactly this cart', () async {
      final t = await make();
      expect(t.c.state.canSave, isFalse);
      t.c.setQty('g-shirt', 's-dry', 1);
      await pause();
      expect(t.c.state.canSave, isFalse, reason: 'no customer yet');
      t.c.setCustomer(sampleCustomer);
      await pause();
      expect(t.c.state.canSave, isTrue);
      t.c.setQty('g-shirt', 's-dry', 2);
      expect(t.c.state.canSave, isFalse, reason: 'cart changed, the old quote no longer matches');
      await pause();
      expect(t.c.state.canSave, isTrue);
    });

    test('save does nothing while it cannot save', () async {
      final t = await make();
      expect(await t.c.save(), isNull);
      expect(t.repo.bookCalls, isEmpty);
    });
  });

  group('save', () {
    Future<({BookOrderController c, FakeCounterRepo repo, MemStorage storage, List<String> keys})> ready() async {
      final t = await make();
      t.c.setCustomer(sampleCustomer);
      t.c.selectService('s-dry');
      t.c.add('g-shirt');
      t.c.setPayment(PosPaymentMode.cash);
      t.c.toggleDeliveryMode(DeliveryMode.homeDelivery);
      t.c.setExpress(value: true);
      t.c.setNotes('  Fold nicely ');
      await pause();
      return t;
    }

    test('books with the cart, flags, payment and an idempotency key; clears the draft', () async {
      final t = await ready();
      expect(t.storage.getString(draftKeyFor('v1')), isNotNull);
      final order = await t.c.save();
      expect(order!.orderNumber, 'LND-261011-TEST');
      final call = t.repo.bookCalls.single;
      expect(call.key, 'key-1');
      final body = call.request.toJson();
      expect(body['paymentMode'], 'CASH');
      expect(body['deliveryMode'], 'HOME_DELIVERY');
      expect(body['isExpress'], true);
      expect(body['notes'], 'Fold nicely');
      expect(body['expectedDeliveryDate'], '2026-10-13');
      expect(body['items'], [
        {'garmentId': 'g-shirt', 'serviceId': 's-dry', 'qty': 1}
      ]);
      expect(t.c.state.booked, isNotNull);
      expect(t.c.state.saving, isFalse);
      expect(t.storage.getString(draftKeyFor('v1')), isNull, reason: 'a booked order must not come back as a draft');
    });

    test('double tap books once', () async {
      final t = await ready();
      final gate = Completer<BookedOrder>();
      t.repo.onBook = (r, k) => gate.future;
      final first = t.c.save();
      final second = await t.c.save();
      expect(second, isNull);
      expect(t.c.state.saving, isTrue);
      gate.complete(BookedOrder(id: 'o', orderNumber: 'X', totalPaise: 1, amountPaidPaise: 0, paymentStatus: 'UNPAID', status: 'BOOKED', customer: sampleCustomer));
      await first;
      expect(t.repo.bookCalls.length, 1);
    });

    test('a failed save keeps the cart and a retry of the SAME order reuses the key', () async {
      final t = await ready();
      t.repo.onBook = (r, k) async => throw Exception('network');
      expect(await t.c.save(), isNull);
      expect(t.c.state.saveError, isNotNull);
      expect(t.c.state.lines, isNotEmpty);
      expect(t.c.state.booked, isNull);
      // touching only the garment search box must not make it a "different" order
      t.c.setSearch('shi');
      t.repo.onBook = null;
      await t.c.save();
      expect(t.repo.bookCalls.map((c) => c.key), ['key-1', 'key-1']);
    });

    test('changing the order gives it a new key', () async {
      final t = await ready();
      t.repo.onBook = (r, k) async => throw Exception('network');
      await t.c.save();
      t.c.setQty('g-shirt', 's-dry', 4);
      await pause();
      t.repo.onBook = null;
      await t.c.save();
      expect(t.repo.bookCalls.map((c) => c.key), ['key-1', 'key-2']);
    });

    test('Book Another resets everything', () async {
      final t = await ready();
      await t.c.save();
      t.c.reset();
      expect(t.c.state.lines, isEmpty);
      expect(t.c.state.customer, isNull);
      expect(t.c.state.booked, isNull);
      expect(t.c.state.paymentMode, PosPaymentMode.payLater);
      expect(t.c.state.serviceId, 's-dry', reason: 'the chosen service is convenient to keep');
    });
  });

  group('draft', () {
    test('the cart survives closing and reopening the screen', () async {
      final t = await make();
      t.c.setCustomer(sampleCustomer);
      t.c.selectService('s-wash');
      t.c.add('g-shirt');
      t.c.add('g-shirt');
      t.c.setPayment(PosPaymentMode.online);
      t.c.toggleDeliveryMode(DeliveryMode.pickup);
      t.c.setNotes('Stain on collar');
      t.c.setDate(DateTime(2026, 10, 25));
      await pause();
      final raw = t.storage.getString(draftKeyFor('v1'))!;

      final again = await make(prefs: {draftKeyFor('v1'): raw});
      final s = again.c.state;
      expect(s.customer!.phone, '9811122233');
      expect(s.qtyOf('g-shirt', 's-wash'), 2);
      expect(s.paymentMode, PosPaymentMode.online);
      expect(s.deliveryMode, DeliveryMode.pickup);
      expect(s.notes, 'Stain on collar');
      expect(s.expectedDate, '2026-10-25');
      await pause();
      expect(again.repo.quoteRequests.length, 1, reason: 'the restored cart is priced again');
      expect(again.c.state.canSave, isTrue);
    });

    test('a past delivery date is replaced by the default', () async {
      final raw = jsonEncode({
        'date': '2026-10-01',
        'lines': [
          {'garmentId': 'g-shirt', 'serviceId': 's-dry', 'qty': 1}
        ],
      });
      final t = await make(prefs: {draftKeyFor('v1'): raw});
      expect(t.c.state.expectedDate, '2026-10-13');
    });

    test('a damaged draft is ignored and removed', () async {
      final t = await make(prefs: {draftKeyFor('v1'): '{not json'});
      expect(t.c.state.lines, isEmpty);
      await pause();
      expect(t.storage.getString(draftKeyFor('v1')), isNull);
    });

    test('drafts are per shop', () async {
      final t = await make(prefs: {draftKeyFor('other-shop'): jsonEncode({'notes': 'x', 'lines': []})});
      expect(t.c.state.notes, '');
    });

    test('an emptied cart removes the draft', () async {
      final t = await make();
      t.c.setQty('g-shirt', 's-dry', 1);
      await pause();
      expect(t.storage.getString(draftKeyFor('v1')), isNotNull);
      t.c.setQty('g-shirt', 's-dry', 0);
      await pause();
      expect(t.storage.getString(draftKeyFor('v1')), isNull);
    });
  });

  group('reconcile with the price list', () {
    test('drops lines whose price disappeared and picks a first service', () async {
      final t = await make();
      t.c.setQty('g-shirt', 's-dry', 1);
      t.c.setQty('g-saree', 's-wash', 1); // no such price in the sample list
      t.c.setQty('g-gone', 's-dry', 1);
      final dropped = t.c.reconcile(sampleCatalogue());
      expect(dropped, 2);
      expect(t.c.state.lines.single.garmentId, 'g-shirt');
      expect(t.c.state.serviceId, 's-dry');
    });

    test('nothing to change → nothing sent', () async {
      final t = await make();
      t.c.selectService('s-dry');
      t.c.setQty('g-shirt', 's-dry', 1);
      await pause();
      final before = t.repo.quoteRequests.length;
      expect(t.c.reconcile(sampleCatalogue()), 0);
      await pause();
      expect(t.repo.quoteRequests.length, before);
    });

    test('rules the shop no longer has are dropped', () async {
      final t = await make();
      t.c.setQty('g-shirt', 's-dry', 1);
      t.c.toggleDiscount('old');
      t.c.toggleCharge('keep');
      t.c.reconcileRules(chargeIds: {'keep'}, discountIds: {});
      expect(t.c.state.discountRuleIds, isEmpty);
      expect(t.c.state.chargeRuleIds, ['keep']);
    });
  });
}
