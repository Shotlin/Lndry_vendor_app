import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../services/device_permissions.dart';

/// A small strip shown on the notifications screen — and only there, where it
/// is actually needed — when the phone has notifications switched off for this
/// app. It opens the app's Settings page (the system will not show its dialog
/// again once the user has answered), and disappears once they are back on.
class NotificationsOffBanner extends StatefulWidget {
  const NotificationsOffBanner({
    super.key,
    this.message = 'Notifications are turned off, so you will miss order updates.',
    this.actionLabel = 'Turn on',
  });

  final String message;
  final String actionLabel;

  @override
  State<NotificationsOffBanner> createState() => _NotificationsOffBannerState();
}

class _NotificationsOffBannerState extends State<NotificationsOffBanner>
    with WidgetsBindingObserver {
  bool _off = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Coming back from Settings: re-check so the strip clears itself.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refresh();
  }

  Future<void> _refresh() async {
    final status = await DevicePermissions.notifications();
    if (mounted) setState(() => _off = status != PermissionOutcome.granted);
  }

  @override
  Widget build(BuildContext context) {
    if (!_off) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.primaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.notifications_off_outlined, size: 18, color: scheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(widget.message, style: Theme.of(context).textTheme.bodySmall),
          ),
          TextButton(
            onPressed: Geolocator.openAppSettings,
            child: Text(widget.actionLabel),
          ),
        ],
      ),
    );
  }
}
