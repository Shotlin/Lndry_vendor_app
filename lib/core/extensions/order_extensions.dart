import '../../models/order_model.dart';

extension OrderDisplayExtension on OrderModel {
  /// The customer-facing order number the backend generated for this order
  /// (e.g. `LNDR-20260919-43T`) — the same one the customer app, the admin
  /// dashboard and the invoice show.
  ///
  /// Never falls back to a slice of the database id: an internal id such as
  /// `E62A5F38` means nothing to anyone and doesn't match any other screen.
  String get displayNumber {
    final number = orderNumber.trim();
    return number.isNotEmpty ? number : '—';
  }

  /// A customer's "Book With Expert Check" order.
  bool get isAssisted => bookingType == 'ASSISTED';

  /// Assisted and the vendor hasn't chosen the services yet — there are no
  /// lines and no service price; only pickup/platform fees exist.
  bool get awaitingServiceSelection => isAssisted && items.isEmpty;
}
