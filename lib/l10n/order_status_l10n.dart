import '../models/models.dart';
import 'generated/app_localizations.dart';

/// Localized display label for [OrderStatus], mirroring
/// [OrderStatus.label] (kept as-is for any non-UI/debug use) but resolved
/// through [AppLocalizations] instead of a hardcoded English string.
String orderStatusLabel(AppLocalizations l10n, OrderStatus status) {
  return switch (status) {
    OrderStatus.paymentPending => l10n.orderStatusPaymentPending,
    OrderStatus.paymentFailed => l10n.orderStatusPaymentFailed,
    OrderStatus.waitingForVendorConfirmation => l10n.orderStatusWaitingForVendorConfirmation,
    OrderStatus.vendorAccepted => l10n.orderStatusVendorAccepted,
    OrderStatus.pickupAssigned => l10n.orderStatusPickupAssigned,
    OrderStatus.goingForPickup => l10n.orderStatusGoingForPickup,
    OrderStatus.pickupOtpVerified => l10n.orderStatusPickupOtpVerified,
    OrderStatus.pickedUp => l10n.orderStatusPickedUp,
    OrderStatus.receivedAtVendor => l10n.orderStatusReceivedAtVendor,
    OrderStatus.reconciliationPending => l10n.orderStatusReconciliationPending,
    OrderStatus.reconciliationDisputed => l10n.orderStatusReconciliationDisputed,
    OrderStatus.processing => l10n.orderStatusProcessing,
    OrderStatus.packed => l10n.orderStatusPacked,
    OrderStatus.deliveryAssigned => l10n.orderStatusDeliveryAssigned,
    OrderStatus.outForDelivery => l10n.orderStatusOutForDelivery,
    OrderStatus.deliveryOtpVerified => l10n.orderStatusDeliveryOtpVerified,
    OrderStatus.delivered => l10n.orderStatusDelivered,
    OrderStatus.vendorRejected => l10n.orderStatusVendorRejected,
    OrderStatus.autoRejected => l10n.orderStatusAutoRejected,
    OrderStatus.customerCancelled => l10n.orderStatusCustomerCancelled,
    OrderStatus.adminCancelled => l10n.orderStatusAdminCancelled,
    OrderStatus.refundPending => l10n.orderStatusRefundPending,
    OrderStatus.refunded => l10n.orderStatusRefunded,
  };
}
