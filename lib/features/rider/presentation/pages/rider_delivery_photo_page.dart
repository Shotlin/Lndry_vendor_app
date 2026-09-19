import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/design/design_system.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../repositories/repositories.dart';
import '../../../../models/models.dart';
import '../../../../core/network/friendly_error.dart';

/// Optional single delivery-proof photo, shown before the delivery-OTP
/// screen (reached from either the collect-balance step or straight from
/// job detail once the balance is clear). Unlike the pickup photo-capture
/// flow, this is a single slot and skippable — "Continue" is always enabled.
class RiderDeliveryPhotoPage extends ConsumerStatefulWidget {
  const RiderDeliveryPhotoPage({super.key, required this.orderId, required this.job});

  final String orderId;
  final RiderJobModel job;

  @override
  ConsumerState<RiderDeliveryPhotoPage> createState() => _RiderDeliveryPhotoPageState();
}

class _RiderDeliveryPhotoPageState extends ConsumerState<RiderDeliveryPhotoPage> {
  String? _photoUrl;
  bool _isUploading = false;
  bool _isContinuing = false;

  Future<void> _captureOrRetake() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (picked == null) return;

    setState(() => _isUploading = true);
    try {
      final url = await ref
          .read(vendorRepositoryProvider)
          .uploadImage(picked, folder: 'delivery-proof-photos');
      if (mounted) setState(() => _photoUrl = url);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).orderDetailsPhotoUploadFailed(friendlyError(e)))),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  void _removePhoto() => setState(() => _photoUrl = null);

  Future<void> _continue() async {
    setState(() => _isContinuing = true);
    try {
      final url = _photoUrl;
      if (url != null) {
        await ref.read(vendorRepositoryProvider).submitDeliveryPhotos(
          widget.orderId,
          [
            {'url': url, 'order_line_id': null, 'is_grouped': true},
          ],
        );
      }
      if (mounted) {
        context.push(
          AppRoutes.riderOtp.replaceFirst(':orderId', widget.orderId),
          extra: widget.job,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).riderFailedSavePhoto(friendlyError(e)))),
        );
      }
    } finally {
      if (mounted) setState(() => _isContinuing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
          l10n.riderDeliveryPhotoTitle,
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.white : AppColors.textBlack,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.r, 12.r, 16.r, 0),
            child: Text(
              l10n.riderOptionalPhotoPrompt,
              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Center(
              child: _photoUrl != null
                  ? Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          width: 220.r,
                          height: 220.r,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Image.network(_photoUrl!, fit: BoxFit.cover),
                        ),
                        Padding(
                          padding: EdgeInsets.all(6.r),
                          child: GestureDetector(
                            onTap: _removePhoto,
                            child: Container(
                              width: 28.r,
                              height: 28.r,
                              decoration: const BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.close_rounded, color: AppColors.white, size: 18.r),
                            ),
                          ),
                        ),
                      ],
                    )
                  : GestureDetector(
                      onTap: _isUploading ? null : _captureOrRetake,
                      child: Container(
                        width: 220.r,
                        height: 220.r,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: AppColors.primary, width: 1.5),
                        ),
                        child: _isUploading
                            ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo_outlined, color: AppColors.primary, size: 36.r),
                                  SizedBox(height: 8.h),
                                  Text(l10n.riderTakePhotoLabel, style: AppTypography.bodyMedium.copyWith(color: AppColors.primary)),
                                ],
                              ),
                      ),
                    ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.r),
            child: SizedBox(
              height: 52.h,
              child: ElevatedButton(
                onPressed: (_isContinuing || _isUploading) ? null : _continue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                ),
                child: _isContinuing
                    ? SizedBox(
                        width: 20.r,
                        height: 20.r,
                        child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : Text(_photoUrl != null ? l10n.riderContinueButton : l10n.riderSkipContinueButton),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
