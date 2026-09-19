import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/design/design_system.dart';
import '../../../../core/services/splash_diag.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../providers/auth_provider.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  bool _timerDone = false;

  @override
  void initState() {
    super.initState();
    splashDiag('splash_page_mounted');
    Future<void>.delayed(const Duration(milliseconds: 1500)).then((_) {
      if (mounted) {
        splashDiag('splash_timer_done');
        setState(() {
          _timerDone = true;
        });
        _checkNavigation();
      }
    });
  }

  void _checkNavigation() {
    if (!_timerDone) return;
    final state = ref.read(authProvider);
    if (state is AuthAuthenticated) {
      splashDiag('splash_navigate', {'to': 'dashboard'});
      context.go(AppRoutes.dashboard);
    } else if (state is AuthNeedsVendorApplication) {
      splashDiag('splash_navigate', {'to': 'profileSetup'});
      context.go(AppRoutes.profileSetup);
    } else if (state is AuthUnauthenticated || state is AuthError) {
      splashDiag('splash_navigate', {'to': 'login'});
      context.go(AppRoutes.login);
    } else {
      splashDiag('splash_still_waiting', {'state': state.runtimeType.toString()});
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen for state changes to navigate as soon as initialization completes
    ref.listen<AuthState>(authProvider, (previous, next) {
      _checkNavigation();
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary,
              AppColors.primary.withOpacity(0.8),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120.r,
                height: 120.r,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(32.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                // The real Partner app icon (the same asset the launcher
                // icon and native splash come from).
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32.r),
                  child: Image.asset(
                    'assets/images/logo/lndry_logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                AppLocalizations.of(context).splashAppName,
                style: AppTypography.headlineMedium.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                AppLocalizations.of(context).splashTagline,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.white.withOpacity(0.8),
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 64.h),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.white),
              ),
              // Temporary, for the splash-hang investigation (2026-09-16):
              // shows exactly which startup step the app is on, live, right
              // on screen — so a screenshot/video is readable with no
              // network round-trip needed. Remove alongside splash_diag.dart
              // once that investigation is closed.
              SizedBox(height: 24.h),
              ValueListenableBuilder<String>(
                valueListenable: splashDiagLastStep,
                builder: (context, step, _) => Text(
                  step,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.white.withOpacity(0.6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
