import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design/design_system.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../l10n/service_category_l10n.dart';
import '../../../../providers/services_provider.dart';
import '../../../../repositories/repositories.dart';
import '../../../../models/models.dart';
import '../../../../core/network/friendly_error.dart';

/// One subcategory row on the Pricing screen — merges admin's published
/// catalogue entry ([GarmentTypeModel]) with the vendor's own rate for it
/// (if any exists yet on `vendor_service_rates`).
class _PricingRow {
  _PricingRow({
    required this.garmentTypeId,
    required this.name,
    required this.unit,
    required this.demoPrice,
    required int initialRatePaise,
    required bool initialIsActive,
  })  : _initialRatePaise = initialRatePaise,
        _initialIsActive = initialIsActive,
        isActive = initialIsActive,
        priceController = TextEditingController(
          text: initialRatePaise > 0
              ? (initialRatePaise / 100).toStringAsFixed(2)
              : '',
        );

  final String garmentTypeId;
  final String name;
  final String unit;
  final double? demoPrice;
  final int _initialRatePaise;
  final bool _initialIsActive;

  bool isActive;
  final TextEditingController priceController;

  bool get isDirty {
    final currentPaise = ((double.tryParse(priceController.text) ?? 0) * 100).round();
    return isActive != _initialIsActive || currentPaise != _initialRatePaise;
  }

  int get currentRatePaise =>
      ((double.tryParse(priceController.text) ?? 0) * 100).round();

  void dispose() => priceController.dispose();
}

class PricingPage extends ConsumerStatefulWidget {
  const PricingPage({super.key});

  @override
  ConsumerState<PricingPage> createState() => _PricingPageState();
}

class _PricingPageState extends ConsumerState<PricingPage> {
  String? _selectedServiceId;
  String? _currentCategoryId;
  List<_PricingRow>? _rows;
  bool _isLoadingRows = false;
  bool _isSaving = false;
  String? _loadError;

  @override
  void dispose() {
    _disposeRows();
    super.dispose();
  }

  void _disposeRows() {
    if (_rows != null) {
      for (final row in _rows!) {
        row.dispose();
      }
    }
  }

  Future<void> _loadRows(String serviceId, String categoryId) async {
    setState(() {
      _isLoadingRows = true;
      _loadError = null;
    });
    try {
      final repo = ref.read(vendorRepositoryProvider);
      final results = await Future.wait([
        repo.getServiceDetails(serviceId),
        repo.getGarmentTypes(categoryId),
      ]);
      final serviceDetails = results[0] as Map<String, dynamic>;
      final catalogue = results[1] as List<GarmentTypeModel>;
      final existingRates = (serviceDetails['garments'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>();

      final oldRows = _rows;
      final newRows = catalogue.map((gt) {
        final existing = existingRates.firstWhere(
          (r) => r['garment_rate_id'] == gt.id,
          orElse: () => const {},
        );
        final ratePaise = existing['rate_paise'] is num
            ? (existing['rate_paise'] as num).toInt()
            : 0;
        final isActive = existing['is_available'] as bool? ?? false;
        return _PricingRow(
          garmentTypeId: gt.id,
          name: gt.name,
          unit: gt.unit,
          demoPrice: gt.demoPrice,
          initialRatePaise: ratePaise,
          initialIsActive: isActive,
        );
      }).toList();

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
      setState(() {
        _isLoadingRows = false;
        _loadError = friendlyError(e);
      });
    }
  }

  Future<void> _saveChanges() async {
    final l10n = AppLocalizations.of(context);
    final rows = _rows;
    if (rows == null) return;
    final dirtyRows = rows.where((r) => r.isDirty).toList();
    if (dirtyRows.isEmpty) return;

    final invalidRow = dirtyRows.any((r) => r.isActive && r.currentRatePaise <= 0);
    if (invalidRow) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pricingEnterPriceSnack)),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      final repo = ref.read(vendorRepositoryProvider);
      await repo.bulkUpsertGarmentRates(
        _selectedServiceId!,
        dirtyRows
            .map((r) => GarmentRateUpsertItem(
                  garmentTypeId: r.garmentTypeId,
                  ratePaise: r.currentRatePaise,
                  isActive: r.isActive,
                ))
            .toList(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pricingPricesSaved)),
      );
      await _loadRows(_selectedServiceId!, _currentCategoryId!);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pricingFailedToSavePrices(friendlyError(e)))),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final servicesAsync = ref.watch(servicesListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canPop = context.canPop();
    final hasDirtyRows = _rows?.any((r) => r.isDirty) ?? false;
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
            l10n.pricingPageTitle,
            style: AppTypography.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.white : AppColors.textBlack,
            ),
          ),
        ),
        body: servicesAsync.when(
          data: (services) {
            if (services.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(32.r),
                  child: Text(l10n.pricingCreateServiceFirst),
                ),
              );
            }

            if (_selectedServiceId == null && services.isNotEmpty) {
              _selectedServiceId = services.first.id;
              final categoryId = services.first.categoryId ?? services.first.category.id;
              _currentCategoryId = categoryId;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _loadRows(_selectedServiceId!, categoryId);
              });
            }

            final selectedService = services.firstWhere((s) => s.id == _selectedServiceId);

            return Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColors.outline.withOpacity(0.1)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedServiceId,
                        dropdownColor: isDark ? AppColors.darkSurface : AppColors.white,
                        items: services.map((s) {
                          return DropdownMenuItem(
                            value: s.id,
                            child: Text(
                              '${s.name} (${serviceCategoryLabel(l10n, s.category)})',
                              style: TextStyle(
                                color: isDark ? AppColors.white : AppColors.textBlack,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null && val != _selectedServiceId) {
                            final service = services.firstWhere((s) => s.id == val);
                            final categoryId = service.categoryId ?? service.category.id;
                            setState(() {
                              _selectedServiceId = val;
                              _currentCategoryId = categoryId;
                            });
                            _loadRows(val, categoryId);
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Expanded(
                    child: _isLoadingRows
                        ? const Center(child: CircularProgressIndicator())
                        : _loadError != null
                            ? Center(child: Text(l10n.pricingFailedToLoad('$_loadError')))
                            : _buildRowsList(selectedService.name),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text(l10n.pricingErrorLoadingServices(friendlyError(err)))),
        ),
        floatingActionButton: hasDirtyRows
            ? FloatingActionButton.extended(
                onPressed: _isSaving ? null : _saveChanges,
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                icon: _isSaving
                    ? SizedBox(
                        width: 16.r,
                        height: 16.r,
                        child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 1.5),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(l10n.pricingSaveChangesButton),
              )
            : null,
      ),
    );
  }

  Widget _buildRowsList(String serviceName) {
    final rows = _rows ?? const [];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    if (rows.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.monetization_on_outlined, size: 48.r, color: AppColors.textSecondary.withOpacity(0.3)),
              SizedBox(height: 12.h),
              Text(l10n.pricingNoSubcategoriesPublished),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: rows.length,
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      itemBuilder: (context, idx) {
        final row = rows[idx];
        return StatefulBuilder(
          builder: (context, setRowState) {
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
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                row.name,
                                style: AppTypography.bodyLarge.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.white : AppColors.textBlack,
                                ),
                              ),
                              Text(l10n.pricingUnitBillingPer(row.unit),
                                  style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                              if (row.demoPrice != null)
                                Padding(
                                  padding: EdgeInsets.only(top: 2.h),
                                  child: Text(
                                    l10n.pricingDemoPriceChargeWhatYouLike(row.demoPrice!.toStringAsFixed(0), row.unit),
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.textSecondary.withOpacity(0.7),
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Switch(
                          value: row.isActive,
                          activeColor: AppColors.primary,
                          onChanged: (val) {
                            setRowState(() => row.isActive = val);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    TextField(
                      controller: row.priceController,
                      enabled: row.isActive,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        prefixText: '₹ ',
                        hintText: l10n.servicesYourPricePer(row.unit),
                        isDense: true,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
