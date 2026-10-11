import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/network/friendly_error.dart';
import '../../../core/router/app_routes.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../models/pos/pos_counter_order_model.dart';
import '../../../models/pos/pos_dashboard_model.dart';
import '../../../providers/app_mode_provider.dart';
import '../booking/add_garment_price_sheet.dart';
import '../core/money.dart';
import '../core/pos_providers.dart';
import '../core/pos_widgets.dart';
import '../customers/add_customer_sheet.dart';
import '../orders/order_filter_sheet.dart';
import '../orders/order_state.dart';
import '../orders/pos_orders_page.dart';
import '../whatsapp/whatsapp_sheet.dart';

/// POS Home: today's numbers, what needs doing, and the three things done most (book, add customer,
/// add price). Booking never waits for the numbers: the button is always there.
class PosHomePage extends ConsumerWidget {
  const PosHomePage({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(posDashboardProvider);
    try {
      await ref.read(posDashboardProvider.future);
    } catch (_) {
      // The error card shows it.
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final info = ref.watch(appModeProvider.select((s) => s.info));
    final dashboard = ref.watch(posDashboardProvider);
    final canManage = ref.watch(posCanManageCatalogueProvider);
    return Scaffold(
      appBar: AppBar(title: Text((info?.shopName ?? '').trim().isEmpty ? l10n.posTabHome : info!.shopName!)),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        onPressed: () => context.push(AppRoutes.posBook),
        icon: const Icon(Icons.add_shopping_cart_rounded),
        label: Text(l10n.posActionBook),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refresh(ref),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
          children: [
            if ((info?.posPlanName ?? '').trim().isNotEmpty) ...[
              _PlanCard(name: info!.posPlanName!.trim(), validTo: info.posValidTo),
              const SizedBox(height: 12),
            ],
            dashboard.when(
              loading: () => const _HomeSkeleton(),
              error: (e, _) => PosErrorNote(message: '${l10n.posHomeLoadError}\n${friendlyError(e)}', onRetry: () => ref.invalidate(posDashboardProvider), retryLabel: l10n.posRetry),
              data: (d) => _Numbers(home: d.home),
            ),
            const SizedBox(height: 20),
            _SectionTitle(l10n.posQuickActions),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _ActionTile(
                    icon: Icons.chat_rounded,
                    label: l10n.posActionWhatsApp,
                    onTap: () => startWhatsAppFlow(context, ref),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionTile(
                    icon: Icons.person_add_alt_1_rounded,
                    label: l10n.posActionAddCustomer,
                    onTap: () async {
                      final c = await showAddCustomerSheet(context);
                      if (c != null && context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.posCustomerAdded(c.displayName))));
                    },
                  ),
                ),
                if (canManage) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionTile(
                      icon: Icons.sell_rounded,
                      label: l10n.posActionAddPrice,
                      onTap: () async {
                        final saved = await showAddGarmentPriceSheet(context);
                        if (saved == true && context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.posPriceSaved)));
                      },
                    ),
                  ),
                ],
              ],
            ),
            dashboard.maybeWhen(
              data: (d) => _Tasks(home: d.home),
              orElse: () => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Semantics(header: true, child: Text(text, style: Theme.of(context).textTheme.titleMedium));
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.name, required this.validTo});
  final String name;
  final DateTime? validTo;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final validText = validTo == null ? null : DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(validTo!);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: scheme.primaryContainer, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Icon(Icons.workspace_premium_rounded, color: scheme.primary, size: 32),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.posPlanTitle, style: text.labelMedium),
                Text(name, style: text.titleMedium),
                if ((validText ?? '').isNotEmpty) Text(l10n.posPlanValidTo(validText!), style: text.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeSkeleton extends StatelessWidget {
  const _HomeSkeleton();
  @override
  Widget build(BuildContext context) => Column(
        children: [
          for (var i = 0; i < 2; i++) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: Theme.of(context).colorScheme.outline)),
              child: const Column(children: [
                Row(children: [Expanded(child: PosSkeleton(height: 56)), SizedBox(width: 12), Expanded(child: PosSkeleton(height: 56))]),
                SizedBox(height: 12),
                Row(children: [Expanded(child: PosSkeleton(height: 56)), SizedBox(width: 12), Expanded(child: PosSkeleton(height: 56))]),
              ]),
            ),
            const SizedBox(height: 12),
          ],
        ],
      );
}

String _count(int? n) => n == null ? '—' : '$n';

class _Numbers extends StatelessWidget {
  const _Numbers({required this.home});
  final PosHomeStats home;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final nothingYet = home.bookingsToday == 0 && home.pendingOrders == 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _KpiCard(tiles: [
          _Kpi(l10n.posTileRevenue, formatPaise(home.todayRevenuePaise), Icons.trending_up_rounded, PosTone.success, _tilePreset('bookingsToday', label: l10n.posTileBooking)),
          _Kpi(l10n.posTileCollection, formatPaise(home.todayCollectionPaise), Icons.payments_rounded, PosTone.success),
          _Kpi(l10n.posTileOrderRequests, _count(home.onlineOrderRequests), Icons.inbox_rounded, PosTone.neutral),
          _Kpi(l10n.posTileWashingToStore, _count(home.washingToStore), Icons.local_laundry_service_rounded, PosTone.neutral),
        ]),
        const SizedBox(height: 12),
        _KpiCard(tiles: [
          _Kpi(l10n.posTileBooking, _count(home.bookingsToday), Icons.edit_note_rounded, PosTone.neutral, _tilePreset('bookingsToday', label: l10n.posTileBooking)),
          _Kpi(l10n.posTileDelivery, _count(home.deliveriesToday), Icons.local_shipping_rounded, PosTone.neutral, _tilePreset('deliveriesToday', label: l10n.posTileDelivery)),
          _Kpi(l10n.posTileDelivered, _count(home.deliveredToday), Icons.task_alt_rounded, PosTone.success, _tilePreset('deliveredToday', label: l10n.posTileDelivered)),
          _Kpi(l10n.posTilePending, _count(home.pendingOrders), Icons.pending_actions_rounded, (home.pendingOrders ?? 0) > 0 ? PosTone.attention : PosTone.neutral, _tilePreset('pendingOrders', label: l10n.posTilePending)),
        ]),
        if (nothingYet) ...[
          const SizedBox(height: 12),
          Text(l10n.posHomeEmpty, style: text.bodyMedium),
        ],
      ],
    );
  }
}

class _Kpi {
  const _Kpi(this.label, this.value, this.icon, this.tone, [this.preset]);
  final String label;
  final String value;
  final IconData icon;
  final PosTone tone;

  /// The orders behind this number (the server lists exactly what the tile counts). `null` = nothing to open.
  final OrdersPreset? preset;
}

/// Opens the Orders tab showing exactly the orders a tile counted.
void _openOrders(BuildContext context, OrdersPreset p) => context.go(AppRoutes.posOrders, extra: p);

OrdersPreset _tilePreset(String tile, {required String label, OrderTab tab = OrderTab.booked, StatusScope scope = StatusScope.all}) =>
    OrdersPreset(tab: tab, scope: scope, filter: OrderFilter(tile: tile), label: label);

class _KpiCard extends StatelessWidget {
  const _KpiCard({required this.tiles});
  final List<_Kpi> tiles;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    Widget tile(_Kpi k) {
      final colors = posToneColors(context, k.tone);
      final open = k.preset;
      return Semantics(
        container: true,
        button: open != null,
        label: '${k.label}: ${k.value}',
        excludeSemantics: true,
        onTap: open == null ? null : () => _openOrders(context, open),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: open == null ? null : () => _openOrders(context, open),
          child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: colors.bg, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Icon(k.icon, size: 20, color: colors.fg),
                const SizedBox(width: 6),
                Expanded(child: Text(k.label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: colors.fg), maxLines: 2, overflow: TextOverflow.ellipsis)),
              ]),
              const SizedBox(height: 6),
              FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: Text(k.value, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: colors.fg, fontWeight: FontWeight.w800))),
            ],
          ),
        ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: scheme.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: scheme.outline)),
      child: Column(
        children: [
          IntrinsicHeight(child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Expanded(child: tile(tiles[0])), const SizedBox(width: 10), Expanded(child: tile(tiles[1]))])),
          const SizedBox(height: 10),
          IntrinsicHeight(child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Expanded(child: tile(tiles[2])), const SizedBox(width: 10), Expanded(child: tile(tiles[3]))])),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      onTap: onTap,
      child: Material(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 96),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: scheme.outline)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 30, color: scheme.primary),
                const SizedBox(height: 8),
                Text(label, textAlign: TextAlign.center, style: Theme.of(context).textTheme.labelLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Tasks extends StatelessWidget {
  const _Tasks({required this.home});
  final PosHomeStats home;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    OrdersPreset? open(String tile, String label) => _tilePreset(tile, label: label);
    final rows = <(String, String, PosTone, OrdersPreset?)>[
      (l10n.posTaskUnassignedPickups, _count(home.unassignedPickups), (home.unassignedPickups ?? 0) > 0 ? PosTone.attention : PosTone.neutral, open('unassignedPickups', l10n.posTaskUnassignedPickups)),
      (l10n.posTaskUpcomingDeliveries, _count(home.upcomingDeliveries), (home.upcomingDeliveries ?? 0) > 0 ? PosTone.attention : PosTone.neutral, open('upcomingDeliveries', l10n.posTaskUpcomingDeliveries)),
      (l10n.posTaskUnassignedDeliveries, _count(home.unassignedDeliveries), (home.unassignedDeliveries ?? 0) > 0 ? PosTone.attention : PosTone.neutral, open('unassignedDeliveries', l10n.posTaskUnassignedDeliveries)),
      (l10n.posTaskExpress, _count(home.expressOrders), (home.expressOrders ?? 0) > 0 ? PosTone.danger : PosTone.neutral, open('expressOrders', l10n.posTaskExpress)),
      // Online order requests are LNDRY marketplace orders, not counter orders: there is no counter list behind this number.
      (l10n.posTaskOrderRequests, _count(home.onlineOrderRequests), (home.onlineOrderRequests ?? 0) > 0 ? PosTone.attention : PosTone.neutral, null),
      (l10n.posTaskCollectionDue, formatPaise(home.collectionDuePaise), (home.collectionDuePaise ?? 0) > 0 ? PosTone.attention : PosTone.neutral, open('collectionDue', l10n.posTaskCollectionDue)),
    ];
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        _SectionTitle(l10n.posTasksTitle),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(color: scheme.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: scheme.outline)),
          child: Column(
            children: [
              for (var i = 0; i < rows.length; i++) ...[
                if (i > 0) Divider(height: 1, color: scheme.outline),
                _TaskRow(label: rows[i].$1, value: rows[i].$2, tone: rows[i].$3, preset: rows[i].$4),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({required this.label, required this.value, required this.tone, this.preset});
  final String label;
  final String value;
  final PosTone tone;

  /// The orders behind this number, opened on tap. `null` = nothing to open (no arrow is drawn).
  final OrdersPreset? preset;

  @override
  Widget build(BuildContext context) {
    final colors = posToneColors(context, tone);
    final open = preset;
    return Semantics(
      container: true,
      button: open != null,
      label: '$label: $value',
      excludeSemantics: true,
      onTap: open == null ? null : () => _openOrders(context, open),
      child: InkWell(
        onTap: open == null ? null : () => _openOrders(context, open),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 52),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              children: [
                Container(width: 10, height: 10, decoration: BoxDecoration(color: colors.fg, shape: BoxShape.circle)),
                const SizedBox(width: 12),
                Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyLarge)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: colors.bg, borderRadius: BorderRadius.circular(20)),
                  child: Text(value, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: colors.fg, fontWeight: FontWeight.w800)),
                ),
                if (open != null) Icon(Icons.chevron_right_rounded, color: Theme.of(context).colorScheme.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
