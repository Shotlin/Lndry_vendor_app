import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/pos/pos_catalogue_model.dart';
import '../core/money.dart';
import '../core/pos_theme.dart';
import 'add_garment_price_sheet.dart' show unitLabelOf;

/// "−  2  +" with big targets and spoken labels. Shared by the garment tiles and the cart rows.
class QtyStepper extends StatelessWidget {
  const QtyStepper({required this.qty, required this.name, required this.onChanged, super.key});
  final int qty;
  final String name;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      container: true,
      label: l10n.posBookQtySemantics(name, qty),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton.filledTonal(
            onPressed: () => onChanged(qty - 1),
            tooltip: l10n.posBookRemoveOne(name),
            icon: const Icon(Icons.remove_rounded),
            constraints: const BoxConstraints(minWidth: PosTheme.minTouch, minHeight: PosTheme.minTouch),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 36),
            child: Text('$qty', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          ),
          IconButton.filled(
            onPressed: () => onChanged(qty + 1),
            tooltip: l10n.posBookAddOne(name),
            style: IconButton.styleFrom(backgroundColor: scheme.primary, foregroundColor: scheme.onPrimary),
            icon: const Icon(Icons.add_rounded),
            constraints: const BoxConstraints(minWidth: PosTheme.minTouch, minHeight: PosTheme.minTouch),
          ),
        ],
      ),
    );
  }
}

/// One garment in the grid: its name, its shop price for the chosen service, and "Add" or a stepper.
class GarmentTile extends StatelessWidget {
  const GarmentTile({required this.garment, required this.ratePaise, required this.qty, required this.onSetQty, super.key});
  final PosGarment garment;
  final int ratePaise;
  final int qty;
  final ValueChanged<int> onSetQty;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final selected = qty > 0;
    final price = garment.unit == 'piece' ? formatPaise(ratePaise) : '${formatPaise(ratePaise)} / ${unitLabelOf(l10n, garment.unit)}';
    return Semantics(
      button: !selected,
      container: true,
      label: '${garment.name}, $price',
      onTap: selected ? null : () => onSetQty(1),
      child: Material(
        color: selected ? scheme.primaryContainer : scheme.surface,
        borderRadius: BorderRadius.circular(PosTheme.radius),
        child: InkWell(
          borderRadius: BorderRadius.circular(PosTheme.radius),
          onTap: selected ? null : () => onSetQty(1),
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(PosTheme.radius),
              border: Border.all(color: selected ? scheme.primary : scheme.outline, width: selected ? 2 : 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(garment.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: text.titleSmall),
                const SizedBox(height: 2),
                Text(price, maxLines: 1, overflow: TextOverflow.ellipsis, style: text.bodySmall),
                const Spacer(),
                if (selected)
                  Align(alignment: Alignment.centerRight, child: QtyStepper(qty: qty, name: garment.name, onChanged: onSetQty))
                else
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 40),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(color: scheme.primary, borderRadius: BorderRadius.circular(20)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.add_rounded, size: 18, color: scheme.onPrimary),
                        const SizedBox(width: 4),
                        Text(l10n.posPriceAdd, style: text.labelLarge?.copyWith(color: scheme.onPrimary)),
                      ]),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
