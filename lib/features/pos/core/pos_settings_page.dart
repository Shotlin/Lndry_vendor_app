import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../providers/app_mode_provider.dart';
import '../../../providers/auth_provider.dart';
import '../mode/mode_switch_section.dart';

/// POS Settings. Phase 1 holds the App mode switch and Log out; shop, tax, printer and team
/// settings arrive in Phase 4.
class PosSettingsPage extends ConsumerWidget {
  const PosSettingsPage({super.key});

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.profileLogoutTitle),
        content: Text(l10n.profileLogoutConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text(l10n.commonCancel)),
          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text(l10n.posLogOut)),
        ],
      ),
    );
    if (ok == true) await ref.read(authProvider.notifier).logout();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final info = ref.watch(appModeProvider.select((s) => s.info));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.posSettingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (info?.shopName != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.storefront_outlined, color: scheme.primary),
                  title: Text(info!.shopName!, style: const TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: Text(info.posPlanName ?? l10n.posSettingsShop),
                ),
              ),
            ),
          const ModeSwitchSection(),
          Card(
            child: ListTile(
              leading: Icon(Icons.logout_rounded, color: scheme.error),
              title: Text(l10n.posLogOut, style: const TextStyle(fontWeight: FontWeight.w700)),
              onTap: () => _confirmLogout(context, ref),
            ),
          ),
        ],
      ),
    );
  }
}
