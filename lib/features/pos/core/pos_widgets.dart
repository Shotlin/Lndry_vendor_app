import 'package:flutter/material.dart';

import 'pos_colors.dart';
import 'pos_theme.dart';

/// Gives every POS screen the Epic-violet theme, in light or dark to match the device setting.
class PosThemeScope extends StatelessWidget {
  const PosThemeScope({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Theme(data: dark ? PosTheme.dark() : PosTheme.light(), child: child);
  }
}

/// A big tappable option with an icon, a title and a plain-words description.
/// Used wherever the user must pick one thing (product, printer, price list) — large target,
/// text next to every icon, and the selection is shown by border + check mark, not colour alone.
class PosChoiceCard extends StatelessWidget {
  const PosChoiceCard({
    required this.icon,
    required this.title,
    super.key,
    this.body,
    this.selected = false,
    this.onTap,
    this.busy = false,
  });

  final IconData icon;
  final String title;
  final String? body;
  final bool selected;
  final VoidCallback? onTap;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      selected: selected,
      enabled: onTap != null && !busy,
      label: body == null ? title : '$title. $body',
      excludeSemantics: true,
      onTap: onTap,
      child: Material(
        color: selected ? scheme.primaryContainer : scheme.surface,
        borderRadius: BorderRadius.circular(PosTheme.radius),
        child: InkWell(
          borderRadius: BorderRadius.circular(PosTheme.radius),
          onTap: busy ? null : onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: PosTheme.minTouch + 24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(PosTheme.radius),
              border: Border.all(color: selected ? scheme.primary : scheme.outline, width: selected ? 2 : 1),
            ),
            child: Row(
              crossAxisAlignment: body == null ? CrossAxisAlignment.center : CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: scheme.primaryContainer, borderRadius: BorderRadius.circular(12)),
                  child: Icon(icon, color: scheme.primary, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: text.titleMedium),
                      if (body != null) ...[
                        const SizedBox(height: 4),
                        Text(body!, style: text.bodySmall),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (busy)
                  const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5))
                else if (selected)
                  Icon(Icons.check_circle_rounded, color: scheme.primary)
                else
                  Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// An inline, plain-words error with a way to try again.
class PosErrorNote extends StatelessWidget {
  const PosErrorNote({required this.message, super.key, this.onRetry, this.retryLabel});
  final String message;
  final VoidCallback? onRetry;
  final String? retryLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.error.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(PosTheme.radius),
        border: Border.all(color: scheme.error),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.error_outline_rounded, color: scheme.error),
              const SizedBox(width: 10),
              Expanded(child: Text(message, style: TextStyle(color: scheme.onSurface))),
            ],
          ),
          // On its own line so a long label (or large text) can never push the message off screen.
          if (onRetry != null && retryLabel != null) Align(alignment: AlignmentDirectional.centerEnd, child: TextButton(onPressed: onRetry, child: Text(retryLabel!))),
        ],
      ),
    );
  }
}

/// Meaning of a colour. Always paired with a word or icon — colour alone never carries meaning.
enum PosTone { neutral, success, attention, danger }

/// Text/icon colour and background for [tone], readable (>= 4.5:1 for words) in light and dark.
({Color fg, Color bg}) posToneColors(BuildContext context, PosTone tone) {
  final dark = Theme.of(context).brightness == Brightness.dark;
  final scheme = Theme.of(context).colorScheme;
  switch (tone) {
    case PosTone.success:
      return dark ? (fg: PosColors.darkSuccess, bg: PosColors.darkRaised) : (fg: PosColors.success, bg: PosColors.successWash);
    case PosTone.attention:
      return dark ? (fg: PosColors.darkAttention, bg: PosColors.darkRaised) : (fg: PosColors.attentionText, bg: PosColors.attentionWash);
    case PosTone.danger:
      return dark ? (fg: scheme.error, bg: PosColors.darkRaised) : (fg: PosColors.dangerText, bg: PosColors.dangerWash);
    case PosTone.neutral:
      return (fg: scheme.onSurfaceVariant, bg: scheme.surfaceContainerHighest);
  }
}

/// A grey rounded block shown while numbers load.
class PosSkeleton extends StatelessWidget {
  const PosSkeleton({super.key, this.height = 16, this.width});
  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(8)),
      );
}

/// "10" for 1000 bps, "7.5" for 750, "2.25" for 225 — integer maths only.
String percentFromBps(int bps) {
  final whole = bps ~/ 100;
  final rest = bps % 100;
  if (rest == 0) return '$whole';
  final frac = rest.toString().padLeft(2, '0').replaceFirst(RegExp(r'0$'), '');
  return '$whole.$frac';
}
