import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';

/// A tab whose real screen is built in a later phase. Says so plainly instead of showing a blank page.
class PosPlaceholderPage extends StatelessWidget {
  const PosPlaceholderPage({required this.title, required this.icon, super.key});
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
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
