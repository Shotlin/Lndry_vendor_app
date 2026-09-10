import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../repositories/repositories.dart';

class RiderJobsNotifier extends StateNotifier<AsyncValue<List<RiderJobModel>>> {
  RiderJobsNotifier(this._repo) : super(const AsyncValue.loading()) {
    fetchJobs();
  }

  final VendorRepository _repo;

  Future<void> fetchJobs() async {
    state = const AsyncValue.loading();
    try {
      final list = await _repo.getRiderJobs();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final riderJobsListProvider = StateNotifierProvider.autoDispose<
    RiderJobsNotifier, AsyncValue<List<RiderJobModel>>>((ref) {
  final repo = ref.watch(vendorRepositoryProvider);
  return RiderJobsNotifier(repo);
});

/// Job detail, fetched fresh per order id.
final riderJobDetailProvider = FutureProvider.autoDispose
    .family<RiderJobModel, String>((ref, orderId) async {
  final repo = ref.watch(vendorRepositoryProvider);
  return repo.getRiderJobDetail(orderId);
});
