import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../api/repositories/api_pos_repositories.dart';
import '../../../core/network/friendly_error.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../models/pos/pos_money_model.dart';
import '../core/money.dart';
import '../core/pos_widgets.dart';
import '../orders/order_errors.dart';
import 'expense_labels.dart';
import 'expense_logic.dart';

Future<T?> _sheet<T>(BuildContext context, Widget child) =>
    showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => PosThemeScope(child: child),
    );

/// Add (or, with [existing], edit) an expense. Returns true when saved.
Future<bool?> showExpenseSheet(BuildContext context, {PosExpense? existing}) =>
    _sheet<bool>(context, ExpenseSheet(existing: existing));

class ExpenseSheet extends ConsumerStatefulWidget {
  const ExpenseSheet({super.key, this.existing, this.today});
  final PosExpense? existing;

  /// Override the clock in tests.
  final DateTime? today;

  @override
  ConsumerState<ExpenseSheet> createState() => _ExpenseSheetState();
}

class _ExpenseSheetState extends ConsumerState<ExpenseSheet> {
  late final _name = TextEditingController(text: widget.existing?.name ?? '');
  late final _amount = TextEditingController(
      text: widget.existing == null
          ? ''
          : paiseToInput(widget.existing!.amountPaise));
  late final _notes = TextEditingController(text: widget.existing?.notes ?? '');
  final _reason = TextEditingController();
  late String _category = widget.existing?.category ?? 'OTHER';
  late String _mode = widget.existing?.paymentMode ?? 'CASH';
  late String _date =
      widget.existing?.date ?? isoDay(widget.today ?? DateTime.now());
  ExpenseProblem? _problem;
  Object? _error;
  bool _busy = false;

  bool get _editing => widget.existing != null;

  @override
  void dispose() {
    _name.dispose();
    _amount.dispose();
    _notes.dispose();
    _reason.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = widget.today ?? DateTime.now();
    final current = DateTime.tryParse(_date) ?? now;
    final picked = await showDatePicker(
        context: context,
        initialDate: current,
        firstDate: DateTime(now.year - 2),
        lastDate: now);
    if (picked != null) setState(() => _date = isoDay(picked));
  }

  Future<void> _save() async {
    if (_busy) return;
    final check = checkExpense(
        name: _name.text,
        amountText: _amount.text,
        category: _category,
        mode: _mode,
        date: _date,
        notes: _notes.text,
        reason: _reason.text,
        needReason: _editing);
    if (!check.ok) {
      setState(() => _problem = check.problem);
      return;
    }
    setState(() {
      _problem = null;
      _error = null;
      _busy = true;
    });
    try {
      final repo = ref.read(posExpenseRepositoryProvider);
      if (_editing) {
        await repo.updateExpense(widget.existing!.id, check.draft!,
            reason: _reason.text);
      } else {
        await repo.createExpense(check.draft!);
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e;
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final dateText =
        DateFormat.yMMMd(Localizations.localeOf(context).toString())
            .format(DateTime.tryParse(_date) ?? DateTime.now());
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 8, 20, MediaQuery.viewInsetsOf(context).bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(_editing ? l10n.posExpEdit : l10n.posExpAdd,
                      style: text.titleLarge),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _name,
                    textCapitalization: TextCapitalization.sentences,
                    maxLength: 160,
                    decoration: InputDecoration(
                        labelText: l10n.posExpName,
                        hintText: l10n.posExpNameHint,
                        counterText: '',
                        errorText: _problem == ExpenseProblem.name
                            ? l10n.posExpNameRequired
                            : null),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _amount,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                        labelText: l10n.posExpAmount,
                        prefixText: '₹ ',
                        errorText: _problem == ExpenseProblem.amount
                            ? l10n.posExpAmountInvalid
                            : null),
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.posExpCategory, style: text.labelLarge),
                  const SizedBox(height: 8),
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    for (final c in {...kExpenseCategories, _category})
                      ChoiceChip(
                        label: Text(expenseCategoryLabel(l10n, c)),
                        selected: _category == c,
                        onSelected: (_) => setState(() => _category = c),
                      ),
                  ]),
                  const SizedBox(height: 16),
                  Text(l10n.posExpMode, style: text.labelLarge),
                  const SizedBox(height: 8),
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    for (final m in {...kExpenseModes, _mode})
                      ChoiceChip(
                          label: Text(expenseModeLabel(l10n, m)),
                          selected: _mode == m,
                          onSelected: (_) => setState(() => _mode = m)),
                  ]),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                      onPressed: _pickDate,
                      icon: const Icon(Icons.event_rounded),
                      label: Text('${l10n.posExpDate}: $dateText')),
                  const SizedBox(height: 12),
                  TextField(
                      controller: _notes,
                      maxLength: 1000,
                      maxLines: 2,
                      decoration: InputDecoration(
                          labelText: l10n.posExpNote, counterText: '')),
                  if (_editing) ...[
                    const SizedBox(height: 12),
                    TextField(
                        controller: _reason,
                        maxLength: 500,
                        decoration: InputDecoration(
                            labelText: l10n.posExpReason,
                            counterText: '',
                            errorText: _problem == ExpenseProblem.reason
                                ? l10n.posExpReasonRequired
                                : null)),
                  ],
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    PosErrorNote(message: orderErrorText(_error, l10n)),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
              onPressed: _busy ? null : _save,
              child: _busy
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.5))
                  : Text(l10n.posExpSave)),
        ],
      ),
    );
  }
}

/// Asks why, then cancels the expense. Returns true when cancelled.
Future<bool?> showCancelExpenseSheet(BuildContext context, PosExpense e) =>
    _sheet<bool>(context, _CancelExpenseSheet(expense: e));

class _CancelExpenseSheet extends ConsumerStatefulWidget {
  const _CancelExpenseSheet({required this.expense});
  final PosExpense expense;

  @override
  ConsumerState<_CancelExpenseSheet> createState() =>
      _CancelExpenseSheetState();
}

class _CancelExpenseSheetState extends ConsumerState<_CancelExpenseSheet> {
  final _reason = TextEditingController();
  bool _empty = false;
  bool _busy = false;
  Object? _error;

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  Future<void> _go() async {
    if (_busy) return;
    if (_reason.text.trim().isEmpty) {
      setState(() => _empty = true);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(posExpenseRepositoryProvider)
          .cancelExpense(widget.expense.id, reason: _reason.text);
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e;
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 8, 20, MediaQuery.viewInsetsOf(context).bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.posExpCancel,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
              '${widget.expense.name} · ${formatPaise(widget.expense.amountPaise)}'),
          const SizedBox(height: 12),
          TextField(
              controller: _reason,
              maxLength: 500,
              autofocus: true,
              decoration: InputDecoration(
                  labelText: l10n.posExpCancelReason,
                  counterText: '',
                  errorText: _empty ? l10n.posExpReasonRequired : null)),
          if (_error != null) ...[
            const SizedBox(height: 8),
            PosErrorNote(message: friendlyError(_error))
          ],
          const SizedBox(height: 12),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError),
            onPressed: _busy ? null : _go,
            child: Text(l10n.posExpCancel),
          ),
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.posExpKeep)),
        ],
      ),
    );
  }
}

/// Opens the cash drawer with the cash already in it. Returns true when opened.
Future<bool?> showOpenDrawerSheet(BuildContext context) =>
    _sheet<bool>(context, const _OpenDrawerSheet());

class _OpenDrawerSheet extends ConsumerStatefulWidget {
  const _OpenDrawerSheet();
  @override
  ConsumerState<_OpenDrawerSheet> createState() => _OpenDrawerSheetState();
}

class _OpenDrawerSheetState extends ConsumerState<_OpenDrawerSheet> {
  final _cash = TextEditingController();
  bool _bad = false;
  bool _busy = false;
  Object? _error;

  @override
  void dispose() {
    _cash.dispose();
    super.dispose();
  }

  Future<void> _go() async {
    if (_busy) return;
    // Zero is allowed: a drawer can start empty.
    final paise =
        _cash.text.trim().isEmpty ? null : parseRupeesToPaise(_cash.text);
    if (paise == null) {
      setState(() => _bad = true);
      return;
    }
    setState(() {
      _bad = false;
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(posExpenseRepositoryProvider)
          .openShift(openingCashPaise: paise);
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e;
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 8, 20, MediaQuery.viewInsetsOf(context).bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.posDrawerOpen,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          TextField(
            controller: _cash,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
                labelText: l10n.posDrawerOpeningQ,
                prefixText: '₹ ',
                errorText: _bad ? l10n.posExpAmountInvalid : null),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            PosErrorNote(message: orderErrorText(_error, l10n))
          ],
          const SizedBox(height: 16),
          FilledButton(
              onPressed: _busy ? null : _go,
              child: Text(l10n.posDrawerOpenSave)),
        ],
      ),
    );
  }
}

/// Closes the drawer after counting. If the count differs from what the server expects, a reason and an approver's
/// name are required (the server insists on both). Returns true when closed.
Future<bool?> showCloseDrawerSheet(BuildContext context, CashShift shift) =>
    _sheet<bool>(context, _CloseDrawerSheet(shift: shift));

class _CloseDrawerSheet extends ConsumerStatefulWidget {
  const _CloseDrawerSheet({required this.shift});
  final CashShift shift;
  @override
  ConsumerState<_CloseDrawerSheet> createState() => _CloseDrawerSheetState();
}

class _CloseDrawerSheetState extends ConsumerState<_CloseDrawerSheet> {
  final _counted = TextEditingController();
  final _why = TextEditingController();
  final _who = TextEditingController();
  bool _badCount = false;
  bool _needWhy = false;
  bool _busy = false;
  Object? _error;

  @override
  void dispose() {
    _counted.dispose();
    _why.dispose();
    _who.dispose();
    super.dispose();
  }

  int? get _countedPaise =>
      _counted.text.trim().isEmpty ? null : parseRupeesToPaise(_counted.text);

  Future<void> _go() async {
    if (_busy) return;
    final counted = _countedPaise;
    final expected = widget.shift.expectedCashPaise;
    if (counted == null || expected == null) {
      setState(() => _badCount = true);
      return;
    }
    final diff =
        drawerDifference(expectedPaise: expected, countedPaise: counted);
    if (drawerNeedsApproval(diff) &&
        (_why.text.trim().isEmpty || _who.text.trim().isEmpty)) {
      setState(() {
        _badCount = false;
        _needWhy = true;
      });
      return;
    }
    setState(() {
      _badCount = false;
      _needWhy = false;
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(posExpenseRepositoryProvider).closeShift(widget.shift.id,
          countedCashPaise: counted,
          note: diff == 0 ? null : _why.text,
          approvedBy: diff == 0 ? null : _who.text);
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e;
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final expected = widget.shift.expectedCashPaise;
    final counted = _countedPaise;
    final diff = counted == null || expected == null
        ? null
        : drawerDifference(expectedPaise: expected, countedPaise: counted);
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 8, 20, MediaQuery.viewInsetsOf(context).bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l10n.posDrawerClose, style: text.titleLarge),
                  const SizedBox(height: 4),
                  Text(l10n.posDrawerExpected(formatPaise(expected)),
                      style: text.titleMedium),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _counted,
                    autofocus: true,
                    onChanged: (_) => setState(() {}),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                        labelText: l10n.posDrawerCounted,
                        prefixText: '₹ ',
                        errorText:
                            _badCount ? l10n.posDrawerCountInvalid : null),
                  ),
                  if (diff != null) ...[
                    const SizedBox(height: 12),
                    if (diff == 0)
                      PosNote(
                          icon: Icons.check_circle_rounded,
                          tone: PosTone.success,
                          text: l10n.posDrawerMatch)
                    else
                      PosNote(
                        icon: Icons.warning_amber_rounded,
                        tone: PosTone.attention,
                        text: diff < 0
                            ? l10n.posDrawerShort(formatPaise(-diff))
                            : l10n.posDrawerExtra(formatPaise(diff)),
                      ),
                  ],
                  if (diff != null && diff != 0) ...[
                    const SizedBox(height: 12),
                    TextField(
                        controller: _why,
                        maxLength: 500,
                        decoration: InputDecoration(
                            labelText: l10n.posDrawerWhy,
                            counterText: '',
                            errorText: _needWhy && _why.text.trim().isEmpty
                                ? l10n.posDrawerNeedsWhy
                                : null)),
                    const SizedBox(height: 8),
                    TextField(
                        controller: _who,
                        maxLength: 160,
                        decoration: InputDecoration(
                            labelText: l10n.posDrawerApprover,
                            counterText: '',
                            errorText: _needWhy && _who.text.trim().isEmpty
                                ? l10n.posDrawerNeedsWhy
                                : null)),
                  ],
                  if (_error != null) ...[
                    const SizedBox(height: 8),
                    PosErrorNote(message: orderErrorText(_error, l10n))
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
              onPressed: _busy ? null : _go,
              child: _busy
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.5))
                  : Text(l10n.posDrawerCloseSave)),
        ],
      ),
    );
  }
}
