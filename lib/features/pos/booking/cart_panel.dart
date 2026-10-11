import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/pos/pos_catalogue_model.dart';
import '../../../models/pos/pos_order_model.dart';
import '../core/money.dart';
import 'garment_grid.dart';

/// "Selected Garments": one row per garment + service with its quantity, the server's line amount and a delete button.
class CartPanel extends StatelessWidget {
  const CartPanel({
    required this.lines,
    required this.catalogue,
    required this.quote,
    required this.quoteIsCurrent,
    required this.canChangePrice,
    required this.onSetQty,
    required this.onChangePrice,
    super.key,
  });

  final List<CartLine> lines;
  final PosCatalogue catalogue;
  final PosQuote? quote;

  /// The quote belongs to exactly this cart. When false the line amounts are shown as "…".
  final bool quoteIsCurrent;
  final bool canChangePrice;
  final void Function(CartLine line, int qty) onSetQty;
  final void Function(CartLine line) onChangePrice;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(color: scheme.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: scheme.outline)),
      child: lines.isEmpty
          ? Padding(padding: const EdgeInsets.all(20), child: Center(child: Text(l10n.posBookCartEmpty, style: text.bodyMedium)))
          : Column(
              children: [
                for (var i = 0; i < lines.length; i++) ...[
                  if (i > 0) Divider(height: 1, color: scheme.outline),
                  _row(context, lines[i]),
                ],
              ],
            ),
    );
  }

  Widget _row(BuildContext context, CartLine line) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final garment = catalogue.garment(line.garmentId);
    final service = catalogue.service(line.serviceId);
    final name = garment?.name ?? '—';
    final priced = quoteIsCurrent ? quote?.lineFor(line.garmentId, line.serviceId) : null;
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 6, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: text.titleSmall),
                    Text(service?.name ?? '', style: text.bodySmall),
                  ],
                ),
              ),
              Text(priced == null ? '…' : formatPaise(priced.amountPaise), style: text.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
              IconButton(
                onPressed: () => onSetQty(line, 0),
                tooltip: l10n.posBookRemoveLine(name),
                icon: const Icon(Icons.delete_outline_rounded),
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              ),
            ],
          ),
          // A Wrap, not a Row: with big text or a long Hindi label "Change price" drops to its own line.
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              QtyStepper(qty: line.qty, name: name, onChanged: (q) => onSetQty(line, q)),
              if (canChangePrice) TextButton.icon(onPressed: () => onChangePrice(line), icon: const Icon(Icons.edit_rounded, size: 18), label: Text(l10n.posBookChangePrice)),
            ],
          ),
        ],
      ),
    );
  }
}
