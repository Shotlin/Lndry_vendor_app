import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/friendly_error.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../models/pos/pos_money_model.dart';
import '../core/money.dart';
import '../core/pos_money_providers.dart';
import '../core/pos_providers.dart';
import '../core/pos_widgets.dart';
import '../orders/order_labels.dart';
import 'expense_sheets.dart';

/// The counter cash drawer: closed (open it), or open with live numbers (close it after counting).
/// Every figure is the server's — "should be in the drawer" is opening + cash received − cash paid out, worked out there.
class CashDrawerCard extends ConsumerWidget {
  const CashDrawerCard({super.key});

  void _refresh(WidgetRef ref) {
    ref.invalidate(posCurrentShiftProvider);
    ref.invalidate(posShiftHistoryProvider);
    ref.invalidate(posDashboardProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final shift = ref.watch(posCurrentShiftProvider);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: shift.when(
          loading: () => const Padding(padding: EdgeInsets.all(8), child: Center(child: CircularProgressIndicator())),
          error: (e, _) => PosErrorNote(message: '${l10n.posDrawerTitle}\n${friendlyError(e)}', onRetry: () => ref.invalidate(posCurrentShiftProvider), retryLabel: l10n.posRetry),
          data: (s) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(children: [
                const Icon(Icons.point_of_sale_rounded),
                const SizedBox(width: 8),
                Expanded(child: Semantics(header: true, child: Text(l10n.posDrawerTitle, style: text.titleMedium))),
              ]),
              const SizedBox(height: 8),
              if (s == null) ...[
                Text(l10n.posDrawerClosed, style: text.bodyMedium),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () async {
                    if (await showOpenDrawerSheet(context) == true) {
                      _refresh(ref);
                      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.posDrawerOpened)));
                    }
                  },
                  icon: const Icon(Icons.lock_open_rounded),
                  label: Text(l10n.posDrawerOpen),
                ),
              ] else ...[
                if (s.openedAt != null) Text(l10n.posDrawerOpenSince(dateTimeText(context, s.openedAt)), style: text.bodySmall),
                const SizedBox(height: 8),
                _Row(l10n.posDrawerOpening, formatPaise(s.openingCashPaise)),
                _Row(l10n.posDrawerIn, formatPaise(s.collectionsPaise)),
                _Row(l10n.posDrawerOut, formatPaise(s.expensesPaise)),
                const Divider(height: 20),
                _Row(l10n.posDrawerShould, formatPaise(s.expectedCashPaise), strong: true),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () async {
                    if (await showCloseDrawerSheet(context, s) == true) {
                      _refresh(ref);
                      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.posDrawerClosedOk)));
                    }
                  },
                  icon: const Icon(Icons.lock_rounded),
                  label: Text(l10n.posDrawerClose),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value, {this.strong = false});
  final String label;
  final String value;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final style = strong ? text.titleMedium : text.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: style)),
          const SizedBox(width: 12),
          Text(value, style: style?.copyWith(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

/// The last few closed drawers: what was counted and whether it matched.
class PastDrawers extends ConsumerWidget {
  const PastDrawers({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final list = ref.watch(posShiftHistoryProvider).valueOrNull?.where((s) => !s.open).take(5).toList() ?? const <CashShift>[];
    if (list.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Semantics(header: true, child: Text(l10n.posDrawerPast, style: text.titleMedium)),
        for (final s in list)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.history_rounded),
            title: Text(dateTimeText(context, s.closedAt ?? s.openedAt)),
            subtitle: Text(l10n.posDrawerPastLine(formatPaise(s.countedCashPaise), _diffText(l10n, s.variancePaise))),
          ),
      ],
    );
  }

  String _diffText(AppLocalizations l10n, int? v) {
    if (v == null) return '—';
    if (v == 0) return l10n.posDrawerDiffOk;
    return v < 0 ? l10n.posDrawerDiffShort(formatPaise(-v)) : l10n.posDrawerDiffExtra(formatPaise(v));
  }
}
