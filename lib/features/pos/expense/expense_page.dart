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
import 'cash_drawer_card.dart';
import 'expense_labels.dart';
import 'expense_providers.dart';
import 'expense_sheets.dart';

/// Expense tab: the cash drawer, and what the shop paid out today or this month.
class PosExpensePage extends ConsumerStatefulWidget {
  const PosExpensePage({super.key, this.now});

  /// Override the clock in tests.
  final DateTime? now;

  @override
  ConsumerState<PosExpensePage> createState() => _PosExpensePageState();
}

class _PosExpensePageState extends ConsumerState<PosExpensePage> {
  ExpenseRange _range = ExpenseRange.today;

  DayRange get _dates => rangeFor(_range, widget.now ?? DateTime.now());

  Future<void> _refresh() async {
    ref.invalidate(posExpensesProvider(_dates));
    ref.invalidate(posCurrentShiftProvider);
    ref.invalidate(posShiftHistoryProvider);
    try {
      await ref.read(posExpensesProvider(_dates).future);
    } catch (_) {
      // Shown in the list.
    }
  }

  void _changed(String message) {
    ref.invalidate(posExpensesProvider);
    ref.invalidate(posCurrentShiftProvider);
    ref.invalidate(posDashboardProvider);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _add() async {
    final l10n = AppLocalizations.of(context);
    if (await showExpenseSheet(context) == true && mounted) _changed(l10n.posExpSaved);
  }

  Future<void> _open(PosExpense e) async {
    final l10n = AppLocalizations.of(context);
    final what = await showModalBottomSheet<String>(
      context: context,
      useSafeArea: true,
      builder: (ctx) => PosThemeScope(child: _ExpenseActions(expense: e)),
    );
    if (!mounted || what == null) return;
    if (what == 'edit' && await showExpenseSheet(context, existing: e) == true && mounted) _changed(l10n.posExpSaved);
    if (what == 'cancel' && await showCancelExpenseSheet(context, e) == true && mounted) _changed(l10n.posExpCancelled);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    if (!ref.watch(posCanUseCashProvider)) {
      return Scaffold(appBar: AppBar(title: Text(l10n.posExpTitle)), body: Padding(padding: const EdgeInsets.all(24), child: PosNote(icon: Icons.lock_outline_rounded, text: l10n.posMoneyNoAccess)));
    }
    final list = ref.watch(posExpensesProvider(_dates));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.posExpTitle)),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        onPressed: _add,
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.posExpAdd),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
          children: [
            const CashDrawerCard(),
            const PastDrawers(),
            const SizedBox(height: 20),
            Wrap(spacing: 8, children: [
              ChoiceChip(label: Text(l10n.posExpToday), selected: _range == ExpenseRange.today, onSelected: (_) => setState(() => _range = ExpenseRange.today)),
              ChoiceChip(label: Text(l10n.posExpThisMonth), selected: _range == ExpenseRange.month, onSelected: (_) => setState(() => _range = ExpenseRange.month)),
            ]),
            const SizedBox(height: 12),
            list.when(
              loading: () => const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator())),
              error: (e, _) => PosErrorNote(message: '${l10n.posExpLoadError}\n${friendlyError(e)}', onRetry: () => ref.invalidate(posExpensesProvider(_dates)), retryLabel: l10n.posRetry),
              data: (items) {
                final spent = items.where((e) => !e.cancelled).fold<int>(0, (s, e) => s + e.amountPaise);
                if (items.isEmpty) {
                  return Padding(padding: const EdgeInsets.all(16), child: Text(l10n.posExpEmpty, style: text.bodyLarge, textAlign: TextAlign.center));
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(l10n.posExpSpent(formatPaise(spent)), style: text.titleMedium),
                    const SizedBox(height: 8),
                    for (final e in items) _ExpenseTile(expense: e, onTap: () => _open(e)),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpenseTile extends StatelessWidget {
  const _ExpenseTile({required this.expense, required this.onTap});
  final PosExpense expense;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final e = expense;
    final strike = e.cancelled ? TextDecoration.lineThrough : null;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        minTileHeight: 64,
        onTap: onTap,
        title: Text(e.name, style: text.titleSmall?.copyWith(decoration: strike)),
        subtitle: Text('${l10n.posExpBy(expenseCategoryLabel(l10n, e.category), expenseModeLabel(l10n, e.paymentMode))} · ${dateText(context, e.date)}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(formatPaise(e.amountPaise), style: text.titleSmall?.copyWith(fontWeight: FontWeight.w800, decoration: strike)),
            if (e.cancelled) Text(l10n.posExpCancelledTag, style: text.labelSmall?.copyWith(color: posToneColors(context, PosTone.danger).fg, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class _ExpenseActions extends StatelessWidget {
  const _ExpenseActions({required this.expense});
  final PosExpense expense;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final e = expense;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(e.name, style: text.titleLarge),
          Text('${formatPaise(e.amountPaise)} · ${l10n.posExpBy(expenseCategoryLabel(l10n, e.category), expenseModeLabel(l10n, e.paymentMode))}', style: text.bodyMedium),
          if ((e.notes ?? '').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 4), child: Text(e.notes!, style: text.bodySmall)),
          if (e.cancelled && (e.cancellationReason ?? '').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8), child: PosNote(icon: Icons.cancel_outlined, tone: PosTone.danger, text: e.cancellationReason!)),
          if (!e.cancelled) ...[
            const SizedBox(height: 16),
            FilledButton.icon(onPressed: () => Navigator.of(context).pop('edit'), icon: const Icon(Icons.edit_rounded), label: Text(l10n.posExpEdit)),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(foregroundColor: posToneColors(context, PosTone.danger).fg, side: BorderSide(color: Theme.of(context).colorScheme.error)),
              onPressed: () => Navigator.of(context).pop('cancel'),
              icon: const Icon(Icons.cancel_outlined),
              label: Text(l10n.posExpCancel),
            ),
          ],
        ],
      ),
    );
  }
}
