import '../../../models/pos/pos_counter_order_model.dart';
import '../../../models/pos/pos_settings_model.dart';
import '../core/money.dart';

/// Fills one saved message for [order]. Every number comes from the server's order; nothing is worked out here.
/// [dateText] turns `YYYY-MM-DD` into the app's date style.
String buildTemplateMessage(
  MessageTemplate template,
  CounterOrder order, {
  required String shopName,
  required String Function(String? ymd) dateText,
}) {
  final shop = shopName.trim().isEmpty ? 'LNDRY' : shopName.trim();
  return fillTemplate(template.body, {
    'Brand': shop,
    'TeamName': shop,
    'CustomerName': order.customer.displayName,
    'CustomerPhone': order.customer.phone,
    'OrderNo': order.orderNumber,
    'OrderDate': dateText(order.orderDate),
    'DeliveryDate': dateText(order.expectedDeliveryDate),
    'TotalGarments': '${order.pieceCount}',
    'TotalAmount': formatPaise(order.totalPaise),
    'Paid': formatPaise(order.amountPaidPaise),
    'Balance': formatPaise(order.balancePaise),
    if ((order.notes ?? '').trim().isNotEmpty) 'Remarks': order.notes!.trim(),
  });
}
