import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../core/network/friendly_error.dart';
import '../../../models/pos/pos_catalogue_model.dart';
import '../../../models/pos/pos_counter_order_model.dart';
import '../../../models/pos/pos_order_model.dart';
import '../booking/add_garment_price_sheet.dart' show unitLabelOf;
import '../booking/garment_grid.dart' show QtyStepper;
import '../core/money.dart';
import '../core/pos_image.dart';
import '../core/pos_providers.dart';
import '../core/pos_widgets.dart';
import 'order_errors.dart';
import 'order_labels.dart';
import 'orders_providers.dart';

// ── Cancel ────────────────────────────────────────────────────────────────

/// Asks why, then cancels. Returns the cancelled order (or `null` if the owner kept it).
Future<CounterOrder?> showCancelOrderSheet(
        BuildContext context, CounterOrder order) =>
    showModalBottomSheet<CounterOrder>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => PosThemeScope(child: CancelOrderSheet(order: order)),
    );

class CancelOrderSheet extends ConsumerStatefulWidget {
  const CancelOrderSheet({required this.order, super.key});
  final CounterOrder order;

  @override
  ConsumerState<CancelOrderSheet> createState() => _CancelOrderSheetState();
}

enum _Reason { mind, mistake, price, other }

class _CancelOrderSheetState extends ConsumerState<CancelOrderSheet> {
  _Reason? _reason;
  final _other = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _other.dispose();
    super.dispose();
  }

  String _text(AppLocalizations l) {
    switch (_reason) {
      case _Reason.mind:
        return l.posCancelReasonMind;
      case _Reason.mistake:
        return l.posCancelReasonMistake;
      case _Reason.price:
        return l.posCancelReasonPrice;
      case _Reason.other:
        return _other.text.trim();
      case null:
        return '';
    }
  }

  Future<void> _confirm() async {
    final l10n = AppLocalizations.of(context);
    if (_busy) return;
    final why = _text(l10n);
    if (why.length < 3) {
      setState(() => _error = l10n.posCancelOtherHint);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final o =
          await ref.read(posOrderActionsProvider).cancel(widget.order.id, why);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.fixed, content: Text(l10n.posCancelDone)));
      Navigator.of(context).pop(o);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = orderErrorText(e, l10n);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
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
              Text(l10n.posCancelTitle, style: text.titleLarge),
              const SizedBox(height: 4),
              Text('${widget.order.orderNumber} · ${l10n.posCancelBody}',
                  style: text.bodyMedium),
              const SizedBox(height: 16),
              Text(l10n.posCancelWhy, style: text.titleSmall),
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 8, children: [
                for (final r in _Reason.values)
                  ChoiceChip(
                    label: Text(switch (r) {
                      _Reason.mind => l10n.posCancelReasonMind,
                      _Reason.mistake => l10n.posCancelReasonMistake,
                      _Reason.price => l10n.posCancelReasonPrice,
                      _Reason.other => l10n.posCancelReasonOther,
                    }),
                    selected: _reason == r,
                    onSelected:
                        _busy ? null : (_) => setState(() => _reason = r),
                  ),
              ]),
              if (_reason == _Reason.other) ...[
                const SizedBox(height: 12),
                TextField(
                    controller: _other,
                    enabled: !_busy,
                    maxLength: 200,
                    decoration:
                        InputDecoration(hintText: l10n.posCancelOtherHint),
                    onChanged: (_) => setState(() {})),
              ],
              if (widget.order.amountPaidPaise > 0) ...[
                const SizedBox(height: 8),
                Text(l10n.posCancelRefundNote, style: text.bodySmall)
              ],
              if (_error != null) ...[
                const SizedBox(height: 8),
                PosErrorNote(message: _error!)
              ],
              const SizedBox(height: 16),
              FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                    foregroundColor: Theme.of(context).colorScheme.onError),
                onPressed: _busy || _text(l10n).length < 3 ? null : _confirm,
                child: _busy
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.5))
                    : Text(l10n.posCancelConfirm),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                  onPressed: _busy ? null : () => Navigator.of(context).pop(),
                  child: Text(l10n.posCancelKeep)),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Edit ──────────────────────────────────────────────────────────────────

/// Edit an open order like at the counter: delivery date, how it reaches the customer, express, remarks — and
/// the garments and services themselves (add, remove, change quantity), with the server's new price shown live.
Future<CounterOrder?> showEditOrderSheet(
  BuildContext context,
  CounterOrder order,
) => showModalBottomSheet<CounterOrder>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (_) => PosThemeScope(child: EditOrderSheet(order: order)),
);

class EditOrderSheet extends ConsumerStatefulWidget {
  const EditOrderSheet({required this.order, super.key});
  final CounterOrder order;

  @override
  ConsumerState<EditOrderSheet> createState() => _EditOrderSheetState();
}

class _EditOrderSheetState extends ConsumerState<EditOrderSheet> {
  late String? _date = widget.order.expectedDeliveryDate;
  late DeliveryMode _mode = widget.order.deliveryMode;
  late bool _express = widget.order.isExpress;
  late final TextEditingController _notes = TextEditingController(
    text: widget.order.notes ?? '',
  );
  late final List<CartLine> _initial = [
    for (final i in widget.order.items)
      CartLine(
        garmentId: i.garmentId,
        serviceId: i.serviceId,
        qty: i.qty.toDouble(),
      ),
  ];
  late List<CartLine> _lines = List.of(_initial);
  Timer? _debounce;
  OrderEditPreview? _preview;
  bool _previewing = false;
  String? _previewError;
  int _previewSeq = 0;
  bool _busy = false;
  String? _error;

  /// Garments can only change before processing starts, and only when the server sent the ids to match lines.
  bool get _canEditItems =>
      const {'BOOKED', 'PICKED_UP'}.contains(widget.order.status) &&
      widget.order.items.isNotEmpty &&
      widget.order.items.every(
        (i) => i.garmentId.isNotEmpty && i.serviceId.isNotEmpty,
      );

  bool get _itemsChanged {
    if (_lines.length != _initial.length) return true;
    for (final l in _lines) {
      final same = _initial.where((i) => i.matches(l.garmentId, l.serviceId));
      if (same.isEmpty || same.first.qty != l.qty) return true;
    }
    return false;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initial = DateTime.tryParse(_date ?? '') ?? now;
    final d = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(now) ? now : initial,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (d != null && mounted) {
      setState(() => _date = DateFormat('yyyy-MM-dd').format(d));
    }
  }

  void _toggle(DeliveryMode m) =>
      setState(() => _mode = _mode == m ? DeliveryMode.walkIn : m);

  void _setQty(CartLine line, double qty) {
    setState(() {
      _lines = [
        for (final l in _lines)
          if (!l.matches(line.garmentId, line.serviceId))
            l
          else if (qty > 0)
            l.withQty(qty),
      ];
    });
    _queuePreview();
  }

  Future<void> _addItem() async {
    final picked = await showModalBottomSheet<CartLine>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const PosThemeScope(child: _AddItemSheet()),
    );
    if (picked == null || !mounted) return;
    final existing = _lines.where(
      (l) => l.matches(picked.garmentId, picked.serviceId),
    );
    if (existing.isNotEmpty) {
      _setQty(existing.first, existing.first.qty + picked.qty);
    } else {
      setState(() => _lines = [..._lines, picked]);
      _queuePreview();
    }
  }

  /// Asks the server what the order would cost now. Nothing is saved by asking.
  void _queuePreview() {
    _debounce?.cancel();
    if (!_itemsChanged || _lines.isEmpty) {
      setState(() {
        _preview = null;
        _previewError = null;
        _previewing = false;
      });
      return;
    }
    setState(() => _previewing = true);
    final seq = ++_previewSeq;
    _debounce = Timer(const Duration(milliseconds: 450), () async {
      final l10n = AppLocalizations.of(context);
      try {
        final p = await ref
            .read(posOrderActionsProvider)
            .previewItems(widget.order.id, _lines);
        if (!mounted || seq != _previewSeq) return;
        setState(() {
          _preview = p;
          _previewError = null;
          _previewing = false;
        });
      } catch (e) {
        if (!mounted || seq != _previewSeq) return;
        setState(() {
          _preview = null;
          _previewError = orderErrorText(e, l10n);
          _previewing = false;
        });
      }
    });
  }

  bool get _canSave =>
      !_busy &&
      _lines.isNotEmpty &&
      (!_itemsChanged || (_preview != null && !_previewing));

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final o = widget.order;
    final edit = OrderEdit(
      expectedDeliveryDate: _date != o.expectedDeliveryDate ? _date : null,
      deliveryMode: _mode != o.deliveryMode ? _mode : null,
      isExpress: _express != o.isExpress ? _express : null,
      notes: _notes.text.trim() != (o.notes ?? '').trim()
          ? _notes.text.trim()
          : null,
      items: _itemsChanged ? _lines : null,
    );
    if (edit.isEmpty) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final r = await ref.read(posOrderActionsProvider).edit(o, edit);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.fixed,
          content: Text(l10n.posEditSaved),
        ),
      );
      Navigator.of(context).pop(r);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = orderErrorText(e, l10n);
      });
    }
  }

  Widget _itemRow(CartLine line, PosCatalogue? cat) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final saved = widget.order.items.where(
      (i) => i.garmentId == line.garmentId && i.serviceId == line.serviceId,
    );
    final garment = cat?.garment(line.garmentId);
    final name = saved.isNotEmpty ? saved.first.name : (garment?.name ?? '—');
    final service = saved.isNotEmpty
        ? saved.first.serviceName
        : (cat?.service(line.serviceId)?.name ?? '');
    final unit = saved.isNotEmpty
        ? saved.first.unit
        : (garment?.unit ?? 'piece');
    final rate = saved.isNotEmpty
        ? saved.first.ratePaise
        : cat?.priceOf(line.garmentId, line.serviceId)?.ratePaise;
    final decimal = !const {'piece', 'pc', 'pcs', 'pair'}.contains(unit);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
      decoration: BoxDecoration(
        border: Border.all(color: scheme.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: text.titleSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  [
                    if (service.isNotEmpty) service,
                    if (rate != null) formatPaise(rate),
                  ].join(' · '),
                  style: text.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: QtyStepper(
              qty: line.qty,
              name: name,
              decimal: decimal,
              unitLabel: unitLabelOf(l10n, unit),
              onChanged: (q) => _setQty(line, q),
            ),
          ),
          IconButton(
            tooltip: l10n.posBookRemoveLine(name),
            onPressed: _busy ? null : () => _setQty(line, 0),
            icon: Icon(Icons.delete_outline_rounded, color: scheme.error),
          ),
        ],
      ),
    );
  }

  Widget _priceBox() {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    if (!_itemsChanged) return const SizedBox.shrink();
    if (_lines.isEmpty) {
      return PosErrorNote(message: l10n.posEditKeepOne);
    }
    if (_previewError != null) {
      return PosErrorNote(
        message: '${l10n.posEditPriceFailed}\n$_previewError',
        onRetry: _queuePreview,
        retryLabel: l10n.posRetry,
      );
    }
    final p = _preview;
    if (p == null) {
      return const Padding(
        padding: EdgeInsets.all(8),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    final diff = p.differencePaise;
    final tone = diff > 0 ? PosTone.attention : PosTone.success;
    final colour = posToneColors(context, tone).fg;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: posToneColors(context, tone).bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.posEditNewTotal, style: text.labelLarge),
                Text(
                  formatPaise(p.totalPaise, alwaysShowPaise: true),
                  style: text.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colour,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                l10n.posEditWasTotal(
                  formatPaise(p.previousTotalPaise, alwaysShowPaise: true),
                ),
                style: text.bodySmall,
              ),
              if (diff != 0)
                Text(
                  diff > 0
                      ? l10n.posEditMore(
                          formatPaise(diff, alwaysShowPaise: true),
                        )
                      : l10n.posEditLess(
                          formatPaise(-diff, alwaysShowPaise: true),
                        ),
                  style: text.labelLarge?.copyWith(color: colour),
                ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final cat = ref.watch(posCatalogueProvider).valueOrNull;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 16,
          bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.posEditTitle, style: text.titleLarge),
              const SizedBox(height: 4),
              Text(widget.order.orderNumber, style: text.bodyMedium),
              const SizedBox(height: 16),
              Text(l10n.posEditItemsTitle, style: text.titleMedium),
              const SizedBox(height: 8),
              if (_canEditItems) ...[
                for (final line in _lines) _itemRow(line, cat),
                OutlinedButton.icon(
                  onPressed: _busy ? null : _addItem,
                  icon: const Icon(Icons.add_rounded),
                  label: Text(l10n.posEditAddItem),
                ),
                const SizedBox(height: 8),
                _priceBox(),
              ] else
                Text(l10n.posEditLocked, style: text.bodyMedium),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _busy ? null : _pickDate,
                icon: const Icon(Icons.event_rounded),
                label: Text(
                  '${l10n.posInfoDeliveryDate}: ${dateText(context, _date)}',
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilterChip(
                    label: Text(l10n.posOrdHomeDelivery),
                    avatar: const Icon(Icons.local_shipping_rounded, size: 18),
                    selected: _mode == DeliveryMode.homeDelivery,
                    onSelected: _busy
                        ? null
                        : (_) => _toggle(DeliveryMode.homeDelivery),
                  ),
                  FilterChip(
                    label: Text(l10n.posOrdPickup),
                    avatar: const Icon(Icons.directions_walk_rounded, size: 18),
                    selected: _mode == DeliveryMode.pickup,
                    onSelected: _busy
                        ? null
                        : (_) => _toggle(DeliveryMode.pickup),
                  ),
                  FilterChip(
                    label: Text(l10n.posOrdExpress),
                    avatar: const Icon(Icons.bolt_rounded, size: 18),
                    selected: _express,
                    onSelected: _busy
                        ? null
                        : (v) => setState(() => _express = v),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _notes,
                enabled: !_busy,
                maxLength: 300,
                maxLines: 3,
                decoration: InputDecoration(labelText: l10n.posInfoNotes),
              ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                PosErrorNote(message: _error!),
              ],
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _canSave ? _save : null,
                child: _busy
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      )
                    : Text(l10n.posEditSave),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pick a service, then a garment that has a shop price for it. Returns the line to add (quantity 1).
class _AddItemSheet extends ConsumerStatefulWidget {
  const _AddItemSheet();
  @override
  ConsumerState<_AddItemSheet> createState() => _AddItemSheetState();
}

class _AddItemSheetState extends ConsumerState<_AddItemSheet> {
  String? _serviceId;
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final async = ref.watch(posCatalogueProvider);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 16,
          bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: async.when(
          loading: () => const SizedBox(
            height: 160,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => PosErrorNote(
            message: friendlyError(e),
            onRetry: () => ref.invalidate(posCatalogueProvider),
            retryLabel: l10n.posRetry,
          ),
          data: (cat) {
            final services = cat.activeServices;
            final serviceId =
                _serviceId ?? (services.isEmpty ? null : services.first.id);
            final garments = cat.garmentsFor(
              serviceId: serviceId,
              search: _search,
            );
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.posEditAddTitle, style: text.titleLarge),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final s in services)
                      ChoiceChip(
                        label: Text(s.name),
                        selected: s.id == serviceId,
                        onSelected: (_) => setState(() => _serviceId = s.id),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  onChanged: (v) => setState(() => _search = v),
                  decoration: InputDecoration(
                    hintText: l10n.posBookSearchGarment,
                    prefixIcon: const Icon(Icons.search_rounded),
                  ),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: garments.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Text(
                              l10n.posEditNoneForService,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: garments.length,
                          itemBuilder: (_, i) {
                            final g = garments[i];
                            final price = cat.priceOf(g.id, serviceId!)!;
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: PosImage(
                                url: cat.imageOf(g),
                                name: g.name,
                                size: 44,
                              ),
                              title: Text(g.name),
                              subtitle: Text(
                                g.unit == 'piece'
                                    ? formatPaise(price.ratePaise)
                                    : '${formatPaise(price.ratePaise)} / ${unitLabelOf(l10n, g.unit)}',
                              ),
                              trailing: const Icon(Icons.add_circle_rounded),
                              onTap: () => Navigator.of(context).pop(
                                CartLine(
                                  garmentId: g.id,
                                  serviceId: serviceId,
                                  qty: 1,
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ── Assign captain ────────────────────────────────────────────────────────

Future<CounterOrder?> showAssignCaptainSheet(
        BuildContext context, CounterOrder order) =>
    showModalBottomSheet<CounterOrder>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => PosThemeScope(child: AssignCaptainSheet(order: order)),
    );

class AssignCaptainSheet extends ConsumerStatefulWidget {
  const AssignCaptainSheet({required this.order, super.key});
  final CounterOrder order;

  @override
  ConsumerState<AssignCaptainSheet> createState() => _AssignCaptainSheetState();
}

class _AssignCaptainSheetState extends ConsumerState<AssignCaptainSheet> {
  late String? _pickup = widget.order.pickupCaptain?.id;
  late String? _delivery = widget.order.deliveryCaptain?.id;
  bool _busy = false;
  String? _error;

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final o = widget.order;
    final pickup = _pickup != o.pickupCaptain?.id ? _pickup : null;
    final delivery = _delivery != o.deliveryCaptain?.id ? _delivery : null;
    if (pickup == null && delivery == null) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final r = await ref
          .read(posOrderActionsProvider)
          .assign(o.id, pickupCaptainId: pickup, deliveryCaptainId: delivery);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.fixed, content: Text(l10n.posAssignDone)));
      Navigator.of(context).pop(r);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = orderErrorText(e, l10n);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final captains = ref.watch(posCaptainsProvider);
    Widget picker(String label, String? value, ValueChanged<String?> onChanged,
            List<OrderCaptain> list) =>
        Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(label, style: text.titleSmall),
          const SizedBox(height: 6),
          DropdownButtonFormField<String?>(
            initialValue: list.any((c) => c.id == value) ? value : null,
            isExpanded: true,
            hint: Text(l10n.posInfoNotAssigned),
            items: [
              for (final c in list)
                DropdownMenuItem<String?>(
                    value: c.id,
                    child: Text(
                        c.name.isEmpty ? c.phone : '${c.name}  ${c.phone}',
                        overflow: TextOverflow.ellipsis))
            ],
            onChanged: _busy ? null : onChanged,
          ),
        ]);
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
              Text(l10n.posAssignTitle, style: text.titleLarge),
              const SizedBox(height: 4),
              Text(widget.order.orderNumber, style: text.bodyMedium),
              const SizedBox(height: 16),
              captains.when(
                loading: () => const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator())),
                error: (e, _) => PosErrorNote(
                    message: orderErrorText(e, l10n),
                    onRetry: () => ref.invalidate(posCaptainsProvider),
                    retryLabel: l10n.posRetry),
                data: (list) => list.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(l10n.posAssignNone, style: text.bodyLarge))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                            picker(l10n.posAssignPickup, _pickup,
                                (v) => setState(() => _pickup = v), list),
                            const SizedBox(height: 14),
                            picker(l10n.posAssignDelivery, _delivery,
                                (v) => setState(() => _delivery = v), list),
                          ]),
              ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                PosErrorNote(message: _error!)
              ],
              const SizedBox(height: 16),
              FilledButton(
                  onPressed: _busy || (captains.valueOrNull?.isEmpty ?? true)
                      ? null
                      : _save,
                  child: _busy
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.5))
                      : Text(l10n.posAssignSave)),
            ],
          ),
        ),
      ),
    );
  }
}
