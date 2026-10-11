import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/pos/pos_counter_order_model.dart';
import '../../../models/pos/pos_order_model.dart';
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

/// Delivery date, how it reaches the customer, express and remarks — the only things the server lets an open order change.
Future<CounterOrder?> showEditOrderSheet(
        BuildContext context, CounterOrder order) =>
    showModalBottomSheet<CounterOrder>(
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
  late final TextEditingController _notes =
      TextEditingController(text: widget.order.notes ?? '');
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
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
        lastDate: now.add(const Duration(days: 365)));
    if (d != null && mounted) {
      setState(() => _date = DateFormat('yyyy-MM-dd').format(d));
    }
  }

  void _toggle(DeliveryMode m) =>
      setState(() => _mode = _mode == m ? DeliveryMode.walkIn : m);

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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.fixed, content: Text(l10n.posEditSaved)));
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
              Text(l10n.posEditTitle, style: text.titleLarge),
              const SizedBox(height: 4),
              Text(widget.order.orderNumber, style: text.bodyMedium),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                  onPressed: _busy ? null : _pickDate,
                  icon: const Icon(Icons.event_rounded),
                  label: Text(
                      '${l10n.posInfoDeliveryDate}: ${dateText(context, _date)}')),
              const SizedBox(height: 12),
              Wrap(spacing: 8, runSpacing: 8, children: [
                FilterChip(
                    label: Text(l10n.posOrdHomeDelivery),
                    avatar: const Icon(Icons.local_shipping_rounded, size: 18),
                    selected: _mode == DeliveryMode.homeDelivery,
                    onSelected: _busy
                        ? null
                        : (_) => _toggle(DeliveryMode.homeDelivery)),
                FilterChip(
                    label: Text(l10n.posOrdPickup),
                    avatar: const Icon(Icons.directions_walk_rounded, size: 18),
                    selected: _mode == DeliveryMode.pickup,
                    onSelected:
                        _busy ? null : (_) => _toggle(DeliveryMode.pickup)),
                FilterChip(
                    label: Text(l10n.posOrdExpress),
                    avatar: const Icon(Icons.bolt_rounded, size: 18),
                    selected: _express,
                    onSelected:
                        _busy ? null : (v) => setState(() => _express = v)),
              ]),
              const SizedBox(height: 12),
              TextField(
                  controller: _notes,
                  enabled: !_busy,
                  maxLength: 300,
                  maxLines: 3,
                  decoration: InputDecoration(labelText: l10n.posInfoNotes)),
              Text(l10n.posEditItemsNote, style: text.bodySmall),
              if (_error != null) ...[
                const SizedBox(height: 8),
                PosErrorNote(message: _error!)
              ],
              const SizedBox(height: 16),
              FilledButton(
                  onPressed: _busy ? null : _save,
                  child: _busy
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.5))
                      : Text(l10n.posEditSave)),
            ],
          ),
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
