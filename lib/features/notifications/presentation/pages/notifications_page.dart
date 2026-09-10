import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design/design_system.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../models/models.dart';
import '../../../../providers/notifications_provider.dart';

String _timeAgo(AppLocalizations l10n, DateTime time) {
  final diff = DateTime.now().difference(time);
  if (diff.inMinutes < 1) return l10n.notificationsJustNow;
  if (diff.inMinutes < 60) return l10n.notificationsMinsAgo(diff.inMinutes);
  if (diff.inHours < 24) return l10n.notificationsHoursAgo(diff.inHours);
  return l10n.notificationsDaysAgo(diff.inDays);
}

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final notificationsAsync = ref.watch(notificationsProvider);
    final unreadCount = notificationsAsync.value?.where((n) => !n.isRead).length ?? 0;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? AppColors.white : AppColors.textBlack),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.notificationsPageTitle,
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.white : AppColors.textBlack,
          ),
        ),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: () => ref.read(notificationsProvider.notifier).markAllRead(),
              child: Text(
                l10n.notificationsMarkAllRead,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(notificationsProvider.notifier).fetch(),
        color: AppColors.primary,
        child: notificationsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child: Padding(
              padding: EdgeInsets.all(32.r),
              child: Text(l10n.notificationsFailedToLoad('$err'), textAlign: TextAlign.center),
            ),
          ),
          data: (notifications) {
            if (notifications.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(32.r),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_off_outlined,
                        size: 64.r,
                        color: AppColors.textSecondary.withOpacity(0.3),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        l10n.notificationsEmptyTitle,
                        style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        l10n.notificationsEmptySubtitle,
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.all(16.r),
              itemCount: notifications.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (context, idx) {
                final item = notifications[idx];
                final (iconBg, iconColor, icon) = switch (item.type) {
                  'order' => (AppColors.primaryContainer, AppColors.primary, Icons.local_laundry_service_rounded),
                  'payment' => (AppColors.successContainer, AppColors.success, Icons.account_balance_wallet_rounded),
                  'price_override' => (AppColors.primaryContainer, AppColors.primary, Icons.currency_rupee_rounded),
                  _ => (const Color(0xFFFFECEE), AppColors.error, Icons.info_rounded),
                };

                return Dismissible(
                  key: Key(item.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    alignment: Alignment.centerRight,
                    child: const Icon(Icons.delete_sweep_rounded, color: Colors.white),
                  ),
                  onDismissed: (_) => ref.read(notificationsProvider.notifier).remove(item.id),
                  child: GestureDetector(
                    onTap: () {
                      if (!item.isRead) {
                        ref.read(notificationsProvider.notifier).markRead(item.id);
                      }
                    },
                    child: Card(
                      elevation: 0,
                      color: isDark ? AppColors.darkSurface : AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        side: BorderSide(
                          color: AppColors.outline.withOpacity(isDark ? 0.05 : 0.2),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(14.r),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10.r),
                              decoration: BoxDecoration(
                                color: iconBg,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(icon, color: iconColor, size: 22.r),
                            ),
                            SizedBox(width: 14.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.title,
                                          style: AppTypography.bodyLarge.copyWith(
                                            fontWeight: item.isRead ? FontWeight.normal : FontWeight.bold,
                                            color: isDark ? AppColors.white : AppColors.textBlack,
                                          ),
                                        ),
                                      ),
                                      if (!item.isRead)
                                        Container(
                                          width: 8.r,
                                          height: 8.r,
                                          decoration: const BoxDecoration(
                                            color: AppColors.primary,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    item.body,
                                    style: AppTypography.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    _timeAgo(l10n, item.createdAt),
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
