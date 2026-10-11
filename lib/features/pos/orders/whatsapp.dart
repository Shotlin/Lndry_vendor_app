import '../../../l10n/generated/app_localizations.dart';
import '../../../models/pos/pos_counter_order_model.dart';
import '../core/money.dart';
import 'order_labels.dart';
import 'order_state.dart';

/// `9811122233` → `919811122233` (the shop and its customers are in India). Anything else keeps its digits;
/// no usable number gives `null`.
String? whatsAppNumber(String phone) {
  var d = phone.replaceAll(RegExp(r'\D'), '');
  if (d.startsWith('00')) d = d.substring(2);
  if (d.length == 11 && d.startsWith('0')) d = d.substring(1);
  if (d.length == 10) return '91$d';
  return d.length >= 11 && d.length <= 15 ? d : null;
}

/// The friendly message pre-filled in WhatsApp: who, which order, its state in words, and what is still to pay.
/// Every number is the server's.
String buildWhatsAppMessage(AppLocalizations l10n,
    {required CounterOrder order, required String shopName}) {
  final name = order.customer.name.trim().isEmpty
      ? l10n.posWaCustomerFallback
      : order.customer.name.trim();
  final status = phaseLabel(l10n, order.phase);
  final shop = shopName.trim().isEmpty ? 'LNDRY' : shopName.trim();
  if (order.balancePaise > 0) {
    return l10n.posWaMessageDue(name, order.orderNumber, status,
        formatPaise(order.totalPaise), formatPaise(order.balancePaise), shop);
  }
  return l10n.posWaMessagePaid(
      name, order.orderNumber, status, formatPaise(order.totalPaise), shop);
}

/// `https://wa.me/<number>?text=<message>`, or `null` when the customer has no usable phone number.
Uri? whatsAppUri(String phone, String message) {
  final n = whatsAppNumber(phone);
  // Spaces must be %20 (not the form-style +) for WhatsApp to show the text as written.
  return n == null
      ? null
      : Uri.parse('https://wa.me/$n?text=${Uri.encodeComponent(message)}');
}
