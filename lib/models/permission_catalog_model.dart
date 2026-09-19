/// One grantable permission in the owner's Permissions screen, e.g.
/// "Re-evaluation". [permissions] are the backend permission strings it stands
/// for — the app never invents or translates these; it stores exactly them.
class PermissionItem {
  const PermissionItem({
    required this.key,
    required this.label,
    required this.permissions,
  });

  factory PermissionItem.fromJson(Map<String, dynamic> json) => PermissionItem(
        key: json['key'] as String? ?? '',
        label: json['label'] as String? ?? '',
        permissions: (json['permissions'] as List<dynamic>? ?? const [])
            .map((e) => e.toString())
            .toList(),
      );

  /// Stable id (e.g. `orders.reevaluate`) — used to pick a translated label.
  final String key;

  /// English fallback label from the backend.
  final String label;
  final List<String> permissions;

  /// Whether a staff member holding [granted] has this item.
  bool isGrantedBy(Iterable<String> granted) {
    final set = granted is Set<String> ? granted : granted.toSet();
    return permissions.isNotEmpty && permissions.every(set.contains);
  }
}

/// A module (Orders, Catalogue, …) with the items an owner can toggle in it.
class PermissionModule {
  const PermissionModule({
    required this.key,
    required this.label,
    required this.items,
  });

  factory PermissionModule.fromJson(Map<String, dynamic> json) => PermissionModule(
        key: json['key'] as String? ?? '',
        label: json['label'] as String? ?? '',
        items: (json['items'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(PermissionItem.fromJson)
            .toList(),
      );

  final String key;
  final String label;
  final List<PermissionItem> items;
}

/// What an owner can grant staff — served by the backend
/// (`GET /vendor/employees/permission-catalog`), so the screen shows exactly
/// what the server enforces.
class PermissionCatalog {
  const PermissionCatalog({required this.modules});

  factory PermissionCatalog.fromJson(Map<String, dynamic> json) => PermissionCatalog(
        modules: (json['modules'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(PermissionModule.fromJson)
            .toList(),
      );

  final List<PermissionModule> modules;
}

/// The signed-in user's CURRENT access, worked out by the backend from the
/// roster (`GET /vendor/employees/me`) — not from the login token, so an
/// owner's change reaches a staff session without signing out.
class MyAccess {
  const MyAccess({
    this.loaded = false,
    this.role,
    this.isOwner = false,
    this.modules = const {},
    this.items = const {},
  });

  factory MyAccess.fromJson(Map<String, dynamic> json) => MyAccess(
        loaded: true,
        role: json['role'] as String?,
        isOwner: json['is_owner'] as bool? ?? false,
        modules: (json['allowed_modules'] as List<dynamic>? ?? const [])
            .map((e) => e.toString())
            .toSet(),
        items: (json['allowed_items'] as List<dynamic>? ?? const [])
            .map((e) => e.toString())
            .toSet(),
      );

  /// The owner: everything, no round trip needed.
  static const MyAccess owner = MyAccess(loaded: true, role: 'VENDOR_OWNER', isOwner: true);

  final bool loaded;
  final String? role;
  final bool isOwner;
  final Set<String> modules;
  final Set<String> items;

  bool get isStaff => role == 'VENDOR_STAFF';

  /// Whether the module (`orders`, `catalogue`, `inventory`, `slots`,
  /// `analytics`) is open to this user.
  bool canModule(String key) => isOwner || modules.contains(key);

  /// Whether a single catalog item (`orders.accept_reject`, …) is granted.
  bool can(String itemKey) => isOwner || items.contains(itemKey);
}
