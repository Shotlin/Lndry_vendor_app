import 'package:file_selector/file_selector.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/design/design_system.dart';
import '../../../../core/services/location_capture_service.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../models/models.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../repositories/repositories.dart';

List<String> _stepTitles(AppLocalizations l10n) => [
  l10n.onboardingStepBusinessDetails,
  l10n.onboardingStepOwnerBank,
  l10n.onboardingStepLocation,
  l10n.onboardingStepRadius,
  l10n.onboardingStepDocuments,
  l10n.onboardingStepReview,
];

/// Maps each step index to the correction-section key an admin can flag on
/// `POST /vendors/admin/:id/review`. Null (the review step) is never locked —
/// it has no editable fields of its own.
const List<String?> _kStepSectionKeys = [
  'business',
  'owner_bank',
  'location',
  'radius',
  'documents',
  null,
];

Map<String, String> _sectionLabels(AppLocalizations l10n) => {
  'business': l10n.onboardingStepBusinessDetails,
  'owner_bank': l10n.onboardingStepOwnerBank,
  'location': l10n.onboardingStepLocation,
  'radius': l10n.onboardingStepRadius,
  'documents': l10n.onboardingStepDocuments,
};

/// Onboarding wizard for a vendor with no vendor record yet
/// (`AuthNeedsVendorApplication`). Mirrors the backend's 6-step application
/// API (business / owner / location / radius / documents / submit) with one
/// in-page step index rather than separate routes, since this is a strictly
/// linear, once-per-vendor flow.
class VendorApplicationPage extends ConsumerStatefulWidget {
  const VendorApplicationPage({super.key});

  @override
  ConsumerState<VendorApplicationPage> createState() =>
      _VendorApplicationPageState();
}

class _VendorApplicationPageState extends ConsumerState<VendorApplicationPage> {
  bool _isLoading = true;
  String? _loadError;
  VendorApplicationModel? _application;
  int _stepIndex = 0;
  bool _isSaving = false;
  bool _isDetectingLocation = false;
  bool _isUploadingOwnerIdentity = false;
  bool _isUploadingShopPhoto = false;
  bool _isUploadingServiceList = false;
  String? _stepError;

  final _formKeys = List.generate(4, (_) => GlobalKey<FormState>());

  // Step 0: business
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _gstController = TextEditingController();
  final _panController = TextEditingController();

  // Step 1: owner & bank
  final _ownerNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _bankAccountController = TextEditingController();
  final _bankIfscController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _bankHolderController = TextEditingController();

  // Step 2: location
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();
  double? _lat;
  double? _lng;

  // Step 3: radius & capacity
  double _requestedRadiusKm = 5.0;
  int _requestedDailyCapacity = 10;
  final _capacityController = TextEditingController(text: '10');

  bool get _hasOwnerIdentity =>
      _application?.documents.any((d) => d.documentType == 'owner_identity') ??
      false;
  bool get _hasShopPhoto =>
      _application?.documents.any((d) => d.documentType == 'shop_photo') ??
      false;
  bool get _hasServiceList =>
      _application?.documents.any((d) => d.documentType == 'service_list') ??
      false;

  bool get _isCorrectionMode => _application?.status == 'CORRECTION_REQUIRED';

  /// Older correction requests (made before flagged sections existed) carry
  /// no section list — treat those as "everything's editable" rather than
  /// locking a vendor out of a correction they can't otherwise clear.
  bool get _hasFlaggedSections =>
      (_application?.correctionSections ?? []).isNotEmpty;

  bool _isStepEditable(int stepIndex) {
    if (!_isCorrectionMode || !_hasFlaggedSections) return true;
    final key = stepIndex < _kStepSectionKeys.length
        ? _kStepSectionKeys[stepIndex]
        : null;
    if (key == null) return true;
    return _application!.correctionSections.contains(key);
  }

  @override
  void initState() {
    super.initState();
    _loadApplication();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _gstController.dispose();
    _panController.dispose();
    _ownerNameController.dispose();
    _emailController.dispose();
    _bankAccountController.dispose();
    _bankIfscController.dispose();
    _bankNameController.dispose();
    _bankHolderController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  Future<void> _loadApplication() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });
    try {
      final app = await ref
          .read(vendorRepositoryProvider)
          .getOrCreateApplication();
      if (!mounted) return;
      _populateFrom(app);
      setState(() {
        _application = app;
        _stepIndex = _computeStartingStep(app);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadError = AppLocalizations.of(context).onboardingLoadError;
        _isLoading = false;
      });
    }
  }

  void _populateFrom(VendorApplicationModel app) {
    _nameController.text = app.name;
    _descController.text = app.description ?? '';
    _gstController.text = app.gstNumber ?? '';
    _panController.text = app.panNumber ?? '';
    _ownerNameController.text = app.ownerName ?? '';
    _emailController.text = app.email ?? '';
    _bankAccountController.text = app.bankAccountNumber ?? '';
    _bankIfscController.text = app.bankIfsc ?? '';
    _bankNameController.text = app.bankName ?? '';
    _bankHolderController.text = app.bankHolderName ?? '';
    _addressLine1Controller.text = app.addressLine1 ?? '';
    _addressLine2Controller.text = app.addressLine2 ?? '';
    _cityController.text = app.city ?? '';
    _stateController.text = app.state ?? '';
    _pincodeController.text = app.pincode ?? '';
    _lat = app.lat;
    _lng = app.lng;
    _requestedRadiusKm = app.requestedServiceRadiusKm;
    _requestedDailyCapacity = app.requestedDailyCapacity ?? 10;
    _capacityController.text = _requestedDailyCapacity.toString();
  }

  int _computeStartingStep(VendorApplicationModel app) {
    if (app.status == 'CORRECTION_REQUIRED' &&
        app.correctionSections.isNotEmpty) {
      final firstFlagged = _kStepSectionKeys.indexWhere(
        (key) => key != null && app.correctionSections.contains(key),
      );
      if (firstFlagged != -1) return firstFlagged;
    }
    if ((app.description ?? '').isEmpty) return 0;
    if (app.missingSteps.contains('bank_details')) return 1;
    if ((app.addressLine1 ?? '').isEmpty) return 2;
    if (app.missingSteps.contains('capacity')) return 3;
    if (app.missingSteps.any((s) => s.startsWith('document:'))) return 4;
    return 5;
  }

  void _showError(Object e) {
    final message = e is LocationCaptureException ? e.message : e.toString();
    setState(() => _stepError = message);
  }

  Future<void> _saveBusinessStep() async {
    if (!_formKeys[0].currentState!.validate()) return;
    setState(() {
      _isSaving = true;
      _stepError = null;
    });
    try {
      final updated = await ref
          .read(vendorRepositoryProvider)
          .updateApplicationBusiness(
            _application!.id,
            name: _nameController.text.trim(),
            description: _descController.text.trim(),
            gstNumber: _gstController.text.trim().isEmpty
                ? null
                : _gstController.text.trim(),
            panNumber: _panController.text.trim().isEmpty
                ? null
                : _panController.text.trim(),
          );
      if (!mounted) return;
      setState(() {
        _application = updated;
        _stepIndex = 1;
      });
    } catch (e) {
      _showError(e);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _saveOwnerStep() async {
    if (!_formKeys[1].currentState!.validate()) return;
    setState(() {
      _isSaving = true;
      _stepError = null;
    });
    try {
      final updated = await ref
          .read(vendorRepositoryProvider)
          .updateApplicationOwner(
            _application!.id,
            ownerName: _ownerNameController.text.trim(),
            email: _emailController.text.trim().isEmpty
                ? null
                : _emailController.text.trim(),
            bankAccountNumber: _bankAccountController.text.trim().isEmpty
                ? null
                : _bankAccountController.text.trim(),
            bankIfsc: _bankIfscController.text.trim().isEmpty
                ? null
                : _bankIfscController.text.trim(),
            bankName: _bankNameController.text.trim().isEmpty
                ? null
                : _bankNameController.text.trim(),
            bankHolderName: _bankHolderController.text.trim().isEmpty
                ? null
                : _bankHolderController.text.trim(),
          );
      if (!mounted) return;
      setState(() {
        _application = updated;
        _stepIndex = 2;
      });
    } catch (e) {
      _showError(e);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _saveLocationStep() async {
    if (!_formKeys[2].currentState!.validate()) return;
    setState(() {
      _isSaving = true;
      _stepError = null;
    });
    try {
      final updated = await ref
          .read(vendorRepositoryProvider)
          .updateApplicationLocation(
            _application!.id,
            addressLine1: _addressLine1Controller.text.trim(),
            addressLine2: _addressLine2Controller.text.trim().isEmpty
                ? null
                : _addressLine2Controller.text.trim(),
            city: _cityController.text.trim(),
            state: _stateController.text.trim(),
            pincode: _pincodeController.text.trim(),
            lat: _lat,
            lng: _lng,
          );
      if (!mounted) return;
      setState(() {
        _application = updated;
        _stepIndex = 3;
      });
    } catch (e) {
      _showError(e);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _detectLocation() async {
    setState(() {
      _isDetectingLocation = true;
      _stepError = null;
    });
    try {
      final captured = await ref
          .read(locationCaptureServiceProvider)
          .captureCurrentLocation();
      if (!mounted) return;
      setState(() {
        _addressLine1Controller.text = captured.line1;
        _cityController.text = captured.city;
        _stateController.text = captured.state;
        _pincodeController.text = captured.pincode;
        _lat = captured.latitude;
        _lng = captured.longitude;
      });
    } catch (e) {
      _showError(e);
    } finally {
      if (mounted) setState(() => _isDetectingLocation = false);
    }
  }

  Future<void> _saveRadiusStep() async {
    setState(() {
      _isSaving = true;
      _stepError = null;
    });
    try {
      final updated = await ref
          .read(vendorRepositoryProvider)
          .updateApplicationRadius(
            _application!.id,
            _requestedRadiusKm,
            requestedDailyCapacity: _requestedDailyCapacity,
          );
      if (!mounted) return;
      setState(() {
        _application = updated;
        _stepIndex = 4;
      });
    } catch (e) {
      _showError(e);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _pickAndUploadDocument(String documentType) async {
    XFile? file;
    if (documentType == 'service_list') {
      file = await openFile(
        acceptedTypeGroups: const [
          XTypeGroup(
            label: 'PDF',
            extensions: ['pdf'],
            mimeTypes: ['application/pdf'],
          ),
        ],
      );
      if (file == null) return;
    } else {
      final picker = ImagePicker();
      file = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (file == null) return;
    }

    setState(() {
      _stepError = null;
      if (documentType == 'owner_identity') {
        _isUploadingOwnerIdentity = true;
      } else if (documentType == 'shop_photo') {
        _isUploadingShopPhoto = true;
      } else {
        _isUploadingServiceList = true;
      }
    });
    try {
      await ref
          .read(vendorRepositoryProvider)
          .uploadApplicationDocument(
            _application!.id,
            documentType: documentType,
            file: file,
          );
      final refreshed = await ref
          .read(vendorRepositoryProvider)
          .getApplicationMe();
      if (!mounted) return;
      setState(() => _application = refreshed);
    } catch (e) {
      _showError(e);
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingOwnerIdentity = false;
          _isUploadingShopPhoto = false;
          _isUploadingServiceList = false;
        });
      }
    }
  }

  Future<void> _submit() async {
    if (!_hasOwnerIdentity || !_hasShopPhoto || !_hasServiceList) {
      setState(
        () => _stepError = AppLocalizations.of(
          context,
        ).onboardingUploadAllDocuments,
      );
      return;
    }
    setState(() {
      _isSaving = true;
      _stepError = null;
    });
    try {
      final isCorrection = _application!.status == 'CORRECTION_REQUIRED';
      final updated = isCorrection
          ? await ref
                .read(vendorRepositoryProvider)
                .resubmitApplication(_application!.id)
          : await ref
                .read(vendorRepositoryProvider)
                .submitApplication(_application!.id);
      if (!mounted) return;
      if (updated.status == 'APPROVED') {
        // Dev-only fast path: the backend's ALLOW_AUTO_APPROVE_VENDOR flag
        // promoted this application to a live vendor immediately instead of
        // waiting on HQ review, so go straight to the dashboard.
        final becameVendor = await ref
            .read(authProvider.notifier)
            .refreshProfileIfApproved();
        if (becameVendor && mounted) {
          context.go(AppRoutes.dashboard);
          return;
        }
      }
      setState(() => _application = updated);
    } catch (e) {
      _showError(e);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? AppColors.darkBackground : AppColors.white;
    final l10n = AppLocalizations.of(context);

    if (_isLoading) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_loadError != null) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 48.r,
                  color: AppColors.error,
                ),
                SizedBox(height: 16.h),
                Text(
                  _loadError!,
                  style: AppTypography.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: _loadApplication,
                  child: Text(l10n.commonRetry),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_application?.status == 'WAITING_FOR_APPROVAL') {
      return _buildPendingScreen(isDark, backgroundColor);
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            l10n.onboardingVendorApplicationTitle,
            style: AppTypography.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.white : AppColors.textBlack,
            ),
          ),
          actions: [
            IconButton(
              tooltip: l10n.onboardingLogOutButton,
              icon: const Icon(Icons.logout_rounded),
              color: AppColors.error,
              onPressed: () => ref.read(authProvider.notifier).logout(),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              _buildStepIndicator(isDark),
              if (_isCorrectionMode) _buildCorrectionBanner(isDark),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 16.h,
                  ),
                  child: _buildStepBody(isDark),
                ),
              ),
              _buildFooter(isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPendingScreen(bool isDark, Color backgroundColor) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: l10n.onboardingLogOutButton,
            icon: const Icon(Icons.logout_rounded),
            color: AppColors.error,
            onPressed: () => ref.read(authProvider.notifier).logout(),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 96.r,
                  height: 96.r,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.hourglass_top_rounded,
                    size: 48.r,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(height: 32.h),
              Text(
                l10n.onboardingApplicationSubmittedTitle,
                style: AppTypography.headlineLarge.copyWith(
                  color: isDark ? AppColors.white : AppColors.textBlack,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                l10n.onboardingApplicationSubmittedBody,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40.h),
              SizedBox(
                height: 54.h,
                child: OutlinedButton(
                  onPressed: () => ref.read(authProvider.notifier).logout(),
                  child: Text(l10n.onboardingLogOutButton),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(bool isDark) {
    final l10n = AppLocalizations.of(context);
    final titles = _stepTitles(l10n);
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full.r),
            child: LinearProgressIndicator(
              value: (_stepIndex + 1) / titles.length,
              minHeight: 6.h,
              backgroundColor: AppColors.outline.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            l10n.onboardingStepOfTotal(
              _stepIndex + 1,
              titles.length,
              titles[_stepIndex],
            ),
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorrectionBanner(bool isDark) {
    final l10n = AppLocalizations.of(context);
    final sectionLabels = _sectionLabels(l10n);
    final sections = _application?.correctionSections ?? const [];
    final reason = _application?.rejectionReason;
    return Container(
      margin: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.md.r),
        border: Border.all(color: AppColors.warning.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: AppColors.warning,
                size: 20.r,
              ),
              SizedBox(width: 8.w),
              Text(
                l10n.onboardingCorrectionNeeded,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.warning,
                ),
              ),
            ],
          ),
          if (sections.isNotEmpty) ...[
            SizedBox(height: 10.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: sections.map((key) {
                final label = sectionLabels[key] ?? key;
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(AppRadius.full.r),
                  ),
                  child: Text(
                    label,
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.warning,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          if (reason != null && reason.isNotEmpty) ...[
            SizedBox(height: 10.h),
            Text(
              reason,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
          if (sections.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              l10n.onboardingCorrectionOnlyFlaggedEditable,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStepBody(bool isDark) {
    final Widget content = switch (_stepIndex) {
      0 => _buildBusinessStep(),
      1 => _buildOwnerStep(),
      2 => _buildLocationStep(),
      3 => _buildRadiusStep(),
      4 => _buildDocumentsStep(),
      _ => _buildReviewStep(),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        content,
        if (_stepError != null) ...[
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.md.r),
              border: Border.all(
                color: AppColors.error.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline_rounded, color: AppColors.error),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    _stepError!,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBusinessStep() {
    final l10n = AppLocalizations.of(context);
    final enabled = _isStepEditable(0);
    return Form(
      key: _formKeys[0],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _nameController,
            enabled: enabled,
            decoration: InputDecoration(
              labelText: l10n.onboardingBusinessNameLabel,
              hintText: l10n.onboardingBusinessNameHint,
              prefixIcon: const Icon(Icons.storefront_outlined),
            ),
            validator: (v) => (v == null || v.trim().isEmpty)
                ? l10n.onboardingBusinessNameRequired
                : null,
          ),
          SizedBox(height: 12.h),
          TextFormField(
            controller: _descController,
            enabled: enabled,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: l10n.servicesDescriptionLabel,
              hintText: l10n.onboardingDescriptionHint,
              prefixIcon: const Icon(Icons.description_outlined),
            ),
            validator: (v) => (v == null || v.trim().isEmpty)
                ? l10n.servicesDescriptionRequired
                : null,
          ),
          SizedBox(height: 12.h),
          TextFormField(
            controller: _gstController,
            enabled: enabled,
            decoration: InputDecoration(
              labelText: l10n.onboardingGstLabel,
              prefixIcon: const Icon(Icons.receipt_long_outlined),
            ),
          ),
          SizedBox(height: 12.h),
          TextFormField(
            controller: _panController,
            enabled: enabled,
            decoration: InputDecoration(
              labelText: l10n.onboardingPanLabel,
              prefixIcon: const Icon(Icons.badge_outlined),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOwnerStep() {
    final l10n = AppLocalizations.of(context);
    final enabled = _isStepEditable(1);
    return Form(
      key: _formKeys[1],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _ownerNameController,
            enabled: enabled,
            decoration: InputDecoration(
              labelText: l10n.onboardingOwnerNameLabel,
              hintText: l10n.onboardingOwnerNameHint,
              prefixIcon: const Icon(Icons.badge_outlined),
            ),
            validator: (v) => (v == null || v.trim().isEmpty)
                ? l10n.onboardingOwnerNameRequired
                : null,
          ),
          SizedBox(height: 12.h),
          TextFormField(
            controller: _emailController,
            enabled: enabled,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: l10n.onboardingEmailOptionalLabel,
              prefixIcon: const Icon(Icons.email_outlined),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            l10n.onboardingBankDetailsOptionalHeader,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          TextFormField(
            controller: _bankAccountController,
            enabled: enabled,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.onboardingBankAccountLabel,
              prefixIcon: const Icon(Icons.account_balance_outlined),
            ),
          ),
          SizedBox(height: 12.h),
          TextFormField(
            controller: _bankIfscController,
            enabled: enabled,
            decoration: InputDecoration(
              labelText: l10n.onboardingIfscLabel,
              prefixIcon: const Icon(Icons.pin_outlined),
            ),
          ),
          SizedBox(height: 12.h),
          TextFormField(
            controller: _bankNameController,
            enabled: enabled,
            decoration: InputDecoration(
              labelText: l10n.onboardingBankNameLabel,
              prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
            ),
          ),
          SizedBox(height: 12.h),
          TextFormField(
            controller: _bankHolderController,
            enabled: enabled,
            decoration: InputDecoration(
              labelText: l10n.onboardingAccountHolderLabel,
              prefixIcon: const Icon(Icons.person_outline),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationStep() {
    final l10n = AppLocalizations.of(context);
    final enabled = _isStepEditable(2);
    return Form(
      key: _formKeys[2],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 48.h,
            child: OutlinedButton.icon(
              onPressed: (!enabled || _isDetectingLocation)
                  ? null
                  : _detectLocation,
              icon: _isDetectingLocation
                  ? SizedBox(
                      width: 18.r,
                      height: 18.r,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.my_location_rounded),
              label: Text(
                _isDetectingLocation
                    ? l10n.onboardingDetectingLocation
                    : l10n.onboardingUseCurrentLocation,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          TextFormField(
            controller: _addressLine1Controller,
            enabled: enabled,
            decoration: InputDecoration(
              labelText: l10n.profileAddressLine1Label,
              hintText: l10n.onboardingAddressLine1Hint,
              prefixIcon: const Icon(Icons.location_on_outlined),
            ),
            validator: (v) => (v == null || v.trim().isEmpty)
                ? l10n.onboardingAddressRequired
                : null,
          ),
          SizedBox(height: 12.h),
          TextFormField(
            controller: _addressLine2Controller,
            enabled: enabled,
            decoration: InputDecoration(
              labelText: l10n.onboardingAddressLine2Label,
              prefixIcon: const Icon(Icons.signpost_outlined),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _cityController,
                  enabled: enabled,
                  decoration: InputDecoration(labelText: l10n.profileCityLabel),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.profileRequiredField
                      : null,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: TextFormField(
                  controller: _stateController,
                  enabled: enabled,
                  decoration: InputDecoration(
                    labelText: l10n.profileStateLabel,
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.profileRequiredField
                      : null,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          TextFormField(
            controller: _pincodeController,
            enabled: enabled,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: l10n.profilePincodeLabel),
            validator: (v) {
              if (v == null || v.trim().isEmpty)
                return l10n.onboardingPincodeRequired;
              if (!RegExp(r'^[1-9][0-9]{5}$').hasMatch(v.trim()))
                return l10n.onboardingPincodeInvalid;
              return null;
            },
          ),
          if (_lat != null && _lng != null) ...[
            SizedBox(height: 8.h),
            Text(
              l10n.onboardingDetectedCoords(
                _lat!.toStringAsFixed(4),
                _lng!.toStringAsFixed(4),
              ),
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRadiusStep() {
    final l10n = AppLocalizations.of(context);
    final enabled = _isStepEditable(3);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.onboardingRadiusQuestion,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 16.h),
        Center(
          child: Text(
            l10n.onboardingKmValue(_requestedRadiusKm.toStringAsFixed(1)),
            style: AppTypography.headlineLarge.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Slider(
          value: _requestedRadiusKm,
          min: 1,
          max: 25,
          divisions: 48,
          label: l10n.onboardingKmValue(_requestedRadiusKm.toStringAsFixed(1)),
          activeColor: AppColors.primary,
          onChanged: enabled
              ? (v) => setState(() => _requestedRadiusKm = v)
              : null,
        ),
        SizedBox(height: 24.h),
        Text(
          l10n.onboardingCapacityQuestion,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            ...[10, 20].map((preset) {
              final selected = _requestedDailyCapacity == preset;
              return Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: ChoiceChip(
                  label: Text('$preset'),
                  selected: selected,
                  onSelected: enabled
                      ? (_) => setState(() {
                          _requestedDailyCapacity = preset;
                          _capacityController.text = preset.toString();
                        })
                      : null,
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: selected ? AppColors.white : AppColors.textBlack,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }),
            Expanded(
              child: TextFormField(
                controller: _capacityController,
                enabled: enabled,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.onboardingCustomLabel,
                  isDense: true,
                ),
                onChanged: (v) {
                  final parsed = int.tryParse(v);
                  if (parsed != null && parsed > 0) {
                    _requestedDailyCapacity = parsed;
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDocumentsStep() {
    final l10n = AppLocalizations.of(context);
    final enabled = _isStepEditable(4);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.onboardingUploadDocumentsPrompt,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 16.h),
        _buildDocumentTile(
          title: l10n.onboardingOwnerIdentityTitle,
          documentType: 'owner_identity',
          uploaded: _hasOwnerIdentity,
          isUploading: _isUploadingOwnerIdentity,
          enabled: enabled,
        ),
        SizedBox(height: 12.h),
        _buildDocumentTile(
          title: l10n.onboardingShopPhotoTitle,
          documentType: 'shop_photo',
          uploaded: _hasShopPhoto,
          isUploading: _isUploadingShopPhoto,
          enabled: enabled,
        ),
        SizedBox(height: 12.h),
        _buildDocumentTile(
          title: l10n.onboardingServiceListTitle,
          documentType: 'service_list',
          uploaded: _hasServiceList,
          isUploading: _isUploadingServiceList,
          enabled: enabled,
        ),
      ],
    );
  }

  Widget _buildDocumentTile({
    required String title,
    required String documentType,
    required bool uploaded,
    required bool isUploading,
    required bool enabled,
  }) {
    final l10n = AppLocalizations.of(context);
    // A document that's already uploaded and not flagged for correction stays
    // locked — no need to re-upload it just because another section changed.
    final canModify = enabled || !uploaded;
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: uploaded
            ? AppColors.success.withOpacity(0.08)
            : AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppRadius.md.r),
        border: Border.all(
          color: uploaded
              ? AppColors.success.withOpacity(0.4)
              : AppColors.outline.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            uploaded ? Icons.check_circle_rounded : Icons.upload_file_rounded,
            color: uploaded ? AppColors.success : AppColors.primary,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              title,
              style: AppTypography.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          isUploading
              ? SizedBox(
                  width: 20.r,
                  height: 20.r,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                )
              : canModify
              ? TextButton(
                  onPressed: () => _pickAndUploadDocument(documentType),
                  child: Text(
                    uploaded
                        ? l10n.onboardingReplaceButton
                        : l10n.onboardingUploadButton,
                  ),
                )
              : Text(
                  l10n.onboardingUploadedLabel,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildReviewStep() {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.onboardingReviewPrompt,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 16.h),
        _reviewRow(l10n.onboardingReviewOwner, _ownerNameController.text),
        _reviewRow(l10n.onboardingBusinessNameLabel, _nameController.text),
        _reviewRow(
          l10n.profileAddressFieldLabel,
          '${_addressLine1Controller.text}, ${_cityController.text}, ${_stateController.text} ${_pincodeController.text}',
        ),
        _reviewRow(
          l10n.onboardingReviewServiceRadius,
          l10n.onboardingKmValue(_requestedRadiusKm.toStringAsFixed(1)),
        ),
        _reviewRow(
          l10n.onboardingReviewDailyCapacity,
          l10n.onboardingOrdersPerDay(_requestedDailyCapacity),
        ),
        _reviewRow(
          l10n.onboardingReviewOwnerIdentity,
          _hasOwnerIdentity
              ? l10n.onboardingUploadedLabel
              : l10n.onboardingMissingLabel,
        ),
        _reviewRow(
          l10n.onboardingReviewShopPhoto,
          _hasShopPhoto
              ? l10n.onboardingUploadedLabel
              : l10n.onboardingMissingLabel,
        ),
        _reviewRow(
          l10n.onboardingReviewServiceList,
          _hasServiceList
              ? l10n.onboardingUploadedLabel
              : l10n.onboardingMissingLabel,
        ),
      ],
    );
  }

  Widget _reviewRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value.isEmpty ? '—' : value,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(bool isDark) {
    final l10n = AppLocalizations.of(context);
    final isLastStep = _stepIndex == _kStepSectionKeys.length - 1;
    final isDocumentsStep = _stepIndex == 4;

    VoidCallback? onNext;
    if (!_isSaving) {
      onNext = switch (_stepIndex) {
        0 => _saveBusinessStep,
        1 => _saveOwnerStep,
        2 => _saveLocationStep,
        3 => _saveRadiusStep,
        4 => () {
          if (!_hasOwnerIdentity || !_hasShopPhoto || !_hasServiceList) {
            setState(
              () => _stepError = l10n.onboardingUploadDocumentsToContinue,
            );
            return;
          }
          setState(() {
            _stepIndex = 5;
            _stepError = null;
          });
        },
        _ => _submit,
      };
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 16.h),
      child: Row(
        children: [
          if (_stepIndex > 0)
            Expanded(
              child: SizedBox(
                height: 54.h,
                child: OutlinedButton(
                  onPressed: _isSaving
                      ? null
                      : () => setState(() => _stepIndex -= 1),
                  child: Text(l10n.onboardingBackButton),
                ),
              ),
            ),
          if (_stepIndex > 0) SizedBox(width: 12.w),
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 54.h,
              child: ElevatedButton(
                onPressed: onNext,
                child: _isSaving
                    ? SizedBox(
                        width: 24.r,
                        height: 24.r,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation(AppColors.white),
                        ),
                      )
                    : Text(
                        isLastStep
                            ? l10n.onboardingSubmitApplicationButton
                            : (isDocumentsStep
                                  ? l10n.riderContinueButton
                                  : l10n.onboardingNextButton),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
