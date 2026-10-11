import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../core/pos_widgets.dart';

/// Shown for a moment while the backend says which modes this vendor may use,
/// so the wrong UI never flashes. If the answer fails the app falls back to Marketplace
/// (see AppModeNotifier.load), so this screen can never get stuck.
class ModeCheckPage extends StatelessWidget {
  const ModeCheckPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PosThemeScope(
      child: Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 20),
                Text(l10n.posModeCheckLoading, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
