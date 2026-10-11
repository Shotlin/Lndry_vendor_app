import '../../../models/pos/pos_money_model.dart';
import '../core/money.dart';

/// What can be wrong with the Add Expense form, in the order the person fixes it.
enum ExpenseProblem { name, amount, reason }

class ExpenseCheck {
  const ExpenseCheck({this.problem, this.draft});
  final ExpenseProblem? problem;
  final ExpenseDraft? draft;
  bool get ok => problem == null;
}

/// Checks what was typed. [needReason] is true when editing (the server insists on a reason).
ExpenseCheck checkExpense({
  required String name,
  required String amountText,
  required String category,
  required String mode,
  required String date,
  String? notes,
  String? reason,
  bool needReason = false,
}) {
  if (name.trim().isEmpty || name.trim().length > 160) return const ExpenseCheck(problem: ExpenseProblem.name);
  final paise = parseRupeesToPaise(amountText);
  if (paise == null || paise <= 0) return const ExpenseCheck(problem: ExpenseProblem.amount);
  if (needReason && (reason ?? '').trim().isEmpty) return const ExpenseCheck(problem: ExpenseProblem.reason);
  return ExpenseCheck(draft: ExpenseDraft(name: name.trim(), date: date, amountPaise: paise, category: category, paymentMode: mode, notes: notes));
}

/// Counted cash against what the server says the drawer should hold. Both are whole paise.
/// Negative = short, positive = extra, zero = matches.
int drawerDifference({required int expectedPaise, required int countedPaise}) => countedPaise - expectedPaise;

/// The closing form needs a reason and an approver only when the count differs (the server insists on both).
bool drawerNeedsApproval(int difference) => difference != 0;
