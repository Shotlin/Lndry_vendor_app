import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/repositories/api_pos_repositories.dart';
import '../../../core/network/friendly_error.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../models/pos/pos_catalogue_model.dart';
import '../../../models/pos/pos_settings_model.dart';
import 'money.dart';
import 'pos_money_providers.dart';
import 'pos_providers.dart';
import 'pos_widgets.dart';

Widget _frame(BuildContext context, String title, List<Widget> children) => PosThemeScope(
      child: Scaffold(appBar: AppBar(title: Text(title)), body: ListView(padding: const EdgeInsets.all(16), children: children)),
    );

/// "10" for 1000 bps → "10% of the bill"; a flat rule shows its rupees.
String ruleValueText(AppLocalizations l10n, PosAdjustmentRule r) {
  if (r.isPercentage) return l10n.posSetRulePercent(percentFromBps(r.percentageBps ?? 0));
  return l10n.posSetRuleFlat(formatPaise(r.flatPaise));
}

/// Read-only list of the saved extra charges and discounts the booking screen offers.
class PosRulesPage extends ConsumerWidget {
  const PosRulesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    Widget section(String title, List<PosAdjustmentRule> rules) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(padding: const EdgeInsets.only(top: 8, bottom: 4), child: Semantics(header: true, child: Text(title, style: text.titleMedium))),
          if (rules.isEmpty) Text(l10n.posSetRulesNone) else for (final r in rules) Card(child: ListTile(title: Text(r.name), subtitle: Text(ruleValueText(l10n, r)))),
        ]);
    final charges = ref.watch(posChargeRulesProvider);
    final discounts = ref.watch(posDiscountRulesProvider);
    return _frame(context, l10n.posSetRules, [
      if (charges.isLoading || discounts.isLoading) const LinearProgressIndicator(),
      section(l10n.posSetRulesCharges, charges.valueOrNull ?? const []),
      const SizedBox(height: 12),
      section(l10n.posSetRulesDiscounts, discounts.valueOrNull ?? const []),
    ]);
  }
}

class PosMessagesPage extends ConsumerWidget {
  const PosMessagesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(posMessageTemplatesProvider);
    return _frame(context, l10n.posSetMessages, [
      PosNote(icon: Icons.info_outline_rounded, text: l10n.posSetMessagesHint),
      const SizedBox(height: 12),
      async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => PosErrorNote(message: '${l10n.posSetLoadFailed}\n${friendlyError(e)}', onRetry: () => ref.invalidate(posMessageTemplatesProvider), retryLabel: l10n.posRetry),
        data: (list) => Column(children: [
          for (final MessageTemplate t in list) Card(child: ListTile(title: Text(t.label), subtitle: Padding(padding: const EdgeInsets.only(top: 4), child: Text(t.body)))),
        ]),
      ),
    ]);
  }
}

class PosTeamPage extends ConsumerWidget {
  const PosTeamPage({super.key});

  String _role(AppLocalizations l10n, String role) {
    switch (role) {
      case 'VENDOR_OWNER':
        return l10n.posSetRoleOwner;
      case 'VENDOR_RIDER':
        return l10n.posSetRoleRider;
    }
    return l10n.posSetRoleStaff;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(posStaffProvider);
    return _frame(context, l10n.posSetTeam, [
      PosNote(icon: Icons.info_outline_rounded, text: l10n.posSetTeamHint),
      const SizedBox(height: 12),
      async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => PosErrorNote(message: '${l10n.posSetLoadFailed}\n${friendlyError(e)}', onRetry: () => ref.invalidate(posStaffProvider), retryLabel: l10n.posRetry),
        data: (list) => Column(children: [
          for (final p in list)
            Card(
              child: ListTile(
                leading: const Icon(Icons.person_rounded),
                title: Text(p.displayName),
                subtitle: Text([_role(l10n, p.role), if (p.name.isNotEmpty) p.phone, if (!p.active) l10n.posSetInactive].where((e) => e.isNotEmpty).join(' · ')),
              ),
            ),
        ]),
      ),
    ]);
  }
}
