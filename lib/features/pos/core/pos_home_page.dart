import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../providers/app_mode_provider.dart';

/// Phase 1 Home: a welcome only. The real dashboard (numbers, Book Order, quick actions) is Phase 2.
class PosHomePage extends ConsumerWidget {
  const PosHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final shop = ref.watch(appModeProvider.select((s) => s.info?.shopName)) ?? '';
    return Scaffold(
      appBar: AppBar(title: Text(l10n.posTabHome)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.waving_hand_rounded, color: scheme.primary, size: 32),
                  const SizedBox(height: 12),
                  Text(l10n.posHomeWelcome(shop), style: text.titleLarge),
                  const SizedBox(height: 8),
                  Text(l10n.posHomeReady, style: text.bodyMedium),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
