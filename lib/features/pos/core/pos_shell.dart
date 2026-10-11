import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/generated/app_localizations.dart';
import 'pos_widgets.dart';

/// Bottom navigation of POS mode: Home · Order · Search · Expense · Report · Setting.
/// Every tab has an icon AND a word. Back from any tab returns to Home first, then leaves the app.
class PosShell extends StatelessWidget {
  const PosShell({required this.navigationShell, super.key});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final index = navigationShell.currentIndex;
    final tabs = <(IconData, IconData, String)>[
      (Icons.home_outlined, Icons.home_rounded, l10n.posTabHome),
      (Icons.assignment_outlined, Icons.assignment_rounded, l10n.posTabOrder),
      (Icons.search_rounded, Icons.search_rounded, l10n.posTabSearch),
      (Icons.account_balance_wallet_outlined, Icons.account_balance_wallet_rounded, l10n.posTabExpense),
      (Icons.insert_chart_outlined_rounded, Icons.insert_chart_rounded, l10n.posTabReport),
      (Icons.settings_outlined, Icons.settings_rounded, l10n.posTabSetting),
    ];
    return PosThemeScope(
      child: Builder(
        builder: (context) => PopScope(
          canPop: index == 0,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) navigationShell.goBranch(0);
          },
          child: Scaffold(
            body: navigationShell,
            bottomNavigationBar: NavigationBar(
              selectedIndex: index,
              onDestinationSelected: (i) => navigationShell.goBranch(i, initialLocation: i == index),
              destinations: [
                for (final t in tabs) NavigationDestination(icon: Icon(t.$1), selectedIcon: Icon(t.$2), label: t.$3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
