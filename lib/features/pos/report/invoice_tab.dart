import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../api/repositories/api_pos_repositories.dart';
import '../../../core/network/friendly_error.dart';
import '../../../core/router/app_routes.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../models/pos/pos_counter_order_model.dart';
import '../../../models/pos/pos_money_model.dart';
import '../core/money.dart';
import '../core/pos_widgets.dart';
import '../orders/order_labels.dart';
import 'line_chart.dart';
import 'report_providers.dart';

const int kInvoicePageSize = 10;

/// Orders in the period, one page at a time (non-cancelled), newest first — the same list the Orders tab uses.
typedef InvoicePageKey = ({ReportRange range, int page});

final posInvoicePageProvider = FutureProvider.autoDispose.family<List<CounterOrder>, InvoicePageKey>(
  (ref, k) => ref.watch(posOrdersRepositoryProvider).listOrders(
        OrderFilter(statuses: const ['BOOKED', 'PICKED_UP', 'IN_PROCESS', 'READY', 'OUT_FOR_DELIVERY', 'DELIVERED'], from: k.range.from, to: k.range.to),
        limit: kInvoicePageSize,
        offset: k.page * kInvoicePageSize,
      ),
);

PosTone _payTone(String s) => s == 'PAID' ? PosTone.success : (s == 'PART_PAID' ? PosTone.attention : PosTone.danger);

/// "Invoices": total revenue, a table of invoices (number, amount, Paid / Part paid / Pending) with Previous / Next,
/// and a chart of what was billed each day. Tap a row to open the order (invoice, tags, payment).
class InvoiceTab extends ConsumerStatefulWidget {
  const InvoiceTab({required this.range, required this.report, super.key});
  final ReportRange range;
  final AsyncValue<PosReport> report;

  @override
  ConsumerState<InvoiceTab> createState() => _InvoiceTabState();
}

class _InvoiceTabState extends ConsumerState<InvoiceTab> {
  int _page = 0;
  ReportRange? _forRange;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    if (_forRange != widget.range) {
      _forRange = widget.range;
      _page = 0;
    }
    final key = (range: widget.range, page: _page);
    final list = ref.watch(posInvoicePageProvider(key));
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(color: scheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(12)),
          child: Row(children: [
            Expanded(child: Text(l10n.posRepTotalRevenue, style: text.titleMedium)),
            Text(formatPaise(widget.report.valueOrNull?.revenuePaise), style: text.titleLarge?.copyWith(color: scheme.primary, fontWeight: FontWeight.w800)),
          ]),
        ),
        const SizedBox(height: 16),
        Semantics(header: true, child: Text(l10n.posRepTabInvoices, style: text.titleLarge)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(border: Border.all(color: scheme.outline), borderRadius: BorderRadius.circular(12)),
          clipBehavior: Clip.antiAlias,
          child: Column(children: [
            Container(
              color: scheme.surfaceContainerHighest,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(children: [
                Expanded(flex: 5, child: Text(l10n.posRepInvNo, style: text.labelLarge)),
                Expanded(flex: 3, child: Text(l10n.posRepAmount, style: text.labelLarge)),
                Expanded(flex: 4, child: Text(l10n.posRepStatus, style: text.labelLarge)),
              ]),
            ),
            list.when(
              loading: () => const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator())),
              error: (e, _) => Padding(padding: const EdgeInsets.all(12), child: PosErrorNote(message: '${l10n.posRepInvoicesFailed}\n${friendlyError(e)}', onRetry: () => ref.invalidate(posInvoicePageProvider(key)), retryLabel: l10n.posRetry)),
              data: (orders) => orders.isEmpty
                  ? Padding(padding: const EdgeInsets.all(20), child: Text(l10n.posRepNoInvoices))
                  : Column(children: [
                      for (final o in orders)
                        InkWell(
                          onTap: () => context.push(AppRoutes.posOrderDetailPath(o.id)),
                          child: Container(
                            constraints: const BoxConstraints(minHeight: 52),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(border: Border(top: BorderSide(color: scheme.outline))),
                            child: Row(children: [
                              Expanded(flex: 5, child: Text(o.orderNumber, style: text.bodyMedium?.copyWith(decoration: TextDecoration.underline, color: scheme.primary, fontWeight: FontWeight.w700))),
                              Expanded(flex: 3, child: Text(formatPaise(o.totalPaise))),
                              Expanded(flex: 4, child: Align(alignment: AlignmentDirectional.centerStart, child: PosStatusChip(label: paymentStatusLabel(l10n, o.paymentStatus), tone: _payTone(o.paymentStatus)))),
                            ]),
                          ),
                        ),
                    ]),
            ),
          ]),
        ),
        const SizedBox(height: 8),
        Row(children: [
          TextButton.icon(onPressed: _page == 0 ? null : () => setState(() => _page--), icon: const Icon(Icons.arrow_back_rounded), label: Text(l10n.posRepPrev)),
          Expanded(child: Text(l10n.posRepPage(_page + 1), textAlign: TextAlign.center, style: text.titleSmall)),
          TextButton.icon(
            iconAlignment: IconAlignment.end,
            onPressed: (list.valueOrNull?.length ?? 0) < kInvoicePageSize ? null : () => setState(() => _page++),
            icon: const Icon(Icons.arrow_forward_rounded),
            label: Text(l10n.posRepNext),
          ),
        ]),
        const SizedBox(height: 16),
        Semantics(header: true, child: Text(l10n.posRepChartBilled, style: text.titleLarge)),
        const SizedBox(height: 8),
        widget.report.when(
          loading: () => const SizedBox(height: 120),
          error: (_, __) => const SizedBox.shrink(),
          data: (r) => MoneyLineChart(title: l10n.posRepChartBilled, points: [for (final d in r.daily) ChartPoint(d.date.length >= 10 ? '${d.date.substring(8, 10)}/${d.date.substring(5, 7)}' : d.date, d.revenuePaise)]),
        ),
      ],
    );
  }
}
