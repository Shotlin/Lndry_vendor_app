import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design/design_system.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../providers/riders_provider.dart';
import '../../../../models/models.dart';

class RiderManagementPage extends ConsumerStatefulWidget {
  const RiderManagementPage({super.key});

  @override
  ConsumerState<RiderManagementPage> createState() => _RiderManagementPageState();
}

class _RiderManagementPageState extends ConsumerState<RiderManagementPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _showAddRiderForm() {
    _nameController.clear();
    _phoneController.clear();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        final l10n = AppLocalizations.of(context);
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
                    l10n.riderManagementAddRiderTitle,
                    style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    l10n.riderManagementAddRiderSubtitle,
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                  SizedBox(height: 16.h),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: l10n.employeesFullNameLabel,
                      hintText: l10n.riderManagementFullNameHint,
                      prefixIcon: const Icon(Icons.person_outline_rounded),
                    ),
                    validator: (value) => value == null || value.isEmpty ? l10n.employeesNameRequired : null,
                  ),
                  SizedBox(height: 12.h),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: l10n.riderManagementPhoneLabel,
                      hintText: l10n.employeesPhoneHint,
                      prefixIcon: const Icon(Icons.phone_android_outlined),
                    ),
                    validator: (value) =>
                        value == null || value.trim().length < 10 ? l10n.riderManagementPhoneInvalid : null,
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton(
                    onPressed: _isSaving ? null : _saveRider,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                    child: _isSaving
                        ? SizedBox(
                            width: 20.r,
                            height: 20.r,
                            child: const CircularProgressIndicator(color: AppColors.white, strokeWidth: 2),
                          )
                        : Text(l10n.riderManagementAddRiderTitle),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveRider() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);
    setState(() => _isSaving = true);
    try {
      await ref.read(ridersListProvider.notifier).addRider(
            name: _nameController.text.trim(),
            phone: _phoneController.text.trim(),
          );
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.riderManagementRiderAddedSnack)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.dashboardActionFailed('$e'))),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _toggleActive(EmployeeModel rider, bool value) async {
    try {
      await ref.read(ridersListProvider.notifier).toggleActive(rider.id, value);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).ordersErrorSnack('$e'))));
      }
    }
  }

  void _showDeleteConfirmDialog(EmployeeModel rider) {
    showDialog<void>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        return AlertDialog(
          title: Text(l10n.riderManagementRemoveRiderTitle),
          content: Text(l10n.riderManagementRemoveConfirm(rider.name)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.commonCancel),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  await ref.read(ridersListProvider.notifier).removeRider(rider.id);
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.dashboardActionFailed('$e'))));
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              child: Text(l10n.employeesConfirmRemoveButton),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ridersAsync = ref.watch(ridersListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? AppColors.white : AppColors.textBlack),
          onPressed: () => context.canPop() ? context.pop() : context.go('/profile'),
        ),
        title: Text(
          l10n.riderManagementPageTitle,
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.white : AppColors.textBlack,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(ridersListProvider.notifier).fetchRiders(),
        color: AppColors.primary,
        child: ridersAsync.when(
          data: (riders) {
            if (riders.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(32.r),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.two_wheeler_outlined, size: 64.r, color: AppColors.textSecondary.withValues(alpha: 0.3)),
                      SizedBox(height: 16.h),
                      Text(
                        l10n.riderManagementEmptyTitle,
                        style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        l10n.riderManagementEmptySubtitle,
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
              itemCount: riders.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (context, idx) {
                final rider = riders[idx];
                return Card(
                  elevation: 0,
                  color: isDark ? AppColors.darkSurface : AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    side: BorderSide(color: AppColors.outline.withValues(alpha: isDark ? 0.05 : 0.2)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12.r),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: AppColors.secondaryLight,
                            child: Icon(Icons.two_wheeler_rounded, color: AppColors.secondary),
                          ),
                          title: Text(
                            rider.name,
                            style: AppTypography.bodyLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.white : AppColors.textBlack,
                            ),
                          ),
                          subtitle: Text(
                            rider.phone ?? '',
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                          ),
                          trailing: Switch(
                            value: rider.isActive,
                            onChanged: (val) => _toggleActive(rider, val),
                            activeColor: AppColors.success,
                          ),
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
                              onPressed: () => _showDeleteConfirmDialog(rider),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text(l10n.riderManagementFailedToLoad('$err'))),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddRiderForm,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
