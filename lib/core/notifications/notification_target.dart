/// Screens a push notification may open in the Partner app.
///
/// Vendors (owner / staff) and captains have different screens, so the
/// whitelist depends on the signed-in person's role. The backend already
/// resolves the route per role, but the app never trusts a payload: only routes
/// matching this list are opened.
abstract final class NotificationRoutes {
  static const _vendorExact = <String>{
    '/dashboard',
    '/orders',
    '/services',
    '/pricing',
    '/inventory',
    '/slots',
    '/analytics',
    '/employees',
    '/rider-management',
    '/profile',
    '/profile/notifications',
    '/profile/help',
    '/profile/settings',
  };

  static const _captainExact = <String>{
    '/rider/jobs',
    '/profile',
    '/profile/notifications',
    '/profile/help',
    '/profile/settings',
  };

  static final _vendorOrder = RegExp(r'^/orders/details/([A-Za-z0-9_-]{1,64})$');
  static final _captainJob = RegExp(r'^/rider/jobs/([A-Za-z0-9_-]{1,64})$');

  static const fallback = '/profile/notifications';

  static bool isCaptain(String? shopRole) => shopRole == 'VENDOR_RIDER';

  static bool isAllowed(String route, {String? shopRole}) {
    if (isCaptain(shopRole)) {
      return _captainExact.contains(route) || _captainJob.hasMatch(route);
    }
    return _vendorExact.contains(route) || _vendorOrder.hasMatch(route);
  }

  /// Maps a route meant for the other role onto this role's equivalent
  /// (an order for a vendor is a job for a captain), so an inbox item written
  /// for one screen set still lands somewhere sensible.
  static String forRole(String route, {String? shopRole}) {
    if (isCaptain(shopRole)) {
      final order = _vendorOrder.firstMatch(route);
      if (order != null) return '/rider/jobs/${order.group(1)}';
      if (route == '/orders' || route == '/dashboard') return '/rider/jobs';
    } else {
      final job = _captainJob.firstMatch(route);
      if (job != null) return '/orders/details/${job.group(1)}';
      if (route == '/rider/jobs') return '/orders';
    }
    return route;
  }

  /// The route for a logical link (`type` + params) for this role, or null.
  static String? forLink(String type, Map<String, String> params,
      {String? shopRole}) {
    final captain = isCaptain(shopRole);
    switch (type) {
      case 'home':
        return captain ? '/rider/jobs' : '/dashboard';
      case 'orders':
        return captain ? '/rider/jobs' : '/orders';
      case 'order_details':
      case 'order_tracking':
      case 'order_approval':
      case 'order_payment':
      case 'order_review':
      case 'rider_job':
        final id = params['orderId'];
        if (id == null || id.isEmpty) return captain ? '/rider/jobs' : '/orders';
        return captain ? '/rider/jobs/$id' : '/orders/details/$id';
      case 'notifications':
        return '/profile/notifications';
      case 'help':
        return '/profile/help';
      case 'profile':
        return '/profile';
      case 'route':
        return params['route'];
      default:
        return null;
    }
  }
}

/// What a tapped notification asks the app to do.
class NotificationTarget {
  const NotificationTarget({
    required this.type,
    required this.params,
    this.candidateRoute,
    this.deliveryId,
    this.notificationId,
    this.campaignId,
    this.messageId,
  });

  /// Logical destination (`order_details`, `notifications`, `none`, …).
  final String type;
  final Map<String, String> params;

  /// The route the backend resolved (unchecked until [routeFor] applies the
  /// signed-in person's whitelist).
  final String? candidateRoute;

  final String? deliveryId;
  final String? notificationId;
  final String? campaignId;
  final String? messageId;

  /// Identifies one delivered message, so a tap is handled exactly once even if
  /// the system hands the same message to the app twice.
  String get dedupeKey =>
      deliveryId ?? messageId ?? notificationId ?? '$type|${candidateRoute ?? ''}';

  bool get hasReportableId =>
      deliveryId != null || notificationId != null || campaignId != null;

  /// The safe route to open for the person with [shopRole], or null when this
  /// notification only opens the app.
  String? routeFor(String? shopRole) {
    var route = candidateRoute ??
        NotificationRoutes.forLink(type, params, shopRole: shopRole);
    if (route == null) return null;
    route = NotificationRoutes.forRole(route, shopRole: shopRole);
    return NotificationRoutes.isAllowed(route, shopRole: shopRole)
        ? route
        : NotificationRoutes.fallback;
  }

  /// Parses an FCM `data` map. Returns null when the message is not one of
  /// ours, so unrelated pushes are ignored.
  static NotificationTarget? fromData(
    Map<String, dynamic> data, {
    String? messageId,
  }) {
    String? s(String key) {
      final v = data[key];
      if (v == null) return null;
      final text = v.toString().trim();
      return text.isEmpty ? null : text;
    }

    final type = s('type');
    final deepLink = s('deepLink');
    if (type == null && deepLink == null && s('deliveryId') == null) {
      return null;
    }
    return NotificationTarget(
      type: type ?? 'none',
      params: {
        for (final k in const ['orderId', 'vendorId'])
          if (s(k) != null) k: s(k)!,
      },
      candidateRoute: deepLink,
      deliveryId: s('deliveryId'),
      notificationId: s('notificationId'),
      campaignId: s('campaignId'),
      messageId: messageId ?? s('messageId'),
    );
  }

  /// A destination that came from inside the app (e.g. an inbox item).
  static NotificationTarget? forRoute(String? route) {
    if (route == null || route.isEmpty) return null;
    return NotificationTarget(type: 'route', params: const {}, candidateRoute: route);
  }
}
