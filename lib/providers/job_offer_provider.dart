import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/socket_service.dart';
import '../models/models.dart';

/// A broadcast (or, in principle, targeted) job offer received over the
/// socket — Phase 3 of the rider-assignment initiative. Mirrors the
/// payload `VendorOrdersService#broadcastToRiders` emits via
/// `fastify.emitJobOffered`.
class JobOffer {
  const JobOffer({
    required this.orderId,
    required this.purpose,
    this.orderNumber,
    this.expiresAt,
  });

  final String orderId;
  final String? orderNumber;

  /// 'PICKUP' or 'DELIVERY'.
  final String purpose;

  /// When this offer will auto re-broadcast if nobody's accepted —
  /// drives the countdown in [JobOfferListener]. Null for a targeted
  /// (Phase 2) offer, which has no timeout.
  final DateTime? expiresAt;

  factory JobOffer.fromSocketData(Map<String, dynamic> data) {
    return JobOffer(
      orderId: data['orderId'] as String? ?? '',
      orderNumber: data['orderNumber'] as String?,
      purpose: data['purpose'] as String? ?? 'PICKUP',
      expiresAt: data['expiresAt'] != null
          ? DateTime.tryParse(data['expiresAt'] as String)
          : null,
    );
  }

  factory JobOffer.fromRiderJob(RiderJobModel job) {
    return JobOffer(
      orderId: job.orderId,
      orderNumber: job.orderNumber,
      purpose: job.assignmentType,
      expiresAt: job.offerExpiresAt,
    );
  }
}

/// The most recently received, not-yet-handled job offer — null when
/// there is nothing to show. Set by the socket listener in
/// [JobOfferListener], cleared once the rider accepts or dismisses it.
final pendingJobOfferProvider = StateProvider<JobOffer?>((ref) => null);

final socketServiceProvider = Provider<SocketService>((ref) {
  final service = SocketService();
  ref.onDispose(service.disconnect);
  return service;
});
