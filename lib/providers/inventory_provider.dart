import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import '../repositories/repositories.dart';

/// The vendor's operational supplies, held by the server.
///
/// Every change goes to the backend; what is shown is always what the server
/// says. A +/− tap is shown at once so it feels instant, then replaced by the
/// server's answer — and if the server refuses, the list goes back to what the
/// server holds and the error is thrown to the caller to tell the person.
class InventoryNotifier extends StateNotifier<AsyncValue<List<InventoryItem>>> {
  InventoryNotifier(this._repo) : super(const AsyncValue.loading()) {
    fetch();
  }

  final VendorRepository _repo;

  /// Adjustments sent but not yet answered, per item. While there are any, a
  /// slower earlier answer must not overwrite a newer tap.
  final Map<String, int> _inFlight = {};

  Future<void> fetch() async {
    state = const AsyncValue.loading();
    try {
      state = AsyncValue.data(await _repo.getInventory());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> create({
    required String name,
    required int quantity,
    required int minThreshold,
    required String unit,
  }) async {
    final item = await _repo.createInventoryItem(
      name: name,
      quantity: quantity,
      minThreshold: minThreshold,
      unit: unit,
    );
    final current = state.valueOrNull ?? const <InventoryItem>[];
    state = AsyncValue.data([...current, item]);
  }

  Future<void> adjust(String id, int delta) async {
    final before = state.valueOrNull;
    if (before == null) return;
    final index = before.indexWhere((i) => i.id == id);
    if (index < 0) return;
    // The server never goes below zero, so neither does what is shown.
    final shown = (before[index].quantity + delta).clamp(0, 1 << 30);
    if (shown == before[index].quantity) return;
    _replace(before[index].copyWith(quantity: shown));
    _inFlight[id] = (_inFlight[id] ?? 0) + 1;
    try {
      final saved = await _repo.adjustInventoryQuantity(id, delta);
      _inFlight[id] = (_inFlight[id] ?? 1) - 1;
      if ((_inFlight[id] ?? 0) <= 0) {
        _inFlight.remove(id);
        _replace(saved);
      }
    } catch (_) {
      _inFlight[id] = (_inFlight[id] ?? 1) - 1;
      if ((_inFlight[id] ?? 0) <= 0) _inFlight.remove(id);
      // Show what the server really holds, not a guess.
      try {
        state = AsyncValue.data(await _repo.getInventory());
      } catch (_) {
        _replace(before[index]);
      }
      rethrow;
    }
  }

  void _replace(InventoryItem item) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncValue.data([for (final i in current) i.id == item.id ? item : i]);
  }
}

final inventoryProvider =
    StateNotifierProvider.autoDispose<InventoryNotifier, AsyncValue<List<InventoryItem>>>((ref) {
  return InventoryNotifier(ref.watch(vendorRepositoryProvider));
});
