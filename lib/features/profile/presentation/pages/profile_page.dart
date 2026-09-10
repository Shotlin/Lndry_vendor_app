import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/design/design_system.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/theme_provider.dart';
import '../../../../repositories/repositories.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();
  bool _isSaving = false;
  bool _isEditing = false;
  bool _isUploadingLogo = false;
  bool _isUploadingBanner = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _descriptionController.dispose();
    _addressLine1Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      try {
        await ref.read(authProvider.notifier).updateProfile(
              name: _nameController.text.trim(),
              email: _emailController.text.trim(),
              description: _descriptionController.text.trim(),
              addressLine1: _addressLine1Controller.text.trim(),
              city: _cityController.text.trim(),
              stateStr: _stateController.text.trim(),
              pincode: _pincodeController.text.trim(),
            );
        setState(() => _isEditing = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).profileUpdatedSnack),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).servicesFailedToSave('$e')),
              backgroundColor: AppColors.error,
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    }
  }

  // Logo card is a square (1:1). Banner is the portrait "side image" slot on
  // the real customer-facing vendor card (130.w x 180.h in Lndry_app's
  // vendor_details_page.dart) — locking the crop to that exact ratio means
  // whatever the vendor uploads fills that slot without distortion.
  static const _bannerAspectRatio = CropAspectRatio(ratioX: 13, ratioY: 18);

  Future<void> _pickAndUploadImage({required bool isLogo}) async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
    if (picked == null) return;
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    final cropTitle = isLogo ? l10n.profileCropLogoTitle : l10n.profileCropBannerTitle;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: picked.path,
      aspectRatio: isLogo
          ? const CropAspectRatio(ratioX: 1, ratioY: 1)
          : _bannerAspectRatio,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: cropTitle,
          toolbarColor: AppColors.primary,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: AppColors.primary,
          lockAspectRatio: true,
          cropStyle: isLogo ? CropStyle.circle : CropStyle.rectangle,
        ),
        IOSUiSettings(
          title: cropTitle,
          aspectRatioLockEnabled: true,
          resetAspectRatioEnabled: false,
        ),
      ],
    );
    if (croppedFile == null) return;
    final XFile file = XFile(croppedFile.path);

    setState(() {
      if (isLogo) {
        _isUploadingLogo = true;
      } else {
        _isUploadingBanner = true;
      }
    });
    try {
      final authState = ref.read(authProvider);
      if (authState is! AuthAuthenticated) return;
      final vendor = authState.vendor;

      final url = await ref.read(vendorRepositoryProvider).uploadImage(
            file,
            folder: isLogo ? 'vendor-logos' : 'vendor-banners',
          );
      await ref.read(authProvider.notifier).updateProfile(
            name: vendor.name,
            email: vendor.email ?? '',
            logoUrl: isLogo ? url : null,
            bannerUrl: isLogo ? null : url,
          );
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isLogo ? l10n.profileLogoUpdatedSnack : l10n.profileBannerUpdatedSnack),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).profileFailedUploadImage('$e')),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingLogo = false;
          _isUploadingBanner = false;
        });
      }
    }
  }

  Future<void> _logout() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.profileLogoutTitle),
        content: Text(l10n.profileLogoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.commonCancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white),
            child: Text(l10n.profileLogoutTitle),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(authProvider.notifier).logout();
      if (mounted) context.go(AppRoutes.login);
    }
  }

  Future<void> _publishToMarketplace() async {
    try {
      await ref.read(vendorRepositoryProvider).publishProfile();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).profilePublishedSnack)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).profileFailedToPublish('$e'))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    if (authState is! AuthAuthenticated) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final vendor = authState.vendor;

    if (!_isEditing) {
      _nameController.text = vendor.name;
      _emailController.text = vendor.email ?? '';
      _descriptionController.text = vendor.description;
      _addressLine1Controller.text = vendor.address.line1;
      _cityController.text = vendor.address.city;
      _stateController.text = vendor.address.state;
      _pincodeController.text = vendor.address.pincode;
    }

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.white,
        elevation: 0,
        title: Text(
          l10n.profilePageTitle,
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.white : AppColors.textBlack,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isEditing ? Icons.close_rounded : Icons.edit_rounded,
              color: AppColors.primary,
            ),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Profile Header Card ────────────────────────────────────────
            // Left/right split mirrors ListingVendorCard / vendor_details_page
            // in the customer app: logo+name+rating on the left, shop side
            // banner on the right (130.w, same slot as the customer-facing
            // card) so vendors see exactly what shoppers will see.
            Stack(
              children: [
                Container(
                  height: 190.h,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: AppElevation.medium,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(16.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    width: 52.r,
                                    height: 52.r,
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(14.r),
                                      image: (vendor.logoUrl != null &&
                                              vendor.logoUrl!.isNotEmpty)
                                          ? DecorationImage(
                                              image: NetworkImage(
                                                  vendor.logoUrl!),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                    child: (vendor.logoUrl == null ||
                                            vendor.logoUrl!.isEmpty)
                                        ? Icon(Icons.storefront_rounded,
                                            color: Colors.white, size: 26.r)
                                        : null,
                                  ),
                                  if (_isUploadingLogo)
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black
                                              .withValues(alpha: 0.45),
                                          borderRadius:
                                              BorderRadius.circular(14.r),
                                        ),
                                        child: const Center(
                                          child: SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2),
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (_isEditing && !_isUploadingLogo)
                                    Positioned(
                                      right: -4.w,
                                      bottom: -4.h,
                                      child: GestureDetector(
                                        onTap: () =>
                                            _pickAndUploadImage(isLogo: true),
                                        child: Container(
                                          padding: EdgeInsets.all(4.r),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(Icons.camera_alt_rounded,
                                              size: 14.r,
                                              color: AppColors.primary),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      vendor.name,
                                      style:
                                          AppTypography.titleLarge.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (vendor.isVerified) ...[
                                    SizedBox(width: 6.w),
                                    Icon(Icons.verified_rounded,
                                        color: Colors.amber, size: 18.r),
                                  ],
                                ],
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                vendor.phone,
                                style: AppTypography.bodySmall.copyWith(
                                    color: Colors.white.withValues(alpha: 0.8)),
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                children: [
                                  Icon(Icons.star_rounded,
                                      color: Colors.amber, size: 16.r),
                                  SizedBox(width: 4.w),
                                  Text(
                                    vendor.averageRating
                                            ?.toStringAsFixed(1) ??
                                        'N/A',
                                    style: AppTypography.bodyMedium.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Flexible(
                                    child: Text(
                                      ' (${vendor.reviewCount} reviews)',
                                      style: AppTypography.bodySmall.copyWith(
                                          color: Colors.white
                                              .withValues(alpha: 0.7)),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Shop side banner — tap to upload/replace while editing.
                      GestureDetector(
                        onTap: (_isEditing && !_isUploadingBanner)
                            ? () => _pickAndUploadImage(isLogo: false)
                            : null,
                        child: SizedBox(
                          width: 130.w,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              if (vendor.coverImageUrl != null &&
                                  vendor.coverImageUrl!.isNotEmpty)
                                Image.network(vendor.coverImageUrl!,
                                    fit: BoxFit.cover)
                              else
                                Container(
                                  color: Colors.white.withValues(alpha: 0.12),
                                  child: Center(
                                    child: Icon(
                                        Icons.add_photo_alternate_outlined,
                                        color:
                                            Colors.white.withValues(alpha: 0.8),
                                        size: 28.r),
                                  ),
                                ),
                              if (_isUploadingBanner)
                                Container(
                                  color: Colors.black.withValues(alpha: 0.45),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 2),
                                  ),
                                ),
                              if (_isEditing && !_isUploadingBanner)
                                Positioned(
                                  right: 8.w,
                                  bottom: 8.h,
                                  child: Container(
                                    padding: EdgeInsets.all(6.r),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.camera_alt_rounded,
                                        size: 16.r, color: AppColors.primary),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (vendor.isVerified)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20.r),
                          bottomLeft: Radius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        l10n.dashboardApprovedBadge,
                        style: AppTypography.badge.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            if (_isEditing) ...[
              SizedBox(height: 10.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline_rounded,
                      size: 14.r, color: AppColors.textSecondary),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      l10n.profileBestFitNote,
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ],
            SizedBox(height: 20.h),

            // ── Edit Form (conditional) ────────────────────────────────────
            if (_isEditing) ...[
              Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                        color: AppColors.outline.withValues(alpha: 0.15)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.profileEditBusinessDetails,
                          style: AppTypography.bodyLarge
                              .copyWith(fontWeight: FontWeight.bold)),
                      SizedBox(height: 16.h),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: l10n.profileBusinessNameLabel,
                          prefixIcon: const Icon(Icons.storefront_outlined),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? l10n.profileRequiredField : null,
                      ),
                      SizedBox(height: 12.h),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: l10n.profileBusinessEmailLabel,
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? l10n.profileRequiredField : null,
                      ),
                      SizedBox(height: 12.h),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: l10n.profileBusinessDescriptionLabel,
                          prefixIcon: const Icon(Icons.info_outline),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? l10n.profileRequiredField : null,
                      ),
                      SizedBox(height: 12.h),
                      TextFormField(
                        controller: _addressLine1Controller,
                        decoration: InputDecoration(
                          labelText: l10n.profileAddressLine1Label,
                          prefixIcon: const Icon(Icons.location_on_outlined),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? l10n.profileRequiredField : null,
                      ),
                      SizedBox(height: 12.h),
                      TextFormField(
                        controller: _cityController,
                        decoration: InputDecoration(
                          labelText: l10n.profileCityLabel,
                          prefixIcon: const Icon(Icons.location_city_outlined),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? l10n.profileRequiredField : null,
                      ),
                      SizedBox(height: 12.h),
                      TextFormField(
                        controller: _stateController,
                        decoration: InputDecoration(
                          labelText: l10n.profileStateLabel,
                          prefixIcon: const Icon(Icons.map_outlined),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? l10n.profileRequiredField : null,
                      ),
                      SizedBox(height: 12.h),
                      TextFormField(
                        controller: _pincodeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: l10n.profilePincodeLabel,
                          prefixIcon: const Icon(Icons.pin_drop_outlined),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? l10n.profileRequiredField : null,
                      ),
                      SizedBox(height: 12.h),
                      TextFormField(
                        initialValue: vendor.phone,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: l10n.profileVerifiedPhoneLabel,
                          prefixIcon: const Icon(Icons.phone_android_outlined),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.white,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                          ),
                          child: _isSaving
                              ? SizedBox(
                                  width: 20.r,
                                  height: 20.r,
                                  child: const CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2),
                                )
                              : Text(l10n.pricingSaveChangesButton),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],

            // ── Business Info (read-only view) ─────────────────────────────
            if (!_isEditing) ...[
              _InfoTile(
                icon: Icons.email_outlined,
                label: l10n.profileEmailLabel,
                value: vendor.email ?? l10n.profileNotSetValue,
                isDark: isDark,
              ),
              _InfoTile(
                icon: Icons.location_on_outlined,
                label: l10n.profileAddressFieldLabel,
                value:
                    '${vendor.address.line1}, ${vendor.address.city}, ${vendor.address.state} ${vendor.address.pincode}',
                isDark: isDark,
              ),
              if (vendor.description != null && vendor.description!.isNotEmpty)
                _InfoTile(
                  icon: Icons.info_outline_rounded,
                  label: l10n.profileBusinessDescriptionLabel,
                  value: vendor.description!,
                  isDark: isDark,
                ),
              SizedBox(height: 8.h),
            ],

            // ── Navigation Menu ────────────────────────────────────────────
            _buildSectionHeader(l10n.profileAccountSection, isDark),
            _buildMenuCard([
              _MenuTile(
                icon: Icons.notifications_outlined,
                label: l10n.notificationsPageTitle,
                subtitle: l10n.profileNotificationsSubtitle,
                onTap: () => context.push(AppRoutes.notifications),
                isDark: isDark,
              ),
              _MenuTile(
                icon: Icons.settings_outlined,
                label: l10n.settingsTitle,
                subtitle: l10n.profileSettingsSubtitle,
                onTap: () => context.push(AppRoutes.settings),
                isDark: isDark,
                isLast: true,
              ),
            ], isDark),
            SizedBox(height: 16.h),

            _buildSectionHeader(l10n.profileBusinessSection, isDark),
            _buildMenuCard([
              _MenuTile(
                icon: Icons.category_outlined,
                label: l10n.servicesPageTitle,
                subtitle: l10n.profileCatalogueSubtitle,
                onTap: () => context.push(AppRoutes.services),
                isDark: isDark,
              ),
              _MenuTile(
                icon: Icons.storefront_outlined,
                label: l10n.profilePublishLabel,
                subtitle: l10n.profilePublishSubtitle,
                onTap: () => _publishToMarketplace(),
                isDark: isDark,
              ),
              _MenuTile(
                icon: Icons.people_outlined,
                label: l10n.profileStaffLabel,
                subtitle: l10n.profileStaffSubtitle,
                onTap: () => context.push(AppRoutes.employees),
                isDark: isDark,
              ),
              _MenuTile(
                icon: Icons.two_wheeler_outlined,
                label: l10n.riderManagementPageTitle,
                subtitle: l10n.profileRiderSubtitle,
                onTap: () => context.push(AppRoutes.riderManagement),
                isDark: isDark,
              ),
              _MenuTile(
                icon: Icons.date_range_outlined,
                label: l10n.profileSlotsLabel,
                subtitle: l10n.profileSlotsSubtitle,
                onTap: () => context.push(AppRoutes.slots),
                isDark: isDark,
              ),
              _MenuTile(
                icon: Icons.inventory_2_outlined,
                label: l10n.profileInventoryLabel,
                subtitle: l10n.profileInventorySubtitle,
                onTap: () => context.push(AppRoutes.inventory),
                isDark: isDark,
                isLast: true,
              ),
            ], isDark),
            SizedBox(height: 16.h),

            _buildSectionHeader(l10n.profileSupportSection, isDark),
            _buildMenuCard([
              _MenuTile(
                icon: Icons.help_outline_rounded,
                label: l10n.profileHelpLabel,
                subtitle: l10n.profileHelpSubtitle,
                onTap: () => context.push(AppRoutes.help),
                isDark: isDark,
              ),
              _MenuTile(
                icon: Icons.info_outline_rounded,
                label: l10n.profileAboutLabel,
                subtitle: l10n.profileAboutSubtitle('1.0.0'),
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'LNDRY Vendor',
                    applicationVersion: '1.0.0',
                    applicationLegalese:
                        '© 2026 LNDRY Technologies Pvt. Ltd.',
                  );
                },
                isDark: isDark,
                isLast: true,
              ),
            ], isDark),
            SizedBox(height: 24.h),

            // ── Logout ────────────────────────────────────────────────────
            OutlinedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout_rounded),
              label: Text(l10n.profileLogoutTitle),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                padding: EdgeInsets.symmetric(vertical: 14.h),
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 8.h, top: 4.h),
      child: Text(
        title,
        style: AppTypography.bodySmall.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildMenuCard(List<Widget> children, bool isDark) {
    return Card(
      elevation: 0,
      color: isDark ? AppColors.darkSurface : AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(
            color: AppColors.outline.withValues(alpha: isDark ? 0.05 : 0.2)),
      ),
      child: Column(children: children),
    );
  }
}

// ── Helper widgets ─────────────────────────────────────────────────────────────

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
            color: AppColors.outline.withValues(alpha: isDark ? 0.05 : 0.15)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20.r, color: AppColors.primary),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary)),
                Text(value,
                    style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.white
                            : AppColors.textBlack)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
    required this.isDark,
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDark;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20.r),
          ),
          title: Text(label,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(subtitle,
              style: TextStyle(
                  fontSize: 11.sp, color: AppColors.textSecondary)),
          trailing:
              const Icon(Icons.arrow_forward_ios_rounded, size: 14),
          onTap: onTap,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        ),
        if (!isLast) const Divider(height: 1, indent: 60),
      ],
    );
  }
}
