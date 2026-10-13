import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/pos/pos_catalogue_model.dart';
import '../core/money.dart';
import '../core/pos_image.dart';
import '../core/pos_theme.dart';
import '../core/qty.dart';
import 'add_garment_price_sheet.dart' show unitLabelOf;

/// "−  2  +" with big targets and spoken labels. Shared by the garment tiles and the cart rows.
///
/// Pieces and pairs go up and down by one. Kg and sq ft items ([decimal]) go by half a unit, and tapping the
/// number lets the owner type an exact amount such as 0.6 or 1.25.
class QtyStepper extends StatelessWidget {
  const QtyStepper({required this.qty, required this.name, required this.onChanged, this.decimal = false, this.unitLabel, super.key});
  final double qty;
  final String name;
  final ValueChanged<double> onChanged;
  final bool decimal;

  /// "kg" / "sq ft": shown next to the number and in the typing dialog.
  final String? unitLabel;

  static const double _halfStep = 0.5;

  double get _step => decimal ? _halfStep : 1;

  double _down() {
    final next = double.parse((qty - _step).toStringAsFixed(2));
    return next < (decimal ? 0.1 : 1) ? 0 : next;
  }

  double _up() => double.parse((qty + _step).toStringAsFixed(2));

  Future<void> _typeExact(BuildContext context) async {
    final value = await showQtyDialog(context, name: name, unitLabel: unitLabel, initial: qty);
    if (value != null) onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final shown = fmtQty(qty);
    final number = Text(
      shown,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800, decoration: decimal ? TextDecoration.underline : null, decorationStyle: TextDecorationStyle.dotted),
    );
    return Semantics(
      container: true,
      label: l10n.posBookQtySemantics(name, decimal && unitLabel != null ? '$shown $unitLabel' : shown),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton.filledTonal(
            onPressed: () => onChanged(_down()),
            tooltip: l10n.posBookRemoveOne(name),
            icon: const Icon(Icons.remove_rounded),
            constraints: const BoxConstraints(minWidth: PosTheme.minTouch, minHeight: PosTheme.minTouch),
          ),
          if (decimal)
            InkWell(
              onTap: () => _typeExact(context),
              borderRadius: BorderRadius.circular(8),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 52, minHeight: PosTheme.minTouch),
                child: Center(child: number),
              ),
            )
          else
            ConstrainedBox(constraints: const BoxConstraints(minWidth: 36), child: number),
          IconButton.filled(
            onPressed: () => onChanged(_up()),
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

/// Asks for an exact quantity ("0.6", "1.25"). Returns null when cancelled; 0 never comes back (use the bin to remove).
Future<double?> showQtyDialog(BuildContext context, {required String name, String? unitLabel, double? initial}) {
  final l10n = AppLocalizations.of(context);
  final controller = TextEditingController(text: initial == null || initial <= 0 ? '' : fmtQty(initial));
  String? error;
  return showDialog<double>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) {
        void submit() {
          final v = parseQty(controller.text);
          if (v == null) {
            setState(() => error = l10n.posBookQtyInvalid);
          } else {
            Navigator.of(ctx).pop(v);
          }
        }

        return AlertDialog(
          title: Text(name, maxLines: 2, overflow: TextOverflow.ellipsis),
          content: TextField(
            controller: controller,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')), LengthLimitingTextInputFormatter(7)],
            onChanged: (_) => setState(() => error = null),
            onSubmitted: (_) => submit(),
            decoration: InputDecoration(
              labelText: l10n.posBookQtyDialogTitle(unitLabel ?? ''),
              suffixText: unitLabel,
              errorText: error,
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text(l10n.commonCancel)),
            FilledButton(onPressed: submit, child: Text(l10n.posBookQtyOk)),
          ],
        );
      },
    ),
  );
}

/// One garment in the grid: its name, its shop price for the chosen service, and "Add" or a stepper.
class GarmentTile extends StatelessWidget {
  const GarmentTile({required this.garment, required this.ratePaise, required this.qty, required this.onSetQty, this.imageUrl, super.key});
  final PosGarment garment;
  final int ratePaise;
  final double qty;
  final ValueChanged<double> onSetQty;

  /// The item's picture (the shop's own, else the admin's, else its category's). Null shows a lettered tile.
  final String? imageUrl;

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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PosImage(url: imageUrl, name: garment.name, size: 52),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(garment.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: text.titleSmall),
                          const SizedBox(height: 2),
                          Text(price, maxLines: 2, overflow: TextOverflow.ellipsis, style: text.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                if (selected)
                  Align(
                    alignment: Alignment.centerRight,
                    // On a narrow phone the +/− and a typed amount shrink a little rather than overflow.
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: QtyStepper(qty: qty, name: garment.name, decimal: !garment.isCountable, unitLabel: unitLabelOf(l10n, garment.unit), onChanged: onSetQty),
                    ),
                  )
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
