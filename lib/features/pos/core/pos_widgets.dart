import 'package:flutter/material.dart';

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
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: scheme.error),
          const SizedBox(width: 10),
          Expanded(child: Text(message, style: TextStyle(color: scheme.onSurface))),
          if (onRetry != null && retryLabel != null) TextButton(onPressed: onRetry, child: Text(retryLabel!)),
        ],
      ),
    );
  }
}
