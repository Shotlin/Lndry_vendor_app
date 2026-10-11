import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lndry_vendor_app/features/pos/core/pos_widgets.dart';
import 'package:lndry_vendor_app/features/pos/home/pos_home_page.dart';
import 'package:lndry_vendor_app/models/pos/pos_dashboard_model.dart';

import 'pos_fakes.dart';
import 'pos_harness.dart';

PosDashboard dash({int? revenue = 230000}) => PosDashboard(
      asOf: '2026-10-11',
      home: PosHomeStats(
        todayRevenuePaise: revenue,
        todayCollectionPaise: 150000,
        collectionDuePaise: 80000,
        onlineOrderRequests: 2,
        washingToStore: 5,
        bookingsToday: 7,
        deliveriesToday: 3,
        deliveredToday: 4,
        pendingOrders: 9,
        unassignedPickups: 1,
        upcomingDeliveries: 6,
        unassignedDeliveries: 0,
        expressOrders: 2,
      ),
    );

void main() {
  testWidgets('shows the server numbers exactly, in rupees and counts', (t) async {
    await pumpPos(t, const PosHomePage(), dashboard: FakeDashboardRepo(dash()));
    expect(find.text('₹2,300'), findsOneWidget); // revenue
    expect(find.text('₹1,500'), findsOneWidget); // collection
    expect(find.text('₹800'), findsOneWidget); // money to collect (task row)
    for (final label in ['Today Revenue', 'Collection', 'Order Request', 'Washing to Store', 'Booking', 'Delivery', 'Delivered', 'Pending Orders']) {
      expect(find.text(label), findsOneWidget, reason: label);
    }
    expect(find.bySemanticsLabel('Pending Orders: 9'), findsOneWidget);
    expect(find.bySemanticsLabel('Express orders: 2'), findsOneWidget);
    expect(find.text('Sparkle Laundry'), findsOneWidget);
  });

  testWidgets('a number the server did not send is a dash, never zero', (t) async {
    await pumpPos(t, const PosHomePage(), dashboard: FakeDashboardRepo(const PosDashboard(asOf: null, home: PosHomeStats(bookingsToday: 3))));
    expect(find.bySemanticsLabel('Booking: 3'), findsOneWidget);
    expect(find.bySemanticsLabel('Today Revenue: —'), findsOneWidget);
    expect(find.bySemanticsLabel('Pending Orders: —'), findsOneWidget);
    expect(find.text('No orders yet. Tap Book Order to start.'), findsNothing, reason: 'unknown is not the same as empty');
  });

  testWidgets('a new shop sees zeros and what to do next', (t) async {
    await pumpPos(
      t,
      const PosHomePage(),
      dashboard: FakeDashboardRepo(const PosDashboard(asOf: 'x', home: PosHomeStats(todayRevenuePaise: 0, todayCollectionPaise: 0, collectionDuePaise: 0, bookingsToday: 0, pendingOrders: 0, deliveriesToday: 0))),
    );
    expect(find.text('₹0'), findsWidgets);
    expect(find.text('No orders yet. Tap Book Order to start.'), findsOneWidget);
    expect(find.text('Could not load today\'s numbers.'), findsNothing);
  });

  testWidgets('while loading: placeholders, and Book Order is already usable', (t) async {
    final repo = FakeDashboardRepo()..gate = Completer<PosDashboard>();
    await pumpPos(t, const PosHomePage(), dashboard: repo, settle: false);
    await t.pump();
    expect(find.byType(PosSkeleton), findsWidgets);
    expect(find.text('Book Order'), findsOneWidget);
    await t.tap(find.text('Book Order'));
    await t.pumpAndSettle();
    expect(find.text('BOOK SCREEN'), findsOneWidget);
    repo.gate!.complete(dash());
    await t.pumpAndSettle();
  });

  testWidgets('an error says so in plain words and Try again reloads', (t) async {
    final repo = FakeDashboardRepo()..error = Exception('boom');
    await pumpPos(t, const PosHomePage(), dashboard: repo);
    expect(find.textContaining('Could not load today'), findsOneWidget);
    expect(find.textContaining('Exception'), findsNothing, reason: 'no technical text for the user');
    expect(find.text('Book Order'), findsOneWidget, reason: 'booking must not depend on the numbers');
    repo
      ..error = null
      ..result = dash();
    await t.tap(find.text('Try again'));
    await t.pumpAndSettle();
    expect(find.text('₹2,300'), findsOneWidget);
    expect(repo.calls, 2);
  });

  testWidgets('pull to refresh asks again', (t) async {
    final repo = FakeDashboardRepo(dash());
    await pumpPos(t, const PosHomePage(), dashboard: repo);
    await t.fling(find.byType(ListView).first, const Offset(0, 400), 1000);
    await t.pumpAndSettle();
    expect(repo.calls, 2);
  });

  testWidgets('staff without catalogue rights never see "Add Garment Price"', (t) async {
    await pumpPos(t, const PosHomePage(), canManage: false);
    expect(find.text('Add Customer'), findsOneWidget);
    expect(find.text('Add Garment Price'), findsNothing);
  });

  testWidgets('the owner sees "Add Garment Price"', (t) async {
    await pumpPos(t, const PosHomePage());
    expect(find.text('Add Garment Price'), findsOneWidget);
  });

  testWidgets('no plan card when the shop has no plan', (t) async {
    await pumpPos(t, const PosHomePage());
    expect(find.text('Your plan'), findsNothing);
  });

  testWidgets('plan card shows the plan and its end date', (t) async {
    await pumpPos(t, const PosHomePage(), info: shopInfo(plan: 'Enterprise', validTo: '2026-11-03'));
    expect(find.text('Enterprise'), findsOneWidget);
    expect(find.textContaining('Nov 3, 2026'), findsOneWidget);
  });

  testWidgets('Hindi labels', (t) async {
    await pumpPos(t, const PosHomePage(), dashboard: FakeDashboardRepo(dash()), locale: const Locale('hi'));
    expect(find.text('आज की कमाई'), findsOneWidget);
    expect(find.text('ऑर्डर बुक करें'), findsOneWidget);
  });

  testWidgets('large text (200%) and a small phone do not overflow', (t) async {
    await pumpPos(t, const PosHomePage(), dashboard: FakeDashboardRepo(dash()), textScale: 2, size: const Size(320, 640));
    expect(t.takeException(), isNull);
    await t.drag(find.byType(ListView).first, const Offset(0, -600));
    await t.pumpAndSettle();
    expect(t.takeException(), isNull);
  });

  testWidgets('dark theme renders', (t) async {
    await pumpPos(t, Theme(data: ThemeData.dark(), child: const PosHomePage()), dashboard: FakeDashboardRepo(dash()));
    expect(t.takeException(), isNull);
  });
}
