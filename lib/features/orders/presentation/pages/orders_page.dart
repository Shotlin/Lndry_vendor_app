import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design/design_system.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../l10n/order_status_l10n.dart';
import '../../../../providers/orders_provider.dart';
import '../../../../models/models.dart';

class OrdersPage extends ConsumerStatefulWidget {
  const OrdersPage({super.key});

  @override
  ConsumerState<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends ConsumerState<OrdersPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final initialTab = ref.read(selectedOrdersTabProvider);
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: initialTab,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshOrders() async {
    ref.read(ordersListProvider.notifier).fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(selectedOrdersTabProvider, (previous, next) {
      if (next != null && next != _tabController.index) {
        _tabController.animateTo(next);
      }
    });

    final ordersAsync = ref.watch(ordersListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.white,
        elevation: 0,
        title: Text(
          l10n.ordersPageTitle,
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.white : AppColors.textBlack,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3.h,
          tabs: [
            Tab(text: l10n.ordersTabPending),
            Tab(text: l10n.ordersTabActive),
            Tab(text: l10n.ordersTabReady),
            Tab(text: l10n.ordersTabHistory),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshOrders,
        color: AppColors.primary,
        child: ordersAsync.when(
          data: (paginatedResponse) {
            final orders = paginatedResponse.items;

            return TabBarView(
              controller: _tabController,
              children: [
                _buildOrderList(
                  orders.where((o) => o.status == OrderStatus.waitingForVendorConfirmation).toList(),
                  l10n.ordersEmptyPendingTitle,
                  l10n.ordersEmptyPendingSubtitle,
                ),
                _buildOrderList(
                  orders.where((o) => [
                    OrderStatus.vendorAccepted,
                    OrderStatus.pickupAssigned,
                    OrderStatus.goingForPickup,
                    OrderStatus.pickupOtpVerified,
                    OrderStatus.pickedUp,
                    OrderStatus.receivedAtVendor,
                    OrderStatus.reconciliationPending,
                    OrderStatus.reconciliationDisputed,
                    OrderStatus.processing,
                  ].contains(o.status)).toList(),
                  l10n.ordersEmptyActiveTitle,
                  l10n.ordersEmptyActiveSubtitle,
                ),
                _buildOrderList(
                  orders.where((o) => [
                    OrderStatus.packed,
                    OrderStatus.deliveryAssigned,
                    OrderStatus.outForDelivery,
                  ].contains(o.status)).toList(),
                  l10n.ordersEmptyReadyTitle,
                  l10n.ordersEmptyReadySubtitle,
                ),
                _buildOrderList(
                  orders.where((o) => [
                    OrderStatus.delivered,
                    OrderStatus.deliveryOtpVerified,
                    OrderStatus.vendorRejected,
                    OrderStatus.autoRejected,
                    OrderStatus.customerCancelled,
                    OrderStatus.adminCancelled,
                    OrderStatus.refunded,
                  ].contains(o.status)).toList(),
                  l10n.ordersEmptyHistoryTitle,
                  l10n.ordersEmptyHistorySubtitle,
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, st) => Center(
            child: Padding(
              padding: EdgeInsets.all(24.r),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline_rounded, size: 64.r, color: AppColors.error),
                  SizedBox(height: 16.h),
                  Text(
                    l10n.dashboardFailedLoadOrders,
                    style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    err.toString(),
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: _refreshOrders,
                    child: Text(l10n.commonRetry),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderList(List<OrderModel> list, String emptyTitle, String emptySubtitle) {
    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.assignment_turned_in_rounded,
                size: 64.r,
                color: AppColors.textSecondary.withOpacity(0.3),
              ),
              SizedBox(height: 16.h),
              Text(
                emptyTitle,
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                emptySubtitle,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(16.r),
      itemCount: list.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final order = list[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final statusColor = _getStatusColor(order.status);

    return Card(
      elevation: 0,
      color: isDark ? AppColors.darkSurface : AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(
          color: AppColors.outline.withOpacity(isDark ? 0.05 : 0.2),
        ),
      ),
      child: InkWell(
        onTap: () => context.push('/orders/details/${order.id}'),
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      l10n.dashboardOrderIdLabel(order.orderNumber.isNotEmpty ? order.orderNumber : order.id.substring(0, 8).toUpperCase()),
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.white : AppColors.textBlack,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: statusColor.withOpacity(0.3)),
                      ),
                      child: Text(
                        orderStatusLabel(l10n, order.status).toUpperCase(),
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                          fontSize: 9.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),

              // Items summary
              Text(
                l10n.dashboardOrderItemsSummary(order.items.length, order.items.map((i) => i.serviceName).join(", ")),
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12.h),

              // Sub-info: Scheduled pickup / delivery
              Row(
                children: [
                  Icon(Icons.access_time_rounded, size: 16.r, color: AppColors.textSecondary),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      order.scheduledPickupAt != null
                          ? l10n.ordersPickupTimeLabel(_formatDateTime(order.scheduledPickupAt!))
                          : l10n.ordersCreatedTimeLabel(_formatDateTime(order.createdAt)),
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    '₹${order.total.toStringAsFixed(2)}',
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              
              // Conditional Action Buttons
              if (order.status == OrderStatus.waitingForVendorConfirmation) ...[
                SizedBox(height: 16.h),
                const Divider(),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _rejectOrder(order.id),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: const BorderSide(color: AppColors.error),
                        ),
                        child: Text(l10n.commonReject),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _acceptOrder(order.id),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          foregroundColor: AppColors.white,
                        ),
                        child: Text(l10n.commonAccept),
                      ),
                    ),
                  ],
                ),
              ] else if (order.status == OrderStatus.receivedAtVendor) ...[
                SizedBox(height: 16.h),
                const Divider(),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.push('/orders/details/${order.id}#reconcile'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                        ),
                        child: Text(l10n.ordersReconcileReceiptsButton),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _updateStage(order.id, 'WASHING'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                        ),
                        child: Text(l10n.ordersStartWashingButton),
                      ),
                    ),
                  ],
                ),
              ] else if (order.status == OrderStatus.processing) ...[
                SizedBox(height: 16.h),
                const Divider(),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _showStagePicker(order.id),
                        child: Text(l10n.ordersUpdateStageButton),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _updateStage(order.id, 'PACKED'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          foregroundColor: AppColors.white,
                        ),
                        child: Text(l10n.ordersMarkPackedButton),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
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
    return '${dt.day}/${dt.month} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _acceptOrder(String id) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ref.read(ordersListProvider.notifier).acceptOrder(id);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.ordersOrderAcceptedSnack)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.ordersErrorSnack('$e'))));
    }
  }

  Future<void> _rejectOrder(String id) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ref.read(ordersListProvider.notifier).rejectOrder(id);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.ordersOrderRejectedSnack)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.ordersErrorSnack('$e'))));
    }
  }

  Future<void> _updateStage(String id, String stage) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ref.read(ordersListProvider.notifier).updateStage(id, stage);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.ordersStageUpdatedSnack(stage))));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.ordersErrorSnack('$e'))));
    }
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
}
