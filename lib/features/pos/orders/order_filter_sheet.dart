import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/pos/pos_counter_order_model.dart';
import '../../../models/pos/pos_order_model.dart';
import '../core/pos_widgets.dart';
import 'order_labels.dart';

/// Which orders the list shows besides the three tabs.
enum StatusScope { tab, active, notCancelled, all, delivered, cancelled }

extension StatusScopeStatuses on StatusScope {
  /// Backend statuses for the scope; `null` for [StatusScope.tab] (the tab decides).
  List<String>? get statuses {
    switch (this) {
      case StatusScope.tab:
        return null;
      case StatusScope.active:
        return const [
          'BOOKED',
          'PICKED_UP',
          'IN_PROCESS',
          'READY',
          'OUT_FOR_DELIVERY'
        ];
      case StatusScope.notCancelled:
        return const [
          'BOOKED',
          'PICKED_UP',
          'IN_PROCESS',
          'READY',
          'OUT_FOR_DELIVERY',
          'DELIVERED'
        ];
      case StatusScope.all:
        return const [];
      case StatusScope.delivered:
        return const ['DELIVERED'];
      case StatusScope.cancelled:
        return const ['CANCELLED'];
    }
  }
}

/// What the filter sheet edits: the status scope and the extras (dates, delivery mode, express, balance due).
class OrdersView {
  const OrdersView(
      {this.scope = StatusScope.tab, this.extras = const OrderFilter()});
  final StatusScope scope;
  final OrderFilter extras;

  OrdersView copyWith({StatusScope? scope, OrderFilter? extras}) =>
      OrdersView(scope: scope ?? this.scope, extras: extras ?? this.extras);

  /// How many things differ from "the tab, no extras" — shown as a number on the Filter button.
  int get activeCount =>
      extras.activeExtras + (scope == StatusScope.tab ? 0 : 1);
}

Future<OrdersView?> showOrderFilterSheet(
    BuildContext context, OrdersView current) {
  return showModalBottomSheet<OrdersView>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => PosThemeScope(child: OrderFilterSheet(initial: current)),
  );
}

class OrderFilterSheet extends StatefulWidget {
  const OrderFilterSheet({required this.initial, super.key});
  final OrdersView initial;

  @override
  State<OrderFilterSheet> createState() => _OrderFilterSheetState();
}

class _OrderFilterSheetState extends State<OrderFilterSheet> {
  late OrdersView _v = widget.initial;

  static String _ymd(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

  Future<void> _pick({required bool from}) async {
    final now = DateTime.now();
    final current =
        DateTime.tryParse((from ? _v.extras.from : _v.extras.to) ?? '') ?? now;
    final d = await showDatePicker(
        context: context,
        initialDate: current,
        firstDate: DateTime(now.year - 3),
        lastDate: DateTime(now.year + 1));
    if (d == null || !mounted) return;
    final iso = _ymd(d);
    setState(() => _v = _v.copyWith(
        extras: from
            ? _v.extras.copyWith(from: iso)
            : _v.extras.copyWith(to: iso)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final e = _v.extras;
    Widget title(String t) => Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 8),
        child: Semantics(header: true, child: Text(t, style: text.titleSmall)));

    Widget scopeChip(StatusScope s, String label) => ChoiceChip(
        label: Text(label),
        selected: _v.scope == s,
        onSelected: (_) => setState(() => _v = _v.copyWith(scope: s)));
    Widget modeChip(DeliveryMode? m, String label) => ChoiceChip(
        label: Text(label),
        selected: e.deliveryMode == m,
        onSelected: (_) => setState(() => _v = _v.copyWith(
            extras: m == null
                ? e.copyWith(clearMode: true)
                : e.copyWith(deliveryMode: m))));

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 16,
            bottom: 16 + MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(l10n.posFilterTitle, style: text.titleLarge)),
                  TextButton(
                      onPressed: () => setState(() => _v = const OrdersView()),
                      child: Text(l10n.posFilterReset)),
                ],
              ),
              title(l10n.posFilterStatus),
              Wrap(spacing: 8, runSpacing: 8, children: [
                scopeChip(StatusScope.tab, l10n.posFilterThisTab),
                scopeChip(StatusScope.all, l10n.posFilterAllOrders),
                scopeChip(StatusScope.delivered, l10n.posFilterDeliveredOnly),
                scopeChip(StatusScope.cancelled, l10n.posFilterCancelledOnly),
              ]),
              title(l10n.posFilterDates),
              Row(children: [
                Expanded(
                    child: OutlinedButton.icon(
                        onPressed: () => _pick(from: true),
                        icon: const Icon(Icons.event_rounded),
                        label: Text(
                            '${l10n.posFilterFrom}: ${e.from == null ? l10n.posFilterAnyDate : dateText(context, e.from)}'))),
                const SizedBox(width: 8),
                Expanded(
                    child: OutlinedButton.icon(
                        onPressed: () => _pick(from: false),
                        icon: const Icon(Icons.event_rounded),
                        label: Text(
                            '${l10n.posFilterTo}: ${e.to == null ? l10n.posFilterAnyDate : dateText(context, e.to)}'))),
              ]),
              if (e.from != null || e.to != null)
                Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextButton(
                        onPressed: () => setState(() => _v =
                            _v.copyWith(extras: e.copyWith(clearDates: true))),
                        child: Text(l10n.posFilterAnyDate))),
              title(l10n.posFilterDelivery),
              Wrap(spacing: 8, runSpacing: 8, children: [
                modeChip(null, l10n.posFilterAnyDelivery),
                modeChip(DeliveryMode.homeDelivery, l10n.posOrdHomeDelivery),
                modeChip(DeliveryMode.pickup, l10n.posOrdPickup),
                modeChip(DeliveryMode.walkIn, l10n.posOrdWalkIn),
              ]),
              const SizedBox(height: 8),
              SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.posFilterExpressOnly),
                  value: e.express,
                  onChanged: (v) => setState(
                      () => _v = _v.copyWith(extras: e.copyWith(express: v)))),
              SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.posFilterDueOnly),
                  value: e.paymentDue,
                  onChanged: (v) => setState(() =>
                      _v = _v.copyWith(extras: e.copyWith(paymentDue: v)))),
              const SizedBox(height: 12),
              FilledButton(
                  onPressed: () => Navigator.of(context).pop(_v),
                  child: Text(l10n.posFilterApply)),
            ],
          ),
        ),
      ),
    );
  }
}
