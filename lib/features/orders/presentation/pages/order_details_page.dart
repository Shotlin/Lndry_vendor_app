import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/design/design_system.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../l10n/order_status_l10n.dart';
import '../../../../providers/orders_provider.dart';
import '../../../../repositories/repositories.dart';
import '../../../../models/models.dart';

class OrderDetailsPage extends ConsumerStatefulWidget {
  const OrderDetailsPage({super.key, required this.orderId});

  final String orderId;

  @override
  ConsumerState<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends ConsumerState<OrderDetailsPage> {
  final _reasonController = TextEditingController();
  final _notesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final Map<String, int> _confirmedQuantities = {};
  /// Decimal weight/area text controllers for continuous-unit lines (kg,
  /// sq ft) — these lines take an exact decimal correction instead of the
  /// +/- stepper used for piece-priced lines.
  final Map<String, TextEditingController> _weightControllers = {};
  final List<String> _reconcilePhotoUrls = [];
  /// order_line_id -> chosen replacement service, when the vendor moves an
  /// item to a different service than the customer originally picked (e.g.
  /// a delicate item found unsuitable for a per-kg wash).
  final Map<String, ReclassifyOption> _reclassifications = {};
  /// Brand-new services added during reconciliation — not tied to any
  /// existing order line. Covers a genuine addition, and the destination
  /// for garments moved out of a partially-reduced continuous-unit line
  /// (reduce that line's weight, then add the moved garments here under
  /// whatever service/quantity they actually belong to).
  final List<_NewLineDraft> _newLineDrafts = [];
  List<ReclassifyOption> _serviceCatalog = [];
  bool _catalogFetchAttempted = false;
  bool _isReconciling = false;
  bool _isUploadingReconcilePhoto = false;
  bool _autoOpenedReconcile = false;
  final ScrollController _timelineScrollController = ScrollController();
  int? _timelineScrolledForIndex;

  @override
  void dispose() {
    _reasonController.dispose();
    _notesController.dispose();
    for (final c in _weightControllers.values) {
      c.dispose();
    }
    _timelineScrollController.dispose();
    super.dispose();
  }

  /// True for units priced by a continuous measurement (kg, sq ft) rather
  /// than a discrete count — these take an exact decimal correction, never
  /// a +/- stepper.
  bool _isContinuousUnit(String unit) {
    final u = unit.toLowerCase();
    return u == 'kg' || u == 'sqft';
  }

  String _unitPricingLabel(String unit) {
    final l10n = AppLocalizations.of(context);
    final u = unit.toLowerCase();
    if (u == 'kg') return l10n.orderDetailsPerKg;
    if (u == 'sqft') return l10n.orderDetailsPerSqFt;
    return l10n.orderDetailsPerItem;
  }

  /// A continuous-unit line's real decimal weight/area can't live in the
  /// INTEGER `order_lines.quantity` column (it's a sentinel `1` once
  /// corrected) — the exact value is derivable from totalPrice/unitPrice,
  /// which always carry the real money regardless of that sentinel.
  double _derivedQuantity(OrderItem item) {
    if (_isContinuousUnit(item.unit) && item.unitPrice > 0) {
      return item.totalPrice / item.unitPrice;
    }
    return item.quantity.toDouble();
  }

  String _formatDraftQuantity(_NewLineDraft draft) {
    if (draft.option.isWeightBased) {
      var s = draft.quantity.toStringAsFixed(2);
      s = s.replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
      final suffix = draft.option.unit.toLowerCase() == 'sqft' ? 'sq ft' : 'kg';
      return '$s $suffix';
    }
    return '${draft.quantity.round()} pcs';
  }

  String _quantityLabel(OrderItem item) {
    if (_isContinuousUnit(item.unit)) {
      final suffix = item.unit.toLowerCase() == 'sqft' ? 'sq ft' : 'kg';
      var s = _derivedQuantity(item).toStringAsFixed(2);
      s = s.replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
      return '$s $suffix';
    }
    return '${item.quantity}';
  }

  /// Keyed by the real `order_lines.id` (not `serviceId`/garment_type_id,
  /// which isn't guaranteed unique per order) — this is what the rider
  /// measurement endpoint and this reconciliation endpoint both key against.
  void _initializeQuantities(OrderModel order) {
    _confirmedQuantities.clear();
    _reclassifications.clear();
    _newLineDrafts.clear();
    for (final c in _weightControllers.values) {
      c.dispose();
    }
    _weightControllers.clear();
    for (final item in order.items) {
      final key = item.orderLineId ?? item.serviceId;
      _confirmedQuantities[key] = item.quantity;
      if (_isContinuousUnit(item.unit)) {
        // item.quantity is a sentinel (1) once a continuous-unit line has
        // already been through one correction — always derive the real
        // decimal value from totalPrice/unitPrice, same as _quantityLabel,
        // so re-evaluation starts from the actual booked/confirmed amount
        // instead of silently resetting to 1.
        var s = _derivedQuantity(item).toStringAsFixed(2);
        s = s.replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
        _weightControllers[key] = TextEditingController(text: s);
      }
    }
  }

  Future<void> _loadServiceCatalog(OrderModel order, void Function(void Function()) setSheetState) async {
    try {
      final catalog = await ref.read(vendorRepositoryProvider).getVendorServiceCatalog();
      setSheetState(() => _serviceCatalog = catalog);
    } catch (_) {
      // Non-critical — reclassification/add-service is optional; the vendor
      // can still adjust quantities/weight and submit without it if this fails.
    }
  }

  /// Shared catalog picker for both "move this item to a different service"
  /// and "add a service" — groups by category, shows the vendor's real
  /// image/logo per item so this matches the shared-screen design language
  /// (only the vendor's own active, approved services ever appear here,
  /// resolved server-side, never a partial/broken list).
  Future<ReclassifyOption?> _pickCatalogOption(BuildContext sheetContext, {String? title}) async {
    final l10n = AppLocalizations.of(context);
    final sheetTitle = title ?? l10n.orderDetailsChooseServiceTitle;
    if (_serviceCatalog.isEmpty) return null;
    final grouped = <String, List<ReclassifyOption>>{};
    for (final option in _serviceCatalog) {
      grouped.putIfAbsent(option.categoryName ?? l10n.orderDetailsOtherCategoryFallback, () => []).add(option);
    }
    return showModalBottomSheet<ReclassifyOption>(
      context: sheetContext,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (context) => SafeArea(
        child: DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) => ListView(
            controller: scrollController,
            padding: EdgeInsets.all(16.r),
            children: [
              Text(sheetTitle, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
              SizedBox(height: 12.h),
              for (final entry in grouped.entries) ...[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.h),
                  child: Text(entry.key, style: AppTypography.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                ),
                for (final option in entry.value)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: option.imageUrl != null && option.imageUrl!.isNotEmpty
                          ? Image.network(option.imageUrl!, width: 44.r, height: 44.r, fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _catalogPlaceholderIcon())
                          : _catalogPlaceholderIcon(),
                    ),
                    title: Text(option.garmentName, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                    subtitle: Text(option.serviceName),
                    trailing: Text(
                      '₹${(option.ratePaise / 100).toStringAsFixed(0)}\n${_unitPricingLabel(option.unit)}',
                      textAlign: TextAlign.right,
                      style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.bold),
                    ),
                    onTap: () => Navigator.of(context).pop(option),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _catalogPlaceholderIcon() => Container(
        width: 44.r,
        height: 44.r,
        color: AppColors.primaryContainer,
        child: Icon(Icons.local_laundry_service_outlined, color: AppColors.primary, size: 20.r),
      );

  Future<void> _pickReplacementService(
    BuildContext sheetContext,
    String lineKey,
    void Function(void Function()) setSheetState,
  ) async {
    final selected = await _pickCatalogOption(sheetContext, title: AppLocalizations.of(context).orderDetailsMoveServiceTitle);
    if (selected != null) {
      setSheetState(() => _reclassifications[lineKey] = selected);
    }
  }

  /// Prompts for a quantity (decimal for kg/sq ft services, whole-number
  /// stepper for piece services) and adds the picked service as a new line.
  Future<void> _addNewServiceLine(
    BuildContext sheetContext,
    void Function(void Function()) setSheetState,
  ) async {
    final l10n = AppLocalizations.of(context);
    final selected = await _pickCatalogOption(sheetContext, title: l10n.orderDetailsAddServiceTitle);
    if (selected == null) return;

    final isWeight = selected.isWeightBased;
    final controller = TextEditingController(text: isWeight ? '' : '1');
    final quantity = await showDialog<double>(
      context: sheetContext,
      builder: (dialogContext) => AlertDialog(
        title: Text(selected.garmentName),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.numberWithOptions(decimal: isWeight),
          decoration: InputDecoration(
            labelText: isWeight ? _unitPricingLabel(selected.unit) : l10n.orderDetailsQuantityLabel,
            suffixText: isWeight ? (selected.unit.toLowerCase() == 'sqft' ? 'sq ft' : 'kg') : null,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(l10n.commonCancel)),
          ElevatedButton(
            onPressed: () {
              final parsed = double.tryParse(controller.text.trim());
              Navigator.pop(dialogContext, (parsed != null && parsed > 0) ? parsed : null);
            },
            child: Text(l10n.orderDetailsAddButton),
          ),
        ],
      ),
    );
    controller.dispose();
    if (quantity == null) return;

    setSheetState(() => _newLineDrafts.add(_NewLineDraft(option: selected, quantity: quantity)));
  }

  Future<void> _addReconcilePhoto(void Function(void Function()) setSheetState) async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.camera, imageQuality: 85);
    if (picked == null) return;

    setSheetState(() => _isUploadingReconcilePhoto = true);
    try {
      final url = await ref
          .read(vendorRepositoryProvider)
          .uploadImage(picked, folder: 'order-reconciliation-photos');
      setSheetState(() => _reconcilePhotoUrls.add(url));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).orderDetailsPhotoUploadFailed('$e'))),
        );
      }
    } finally {
      setSheetState(() => _isUploadingReconcilePhoto = false);
    }
  }

  Future<void> _submitReconciliation(OrderModel order) async {
    final l10n = AppLocalizations.of(context);
    if (_reconcilePhotoUrls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.orderDetailsPhotoRequired)),
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      setState(() => _isReconciling = true);
      try {
        // Continuous-unit lines (kg, sq ft) go through confirmedWeightKg as
        // an exact decimal, not the integer confirmed_quantity used for
        // piece-priced lines — only one such line's correction is sent per
        // submission, the backend targets whichever is dominant on the order.
        double? confirmedWeightKg;
        for (final entry in _weightControllers.entries) {
          final parsed = double.tryParse(entry.value.text.trim());
          if (parsed != null && parsed > 0) {
            confirmedWeightKg = parsed;
            break;
          }
        }

        final List<Map<String, dynamic>> lines = _confirmedQuantities.entries
            .where((e) => !_weightControllers.containsKey(e.key))
            .map((e) => <String, dynamic>{
                  'order_line_id': e.key,
                  'confirmed_quantity': e.value,
                  if (_reclassifications.containsKey(e.key))
                    'new_garment_type_id': _reclassifications[e.key]!.garmentTypeId,
                })
            .toList();
        // A continuous-unit line's reclassification (if any) still needs to
        // reach the backend even though its quantity travels via
        // confirmedWeightKg rather than this lines[] entry.
        for (final key in _weightControllers.keys) {
          if (_reclassifications.containsKey(key)) {
            lines.add(<String, dynamic>{
              'order_line_id': key,
              'new_garment_type_id': _reclassifications[key]!.garmentTypeId,
            });
          }
        }

        final notes = _notesController.text.trim();

        final newLines = _newLineDrafts
            .map((d) => <String, dynamic>{
                  'garment_type_id': d.option.garmentTypeId,
                  'quantity': d.quantity,
                })
            .toList();

        await ref.read(ordersListProvider.notifier).reconcile(
          order.id,
          lines: lines,
          confirmedWeightKg: confirmedWeightKg,
          adjustmentReason: notes.isNotEmpty ? notes : 'Receipt reconciliation',
          photoUrls: _reconcilePhotoUrls,
          newLines: newLines.isNotEmpty ? newLines : null,
        );

        ref.invalidate(orderDetailsProvider(order.id));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.orderDetailsSubmittedForApproval)),
          );
          Navigator.pop(context); // Close sheet
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.orderDetailsReconciliationFailed('$e'))),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isReconciling = false);
        }
      }
    }
  }

  void _showReconcileSheet(OrderModel order) {
    _initializeQuantities(order);
    _reconcilePhotoUrls.clear();
    _catalogFetchAttempted = false;
    _notesController.text = '';
    final l10n = AppLocalizations.of(context);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            if (!_catalogFetchAttempted) {
              _catalogFetchAttempted = true;
              _loadServiceCatalog(order, setSheetState);
            }
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20.w,
                right: 20.w,
                top: 24.h,
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l10n.orderDetailsReconcileSheetTitle,
                        style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        l10n.orderDetailsReconcileSheetSubtitle,
                        style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                      ),
                      SizedBox(height: 20.h),

                      // Item List adjusting
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: order.items.length,
                        separatorBuilder: (_, __) => SizedBox(height: 12.h),
                        itemBuilder: (context, idx) {
                          final item = order.items[idx];
                          final key = item.orderLineId ?? item.serviceId;
                          final count = _confirmedQuantities[key] ?? item.quantity;
                          final reclassifiedTo = _reclassifications[key];
                          final weightController = _weightControllers[key];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          reclassifiedTo != null ? reclassifiedTo.garmentName : item.serviceName,
                                          style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                                        ),
                                        Text(l10n.orderDetailsEstQuantity(_quantityLabel(item)), style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                                        if (reclassifiedTo != null)
                                          Text(
                                            l10n.orderDetailsMovedFrom(item.serviceName, reclassifiedTo.serviceName),
                                            style: AppTypography.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                                          ),
                                      ],
                                    ),
                                  ),
                                  if (weightController != null)
                                    SizedBox(
                                      width: 90.w,
                                      child: TextField(
                                        controller: weightController,
                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                        textAlign: TextAlign.center,
                                        style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                                        decoration: InputDecoration(
                                          suffixText: item.unit.toLowerCase() == 'sqft' ? 'sq ft' : 'kg',
                                          isDense: true,
                                          border: const OutlineInputBorder(),
                                        ),
                                      ),
                                    )
                                  else
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove_circle_outline_rounded),
                                          onPressed: count > 0
                                              ? () => setSheetState(() => _confirmedQuantities[key] = count - 1)
                                              : null,
                                        ),
                                        Text('$count', style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                                        IconButton(
                                          icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary),
                                          onPressed: () => setSheetState(() => _confirmedQuantities[key] = count + 1),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                              if (_serviceCatalog.isNotEmpty)
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton.icon(
                                    onPressed: () => _pickReplacementService(context, key, setSheetState),
                                    icon: const Icon(Icons.swap_horiz_rounded, size: 16),
                                    label: Text(reclassifiedTo != null ? l10n.orderDetailsChangeServiceAgain : l10n.orderDetailsMoveServicePrompt),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),

                      // Newly added services — moved-out garments from a
                      // partially-reduced line, or a genuine addition.
                      if (_newLineDrafts.isNotEmpty) ...[
                        SizedBox(height: 12.h),
                        const Divider(),
                        SizedBox(height: 4.h),
                        for (var i = 0; i < _newLineDrafts.length; i++)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.h),
                            child: Row(
                              children: [
                                Icon(Icons.add_circle_rounded, color: AppColors.success, size: 18.r),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(_newLineDrafts[i].option.garmentName,
                                          style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                                      Text(
                                        '${_formatDraftQuantity(_newLineDrafts[i])} · ${_newLineDrafts[i].option.serviceName}',
                                        style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.close_rounded, size: 18.r, color: AppColors.error),
                                  onPressed: () => setSheetState(() => _newLineDrafts.removeAt(i)),
                                ),
                              ],
                            ),
                          ),
                      ],
                      SizedBox(height: 8.h),
                      if (_serviceCatalog.isNotEmpty)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: () => _addNewServiceLine(context, setSheetState),
                            icon: const Icon(Icons.add_rounded, size: 18),
                            label: Text(l10n.orderDetailsAddServiceButton),
                          ),
                        ),
                      SizedBox(height: 20.h),

                      // Adjustment notes
                      TextFormField(
                        controller: _notesController,
                        decoration: InputDecoration(
                          labelText: l10n.orderDetailsAdjustmentNoteLabel,
                          hintText: l10n.orderDetailsAdjustmentNoteHint,
                          prefixIcon: const Icon(Icons.note_alt_rounded),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Photo evidence — required before submit is enabled.
                      Text(
                        l10n.orderDetailsPhotoEvidenceLabel,
                        style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 8.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: [
                          for (var i = 0; i < _reconcilePhotoUrls.length; i++)
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
                                  child: Image.network(_reconcilePhotoUrls[i], fit: BoxFit.cover),
                                ),
                                Positioned(
                                  top: -6,
                                  right: -6,
                                  child: GestureDetector(
                                    onTap: () => setSheetState(() => _reconcilePhotoUrls.removeAt(i)),
                                    child: Container(
                                      width: 20.r,
                                      height: 20.r,
                                      decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                                      child: Icon(Icons.close_rounded, color: AppColors.white, size: 14.r),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          if (_isUploadingReconcilePhoto)
                            Container(
                              width: 56.r,
                              height: 56.r,
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                            )
                          else
                            GestureDetector(
                              onTap: () => _addReconcilePhoto(setSheetState),
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
                      SizedBox(height: 24.h),

                      ElevatedButton(
                        onPressed: (_isReconciling || _reconcilePhotoUrls.isEmpty)
                            ? null
                            : () => _submitReconciliation(order),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                        ),
                        child: _isReconciling
                            ? SizedBox(
                                width: 20.r,
                                height: 20.r,
                                child: const CircularProgressIndicator(color: AppColors.white, strokeWidth: 2),
                              )
                            : Text(l10n.orderDetailsSubmitButton),
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _updateStage(String id, String stage) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ref.read(ordersListProvider.notifier).updateStage(id, stage);
      ref.invalidate(orderDetailsProvider(id));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.ordersStageUpdatedSnack(stage))));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.ordersErrorSnack('$e'))));
    }
  }

  Future<void> _acceptOrder(String id) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ref.read(ordersListProvider.notifier).acceptOrder(id);
      ref.invalidate(orderDetailsProvider(id));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.ordersOrderAcceptedSnack)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.ordersErrorSnack('$e'))));
    }
  }

  void _showRejectDialog(String id) {
    final l10n = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.orderDetailsRejectOrderTitle),
          content: TextFormField(
            controller: _reasonController,
            decoration: InputDecoration(
              labelText: l10n.orderDetailsRejectionReasonLabel,
              hintText: l10n.orderDetailsRejectionReasonHint,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.commonCancel),
            ),
            ElevatedButton(
              onPressed: () async {
                final reason = _reasonController.text.trim();
                Navigator.pop(context);
                try {
                  await ref.read(ordersListProvider.notifier).rejectOrder(id, reason: reason);
                  ref.invalidate(orderDetailsProvider(id));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.ordersOrderRejectedSnack)));
                  context.pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.dashboardActionFailed('$e'))));
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              child: Text(l10n.orderDetailsConfirmRejectButton),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderAsync = ref.watch(orderDetailsProvider(widget.orderId));
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
          l10n.orderDetailsPageTitle,
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.white : AppColors.textBlack,
          ),
        ),
      ),
      body: orderAsync.when(
        data: (order) {
          final statusColor = _getStatusColor(order.status);
          
          if (!_autoOpenedReconcile) {
            final uri = GoRouterState.of(context).uri;
            if (uri.fragment == 'reconcile' || uri.queryParameters['reconcile'] == 'true') {
              _autoOpenedReconcile = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _showReconcileSheet(order);
              });
            }
          }
          
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Status Header
                      Container(
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : AppColors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: AppColors.outline.withOpacity(0.1)),
                        ),
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.dashboardOrderIdLabel(order.orderNumber.isNotEmpty ? order.orderNumber : order.id.substring(0, 8).toUpperCase()),
                                  style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  _formatDateTime(order.createdAt),
                                  style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                                ),
                                SizedBox(height: 10.h),
                                // Full-width so a long status (e.g.
                                // "Re-evaluation Submitted — Waiting for
                                // Customer Approval") wraps onto a second
                                // line instead of forcing a fixed-width Row
                                // to squeeze the order#/date column down to
                                // a sliver, or overflowing off-screen.
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(14.r),
                                    border: Border.all(color: statusColor.withOpacity(0.3)),
                                  ),
                                  child: Text(
                                    orderStatusLabel(l10n, order.status).toUpperCase(),
                                    style: AppTypography.bodySmall.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: statusColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),

                      if (order.status == OrderStatus.reconciliationPending) ...[
                        _buildReconciliationBanner(
                          icon: Icons.hourglass_top_rounded,
                          color: AppColors.warning,
                          title: l10n.orderDetailsAwaitingApprovalTitle,
                          body: l10n.orderDetailsAwaitingApprovalBody,
                        ),
                        SizedBox(height: 16.h),
                      ] else if (order.status == OrderStatus.reconciliationDisputed) ...[
                        _buildReconciliationBanner(
                          icon: Icons.error_outline_rounded,
                          color: AppColors.error,
                          title: l10n.orderDetailsDisputedTitle,
                          body: l10n.orderDetailsDisputedBody,
                        ),
                        SizedBox(height: 16.h),
                      ],

                      // Stepper / Timeline summary
                      Text(l10n.orderDetailsLifecycleStepper, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8.h),
                      _buildTimeline(order.status),
                      SizedBox(height: 24.h),

                      // Customer Info
                      Text(l10n.orderDetailsCustomerDetails, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : AppColors.white,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20.r,
                                  backgroundColor: AppColors.primaryContainer,
                                  child: const Icon(Icons.person, color: AppColors.primary),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(order.customerName.isNotEmpty ? order.customerName : l10n.orderDetailsCustomerFallback, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                                    SizedBox(height: 2.h),
                                    if (order.customerPhone.isNotEmpty) ...[
                                      Text(order.customerPhone, style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
                                      SizedBox(height: 2.h),
                                    ],
                                    if (order.deliveryAddressText.isNotEmpty)
                                      Text(order.deliveryAddressText, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                                    if (order.customerNotes != null && order.customerNotes!.isNotEmpty) ...[
                                      SizedBox(height: 6.h),
                                      Text(l10n.orderDetailsCustomerNote(order.customerNotes!), style: AppTypography.bodySmall.copyWith(color: AppColors.warning, fontWeight: FontWeight.bold)),
                                    ],
                                  ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Garment Items List — while a re-evaluation is
                      // pending/disputed, this shows exactly what was
                      // submitted (services, quantities, final amount,
                      // note, evidence) instead of the stale
                      // pre-reconciliation order data, since the real
                      // order_lines/total don't change until the customer
                      // actually accepts.
                      if (order.pendingReconciliation != null)
                        _buildPendingReconciliationCard(order, isDark)
                      else ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(l10n.orderDetailsGarmentItems, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                            if (order.status == OrderStatus.receivedAtVendor)
                              TextButton.icon(
                                onPressed: () => _showReconcileSheet(order),
                                icon: const Icon(Icons.scale_rounded, size: 16),
                                label: Text(l10n.orderDetailsReconcileCountButton),
                              ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          padding: EdgeInsets.all(16.r),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurface : AppColors.white,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Column(
                            children: [
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: order.items.length,
                                separatorBuilder: (_, __) => const Divider(),
                                itemBuilder: (context, idx) {
                                  final item = order.items[idx];
                                  return Padding(
                                    padding: EdgeInsets.symmetric(vertical: 4.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(item.serviceName, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                                            Text(l10n.orderDetailsQuantityValue(_quantityLabel(item)), style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                                          ],
                                        ),
                                        Text('₹${item.totalPrice.toStringAsFixed(2)}', style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              const Divider(thickness: 1.5),
                              SizedBox(height: 8.h),
                              _buildPriceSummaryRow(l10n.orderDetailsSubtotal, '₹${order.subtotal.toStringAsFixed(2)}'),
                              _buildPriceSummaryRow(l10n.orderDetailsGstTaxes, '₹${order.gstAmount.toStringAsFixed(2)}'),
                              _buildPriceSummaryRow(l10n.orderDetailsPlatformFee, '₹${order.platformFee.toStringAsFixed(2)}'),
                              if (order.deliveryFee > 0)
                                _buildPriceSummaryRow(l10n.orderDetailsDeliveryFee, '₹${order.deliveryFee.toStringAsFixed(2)}'),
                              if (order.handlingFee > 0)
                                _buildPriceSummaryRow(l10n.orderDetailsHandlingFee, '₹${order.handlingFee.toStringAsFixed(2)}'),
                              const Divider(),
                              _buildPriceSummaryRow(
                                l10n.orderDetailsTotalPayable,
                                '₹${order.total.toStringAsFixed(2)}',
                                isBold: true,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                      ],
                      SizedBox(height: 32.h),

                      // Customer Review — only present once the customer
                      // has actually submitted one for this order.
                      if (order.customerRating != null) ...[
                        Text(l10n.orderDetailsCustomerReview, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8.h),
                        Container(
                          padding: EdgeInsets.all(16.r),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurface : AppColors.white,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildRatingRow(l10n.orderDetailsVendorRating, order.customerRating!),
                              if (order.deliveryRating != null) ...[
                                SizedBox(height: 8.h),
                                _buildRatingRow(l10n.orderDetailsDeliveryRating, order.deliveryRating!),
                              ],
                              if (order.customerReview != null && order.customerReview!.isNotEmpty) ...[
                                SizedBox(height: 12.h),
                                Text(order.customerReview!, style: AppTypography.bodyMedium),
                              ],
                            ],
                          ),
                        ),
                        SizedBox(height: 32.h),
                      ],
                    ],
                  ),
                ),
              ),
              
              // Bottom Action panel (sticky)
              _buildBottomActions(order),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text(l10n.orderDetailsErrorLoading('$err'))),
      ),
    );
  }

  Widget _buildReconciliationBanner({
    required IconData icon,
    required Color color,
    required String title,
    required String body,
  }) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20.r),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: color)),
                SizedBox(height: 4.h),
                Text(body, style: AppTypography.bodySmall.copyWith(color: color)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingRow(String label, double rating) {
    final percent = (rating / 5 * 100).round();
    return Row(
      children: [
        Expanded(child: Text(label, style: AppTypography.bodyMedium)),
        Row(
          children: List.generate(
            5,
            (i) => Icon(
              i < rating.round() ? Icons.star_rounded : Icons.star_border_rounded,
              color: AppColors.warning,
              size: 16.r,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Text('$percent%', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  /// Shown instead of the normal Garment Items card while a re-evaluation
  /// is pending customer approval (or was just disputed) — the vendor's
  /// submitted services/quantities/amount/note/photos, since the real
  /// order data doesn't change until the customer accepts.
  Widget _buildPendingReconciliationCard(OrderModel order, bool isDark) {
    final l10n = AppLocalizations.of(context);
    final recon = order.pendingReconciliation!;
    final isDisputed = recon.status == 'REJECTED';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(
              isDisputed ? Icons.report_problem_rounded : Icons.hourglass_top_rounded,
              size: 18.r,
              color: isDisputed ? AppColors.error : AppColors.warning,
            ),
            SizedBox(width: 6.w),
            Text(
              isDisputed ? l10n.orderStatusReconciliationDisputed : l10n.orderDetailsSubmittedReevaluation,
              style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold, color: isDisputed ? AppColors.error : AppColors.warning),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recon.lineChanges.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, idx) {
                  final c = recon.lineChanges[idx];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(c.displayName, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                              if (c.isNew)
                                Text(l10n.orderDetailsNewServiceAdded, style: AppTypography.bodySmall.copyWith(color: AppColors.success, fontWeight: FontWeight.w600))
                              else if (c.isReclassified)
                                Text(l10n.orderDetailsMovedGeneric(c.previousName ?? l10n.orderDetailsItemFallback, c.displayName),
                                    style: AppTypography.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        Text(c.quantityLabel, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  );
                },
              ),
              const Divider(thickness: 1.5),
              SizedBox(height: 8.h),
              _buildPriceSummaryRow(l10n.orderDetailsPreviousTotal, '₹${(recon.previousPayableAmountPaise / 100).toStringAsFixed(2)}'),
              _buildPriceSummaryRow(
                l10n.orderDetailsFinalEvaluatedAmount,
                '₹${(recon.proposedPayableAmountPaise / 100).toStringAsFixed(2)}',
                isBold: true,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
        if (recon.reason != null && recon.reason!.isNotEmpty) ...[
          SizedBox(height: 12.h),
          Text(l10n.orderDetailsAdjustmentNoteHeader, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 4.h),
          Text(recon.reason!, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
        ],
        if (recon.photos.isNotEmpty) ...[
          SizedBox(height: 12.h),
          Text(l10n.orderDetailsPhotoEvidenceHeader, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 8.h),
          SizedBox(
            height: 72.r,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: recon.photos.length,
              separatorBuilder: (_, __) => SizedBox(width: 8.w),
              itemBuilder: (context, idx) => ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Image.network(recon.photos[idx], width: 72.r, height: 72.r, fit: BoxFit.cover),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPriceSummaryRow(String label, String value, {bool isBold = false, Color? color}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodyMedium.copyWith(color: color, fontWeight: isBold ? FontWeight.bold : null)),
          Text(value, style: AppTypography.bodyLarge.copyWith(color: color, fontWeight: isBold ? FontWeight.bold : null)),
        ],
      ),
    );
  }

  static const double _timelineStageWidth = 64.0;

  Widget _buildTimeline(OrderStatus status) {
    final l10n = AppLocalizations.of(context);
    final stages = [
      l10n.orderDetailsStageWaiting,
      l10n.orderDetailsStageAccepted,
      l10n.orderDetailsStageReceived,
      l10n.orderDetailsStageCustomerApproval,
      l10n.orderDetailsStageProcessing,
      l10n.orderDetailsStagePacked,
      l10n.orderDetailsStageDelivered,
    ];
    final activeIndex = _getStageIndex(status);

    // With 7 stages only ~5 fit on screen at once — without this, an order
    // that's already far along (e.g. out for delivery) silently required
    // the vendor to manually scroll right to discover where they actually
    // are, with WAITING shown first and looking like the current stage.
    if (_timelineScrolledForIndex != activeIndex) {
      _timelineScrolledForIndex = activeIndex;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_timelineScrollController.hasClients) return;
        final target = (activeIndex * _timelineStageWidth.w - 80.w)
            .clamp(0.0, _timelineScrollController.position.maxScrollExtent);
        _timelineScrollController.animateTo(
          target,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16.r),
      ),
      // Fixed-width columns in a horizontal scroll view, not a spaceAround
      // Row — "CUSTOMER APPROVAL" is far longer than the other labels, and
      // a fixed-width Row can't fit 7 stages plus that label without
      // squeezing/overflowing. Each column lets its label wrap to 2 lines
      // instead of forcing extra width.
      child: SingleChildScrollView(
        controller: _timelineScrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(stages.length, (index) {
            final isActive = index <= activeIndex;
            final isCurrent = index == activeIndex;
            return Container(
              width: _timelineStageWidth.w,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                children: [
                  Container(
                    width: 24.r,
                    height: 24.r,
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? AppColors.primary
                          : isActive
                              ? AppColors.primary.withOpacity(0.5)
                              : Colors.grey.shade400,
                      shape: BoxShape.circle,
                      border: isCurrent ? Border.all(color: Colors.white, width: 2) : null,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.check,
                        size: 14.r,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    stages[index],
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: isCurrent ? FontWeight.bold : null,
                      color: isCurrent ? AppColors.primary : AppColors.textSecondary,
                      fontSize: 9.sp,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  int _getStageIndex(OrderStatus status) {
    if (status == OrderStatus.waitingForVendorConfirmation) return 0;
    if (status == OrderStatus.vendorAccepted || status == OrderStatus.pickupAssigned || status == OrderStatus.goingForPickup || status == OrderStatus.pickupOtpVerified || status == OrderStatus.pickedUp) return 1;
    if (status == OrderStatus.receivedAtVendor) return 2;
    if (status == OrderStatus.reconciliationPending || status == OrderStatus.reconciliationDisputed) {
      return 3;
    }
    if (status == OrderStatus.processing) return 4;
    // Dispatched/out for delivery has no dedicated stepper stage — stays
    // "current" at PACKED (the item has left the shop but isn't delivered
    // yet) until DELIVERED actually completes it. Previously these two
    // statuses matched none of the conditions here and fell through to the
    // `return 0` default, making the stepper show WAITING as active even
    // for an order already out for delivery.
    if (status == OrderStatus.packed || status == OrderStatus.deliveryAssigned || status == OrderStatus.outForDelivery) {
      return 5;
    }
    if (status == OrderStatus.delivered || status == OrderStatus.deliveryOtpVerified) return 6;
    return 0;
  }

  Widget _buildBottomActions(OrderModel order) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    if (order.status == OrderStatus.waitingForVendorConfirmation) {
      return Container(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _showRejectDialog(order.id),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                child: Text(l10n.orderDetailsRejectOrderButton),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _acceptOrder(order.id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: AppColors.white,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                child: Text(l10n.orderDetailsAcceptOrderButton),
              ),
            ),
          ],
        ),
      );
    } else if ([
      OrderStatus.vendorAccepted,
      OrderStatus.pickupAssigned,
      OrderStatus.goingForPickup,
      OrderStatus.pickupOtpVerified,
      OrderStatus.pickedUp,
    ].contains(order.status)) {
      // Garments are somewhere between vendor-accepted and physically
      // arriving at the shop — the state machine allows RECEIVED_AT_VENDOR
      // from any of these (rider flow or a manual/self-pickup bypass), but
      // until now there was no button here at all, so orders sitting in
      // PICKED_UP (etc.) had a blank action area with no way forward.
      return Container(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: SizedBox(
          height: 52.h,
          child: ElevatedButton(
            onPressed: () => _updateStage(order.id, 'RECEIVED_AT_VENDOR'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: EdgeInsets.symmetric(vertical: 14.h),
            ),
            child: Text(l10n.orderDetailsMarkReceivedButton),
          ),
        ),
      );
    } else if (order.status == OrderStatus.receivedAtVendor) {
      return Container(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _showReconcileSheet(order),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                child: Text(l10n.orderDetailsReconcileItemsButton),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _updateStage(order.id, 'WASHING'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                child: Text(l10n.orderDetailsStartProcessingButton),
              ),
            ),
          ],
        ),
      );
    } else if (order.status == OrderStatus.reconciliationPending) {
      // Vendor already submitted a re-evaluation — this order stays in its
      // current active-orders slot, no Accept/Reject (those are only for
      // the very first order acceptance), and no Start Processing until the
      // customer decides. Nothing to press here, just a status message.
      return Container(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hourglass_top_rounded, size: 18.r, color: AppColors.warning),
            SizedBox(width: 8.w),
            Text(
              l10n.orderDetailsWaitingApprovalStatus,
              style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600, color: AppColors.warning),
            ),
          ],
        ),
      );
    } else if (order.status == OrderStatus.reconciliationDisputed) {
      // Customer rejected the proposal — resolution is a phone call, then
      // the vendor resubmits through the same sheet/endpoint (no separate
      // "resolve dispute" UI).
      return Container(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: SizedBox(
          height: 52.h,
          child: ElevatedButton(
            onPressed: () => _showReconcileSheet(order),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: EdgeInsets.symmetric(vertical: 14.h),
            ),
            child: Text(l10n.orderDetailsResubmitButton),
          ),
        ),
      );
    } else if (order.status == OrderStatus.processing) {
      return Container(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _showStagePicker(order.id),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                child: Text(l10n.ordersUpdateStageButton),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _updateStage(order.id, 'PACKED'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: AppColors.white,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                child: Text(l10n.ordersMarkPackedButton),
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  void _showStagePicker(String id) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(l10n.ordersUpdateProcessingStageTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.waves),
                title: Text(l10n.ordersStageWashing),
                onTap: () {
                  Navigator.pop(context);
                  _updateStage(id, 'WASHING');
                },
              ),
              ListTile(
                leading: const Icon(Icons.wb_sunny_outlined),
                title: Text(l10n.ordersStageDrying),
                onTap: () {
                  Navigator.pop(context);
                  _updateStage(id, 'DRYING');
                },
              ),
              ListTile(
                leading: const Icon(Icons.iron_rounded),
                title: Text(l10n.ordersStageIroning),
                onTap: () {
                  Navigator.pop(context);
                  _updateStage(id, 'IRONING');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getStatusColor(OrderStatus status) {
    return switch (status) {
      OrderStatus.waitingForVendorConfirmation => AppColors.warning,
      OrderStatus.vendorAccepted ||
      OrderStatus.pickupAssigned ||
      OrderStatus.goingForPickup ||
      OrderStatus.pickupOtpVerified ||
      OrderStatus.pickedUp =>
        AppColors.primary,
      OrderStatus.receivedAtVendor => Color(0xFF8E2DE2),
      OrderStatus.reconciliationPending => AppColors.warning,
      OrderStatus.reconciliationDisputed => AppColors.error,
      OrderStatus.processing => Color(0xFF4A00E0),
      OrderStatus.packed => AppColors.success,
      OrderStatus.delivered => Colors.green,
      OrderStatus.vendorRejected ||
      OrderStatus.autoRejected ||
      OrderStatus.customerCancelled ||
      OrderStatus.adminCancelled =>
        AppColors.error,
      _ => AppColors.textSecondary,
    };
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

/// A brand-new service added during reconciliation, staged locally until
/// submit — not tied to any existing order line.
class _NewLineDraft {
  _NewLineDraft({required this.option, required this.quantity});
  final ReclassifyOption option;
  final double quantity;
}
