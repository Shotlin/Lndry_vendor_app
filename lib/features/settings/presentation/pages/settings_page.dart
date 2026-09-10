import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design/design_system.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../providers/locale_provider.dart';

const _hinglishLocale = Locale.fromSubtags(languageCode: 'hi', scriptCode: 'Latn');

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _pushNotifications = true;
  bool _soundAlerts = true;
  bool _autoAcceptOrders = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: isDark ? AppColors.white : AppColors.textBlack),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.settingsTitle,
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.white : AppColors.textBlack,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.r),
        children: [
          // ── Language ──────────────────────────────────────────────────────
          _buildSectionHeader(l10n.settingsLanguageTitle),
          _buildSettingsCard([
            ListTile(
              leading: const Icon(Icons.language_rounded, color: AppColors.primary),
              title: Text(l10n.settingsLanguageTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(_languageLabel(locale)),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () => _showLanguagePicker(context, locale),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
            ),
          ], isDark),
          SizedBox(height: 24.h),

          // ── Notifications ─────────────────────────────────────────────────
          _buildSectionHeader(l10n.settingsNotificationsSection),
          _buildSettingsCard([
            SwitchListTile(
              title: Text(l10n.settingsPushNotifications,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(l10n.settingsPushNotificationsSubtitle),
              value: _pushNotifications,
              onChanged: (val) =>
                  setState(() => _pushNotifications = val),
              activeColor: AppColors.primary,
              secondary: const Icon(Icons.notifications_outlined,
                  color: AppColors.primary),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
            ),
            const Divider(height: 1),
            SwitchListTile(
              title: Text(l10n.settingsSoundAlerts,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(l10n.settingsSoundAlertsSubtitle),
              value: _soundAlerts,
              onChanged: (val) => setState(() => _soundAlerts = val),
              activeColor: AppColors.primary,
              secondary: const Icon(Icons.volume_up_outlined,
                  color: AppColors.primary),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
            ),
          ], isDark),
          SizedBox(height: 24.h),

          // ── Operations ────────────────────────────────────────────────────
          _buildSectionHeader(l10n.settingsOperationsSection),
          _buildSettingsCard([
            SwitchListTile(
              title: Text(l10n.settingsAutoAcceptOrders,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(l10n.settingsAutoAcceptOrdersSubtitle),
              value: _autoAcceptOrders,
              onChanged: (val) =>
                  setState(() => _autoAcceptOrders = val),
              activeColor: AppColors.primary,
              secondary: const Icon(Icons.auto_awesome_outlined,
                  color: AppColors.primary),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
            ),
          ], isDark),
          SizedBox(height: 24.h),

          // ── Support & Legal ───────────────────────────────────────────────
          _buildSectionHeader(l10n.settingsSupportLegalSection),
          _buildSettingsCard([
            ListTile(
              leading: const Icon(Icons.help_outline_rounded,
                  color: AppColors.primary),
              title: Text(l10n.settingsPartnerHelpdesk,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(l10n.settingsPartnerHelpdeskSubtitle),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.settingsConnectingHelpdesk)),
                );
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.description_outlined,
                  color: AppColors.primary),
              title: Text(l10n.settingsTermsOfService,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.settingsOpeningTerms)),
                );
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.security_outlined,
                  color: AppColors.primary),
              title: Text(l10n.settingsPrivacyPolicy,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.settingsOpeningPrivacy)),
                );
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
            ),
          ], isDark),
          SizedBox(height: 32.h),

          Center(
            child: Text(
              l10n.settingsFooter('1.0.0'),
              style: AppTypography.bodySmall
                  .copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  String _languageLabel(Locale locale) {
    if (locale.scriptCode == 'Latn') return 'Hinglish';
    if (locale.languageCode == 'hi') return 'हिंदी';
    return 'English';
  }

  Future<void> _showLanguagePicker(BuildContext context, Locale current) {
    return AppBottomSheet.show<void>(
      context: context,
      title: AppLocalizations.of(context).settingsLanguageTitle,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _languageOption(context, label: 'English', locale: const Locale('en'), current: current),
          _languageOption(context, label: 'हिंदी', locale: const Locale('hi'), current: current),
          _languageOption(context, label: 'Hinglish', locale: _hinglishLocale, current: current),
        ],
      ),
    );
  }

  Widget _languageOption(
    BuildContext context, {
    required String label,
    required Locale locale,
    required Locale current,
  }) {
    final isSelected = current == locale;
    return ListTile(
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: AppColors.primary) : null,
      onTap: () {
        ref.read(localeProvider.notifier).setLocale(locale);
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
      child: Text(
        title,
        style: AppTypography.bodyMedium.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children, bool isDark) {
    return Card(
      elevation: 0,
      color: isDark ? AppColors.darkSurface : AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(
          color: AppColors.outline.withValues(alpha: isDark ? 0.05 : 0.2),
        ),
      ),
      child: Column(children: children),
    );
  }
}
