import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/friendly_error.dart';
import '../../../core/router/app_routes.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../models/pos/pos_counter_order_model.dart';
import '../../../models/pos/pos_customer_detail_model.dart';
import '../../../providers/app_mode_provider.dart';
import '../core/money.dart';
import '../core/pos_money_providers.dart';
import '../core/pos_widgets.dart';
import '../orders/orders_providers.dart';
import '../orders/pos_orders_page.dart';
import '../orders/whatsapp.dart';
import '../whatsapp/whatsapp_sheet.dart';

/// One customer: contact buttons, what they owe (tap an order to collect), and their order history.
class PosCustomerDetailPage extends ConsumerWidget {
  const PosCustomerDetailPage({required this.customerId, super.key});
  final String customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(posCustomerDetailProvider(customerId));
    return Scaffold(
      appBar: AppBar(title: Text(async.valueOrNull?.customer.displayName ?? l10n.posCustTitle)),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(posCustomerDetailProvider(customerId));
          try {
            await ref.read(posCustomerDetailProvider(customerId).future);
          } catch (_) {
            // Shown below.
          }
        },
        child: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ListView(padding: const EdgeInsets.all(16), children: [
            PosErrorNote(
              message: errorStatusIs404(e) ? l10n.posCustNotFound : '${l10n.posCustLoadError}\n${friendlyError(e)}',
              onRetry: () => ref.invalidate(posCustomerDetailProvider(customerId)),
              retryLabel: l10n.posRetry,
            ),
          ]),
          data: (d) => _Detail(detail: d, customerId: customerId),
        ),
      ),
    );
  }
}

bool errorStatusIs404(Object e) => friendlyError(e).toLowerCase().contains('not found');

class _Detail extends ConsumerWidget {
  const _Detail({required this.detail, required this.customerId});
  final PosCustomerDetail detail;
  final String customerId;

  Future<void> _call(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final ok = await ref.read(posUrlOpenerProvider)(Uri(scheme: 'tel', path: detail.customer.phone));
    if (!ok && context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.posOrdCallFailed)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final c = detail.customer;
    final due = detail.ordersWithDue;
    final totalDue = due.fold<int>(0, (s, o) => s + o.balancePaise);
    final hasPhone = whatsAppNumber(c.phone) != null;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.displayName, style: text.titleLarge),
                const SizedBox(height: 2),
                Text(c.phone, style: text.bodyMedium),
                if (detail.orders.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(l10n.posCustOrdersCount(detail.orders.length, formatPaise(detail.orders.where((o) => o.status != 'CANCELLED').fold<int>(0, (s, o) => s + o.totalPaise))), style: text.bodySmall),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(onPressed: c.phone.isEmpty ? null : () => _call(context, ref), icon: const Icon(Icons.call_rounded), label: Text(l10n.posCustCall)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: hasPhone ? () => showWhatsAppSheet(context, customerName: c.displayName, phone: c.phone, orders: detail.orders) : null,
                        icon: const Icon(Icons.chat_rounded),
                        label: Text(l10n.posCustWhatsApp),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Semantics(header: true, child: Text(l10n.posCustDuesTitle, style: text.titleMedium)),
        const SizedBox(height: 8),
        if (due.isEmpty)
          PosNote(icon: Icons.check_circle_rounded, tone: PosTone.success, text: l10n.posCustNoDues)
        else ...[
          PosNote(icon: Icons.account_balance_wallet_outlined, tone: PosTone.attention, text: l10n.posCustOwes(formatPaise(totalDue))),
          const SizedBox(height: 4),
          Text(l10n.posCustCollectHint, style: text.bodySmall),
          const SizedBox(height: 8),
          for (final o in due)
            Card(
              child: ListTile(
                minTileHeight: 64,
                leading: Icon(Icons.payments_outlined, color: scheme.primary),
                title: Text(l10n.posCustDueOrder(o.orderNumber)),
                subtitle: Text(formatPaise(o.balancePaise)),
                trailing: Text(l10n.posCustCollect, style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w700)),
                onTap: () => context.push(AppRoutes.posOrderDetailPath(o.id)),
              ),
            ),
        ],
        if (detail.notes.trim().isNotEmpty) ...[
          const SizedBox(height: 16),
          Semantics(header: true, child: Text(l10n.posCustNotes, style: text.titleMedium)),
          const SizedBox(height: 4),
          Text(detail.notes),
        ],
        if (detail.addresses.isNotEmpty) ...[
          const SizedBox(height: 16),
          Semantics(header: true, child: Text(l10n.posCustAddresses, style: text.titleMedium)),
          for (final a in detail.addresses) ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.place_outlined), title: Text(a.line), subtitle: a.label.isEmpty ? null : Text(a.label)),
        ],
        const SizedBox(height: 16),
        Semantics(header: true, child: Text(l10n.posCustHistory, style: text.titleMedium)),
        const SizedBox(height: 8),
        if (detail.orders.isEmpty) Text(l10n.posCustNoOrders) else for (final CounterOrder o in detail.orders) Padding(padding: const EdgeInsets.only(bottom: 10), child: OrderCard(order: o, onOpen: () => context.push(AppRoutes.posOrderDetailPath(o.id)))),
      ],
    );
  }
}
