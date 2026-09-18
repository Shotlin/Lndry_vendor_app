import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/config.dart';
import 'core/router/vendor_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/tokens/breakpoints.dart';
import 'core/services/storage_service.dart';
import 'core/services/splash_diag.dart';
import 'core/widgets/job_offer_listener.dart';
import 'l10n/generated/app_localizations.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  splashDiag('main_start');

  final prefs = await SharedPreferences.getInstance();
  splashDiag('shared_prefs_ready');

  // Firebase is intentionally not initialised here — disabled at the
  // user's request (2026-09-16) after android/app/google-services.json's
  // placeholder project caused the app to hang on the splash screen on
  // some devices. Restore `await Firebase.initializeApp();` (wrapped in
  // try/catch, as it was before) once a real Firebase project's
  // google-services.json replaces the placeholder — and see
  // auth_provider.dart's _registerDeviceIfPossible for the matching FCM
  // re-enable step.

  splashDiag('run_app_called');
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        storageServiceProvider.overrideWithValue(StorageService(prefs: prefs)),
      ],
      child: const LndryVendorApp(),
    ),
  );
}

class LndryVendorApp extends ConsumerWidget {
  const LndryVendorApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(vendorRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    // Keep the static flag in sync with the resolved theme so
    // AppColors dynamic getters return the correct value.
    final systemIsDark =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    AppColors.isDarkMode = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system && systemIsDark);

    return ScreenUtilInit(
      designSize: const Size(
        AppBreakpoints.designWidth,
        AppBreakpoints.designHeight,
      ),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          key: ValueKey(themeMode),
          title: 'Lndry Partner',
          debugShowCheckedModeBanner: Env.showDebugBanner,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routerConfig: router,
          builder: (context, child) {
            return JobOfferListener(child: child ?? const SizedBox.shrink());
          },
        );
      },
    );
  }
}
