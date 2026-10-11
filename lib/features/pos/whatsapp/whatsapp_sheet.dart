import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/repositories/api_pos_repositories.dart';
import '../../../core/network/friendly_error.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../models/pos/pos_counter_order_model.dart';
import '../../../models/pos/pos_settings_model.dart';
import '../../../providers/app_mode_provider.dart';
import '../core/pos_money_providers.dart';
import '../core/pos_widgets.dart';
import '../customers/customer_picker.dart';
import '../orders/order_labels.dart';
import '../orders/orders_providers.dart';
import '../orders/whatsapp.dart';
import 'whatsapp_templates.dart';

/// "Message this customer": one tap opens WhatsApp with the text ready. Messages are the shop's saved ones
/// (same as on the counter software), filled from the customer's latest order. No WhatsApp Business API:
/// the person still presses Send in WhatsApp.
Future<void> showWhatsAppSheet(BuildContext context, {required String customerName, required String phone, required List<CounterOrder> orders}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => PosThemeScope(child: WhatsAppSheet(customerName: customerName, phone: phone, orders: orders)),
  );
}

class WhatsAppSheet extends ConsumerWidget {
  const WhatsAppSheet({required this.customerName, required this.phone, required this.orders, super.key});
  final String customerName;
  final String phone;

  /// Newest first. The messages talk about the first one that is not cancelled.
  final List<CounterOrder> orders;

  CounterOrder? get _latest {
    for (final o in orders) {
      if (o.status != 'CANCELLED') return o;
    }
    return null;
  }

  Future<void> _open(BuildContext context, WidgetRef ref, String message) async {
    final l10n = AppLocalizations.of(context);
    final uri = whatsAppUri(phone, message);
    final ok = uri != null && await ref.read(posUrlOpenerProvider)(uri);
    if (!context.mounted) return;
    if (ok) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.posWaOpenFailed)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final shop = ref.watch(appModeProvider.select((s) => s.info?.shopName)) ?? '';
    final templates = ref.watch(posMessageTemplatesProvider);
    final order = _latest;
    final name = customerName.trim().isEmpty ? l10n.posWaCustomerFallback : customerName.trim();
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 8, 20, MediaQuery.viewInsetsOf(context).bottom + 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.posWaSheetTitle(name), style: text.titleLarge),
            const SizedBox(height: 4),
            Text(phone, style: text.bodyMedium),
            const SizedBox(height: 16),
            PosChoiceCard(icon: Icons.chat_bubble_outline_rounded, title: l10n.posWaOpenChat, body: l10n.posWaOpenChatBody, onTap: () => _open(context, ref, l10n.posWaHello(name, shop.trim().isEmpty ? 'LNDRY' : shop.trim()))),
            const SizedBox(height: 16),
            if (order == null)
              Text(l10n.posWaNoOrder, style: text.bodyMedium)
            else ...[
              Semantics(header: true, child: Text(l10n.posWaForOrder(order.orderNumber), style: text.titleMedium)),
              const SizedBox(height: 8),
              if (order.balancePaise > 0) ...[
                PosChoiceCard(
                    icon: Icons.payments_outlined,
                    title: l10n.posWaPaymentDue,
                    body: l10n.posWaPaymentDueBody,
                    onTap: () => _open(context, ref, buildWhatsAppMessage(l10n, order: order, shopName: shop))),
                const SizedBox(height: 8),
              ],
              templates.when(
                loading: () => const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator())),
                error: (e, _) => PosErrorNote(message: '${l10n.posWaTemplatesFailed}\n${friendlyError(e)}', onRetry: () => ref.invalidate(posMessageTemplatesProvider), retryLabel: l10n.posRetry),
                data: (list) => Column(
                  children: [
                    for (final MessageTemplate t in list.where((t) => t.active)) ...[
                      PosChoiceCard(
                        icon: Icons.send_rounded,
                        title: t.label,
                        onTap: () => _open(context, ref, buildTemplateMessage(t, order, shopName: shop, dateText: (d) => dateText(context, d))),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ],
                ),
              ),
            ],
            const SizedBox(height: 8),
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.commonCancel)),
          ],
        ),
      ),
    );
  }
}

/// Home's WhatsApp quick action: choose a customer, then the message.
Future<void> startWhatsAppFlow(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final customer = await showCustomerPicker(context);
  if (customer == null || !context.mounted) return;
  var orders = const <CounterOrder>[];
  try {
    orders = (await ref.read(posCustomersRepositoryProvider).detail(customer.id)).orders;
  } catch (_) {
    // Still allow a plain chat: the orders only add the ready-made messages.
    messenger.showSnackBar(SnackBar(content: Text(l10n.posWaTemplatesFailed)));
  }
  if (!context.mounted) return;
  await showWhatsAppSheet(context, customerName: customer.displayName, phone: customer.phone, orders: orders);
}
