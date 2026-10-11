import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';

/// A tab whose real screen is built in a later phase. Says so plainly instead of showing a blank page.
class PosPlaceholderPage extends StatelessWidget {
  const PosPlaceholderPage({required this.title, required this.icon, super.key, this.actionLabel, this.onAction});
  final String title;
  final IconData icon;

  /// An optional big button (e.g. "Book Order") so the tab is useful before its real screen exists.
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      floatingActionButton: onAction == null || actionLabel == null
          ? null
          : FloatingActionButton.extended(backgroundColor: scheme.primary, foregroundColor: scheme.onPrimary, onPressed: onAction, icon: const Icon(Icons.add_shopping_cart_rounded), label: Text(actionLabel!)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(color: scheme.primaryContainer, shape: BoxShape.circle),
                child: Icon(icon, size: 44, color: scheme.primary),
              ),
              const SizedBox(height: 20),
              Text(l10n.posComingSoonTitle, style: text.titleLarge),
              const SizedBox(height: 8),
              Text(l10n.posComingSoonBody, style: text.bodyMedium, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
