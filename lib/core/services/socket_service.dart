import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../config/env.dart';

/// Thin wrapper around the Socket.IO client, connecting to the same
/// backend server (`socketio.plugin.js`) the dashboard already uses.
///
/// Phase 3 of the rider-assignment initiative — a rider's session
/// connects on login so their device can receive a `job:offered` event
/// the moment a vendor broadcasts an order (see [job_offer_provider.dart]
/// for the app-level listener). Only works while the app is open or
/// backgrounded-but-alive; there is no push-when-fully-closed path yet
/// since Firebase credentials are still blank (see CLAUDE.md's "Known
/// incomplete state").
///
/// Also carries `order:status`/`order.created`/`notification` listeners
/// (added when a live-sync bug surfaced: a vendor-owner/vendor-staff
/// session never opened a socket at all before this, since `connect()`
/// used to only be called for a `VENDOR_RIDER` session — see
/// `job_offer_listener.dart`) so the vendor's own Orders list/dashboard
/// refreshes the instant a new order arrives or a customer responds to a
/// reconciliation, instead of only on manual pull-to-refresh.
class SocketService {
  io.Socket? _socket;

  bool get isConnected => _socket?.connected ?? false;

  void connect({
    required String token,
    required void Function(Map<String, dynamic> data) onJobOffered,
    void Function(Map<String, dynamic> data)? onOrderStatus,
    void Function(Map<String, dynamic> data)? onOrderCreated,
    void Function(Map<String, dynamic> data)? onNotification,
  }) {
    if (_socket != null) return;

    _socket = io.io(
      Env.socketBaseUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .disableAutoConnect()
          .build(),
    );

    _socket!
      ..onConnect((_) => debugPrint('[Socket] connected'))
      ..onConnectError((err) => debugPrint('[Socket] connect error: $err'))
      ..onError((err) => debugPrint('[Socket] error: $err'))
      ..onDisconnect((_) => debugPrint('[Socket] disconnected'))
      ..on('job:offered', (data) {
        if (data is Map) {
          onJobOffered(Map<String, dynamic>.from(data));
        }
      })
      ..on('order:status', (data) {
        if (data is Map) onOrderStatus?.call(Map<String, dynamic>.from(data));
      })
      ..on('order.created', (data) {
        if (data is Map) onOrderCreated?.call(Map<String, dynamic>.from(data));
      })
      ..on('notification', (data) {
        if (data is Map) onNotification?.call(Map<String, dynamic>.from(data));
      })
      ..connect();
  }

  void disconnect() {
    _socket?.clearListeners();
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }
}
