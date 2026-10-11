import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/repositories/api_pos_repositories.dart';
import '../../../models/pos/pos_money_model.dart';

enum ExpenseRange { today, month }

typedef DayRange = ({String from, String to});

/// The dates a range covers, from the phone's own clock (an expense dated "today" is the owner's today).
DayRange rangeFor(ExpenseRange r, DateTime now) {
  final today = isoDay(now);
  return r == ExpenseRange.today ? (from: today, to: today) : (from: isoDay(DateTime(now.year, now.month, 1)), to: today);
}

final posExpensesProvider = FutureProvider.autoDispose.family<List<PosExpense>, DayRange>(
  (ref, range) => ref.watch(posExpenseRepositoryProvider).listExpenses(from: range.from, to: range.to),
);
