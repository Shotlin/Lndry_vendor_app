import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/repositories/api_pos_repositories.dart';
import '../../../models/pos/pos_catalogue_model.dart';
import '../../../models/pos/pos_customer_model.dart';
import '../../../models/pos/pos_dashboard_model.dart';
import '../../../providers/access_provider.dart';

/// POS Home numbers. Refreshed by pull-to-refresh and after every booking.
final posDashboardProvider = FutureProvider.autoDispose<PosDashboard>(
  (ref) => ref.watch(posDashboardRepositoryProvider).getDashboard(),
);

/// The shop's price list (garments, services, prices, GST rules).
final posCatalogueProvider = FutureProvider.autoDispose<PosCatalogue>(
  (ref) => ref.watch(posCatalogueRepositoryProvider).getCatalogue(),
);

/// Saved charges / discounts. A failure here is not fatal for booking, so it yields an empty list.
final posChargeRulesProvider = FutureProvider.autoDispose<List<PosAdjustmentRule>>((ref) async {
  try {
    return (await ref.watch(posCatalogueRepositoryProvider).listRules('charge')).where((r) => r.active).toList();
  } catch (_) {
    return const [];
  }
});

final posDiscountRulesProvider = FutureProvider.autoDispose<List<PosAdjustmentRule>>((ref) async {
  try {
    return (await ref.watch(posCatalogueRepositoryProvider).listRules('discount')).where((r) => r.active).toList();
  } catch (_) {
    return const [];
  }
});

/// Customers matching the text (empty text = recent ones).
final posCustomerSearchProvider = FutureProvider.autoDispose.family<List<PosCustomer>, String>(
  (ref, query) => ref.watch(posCounterRepositoryProvider).searchCustomers(query),
);

/// Whether this person may add or change prices. The server enforces it too; this only decides
/// whether the buttons are shown (staff without catalogue rights never see "Add Garment Price").
final posCanManageCatalogueProvider = Provider<bool>((ref) => ref.watch(myAccessProvider).can('catalogue.manage'));

/// Staff only see and change orders if the owner granted it. The server decides what is *allowed*; these only decide
/// what is *shown* (the counter routes do not check staff permissions yet — see PROGRESS.md, Phase 4 security review).
final posCanViewOrdersProvider = Provider<bool>((ref) => ref.watch(myAccessProvider).can('orders.view'));
final posCanProcessOrdersProvider = Provider<bool>((ref) => ref.watch(myAccessProvider).can('orders.process'));
final posCanAssignCaptainProvider = Provider<bool>((ref) => ref.watch(myAccessProvider).can('orders.assign_captain'));
