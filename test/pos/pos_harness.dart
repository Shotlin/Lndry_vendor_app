import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lndry_vendor_app/api/repositories/api_pos_repositories.dart';
import 'package:lndry_vendor_app/core/router/app_routes.dart';
import 'package:lndry_vendor_app/core/services/storage_service.dart';
import 'package:lndry_vendor_app/features/pos/core/pos_providers.dart';
import 'package:lndry_vendor_app/features/pos/orders/orders_providers.dart';
import 'package:lndry_vendor_app/features/pos/orders/pdf_viewer.dart';
import 'package:lndry_vendor_app/l10n/generated/app_localizations.dart';
import 'package:lndry_vendor_app/models/pos/app_mode_model.dart';
import 'package:lndry_vendor_app/providers/app_mode_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fakes.dart';
import 'pos_fakes.dart';

/// An [AppModeNotifier] that already knows the shop (no network, no sign-in).
class FixedAppMode extends AppModeNotifier {
  FixedAppMode(Ref ref, StorageService storage, AppModeInfo info)
      : super(ref, FakeAppModeRepo(mode: info), storage) {
    state = AppModeState(
        status: AppModeStatus.ready, info: info, selected: AppMode.pos);
  }
}

AppModeInfo shopInfo({String? plan, String? validTo, bool wallet = false}) =>
    AppModeInfo.fromJson({
      'hasVendor': true,
      'vendorId': 'v1',
      'shopName': 'Sparkle Laundry',
      'role': 'VENDOR_OWNER',
      'offering': 'POS',
      'posOnboardingStatus': 'COMPLETED',
      'allowedModes': const ['POS'],
      'walletAccess': wallet,
      if (plan != null) 'posPlanName': plan,
      if (validTo != null) 'posValidTo': validTo,
    });

class Pos {
  Pos(this.c, this.dashboard, this.catalogue, this.counter, this.storage,
      this.router, this.orders, this.opened, this.extras);
  final FakeOrdersRepo orders;

  /// Links the app asked the phone to open (tel:, wa.me).
  final List<Uri> opened;

  /// `extra` of every visit to the Orders tab (the preset a Home tile asked for).
  final List<Object?> extras;
  final ProviderContainer c;
  final FakeDashboardRepo dashboard;
  final FakeCatalogueRepo catalogue;
  final FakeCounterRepo counter;
  final MemStorage storage;
  final GoRouter router;
}

/// Pumps [page] inside a POS-themed app with fake repositories. Routes to Book/Orders show a marker text.
Future<Pos> pumpPos(
  WidgetTester tester,
  Widget page, {
  FakeDashboardRepo? dashboard,
  FakeCatalogueRepo? catalogue,
  FakeCounterRepo? counter,
  FakeOrdersRepo? orders,
  bool canManage = true,
  bool canViewOrders = true,
  bool canProcessOrders = true,
  bool canAssign = true,
  bool openerWorks = true,
  AppModeInfo? info,
  Map<String, Object> prefs = const {},
  double textScale = 1,
  Locale locale = const Locale('en'),
  Size size = const Size(390, 844),
  bool settle = true,
}) async {
  tester.view.physicalSize = size * 2;
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  SharedPreferences.setMockInitialValues(prefs);
  final storage = MemStorage(prefs: await SharedPreferences.getInstance());
  final d = dashboard ?? FakeDashboardRepo();
  final cat = catalogue ?? FakeCatalogueRepo();
  final cnt = counter ?? FakeCounterRepo();
  final ord = orders ?? FakeOrdersRepo();
  final opened = <Uri>[];
  final extras = <Object?>[];
  final c = ProviderContainer(overrides: [
    storageServiceProvider.overrideWithValue(storage),
    appModeProvider
        .overrideWith((ref) => FixedAppMode(ref, storage, info ?? shopInfo())),
    posDashboardRepositoryProvider.overrideWithValue(d),
    posCatalogueRepositoryProvider.overrideWithValue(cat),
    posCounterRepositoryProvider.overrideWithValue(cnt),
    posCanManageCatalogueProvider.overrideWithValue(canManage),
    posOrdersRepositoryProvider.overrideWithValue(ord),
    posCanViewOrdersProvider.overrideWithValue(canViewOrders),
    posCanProcessOrdersProvider.overrideWithValue(canProcessOrders),
    posCanAssignCaptainProvider.overrideWithValue(canAssign),
    posUrlOpenerProvider.overrideWithValue((uri) async {
      opened.add(uri);
      return openerWorks;
    }),
    posPdfViewerProvider.overrideWithValue((context, pdf, {onDone}) =>
        Column(children: [
          Text('PDF ${pdf.fileName}'),
          if (onDone != null)
            TextButton(onPressed: onDone, child: const Text('SIMULATE PRINTED'))
        ])),
  ]);
  addTearDown(c.dispose);
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, __) => page),
      GoRoute(
          path: AppRoutes.posBook,
          builder: (_, __) => const Scaffold(body: Text('BOOK SCREEN'))),
      GoRoute(
        path: AppRoutes.posOrders,
        builder: (_, s) {
          extras.add(s.extra);
          return const Scaffold(body: Text('ORDERS SCREEN'));
        },
      ),
      GoRoute(
          path: AppRoutes.posOrderDetail,
          builder: (_, s) =>
              Scaffold(body: Text('ORDER DETAIL ${s.pathParameters['id']}'))),
      GoRoute(
          path: AppRoutes.posOrderInvoice,
          builder: (_, s) =>
              Scaffold(body: Text('INVOICE ${s.pathParameters['id']}'))),
      GoRoute(
          path: AppRoutes.posOrderMini,
          builder: (_, s) =>
              Scaffold(body: Text('MINI ${s.pathParameters['id']}'))),
      GoRoute(
          path: AppRoutes.posOrderTags,
          builder: (_, s) =>
              Scaffold(body: Text('TAGS ${s.pathParameters['id']}'))),
    ],
  );
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: c,
      child: MaterialApp.router(
        locale: locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(textScale)),
            child: child!),
      ),
    ),
  );
  if (settle) await tester.pumpAndSettle();
  return Pos(c, d, cat, cnt, storage, router, ord, opened, extras);
}

/// A draft with a customer and one shirt, as the Book Order screen would have saved it.
String draftWith({String payment = 'PAY_LATER'}) =>
    '{"customer":{"id":"u-1","name":"Asha Verma","phone":"9811122233"},'
    '"date":"2099-01-01","serviceId":"s-dry","lines":[{"garmentId":"g-shirt","serviceId":"s-dry","qty":1}],"payment":"$payment"}';
