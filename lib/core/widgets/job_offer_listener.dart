import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../providers/analytics_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/job_offer_provider.dart';
import '../../providers/notifications_provider.dart';
import '../../providers/orders_provider.dart';
import '../../repositories/repositories.dart';
import '../constants/app_constants.dart';
import '../services/storage_service.dart';
import '../theme/theme.dart';
import 'app_bottom_sheet.dart';
import 'app_snackbar.dart';

/// Wraps the whole app (see main.dart's `MaterialApp.router` builder) to
/// connect this vendor session's socket on login and:
///   - for a rider (`shopRole == 'VENDOR_RIDER'`): show a bottom sheet the
///     moment a `job:offered` event arrives — with a live countdown to
///     when the offer auto re-broadcasts (Phase 4/5's timeout, surfaced
///     here in Phase 6 of the rider-assignment initiative, see CLAUDE.md);
///   - for ANY authenticated vendor session (owner, staff or rider alike):
///     live-refresh the Orders list/dashboard on `order:status` /
///     `order.created` / `notification` events instead of only on manual
///     pull-to-refresh.
///
/// The socket used to only connect for `VENDOR_RIDER` sessions at all —
/// a vendor-owner/vendor-staff session never opened one, so a newly
/// placed order or a customer's reconciliation response only ever
/// reached the vendor's Orders list/dashboard on the next manual refresh.
/// Broadening the connection to every authenticated session (harmless for
/// job-offer purposes too — `job:offered` is only ever emitted to a
/// rider's own room server-side, so a non-rider session simply never
/// receives it) closes that gap.
///
/// Also checks for any already-pending job offer right after connecting
/// (rider sessions only), so one broadcast while the app was closed or
/// briefly disconnected isn't silently missed — the fast path (a live
/// `job:offered` event) and this recovery path both funnel into the same
/// [pendingJobOfferProvider].
///
/// Known limitation, acceptable for this phase: if a second offer arrives
/// while the first one's sheet is still open, it's dropped rather than
/// queued — a real multi-offer queue is a bigger UI than this initiative
/// has needed so far; this prompt is the rider's *fast* path, not a full
/// inbox (that's still the plain job list for confirmed jobs).
class JobOfferListener extends ConsumerStatefulWidget {
  const JobOfferListener({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<JobOfferListener> createState() => _JobOfferListenerState();
}

class _JobOfferListenerState extends ConsumerState<JobOfferListener> {
  bool _sheetOpen = false;

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      _syncSocket(next);
    });

    ref.listen<JobOffer?>(pendingJobOfferProvider, (previous, next) {
      if (next != null && !_sheetOpen) {
        _showOfferSheet(next);
      }
    });

    return widget.child;
  }

  Future<void> _syncSocket(AuthState state) async {
    final socket = ref.read(socketServiceProvider);
    if (state is AuthAuthenticated) {
      final storage = ref.read(storageServiceProvider);
      final token = await storage.getSecure(AppConstants.keyAccessToken);
      if (token != null && token.isNotEmpty) {
        socket.connect(
          token: token,
          onJobOffered: (data) {
            ref.read(pendingJobOfferProvider.notifier).state =
                JobOffer.fromSocketData(data);
          },
          onOrderStatus: _handleOrderEvent,
          onOrderCreated: _handleOrderEvent,
          onNotification: (data) {
            _handleOrderEvent(data);
            ref.invalidate(notificationsProvider);
            final title = data['title'] as String? ?? 'Order update';
            final body = data['body'] as String? ?? '';
            if (mounted) {
              AppSnackBar.showInfo(context, '$title\n$body');
            }
          },
        );
        if (state.shopRole == 'VENDOR_RIDER') {
          await _checkForPendingOffer();
        }
      }
    } else {
      socket.disconnect();
    }
  }

  /// A new order arrived, or an existing one's status changed (vendor
  /// accept/reject is this session's own action and already refreshes via
  /// `OrdersNotifier`'s own post-mutation `fetchOrders()`; this path is
  /// for changes made elsewhere — a customer accepting/rejecting a
  /// reconciliation, or another vendor-staff device acting on the same
  /// order). Refreshes the Orders list/dashboard wherever they're
  /// currently watched, and the specific order's detail screen if it
  /// carries an `order_id`/`orderId`.
  void _handleOrderEvent(Map<String, dynamic> data) {
    ref.invalidate(ordersListProvider);
    ref.invalidate(dashboardStatsProvider);
    ref.invalidate(analyticsStatsProvider);

    final nested = data['data'];
    final orderId = data['orderId'] as String? ??
        data['order_id'] as String? ??
        (nested is Map
            ? (nested['orderId'] as String? ?? nested['order_id'] as String?)
            : null);
    if (orderId != null && orderId.isNotEmpty) {
      ref.invalidate(orderDetailsProvider(orderId));
    }
  }

  /// Recovery path for an offer broadcast while the app had no live
  /// socket connection — the fast path above only catches one broadcast
  /// while actually connected.
  Future<void> _checkForPendingOffer() async {
    if (_sheetOpen || ref.read(pendingJobOfferProvider) != null) return;
    try {
      final offers = await ref.read(vendorRepositoryProvider).getJobOffers();
      if (offers.isNotEmpty && mounted) {
        ref.read(pendingJobOfferProvider.notifier).state =
            JobOffer.fromRiderJob(offers.first);
      }
    } catch (_) {
      // Best-effort — the rider will still get the next live broadcast.
    }
  }

  Future<void> _showOfferSheet(JobOffer offer) async {
    _sheetOpen = true;
    final l10n = AppLocalizations.of(context);
    var accepting = false;

    await AppBottomSheet.show<void>(
      context: context,
      title: l10n.jobOfferTitle,
      primaryActionLabel: l10n.jobOfferAcceptButton,
      onPrimaryAction: () async {
        if (accepting) return;
        accepting = true;
        final navigator = Navigator.of(context);
        final messenger = ScaffoldMessenger.of(context);
        try {
          await ref.read(vendorRepositoryProvider).acceptJobOffer(offer.orderId);
          navigator.pop();
          messenger.showSnackBar(SnackBar(content: Text(l10n.jobOfferAcceptedSnack)));
        } catch (e) {
          accepting = false;
          navigator.pop();
          messenger.showSnackBar(SnackBar(content: Text(l10n.jobOfferUnavailableSnack)));
        }
      },
      secondaryActionLabel: l10n.jobOfferNotNowButton,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            offer.purpose == 'PICKUP'
                ? l10n.orderDetailsPickupRiderLabel
                : l10n.orderDetailsDeliveryRiderLabel,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
          SizedBox(height: 4.h),
          Text(
            offer.orderNumber != null
                ? l10n.jobOfferOrderNumber(offer.orderNumber!)
                : l10n.jobOfferTitle,
            style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.bold),
          ),
          if (offer.expiresAt != null) ...[
            SizedBox(height: 12.h),
            _CountdownBadge(expiresAt: offer.expiresAt!),
          ],
        ],
      ),
    );

    _sheetOpen = false;
    if (mounted) {
      ref.read(pendingJobOfferProvider.notifier).state = null;
    }
  }
}

/// Live "mm:ss remaining" pill, ticking once a second until [expiresAt] —
/// after that it shows an "Expired" state rather than a negative
/// countdown (the sheet itself stays open; the offer's own timeout job
/// determines what actually happens server-side, this is just a display).
class _CountdownBadge extends StatefulWidget {
  const _CountdownBadge({required this.expiresAt});

  final DateTime expiresAt;

  @override
  State<_CountdownBadge> createState() => _CountdownBadgeState();
}

class _CountdownBadgeState extends State<_CountdownBadge> {
  Timer? _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = widget.expiresAt.difference(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final remaining = widget.expiresAt.difference(DateTime.now());
      if (!mounted) return;
      setState(() => _remaining = remaining);
      if (remaining.isNegative) _timer?.cancel();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final expired = _remaining.isNegative;
    final clamped = expired ? Duration.zero : _remaining;
    final minutes = clamped.inMinutes.toString().padLeft(2, '0');
    final seconds = (clamped.inSeconds % 60).toString().padLeft(2, '0');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: (expired ? AppColors.error : AppColors.warning).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_outlined,
            size: 16.r,
            color: expired ? AppColors.error : AppColors.warning,
          ),
          SizedBox(width: 6.w),
          Text(
            expired ? l10n.jobOfferExpiredLabel : l10n.jobOfferCountdownLabel('$minutes:$seconds'),
            style: AppTypography.bodySmall.copyWith(
              fontWeight: FontWeight.bold,
              color: expired ? AppColors.error : AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }
}
