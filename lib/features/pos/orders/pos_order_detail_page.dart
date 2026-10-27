import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../models/pos/pos_counter_order_model.dart';
import '../../../models/pos/pos_order_model.dart';
import '../../../providers/app_mode_provider.dart';
import '../core/money.dart';
import '../core/pos_providers.dart';
import '../core/pos_widgets.dart';
import 'order_errors.dart';
import 'order_labels.dart';
import 'order_sheets.dart';
import 'order_state.dart';
import 'order_timeline.dart';
import 'orders_providers.dart';
import 'payment_sheet.dart';
import 'whatsapp.dart';

/// One order: who, what state, what to do next, how much is paid, the garments.
class PosOrderDetailPage extends ConsumerStatefulWidget {
  const PosOrderDetailPage({required this.orderId, super.key});
  final String orderId;

  @override
  ConsumerState<PosOrderDetailPage> createState() => _PosOrderDetailPageState();
}

class _PosOrderDetailPageState extends ConsumerState<PosOrderDetailPage>
    with WidgetsBindingObserver {
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Coming back to the app (after a call, WhatsApp, a payment app) shows the order as it is now.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(posOrderActionsProvider).reload(widget.orderId);
    }
  }

  void _say(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
          SnackBar(behavior: SnackBarBehavior.fixed, content: Text(message)));
  }

  Future<bool?> _confirm(
          {required String title,
          required String body,
          required String yes,
          required String no}) =>
      showDialog<bool>(
        context: context,
        builder: (dialogContext) => PosThemeScope(
          child: AlertDialog(
            title: Text(title),
            content: Text(body),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: Text(no)),
              FilledButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: Text(yes)),
            ],
          ),
        ),
      );

  /// Delivering something that still owes money: collect first, or say so out loud and deliver anyway.
  /// Returns `true` to deliver with the balance due, `false`/`null` to stop.
  Future<bool?> _askDeliverDue(CounterOrder o) async {
    final l10n = AppLocalizations.of(context);
    final choice = await showDialog<String>(
      context: context,
      builder: (dialogContext) => PosThemeScope(
        child: AlertDialog(
          title: Text(l10n.posDeliverDueTitle(
              formatPaise(o.balancePaise, alwaysShowPaise: true))),
          content: Text(l10n.posDeliverDueBody),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(dialogContext).pop('deliver'),
                child: Text(l10n.posDeliverAnyway)),
            FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop('collect'),
                child: Text(l10n.posCollectFirst)),
          ],
        ),
      ),
    );
    if (choice == 'collect') {
      await _pay(o);
      return false;
    }
    return choice == 'deliver';
  }

  Future<void> _advance(CounterOrder o) async {
    if (_busy) return;
    final l10n = AppLocalizations.of(context);
    final step = nextStepOf(o);
    if (step == null) return;
    var allowUnpaid = false;
    if (step.kind == NextStepKind.deliver && o.balancePaise > 0) {
      if (await _askDeliverDue(o) != true) return;
      allowUnpaid = true;
    }
    setState(() => _busy = true);
    try {
      final actions = ref.read(posOrderActionsProvider);
      CounterOrder moved;
      try {
        moved = await actions.transition(o, step, allowUnpaid: allowUnpaid);
      } catch (e) {
        // The server stopped us at a gate: say what it is and let the owner decide, never decide for them.
        final code = errorCodeOf(e);
        if (code == 'ASSEMBLY_INCOMPLETE' &&
            step.kind == NextStepKind.markReady) {
          if (!mounted) return;
          // While the owner thinks, nothing is "working": no spinner behind the question.
          setState(() => _busy = false);
          final yes = await _confirm(
              title: l10n.posReadyAnywayTitle,
              body: l10n.posReadyAnywayBody,
              yes: l10n.posReadyAnywayYes,
              no: l10n.posNotYet);
          if (yes != true || !mounted) return;
          setState(() => _busy = true);
          moved = await actions.transition(o, step,
              allowIncomplete: true, allowUnpaid: allowUnpaid);
        } else if (code == 'PAYMENT_OUTSTANDING') {
          if (!mounted) return;
          setState(() => _busy = false);
          if (await _askDeliverDue(o) != true || !mounted) return;
          setState(() => _busy = true);
          moved = await actions.transition(o, step, allowUnpaid: true);
        } else {
          rethrow;
        }
      }
      _say(l10n.posOrdMoved(phaseLabel(l10n, moved.phase)));
    } catch (e) {
      _say(orderErrorText(e, l10n));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _pay(CounterOrder o) async {
    await showPaymentSheet(context, o);
  }

  Future<void> _call(String phone) async {
    final l10n = AppLocalizations.of(context);
    final ok =
        await ref.read(posUrlOpenerProvider)(Uri(scheme: 'tel', path: phone));
    if (!ok) _say(l10n.posOrdCallFailed);
  }

  Future<void> _whatsApp(CounterOrder o) async {
    final l10n = AppLocalizations.of(context);
    final shop = ref.read(appModeProvider).info?.shopName ?? '';
    final uri = whatsAppUri(
        o.customer.phone, buildWhatsAppMessage(l10n, order: o, shopName: shop));
    final ok = uri != null && await ref.read(posUrlOpenerProvider)(uri);
    if (!ok) _say(l10n.posWaOpenFailed);
  }

  Future<void> _invoice(CounterOrder o) async {
    final l10n = AppLocalizations.of(context);
    if (o.hasInvoice) {
      await context.push(AppRoutes.posOrderInvoicePath(o.id));
      return;
    }
    // Not delivered yet: the A4 invoice does not exist. Say so, and offer the bill that does.
    final mini = await _confirm(
        title: l10n.posActInvoice,
        body: l10n.posInvoiceLater,
        yes: l10n.posInvoiceOpenMini,
        no: l10n.posOk);
    if (mini == true && mounted) {
      await context.push(AppRoutes.posOrderMiniPath(o.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(posOrderDetailProvider(widget.orderId));
    final canProcess = ref.watch(posCanProcessOrdersProvider);
    final canAssign = ref.watch(posCanAssignCaptainProvider);
    final canView = ref.watch(posCanViewOrdersProvider);

    if (!canView) {
      return Scaffold(
          appBar: AppBar(title: Text(l10n.posOrdDetailTitle)),
          body: Center(
              child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(l10n.posNoPermission,
                      textAlign: TextAlign.center))));
    }

    final detail = async.valueOrNull;
    if (detail == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.posOrdDetailTitle)),
        body: async.hasError
            ? ListView(padding: const EdgeInsets.all(16), children: [
                PosErrorNote(
                    message:
                        '${l10n.posOrdLoadFailed}\n${orderErrorText(async.error, l10n)}',
                    onRetry: () =>
                        ref.invalidate(posOrderDetailProvider(widget.orderId)),
                    retryLabel: l10n.posRetry)
              ])
            : Center(
                child: Semantics(
                    label: l10n.posOrdLoadingHint,
                    child: const CircularProgressIndicator())),
      );
    }

    final o = detail.order;
    final step = nextStepOf(o);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final showPayMain = step == null && o.canCollect && canProcess;

    return Scaffold(
      appBar: AppBar(title: Text(o.orderNumber)),
      floatingActionButton: o.customer.phone.isEmpty
          ? null
          : FloatingActionButton.extended(
              heroTag: 'order-whatsapp',
              onPressed: () => _whatsApp(o),
              icon: const Icon(Icons.chat_rounded),
              label: Text(l10n.posWhatsApp),
            ),
      bottomNavigationBar: (step != null && canProcess) || showPayMain
          ? SafeArea(
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                decoration: BoxDecoration(
                    color: scheme.surface,
                    border: Border(top: BorderSide(color: scheme.outline))),
                child: SizedBox(
                  height: 52,
                  child: FilledButton(
                    onPressed: _busy
                        ? null
                        : () => step != null ? _advance(o) : _pay(o),
                    child: _busy
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2.5))
                        : Text(step != null
                            ? nextStepLabel(l10n, step.kind)
                            : l10n.posActPayNow),
                  ),
                ),
              ),
            )
          : null,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(posOrderDetailProvider(widget.orderId));
          await ref
              .read(posOrderDetailProvider(widget.orderId).future)
              .catchError((_) => detail);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
          children: [
            if (async.isLoading)
              const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: LinearProgressIndicator()),
            _HeaderCard(
                order: o,
                onCall: o.customer.phone.isEmpty
                    ? null
                    : () => _call(o.customer.phone)),
            const SizedBox(height: 12),
            if (o.status == 'CANCELLED')
              _Note(
                  icon: Icons.cancel_rounded,
                  tone: PosTone.danger,
                  text: [
                    l10n.posOrdCancelledNote,
                    if ((o.cancelReason ?? '').isNotEmpty)
                      '${l10n.posInfoCancelReason}: ${o.cancelReason}'
                  ].join('\n'))
            else
              OrderTimeline(detail: detail),
            const SizedBox(height: 16),
            _Title(l10n.posActionsTitle),
            const SizedBox(height: 8),
            _ActionGrid(actions: [
              if (canProcess)
                _Action(Icons.payments_rounded, l10n.posActPayNow,
                    enabled: o.canCollect, onTap: () => _pay(o)),
              _Action(Icons.receipt_long_rounded, l10n.posActInvoice,
                  enabled: o.hasMiniBill, onTap: () => _invoice(o)),
              _Action(Icons.receipt_rounded, l10n.posActMiniInvoice,
                  enabled: o.hasMiniBill,
                  onTap: () => context.push(AppRoutes.posOrderMiniPath(o.id))),
              _Action(Icons.label_rounded, l10n.posActTag,
                  enabled: detail.units.isNotEmpty,
                  onTap: () => context.push(AppRoutes.posOrderTagsPath(o.id))),
              if (canProcess)
                _Action(Icons.edit_rounded, l10n.posActEdit,
                    enabled: o.canEdit,
                    onTap: () => showEditOrderSheet(context, o)),
              if (canAssign && o.deliveryMode != DeliveryMode.walkIn)
                _Action(Icons.two_wheeler_rounded, l10n.posActAssign,
                    enabled: !o.isClosed,
                    onTap: () => showAssignCaptainSheet(context, o)),
              if (canProcess)
                _Action(Icons.cancel_outlined, l10n.posActCancel,
                    enabled: o.canCancel,
                    danger: true,
                    onTap: () => showCancelOrderSheet(context, o)),
            ]),
            const SizedBox(height: 16),
            _Title(l10n.posInfoTitle),
            const SizedBox(height: 8),
            _InfoCard(order: o),
            const SizedBox(height: 16),
            _Title(l10n.posPaymentsTitle),
            const SizedBox(height: 8),
            _PaymentsCard(detail: detail),
            const SizedBox(height: 16),
            _Title(l10n.posGarmentsTitle),
            const SizedBox(height: 8),
            _GarmentsCard(detail: detail),
            const SizedBox(height: 8),
            Text('${l10n.posInfoOrderNo}: ${o.orderNumber}',
                style: text.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Semantics(
      header: true,
      child: Text(text, style: Theme.of(context).textTheme.titleMedium));
}

class _Note extends StatelessWidget {
  const _Note({required this.icon, required this.tone, required this.text});
  final IconData icon;
  final PosTone tone;
  final String text;
  @override
  Widget build(BuildContext context) {
    final c = posToneColors(context, tone);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: c.bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: c.fg.withValues(alpha: 0.4))),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: c.fg),
        const SizedBox(width: 10),
        Expanded(
            child: Text(text,
                style: TextStyle(color: c.fg, fontWeight: FontWeight.w600)))
      ]),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // A Material (not a coloured Container) so taps inside — the garment rows — show their ink.
    return Material(
      color: scheme.surface,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: scheme.outline)),
      child: Padding(padding: const EdgeInsets.all(14), child: child),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.order, required this.onCall});
  final CounterOrder order;
  final VoidCallback? onCall;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final hasName = order.customer.name.trim().isNotEmpty;
    return Material(
      color: scheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: scheme.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.orderNumber,
                        style: text.labelLarge?.copyWith(
                          color: scheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        order.customer.displayName,
                        style: text.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (hasName && order.customer.phone.isNotEmpty)
                        Text(order.customer.phone, style: text.bodyMedium),
                    ],
                  ),
                ),
                // An icon-only button: the POS theme stretches text buttons to full width, which squeezed this row.
                if (onCall != null)
                  IconButton.filled(
                    onPressed: onCall,
                    tooltip: l10n.posOrdCall,
                    icon: const Icon(Icons.call_rounded),
                    style: IconButton.styleFrom(
                      minimumSize: const Size(48, 48),
                      fixedSize: const Size(48, 48),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  OrderStatusChip(order: order),
                  if (order.status != 'CANCELLED')
                    PosStatusChip(
                      label: paymentStatusLabel(l10n, order.paymentStatus),
                      tone: toneOfPayment(order.paymentStatus),
                    ),
                  if (order.isExpress)
                    PosStatusChip(
                      label: l10n.posOrdExpress,
                      tone: PosTone.danger,
                      icon: Icons.bolt_rounded,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Action {
  const _Action(this.icon, this.label,
      {required this.enabled, required this.onTap, this.danger = false});
  final IconData icon;
  final String label;
  final bool enabled;
  final bool danger;
  final VoidCallback onTap;
}

class _ActionGrid extends StatelessWidget {
  const _ActionGrid({required this.actions});
  final List<_Action> actions;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    Widget tile(_Action a) {
      final colour = !a.enabled
          ? scheme.onSurfaceVariant.withValues(alpha: 0.6)
          : (a.danger
              ? posToneColors(context, PosTone.danger).fg
              : scheme.primary);
      return Semantics(
        button: true,
        enabled: a.enabled,
        label: a.label,
        excludeSemantics: true,
        onTap: a.enabled ? a.onTap : null,
        child: Material(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: a.enabled ? a.onTap : null,
            child: Container(
              constraints: const BoxConstraints(minHeight: 84),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: scheme.outline)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(a.icon, size: 28, color: colour),
                  const SizedBox(height: 6),
                  Text(a.label,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(color: colour)),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return LayoutBuilder(builder: (context, c) {
      final cols = c.maxWidth >= 520 ? 4 : 3;
      const gap = 10.0;
      final w = (c.maxWidth - gap * (cols - 1)) / cols;
      return Wrap(spacing: gap, runSpacing: gap, children: [
        for (final a in actions) SizedBox(width: w, child: tile(a))
      ]);
    });
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value, {this.strong = false, this.tone});
  final String label;
  final String value;
  final bool strong;
  final PosTone? tone;
  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final c = tone == null ? null : posToneColors(context, tone!).fg;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 4, child: Text(label, style: text.bodyMedium)),
          const SizedBox(width: 8),
          Expanded(
              flex: 5,
              child: Text(value,
                  textAlign: TextAlign.end,
                  style: (strong ? text.titleSmall : text.bodyLarge)?.copyWith(
                      color: c, fontWeight: strong ? FontWeight.w800 : null))),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.order});
  final CounterOrder order;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final o = order;
    final rows = <Widget>[
      _InfoRow(l10n.posInfoDelivery, deliveryModeLabel(l10n, o.deliveryMode)),
      _InfoRow(l10n.posInfoOrderNo, o.orderNumber),
      _InfoRow(l10n.posInfoInvoiceAmount,
          formatPaise(o.totalPaise, alwaysShowPaise: true),
          strong: true),
      _InfoRow(l10n.posInfoPaid,
          formatPaise(o.amountPaidPaise, alwaysShowPaise: true),
          tone: o.amountPaidPaise > 0 ? PosTone.success : null),
      if (o.status != 'CANCELLED')
        _InfoRow(l10n.posInfoBalance,
            formatPaise(o.balancePaise, alwaysShowPaise: true),
            strong: true,
            tone: o.balancePaise > 0 ? PosTone.attention : PosTone.success),
      _InfoRow(l10n.posInfoBookedOn, dateTimeText(context, o.placedAt)),
      _InfoRow(
          l10n.posInfoDeliveryDate, dateText(context, o.expectedDeliveryDate)),
      if (o.deliveryMode != DeliveryMode.walkIn) ...[
        _InfoRow(l10n.posInfoPickupCaptain,
            o.pickupCaptain?.name ?? l10n.posInfoNotAssigned),
        _InfoRow(l10n.posInfoDeliveryCaptain,
            o.deliveryCaptain?.name ?? l10n.posInfoNotAssigned),
      ],
      if ((o.notes ?? '').trim().isNotEmpty)
        _InfoRow(l10n.posInfoNotes, o.notes!.trim()),
    ];
    return _Card(child: Column(children: rows));
  }
}

class _PaymentsCard extends StatelessWidget {
  const _PaymentsCard({required this.detail});
  final OrderDetail detail;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final p = detail.payments;
    return _Card(
      child: p.isEmpty
          ? Text(l10n.posPaymentsNone, style: text.bodyMedium)
          : Column(
              children: [
                for (final x in p)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(paymentModeLabel(l10n, x.mode),
                                  style: text.titleSmall),
                              Text(
                                  [
                                    dateTimeText(context, x.createdAt),
                                    if ((x.reference ?? '').isNotEmpty)
                                      x.reference!
                                  ].join(' · '),
                                  style: text.bodySmall),
                            ],
                          ),
                        ),
                        Text(formatPaise(x.amountPaise, alwaysShowPaise: true),
                            style: text.titleSmall?.copyWith(
                                color:
                                    posToneColors(context, PosTone.success).fg,
                                fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}

class _GarmentsCard extends StatelessWidget {
  const _GarmentsCard({required this.detail});
  final OrderDetail detail;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final items = detail.order.items;
    if (items.isEmpty) {
      return _Card(child: Text(l10n.posGarmentsNone, style: text.bodyMedium));
    }
    return _Card(
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++)
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: EdgeInsets.zero,
                childrenPadding: const EdgeInsets.only(bottom: 8),
                title: Text('${items[i].name} × ${items[i].qtyText}',
                    style: text.titleSmall),
                subtitle: Text(
                    '${items[i].serviceName} · ${formatPaise(items[i].ratePaise)} → ${formatPaise(items[i].amountPaise)}',
                    style: text.bodySmall),
                children: [
                  for (final u in detail.units.where((u) => u.itemIndex == i))
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(children: [
                        Expanded(
                            child: Text('#${u.sequence}  ${u.tagCode}',
                                style: text.bodyMedium,
                                overflow: TextOverflow.ellipsis)),
                        PosStatusChip(
                            label: unitStateLabel(l10n, u.state),
                            tone: unitTone(u.state)),
                      ]),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
