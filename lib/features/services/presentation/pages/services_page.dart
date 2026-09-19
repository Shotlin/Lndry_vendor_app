import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/design/design_system.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../l10n/service_category_l10n.dart';
import '../../../../providers/services_provider.dart';
import '../../../../repositories/repositories.dart';
import '../../../../models/models.dart';
import '../../../../core/network/friendly_error.dart';

/// One admin-published subcategory row inside the Add/Edit Service form —
/// merges the catalogue entry with the vendor's own existing rate for it
/// (if any).
class _SubcategoryRow {
  _SubcategoryRow({
    required this.garmentTypeId,
    required this.name,
    required this.unit,
    required this.demoPrice,
    required this.thumbnailUrl,
    required int initialRatePaise,
    required bool initialIsActive,
    this.overrideReason,
    this.overrideAt,
  })  : isActive = initialIsActive,
        priceController = TextEditingController(
          text: initialRatePaise > 0
              ? (initialRatePaise / 100).toStringAsFixed(2)
              : '',
        );

  final String garmentTypeId;
  final String name;
  final String unit;
  final double? demoPrice;
  final String? thumbnailUrl;
  /// Set when admin last recalculated this subcategory's price — shown to
  /// the vendor so the reason is never hidden from them.
  final String? overrideReason;
  final DateTime? overrideAt;

  bool isActive;
  final TextEditingController priceController;

  int get currentRatePaise =>
      ((double.tryParse(priceController.text) ?? 0) * 100).round();

  void dispose() => priceController.dispose();
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String? status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    late final Color color;
    late final String label;
    switch (status) {
      case 'PENDING':
        color = AppColors.warning;
        label = l10n.servicesStatusPendingReview;
        break;
      case 'REJECTED':
        color = AppColors.error;
        label = l10n.servicesStatusRejected;
        break;
      case 'APPROVED':
      default:
        color = AppColors.success;
        label = l10n.servicesStatusLive;
        break;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10.r)),
      child: Text(
        label,
        style: TextStyle(fontSize: 10.sp, color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class ServicesPage extends ConsumerStatefulWidget {
  const ServicesPage({super.key});

  @override
  ConsumerState<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends ConsumerState<ServicesPage> {
  Future<void> _openServiceForm({ServiceModel? existing}) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
      builder: (context) => _ServiceFormSheet(existing: existing),
    );
  }

  @override
  Widget build(BuildContext context) {
    final servicesAsync = ref.watch(servicesListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.white,
        elevation: 0,
        title: Text(
          l10n.servicesPageTitle,
          style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.bold, color: isDark ? AppColors.white : AppColors.textBlack),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(servicesListProvider.notifier).fetchServices(),
        color: AppColors.primary,
        child: servicesAsync.when(
          data: (services) {
            if (services.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(32.r),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.category_outlined, size: 64.r, color: AppColors.textSecondary.withOpacity(0.3)),
                      SizedBox(height: 16.h),
                      Text(l10n.servicesEmptyTitle, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8.h),
                      Text(
                        l10n.servicesEmptySubtitle,
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.fromLTRB(16.r, 16.r, 16.r, 96.r),
              itemCount: services.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (context, idx) {
                final service = services[idx];
                return Card(
                  elevation: 0,
                  color: isDark ? AppColors.darkSurface : AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    side: BorderSide(color: AppColors.outline.withOpacity(isDark ? 0.05 : 0.2)),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            service.name,
                            style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold, color: isDark ? AppColors.white : AppColors.textBlack),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        _StatusChip(status: service.approvalStatus),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(10.r)),
                          child: Text(
                            serviceCategoryLabel(l10n, service.category),
                            style: AppTypography.bodySmall.copyWith(fontSize: 10.sp, color: AppColors.primary, fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (service.approvalStatus == 'REJECTED' && service.rejectionReason != null) ...[
                          SizedBox(height: 6.h),
                          Text(
                            l10n.servicesRejectedReason(service.rejectionReason!),
                            style: AppTypography.bodySmall.copyWith(color: AppColors.error),
                          ),
                        ],
                        if (service.latestOverrideReason != null && service.latestOverrideReason!.isNotEmpty) ...[
                          SizedBox(height: 8.h),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: AppColors.warning.withOpacity(0.3)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.campaign_rounded, size: 13.r, color: AppColors.warning),
                                SizedBox(width: 6.w),
                                Expanded(
                                  child: Text(
                                    l10n.servicesPriceAdjustedByAdmin(service.latestOverrideReason!),
                                    style: AppTypography.bodySmall.copyWith(color: AppColors.warning),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    trailing: Switch(
                      value: service.isAvailable,
                      onChanged: (val) => ref.read(servicesListProvider.notifier).toggleAvailability(service.id, val),
                      activeColor: AppColors.success,
                    ),
                    onTap: () => _openServiceForm(existing: service),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline_rounded, color: AppColors.error, size: 48.r),
                SizedBox(height: 16.h),
                Text(l10n.servicesFailedToLoad(friendlyError(err)), style: AppTypography.bodyMedium),
                SizedBox(height: 8.h),
                ElevatedButton.icon(
                  onPressed: () => ref.invalidate(servicesListProvider),
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(l10n.commonRetry),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openServiceForm(),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        icon: const Icon(Icons.add),
        label: Text(l10n.servicesAddServiceButton),
      ),
    );
  }
}

class _ServiceFormSheet extends ConsumerStatefulWidget {
  const _ServiceFormSheet({this.existing});

  final ServiceModel? existing;

  @override
  ConsumerState<_ServiceFormSheet> createState() => _ServiceFormSheetState();
}

class _ServiceFormSheetState extends ConsumerState<_ServiceFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();

  List<CategoryModel> _categories = [];
  CategoryModel? _selectedCategory;
  List<_SubcategoryRow>? _rows;
  bool _isLoadingCategories = true;
  bool _isLoadingRows = false;
  bool _isSaving = false;
  String? _error;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.existing?.name ?? '';
    _descController.text = widget.existing?.description ?? '';
    _init();
  }

  Future<void> _init() async {
    try {
      _categories = await ref.read(serviceCategoriesProvider.future);
    } catch (_) {
      _categories = [];
    }
    if (!mounted) return;

    if (widget.existing != null) {
      _selectedCategory = _categories.cast<CategoryModel?>().firstWhere(
            (c) => c?.id == widget.existing!.categoryId,
            orElse: () => null,
          );
    } else if (_categories.isNotEmpty) {
      _selectedCategory = _categories.first;
    }

    setState(() => _isLoadingCategories = false);
    if (_selectedCategory != null) await _loadRows();
  }

  Future<void> _loadRows() async {
    final category = _selectedCategory;
    if (category == null) return;
    setState(() {
      _isLoadingRows = true;
      _error = null;
    });
    try {
      final repo = ref.read(vendorRepositoryProvider);
      final catalogue = await repo.getGarmentTypes(category.id);

      final existingRatesById = <String, Map<String, dynamic>>{};
      if (_isEditing && _selectedCategory?.id == widget.existing!.categoryId) {
        final details = await repo.getServiceDetails(widget.existing!.id);
        final list = (details['garments'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
        for (final r in list) {
          final id = r['garment_rate_id'] as String?;
          if (id != null) existingRatesById[id] = r;
        }
      }

      final oldRows = _rows;
      final newRows = catalogue.map((gt) {
        final existing = existingRatesById[gt.id];
        final ratePaise = existing != null && existing['rate_paise'] is num ? (existing['rate_paise'] as num).toInt() : 0;
        final isActive = existing != null ? (existing['is_available'] as bool? ?? false) : false;
        return _SubcategoryRow(
          garmentTypeId: gt.id,
          name: gt.name,
          unit: gt.unit,
          demoPrice: gt.demoPrice,
          thumbnailUrl: gt.thumbnailUrl,
          initialRatePaise: ratePaise,
          initialIsActive: isActive,
          overrideReason: existing?['override_reason'] as String?,
          overrideAt: existing?['override_at'] != null
              ? DateTime.tryParse(existing!['override_at'] as String)
              : null,
        );
      }).toList();

      if (!mounted) return;
      setState(() {
        _rows = newRows;
        _isLoadingRows = false;
      });
      if (oldRows != null) {
        for (final row in oldRows) {
          row.dispose();
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingRows = false;
        _error = friendlyError(e);
      });
    }
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.servicesPickCategorySnack)));
      return;
    }
    final rows = _rows ?? [];
    final activeRows = rows.where((r) => r.isActive).toList();
    if (activeRows.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.servicesTurnOnSubcategorySnack)));
      return;
    }
    if (activeRows.any((r) => r.currentRatePaise <= 0)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.servicesEnterPriceSnack)));
      return;
    }

    setState(() => _isSaving = true);
    try {
      final repo = ref.read(vendorRepositoryProvider);
      final service = ServiceModel(
        id: widget.existing?.id ?? '',
        vendorId: widget.existing?.vendorId ?? '',
        name: _nameController.text.trim(),
        description: _descController.text.trim(),
        category: widget.existing?.category ?? ServiceCategory.wash,
        categoryId: _selectedCategory!.id,
        // Left null deliberately — this legacy per-service price column
        // isn't used by the subcategory-rate pricing model (real prices
        // live in vendor_service_rates), and the DB constrains it to
        // NULL or >= 0.01, so sending 0 fails the save.
        pricePerPiece: null,
        minWeightKg: 1.0,
        isAvailable: widget.existing?.isAvailable ?? true,
      );

      final saved = _isEditing ? await repo.updateService(service) : await repo.addService(service);

      await repo.bulkUpsertGarmentRates(
        saved.id,
        rows
            .map((r) => GarmentRateUpsertItem(garmentTypeId: r.garmentTypeId, ratePaise: r.currentRatePaise, isActive: r.isActive))
            .toList(),
      );

      await ref.read(servicesListProvider.notifier).fetchServices(silent: true);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.servicesSubmittedForReview)),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.servicesFailedToSave(friendlyError(e)))));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    if (_rows != null) {
      for (final row in _rows!) {
        row.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20.w, right: 20.w, top: 24.h),
      child: DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Form(
            key: _formKey,
            child: ListView(
              controller: scrollController,
              children: [
                Text(
                  _isEditing ? l10n.servicesEditServiceTitle : l10n.servicesAddServiceButton,
                  style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.h),

                if (widget.existing?.approvalStatus == 'REJECTED' && widget.existing?.rejectionReason != null)
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 16.h),
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.error.withOpacity(0.3)),
                    ),
                    child: Text(
                      l10n.servicesRejectedByAdminNote(widget.existing!.rejectionReason!),
                      style: AppTypography.bodySmall.copyWith(color: AppColors.error),
                    ),
                  ),

                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: l10n.servicesServiceNameLabel,
                    hintText: l10n.servicesServiceNameHint,
                    prefixIcon: const Icon(Icons.drive_file_rename_outline_rounded),
                  ),
                  validator: (v) => v == null || v.isEmpty ? l10n.servicesNameRequired : null,
                ),
                SizedBox(height: 12.h),

                TextFormField(
                  controller: _descController,
                  decoration: InputDecoration(
                    labelText: l10n.servicesDescriptionLabel,
                    hintText: l10n.servicesDescriptionHint,
                    prefixIcon: const Icon(Icons.description_rounded),
                  ),
                  validator: (v) => v == null || v.isEmpty ? l10n.servicesDescriptionRequired : null,
                ),
                SizedBox(height: 12.h),

                _isLoadingCategories
                    ? const Center(child: Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator()))
                    : DropdownButtonFormField<CategoryModel>(
                        value: _selectedCategory,
                        // No separate prefixIcon here — the selected item's
                        // own Row (avatar + name) already renders as the
                        // field's closed-state content; adding one would
                        // show two avatars side by side.
                        decoration: InputDecoration(labelText: l10n.servicesCategoryLabel),
                        items: _categories
                            .map((c) => DropdownMenuItem(
                                  value: c,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _CategoryAvatar(imageUrl: c.imageUrl, size: 24),
                                      SizedBox(width: 8.w),
                                      Text(c.name),
                                    ],
                                  ),
                                ))
                            .toList(),
                        // Category is locked once a service exists for it — changing it
                        // would orphan the rates already collected below.
                        onChanged: _isEditing
                            ? null
                            : (val) {
                                if (val != null && val.id != _selectedCategory?.id) {
                                  setState(() => _selectedCategory = val);
                                  _loadRows();
                                }
                              },
                        validator: (v) => v == null ? l10n.servicesCategoryRequired : null,
                      ),
                SizedBox(height: 20.h),

                Text(l10n.servicesSubcategoriesHeader, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: 4.h),
                Text(
                  l10n.servicesSubcategoriesSubtitle,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
                SizedBox(height: 12.h),

                if (_isLoadingRows)
                  const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
                else if (_error != null)
                  Text(l10n.servicesFailedToLoadSubcategories('$_error'), style: AppTypography.bodySmall.copyWith(color: AppColors.error))
                else if (_rows != null)
                  if (_rows!.isEmpty)
                    Text(l10n.servicesNoSubcategoriesPublished)
                  else
                    ..._rows!.map((row) => _SubcategoryTile(row: row, onChanged: () => setState(() {}))),

                SizedBox(height: 24.h),
                ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.white, padding: EdgeInsets.symmetric(vertical: 14.h)),
                  child: _isSaving
                      ? SizedBox(width: 20.r, height: 20.r, child: const CircularProgressIndicator(color: AppColors.white, strokeWidth: 2))
                      : Text(l10n.servicesSaveSubmitButton),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SubcategoryTile extends StatelessWidget {
  const _SubcategoryTile({required this.row, required this.onChanged});

  final _SubcategoryRow row;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.outline.withOpacity(isDark ? 0.1 : 0.2)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: row.thumbnailUrl != null && row.thumbnailUrl!.isNotEmpty
                    ? Image.network(
                        row.thumbnailUrl!,
                        width: 44.r,
                        height: 44.r,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _SubcategoryPlaceholder(size: 44.r),
                      )
                    : _SubcategoryPlaceholder(size: 44.r),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(row.name, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    Text(l10n.servicesUnitPer(row.unit), style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                    if (row.demoPrice != null)
                      Text(
                        l10n.servicesDemoPriceReferenceOnly(row.demoPrice!.toStringAsFixed(0), row.unit),
                        style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary.withOpacity(0.7), fontStyle: FontStyle.italic),
                      ),
                  ],
                ),
              ),
              Switch(
                value: row.isActive,
                activeColor: AppColors.primary,
                onChanged: (val) {
                  row.isActive = val;
                  onChanged();
                },
              ),
            ],
          ),
          if (row.overrideReason != null && row.overrideReason!.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColors.warning.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.campaign_rounded, size: 14.r, color: AppColors.warning),
                      SizedBox(width: 6.w),
                      Text(
                        l10n.servicesPriceAdjustedHeader,
                        style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.bold, color: AppColors.warning),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(row.overrideReason!, style: AppTypography.bodySmall),
                ],
              ),
            ),
          ],
          if (row.isActive) ...[
            SizedBox(height: 6.h),
            TextField(
              controller: row.priceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => onChanged(),
              decoration: InputDecoration(prefixText: '₹ ', hintText: l10n.servicesYourPricePer(row.unit), isDense: true, border: const OutlineInputBorder()),
            ),
          ],
        ],
      ),
    );
  }
}

class _SubcategoryPlaceholder extends StatelessWidget {
  const _SubcategoryPlaceholder({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(10)),
      child: Icon(Icons.checkroom_rounded, color: AppColors.primary, size: size * 0.55),
    );
  }
}

class _CategoryAvatar extends StatelessWidget {
  const _CategoryAvatar({required this.imageUrl, this.size = 28});

  final String? imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Icon(Icons.layers_rounded, size: size, color: AppColors.primary);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 4),
      child: Image.network(
        imageUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Icon(Icons.layers_rounded, size: size, color: AppColors.primary),
      ),
    );
  }
}
