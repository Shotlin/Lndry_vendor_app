import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/friendly_error.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../providers/app_mode_provider.dart';
import '../../../providers/auth_provider.dart';
import '../core/pos_widgets.dart';

/// First-run question for someone with no shop yet: do you want customers from LNDRY (Marketplace)
/// or a billing counter for your own shop (POS)? Two big options, plain words.
class ChooseProductPage extends ConsumerStatefulWidget {
  const ChooseProductPage({super.key});

  @override
  ConsumerState<ChooseProductPage> createState() => _ChooseProductPageState();
}

class _ChooseProductPageState extends ConsumerState<ChooseProductPage> {
  bool _startingPos = false;
  String? _error;

  Future<void> _chooseMarketplace() async {
    final auth = ref.read(authProvider);
    final phone = auth is AuthNeedsVendorApplication ? auth.phone : '';
    await ref.read(appModeProvider.notifier).chooseMarketplaceApplication(phone);
    // The router now lets this person into the application wizard.
  }

  Future<void> _choosePos() async {
    if (_startingPos) return;
    setState(() {
      _startingPos = true;
      _error = null;
    });
    try {
      await ref.read(appModeProvider.notifier).startPosAsNewUser();
      // Signed in with the new shop: the router moves on to POS setup by itself.
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = friendlyError(e));
    } finally {
      if (mounted) setState(() => _startingPos = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PosThemeScope(
      child: Builder(builder: (context) {
        final text = Theme.of(context).textTheme;
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.posChoiceTitle),
            automaticallyImplyLeading: false,
            actions: [
              TextButton(onPressed: _startingPos ? null : () => ref.read(authProvider.notifier).logout(), child: Text(l10n.posLogOut)),
            ],
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(l10n.posChoiceSubtitle, style: text.bodyMedium),
                const SizedBox(height: 20),
                PosChoiceCard(
                  icon: Icons.storefront_outlined,
                  title: l10n.posChoiceMarketplaceTitle,
                  body: l10n.posChoiceMarketplaceBody,
                  onTap: _startingPos ? null : _chooseMarketplace,
                ),
                const SizedBox(height: 14),
                PosChoiceCard(
                  icon: Icons.point_of_sale_rounded,
                  title: l10n.posChoicePosTitle,
                  body: l10n.posChoicePosBody,
                  busy: _startingPos,
                  onTap: _choosePos,
                ),
                const SizedBox(height: 18),
                Text(l10n.posChoiceBothHint, style: text.bodySmall),
                if (_error != null) ...[
                  const SizedBox(height: 16),
                  PosErrorNote(message: _error!, onRetry: _choosePos, retryLabel: l10n.commonRetry),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }
}
