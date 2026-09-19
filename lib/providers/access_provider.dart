import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import '../repositories/repositories.dart';
import 'auth_provider.dart';

/// What the owner can grant staff, straight from the backend.
final permissionCatalogProvider = FutureProvider.autoDispose<PermissionCatalog>(
  (ref) => ref.watch(vendorRepositoryProvider).getPermissionCatalog(),
);

/// The signed-in user's current access (see [MyAccess]).
///
/// Owners have everything, so no request is needed. Staff start with nothing
/// open until the backend has said what they may use — the server enforces
/// the same rules on every request, so this only decides what to *show*.
/// A session whose role isn't known yet is treated permissively while the
/// backend answers, so an owner is never locked out by a slow network.
class MyAccessNotifier extends StateNotifier<MyAccess> {
  MyAccessNotifier(this._repo, {required String? shopRole, required bool signedIn})
      : _shopRole = shopRole,
        _signedIn = signedIn,
        super(_initial(shopRole, signedIn)) {
    refresh();
  }

  final VendorRepository _repo;
  final String? _shopRole;
  final bool _signedIn;

  static MyAccess _initial(String? shopRole, bool signedIn) {
    if (!signedIn || shopRole == 'VENDOR_OWNER') return MyAccess.owner;
    if (shopRole == 'VENDOR_STAFF') return const MyAccess(role: 'VENDOR_STAFF');
    if (shopRole == 'VENDOR_RIDER') return const MyAccess(loaded: true, role: 'VENDOR_RIDER');
    // Unknown role: open until the backend answers (the server still enforces).
    return const MyAccess(isOwner: true);
  }

  /// Re-reads the caller's access from the backend. Keeps what it had if the
  /// request fails, so a network blip never revokes (or grants) anything.
  Future<void> refresh() async {
    if (!_signedIn || _shopRole == 'VENDOR_OWNER' || _shopRole == 'VENDOR_RIDER') return;
    try {
      final access = await _repo.getMyAccess();
      if (mounted) state = access;
    } catch (_) {
      // Keep the current access.
    }
  }
}

final myAccessProvider = StateNotifierProvider<MyAccessNotifier, MyAccess>((ref) {
  final signedIn = ref.watch(authProvider.select((s) => s is AuthAuthenticated));
  final shopRole = ref.watch(
    authProvider.select((s) => s is AuthAuthenticated ? s.shopRole : null),
  );
  return MyAccessNotifier(
    ref.watch(vendorRepositoryProvider),
    shopRole: shopRole,
    signedIn: signedIn,
  );
});
