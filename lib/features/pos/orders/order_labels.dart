import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/pos/pos_counter_order_model.dart';
import '../../../models/pos/pos_order_model.dart';
import '../core/pos_widgets.dart';
import 'order_state.dart';

/// Words for the order states. Kept apart from `order_state.dart` so the rules stay free of screens and languages.
String phaseLabel(AppLocalizations l, OrderPhase p) {
  switch (p) {
    case OrderPhase.booked:
    case OrderPhase.unknown:
      return l.posPhaseBooked;
    case OrderPhase.processing:
      return l.posPhaseProcessing;
    case OrderPhase.ready:
      return l.posPhaseReady;
    case OrderPhase.outForDelivery:
      return l.posPhaseOut;
    case OrderPhase.delivered:
      return l.posPhaseDelivered;
    case OrderPhase.complete:
      return l.posPhaseComplete;
    case OrderPhase.cancelled:
      return l.posPhaseCancelled;
  }
}

IconData phaseIcon(OrderPhase p) {
  switch (p) {
    case OrderPhase.booked:
    case OrderPhase.unknown:
      return Icons.edit_note_rounded;
    case OrderPhase.processing:
      return Icons.local_laundry_service_rounded;
    case OrderPhase.ready:
      return Icons.inventory_2_rounded;
    case OrderPhase.outForDelivery:
      return Icons.local_shipping_rounded;
    case OrderPhase.delivered:
      return Icons.task_alt_rounded;
    case OrderPhase.complete:
      return Icons.verified_rounded;
    case OrderPhase.cancelled:
      return Icons.cancel_rounded;
  }
}

String paymentStatusLabel(AppLocalizations l, String paymentStatus) {
  switch (paymentStatus) {
    case 'PAID':
      return l.posPayStatusPaid;
    case 'PART_PAID':
      return l.posPayStatusPart;
    default:
      return l.posPayStatusUnpaid;
  }
}

String nextStepLabel(AppLocalizations l, NextStepKind k) {
  switch (k) {
    case NextStepKind.startProcessing:
      return l.posNextStart;
    case NextStepKind.markReady:
      return l.posNextReady;
    case NextStepKind.sendOut:
      return l.posNextSendOut;
    case NextStepKind.deliver:
      return l.posNextDeliver;
  }
}

String deliveryModeLabel(AppLocalizations l, DeliveryMode m) {
  switch (m) {
    case DeliveryMode.homeDelivery:
      return l.posOrdHomeDelivery;
    case DeliveryMode.pickup:
      return l.posOrdPickup;
    case DeliveryMode.walkIn:
      return l.posOrdWalkIn;
  }
}

/// CASH / UPI / CARD / BANK / WALLET → the words the shop uses.
String paymentModeLabel(AppLocalizations l, String? mode) {
  switch ((mode ?? '').toUpperCase()) {
    case 'CASH':
      return l.posModeCash;
    case 'UPI':
    case 'ONLINE':
      return l.posModeOnline;
    case 'CARD':
      return l.posModeCard;
    case 'BANK':
      return l.posModeBank;
    case 'WALLET':
      return l.posModeWallet;
  }
  return mode ?? '';
}

String stageLabel(AppLocalizations l, OrderStage s) {
  switch (s) {
    case OrderStage.booked:
      return l.posStageBooked;
    case OrderStage.processed:
      return l.posStageProcessed;
    case OrderStage.done:
      return l.posStageDone;
    case OrderStage.delivered:
      return l.posStageDelivered;
    case OrderStage.complete:
      return l.posStageComplete;
  }
}

String unitStateLabel(AppLocalizations l, String state) {
  switch (state) {
    case 'INTAKE':
      return l.posUnitReceived;
    case 'SORTED':
    case 'PROCESSING':
    case 'QC':
    case 'REWASH':
      return l.posUnitProcessing;
    case 'ASSEMBLY':
    case 'RACKED':
      return l.posUnitReady;
    case 'DISPATCHED':
      return l.posUnitOut;
    case 'DELIVERED':
      return l.posUnitDelivered;
    case 'MISSING':
      return l.posUnitMissing;
    case 'CANCELLED':
      return l.posUnitCancelled;
  }
  return state;
}

PosTone unitTone(String state) {
  switch (state) {
    case 'ASSEMBLY':
    case 'RACKED':
    case 'DELIVERED':
      return PosTone.success;
    case 'MISSING':
    case 'CANCELLED':
      return PosTone.danger;
    case 'INTAKE':
      return PosTone.neutral;
    default:
      return PosTone.attention;
  }
}

/// `2026-10-13` → `13 Oct 2026` in the app's language. A value that is not a date is shown as it is.
String dateText(BuildContext context, String? ymd) {
  if (ymd == null || ymd.isEmpty) return '—';
  final d = DateTime.tryParse(ymd);
  return d == null
      ? ymd
      : DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(d);
}

String dateTimeText(BuildContext context, DateTime? t) => t == null
    ? '—'
    : DateFormat.yMMMd(Localizations.localeOf(context).toString())
        .add_jm()
        .format(t);

/// A coloured pill with an icon AND a word — colour never carries the meaning alone.
class PosStatusChip extends StatelessWidget {
  const PosStatusChip(
      {required this.label, required this.tone, super.key, this.icon});
  final String label;
  final PosTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final c = posToneColors(context, tone);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: c.bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: c.fg.withValues(alpha: 0.35))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 15, color: c.fg),
            const SizedBox(width: 4)
          ],
          Flexible(
              child: Text(label,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: c.fg, fontWeight: FontWeight.w700),
                  overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}

/// The order's state as a chip.
class OrderStatusChip extends StatelessWidget {
  const OrderStatusChip({required this.order, super.key});
  final CounterOrder order;

  @override
  Widget build(BuildContext context) {
    final p = order.phase;
    return PosStatusChip(
        label: phaseLabel(AppLocalizations.of(context), p),
        tone: toneOfPhase(p),
        icon: phaseIcon(p));
  }
}
