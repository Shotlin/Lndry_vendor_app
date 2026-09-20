import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_provider.dart';
import '../router/vendor_router.dart';
import '../services/permission_prompter.dart';
import 'notification_router.dart';

/// Starts the notification router once the app router exists and nudges it
/// whenever the sign-in state changes (a waiting notification can then be
/// delivered, or the user sent to sign in first).
class NotificationBootstrap extends ConsumerStatefulWidget {
  const NotificationBootstrap({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<NotificationBootstrap> createState() =>
      _NotificationBootstrapState();
}

class _NotificationBootstrapState extends ConsumerState<NotificationBootstrap> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final router = ref.read(vendorRouterProvider);
      ref.read(notificationRouterProvider).start(router);
      router.routerDelegate.addListener(_maybePrompt);
      _maybePrompt();
    });
  }

  static const _notMainPaths = {
    '/', '/onboarding', '/login', '/otp', '/profile-setup',
    '/location-permission', '/map-address',
  };
  bool _prompted = false;

  /// After sign-in, on the first main screen: the phone's own permission
  /// dialogs (notifications, then location), one at a time. Each is asked at
  /// most once ever, so this is a no-op on every later launch.
  void _maybePrompt() {
    if (_prompted || !mounted) return;
    if (ref.read(authProvider) is! AuthAuthenticated) return;
    final path = ref.read(vendorRouterProvider).routeInformationProvider.value.uri.path;
    if (_notMainPaths.contains(path)) return;
    _prompted = true;
    ref.read(permissionPrompterProvider).runIfNeeded();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (_, __) {
      ref.read(notificationRouterProvider).tryConsume();
      _maybePrompt();
    });
    return widget.child;
  }
}
