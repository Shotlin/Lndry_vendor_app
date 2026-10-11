import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../api/repositories/api_pos_repositories.dart';
import '../../../models/pos/pos_counter_order_model.dart';
import '../../../repositories/abstract/pos_repositories.dart';
import '../core/pos_providers.dart';
import 'order_errors.dart';
import 'order_state.dart';

const int kOrdersPageSize = 30;

/// Opens a link outside the app (phone dialler, WhatsApp). A seam so tests do not need a phone.
final posUrlOpenerProvider = Provider<Future<bool> Function(Uri uri)>(
    (ref) => (uri) => launchUrl(uri, mode: LaunchMode.externalApplication));

/// One order with everything behind it. Re-read after every action — the app never guesses a new balance or status.
final posOrderDetailProvider = FutureProvider.autoDispose
    .family<OrderDetail, String>(
        (ref, id) => ref.watch(posOrdersRepositoryProvider).getOrder(id));

/// The shop's captains, for the "Assign captain" sheet.
final posCaptainsProvider = FutureProvider.autoDispose<List<OrderCaptain>>(
    (ref) => ref.watch(posOrdersRepositoryProvider).listCaptains());

final posOrderUnitsProvider = FutureProvider.autoDispose
    .family<List<GarmentUnit>, String>((ref, id) =>
        ref.watch(posOrdersRepositoryProvider).listGarmentUnits(id));

class OrdersListState {
  const OrdersListState({
    this.items = const [],
    this.loading = true,
    this.loadingMore = false,
    this.hasMore = false,
    this.error,
    this.loadMoreError,
    this.selected = const {},
    this.bulkBusy = false,
  });

  final List<CounterOrder> items;

  /// True until the first page arrived (or failed).
  final bool loading;
  final bool loadingMore;
  final bool hasMore;
  final Object? error;
  final Object? loadMoreError;
  final Set<String> selected;
  final bool bulkBusy;

  OrdersListState copyWith({
    List<CounterOrder>? items,
    bool? loading,
    bool? loadingMore,
    bool? hasMore,
    Object? error,
    bool clearError = false,
    Object? loadMoreError,
    bool clearLoadMoreError = false,
    Set<String>? selected,
    bool? bulkBusy,
  }) =>
      OrdersListState(
        items: items ?? this.items,
        loading: loading ?? this.loading,
        loadingMore: loadingMore ?? this.loadingMore,
        hasMore: hasMore ?? this.hasMore,
        error: clearError ? null : (error ?? this.error),
        loadMoreError:
            clearLoadMoreError ? null : (loadMoreError ?? this.loadMoreError),
        selected: selected ?? this.selected,
        bulkBusy: bulkBusy ?? this.bulkBusy,
      );
}

/// What a "Move to next step" did, so the screen can say it in words.
class BulkResult {
  const BulkResult(
      {required this.moved,
      required this.failed,
      required this.skippedDue,
      this.firstError});
  final int moved;
  final int failed;

  /// Orders left alone because they would be delivered with a balance due (never forced in bulk).
  final int skippedDue;
  final Object? firstError;
}

/// One page-by-page list of orders for a filter. The list is the server's; a page shorter than the page size is the end.
class OrdersListController extends StateNotifier<OrdersListState> {
  OrdersListController(this._repo, this.filter,
      {this.pageSize = kOrdersPageSize})
      : super(const OrdersListState()) {
    unawaited(_loadFirst());
  }

  final PosOrdersRepository _repo;
  final OrderFilter filter;
  final int pageSize;
  int _seq = 0;

  Future<void> _loadFirst() async {
    final seq = ++_seq;
    try {
      final page = await _repo.listOrders(filter, limit: pageSize, offset: 0);
      if (!mounted || seq != _seq) return;
      state = state.copyWith(
          items: page,
          loading: false,
          hasMore: page.length >= pageSize,
          clearError: true,
          clearLoadMoreError: true);
    } catch (e) {
      if (!mounted || seq != _seq) return;
      state = state.copyWith(loading: false, error: e);
    }
  }

  /// Pull-to-refresh: reads page one again and keeps the selection of orders that are still there.
  Future<void> refresh() async {
    final seq = ++_seq;
    try {
      final page = await _repo.listOrders(filter, limit: pageSize, offset: 0);
      if (!mounted || seq != _seq) return;
      final ids = page.map((o) => o.id).toSet();
      state = state.copyWith(
          items: page,
          loading: false,
          hasMore: page.length >= pageSize,
          clearError: true,
          clearLoadMoreError: true,
          selected: state.selected.where(ids.contains).toSet());
    } catch (e) {
      if (!mounted || seq != _seq) return;
      state = state.copyWith(
          loading: false,
          error: state.items.isEmpty ? e : null,
          loadMoreError: state.items.isEmpty ? null : e);
    }
  }

  Future<void> retry() async {
    state = state.copyWith(loading: true, clearError: true);
    await _loadFirst();
  }

  Future<void> loadMore() async {
    if (state.loading ||
        state.loadingMore ||
        !state.hasMore ||
        state.error != null) {
      return;
    }
    final seq = _seq;
    state = state.copyWith(loadingMore: true, clearLoadMoreError: true);
    try {
      final page = await _repo.listOrders(filter,
          limit: pageSize, offset: state.items.length);
      if (!mounted || seq != _seq) return;
      final known = state.items.map((o) => o.id).toSet();
      state = state.copyWith(
          items: [...state.items, ...page.where((o) => !known.contains(o.id))],
          loadingMore: false,
          hasMore: page.length >= pageSize);
    } catch (e) {
      if (!mounted || seq != _seq) return;
      state = state.copyWith(loadingMore: false, loadMoreError: e);
    }
  }

  // ── Selection ───────────────────────────────────────────────────────────

  void toggle(String id) {
    final next = {...state.selected};
    if (!next.remove(id)) next.add(id);
    state = state.copyWith(selected: next);
  }

  /// Selects every order that can still move forward (finished ones cannot).
  void selectAll() => state = state.copyWith(selected: {
        for (final o in state.items)
          if (nextStepOf(o) != null) o.id
      });
  void clearSelection() => state = state.copyWith(selected: const {});

  bool get allSelected {
    final movable = state.items
        .where((o) => nextStepOf(o) != null)
        .map((o) => o.id)
        .toSet();
    return movable.isNotEmpty && movable.every(state.selected.contains);
  }

  /// Moves each selected order ONE step. Never delivers an order that still owes money, and never goes past a step
  /// the server refuses — those are counted so the person can open them one by one.
  Future<BulkResult> moveSelected() async {
    state = state.copyWith(bulkBusy: true);
    var moved = 0, failed = 0, skippedDue = 0;
    Object? firstError;
    final updated = <String, CounterOrder>{};
    for (final o in state.items.where((o) => state.selected.contains(o.id))) {
      final step = nextStepOf(o);
      if (step == null) continue;
      if (step.kind == NextStepKind.deliver && o.balancePaise > 0) {
        skippedDue++;
        continue;
      }
      try {
        updated[o.id] = await _repo.transition(o.id, step.targetState,
            allowIncomplete: step.kind == NextStepKind.markReady,
            version: o.version);
        moved++;
      } catch (e) {
        failed++;
        firstError ??= e;
      }
    }
    if (!mounted) {
      return BulkResult(
          moved: moved,
          failed: failed,
          skippedDue: skippedDue,
          firstError: firstError);
    }
    state = state.copyWith(
      items: [for (final o in state.items) updated[o.id] ?? o],
      selected: const {},
      bulkBusy: false,
    );
    return BulkResult(
        moved: moved,
        failed: failed,
        skippedDue: skippedDue,
        firstError: firstError);
  }
}

final posOrdersListProvider = StateNotifierProvider.autoDispose
    .family<OrdersListController, OrdersListState, OrderFilter>(
  (ref, filter) =>
      OrdersListController(ref.watch(posOrdersRepositoryProvider), filter),
);

/// Everything that changes an order. After each change the order, every list and the Home numbers are re-read.
class OrderActions {
  OrderActions(this._ref);
  final Ref _ref;

  PosOrdersRepository get _repo => _ref.read(posOrdersRepositoryProvider);

  void _changed(String id) {
    _ref.invalidate(posOrderDetailProvider(id));
    _ref.invalidate(posOrderUnitsProvider(id));
    _ref.invalidate(posOrdersListProvider);
    _ref.invalidate(posDashboardProvider);
  }

  /// Re-reads everything about an order after an action whose outcome we could not see (a dropped connection).
  void reload(String id) => _changed(id);

  Future<CounterOrder> transition(CounterOrder o, NextStep step,
      {bool allowIncomplete = false, bool allowUnpaid = false}) async {
    try {
      final r = await _repo.transition(o.id, step.targetState,
          allowIncomplete: allowIncomplete,
          allowUnpaid: allowUnpaid,
          version: o.version);
      _changed(o.id);
      return r;
    } catch (e) {
      // Someone else moved it first: show the truth instead of the stale screen.
      if (errorCodeOf(e) == 'VERSION_CONFLICT') _changed(o.id);
      rethrow;
    }
  }

  Future<({CounterOrder order, List<OrderPayment> payments})> collectPayment(
      String id,
      {required int amountPaise,
      required String mode,
      String? reference}) async {
    try {
      final r = await _repo.collectPayment(id,
          amountPaise: amountPaise, mode: mode, reference: reference);
      _changed(id);
      return r;
    } catch (e) {
      // A dropped connection may still have recorded the payment: re-read before anyone taps again.
      if (isNetworkProblem(e)) _changed(id);
      rethrow;
    }
  }

  Future<CounterOrder> cancel(String id, String reason) async {
    final r = await _repo.cancel(id, reason);
    _changed(id);
    return r;
  }

  Future<CounterOrder> edit(CounterOrder o, OrderEdit edit) async {
    try {
      final r = await _repo.updateOrder(o.id, edit, version: o.version);
      _changed(o.id);
      return r;
    } catch (e) {
      if (errorCodeOf(e) == 'VERSION_CONFLICT') _changed(o.id);
      rethrow;
    }
  }

  Future<CounterOrder> assign(String id,
      {String? pickupCaptainId, String? deliveryCaptainId}) async {
    final r = await _repo.assignCaptain(id,
        pickupCaptainId: pickupCaptainId, deliveryCaptainId: deliveryCaptainId);
    _changed(id);
    return r;
  }
}

final posOrderActionsProvider =
    Provider<OrderActions>((ref) => OrderActions(ref));
