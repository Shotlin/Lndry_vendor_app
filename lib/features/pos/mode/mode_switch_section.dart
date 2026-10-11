import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/friendly_error.dart';
import '../../../core/router/app_routes.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../models/pos/app_mode_model.dart';
import '../../../providers/app_mode_provider.dart';

String appModeLabel(AppLocalizations l10n, AppMode mode) =>
    mode == AppMode.pos ? l10n.posModePos : l10n.posModeMarketplace;

/// "App mode" block for both Settings pages.
///  * Both modes allowed → a Marketplace / POS switch.
///  * Marketplace-only owner → "Get POS for my shop".
///  * POS setup started but not finished → "Finish POS setup".
/// Staff may use the switch when the shop has both modes; "Get POS" / "Finish POS setup" are owner-only.
/// Renders nothing when none applies (marketplace-only shops, captains, or a failed lookup), so the
/// marketplace Settings page looks exactly as before for those users.
class ModeSwitchSection extends ConsumerStatefulWidget {
  const ModeSwitchSection({super.key});

  @override
  ConsumerState<ModeSwitchSection> createState() => _ModeSwitchSectionState();
}

class _ModeSwitchSectionState extends ConsumerState<ModeSwitchSection> {
  bool _starting = false;

  Future<void> _switchTo(AppMode mode) async {
    final l10n = AppLocalizations.of(context);
    final ok = await ref.read(appModeProvider.notifier).setMode(mode);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ok ? l10n.posAppModeSwitched(appModeLabel(l10n, mode)) : l10n.posAppModeNotAllowed)),
    );
    // The router moves to the right home screen by itself.
  }

  Future<void> _getPos() async {
    if (_starting) return;
    setState(() => _starting = true);
    try {
      await ref.read(appModeProvider.notifier).startPosAsExistingVendor();
      if (mounted) context.go(AppRoutes.posOnboarding);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(friendlyError(e))));
    } finally {
      if (mounted) setState(() => _starting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(appModeProvider);
    final info = mode.info;
    if (!mode.resolved || info == null || !info.hasVendor) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final owner = info.isOwner;
    final showSwitch = mode.canSwitch;
    final showGet = owner && info.canStartPos && info.offering == VendorOffering.marketplace;
    final showFinish = owner && info.needsPosOnboarding && info.offering != VendorOffering.marketplace;
    if (!showSwitch && !showGet && !showFinish) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        // A Card merges everything inside into ONE screen-reader item by default. This one holds two separate
        // controls (the mode switch and the Get/Finish POS tile), so they must stay individually focusable.
        semanticContainer: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Icon(Icons.swap_horiz_rounded, color: scheme.primary),
                const SizedBox(width: 10),
                Expanded(child: Text(l10n.posAppModeTitle, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16))),
              ]),
              if (showSwitch) ...[
                const SizedBox(height: 4),
                Text(l10n.posAppModeSubtitle, style: TextStyle(color: scheme.onSurfaceVariant)),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<AppMode>(
                    showSelectedIcon: false,
                    segments: [
                      for (final m in mode.allowed) ButtonSegment<AppMode>(value: m, label: Text(appModeLabel(l10n, m))),
                    ],
                    selected: {mode.effective},
                    onSelectionChanged: (s) => _switchTo(s.first),
                  ),
                ),
              ],
              if (showGet || showFinish) ...[
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  minVerticalPadding: 8,
                  leading: Icon(Icons.point_of_sale_rounded, color: scheme.primary),
                  title: Text(showGet ? l10n.posGetPosTitle : l10n.posFinishSetupTitle, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text(showGet ? l10n.posGetPosSubtitle : l10n.posFinishSetupSubtitle),
                  trailing: _starting
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5))
                      : const Icon(Icons.chevron_right_rounded),
                  onTap: showGet ? _getPos : () => context.go(AppRoutes.posOnboarding),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
