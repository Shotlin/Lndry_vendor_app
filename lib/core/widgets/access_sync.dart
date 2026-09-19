import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/access_provider.dart';

/// Keeps a staff session's access in step with what the owner has set.
///
/// The backend is the source of truth and checks every request; this just
/// re-reads "what am I allowed to open" when the app comes back to the
/// foreground and every minute while it's open, so a permission the owner
/// changes shows up (or disappears) without the staff member signing out.
class AccessSync extends ConsumerStatefulWidget {
  const AccessSync({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<AccessSync> createState() => _AccessSyncState();
}

class _AccessSyncState extends ConsumerState<AccessSync> with WidgetsBindingObserver {
  static const _interval = Duration(seconds: 60);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _timer = Timer.periodic(_interval, (_) => _refresh());
  }

  void _refresh() {
    final access = ref.read(myAccessProvider);
    // Owners never change; nothing to sync for them.
    if (!access.isOwner || !access.loaded) {
      ref.read(myAccessProvider.notifier).refresh();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refresh();
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watching keeps the notifier alive (and fetching) for the whole session.
    ref.watch(myAccessProvider);
    return widget.child;
  }
}
