import '../../../models/pos/pos_counter_order_model.dart';
import '../../../models/pos/pos_order_model.dart';
import '../core/pos_widgets.dart';

/// THE one place that turns the backend's `status` + `paymentStatus` into what the owner sees and can do next
/// (Master Plan §5). Nothing else in the app looks at raw status strings.
///
/// | Backend                                | Owner sees                         |
/// |----------------------------------------|------------------------------------|
/// | BOOKED, PICKED_UP                      | Booked                             |
/// | IN_PROCESS                             | Processing                         |
/// | READY                                  | Ready (the "Done" tab)             |
/// | OUT_FOR_DELIVERY                       | Out for delivery (the "Done" tab)  |
/// | DELIVERED, not fully paid              | Delivered                          |
/// | DELIVERED and PAID                     | Order Complete                     |
/// | CANCELLED                              | Cancelled                          |
enum OrderPhase {
  booked,
  processing,
  ready,
  outForDelivery,
  delivered,
  complete,
  cancelled,
  unknown
}

OrderPhase orderPhaseOf(String status, String paymentStatus) {
  switch (status) {
    case 'BOOKED':
    case 'PICKED_UP':
      return OrderPhase.booked;
    case 'IN_PROCESS':
      return OrderPhase.processing;
    case 'READY':
      return OrderPhase.ready;
    case 'OUT_FOR_DELIVERY':
      return OrderPhase.outForDelivery;
    case 'DELIVERED':
      return paymentStatus == 'PAID'
          ? OrderPhase.complete
          : OrderPhase.delivered;
    case 'CANCELLED':
      return OrderPhase.cancelled;
  }
  return OrderPhase.unknown;
}

extension CounterOrderState on CounterOrder {
  OrderPhase get phase => orderPhaseOf(status, paymentStatus);

  /// Delivered or cancelled: nothing more can be edited, moved or cancelled.
  bool get isClosed => status == 'DELIVERED' || status == 'CANCELLED';
  bool get canEdit => !isClosed;
  bool get canCancel => !isClosed;

  /// A cancelled order takes no payment; anything with a balance does.
  bool get canCollect => status != 'CANCELLED' && balancePaise > 0;

  /// The mini bill exists until the order is cancelled; the A4 invoice only after delivery.
  bool get hasMiniBill => status != 'CANCELLED';
  bool get hasInvoice => status == 'DELIVERED';
}

PosTone toneOfPhase(OrderPhase p) {
  switch (p) {
    case OrderPhase.booked:
    case OrderPhase.unknown:
      return PosTone.neutral;
    case OrderPhase.processing:
    case OrderPhase.outForDelivery:
      return PosTone.attention;
    case OrderPhase.ready:
    case OrderPhase.delivered:
    case OrderPhase.complete:
      return PosTone.success;
    case OrderPhase.cancelled:
      return PosTone.danger;
  }
}

/// Paid in green, part paid in amber, unpaid in red — always with the word.
PosTone toneOfPayment(String paymentStatus) {
  switch (paymentStatus) {
    case 'PAID':
      return PosTone.success;
    case 'PART_PAID':
      return PosTone.attention;
    default:
      return PosTone.danger;
  }
}

/// What the big button on an order does.
enum NextStepKind { startProcessing, markReady, sendOut, deliver }

class NextStep {
  const NextStep(this.kind, this.targetState);
  final NextStepKind kind;

  /// The backend state sent in `POST …/transition`.
  final String targetState;

  @override
  bool operator ==(Object other) =>
      other is NextStep &&
      other.kind == kind &&
      other.targetState == targetState;
  @override
  int get hashCode => Object.hash(kind, targetState);
}

/// The next step, or `null` when the order is finished (delivered / cancelled).
/// A ready order goes out for delivery when it is a home-delivery order, otherwise it is handed over at the counter.
NextStep? nextStepOf(CounterOrder o) {
  switch (o.status) {
    case 'BOOKED':
    case 'PICKED_UP':
      return const NextStep(NextStepKind.startProcessing, 'IN_PROCESS');
    case 'IN_PROCESS':
      return const NextStep(NextStepKind.markReady, 'READY');
    case 'READY':
      return o.deliveryMode == DeliveryMode.homeDelivery
          ? const NextStep(NextStepKind.sendOut, 'OUT_FOR_DELIVERY')
          : const NextStep(NextStepKind.deliver, 'DELIVERED');
    case 'OUT_FOR_DELIVERY':
      return const NextStep(NextStepKind.deliver, 'DELIVERED');
  }
  return null;
}

/// The three tabs of the Orders list, and what each asks the server for.
enum OrderTab {
  booked(['BOOKED', 'PICKED_UP']),
  inProcess(['IN_PROCESS']),
  done(['READY', 'OUT_FOR_DELIVERY']);

  const OrderTab(this.statuses);
  final List<String> statuses;
}

/// The five stops of the progress line on the order screen.
enum OrderStage { booked, processed, done, delivered, complete }

/// How far along the order is: 1..5 stops reached (0 for a cancelled order).
int stagesReached(CounterOrder o) {
  switch (o.phase) {
    case OrderPhase.booked:
    case OrderPhase.unknown:
      return 1;
    case OrderPhase.processing:
      return 2;
    case OrderPhase.ready:
    case OrderPhase.outForDelivery:
      return 3;
    case OrderPhase.delivered:
      return 4;
    case OrderPhase.complete:
      return 5;
    case OrderPhase.cancelled:
      return 0;
  }
}

/// 20 / 40 / 60 / 80 / 100 — whole percent, integer maths.
int progressPercent(CounterOrder o) =>
    stagesReached(o) * 100 ~/ OrderStage.values.length;

/// Which backend status carries each stop's time on the timeline (`null` = derived, shows no time of its own).
String? statusForStage(OrderStage s) {
  switch (s) {
    case OrderStage.booked:
      return 'BOOKED';
    case OrderStage.processed:
      return 'IN_PROCESS';
    case OrderStage.done:
      return 'READY';
    case OrderStage.delivered:
      return 'DELIVERED';
    case OrderStage.complete:
      return null;
  }
}
