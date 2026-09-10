import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../repositories/repositories.dart';

class ServicesNotifier extends StateNotifier<AsyncValue<List<ServiceModel>>> {
  ServicesNotifier(this._repo) : super(const AsyncValue.loading()) {
    fetchServices();
  }

  final VendorRepository _repo;

  Future<void> fetchServices({bool silent = false}) async {
    if (!silent && !state.hasValue) {
      state = const AsyncValue.loading();
    }
    try {
      final list = await _repo.getMyServices();
      state = AsyncValue.data(list);
    } catch (e, st) {
      if (!silent) {
        state = AsyncValue.error(e, st);
      }
    }
  }

  Future<void> addService(ServiceModel service) async {
    try {
      final created = await _repo.addService(service);
      state.whenData((currentList) {
        final idx = currentList.indexWhere((s) =>
            (s.id.isNotEmpty && s.id == created.id) ||
            (s.categoryId?.isNotEmpty == true &&
                s.categoryId == created.categoryId));
        if (idx != -1) {
          final updated = [...currentList];
          updated[idx] = created;
          state = AsyncValue.data(updated);
        } else {
          state = AsyncValue.data([...currentList, created]);
        }
      });
      await fetchServices(silent: true);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateService(ServiceModel service) async {
    try {
      final updatedService = await _repo.updateService(service);
      state.whenData((currentList) {
        final idx = currentList.indexWhere((s) =>
            (s.id.isNotEmpty && s.id == updatedService.id) ||
            (s.categoryId?.isNotEmpty == true &&
                s.categoryId == updatedService.categoryId));
        if (idx != -1) {
          final updated = [...currentList];
          updated[idx] = updatedService;
          state = AsyncValue.data(updated);
        }
      });
      await fetchServices(silent: true);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteService(String serviceId) async {
    try {
      state.whenData((currentList) {
        final updated = currentList.where((s) => s.id != serviceId).toList();
        state = AsyncValue.data(updated);
      });
      await _repo.deleteService(serviceId);
      await fetchServices(silent: true);
    } catch (e) {
      await fetchServices(silent: true);
      rethrow;
    }
  }

  Future<void> toggleAvailability(String serviceId, bool isAvailable) async {
    try {
      state.whenData((currentList) {
        final updated = currentList.map((s) {
          if (s.id == serviceId) {
            return s.copyWith(isAvailable: isAvailable);
          }
          return s;
        }).toList();
        state = AsyncValue.data(updated);
      });
      await _repo.toggleServiceAvailability(serviceId, isAvailable);
      await fetchServices(silent: true);
    } catch (e) {
      await fetchServices(silent: true);
      rethrow;
    }
  }
}

final servicesListProvider = StateNotifierProvider.autoDispose<
    ServicesNotifier, AsyncValue<List<ServiceModel>>>((ref) {
  final repo = ref.watch(vendorRepositoryProvider);
  return ServicesNotifier(repo);
});

/// Real service categories fetched from the backend (`GET /service-categories`)
/// — used to populate the "Add Service" category dropdown instead of the
/// hardcoded, non-existent UUIDs on the `ServiceCategory` enum.
final serviceCategoriesProvider =
    FutureProvider.autoDispose<List<CategoryModel>>((ref) {
  final repo = ref.watch(vendorRepositoryProvider);
  return repo.getServiceCategories();
});

/// Admin-published subcategories for a given category — the catalogue a
/// vendor picks from on the Pricing screen. Keyed (and cached) per category
/// so switching services within the same category doesn't refetch.
final garmentTypesForCategoryProvider = FutureProvider.autoDispose
    .family<List<GarmentTypeModel>, String>((ref, categoryId) {
  final repo = ref.watch(vendorRepositoryProvider);
  return repo.getGarmentTypes(categoryId);
});
