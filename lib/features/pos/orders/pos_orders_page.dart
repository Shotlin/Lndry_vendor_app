import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../models/pos/pos_counter_order_model.dart';
import '../../../models/pos/pos_order_model.dart';
import '../core/money.dart';
import '../core/pos_providers.dart';
import '../core/pos_widgets.dart';
import 'order_errors.dart';
import 'order_filter_sheet.dart';
import 'order_labels.dart';
import 'order_state.dart';
import 'orders_providers.dart';

/// Where the Orders screen starts: which tab or status group, and which extra filters (a Home tile sets these).
class OrdersPreset {
  const OrdersPreset(
      {this.tab = OrderTab.booked,
      this.scope = StatusScope.tab,
      this.filter = const OrderFilter(),
      this.label});
  final OrderTab tab;
  final StatusScope scope;
  final OrderFilter filter;

  /// Plain words for what is shown ("Express orders"), displayed above the list.
  final String? label;
}

/// Orders: Booked / In Process / Done tabs, search, filter, and moving several orders forward at once.
class PosOrdersPage extends ConsumerStatefulWidget {
  const PosOrdersPage({super.key, this.preset});
  final OrdersPreset? preset;

  @override
  ConsumerState<PosOrdersPage> createState() => _PosOrdersPageState();
}

class _PosOrdersPageState extends ConsumerState<PosOrdersPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs =
      TabController(length: OrderTab.values.length, vsync: this)
        ..addListener(_onTab);
  final _searchCtl = TextEditingController();
  Timer? _debounce;
  OrdersView _view = const OrdersView();
  String _search = '';
  String? _label;

  @override
  void initState() {
    super.initState();
    if (widget.preset != null) _apply(widget.preset!);
  }

  @override
  void didUpdateWidget(PosOrdersPage old) {
    super.didUpdateWidget(old);
    // A Home tile was tapped while this screen was already open: show what it asked for.
    if (widget.preset != null && !identical(widget.preset, old.preset)) {
      setState(() => _apply(widget.preset!));
    }
  }

  void _apply(OrdersPreset p) {
    _view = OrdersView(scope: p.scope, extras: p.filter);
    _label = p.label;
    _search = '';
    _searchCtl.clear();
    _tabs.index = p.tab.index;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _tabs.dispose();
    _searchCtl.dispose();
    super.dispose();
  }

  void _onTab() {
    if (!_tabs.indexIsChanging) setState(() {});
  }

  void _onSearch(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted && v.trim() != _search) setState(() => _search = v.trim());
    });
  }

  OrderFilter _filterFor(OrderTab t) =>
      _view.extras.copyWith(statuses: t.statuses, search: _search);
  OrderFilter get _scopeFilter => _view.extras
      .copyWith(statuses: _view.scope.statuses ?? const [], search: _search);
  bool get _byTabs => _view.scope == StatusScope.tab;
  OrderFilter get _current =>
      _byTabs ? _filterFor(OrderTab.values[_tabs.index]) : _scopeFilter;

  Future<void> _openFilter() async {
    final next = await showOrderFilterSheet(context, _view);
    if (next != null && mounted) {
      setState(() {
        _view = next;
        _label = null;
      });
    }
  }

  void _clearAll() {
    _searchCtl.clear();
    setState(() {
      _view = const OrdersView();
      _search = '';
      _label = null;
    });
  }

  Future<void> _moveSelected() async {
    final l10n = AppLocalizations.of(context);
    final ctl = ref.read(posOrdersListProvider(_current).notifier);
    final st = ref.read(posOrdersListProvider(_current));
    final chosen = st.items.where((o) => st.selected.contains(o.id)).toList();
    final anyReady =
        chosen.any((o) => nextStepOf(o)?.kind == NextStepKind.markReady);
    final anyDue = chosen.any((o) =>
        nextStepOf(o)?.kind == NextStepKind.deliver && o.balancePaise > 0);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => PosThemeScope(
        child: AlertDialog(
          title: Text(l10n.posBulkTitle(chosen.length)),
          content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.posBulkBody),
                if (anyReady) ...[
                  const SizedBox(height: 8),
                  Text(l10n.posBulkReadyNote)
                ],
                if (anyDue) ...[
                  const SizedBox(height: 8),
                  Text(l10n.posBulkDueNote)
                ],
              ]),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(l10n.posNotYet)),
            FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(l10n.posBulkGo)),
          ],
        ),
      ),
    );
    if (ok != true || !mounted) return;
    final r = await ctl.moveSelected();
    if (!mounted) return;
    ref.invalidate(posOrdersListProvider);
    ref.invalidate(posDashboardProvider);
    final msg = r.failed == 0 && r.moved > 0
        ? l10n.posBulkDone(r.moved)
        : r.moved > 0
            ? l10n.posBulkPartial(r.moved, r.failed + r.skippedDue)
            : r.failed > 0
                ? '${l10n.posBulkNone}\n${orderErrorText(r.firstError, l10n)}'
                : r.skippedDue > 0
                    ? l10n.posBulkSkipDue(r.skippedDue)
                    : l10n.posBulkNone;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(behavior: SnackBarBehavior.fixed, content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final canView = ref.watch(posCanViewOrdersProvider);
    final canProcess = ref.watch(posCanProcessOrdersProvider);
    if (!canView) {
      return Scaffold(
          appBar: AppBar(title: Text(l10n.posOrdersTitle)),
          body: Center(
              child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(l10n.posNoPermission,
                      textAlign: TextAlign.center))));
    }
    final current = ref.watch(posOrdersListProvider(_current));
    final ctl = ref.read(posOrdersListProvider(_current).notifier);
    final movable = current.items.where((o) => nextStepOf(o) != null).toList();
    final selectedCount = current.selected.length;
    final filtersOn =
        _view.activeCount > 0 || _search.isNotEmpty || _label != null;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.posOrdersTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: _searchCtl,
              onChanged: _onSearch,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: l10n.posOrdSearchHint,
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchCtl.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: l10n.posFilterReset,
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () {
                          _searchCtl.clear();
                          setState(() => _search = '');
                        },
                      ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            // A Wrap, not a Row: with large text the two controls go onto two lines instead of overflowing.
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 4,
              children: [
                OutlinedButton.icon(
                  onPressed: _openFilter,
                  icon: const Icon(Icons.tune_rounded),
                  label: Text(_view.activeCount > 0
                      ? '${l10n.posOrdFilter} (${_view.activeCount})'
                      : l10n.posOrdFilter),
                ),
                if (canProcess && movable.isNotEmpty)
                  InkWell(
                    onTap: () => current.selected.length == movable.length
                        ? ctl.clearSelection()
                        : ctl.selectAll(),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 48),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Checkbox(
                            value: current.selected.length == movable.length,
                            onChanged: (_) =>
                                current.selected.length == movable.length
                                    ? ctl.clearSelection()
                                    : ctl.selectAll()),
                        Flexible(child: Text(l10n.posOrdSelectAll)),
                        const SizedBox(width: 8),
                      ]),
                    ),
                  ),
              ],
            ),
          ),
          if (_label != null || !_byTabs)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: InputChip(
                  label: Text(l10n.posOrdFiltered(_label ?? _scopeText(l10n))),
                  onDeleted: _clearAll,
                  deleteButtonTooltipMessage: l10n.posOrdClearFilters,
                ),
              ),
            ),
          if (_byTabs)
            TabBar(
              controller: _tabs,
              tabs: [
                Tab(text: l10n.posOrdTabBooked),
                Tab(text: l10n.posOrdTabInProcess),
                Tab(text: l10n.posOrdTabDone)
              ],
            ),
          Expanded(
            child: _byTabs
                ? TabBarView(controller: _tabs, children: [
                    for (final t in OrderTab.values)
                      _OrdersList(
                          filter: _filterFor(t),
                          tab: t,
                          filtersOn: filtersOn,
                          onClear: _clearAll)
                  ])
                : _OrdersList(
                    filter: _scopeFilter,
                    tab: null,
                    filtersOn: filtersOn,
                    onClear: _clearAll),
          ),
          if (canProcess && selectedCount > 0)
            SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border(
                        top: BorderSide(
                            color: Theme.of(context).colorScheme.outline))),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(l10n.posOrdSelectedCount(selectedCount),
                            style: Theme.of(context).textTheme.titleSmall)),
                    FilledButton.icon(
                      onPressed: current.bulkBusy ? null : _moveSelected,
                      icon: current.bulkBusy
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.fast_forward_rounded),
                      label: Text(l10n.posOrdMoveNext),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _scopeText(AppLocalizations l10n) {
    switch (_view.scope) {
      case StatusScope.delivered:
        return l10n.posFilterDeliveredOnly;
      case StatusScope.cancelled:
        return l10n.posFilterCancelledOnly;
      default:
        return l10n.posFilterAllOrders;
    }
  }
}

class _OrdersList extends ConsumerWidget {
  const _OrdersList(
      {required this.filter,
      required this.tab,
      required this.filtersOn,
      required this.onClear});
  final OrderFilter filter;
  final OrderTab? tab;
  final bool filtersOn;
  final VoidCallback onClear;

  String _empty(AppLocalizations l10n) {
    if (filtersOn) return l10n.posOrdEmptyFiltered;
    switch (tab) {
      case OrderTab.booked:
        return l10n.posOrdEmptyBooked;
      case OrderTab.inProcess:
        return l10n.posOrdEmptyInProcess;
      case OrderTab.done:
        return l10n.posOrdEmptyDone;
      case null:
        return l10n.posOrdEmptyFiltered;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final st = ref.watch(posOrdersListProvider(filter));
    final ctl = ref.read(posOrdersListProvider(filter).notifier);
    final canProcess = ref.watch(posCanProcessOrdersProvider);

    if (st.loading) return const Center(child: CircularProgressIndicator());
    if (st.error != null) {
      return ListView(padding: const EdgeInsets.all(16), children: [
        PosErrorNote(
            message:
                '${l10n.posOrdLoadError}\n${orderErrorText(st.error, l10n)}',
            onRetry: ctl.retry,
            retryLabel: l10n.posRetry)
      ]);
    }
    return RefreshIndicator(
      onRefresh: ctl.refresh,
      child: st.items.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 40),
                Icon(Icons.assignment_outlined,
                    size: 56,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
                const SizedBox(height: 12),
                Text(_empty(l10n),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge),
                if (filtersOn)
                  Center(
                      child: TextButton(
                          onPressed: onClear,
                          child: Text(l10n.posOrdClearFilters))),
              ],
            )
          : NotificationListener<ScrollNotification>(
              onNotification: (n) {
                if (n.metrics.extentAfter < 500) ctl.loadMore();
                return false;
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: st.items.length + 1,
                itemBuilder: (context, i) {
                  if (i == st.items.length) {
                    if (st.loadingMore) {
                      return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()));
                    }
                    if (st.loadMoreError != null) {
                      return TextButton(
                          onPressed: ctl.loadMore,
                          child: Text(l10n.posOrdLoadMoreError));
                    }
                    return const SizedBox(height: 8);
                  }
                  final o = st.items[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: OrderCard(
                      order: o,
                      selected: st.selected.contains(o.id),
                      onSelect: canProcess && nextStepOf(o) != null
                          ? () => ctl.toggle(o.id)
                          : null,
                      onOpen: () =>
                          context.push(AppRoutes.posOrderDetailPath(o.id)),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

/// One order in the list: number, who, state, how much — tap to open, chevron to peek at the garments.
class OrderCard extends StatefulWidget {
  const OrderCard(
      {required this.order,
      required this.onOpen,
      super.key,
      this.selected = false,
      this.onSelect});
  final CounterOrder order;
  final bool selected;
  final VoidCallback? onSelect;
  final VoidCallback onOpen;

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final o = widget.order;
    final balance = o.balancePaise;
    return Semantics(
      container: true,
      label:
          '${o.orderNumber}, ${o.customer.displayName}, ${phaseLabel(l10n, o.phase)}, ${formatPaise(o.totalPaise)}',
      child: Material(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: widget.selected ? scheme.primary : scheme.outline,
                  width: widget.selected ? 2 : 1)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: widget.onOpen,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4, 10, 12, 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 48,
                        child: widget.onSelect == null
                            ? null
                            : Checkbox(
                                value: widget.selected,
                                onChanged: (_) => widget.onSelect!()),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Expanded(
                                  child: Text(o.orderNumber,
                                      style: text.titleMedium,
                                      overflow: TextOverflow.ellipsis)),
                              const SizedBox(width: 8),
                              Flexible(child: OrderStatusChip(order: o)),
                            ]),
                            const SizedBox(height: 4),
                            Text(
                                '${o.customer.displayName}${o.customer.name.trim().isEmpty ? '' : ' · ${o.customer.phone}'}',
                                style: text.bodyMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 8),
                            Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(formatPaise(o.totalPaise),
                                      style: text.titleSmall),
                                  if (o.status != 'CANCELLED')
                                    PosStatusChip(
                                        label: balance > 0
                                            ? l10n.posOrdBalanceDue(
                                                formatPaise(balance))
                                            : paymentStatusLabel(
                                                l10n, o.paymentStatus),
                                        tone: toneOfPayment(o.paymentStatus)),
                                  if (o.isExpress)
                                    PosStatusChip(
                                        label: l10n.posOrdExpress,
                                        tone: PosTone.danger,
                                        icon: Icons.bolt_rounded),
                                  if (o.deliveryMode != DeliveryMode.walkIn)
                                    PosStatusChip(
                                        label: deliveryModeLabel(
                                            l10n, o.deliveryMode),
                                        tone: PosTone.neutral,
                                        icon: o.deliveryMode ==
                                                DeliveryMode.homeDelivery
                                            ? Icons.local_shipping_rounded
                                            : Icons.directions_walk_rounded),
                                  if (!o.isClosed &&
                                      o.expectedDeliveryDate != null)
                                    Text(
                                        l10n.posOrdDue(dateText(
                                            context, o.expectedDeliveryDate)),
                                        style: text.bodySmall),
                                ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => setState(() => _open = !_open),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 40),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(children: [
                      Text(l10n.posOrdItemsCount(o.pieceCount),
                          style: text.labelLarge),
                      const Spacer(),
                      Icon(_open
                          ? Icons.expand_less_rounded
                          : Icons.expand_more_rounded),
                    ]),
                  ),
                ),
              ),
              if (_open)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Column(children: [
                    for (final i in o.items)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(children: [
                          Expanded(
                              child: Text(
                                  '${i.name} · ${i.serviceName} × ${i.qtyText}',
                                  style: text.bodyMedium)),
                          Text(formatPaise(i.amountPaise),
                              style: text.bodyMedium),
                        ]),
                      ),
                  ]),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
