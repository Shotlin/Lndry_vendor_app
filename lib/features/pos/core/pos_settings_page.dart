import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../providers/app_mode_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/locale_provider.dart';
import '../booking/add_garment_price_sheet.dart';
import '../mode/mode_switch_section.dart';
import 'pos_providers.dart';
import 'pos_settings_lists.dart';
import 'pos_widgets.dart';

/// POS Settings: my shop (customers, price list, charges, messages, team), this app (language, mode), log out.
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

  String _languageLabel(Locale l) => l.scriptCode == 'Latn' ? 'Hinglish' : (l.languageCode == 'hi' ? 'हिंदी' : 'English');

  Future<void> _pickLanguage(BuildContext context, WidgetRef ref) async {
    final current = ref.read(localeProvider);
    const hinglish = Locale.fromSubtags(languageCode: 'hi', scriptCode: 'Latn');
    final options = <(String, Locale)>[('English', const Locale('en')), ('हिंदी', const Locale('hi')), ('Hinglish', hinglish)];
    final picked = await showModalBottomSheet<Locale>(
      context: context,
      useSafeArea: true,
      builder: (ctx) => PosThemeScope(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          for (final o in options)
            ListTile(
              minTileHeight: 60,
              leading: Icon(current == o.$2 ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded),
              title: Text(o.$1, style: Theme.of(ctx).textTheme.titleMedium),
              onTap: () => Navigator.of(ctx).pop(o.$2),
            ),
          const SizedBox(height: 12),
        ]),
      ),
    );
    if (picked != null) await ref.read(localeProvider.notifier).setLocale(picked);
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
          _Heading(l10n.posSetSectionShop),
          _Tile(icon: Icons.people_alt_outlined, title: l10n.posSetCustomers, body: l10n.posSetCustomersBody, onTap: () => context.push(AppRoutes.posCustomers)),
          if (ref.watch(posCanManageCatalogueProvider))
            _Tile(
              icon: Icons.sell_outlined,
              title: l10n.posSetPrices,
              body: l10n.posSetPricesBody,
              onTap: () async {
                final saved = await showAddGarmentPriceSheet(context);
                if (saved == true && context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.posPriceSaved)));
              },
            ),
          _Tile(icon: Icons.percent_rounded, title: l10n.posSetRules, body: l10n.posSetRulesBody, onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const PosRulesPage()))),
          _Tile(icon: Icons.chat_rounded, title: l10n.posSetMessages, body: l10n.posSetMessagesBody, onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const PosMessagesPage()))),
          _Tile(icon: Icons.groups_rounded, title: l10n.posSetTeam, body: l10n.posSetTeamBody, onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const PosTeamPage()))),
          _Heading(l10n.posSetSectionApp),
          _Tile(icon: Icons.translate_rounded, title: l10n.posSetLanguage, body: _languageLabel(ref.watch(localeProvider)), onTap: () => _pickLanguage(context, ref)),
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

class _Heading extends StatelessWidget {
  const _Heading(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 8),
        child: Semantics(header: true, child: Text(text, style: Theme.of(context).textTheme.titleMedium)),
      );
}

class _Tile extends StatelessWidget {
  const _Tile({required this.icon, required this.title, required this.body, required this.onTap});
  final IconData icon;
  final String title;
  final String body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        child: ListTile(
          minTileHeight: 68,
          leading: Icon(icon, color: scheme.primary, size: 28),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text(body),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: onTap,
        ),
      ),
    );
  }
}
