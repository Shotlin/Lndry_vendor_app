import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design/design_system.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../repositories/repositories.dart';
import '../../../../models/models.dart';
import '../../../../core/network/friendly_error.dart';

/// Delivery-leg balance-collection step, shown before the delivery-OTP
/// screen. COD orders show a "Confirm Cash Collected" action that records
/// the payment server-side; ONLINE-balance orders show a read-only note
/// since the customer settles that leg themselves in-app.
class RiderCollectBalancePage extends ConsumerStatefulWidget {
  const RiderCollectBalancePage({super.key, required this.orderId, required this.job});

  final String orderId;
  final RiderJobModel job;

  @override
  ConsumerState<RiderCollectBalancePage> createState() => _RiderCollectBalancePageState();
}

class _RiderCollectBalancePageState extends ConsumerState<RiderCollectBalancePage> {
  bool _isCollecting = false;
  bool _collected = false;

  Future<void> _confirmCollected() async {
    setState(() => _isCollecting = true);
    try {
      await ref.read(vendorRepositoryProvider).collectBalance(widget.orderId);
      if (mounted) {
        setState(() => _collected = true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).riderFailedRecordCashCollection(friendlyError(e)))),
        );
      }
    } finally {
      if (mounted) setState(() => _isCollecting = false);
    }
  }

  void _continueToOtp() {
    context.push(
      AppRoutes.riderDeliveryPhoto.replaceFirst(':orderId', widget.orderId),
      extra: widget.job,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final balancePaise = widget.job.balanceDuePaise ?? 0;
    final balanceRupees = balancePaise / 100.0;
    final isCod = widget.job.isCod;
    final noBalanceDue = balancePaise <= 0;
    final l10n = AppLocalizations.of(context);

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
          l10n.riderCollectBalanceTitle,
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.white : AppColors.textBlack,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.outline.withValues(alpha: isDark ? 0.1 : 0.2)),
              ),
              child: Column(
                children: [
                  Text(l10n.riderBalanceDueLabel, style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
                  SizedBox(height: 8.h),
                  Text(
                    CurrencyUtils.formatDecimal(balanceRupees),
                    style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.bold, fontSize: 32),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    isCod ? l10n.riderPaymentMethodCod : l10n.riderPaymentMethodOnline,
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            if (noBalanceDue)
              _InfoBanner(
                icon: Icons.check_circle_outline_rounded,
                color: AppColors.success,
                text: l10n.riderNoBalanceDueBanner,
              )
            else if (!isCod)
              _InfoBanner(
                icon: Icons.info_outline_rounded,
                color: AppColors.primary,
                text: l10n.riderCustomerPaysOnlineBanner,
              )
            else if (_collected)
              _InfoBanner(
                icon: Icons.check_circle_outline_rounded,
                color: AppColors.success,
                text: l10n.riderCashCollectionRecordedBanner,
              ),
            const Spacer(),
            SizedBox(
              height: 52.h,
              child: (isCod && !noBalanceDue && !_collected)
                  ? ElevatedButton(
                      onPressed: _isCollecting ? null : _confirmCollected,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                      ),
                      child: _isCollecting
                          ? SizedBox(
                              width: 20.r,
                              height: 20.r,
                              child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : Text(l10n.riderConfirmCashCollectedButton(CurrencyUtils.formatDecimal(balanceRupees))),
                    )
                  : ElevatedButton(
                      onPressed: _continueToOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                      ),
                      child: Text(l10n.riderContinueButton),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.icon, required this.color, required this.text});

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20.r),
          SizedBox(width: 10.w),
          Expanded(child: Text(text, style: AppTypography.bodySmall.copyWith(color: color))),
        ],
      ),
    );
  }
}
