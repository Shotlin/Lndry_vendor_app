import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design/design_system.dart';
import '../../../../core/network/friendly_error.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../models/models.dart';
import '../../../../providers/access_provider.dart';
import '../../../../providers/inventory_provider.dart';

class InventoryPage extends ConsumerStatefulWidget {
  const InventoryPage({super.key});

  @override
  ConsumerState<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends ConsumerState<InventoryPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _qtyController = TextEditingController();
  final _thresholdController = TextEditingController();
  final _unitController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _qtyController.dispose();
    _thresholdController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  void _showAddItemDialog() {
    _nameController.clear();
    _qtyController.clear();
    _thresholdController.clear();
    _unitController.text = 'Pieces';
    final l10n = AppLocalizations.of(context);

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.inventoryAddSupplyItemTitle),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                        labelText: l10n.inventoryItemNameLabel,
                        hintText: l10n.inventoryItemNameHint),
                    validator: (value) => value == null || value.isEmpty
                        ? l10n.inventoryRequiredField
                        : null,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _qtyController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: l10n.inventoryInitialQtyLabel),
                          validator: (value) =>
                              int.tryParse(value?.trim() ?? '') == null
                                  ? l10n.inventoryRequiredField
                                  : null,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: TextFormField(
                          controller: _thresholdController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: l10n.inventoryMinLimitLabel),
                          validator: (value) =>
                              int.tryParse(value?.trim() ?? '') == null
                                  ? l10n.inventoryRequiredField
                                  : null,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  TextFormField(
                    controller: _unitController,
                    decoration: InputDecoration(
                        labelText: l10n.inventoryUnitLabel,
                        hintText: l10n.inventoryUnitHint),
                    validator: (value) => value == null || value.isEmpty
                        ? l10n.inventoryRequiredField
                        : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.commonCancel),
            ),
            ElevatedButton(
              onPressed: _saveItem,
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white),
              child: Text(l10n.inventoryAddItemButton),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      // Only reported as added once the server has saved it.
      await ref.read(inventoryProvider.notifier).create(
            name: _nameController.text.trim(),
            quantity: int.parse(_qtyController.text.trim()),
            minThreshold: int.parse(_thresholdController.text.trim()),
            unit: _unitController.text.trim(),
          );
      navigator.pop();
      messenger
          .showSnackBar(SnackBar(content: Text(l10n.inventoryItemAddedSnack)));
    } catch (e) {
      messenger.showSnackBar(SnackBar(
          content: Text(l10n.dashboardActionFailed(friendlyError(e)))));
    }
  }

  Future<void> _adjustQty(InventoryItem item, int change) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(inventoryProvider.notifier).adjust(item.id, change);
    } catch (e) {
      messenger.showSnackBar(SnackBar(
          content: Text(l10n.dashboardActionFailed(friendlyError(e)))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inventoryAsync = ref.watch(inventoryProvider);
    final items = inventoryAsync.valueOrNull ?? const <InventoryItem>[];
    final lowStockItems = items.where((i) => i.isLowStock).toList();
    // Staff who may only view can see quantities but not change them.
    final canManage = ref.watch(myAccessProvider).can('inventory.manage');
    final canPop = context.canPop();
    final l10n = AppLocalizations.of(context);

    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.go('/profile');
      },
      child: Scaffold(
        backgroundColor:
            isDark ? AppColors.darkBackground : const Color(0xFFF8F9FD),
        appBar: AppBar(
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: isDark ? AppColors.white : AppColors.textBlack),
            onPressed: () =>
                context.canPop() ? context.pop() : context.go('/profile'),
          ),
          title: Text(
            l10n.inventoryPageTitle,
            style: AppTypography.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.white : AppColors.textBlack,
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Low Stock Alerts summary Banner
            if (lowStockItems.isNotEmpty) ...[
              Container(
                margin: EdgeInsets.all(16.r),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: AppColors.error.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: AppColors.error, size: 24.r),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.inventoryLowStockWarningTitle,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.error,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            l10n.inventoryLowStockWarningBody(
                                lowStockItems.length),
                            style: AppTypography.bodySmall
                                .copyWith(color: AppColors.error),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            Expanded(
              child: inventoryAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.r),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(l10n.inventoryLoadFailed,
                            style: AppTypography.bodyLarge
                                .copyWith(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8.h),
                        Text(friendlyError(err),
                            textAlign: TextAlign.center,
                            style: AppTypography.bodySmall
                                .copyWith(color: AppColors.textSecondary)),
                        SizedBox(height: 12.h),
                        TextButton(
                          onPressed: () =>
                              ref.read(inventoryProvider.notifier).fetch(),
                          child: Text(l10n.commonRetry),
                        ),
                      ],
                    ),
                  ),
                ),
                data: (_) => items.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.r),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(l10n.inventoryEmptyTitle,
                                  style: AppTypography.bodyLarge
                                      .copyWith(fontWeight: FontWeight.bold)),
                              SizedBox(height: 8.h),
                              Text(l10n.inventoryEmptySubtitle,
                                  textAlign: TextAlign.center,
                                  style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () =>
                            ref.read(inventoryProvider.notifier).fetch(),
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.all(16.r),
                          itemCount: items.length,
                          separatorBuilder: (_, __) => SizedBox(height: 12.h),
                          itemBuilder: (context, idx) {
                            final item = items[idx];
                            final isLowStock =
                                item.quantity <= item.minThreshold;
                            final statusColor = isLowStock
                                ? (item.quantity == 0
                                    ? AppColors.error
                                    : AppColors.warning)
                                : AppColors.success;

                            return Card(
                              elevation: 0,
                              color: isDark
                                  ? AppColors.darkSurface
                                  : AppColors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                                side: BorderSide(
                                  color: AppColors.outline
                                      .withOpacity(isDark ? 0.05 : 0.2),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16.r),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                item.name,
                                                style: AppTypography.bodyLarge
                                                    .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: isDark
                                                      ? AppColors.white
                                                      : AppColors.textBlack,
                                                ),
                                              ),
                                              if (isLowStock) ...[
                                                SizedBox(width: 8.w),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 6.w,
                                                      vertical: 2.h),
                                                  decoration: BoxDecoration(
                                                    color: statusColor
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
                                                  ),
                                                  child: Text(
                                                    item.quantity == 0
                                                        ? l10n.inventoryOutBadge
                                                        : l10n
                                                            .inventoryLowBadge,
                                                    style: TextStyle(
                                                      fontSize: 9.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: statusColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            l10n.inventoryQuantityOfThreshold(
                                                '${item.quantity}',
                                                '${item.minThreshold}',
                                                item.unit),
                                            style: AppTypography.bodySmall
                                                .copyWith(
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Increment/Decrement Counters
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons
                                              .remove_circle_outline_rounded),
                                          onPressed: canManage
                                              ? () => _adjustQty(item, -1)
                                              : null,
                                        ),
                                        Container(
                                          constraints:
                                              BoxConstraints(minWidth: 32.w),
                                          alignment: Alignment.center,
                                          child: Text(
                                            '${item.quantity}',
                                            style: AppTypography.bodyLarge
                                                .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: isDark
                                                  ? AppColors.white
                                                  : AppColors.textBlack,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                              Icons.add_circle_outline_rounded,
                                              color: AppColors.primary),
                                          onPressed: canManage
                                              ? () => _adjustQty(item, 1)
                                              : null,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ),
          ],
        ),
        floatingActionButton: canManage
            ? FloatingActionButton(
                onPressed: _showAddItemDialog,
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                child: const Icon(Icons.add),
              )
            : null,
      ),
    );
  }
}
