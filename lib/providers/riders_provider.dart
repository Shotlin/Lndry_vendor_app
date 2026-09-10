import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../repositories/repositories.dart';

class RidersNotifier extends StateNotifier<AsyncValue<List<EmployeeModel>>> {
  RidersNotifier(this._repo) : super(const AsyncValue.loading()) {
    fetchRiders();
  }

  final VendorRepository _repo;

  Future<void> fetchRiders() async {
    state = const AsyncValue.loading();
    try {
      final list = await _repo.getRiders();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addRider({required String name, required String phone}) async {
    await _repo.createRider(name: name, phone: phone);
    await fetchRiders();
  }

  Future<void> toggleActive(String id, bool isActive) async {
    // updateEmployee requires role/permissions too; riders have neither
    // editable, so pass through their fixed role and empty permissions.
    await _repo.updateEmployee(
      id,
      role: 'VENDOR_RIDER',
      permissions: const [],
      isActive: isActive,
    );
    await fetchRiders();
  }

  Future<void> removeRider(String id) async {
    await _repo.deleteEmployee(id);
    await fetchRiders();
  }
}

final ridersListProvider = StateNotifierProvider.autoDispose<
    RidersNotifier, AsyncValue<List<EmployeeModel>>>((ref) {
  final repo = ref.watch(vendorRepositoryProvider);
  return RidersNotifier(repo);
});
