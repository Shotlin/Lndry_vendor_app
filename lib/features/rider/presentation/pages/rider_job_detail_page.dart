import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/design/design_system.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../providers/rider_jobs_provider.dart';
import '../../../../repositories/repositories.dart';
import '../../../../models/models.dart';
import '../../../../core/network/friendly_error.dart';

class RiderJobDetailPage extends ConsumerStatefulWidget {
  const RiderJobDetailPage({super.key, required this.orderId});

  final String orderId;

  @override
  ConsumerState<RiderJobDetailPage> createState() => _RiderJobDetailPageState();
}

class _RiderJobDetailPageState extends ConsumerState<RiderJobDetailPage> {
  bool _isStartingLeg = false;

  Future<void> _navigate(BuildContext context, RiderJobModel job) async {
    final l10n = AppLocalizations.of(context);
    if (!job.hasLocation) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.riderNoLocationSnack)));
      return;
    }
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${job.lat},${job.lng}',
    );
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.riderCouldNotOpenMaps)));
    }
  }

  Future<void> _callCustomer(BuildContext context, String phone) async {
    // Keep the customer number out of the rider UI; the only available action
    // passes it straight to the phone's configured dialer.
    final uri = Uri(
      scheme: 'tel',
      path: phone.replaceAll(RegExp(r'[^0-9+]'), ''),
    );
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).commonCouldNotOpenDialer),
        ),
      );
    }
  }

  Future<void> _startLeg(RiderJobModel job) async {
    setState(() => _isStartingLeg = true);
    final l10n = AppLocalizations.of(context);
    try {
      final repo = ref.read(vendorRepositoryProvider);
      if (job.isPickup) {
        await repo.startPickup(job.orderId);
      } else {
        await repo.startDelivery(job.orderId);
      }
      ref.invalidate(riderJobDetailProvider(job.orderId));
      ref.invalidate(riderJobsListProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              job.isPickup
                  ? l10n.riderCouldNotStartPickup(friendlyError(e))
                  : l10n.riderCouldNotStartDelivery(friendlyError(e)),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isStartingLeg = false);
    }
  }

  void _cancelPickup(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context).riderCancelPickupNotAvailable,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final jobAsync = ref.watch(riderJobDetailProvider(widget.orderId));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? AppColors.white : AppColors.textBlack,
          ),
          onPressed: () => context.canPop()
              ? context.pop()
              : context.go(AppRoutes.riderJobs),
        ),
        title: Text(
          l10n.riderJobDetailTitle,
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.white : AppColors.textBlack,
          ),
        ),
      ),
      body: jobAsync.when(
        data: (job) => _buildBody(context, job, isDark),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) =>
            Center(child: Text(l10n.riderFailedToLoadJob(friendlyError(err)))),
      ),
    );
  }

  Widget _buildBody(BuildContext context, RiderJobModel job, bool isDark) {
    final l10n = AppLocalizations.of(context);
    final awaitingStart = job.isPickup
        ? job.orderStatus == 'PICKUP_ASSIGNED'
        : job.orderStatus == 'DELIVERY_ASSIGNED';
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: AppColors.outline.withValues(alpha: isDark ? 0.1 : 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color:
                            (job.isPickup
                                    ? AppColors.secondary
                                    : AppColors.primary)
                                .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        job.isPickup
                            ? l10n.riderPickupBadge
                            : l10n.riderDeliveryBadge,
                        style: AppTypography.badge.copyWith(
                          color: job.isPickup
                              ? AppColors.secondary
                              : AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '#${job.orderNumber}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Text(
                  job.customerName?.isNotEmpty == true
                      ? job.customerName!
                      : l10n.orderDetailsCustomerFallback,
                  style: AppTypography.headlineMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 18.r,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        job.addressLine,
                        style: AppTypography.bodyMedium,
                      ),
                    ),
                  ],
                ),
                if (job.scheduledLabel != null &&
                    job.scheduledLabel!.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        size: 18.r,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        job.scheduledLabel!,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
                if (job.customerPhone?.isNotEmpty == true) ...[
                  SizedBox(height: 12.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Semantics(
                      button: true,
                      label: l10n.commonCallCustomer,
                      child: Material(
                        color: AppColors.success,
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () =>
                              _callCustomer(context, job.customerPhone!),
                          child: SizedBox(
                            width: 48.r,
                            height: 48.r,
                            child: const Icon(
                              Icons.phone_rounded,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (!job.isPickup) ...[
            SizedBox(height: 16.h),
            _PaymentStatusBanner(
              job: job,
              isDark: isDark,
              onRefresh: () =>
                  ref.invalidate(riderJobDetailProvider(job.orderId)),
            ),
          ],
          SizedBox(height: 16.h),
          if (job.lines.isNotEmpty) ...[
            Text(
              l10n.riderItemsHeader,
              style: AppTypography.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: AppColors.outline.withValues(
                    alpha: isDark ? 0.1 : 0.2,
                  ),
                ),
              ),
              child: Column(
                children: job.lines
                    .map(
                      (l) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text('${l.quantity} × ${l.garmentName}'),
                            ),
                            Text(
                              l.unit,
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            SizedBox(height: 16.h),
          ],
          SizedBox(
            height: 52.h,
            child: OutlinedButton.icon(
              onPressed: () => _navigate(context, job),
              icon: const Icon(Icons.directions_rounded),
              label: Text(l10n.riderNavigateButton),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 52.h,
            child: ElevatedButton(
              onPressed: awaitingStart
                  ? (_isStartingLeg ? null : () => _startLeg(job))
                  : () {
                      if (job.isPickup) {
                        context.push(
                          AppRoutes.riderMeasurements.replaceFirst(
                            ':orderId',
                            job.orderId,
                          ),
                          extra: job,
                        );
                      } else if (job.isCod && job.hasBalanceDue) {
                        context.push(
                          AppRoutes.riderCollectBalance.replaceFirst(
                            ':orderId',
                            job.orderId,
                          ),
                          extra: job,
                        );
                      } else if (job.hasBalanceDue) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              l10n.riderCustomerPaymentPendingSnack,
                            ),
                          ),
                        );
                      } else {
                        context.push(
                          AppRoutes.riderDeliveryPhoto.replaceFirst(
                            ':orderId',
                            job.orderId,
                          ),
                          extra: job,
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
              ),
              child: _isStartingLeg
                  ? SizedBox(
                      width: 20.r,
                      height: 20.r,
                      child: const CircularProgressIndicator(
                        color: AppColors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      awaitingStart
                          ? (job.isPickup
                                ? l10n.riderStartPickupButton
                                : l10n.riderStartDeliveryButton)
                          : (job.isPickup
                                ? l10n.riderPickUpButton
                                : l10n.riderMarkDeliveredButton),
                    ),
            ),
          ),
          if (job.isPickup) ...[
            SizedBox(height: 12.h),
            SizedBox(
              height: 52.h,
              child: OutlinedButton(
                onPressed: () => _cancelPickup(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                ),
                child: Text(l10n.riderCancelPickupButton),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Payment-status banner shown at the top of a delivery job, with a manual
/// refresh action since this app has no push/websocket channel to notice a
/// customer's balance payment landing while the rider is on this screen.
class _PaymentStatusBanner extends StatelessWidget {
  const _PaymentStatusBanner({
    required this.job,
    required this.isDark,
    required this.onRefresh,
  });

  final RiderJobModel job;
  final bool isDark;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isPending = job.hasBalanceDue;
    final color = isPending ? AppColors.error : AppColors.success;
    final balanceRupees = (job.balanceDuePaise ?? 0) / 100.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.r, vertical: 12.r),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(
            isPending
                ? Icons.error_outline_rounded
                : Icons.check_circle_outline_rounded,
            color: color,
            size: 20.r,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              isPending
                  ? l10n.riderPaymentPending(
                      CurrencyUtils.formatDecimal(balanceRupees),
                    )
                  : l10n.riderFullPaymentCompleted,
              style: AppTypography.bodyMedium.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (isPending)
            IconButton(
              icon: Icon(Icons.refresh_rounded, color: color, size: 20.r),
              tooltip: l10n.riderRefreshPaymentTooltip,
              onPressed: onRefresh,
            ),
        ],
      ),
    );
  }
}
