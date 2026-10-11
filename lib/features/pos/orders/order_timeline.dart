import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/pos/pos_counter_order_model.dart';
import 'order_labels.dart';
import 'order_state.dart';

/// Booked → Processed → Done → Delivered → Complete, with how far along it is. Reached stops are filled and
/// carry a tick (not only a colour), and show the time the order got there when the history has it.
class OrderTimeline extends StatelessWidget {
  const OrderTimeline({required this.detail, super.key});
  final OrderDetail detail;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final o = detail.order;
    final reached = stagesReached(o);
    final percent = progressPercent(o);
    const stages = OrderStage.values;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: scheme.outline)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(
                child: Text(l10n.posProgressPercent(percent),
                    style: text.titleMedium)),
          ]),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
                value: percent / 100,
                minHeight: 10,
                backgroundColor: scheme.surfaceContainerHighest,
                color: scheme.primary),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < stages.length; i++)
            _StageRow(
              label: stageLabel(l10n, stages[i]),
              done: i < reached,
              current: i == reached - 1,
              last: i == stages.length - 1,
              time: _timeFor(context, stages[i], o),
            ),
        ],
      ),
    );
  }

  String? _timeFor(BuildContext context, OrderStage s, CounterOrder o) {
    final status = statusForStage(s);
    final at = status == null
        ? (s == OrderStage.complete && stagesReached(o) == 5
            ? o.updatedAt
            : null)
        : detail.reachedAt(status);
    if (at == null) return null;
    return dateTimeText(context, at);
  }
}

class _StageRow extends StatelessWidget {
  const _StageRow(
      {required this.label,
      required this.done,
      required this.current,
      required this.last,
      required this.time});
  final String label;
  final bool done;
  final bool current;
  final bool last;
  final String? time;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Semantics(
      container: true,
      label: '$label${done ? ', ✓' : ''}${time == null ? '' : ', $time'}',
      excludeSemantics: true,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 28,
              child: Column(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: done ? scheme.primary : scheme.surface,
                        border: Border.all(
                            color: done ? scheme.primary : scheme.outline,
                            width: 2)),
                    child: done
                        ? Icon(Icons.check_rounded,
                            size: 16, color: scheme.onPrimary)
                        : null,
                  ),
                  if (!last)
                    Expanded(
                        child: Container(
                            width: 2,
                            color: done ? scheme.primary : scheme.outline)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: text.titleSmall?.copyWith(
                            fontWeight:
                                current ? FontWeight.w800 : FontWeight.w600,
                            color: done ? null : scheme.onSurfaceVariant)),
                    if (time != null) Text(time!, style: text.bodySmall),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
