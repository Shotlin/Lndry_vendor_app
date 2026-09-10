import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../repositories/repositories.dart';

class NotificationsNotifier extends StateNotifier<AsyncValue<List<NotificationModel>>> {
  NotificationsNotifier(this._repo) : super(const AsyncValue.loading()) {
    fetch();
  }

  final VendorRepository _repo;

  Future<void> fetch() async {
    try {
      final list = await _repo.getNotifications();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> markRead(String id) async {
    state.whenData((list) {
      state = AsyncValue.data(list.map((n) => n.id == id ? n.copyWith(isRead: true) : n).toList());
    });
    try {
      await _repo.markNotificationRead(id);
    } catch (_) {
      // Best-effort — local state already reflects the read state either way.
    }
  }

  Future<void> markAllRead() async {
    state.whenData((list) {
      state = AsyncValue.data(list.map((n) => n.copyWith(isRead: true)).toList());
    });
    try {
      await _repo.markAllNotificationsRead();
    } catch (_) {}
  }

  Future<void> remove(String id) async {
    state.whenData((list) {
      state = AsyncValue.data(list.where((n) => n.id != id).toList());
    });
    try {
      await _repo.deleteNotification(id);
    } catch (_) {}
  }
}

final notificationsProvider = StateNotifierProvider.autoDispose<
    NotificationsNotifier, AsyncValue<List<NotificationModel>>>((ref) {
  final repo = ref.watch(vendorRepositoryProvider);
  return NotificationsNotifier(repo);
});
