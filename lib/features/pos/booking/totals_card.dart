import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../core/money.dart';
import '../core/pos_widgets.dart';
import '../core/qty.dart';
import 'book_order_state.dart';

/// The bill. Every figure is the server's answer; while a newer answer is on its way the old one is shown
/// with a "Calculating…" note, and a failed request says so instead of showing a guess.
class TotalsCard extends StatelessWidget {
  const TotalsCard({required this.state, required this.onRetry, super.key});
  final BookOrderState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final q = state.quote;
    final stale = state.quoteStatus == QuoteStatus.loading || (q != null && !state.quoteIsCurrent);
    Widget row(String label, String value, {bool strong = false}) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(children: [
            Expanded(child: Text(label, style: strong ? text.titleMedium : text.bodyMedium)),
            Text(value, style: (strong ? text.titleLarge : text.bodyMedium)?.copyWith(fontWeight: FontWeight.w800)),
          ]),
        );
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: scheme.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: scheme.outline)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          row(l10n.posBookItems, fmtQty(state.totalQty)),
          row(l10n.posBookSubtotal, formatPaise(q?.subtotalPaise)),
          if (q != null) ...[
            for (final c in q.charges) row(c.label, formatPaise(c.amountPaise)),
            if (q.charges.isEmpty && q.chargesPaise > 0) row(l10n.posBookCharge, formatPaise(q.chargesPaise)),
            for (final d in q.discounts) row(d.label, '-${formatPaise(d.amountPaise)}'),
            if (q.discounts.isEmpty && q.discountsPaise > 0) row(l10n.posBookDiscount, '-${formatPaise(q.discountsPaise)}'),
            if (q.taxPaise > 0 || q.taxRateBps > 0) row(l10n.posBookTaxPercent(percentFromBps(q.taxRateBps)), formatPaise(q.taxPaise)),
          ],
          Divider(color: scheme.outline),
          Semantics(
            container: true,
            liveRegion: true,
            label: '${l10n.posBookGrandTotal}: ${formatPaise(q?.totalPaise)}',
            excludeSemantics: true,
            child: row(l10n.posBookGrandTotal, formatPaise(q?.totalPaise), strong: true),
          ),
          if (stale)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(children: [
                const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2)),
                const SizedBox(width: 8),
                Text(l10n.posBookCalculating, style: text.bodySmall),
              ]),
            ),
          if (state.quoteStatus == QuoteStatus.failed) ...[
            const SizedBox(height: 8),
            PosErrorNote(message: '${l10n.posBookQuoteError}\n${state.quoteError ?? ''}'.trim(), onRetry: onRetry, retryLabel: l10n.posRetry),
          ],
        ],
      ),
    );
  }
}
