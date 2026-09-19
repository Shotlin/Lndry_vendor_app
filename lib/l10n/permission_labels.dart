import '../models/permission_catalog_model.dart';
import 'generated/app_localizations.dart';

/// Translated labels for the backend's permission catalog.
///
/// The backend owns WHAT can be granted (keys + permission strings); the app
/// only supplies the words. A key this build doesn't know yet — a module the
/// backend added after this app shipped — falls back to the backend's own
/// English label, so it still appears and works.
String permissionModuleLabel(AppLocalizations l10n, PermissionModule module) =>
    switch (module.key) {
      'orders' => l10n.permModuleOrders,
      'catalogue' => l10n.permModuleCatalogue,
      'inventory' => l10n.permModuleInventory,
      'slots' => l10n.permModuleSlots,
      'analytics' => l10n.permModuleAnalytics,
      _ => module.label,
    };

String permissionItemLabel(AppLocalizations l10n, PermissionItem item) =>
    switch (item.key) {
      'orders.view' => l10n.permOrdersView,
      'orders.accept_reject' => l10n.permOrdersAcceptReject,
      'orders.process' => l10n.permOrdersProcess,
      'orders.reevaluate' => l10n.permOrdersReevaluate,
      'orders.assign_captain' => l10n.permOrdersAssignCaptain,
      'catalogue.view' => l10n.permCatalogueView,
      'catalogue.manage' => l10n.permCatalogueManage,
      'inventory.view' => l10n.permInventoryView,
      'inventory.manage' => l10n.permInventoryManage,
      'slots.view' => l10n.permSlotsView,
      'slots.manage' => l10n.permSlotsManage,
      'analytics.view' => l10n.permAnalyticsView,
      _ => item.label,
    };
