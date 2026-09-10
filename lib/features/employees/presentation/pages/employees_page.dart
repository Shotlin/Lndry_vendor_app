import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design/design_system.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../providers/employees_provider.dart';
import '../../../../models/models.dart';

class EmployeesPage extends ConsumerStatefulWidget {
  const EmployeesPage({super.key});

  @override
  ConsumerState<EmployeesPage> createState() => _EmployeesPageState();
}

class _EmployeesPageState extends ConsumerState<EmployeesPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'VENDOR_STAFF';
  final List<String> _selectedPermissions = ['orders:read'];
  bool _isSaving = false;

  List<Map<String, String>> _allPermissions(AppLocalizations l10n) => [
        {'value': 'orders:read', 'label': l10n.employeesPermReadOrders},
        {'value': 'orders:write', 'label': l10n.employeesPermProcessOrders},
        {'value': 'catalog:write', 'label': l10n.employeesPermManageCatalog},
        {'value': 'staff:write', 'label': l10n.employeesPermManageEmployees},
      ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showEmployeeForm({EmployeeModel? existing}) {
    if (existing != null) {
      _nameController.text = existing.name;
      _emailController.text = existing.email;
      _phoneController.text = existing.phone ?? '';
      _selectedRole = existing.role;
      _selectedPermissions.clear();
      _selectedPermissions.addAll(existing.permissions);
    } else {
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _selectedRole = 'VENDOR_STAFF';
      _selectedPermissions.clear();
      _selectedPermissions.add('orders:read');
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        return StatefulBuilder(
          builder: (context, setSheetState) {
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
                        existing != null ? l10n.employeesEditStaffTitle : l10n.employeesInviteStaffTitle,
                        style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16.h),

                      TextFormField(
                        controller: _nameController,
                        enabled: existing == null, // Name is fixed on invite
                        decoration: InputDecoration(
                          labelText: l10n.employeesFullNameLabel,
                          hintText: l10n.employeesFullNameHint,
                          prefixIcon: const Icon(Icons.person_outline_rounded),
                        ),
                        validator: (value) => value == null || value.isEmpty ? l10n.employeesNameRequired : null,
                      ),
                      SizedBox(height: 12.h),

                      TextFormField(
                        controller: _emailController,
                        enabled: existing == null, // Email is fixed on invite
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: l10n.employeesEmailLabel,
                          hintText: l10n.employeesEmailHint,
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return l10n.employeesEmailRequired;
                          if (!value.contains('@') || !value.contains('.')) return l10n.employeesEmailInvalid;
                          return null;
                        },
                      ),
                      SizedBox(height: 12.h),

                      if (existing == null) ...[
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: l10n.employeesPhoneOptionalLabel,
                            hintText: l10n.employeesPhoneHint,
                            prefixIcon: const Icon(Icons.phone_android_outlined),
                          ),
                        ),
                        SizedBox(height: 12.h),
                      ],

                      DropdownButtonFormField<String>(
                        value: _selectedRole,
                        decoration: InputDecoration(
                          labelText: l10n.employeesShopRoleLabel,
                          prefixIcon: const Icon(Icons.badge_outlined),
                        ),
                        items: [
                          DropdownMenuItem(value: 'VENDOR_OWNER', child: Text(l10n.employeesRoleOwner)),
                          DropdownMenuItem(value: 'VENDOR_STAFF', child: Text(l10n.employeesRoleStaff)),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setSheetState(() => _selectedRole = val);
                          }
                        },
                      ),
                      SizedBox(height: 16.h),

                      Text(
                        l10n.employeesPermissionsHeader,
                        style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.h),

                      ..._allPermissions(l10n).map((perm) {
                        final val = perm['value']!;
                        final label = perm['label']!;
                        final isChecked = _selectedPermissions.contains(val);
                        return CheckboxListTile(
                          title: Text(label),
                          value: isChecked,
                          activeColor: AppColors.primary,
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (checked) {
                            setSheetState(() {
                              if (checked == true) {
                                if (!_selectedPermissions.contains(val)) {
                                  _selectedPermissions.add(val);
                                }
                              } else {
                                if (_selectedPermissions.length > 1) {
                                  _selectedPermissions.remove(val);
                                }
                              }
                            });
                          },
                        );
                      }),
                      SizedBox(height: 24.h),

                      ElevatedButton(
                        onPressed: _isSaving ? null : () => _saveStaff(existing),
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
                            : Text(existing != null ? l10n.employeesSaveChangesButton : l10n.employeesInviteStaffButton),
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

  Future<void> _saveStaff(EmployeeModel? existing) async {
    if (_formKey.currentState!.validate()) {
      final l10n = AppLocalizations.of(context);
      setState(() => _isSaving = true);
      try {
        final notifier = ref.read(employeesListProvider.notifier);
        if (existing != null) {
          await notifier.updateEmployee(
            existing.id,
            role: _selectedRole,
            permissions: _selectedPermissions,
            isActive: existing.isActive,
          );
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.employeesStaffUpdatedSnack)));
        } else {
          await notifier.addEmployee(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim().isNotEmpty ? _phoneController.text.trim() : null,
            role: _selectedRole,
            permissions: _selectedPermissions,
          );
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.employeesInvitationSentSnack)));
        }
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.dashboardActionFailed('$e'))));
      } finally {
        if (mounted) {
          setState(() => _isSaving = false);
        }
      }
    }
  }

  void _showResetPasswordDialog(EmployeeModel employee) {
    _passwordController.clear();
    showDialog<void>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        return AlertDialog(
          title: Text(l10n.employeesResetPasswordTitle(employee.name)),
          content: TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: l10n.employeesNewPasswordLabel,
              hintText: l10n.employeesNewPasswordHint,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.commonCancel),
            ),
            ElevatedButton(
              onPressed: () async {
                final pass = _passwordController.text.trim();
                if (pass.length < 8) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.employeesPasswordTooShort)));
                  return;
                }
                Navigator.pop(context);
                try {
                  await ref.read(employeesListProvider.notifier).resetPassword(employee.id, pass);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.employeesPasswordUpdatedSnack)));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.employeesResetFailedSnack('$e'))));
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              child: Text(l10n.employeesSavePasswordButton),
            ),
          ],
        );
      },
    );
  }

  Future<void> _toggleStaffActive(EmployeeModel employee, bool val) async {
    try {
      await ref.read(employeesListProvider.notifier).updateEmployee(
        employee.id,
        role: employee.role,
        permissions: employee.permissions,
        isActive: val,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).ordersErrorSnack('$e'))));
    }
  }

  void _showDeleteConfirmDialog(EmployeeModel employee) {
    showDialog<void>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        return AlertDialog(
          title: Text(l10n.employeesRemoveStaffTitle),
          content: Text(l10n.employeesRemoveStaffConfirm(employee.name)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.commonCancel),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  await ref.read(employeesListProvider.notifier).removeEmployee(employee.id);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.employeesStaffRemovedSnack)));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.dashboardActionFailed('$e'))));
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
    final employeesAsync = ref.watch(employeesListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canPop = context.canPop();
    final l10n = AppLocalizations.of(context);

    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.go('/profile');
      },
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : const Color(0xFFF8F9FD),
        appBar: AppBar(
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? AppColors.white : AppColors.textBlack),
            onPressed: () => context.canPop() ? context.pop() : context.go('/profile'),
          ),
        title: Text(
          l10n.employeesPageTitle,
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.white : AppColors.textBlack,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(employeesListProvider.notifier).fetchEmployees(),
        color: AppColors.primary,
        child: employeesAsync.when(
          data: (employees) {
            if (employees.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(32.r),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_outline_rounded, size: 64.r, color: AppColors.textSecondary.withOpacity(0.3)),
                      SizedBox(height: 16.h),
                      Text(
                        l10n.employeesEmptyTitle,
                        style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        l10n.employeesEmptySubtitle,
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
              itemCount: employees.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (context, idx) {
                final emp = employees[idx];
                final roleColor = emp.role == 'VENDOR_OWNER' ? AppColors.primary : AppColors.secondary;

                return Card(
                  elevation: 0,
                  color: isDark ? AppColors.darkSurface : AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    side: BorderSide(
                      color: AppColors.outline.withOpacity(isDark ? 0.05 : 0.2),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12.r),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primaryContainer,
                            child: Text(
                              emp.name.substring(0, 1).toUpperCase(),
                              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(
                                emp.name,
                                style: AppTypography.bodyLarge.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.white : AppColors.textBlack,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: roleColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Text(
                                  emp.role == 'VENDOR_OWNER' ? l10n.employeesOwnerBadge : l10n.employeesStaffBadge,
                                  style: TextStyle(
                                    fontSize: 8.sp,
                                    color: roleColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4.h),
                              Text(emp.email, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                              if (emp.phone != null && emp.phone!.isNotEmpty) ...[
                                SizedBox(height: 2.h),
                                Text(emp.phone!, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                              ],
                            ],
                          ),
                          trailing: Switch(
                            value: emp.isActive,
                            onChanged: (val) => _toggleStaffActive(emp, val),
                            activeColor: AppColors.success,
                          ),
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: () => _showResetPasswordDialog(emp),
                              icon: const Icon(Icons.vpn_key_outlined, size: 16),
                              label: Text(l10n.employeesResetPassButton),
                            ),
                            SizedBox(width: 8.w),
                            TextButton.icon(
                              onPressed: () => _showEmployeeForm(existing: emp),
                              icon: const Icon(Icons.edit_outlined, size: 16),
                              label: Text(l10n.employeesPermissionsButton),
                            ),
                            SizedBox(width: 8.w),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
                              onPressed: () => _showDeleteConfirmDialog(emp),
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
          error: (err, _) => Center(child: Text(l10n.employeesFailedToLoad('$err'))),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEmployeeForm(),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        child: const Icon(Icons.add),
      ),
    ),
  );
}
}
