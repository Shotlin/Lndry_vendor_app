import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lndry_vendor_app/api/repositories/api_pos_repositories.dart';
import 'package:lndry_vendor_app/core/network/api_exception.dart';
import 'package:lndry_vendor_app/features/pos/orders/order_errors.dart';
import 'package:lndry_vendor_app/features/pos/orders/order_state.dart';
import 'package:lndry_vendor_app/features/pos/orders/orders_providers.dart';
import 'package:lndry_vendor_app/models/pos/pos_counter_order_model.dart';

import 'pos_fakes.dart';

List<CounterOrder> many(int n, {String status = 'BOOKED'}) => [
      for (var i = 0; i < n; i++)
        makeOrder(id: 'o$i', number: 'N$i', status: status)
    ];

Future<void> settle() => Future<void>.delayed(Duration.zero);

ProviderContainer container(FakeOrdersRepo repo) {
  final c = ProviderContainer(overrides: [
    posOrdersRepositoryProvider.overrideWithValue(repo),
    posDashboardRepositoryProvider.overrideWithValue(FakeDashboardRepo())
  ]);
  addTearDown(c.dispose);
  return c;
}

OrdersListController list(FakeOrdersRepo repo,
        {OrderFilter filter = const OrderFilter(), int pageSize = 3}) =>
    OrdersListController(repo, filter, pageSize: pageSize);

void main() {
  group('list: paging', () {
    test('the first page loads; a FULL page means there may be more', () async {
      final repo = FakeOrdersRepo(orders: many(7));
      final c = list(repo);
      expect(c.state.loading, isTrue);
      await settle();
      expect(c.state.loading, isFalse);
      expect(c.state.items.map((o) => o.id), ['o0', 'o1', 'o2']);
      expect(c.state.hasMore, isTrue);
      expect(repo.pages.single, (limit: 3, offset: 0));
    });

    test(
        'loadMore asks for the next offset, appends without duplicates, and stops on a short page',
        () async {
      final repo = FakeOrdersRepo(orders: many(7));
      final c = list(repo);
      await settle();
      await c.loadMore();
      expect(repo.pages.last, (limit: 3, offset: 3));
      await c.loadMore();
      expect(repo.pages.last, (limit: 3, offset: 6));
      expect(c.state.items.map((o) => o.id),
          ['o0', 'o1', 'o2', 'o3', 'o4', 'o5', 'o6']);
      expect(c.state.hasMore, isFalse, reason: 'the last page had 1 of 3');
      final calls = repo.pages.length;
      await c.loadMore();
      expect(repo.pages.length, calls, reason: 'nothing more to ask for');
    });

    test('an exactly-full last page costs one more (empty) request, then stops',
        () async {
      final repo = FakeOrdersRepo(orders: many(6));
      final c = list(repo);
      await settle();
      await c.loadMore();
      expect(c.state.hasMore, isTrue);
      await c.loadMore();
      expect(c.state.hasMore, isFalse);
      expect(c.state.items, hasLength(6));
    });

    test('the same order twice (the list moved while paging) is shown once',
        () async {
      final repo = FakeOrdersRepo(orders: many(5));
      final c = list(repo);
      await settle();
      repo.orders = [
        makeOrder(id: 'new'),
        ...many(5)
      ]; // a new order pushes everything down by one
      await c.loadMore();
      expect(
          c.state.items.map((o) => o.id).toSet().length, c.state.items.length);
    });

    test('two loadMore calls at once ask only once', () async {
      final repo = FakeOrdersRepo(orders: many(9));
      final c = list(repo);
      await settle();
      final a = c.loadMore();
      final b = c.loadMore();
      await Future.wait([a, b]);
      expect(repo.pages.where((p) => p.offset == 3), hasLength(1));
    });

    test('the filter reaches the server unchanged', () async {
      final repo = FakeOrdersRepo(orders: many(2));
      list(repo,
          filter: const OrderFilter(
              statuses: ['BOOKED'], search: 'x', express: true));
      await settle();
      expect(repo.listCalls.single,
          const OrderFilter(statuses: ['BOOKED'], search: 'x', express: true));
    });
  });

  group('list: failures', () {
    test('first load fails → error with a retry that works', () async {
      final repo = FakeOrdersRepo(orders: many(2))
        ..listError = apiError('X', 'no network', status: 500);
      final c = list(repo);
      await settle();
      expect(c.state.error, isNotNull);
      expect(c.state.loading, isFalse);
      repo.listError = null;
      await c.retry();
      expect(c.state.error, isNull);
      expect(c.state.items, hasLength(2));
    });

    test('a failed loadMore keeps what is shown and offers a retry', () async {
      final repo = FakeOrdersRepo(orders: many(7));
      final c = list(repo);
      await settle();
      repo.listError = apiError('X', 'boom', status: 500);
      await c.loadMore();
      expect(c.state.items, hasLength(3));
      expect(c.state.loadMoreError, isNotNull);
      expect(c.state.error, isNull);
      repo.listError = null;
      await c.loadMore();
      expect(c.state.items, hasLength(6));
      expect(c.state.loadMoreError, isNull);
    });

    test('a refresh that fails with orders on screen keeps them', () async {
      final repo = FakeOrdersRepo(orders: many(2));
      final c = list(repo);
      await settle();
      repo.listError = apiError('X', 'boom', status: 500);
      await c.refresh();
      expect(c.state.items, hasLength(2));
      expect(c.state.error, isNull);
    });

    test('an old answer never overwrites a newer one', () async {
      final slow = _SlowRepo();
      final c = OrdersListController(slow, const OrderFilter());
      await slow.firstCall.future;
      unawaited(
          c.refresh()); // a newer request while the first is still in flight
      slow.answer(0, many(1)); // the OLD answer arrives first …
      slow.answer(1, many(2)); // … then the new one
      await settle();
      expect(c.state.items, hasLength(2), reason: 'the newest request wins');
      // and the other way round: the new answer arrives first, the old one must not replace it
      final slow2 = _SlowRepo();
      final d = OrdersListController(slow2, const OrderFilter());
      await slow2.firstCall.future;
      unawaited(d.refresh());
      slow2.answer(1, many(2));
      await settle();
      slow2.answer(0, many(1));
      await settle();
      expect(d.state.items, hasLength(2));
    });
  });

  group('selection', () {
    test('toggle, select all (only orders that can still move), clear',
        () async {
      final repo = FakeOrdersRepo(orders: [
        makeOrder(id: 'a'),
        makeOrder(id: 'b', status: 'IN_PROCESS'),
        makeOrder(id: 'd', status: 'DELIVERED'),
        makeOrder(id: 'x', status: 'CANCELLED')
      ]);
      final c = list(repo, pageSize: 10);
      await settle();
      c.toggle('a');
      expect(c.state.selected, {'a'});
      c.toggle('a');
      expect(c.state.selected, isEmpty);
      c.selectAll();
      expect(c.state.selected, {'a', 'b'},
          reason: 'delivered / cancelled cannot move');
      expect(c.allSelected, isTrue);
      c.clearSelection();
      expect(c.state.selected, isEmpty);
      expect(c.allSelected, isFalse);
    });

    test(
        'a refresh keeps the selection of orders that are still listed and drops the rest',
        () async {
      final repo =
          FakeOrdersRepo(orders: [makeOrder(id: 'a'), makeOrder(id: 'b')]);
      final c = list(repo, pageSize: 10);
      await settle();
      c.selectAll();
      repo.orders = [makeOrder(id: 'a')];
      await c.refresh();
      expect(c.state.selected, {'a'});
    });
  });

  group('bulk "Move to next step"', () {
    test(
        'each selected order moves ONE step, with its version, and the selection is cleared',
        () async {
      final repo = FakeOrdersRepo(orders: [
        makeOrder(id: 'a', version: 4),
        makeOrder(id: 'b', status: 'IN_PROCESS', version: 7)
      ]);
      final c = list(repo, pageSize: 10);
      await settle();
      c.selectAll();
      final r = await c.moveSelected();
      expect((r.moved, r.failed, r.skippedDue), (2, 0, 0));
      expect(repo.transitions.map((t) => (t.id, t.state, t.version)),
          [('a', 'IN_PROCESS', 4), ('b', 'READY', 7)]);
      expect(c.state.items.map((o) => o.status), ['IN_PROCESS', 'READY']);
      expect(c.state.selected, isEmpty);
      expect(c.state.bulkBusy, isFalse);
    });

    test(
        '"ready anyway" is sent only for the Ready step (the dialog told the owner); delivery never forces anything',
        () async {
      final repo = FakeOrdersRepo(orders: [
        makeOrder(id: 'a', status: 'IN_PROCESS'),
        makeOrder(id: 'b', status: 'READY', total: 16000, paid: 16000)
      ]);
      final c = list(repo, pageSize: 10);
      await settle();
      c.selectAll();
      await c.moveSelected();
      expect(
          repo.transitions.firstWhere((t) => t.id == 'a').incomplete, isTrue);
      final b = repo.transitions.firstWhere((t) => t.id == 'b');
      expect((b.state, b.incomplete, b.unpaid), ('DELIVERED', false, false));
    });

    test(
        'an order that would be delivered with a balance due is LEFT ALONE (never forced in bulk)',
        () async {
      final repo = FakeOrdersRepo(orders: [
        makeOrder(id: 'due', status: 'READY', total: 16000, paid: 1000),
        makeOrder(id: 'ok', status: 'BOOKED')
      ]);
      final c = list(repo, pageSize: 10);
      await settle();
      c.selectAll();
      final r = await c.moveSelected();
      expect((r.moved, r.skippedDue), (1, 1));
      expect(repo.transitions.map((t) => t.id), ['ok']);
      expect(c.state.items.firstWhere((o) => o.id == 'due').status, 'READY');
    });

    test(
        'one failing order does not stop the others; failures are counted and the first error kept',
        () async {
      final repo = FakeOrdersRepo(
          orders: [makeOrder(id: 'a'), makeOrder(id: 'b'), makeOrder(id: 'c')])
        ..onTransition = (id, _, __, ___) => id == 'b'
            ? apiError('VERSION_CONFLICT', 'changed by someone else')
            : null;
      final c = list(repo, pageSize: 10);
      await settle();
      c.selectAll();
      final r = await c.moveSelected();
      expect((r.moved, r.failed), (2, 1));
      expect(errorCodeOf(r.firstError), 'VERSION_CONFLICT');
      expect(c.state.items.map((o) => o.status),
          ['IN_PROCESS', 'BOOKED', 'IN_PROCESS']);
    });

    test('nothing selected → nothing sent', () async {
      final repo = FakeOrdersRepo(orders: many(2));
      final c = list(repo, pageSize: 10);
      await settle();
      final r = await c.moveSelected();
      expect((r.moved, r.failed, r.skippedDue), (0, 0, 0));
      expect(repo.transitions, isEmpty);
    });
  });

  group('actions re-read the truth', () {
    test('a transition refreshes the order, the lists and Home', () async {
      final repo = FakeOrdersRepo(orders: [makeOrder(id: 'a', version: 2)]);
      final c = container(repo);
      final sub = c.listen(posOrderDetailProvider('a'), (_, __) {});
      await c.read(posOrderDetailProvider('a').future);
      expect(repo.calls, ['get:a']);
      final o = (await c.read(posOrderDetailProvider('a').future)).order;
      await c.read(posOrderActionsProvider).transition(o, nextStepOf(o)!);
      await settle();
      expect(repo.calls, ['get:a', 'get:a'], reason: 're-read, not guessed');
      expect(repo.transitions.single.version, 2);
      sub.close();
    });

    test('a version conflict re-reads the order and still tells the caller',
        () async {
      final repo = FakeOrdersRepo(orders: [makeOrder(id: 'a')])
        ..onTransition =
            (_, __, ___, ____) => apiError('VERSION_CONFLICT', 'changed');
      final c = container(repo);
      final sub = c.listen(posOrderDetailProvider('a'), (_, __) {});
      final o = (await c.read(posOrderDetailProvider('a').future)).order;
      await expectLater(
          c.read(posOrderActionsProvider).transition(o, nextStepOf(o)!),
          throwsA(predicate((e) => errorCodeOf(e) == 'VERSION_CONFLICT')));
      await settle();
      expect(repo.calls.where((x) => x == 'get:a'), hasLength(2));
      sub.close();
    });

    test('a refusal that is not a conflict does not reload (nothing changed)',
        () async {
      final repo =
          FakeOrdersRepo(orders: [makeOrder(id: 'a', status: 'IN_PROCESS')])
            ..onTransition = (_, __, ___, ____) =>
                apiError('ASSEMBLY_INCOMPLETE', 'not scanned');
      final c = container(repo);
      final sub = c.listen(posOrderDetailProvider('a'), (_, __) {});
      final o = (await c.read(posOrderDetailProvider('a').future)).order;
      await expectLater(
          c.read(posOrderActionsProvider).transition(o, nextStepOf(o)!),
          throwsA(isA<Object>()));
      await settle();
      expect(repo.calls, ['get:a']);
      sub.close();
    });

    test(
        'payment: partial, full; more than the balance is refused by the server too',
        () async {
      final repo = FakeOrdersRepo(orders: [makeOrder(id: 'a', total: 16000)]);
      final c = container(repo);
      final actions = c.read(posOrderActionsProvider);
      var r =
          await actions.collectPayment('a', amountPaise: 5000, mode: 'CASH');
      expect((
        r.order.amountPaidPaise,
        r.order.balancePaise,
        r.order.paymentStatus
      ), (
        5000,
        11000,
        'PART_PAID'
      ));
      await expectLater(
          actions.collectPayment('a', amountPaise: 11001, mode: 'CASH'),
          throwsA(predicate((e) => errorCodeOf(e) == 'OVERPAYMENT')));
      r = await actions.collectPayment('a',
          amountPaise: 11000, mode: 'UPI', reference: 'UTR9');
      expect((r.order.balancePaise, r.order.paymentStatus), (0, 'PAID'));
      expect(repo.payments.map((p) => (p.amount, p.mode, p.ref)), [
        (5000, 'CASH', null),
        (11001, 'CASH', null),
        (11000, 'UPI', 'UTR9')
      ]);
    });

    test(
        'a dropped connection during payment re-reads the order (it may have been recorded)',
        () async {
      final repo = FakeOrdersRepo(orders: [makeOrder(id: 'a')])
        ..onPay = (_, __) => const ApiException(
            message: 'No internet connection', code: 'NETWORK_ERROR');
      final c = container(repo);
      final sub = c.listen(posOrderDetailProvider('a'), (_, __) {});
      await c.read(posOrderDetailProvider('a').future);
      await expectLater(
          c
              .read(posOrderActionsProvider)
              .collectPayment('a', amountPaise: 1000, mode: 'CASH'),
          throwsA(isA<Object>()));
      await settle();
      expect(repo.calls.where((x) => x == 'get:a'), hasLength(2));
      sub.close();
    });
  });
}

/// A repository whose first two list answers are released by the test, in any order.
class _SlowRepo extends FakeOrdersRepo {
  final List<Completer<List<CounterOrder>>> _c = [Completer(), Completer()];
  final Completer<void> firstCall = Completer();
  int _n = 0;

  void answer(int i, List<CounterOrder> v) => _c[i].complete(v);

  @override
  Future<List<CounterOrder>> listOrders(OrderFilter f,
      {int limit = 30, int offset = 0}) {
    final i = _n++;
    if (i == 0) firstCall.complete();
    return _c[i].future;
  }
}
