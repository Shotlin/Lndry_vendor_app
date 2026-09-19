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

/// One photo slot: either the single shared slot for all weight(kg)-priced
/// lines on the order, or a dedicated slot for one piece/pair line.
/// Each slot takes 1–5 photos: the first is required, the rest are optional
/// extra angles/condition shots.
class _PhotoSlot {
  _PhotoSlot({this.groupedGarmentNames, this.quantity, this.garmentName, this.lineId, required this.isGrouped});
  /// Garment names for a grouped (weight-based) slot, joined for display.
  final List<String>? groupedGarmentNames;
  /// Quantity + name for an individual piece-line slot.
  final int? quantity;
  final String? garmentName;
  final String? lineId;
  final bool isGrouped;
  final List<String> photoUrls = [];
  bool isUploading = false;

  static const maxPhotos = 5;
  bool get hasRequiredPhoto => photoUrls.isNotEmpty;
  bool get canAddMore => photoUrls.length < maxPhotos;

  String label(AppLocalizations l10n) => isGrouped
      ? l10n.riderWeightBasedItemsLabel(groupedGarmentNames!.join(', '))
      : '$quantity × $garmentName';
}

class RiderPhotoCapturePage extends ConsumerStatefulWidget {
  const RiderPhotoCapturePage({super.key, required this.orderId, required this.job});

  final String orderId;
  final RiderJobModel job;

  @override
  ConsumerState<RiderPhotoCapturePage> createState() => _RiderPhotoCapturePageState();
}

class _RiderPhotoCapturePageState extends ConsumerState<RiderPhotoCapturePage> {
  late final List<_PhotoSlot> _slots;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final weightLines = widget.job.lines.where((l) => l.isWeightBased).toList();
    final pieceLines = widget.job.lines.where((l) => !l.isWeightBased).toList();

    _slots = [
      if (weightLines.isNotEmpty)
        _PhotoSlot(
          groupedGarmentNames: weightLines.map((l) => l.garmentName).toList(),
          lineId: null,
          isGrouped: true,
        ),
      ...pieceLines.map((l) => _PhotoSlot(
            quantity: l.quantity,
            garmentName: l.garmentName,
            lineId: l.id,
            isGrouped: false,
          )),
    ];
  }

  bool get _allSlotsFilled => _slots.every((s) => s.hasRequiredPhoto);

  Future<void> _captureFor(_PhotoSlot slot) async {
    if (!slot.canAddMore) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).riderMaxPhotosPerItem('${_PhotoSlot.maxPhotos}'))),
      );
      return;
    }

    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (picked == null) return;

    setState(() => slot.isUploading = true);
    try {
      final url = await ref
          .read(vendorRepositoryProvider)
          .uploadImage(picked, folder: 'order-garment-photos');
      setState(() {
        slot.photoUrls.add(url);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).orderDetailsPhotoUploadFailed(friendlyError(e)))),
        );
      }
    } finally {
      if (mounted) setState(() => slot.isUploading = false);
    }
  }

  void _removePhoto(_PhotoSlot slot, int photoIdx) {
    setState(() => slot.photoUrls.removeAt(photoIdx));
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      final photos = _slots
          .expand((s) => s.photoUrls.map((url) => {
                'url': url,
                'order_line_id': s.lineId,
                'is_grouped': s.isGrouped,
              }))
          .toList();
      await ref
          .read(vendorRepositoryProvider)
          .submitPickupPhotos(widget.orderId, photos);
      if (mounted) {
        context.push(
          AppRoutes.riderOtp.replaceFirst(':orderId', widget.orderId),
          extra: widget.job,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).riderFailedSavePhotos(friendlyError(e)))),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
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
          l10n.riderGarmentConditionPhotosTitle,
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
              l10n.riderPhotographEachItemPrompt,
              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(16.r),
              itemCount: _slots.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (context, idx) => _SlotCard(
                slot: _slots[idx],
                isDark: isDark,
                onAddPhoto: () => _captureFor(_slots[idx]),
                onRemovePhoto: (photoIdx) => _removePhoto(_slots[idx], photoIdx),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.r),
            child: SizedBox(
              height: 52.h,
              child: ElevatedButton(
                onPressed: (_allSlotsFilled && !_isSaving) ? _save : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                ),
                child: _isSaving
                    ? SizedBox(
                        width: 20.r,
                        height: 20.r,
                        child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : Text(l10n.riderSaveButton),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SlotCard extends StatelessWidget {
  const _SlotCard({
    required this.slot,
    required this.isDark,
    required this.onAddPhoto,
    required this.onRemovePhoto,
  });

  final _PhotoSlot slot;
  final bool isDark;
  final VoidCallback onAddPhoto;
  final ValueChanged<int> onRemovePhoto;

  @override
  Widget build(BuildContext context) {
    final hasRequiredPhoto = slot.hasRequiredPhoto;
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: hasRequiredPhoto ? AppColors.success : AppColors.outline.withValues(alpha: isDark ? 0.15 : 0.3),
          width: hasRequiredPhoto ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  slot.label(l10n),
                  style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              if (hasRequiredPhoto) Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20.r),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            l10n.riderPhotosCountLabel('${slot.photoUrls.length}', '${_PhotoSlot.maxPhotos}'),
            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              for (var i = 0; i < slot.photoUrls.length; i++)
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 56.r,
                      height: 56.r,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Image.network(slot.photoUrls[i], fit: BoxFit.cover),
                    ),
                    Positioned(
                      top: -6,
                      right: -6,
                      child: GestureDetector(
                        onTap: () => onRemovePhoto(i),
                        child: Container(
                          width: 20.r,
                          height: 20.r,
                          decoration: const BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.close_rounded, color: AppColors.white, size: 14.r),
                        ),
                      ),
                    ),
                  ],
                ),
              if (slot.isUploading)
                Container(
                  width: 56.r,
                  height: 56.r,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                )
              else if (slot.canAddMore)
                GestureDetector(
                  onTap: onAddPhoto,
                  child: Container(
                    width: 56.r,
                    height: 56.r,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.primary, width: 1.5),
                    ),
                    child: Icon(Icons.add_a_photo_outlined, color: AppColors.primary, size: 22.r),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
