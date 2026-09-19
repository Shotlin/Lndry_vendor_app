import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design/design_system.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../l10n/permission_labels.dart';
import '../../../../models/models.dart';
import '../../../../providers/access_provider.dart';
import '../../../../providers/employees_provider.dart';
import '../../../../core/network/friendly_error.dart';
import '../../../../core/utils/phone_input.dart';

/// Staff Management — the vendor's STAFF only.
///
/// Staff sign in to the main Partner app and can open only the modules the
/// owner switches on here. Captains (riders) are a different account type with
/// their own screen, Captain Management; the backend list this page reads
/// (`role=VENDOR_STAFF`) never contains them.
class EmployeesPage extends ConsumerStatefulWidget {
  const EmployeesPage({super.key});

  @override
  ConsumerState<EmployeesPage> createState() => _EmployeesPageState();
}

class _EmployeesPageState extends ConsumerState<EmployeesPage> {
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _showEmployeeForm({EmployeeModel? existing}) async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => _StaffFormSheet(existing: existing),
    );
    if (saved == true && mounted) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(existing != null ? l10n.employeesStaffUpdatedSnack : l10n.employeesInvitationSentSnack),
      ));
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
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.employeesResetFailedSnack(friendlyError(e)))));
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).ordersErrorSnack(friendlyError(e)))));
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
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.dashboardActionFailed(friendlyError(e)))));
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

  /// "Orders · Catalogue & pricing" — which modules this staff member can open.
  String _accessSummary(AppLocalizations l10n, PermissionCatalog? catalog, EmployeeModel emp) {
    if (catalog == null) return '';
    final granted = emp.permissions.toSet();
    final names = <String>[
      for (final m in catalog.modules)
        if (m.items.any((i) => i.isGrantedBy(granted))) permissionModuleLabel(l10n, m),
    ];
    return names.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final employeesAsync = ref.watch(employeesListProvider);
    final catalog = ref.watch(permissionCatalogProvider).valueOrNull;
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
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.white,
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
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => ref.read(employeesListProvider.notifier).fetchEmployees(),
            color: AppColors.primary,
            child: employeesAsync.when(
              data: (employees) {
                // Always a scrollable, so pull-to-refresh works on an empty list too.
                if (employees.isEmpty) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(32.r, 96.h, 32.r, 32.r),
                    children: [
                      Icon(Icons.people_outline_rounded, size: 64.r, color: AppColors.textSecondary.withOpacity(0.3)),
                      SizedBox(height: 16.h),
                      Text(
                        l10n.employeesEmptyTitle,
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        l10n.employeesEmptySubtitle,
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        l10n.employeesStaffOnlyNote,
                        textAlign: TextAlign.center,
                        style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  );
                }

                // The bottom padding keeps the last card clear of the
                // floating Add Staff button.
                return ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(16.r, 16.r, 16.r, 96.h),
                  itemCount: employees.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, idx) {
                    final emp = employees[idx];
                    final summary = _accessSummary(l10n, catalog, emp);
                    return Card(
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      color: isDark ? AppColors.darkSurface : AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        side: BorderSide(color: AppColors.outline.withOpacity(isDark ? 0.05 : 0.3)),
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
                                  emp.name.trim().isEmpty ? '?' : emp.name.trim().substring(0, 1).toUpperCase(),
                                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                                ),
                              ),
                              title: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      emp.name,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTypography.bodyLarge.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? AppColors.white : AppColors.textBlack,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                    decoration: BoxDecoration(
                                      color: AppColors.secondary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Text(
                                      l10n.employeesStaffBadge,
                                      style: TextStyle(
                                        fontSize: 8.sp,
                                        color: AppColors.secondary,
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
                                  if (emp.phone != null && emp.phone!.isNotEmpty && !emp.phone!.startsWith('s:')) ...[
                                    SizedBox(height: 2.h),
                                    Text(emp.phone!, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                                  ],
                                  if (summary.isNotEmpty) ...[
                                    SizedBox(height: 6.h),
                                    Text(
                                      summary,
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
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
                            Wrap(
                              alignment: WrapAlignment.end,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 8.w,
                              children: [
                                TextButton.icon(
                                  onPressed: () => _showResetPasswordDialog(emp),
                                  icon: const Icon(Icons.vpn_key_outlined, size: 16),
                                  label: Text(l10n.employeesResetPassButton),
                                ),
                                TextButton.icon(
                                  onPressed: () => _showEmployeeForm(existing: emp),
                                  icon: const Icon(Icons.edit_outlined, size: 16),
                                  label: Text(l10n.employeesPermissionsButton),
                                ),
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
              error: (err, _) => ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(32.r),
                children: [
                  SizedBox(height: 96.h),
                  Text(l10n.employeesFailedToLoad(friendlyError(err)), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showEmployeeForm(),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          icon: const Icon(Icons.add),
          label: Text(l10n.employeesAddStaffButton),
        ),
      ),
    );
  }
}

/// The invite / edit form for one staff member, including the permission
/// switches. A widget of its own (not an inline builder) so it can watch the
/// backend permission catalog and rebuild when it arrives.
class _StaffFormSheet extends ConsumerStatefulWidget {
  const _StaffFormSheet({this.existing});

  final EmployeeModel? existing;

  @override
  ConsumerState<_StaffFormSheet> createState() => _StaffFormSheetState();
}

class _StaffFormSheetState extends ConsumerState<_StaffFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _phone;

  /// The backend permission strings currently switched on. Starts from what
  /// the staff member already has, so nothing they hold is silently dropped.
  late final Set<String> _granted;
  bool _seededDefault = false;
  bool _isSaving = false;
  bool _showPermissionError = false;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _name = TextEditingController(text: e?.name ?? '');
    _email = TextEditingController(text: e?.email ?? '');
    _phone = TextEditingController(text: e?.phone ?? '');
    _granted = {...?e?.permissions};
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  /// A new staff member starts able to view orders, the first item of the
  /// first module — the same starting point the old form had.
  void _seedDefault(PermissionCatalog catalog) {
    if (_seededDefault || _isEdit) return;
    _seededDefault = true;
    if (catalog.modules.isNotEmpty && catalog.modules.first.items.isNotEmpty) {
      _granted.addAll(catalog.modules.first.items.first.permissions);
    }
  }

  /// Switches one item. Within a module the first item is its "view" base:
  /// turning on anything stronger turns the view on too, and turning the
  /// view off turns the whole module off. (The backend applies the same rule
  /// when it saves, so what's shown here is what is stored.)
  void _toggle(PermissionModule module, PermissionItem item, bool on) {
    setState(() {
      _showPermissionError = false;
      final base = module.items.first;
      if (on) {
        _granted.addAll(item.permissions);
        _granted.addAll(base.permissions);
      } else if (identical(item, base)) {
        for (final i in module.items) {
          _granted.removeAll(i.permissions);
        }
      } else {
        _granted.removeAll(item.permissions);
      }
    });
  }

  String _normalizedPhone() {
    final digits = _phone.text.replaceAll(RegExp(r'\D'), '');
    return digits.length > 10 ? digits.substring(digits.length - 10) : digits;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_granted.isEmpty) {
      setState(() => _showPermissionError = true);
      return;
    }
    final l10n = AppLocalizations.of(context);
    setState(() => _isSaving = true);
    try {
      final notifier = ref.read(employeesListProvider.notifier);
      final existing = widget.existing;
      if (existing != null) {
        await notifier.updateEmployee(
          existing.id,
          role: existing.role,
          permissions: _granted.toList(),
          isActive: existing.isActive,
        );
      } else {
        await notifier.addEmployee(
          name: _name.text.trim(),
          email: _email.text.trim(),
          phone: _normalizedPhone(),
          // Staff only. Captains are added under Captain Management.
          role: 'VENDOR_STAFF',
          permissions: _granted.toList(),
        );
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.dashboardActionFailed(friendlyError(e)))));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final catalogAsync = ref.watch(permissionCatalogProvider);

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
                _isEdit ? l10n.employeesEditStaffTitle : l10n.employeesInviteStaffTitle,
                style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.bold),
              ),
              if (!_isEdit) ...[
                SizedBox(height: 4.h),
                Text(
                  l10n.employeesStaffOnlyNote,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
              ],
              SizedBox(height: 16.h),
              TextFormField(
                controller: _name,
                enabled: !_isEdit, // fixed once invited
                decoration: InputDecoration(
                  labelText: l10n.employeesFullNameLabel,
                  hintText: l10n.employeesFullNameHint,
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                ),
                validator: (value) => value == null || value.trim().isEmpty ? l10n.employeesNameRequired : null,
              ),
              SizedBox(height: 12.h),
              TextFormField(
                controller: _email,
                enabled: !_isEdit,
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
              if (!_isEdit) ...[
                // Staff sign in to the Partner app with a phone OTP, so a phone
                // number is required — without one the account could never log in.
                TextFormField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  inputFormatters: const [TenDigitPhoneFormatter()],
                  maxLength: 10,
                  decoration: InputDecoration(
                    counterText: '',
                    labelText: l10n.employeesPhoneRequiredLabel,
                    hintText: l10n.employeesPhoneHint,
                    prefixIcon: const Icon(Icons.phone_android_outlined),
                  ),
                  validator: (value) =>
                      isValidTenDigitPhone(value) ? null : l10n.employeesPhoneRequiredError,
                ),
                SizedBox(height: 12.h),
              ],
              SizedBox(height: 4.h),
              Text(
                l10n.employeesPermissionsHeader,
                style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.h),
              Text(
                l10n.employeesPermissionsHint,
                style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
              SizedBox(height: 8.h),
              catalogAsync.when(
                loading: () => Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  child: const Center(child: CircularProgressIndicator()),
                ),
                error: (_, __) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Column(
                    children: [
                      Text(l10n.employeesPermissionsLoadFailed),
                      TextButton(
                        onPressed: () => ref.invalidate(permissionCatalogProvider),
                        child: Text(l10n.commonRetry),
                      ),
                    ],
                  ),
                ),
                data: (catalog) {
                  _seedDefault(catalog);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final module in catalog.modules)
                        if (module.items.isNotEmpty) ...[
                          Padding(
                            padding: EdgeInsets.only(top: 8.h, bottom: 2.h),
                            child: Text(
                              permissionModuleLabel(l10n, module).toUpperCase(),
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                          for (final item in module.items)
                            SwitchListTile.adaptive(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              activeColor: AppColors.primary,
                              title: Text(permissionItemLabel(l10n, item)),
                              value: item.isGrantedBy(_granted),
                              onChanged: (on) => _toggle(module, item, on),
                            ),
                        ],
                    ],
                  );
                },
              ),
              if (_showPermissionError)
                Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Text(
                    l10n.employeesPermissionsRequired,
                    style: AppTypography.bodySmall.copyWith(color: AppColors.error),
                  ),
                ),
              SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: _isSaving || catalogAsync.isLoading ? null : _save,
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
                    : Text(_isEdit ? l10n.employeesSaveChangesButton : l10n.employeesInviteStaffButton),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
