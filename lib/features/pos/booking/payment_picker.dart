import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/pos/pos_order_model.dart';
import '../core/pos_theme.dart';

/// How the customer pays now. Wallet is not offered here: using the LNDRY wallet needs the customer to
/// approve the amount with a one-time code, which is part of collecting payment on the order (Phase 3).
const List<PosPaymentMode> kBookingPaymentModes = [PosPaymentMode.cash, PosPaymentMode.online, PosPaymentMode.payLater];

class PaymentPicker extends StatelessWidget {
  const PaymentPicker({required this.selected, required this.onChanged, super.key});
  final PosPaymentMode selected;
  final ValueChanged<PosPaymentMode> onChanged;

  static String label(AppLocalizations l10n, PosPaymentMode m) => switch (m) {
        PosPaymentMode.cash => l10n.posPayCash,
        PosPaymentMode.online => l10n.posPayOnline,
        PosPaymentMode.wallet => '', // not offered at booking (see kBookingPaymentModes)
        PosPaymentMode.payLater => l10n.posPayLater,
      };

  static IconData icon(PosPaymentMode m) => switch (m) {
        PosPaymentMode.cash => Icons.payments_rounded,
        PosPaymentMode.online => Icons.qr_code_2_rounded,
        PosPaymentMode.wallet => Icons.account_balance_wallet_rounded,
        PosPaymentMode.payLater => Icons.schedule_rounded,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (var i = 0; i < kBookingPaymentModes.length; i++) ...[
              if (i > 0) const SizedBox(width: 8),
              Expanded(child: _option(context, kBookingPaymentModes[i])),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Text(selected == PosPaymentMode.payLater ? l10n.posPayLaterNote : l10n.posPayNowNote, style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
      ],
    );
  }

  Widget _option(BuildContext context, PosPaymentMode m) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final on = m == selected;
    return Semantics(
      button: true,
      selected: on,
      label: label(l10n, m),
      excludeSemantics: true,
      onTap: () => onChanged(m),
      child: Material(
        color: on ? scheme.primaryContainer : scheme.surface,
        borderRadius: BorderRadius.circular(PosTheme.radius),
        child: InkWell(
          borderRadius: BorderRadius.circular(PosTheme.radius),
          onTap: () => onChanged(m),
          child: Container(
            constraints: const BoxConstraints(minHeight: 72),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(PosTheme.radius),
              border: Border.all(color: on ? scheme.primary : scheme.outline, width: on ? 2 : 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(on ? Icons.check_circle_rounded : icon(m), color: on ? scheme.primary : scheme.onSurfaceVariant),
                const SizedBox(height: 4),
                Text(label(l10n, m), textAlign: TextAlign.center, style: Theme.of(context).textTheme.labelLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
