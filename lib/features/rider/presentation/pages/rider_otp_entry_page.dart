import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design/design_system.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../repositories/repositories.dart';
import '../../../../providers/rider_jobs_provider.dart';
import '../../../../models/models.dart';

class RiderOtpEntryPage extends ConsumerStatefulWidget {
  const RiderOtpEntryPage({super.key, required this.orderId, required this.job});

  final String orderId;
  final RiderJobModel job;

  @override
  ConsumerState<RiderOtpEntryPage> createState() => _RiderOtpEntryPageState();
}

class _RiderOtpEntryPageState extends ConsumerState<RiderOtpEntryPage> {
  final _otpController = TextEditingController();
  bool _isVerifying = false;
  String? _error;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final l10n = AppLocalizations.of(context);
    final otp = _otpController.text.trim();
    if (otp.length != 6) {
      setState(() => _error = l10n.riderOtpEnterCode);
      return;
    }

    setState(() {
      _isVerifying = true;
      _error = null;
    });
    try {
      final repo = ref.read(vendorRepositoryProvider);
      if (widget.job.isPickup) {
        await repo.verifyPickupOtp(widget.orderId, otp);
      } else {
        await repo.verifyDeliveryOtp(widget.orderId, otp);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.job.isPickup ? l10n.riderOtpPickupConfirmedSnack : l10n.riderOtpDeliveryConfirmedSnack),
            backgroundColor: AppColors.success,
          ),
        );
        ref.read(riderJobsListProvider.notifier).fetchJobs();
        context.go(AppRoutes.riderJobs);
      }
    } catch (e) {
      setState(() => _error = l10n.riderOtpInvalidExpired);
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPickup = widget.job.isPickup;
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
          isPickup ? l10n.riderConfirmPickupTitle : l10n.riderConfirmDeliveryTitle,
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
            SizedBox(height: 24.h),
            Icon(Icons.verified_user_outlined, size: 56.r, color: AppColors.primary),
            SizedBox(height: 16.h),
            Text(
              l10n.riderOtpPrompt,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: AppTypography.headlineMedium.copyWith(letterSpacing: 8),
              decoration: InputDecoration(
                counterText: '',
                hintText: '000000',
                errorText: _error,
              ),
              onChanged: (_) {
                if (_error != null) setState(() => _error = null);
              },
            ),
            SizedBox(height: 24.h),
            SizedBox(
              height: 52.h,
              child: ElevatedButton(
                onPressed: _isVerifying ? null : _verify,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                ),
                child: _isVerifying
                    ? SizedBox(
                        width: 20.r,
                        height: 20.r,
                        child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : Text(isPickup ? l10n.riderConfirmPickupTitle : l10n.riderConfirmDeliveryTitle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
