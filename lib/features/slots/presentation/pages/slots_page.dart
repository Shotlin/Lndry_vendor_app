import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design/design_system.dart';
import '../../../../l10n/days_of_week_l10n.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../providers/slots_provider.dart';
import '../../../../repositories/repositories.dart';
import '../../../../models/models.dart';

class SlotsPage extends ConsumerStatefulWidget {
  const SlotsPage({super.key});

  @override
  ConsumerState<SlotsPage> createState() => _SlotsPageState();
}

int _timeToMinutes(String timeStr) {
  final parts = timeStr.split(':');
  if (parts.length < 2) return 0;
  final hours = int.tryParse(parts[0]) ?? 0;
  final minutes = int.tryParse(parts[1]) ?? 0;
  return hours * 60 + minutes;
}

/// Parses "HH:mm" or "HH:mm:ss" into a TimeOfDay, or null if unparsable.
TimeOfDay? _parseTimeOfDay(String text) {
  final parts = text.split(':');
  if (parts.length < 2) return null;
  final h = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  if (h == null || m == null) return null;
  return TimeOfDay(hour: h, minute: m);
}

class _SlotsPageState extends ConsumerState<SlotsPage> {
  final _capacityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isUpdatingCapacity = false;

  @override
  void dispose() {
    _capacityController.dispose();
    super.dispose();
  }

  Future<void> _updateCapacity() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isUpdatingCapacity = true);
      final l10n = AppLocalizations.of(context);
      try {
        final limit = int.parse(_capacityController.text);
        final repo = ref.read(vendorRepositoryProvider);
        await repo.requestCapacityChange(limit);
        ref.invalidate(dailyCapacityProvider);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.slotsCapacityRequestedSnack)),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.slotsFailedToUpdateCapacity('$e'))),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isUpdatingCapacity = false);
        }
      }
    }
  }

  void _showAddOrEditSlotSheet({PickupSlotModel? existingSlot}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      // A fresh widget (and fresh controllers) per open — the previous
      // implementation kept Start/End/MaxOrders/Day as _SlotsPageState
      // fields shared across every sheet open, so any interrupted attempt
      // (a picker dismissed mid-way, a stray tap) left stale values behind
      // that silently resurfaced as if pre-filled the next time "Add" was
      // tapped, occasionally outside operational hours entirely.
      builder: (context) => _AddEditSlotSheet(existingSlot: existingSlot),
    );
  }

  Future<void> _toggleSlot(PickupSlotModel slot, bool isActive) async {
    try {
      await ref.read(slotsListProvider.notifier).toggleSlot(slot.id, isActive);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).slotsFailedGeneric('$e'))));
      }
    }
  }

  Future<void> _deleteSlot(String id) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ref.read(slotsListProvider.notifier).removeSlot(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.slotsSlotDeletedSnack)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.slotsFailedGeneric('$e'))));
      }
    }
  }

  Future<void> _selectWorkingHoursTime(BuildContext context, int day, bool isOpenTime) async {
    final current = ref.read(workingHoursProvider).value?[day];
    final existing = isOpenTime ? (current?['openTime'] as String?) : (current?['closeTime'] as String?);
    final initial = (existing != null ? _parseTimeOfDay(existing) : null) ??
        (isOpenTime ? const TimeOfDay(hour: 8, minute: 0) : const TimeOfDay(hour: 20, minute: 0));
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
    );
    if (picked != null) {
      final hh = picked.hour.toString().padLeft(2, '0');
      final mm = picked.minute.toString().padLeft(2, '0');
      final timeStr = '$hh:$mm';
      
      final current = ref.read(workingHoursProvider).value?[day];
      if (current != null) {
        final openVal = isOpenTime ? timeStr : (current['openTime'] as String? ?? '08:00');
        final closeVal = isOpenTime ? (current['closeTime'] as String? ?? '20:00') : timeStr;
        final isOpen = current['isOpen'] as bool? ?? false;
        
        if (_timeToMinutes(closeVal) <= _timeToMinutes(openVal)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context).slotsClosingAfterOpening), backgroundColor: AppColors.error),
          );
          return;
        }

        await ref.read(workingHoursProvider.notifier).updateHours(
          day,
          isOpen: isOpen,
          openTime: openVal,
          closeTime: closeVal,
        );
      }
    }
  }

  Future<void> _toggleWorkingDay(int day, bool val) async {
    final current = ref.read(workingHoursProvider).value?[day];
    if (current != null) {
      await ref.read(workingHoursProvider.notifier).updateHours(
        day,
        isOpen: val,
        openTime: current['openTime'] as String? ?? '08:00',
        closeTime: current['closeTime'] as String? ?? '20:00',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final capacityAsync = ref.watch(dailyCapacityProvider);
    final slotsAsync = ref.watch(slotsListProvider);
    final workingHoursAsync = ref.watch(workingHoursProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final daysOfWeek = daysOfWeekLabels(l10n);

    final canPop = context.canPop();
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.go(AppRoutes.dashboard);
      },
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : const Color(0xFFF8F9FD),
        appBar: AppBar(
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? AppColors.white : AppColors.textBlack),
            onPressed: () => context.canPop() ? context.pop() : context.go(AppRoutes.dashboard),
          ),
          title: Text(
            l10n.slotsPageTitle,
            style: AppTypography.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.white : AppColors.textBlack,
            ),
          ),
        ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(dailyCapacityProvider);
          ref.invalidate(slotsListProvider);
          ref.invalidate(workingHoursProvider);
        },
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Working Hours Configuration Section (Issue 1 & 10) ──────────
              Text(l10n.slotsOperationalWorkingHours, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: AppColors.outline.withValues(alpha: 0.1)),
                ),
                child: workingHoursAsync.when(
                  data: (hoursMap) => ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 7,
                    separatorBuilder: (_, __) => Divider(height: 1, color: AppColors.outline.withValues(alpha: 0.1)),
                    itemBuilder: (ctx, idx) {
                      final dayData = hoursMap[idx] ?? {'isOpen': true, 'openTime': '08:00', 'closeTime': '20:00'};
                      final isOpen = dayData['isOpen'] as bool? ?? false;
                      final openTime = dayData['openTime'] as String? ?? '08:00';
                      final closeTime = dayData['closeTime'] as String? ?? '20:00';

                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90.w,
                              child: Text(daysOfWeek[idx], style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                            ),
                            Switch(
                              value: isOpen,
                              onChanged: (val) => _toggleWorkingDay(idx, val),
                              activeColor: AppColors.success,
                            ),
                            if (isOpen) ...[
                              InkWell(
                                onTap: () => _selectWorkingHoursTime(context, idx, true),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.outline.withValues(alpha: 0.2)),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Text(openTime, style: AppTypography.bodySmall),
                                ),
                              ),
                              Text(l10n.slotsToLabel, style: AppTypography.bodySmall),
                              InkWell(
                                onTap: () => _selectWorkingHoursTime(context, idx, false),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.outline.withValues(alpha: 0.2)),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Text(closeTime, style: AppTypography.bodySmall),
                                ),
                              ),
                            ] else
                              Expanded(
                                child: Center(
                                  child: Text(l10n.slotsClosedLabel, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Center(child: Text(l10n.slotsErrorGeneric('$err'))),
                ),
              ),
              SizedBox(height: 24.h),

              // ── Daily capacity limit settings card ──────────────────────────
              Text(l10n.slotsDailyCapacityLimit, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: AppColors.outline.withValues(alpha: 0.1)),
                ),
                child: capacityAsync.when(
                  data: (cap) {
                    final pending = cap['pending_capacity_request'] as Map<String, dynamic>?;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (pending != null) ...[
                          Container(
                            padding: EdgeInsets.all(10.r),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(color: AppColors.warning.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.hourglass_top_rounded, size: 16.r, color: AppColors.warning),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    l10n.slotsPendingRequestNotice('${pending['requested_daily_limit']}'),
                                    style: AppTypography.bodySmall.copyWith(color: AppColors.warning),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12.h),
                        ],
                        Form(
                          key: _formKey,
                          child: Row(
                            children: [
                              Expanded(
                                child: Builder(builder: (context) {
                                  // Backend returns this under `daily_limit` —
                                  // the other two keys were never actually
                                  // present, so this always silently fell back
                                  // to 20 regardless of what was saved.
                                  final maxOrders = cap['daily_limit'] ?? cap['max_orders_per_day'] ?? cap['maxOrdersPerDay'] ?? 20;
                                  if (_capacityController.text.isEmpty) {
                                    _capacityController.text = maxOrders.toString();
                                  }
                                  return TextFormField(
                                    controller: _capacityController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: l10n.slotsMaxOrdersPerDayLabel,
                                      hintText: l10n.slotsMaxOrdersHint,
                                      prefixIcon: const Icon(Icons.dashboard_customize_rounded),
                                    ),
                                    validator: (value) => value == null || value.isEmpty ? l10n.slotsRequiredField : null,
                                  );
                                }),
                              ),
                              SizedBox(width: 16.w),
                              ElevatedButton(
                                onPressed: _isUpdatingCapacity ? null : _updateCapacity,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(80, 48),
                                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                                ),
                                child: _isUpdatingCapacity
                                    ? SizedBox(
                                        width: 16.r,
                                        height: 16.r,
                                        child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 1.5),
                                      )
                                    : Text(pending != null ? l10n.slotsUpdateRequestButton : l10n.slotsUpdateButton),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.slotsErrorLoading('$err'), style: AppTypography.bodySmall.copyWith(color: AppColors.error)),
                      TextButton(
                        onPressed: () => ref.invalidate(dailyCapacityProvider),
                        child: Text(l10n.commonRetry),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // ── Pickup Slots Schedule List ──────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.slotsWeeklySlotsSchedule, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary),
                    onPressed: () => _showAddOrEditSlotSheet(),
                  ),
                ],
              ),
              SizedBox(height: 8.h),

              slotsAsync.when(
                data: (slots) {
                  if (slots.isEmpty) {
                    return Container(
                      padding: EdgeInsets.all(32.r),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : AppColors.white,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Center(
                        child: Text(l10n.slotsNoCustomSlots),
                      ),
                    );
                  }

                  slots.sort((a, b) {
                    final dayCompare = a.dayOfWeek.compareTo(b.dayOfWeek);
                    if (dayCompare != 0) return dayCompare;
                    return a.startTime.compareTo(b.startTime);
                  });

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: slots.length,
                    separatorBuilder: (_, __) => SizedBox(height: 10.h),
                    itemBuilder: (context, index) {
                      final slot = slots[index];
                      return Card(
                        elevation: 0,
                        color: isDark ? AppColors.darkSurface : AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          side: BorderSide(color: AppColors.outline.withValues(alpha: isDark ? 0.05 : 0.2)),
                        ),
                        child: ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  daysOfWeek[slot.dayOfWeek],
                                  style: AppTypography.bodyLarge.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? AppColors.white : AppColors.textBlack,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryContainer,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Text(
                                  l10n.slotsMaxOrdersBadge('${slot.maxOrders}'),
                                  style: AppTypography.bodySmall.copyWith(
                                    fontSize: 9.sp,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text('${slot.startTime.substring(0, 5)} - ${slot.endTime.substring(0, 5)}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Switch(
                                value: slot.isActive,
                                onChanged: (val) => _toggleSlot(slot, val),
                                activeColor: AppColors.success,
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
                                onPressed: () => _showAddOrEditSlotSheet(existingSlot: slot),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
                                onPressed: () => _deleteSlot(slot.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    children: [
                      Text(l10n.slotsErrorGeneric('$err')),
                      TextButton(
                        onPressed: () => ref.invalidate(slotsListProvider),
                        child: Text(l10n.commonRetry),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}

/// Add/Edit form for a single pickup time slot. Deliberately its own
/// StatefulWidget (rather than a StatefulBuilder inline in the parent) so
/// every open gets brand-new controllers — no state can leak in from a
/// previous attempt.
class _AddEditSlotSheet extends ConsumerStatefulWidget {
  const _AddEditSlotSheet({this.existingSlot});

  final PickupSlotModel? existingSlot;

  @override
  ConsumerState<_AddEditSlotSheet> createState() => _AddEditSlotSheetState();
}

class _AddEditSlotSheetState extends ConsumerState<_AddEditSlotSheet> {
  final _slotFormKey = GlobalKey<FormState>();
  late final _startController =
      TextEditingController(text: widget.existingSlot?.startTime);
  late final _endController =
      TextEditingController(text: widget.existingSlot?.endTime);
  late final _maxOrdersController = TextEditingController(
    text: (widget.existingSlot?.maxOrders ?? 5).toString(),
  );
  late int _selectedDay = widget.existingSlot?.dayOfWeek ?? 1; // 1 = Monday
  bool _isSavingSlot = false;

  bool get _isEdit => widget.existingSlot != null;

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    _maxOrdersController.dispose();
    super.dispose();
  }

  /// Opens the time picker defaulting to whatever's already in the field,
  /// falling back to [defaultTime] — never the device's current clock time,
  /// which is how Start/End used to default to whatever moment you happened
  /// to tap each field and frequently produced an invalid pair.
  Future<void> _selectTime(
    TextEditingController controller, {
    required TimeOfDay defaultTime,
  }) async {
    final initial = _parseTimeOfDay(controller.text) ?? defaultTime;
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
    );
    if (picked != null && mounted) {
      final hh = picked.hour.toString().padLeft(2, '0');
      final mm = picked.minute.toString().padLeft(2, '0');
      setState(() => controller.text = '$hh:$mm:00');
    }
  }

  Future<void> _saveSlot() async {
    if (!_slotFormKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context);
    setState(() => _isSavingSlot = true);
    try {
      final startMin = _timeToMinutes(_startController.text);
      final endMin = _timeToMinutes(_endController.text);

      // 1. Validate closing time is after opening time
      if (endMin <= startMin) {
        throw l10n.slotsClosingAfterOpening;
      }

      // 2. Validate slot stays inside working hours
      final workingHours = ref.read(workingHoursProvider).value;
      if (workingHours != null) {
        final dayHours = workingHours[_selectedDay];
        if (dayHours != null) {
          final dayOpen = dayHours['isOpen'] as bool? ?? false;
          if (!dayOpen) {
            throw l10n.slotsDayClosedError;
          }
          final openLimit = _timeToMinutes(dayHours['openTime'] as String? ?? '08:00');
          final closeLimit = _timeToMinutes(dayHours['closeTime'] as String? ?? '20:00');
          if (startMin < openLimit || endMin > closeLimit) {
            throw l10n.slotsOutsideWorkingHoursError('${dayHours['openTime']}', '${dayHours['closeTime']}');
          }
        }
      }

      // 3. Validate no overlapping slots for the same day
      final allSlots = ref.read(slotsListProvider).value ?? [];
      final existingSlot = widget.existingSlot;
      for (final s in allSlots) {
        if (existingSlot != null && s.id == existingSlot.id) continue;
        if (s.dayOfWeek == _selectedDay && s.isActive) {
          final sMin = _timeToMinutes(s.startTime);
          final eMin = _timeToMinutes(s.endTime);
          if (startMin < eMin && endMin > sMin) {
            throw l10n.slotsOverlapError(
              s.startTime.substring(0, 5),
              s.endTime.substring(0, 5),
              daysOfWeekLabels(l10n)[_selectedDay],
            );
          }
        }
      }

      final maxOrders = int.parse(_maxOrdersController.text);
      final repo = ref.read(vendorRepositoryProvider);

      if (existingSlot != null) {
        await repo.deletePickupSlot(existingSlot.id);
      }

      await ref.read(slotsListProvider.notifier).addSlot(
            dayOfWeek: _selectedDay,
            startTime: _startController.text,
            endTime: _endController.text,
            maxOrders: maxOrders,
          );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_isEdit ? l10n.slotsSlotUpdatedSnack : l10n.slotsPickupSlotAddedSnack)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.slotsErrorGeneric('$e')), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isSavingSlot = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final daysOfWeek = daysOfWeekLabels(l10n);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20.w,
        right: 20.w,
        top: 24.h,
      ),
      child: Form(
        key: _slotFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _isEdit ? l10n.slotsEditPickupTimeSlotTitle : l10n.slotsAddPickupTimeSlotTitle,
              style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),

            // Day of Week Selection
            DropdownButtonFormField<int>(
              value: _selectedDay,
              decoration: InputDecoration(
                labelText: l10n.slotsDayOfWeekLabel,
                prefixIcon: const Icon(Icons.calendar_today_rounded),
              ),
              items: List.generate(7, (idx) {
                return DropdownMenuItem(
                  value: idx,
                  child: Text(daysOfWeek[idx]),
                );
              }),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedDay = val);
                }
              },
            ),
            SizedBox(height: 12.h),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _startController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: l10n.slotsStartTimeLabel,
                      hintText: l10n.slotsStartTimeHint,
                      prefixIcon: const Icon(Icons.alarm_rounded),
                    ),
                    onTap: () => _selectTime(_startController, defaultTime: const TimeOfDay(hour: 9, minute: 0)),
                    validator: (value) => value == null || value.isEmpty ? l10n.slotsRequiredField : null,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: TextFormField(
                    controller: _endController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: l10n.slotsEndTimeLabel,
                      hintText: l10n.slotsEndTimeHint,
                      prefixIcon: const Icon(Icons.alarm_on_rounded),
                    ),
                    onTap: () {
                      final start = _parseTimeOfDay(_startController.text);
                      final fallback = start != null
                          ? TimeOfDay(hour: (start.hour + 2).clamp(0, 23), minute: start.minute)
                          : const TimeOfDay(hour: 11, minute: 0);
                      _selectTime(_endController, defaultTime: fallback);
                    },
                    validator: (value) => value == null || value.isEmpty ? l10n.slotsRequiredField : null,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            TextFormField(
              controller: _maxOrdersController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.slotsMaxOrdersLimitLabel,
                hintText: l10n.slotsMaxOrdersLimitHint,
                prefixIcon: const Icon(Icons.filter_9_plus_rounded),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return l10n.slotsRequiredField;
                if (int.tryParse(value) == null) return l10n.slotsInvalidNumber;
                return null;
              },
            ),
            SizedBox(height: 24.h),

            ElevatedButton(
              onPressed: _isSavingSlot ? null : _saveSlot,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: EdgeInsets.symmetric(vertical: 14.h),
              ),
              child: _isSavingSlot
                  ? SizedBox(
                      width: 20.r,
                      height: 20.r,
                      child: const CircularProgressIndicator(color: AppColors.white, strokeWidth: 2),
                    )
                  : Text(_isEdit ? l10n.slotsUpdateSlotButton : l10n.slotsSaveSlotButton),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
