import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/pos/pos_counter_order_model.dart';
import '../core/money.dart';
import '../core/pos_widgets.dart';
import 'order_errors.dart';
import 'order_labels.dart';
import 'orders_providers.dart';

/// Asks how much and how, then records it. Returns the order as the server now has it (or `null` if dismissed).
/// Wallet is not offered here: a wallet payment needs the customer's OTP and is taken when the order is booked.
Future<CounterOrder?> showPaymentSheet(
    BuildContext context, CounterOrder order) {
  return showModalBottomSheet<CounterOrder>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => PosThemeScope(child: PaymentSheet(order: order)),
  );
}

const _modes = ['CASH', 'UPI', 'CARD', 'BANK'];

class PaymentSheet extends ConsumerStatefulWidget {
  const PaymentSheet({required this.order, super.key});
  final CounterOrder order;

  @override
  ConsumerState<PaymentSheet> createState() => _PaymentSheetState();
}

class _PaymentSheetState extends ConsumerState<PaymentSheet> {
  late final TextEditingController _amount =
      TextEditingController(text: paiseToInput(widget.order.balancePaise));
  final _reference = TextEditingController();
  String _mode = 'CASH';
  bool _busy = false;
  String? _error;
  String? _fieldError;

  @override
  void dispose() {
    _amount.dispose();
    _reference.dispose();
    super.dispose();
  }

  int get _balance => widget.order.balancePaise;

  Future<void> _collect() async {
    if (_busy) return; // one tap = one payment
    final l10n = AppLocalizations.of(context);
    final paise = parseRupeesToPaise(_amount.text);
    if (paise == null || paise <= 0) {
      setState(() => _fieldError = l10n.posPayErrZero);
      return;
    }
    if (paise > _balance) {
      setState(() => _fieldError =
          l10n.posPayErrOver(formatPaise(_balance, alwaysShowPaise: true)));
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
      _fieldError = null;
    });
    try {
      final r = await ref.read(posOrderActionsProvider).collectPayment(
          widget.order.id,
          amountPaise: paise,
          mode: _mode,
          reference: _reference.text);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.fixed,
          content: Text(
              l10n.posPayDone(formatPaise(paise, alwaysShowPaise: true)))));
      Navigator.of(context).pop(r.order);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        // After a dropped connection we cannot know whether it was recorded; the order was re-read, so say so.
        _error = isNetworkProblem(e)
            ? '${l10n.posPayCheckFirst}\n${orderErrorText(e, l10n)}'
            : orderErrorText(e, l10n);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
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
              Text(l10n.posPayTitle, style: text.titleLarge),
              const SizedBox(height: 4),
              Text(widget.order.orderNumber, style: text.bodyMedium),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  Expanded(
                      child: Text(l10n.posPayBalance, style: text.titleSmall)),
                  Text(formatPaise(_balance, alwaysShowPaise: true),
                      style: text.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w800)),
                ]),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _amount,
                enabled: !_busy,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,₹]'))
                ],
                decoration: InputDecoration(
                    labelText: l10n.posPayAmount, errorText: _fieldError),
                onChanged: (_) {
                  if (_fieldError != null) setState(() => _fieldError = null);
                },
              ),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton(
                    onPressed: _busy
                        ? null
                        : () => setState(
                            () => _amount.text = paiseToInput(_balance)),
                    child: Text(l10n.posPayFull)),
              ),
              Text(l10n.posPayHow, style: text.titleSmall),
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 8, children: [
                for (final m in _modes)
                  ChoiceChip(
                      label: Text(paymentModeLabel(l10n, m)),
                      selected: _mode == m,
                      onSelected:
                          _busy ? null : (_) => setState(() => _mode = m)),
              ]),
              const SizedBox(height: 12),
              TextField(
                  controller: _reference,
                  enabled: !_busy,
                  maxLength: 120,
                  decoration: InputDecoration(
                      labelText: l10n.posPayReference,
                      hintText: l10n.posPayReferenceHint,
                      counterText: '')),
              if (_error != null) ...[
                const SizedBox(height: 8),
                PosErrorNote(message: _error!)
              ],
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _busy ? null : _collect,
                child: _busy
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.5))
                    : Text(l10n.posPayCollect(formatPaise(
                        parseRupeesToPaise(_amount.text) ?? _balance,
                        alwaysShowPaise: true))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
