import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design/design_system.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/rider_jobs_provider.dart';
import '../../../../models/models.dart';
import '../../../../core/network/friendly_error.dart';

class RiderJobListPage extends ConsumerWidget {
  const RiderJobListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsAsync = ref.watch(riderJobsListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final vendor = ref.watch(currentVendorProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          vendor != null ? l10n.riderMyJobsTitleWithVendor(vendor.name) : l10n.riderMyJobsTitle,
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.white : AppColors.textBlack,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            color: AppColors.error,
            onPressed: () => ref.read(authProvider.notifier).logout(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(riderJobsListProvider.notifier).fetchJobs(),
        color: AppColors.primary,
        child: jobsAsync.when(
          data: (jobs) {
            if (jobs.isEmpty) {
              return LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.r),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.two_wheeler_outlined,
                                size: 64.r, color: AppColors.textSecondary.withValues(alpha: 0.3)),
                            SizedBox(height: 16.h),
                            Text(
                              l10n.riderNoJobsTitle,
                              style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              l10n.riderNoJobsSubtitle,
                              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }

            final sortedJobs = [...jobs]..sort((a, b) {
                final aStarted = a.isInProgress ? 0 : 1;
                final bStarted = b.isInProgress ? 0 : 1;
                return aStarted.compareTo(bStarted);
              });

            return ListView.separated(
              padding: EdgeInsets.all(16.r),
              itemCount: sortedJobs.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (context, idx) {
                final job = sortedJobs[idx];
                return _JobCard(
                  job: job,
                  isDark: isDark,
                  onTap: () => context.push(
                    AppRoutes.riderJobDetail.replaceFirst(':orderId', job.orderId),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text(l10n.riderFailedToLoadJobs(friendlyError(err)))),
        ),
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  const _JobCard({required this.job, required this.isDark, required this.onTap});

  final RiderJobModel job;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isPickup = job.isPickup;
    final badgeColor = isPickup ? AppColors.secondary : AppColors.primary;
    final l10n = AppLocalizations.of(context);

    return Card(
      elevation: 0,
      color: isDark ? AppColors.darkSurface : AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(color: AppColors.outline.withValues(alpha: isDark ? 0.05 : 0.2)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(14.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      isPickup ? l10n.riderPickupBadge : l10n.riderDeliveryBadge,
                      style: AppTypography.badge.copyWith(
                        color: badgeColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  if (job.isInProgress) ...[
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        l10n.riderInProgressBadge,
                        style: AppTypography.badge.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  Text('#${job.orderNumber}',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                ],
              ),
              SizedBox(height: 10.h),
              Text(
                job.customerName?.isNotEmpty == true ? job.customerName! : l10n.orderDetailsCustomerFallback,
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.white : AppColors.textBlack,
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 16.r, color: AppColors.textSecondary),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      job.addressLine,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (job.scheduledLabel != null && job.scheduledLabel!.isNotEmpty) ...[
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(Icons.schedule_rounded, size: 16.r, color: AppColors.primary),
                    SizedBox(width: 4.w),
                    Text(
                      job.scheduledLabel!,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
