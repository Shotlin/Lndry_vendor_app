import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design/design_system.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../repositories/repositories.dart';
import '../../../../models/models.dart';
import '../../../../core/network/friendly_error.dart';

/// Rider's doorstep weigh-in/recount step, shown before the photo-capture
/// screen on the pickup leg. Corrects the customer's rough self-declared
/// weight/piece-count — applies immediately server-side, no customer
/// approval gate (that's the vendor's later, separate reconciliation step).
///
/// Piece-priced lines use a +/- stepper. Continuous-unit lines (kg, sq ft)
/// take an exact decimal correction instead (e.g. "1.2") — the rate is
/// multiplied by the exact value entered, never rounded.
class RiderMeasurementPage extends ConsumerStatefulWidget {
  const RiderMeasurementPage({super.key, required this.orderId, required this.job});

  final String orderId;
  final RiderJobModel job;

  @override
  ConsumerState<RiderMeasurementPage> createState() => _RiderMeasurementPageState();
}

class _RiderMeasurementPageState extends ConsumerState<RiderMeasurementPage> {
  final Map<String, int> _quantities = {};
  final Map<String, TextEditingController> _weightControllers = {};
  bool _isSaving = false;

  List<RiderJobLineModel> get _pieceLines =>
      widget.job.lines.where((l) => !l.isWeightBased).toList();
  List<RiderJobLineModel> get _continuousLines =>
      widget.job.lines.where((l) => l.isWeightBased).toList();

  @override
  void initState() {
    super.initState();
    for (final l in _pieceLines) {
      _quantities[l.id] = l.quantity;
    }
    for (final l in _continuousLines) {
      _weightControllers[l.id] = TextEditingController(text: l.quantity.toString());
    }
  }

  @override
  void dispose() {
    for (final c in _weightControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _adjust(String lineId, int delta) {
    setState(() {
      final current = _quantities[lineId] ?? 0;
      _quantities[lineId] = (current + delta).clamp(0, 999);
    });
  }

  Future<void> _saveAndContinue() async {
    // Only one continuous-unit line's correction is sent per submission —
    // the backend targets whichever kg/sqft line is dominant on the order.
    double? confirmedWeightKg;
    for (final l in _continuousLines) {
      final text = _weightControllers[l.id]?.text.trim();
      final parsed = text == null ? null : double.tryParse(text);
      if (parsed != null && parsed > 0) {
        confirmedWeightKg = parsed;
        break;
      }
    }

    setState(() => _isSaving = true);
    try {
      final lines = _pieceLines
          .map((l) => {
                'order_line_id': l.id,
                'confirmed_quantity': _quantities[l.id] ?? l.quantity,
              })
          .toList();

      await ref.read(vendorRepositoryProvider).submitPickupMeasurements(
            widget.orderId,
            confirmedWeightKg: confirmedWeightKg,
            lines: lines,
          );

      if (mounted) {
        context.push(
          AppRoutes.riderPhotos.replaceFirst(':orderId', widget.orderId),
          extra: widget.job,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).riderFailedSaveMeasurements(friendlyError(e)))),
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
          l10n.riderConfirmWeightCountTitle,
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
              l10n.riderWeighRecountPrompt,
              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.r),
              children: [
                if (_continuousLines.isNotEmpty) ...[
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Text(l10n.riderWeightAreaBasedHeader, style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  ..._continuousLines.map((l) => Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurface : AppColors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(color: AppColors.outline.withValues(alpha: isDark ? 0.1 : 0.2)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(l.garmentName, style: AppTypography.bodyMedium),
                                    Text(
                                      l10n.riderEnterExactUnit(l.unitLabel),
                                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 90.w,
                                child: TextField(
                                  controller: _weightControllers[l.id],
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  textAlign: TextAlign.center,
                                  style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                                  decoration: InputDecoration(
                                    suffixText: l.unitLabel,
                                    isDense: true,
                                    border: const OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                  SizedBox(height: 8.h),
                ],
                if (_pieceLines.isNotEmpty) ...[
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Text(l10n.riderPieceBasedHeader, style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  ..._pieceLines.map((l) {
                    final count = _quantities[l.id] ?? l.quantity;
                    return Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : AppColors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: AppColors.outline.withValues(alpha: isDark ? 0.1 : 0.2)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(l.garmentName, style: AppTypography.bodyMedium),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline_rounded),
                              color: AppColors.primary,
                              onPressed: () => _adjust(l.id, -1),
                            ),
                            SizedBox(
                              width: 32.w,
                              child: Text(
                                '$count',
                                textAlign: TextAlign.center,
                                style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline_rounded),
                              color: AppColors.primary,
                              onPressed: () => _adjust(l.id, 1),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.r),
            child: SizedBox(
              height: 52.h,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveAndContinue,
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
                    : Text(l10n.riderSaveContinueButton),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
