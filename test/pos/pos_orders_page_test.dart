import 'dart:async';
import 'dart:ui' show CheckedState, SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lndry_vendor_app/features/pos/home/pos_home_page.dart';
import 'package:lndry_vendor_app/features/pos/orders/order_filter_sheet.dart';
import 'package:lndry_vendor_app/features/pos/orders/pos_orders_page.dart';
import 'package:lndry_vendor_app/models/pos/pos_counter_order_model.dart';
import 'package:lndry_vendor_app/models/pos/pos_customer_model.dart';
import 'package:lndry_vendor_app/models/pos/pos_dashboard_model.dart';
import 'package:lndry_vendor_app/models/pos/pos_order_model.dart';

import 'pos_fakes.dart';
import 'pos_harness.dart';

const other = PosCustomer(id: 'u-2', name: 'Ravi Kumar', phone: '9000011111');

List<CounterOrder> sample() => [
      makeOrder(
          id: 'b1',
          number: 'LND-B1',
          status: 'BOOKED',
          total: 23000,
          paid: 5000,
          express: true,
          mode: DeliveryMode.homeDelivery),
      makeOrder(
          id: 'b2',
          number: 'LND-B2',
          status: 'PICKED_UP',
          customer: other,
          total: 8000,
          paid: 8000),
      makeOrder(id: 'p1', number: 'LND-P1', status: 'IN_PROCESS', total: 15000),
      makeOrder(
          id: 'r1',
          number: 'LND-R1',
          status: 'READY',
          total: 30000,
          paid: 30000),
      makeOrder(
          id: 'r2',
          number: 'LND-R2',
          status: 'OUT_FOR_DELIVERY',
          total: 12000,
          mode: DeliveryMode.homeDelivery),
      makeOrder(
          id: 'd1',
          number: 'LND-D1',
          status: 'DELIVERED',
          total: 9000,
          paid: 9000),
      makeOrder(id: 'c1', number: 'LND-C1', status: 'CANCELLED', total: 9000),
    ];

Future<Pos> open(WidgetTester t,
        {FakeOrdersRepo? repo,
        OrdersPreset? preset,
        bool canProcess = true,
        bool canView = true,
        double textScale = 1,
        Locale locale = const Locale('en'),
        Size size = const Size(390, 1800)}) =>
    pumpPos(t, PosOrdersPage(preset: preset),
        orders: repo ?? FakeOrdersRepo(orders: sample()),
        canProcessOrders: canProcess,
        canViewOrders: canView,
        textScale: textScale,
        locale: locale,
        size: size);

void main() {
  testWidgets(
      'three tabs; Booked shows booked + picked-up orders with number, customer, status WORD, money, balance',
      (t) async {
    await open(t);
    expect(find.text('Booked'), findsWidgets);
    expect(find.text('In Process'), findsOneWidget);
    expect(find.text('Done'), findsOneWidget);
    expect(find.text('LND-B1'), findsOneWidget);
    expect(find.text('LND-B2'), findsOneWidget);
    expect(find.text('LND-P1'), findsNothing,
        reason: 'that is on the In Process tab');
    expect(find.text('Asha Verma · 9811122233'), findsOneWidget);
    expect(find.text('₹230'), findsOneWidget);
    expect(find.text('Balance ₹180'), findsOneWidget,
        reason: 'the server\'s total minus paid, in words');
    expect(find.text('Paid'), findsWidgets);
    expect(find.text('Express'), findsOneWidget);
    expect(find.text('Home Delivery'), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('LND-B1, Asha Verma, Booked, ₹230')),
        findsOneWidget);
  });

  testWidgets(
      'In Process and Done tabs show their own orders (Done = ready + out for delivery)',
      (t) async {
    await open(t);
    await t.tap(find.text('In Process'));
    await t.pumpAndSettle();
    expect(find.text('LND-P1'), findsOneWidget);
    expect(find.text('LND-B1'), findsNothing);
    await t.tap(find.text('Done'));
    await t.pumpAndSettle();
    expect(find.text('LND-R1'), findsOneWidget);
    expect(find.text('LND-R2'), findsOneWidget);
    expect(find.text('Out for delivery'), findsOneWidget);
    expect(find.text('Ready'), findsOneWidget);
  });

  testWidgets('empty tabs say what to do next, in plain words', (t) async {
    await open(t, repo: FakeOrdersRepo());
    expect(find.text('No booked orders. Tap Book Order to add one.'),
        findsOneWidget);
    await t.tap(find.text('In Process'));
    await t.pumpAndSettle();
    expect(find.text('Nothing is being processed right now.'), findsOneWidget);
    await t.tap(find.text('Done'));
    await t.pumpAndSettle();
    expect(find.text('No orders are ready right now.'), findsOneWidget);
  });

  testWidgets('a failed load shows a plain sentence and Try again works',
      (t) async {
    final repo = FakeOrdersRepo(orders: sample())
      ..listError = apiError('X', 'The server is busy', status: 500);
    await open(t, repo: repo);
    expect(find.textContaining('Could not load the orders.'), findsWidgets);
    repo.listError = null;
    await t.tap(find.text('Try again').first);
    await t.pumpAndSettle();
    expect(find.text('LND-B1'), findsOneWidget);
  });

  testWidgets(
      'search (name, phone, order no.) is debounced and sent to the server',
      (t) async {
    final repo = FakeOrdersRepo(orders: sample());
    await open(t, repo: repo);
    final before = repo.listCalls.length;
    await t.enterText(find.byType(TextField).first, 'ravi');
    await t.pump(const Duration(milliseconds: 100));
    expect(repo.listCalls.length, before,
        reason: 'still typing: no request yet');
    await t.pump(const Duration(milliseconds: 400));
    await t.pumpAndSettle();
    expect(repo.listCalls.any((f) => f.search == 'ravi'), isTrue);
    expect(find.text('LND-B2'), findsOneWidget);
    expect(find.text('LND-B1'), findsNothing);
  });

  testWidgets('no match: says so and offers to clear', (t) async {
    await open(t);
    await t.enterText(find.byType(TextField).first, 'zzzz');
    await t.pump(const Duration(milliseconds: 500));
    await t.pumpAndSettle();
    expect(find.text('No orders match. Clear the filter or the search.'),
        findsOneWidget);
    await t.tap(find.text('Clear filters'));
    await t.pumpAndSettle();
    expect(find.text('LND-B1'), findsOneWidget);
  });

  testWidgets('the card expands to the garments; tapping it opens the order',
      (t) async {
    final pos = await open(t);
    expect(find.text('Shirt · Dry Cleaning × 2'), findsNothing);
    await t.tap(find.text('2 items').first);
    await t.pumpAndSettle();
    expect(find.text('Shirt · Dry Cleaning × 2'), findsWidgets);
    await t.tap(find.text('LND-B1'));
    await t.pumpAndSettle();
    expect(find.text('ORDER DETAIL b1'), findsOneWidget);
    expect(pos.orders.listCalls, isNotEmpty);
  });

  group('Filter sheet', () {
    testWidgets(
        'All orders shows every status, Delivered / Cancelled their own; the tabs go away and come back',
        (t) async {
      final repo = FakeOrdersRepo(orders: sample());
      await open(t, repo: repo);
      await t.tap(find.text('Filter'));
      await t.pumpAndSettle();
      await t.tap(find.text('All orders'));
      await t.ensureVisible(find.text('Show orders'));
      await t.tap(find.text('Show orders'));
      await t.pumpAndSettle();
      for (final n in ['LND-B1', 'LND-P1', 'LND-R1', 'LND-D1', 'LND-C1']) {
        expect(find.text(n), findsOneWidget, reason: n);
      }
      expect(find.text('Cancelled'), findsWidgets);
      expect(find.text('Order Complete'), findsOneWidget,
          reason: 'delivered AND paid');
      expect(find.text('Showing: All orders'), findsOneWidget);
      expect(find.byType(TabBar), findsNothing);
      await t.tap(find.text('Clear filters').first);
      await t.pumpAndSettle();
      expect(find.byType(TabBar), findsOneWidget);
    });

    testWidgets(
        'Express only + Balance due only narrow the list and show a count on the button',
        (t) async {
      final repo = FakeOrdersRepo(orders: sample());
      await open(t, repo: repo);
      await t.tap(find.text('Filter'));
      await t.pumpAndSettle();
      await t.ensureVisible(find.text('Express only'));
      await t.tap(find.text('Express only'));
      await t.pumpAndSettle();
      await t.ensureVisible(find.text('Balance due only'));
      await t.tap(find.text('Balance due only'));
      await t.pumpAndSettle();
      await t.ensureVisible(find.text('Show orders'));
      await t.tap(find.text('Show orders'));
      await t.pumpAndSettle();
      expect(find.text('LND-B1'), findsOneWidget);
      expect(find.text('LND-B2'), findsNothing);
      expect(find.text('Filter (2)'), findsOneWidget);
      expect(repo.listCalls.last.express && repo.listCalls.last.paymentDue,
          isTrue);
    });
  });

  group('selecting and moving several orders', () {
    testWidgets(
        'select all → one tap moves each one step, after a plain-words confirm',
        (t) async {
      final repo = FakeOrdersRepo(orders: sample());
      await open(t, repo: repo);
      await t.tap(find.text('Select all'));
      await t.pumpAndSettle();
      expect(find.text('2 selected'), findsOneWidget);
      await t.tap(find.text('Move to next step'));
      await t.pumpAndSettle();
      expect(find.text('Move 2 orders to the next step?'), findsOneWidget);
      expect(repo.transitions, isEmpty,
          reason: 'nothing happens before the owner confirms');
      await t.tap(find.text('Move orders'));
      await t.pumpAndSettle();
      expect(repo.transitions.map((x) => (x.id, x.state)),
          [('b1', 'IN_PROCESS'), ('b2', 'IN_PROCESS')]);
      expect(find.text('2 orders moved.'), findsOneWidget);
    });

    testWidgets(
        'the confirm warns when "ready anyway" and balances are involved',
        (t) async {
      final repo = FakeOrdersRepo(orders: [
        makeOrder(id: 'p', status: 'IN_PROCESS'),
        makeOrder(id: 'r', status: 'READY', total: 5000, paid: 0)
      ]);
      await open(t,
          repo: repo, preset: const OrdersPreset(scope: StatusScope.active));
      await t.tap(find.text('Select all'));
      await t.pumpAndSettle();
      await t.tap(find.text('Move to next step'));
      await t.pumpAndSettle();
      expect(
          find.text(
              'Orders whose garments were not scanned are marked ready anyway.'),
          findsOneWidget);
      expect(find.textContaining('NOT delivered here'), findsOneWidget);
      await t.tap(find.text('Move orders'));
      await t.pumpAndSettle();
      expect(repo.transitions.map((x) => x.id), ['p'],
          reason: 'the order with a balance is left for the owner to open');
      expect(find.textContaining('left for you to open'), findsNothing);
    });

    testWidgets('"Not yet" in the confirm moves nothing', (t) async {
      final repo = FakeOrdersRepo(orders: sample());
      await open(t, repo: repo);
      await t.tap(find.text('Select all'));
      await t.pumpAndSettle();
      await t.tap(find.text('Move to next step'));
      await t.pumpAndSettle();
      await t.tap(find.text('Not yet'));
      await t.pumpAndSettle();
      expect(repo.transitions, isEmpty);
    });

    testWidgets(
        'a person without "process orders" cannot select or move anything',
        (t) async {
      await open(t, canProcess: false);
      expect(find.text('Select all'), findsNothing);
      expect(find.byType(Checkbox), findsNothing);
      expect(find.text('LND-B1'), findsOneWidget,
          reason: 'they can still see the orders');
    });
  });

  testWidgets(
      'a person without "view orders" sees a polite no, not an empty list',
      (t) async {
    await open(t, canView: false);
    expect(
        find.text('You do not have permission to do this. Ask the shop owner.'),
        findsOneWidget);
    expect(find.text('LND-B1'), findsNothing);
  });

  testWidgets('coming back to the app re-reads the list from the server',
      (t) async {
    final repo = FakeOrdersRepo(orders: sample());
    await open(t, repo: repo);
    expect(find.text('LND-B1'), findsOneWidget);
    final before = repo.listCalls.length;
    repo.orders = [
      ...sample(),
      makeOrder(id: 'new', number: 'LND-NEW', status: 'BOOKED')
    ];
    t.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await t.pumpAndSettle();
    expect(repo.listCalls.length, greaterThan(before));
    expect(find.text('LND-NEW'), findsOneWidget,
        reason: 'an order booked on another device appears');
  });

  group(
      'inside the real tab shell (the page sits in its own nested navigator, dialogs live on the root one)',
      () {
    /// The Orders tab hosts its page in a navigator of its own, like a StatefulShellBranch does.
    Widget inShell({OrdersPreset? preset}) => Navigator(
        onGenerateRoute: (_) => MaterialPageRoute<void>(
            builder: (_) => PosOrdersPage(preset: preset)));

    testWidgets(
        'the bulk confirm moves the orders (a dialog popped with the wrong context used to close the page)',
        (t) async {
      final repo = FakeOrdersRepo(orders: sample());
      await pumpPos(t, inShell(), orders: repo, size: const Size(390, 1800));
      await t.tap(find.text('Select all'));
      await t.pumpAndSettle();
      await t.tap(find.text('Move to next step'));
      await t.pumpAndSettle();
      await t.tap(find.text('Move orders'));
      await t.pumpAndSettle();
      expect(repo.transitions, hasLength(2),
          reason: 'both selected orders were sent');
      expect(find.text('2 orders moved.'), findsOneWidget);
      expect(find.text('2 selected'), findsNothing,
          reason: 'nothing is selected any more');
      expect(find.byType(TabBar), findsOneWidget,
          reason: 'the Orders screen is still there');
    });

    testWidgets('"Not yet" closes only the dialog and keeps the selection',
        (t) async {
      final repo = FakeOrdersRepo(orders: sample());
      await pumpPos(t, inShell(), orders: repo, size: const Size(390, 1800));
      await t.tap(find.text('Select all'));
      await t.pumpAndSettle();
      await t.tap(find.text('Move to next step'));
      await t.pumpAndSettle();
      await t.tap(find.text('Not yet'));
      await t.pumpAndSettle();
      expect(repo.transitions, isEmpty);
      expect(find.text('2 selected'), findsOneWidget);
      expect(find.byType(TabBar), findsOneWidget);
    });

    testWidgets(
        'the selection bar gives the count and the button the full width (the count must not wrap letter by letter)',
        (t) async {
      await pumpPos(t, inShell(),
          orders: FakeOrdersRepo(orders: sample()), size: const Size(360, 800));
      await t.tap(find.text('Select all'));
      await t.pumpAndSettle();
      expect(t.getSize(find.text('2 selected')).height, lessThan(24),
          reason: 'one line');
      expect(
          t
              .getSize(find.widgetWithText(FilledButton, 'Move to next step'))
              .width,
          greaterThan(300));
      expect(t.takeException(), isNull);
    });
  });

  testWidgets(
      'screen reader: an order is ONE button with a spoken summary; Select all is a named checkbox; each order has its own',
      (t) async {
    final handle = t.ensureSemantics();
    await open(t);
    final card = t.getSemantics(find.bySemanticsLabel(
        RegExp(r'^LND-B1, Asha Verma, Booked, ₹230, Balance ₹180$')));
    final cardData = card.getSemanticsData();
    expect(cardData.flagsCollection.isButton, isTrue,
        reason: 'opening an order is a button, not an anonymous group');
    expect(cardData.hasAction(SemanticsAction.tap), isTrue);
    final all = t.getSemantics(find.bySemanticsLabel('Select all'));
    final allData = all.getSemanticsData();
    expect(allData.flagsCollection.isChecked != CheckedState.none, isTrue,
        reason:
            'it is a checkbox with a name, not an unnamed box beside a label');
    expect(allData.flagsCollection.isChecked, CheckedState.isFalse);
    expect(find.bySemanticsLabel('LND-B1'), findsWidgets,
        reason: 'each order\'s own checkbox is named by its number');
    await t.tap(find.text('Select all'));
    await t.pumpAndSettle();
    expect(
        t
            .getSemantics(find.bySemanticsLabel('Select all'))
            .getSemanticsData()
            .flagsCollection
            .isChecked,
        CheckedState.isTrue);
    handle.dispose();
  });

  testWidgets('pull to refresh asks the server again', (t) async {
    final repo = FakeOrdersRepo(orders: sample());
    await open(t, repo: repo);
    final before = repo.listCalls.length;
    // The pull gesture itself is Flutter's; what matters here is that the indicator is wired to a fresh server read.
    final indicator =
        t.state<RefreshIndicatorState>(find.byType(RefreshIndicator).first);
    unawaited(indicator.show());
    await t.pumpAndSettle();
    expect(repo.listCalls.length, greaterThan(before));
    expect(find.text('LND-B1'), findsOneWidget);
  });

  testWidgets('infinite scroll: reaching the end asks for the next page',
      (t) async {
    final repo = FakeOrdersRepo(orders: [
      for (var i = 0; i < 45; i++) makeOrder(id: 'o$i', number: 'LND-$i')
    ]);
    await open(t, repo: repo);
    expect(repo.pages.where((p) => p.offset == 0), isNotEmpty);
    await t.drag(find.byType(Scrollable).last, const Offset(0, -6000));
    await t.pumpAndSettle();
    expect(repo.pages.any((p) => p.offset == 30), isTrue,
        reason: 'page two was requested');
  });

  testWidgets('big text and a small phone do not overflow', (t) async {
    await open(t,
        textScale: 2,
        size: const Size(360, 640),
        repo: FakeOrdersRepo(orders: sample()));
    expect(t.takeException(), isNull);
    await t.tap(find.text('In Process'));
    await t.pumpAndSettle();
    expect(t.takeException(), isNull);
  });

  testWidgets('Hindi: tabs, filter and statuses are translated', (t) async {
    await open(t, locale: const Locale('hi'));
    expect(find.text('बुक'), findsWidgets);
    expect(find.text('फ़िल्टर'), findsOneWidget);
    expect(find.text('प्रोसेस में'), findsOneWidget);
    expect(find.text('सभी चुनें'), findsOneWidget);
  });

  group('Home tiles open exactly the list behind them', () {
    const dash = PosDashboard(
        asOf: '2026-10-11',
        home: PosHomeStats(
            bookingsToday: 3,
            pendingOrders: 9,
            expressOrders: 2,
            unassignedPickups: 1,
            upcomingDeliveries: 4,
            unassignedDeliveries: 0,
            collectionDuePaise: 80000,
            todayRevenuePaise: 5000,
            onlineOrderRequests: 2,
            deliveredToday: 1,
            deliveriesToday: 2));

    Future<OrdersPreset> tapAndRead(WidgetTester t, String label) async {
      final pos = await pumpPos(t, const PosHomePage(),
          dashboard: FakeDashboardRepo(dash), size: const Size(390, 2000));
      await t.tap(find.text(label));
      await t.pumpAndSettle();
      expect(find.text('ORDERS SCREEN'), findsOneWidget);
      return pos.extras.last! as OrdersPreset;
    }

    testWidgets('Pending Orders → active orders', (t) async {
      final p = await tapAndRead(t, 'Pending Orders');
      expect((p.filter.tile, p.scope), ('pendingOrders', StatusScope.all));
      expect(p.label, 'Pending Orders');
    });
    testWidgets(
        'Express orders → the express tile',
        (t) async => expect((await tapAndRead(t, 'Express orders')).filter.tile,
            'expressOrders'));
    testWidgets(
        'Pickups to assign → that tile',
        (t) async => expect(
            (await tapAndRead(t, 'Pickups to assign')).filter.tile,
            'unassignedPickups'));
    testWidgets(
        'Deliveries due → that tile',
        (t) async => expect((await tapAndRead(t, 'Deliveries due')).filter.tile,
            'upcomingDeliveries'));
    testWidgets(
        'Deliveries to assign → that tile',
        (t) async => expect(
            (await tapAndRead(t, 'Deliveries to assign')).filter.tile,
            'unassignedDeliveries'));
    testWidgets(
        'Money to collect → the balance-due tile',
        (t) async => expect(
            (await tapAndRead(t, 'Money to collect')).filter.tile,
            'collectionDue'));
    testWidgets(
        'the number tiles open their lists: Booking, Delivery, Delivered, Today Revenue',
        (t) async {
      for (final (label, tile) in [
        ('Booking', 'bookingsToday'),
        ('Delivery', 'deliveriesToday'),
        ('Delivered', 'deliveredToday'),
        ('Today Revenue', 'bookingsToday')
      ]) {
        final p = await tapAndRead(t, label);
        expect(p.filter.tile, tile, reason: label);
      }
    });

    testWidgets(
        'Order Request (LNDRY marketplace orders) opens nothing: there is no counter list behind it',
        (t) async {
      final pos = await pumpPos(t, const PosHomePage(),
          dashboard: FakeDashboardRepo(dash), size: const Size(390, 2000));
      await t.tap(find.text('Order requests'));
      await t.pumpAndSettle();
      expect(pos.extras, isEmpty);
      expect(find.text('ORDERS SCREEN'), findsNothing);
    });

    testWidgets(
        'on the Orders screen the preset shows its words, the list is the server\'s, and Clear returns to the tabs',
        (t) async {
      final repo = FakeOrdersRepo(orders: sample());
      await open(t,
          repo: repo,
          preset: const OrdersPreset(
              scope: StatusScope.all,
              filter: OrderFilter(tile: 'expressOrders'),
              label: 'Express orders'));
      expect(find.text('Showing: Express orders'), findsOneWidget);
      expect(repo.listCalls.single.tile, 'expressOrders');
      expect(find.byType(TabBar), findsNothing);
      await t.tap(find.text('Clear filters').first);
      await t.pumpAndSettle();
      expect(find.byType(TabBar), findsOneWidget);
      expect(repo.listCalls.last.tile, isNull);
    });
  });
}
