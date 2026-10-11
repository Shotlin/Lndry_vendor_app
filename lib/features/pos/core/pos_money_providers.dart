import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/repositories/api_pos_repositories.dart';
import '../../../models/pos/pos_customer_detail_model.dart';
import '../../../models/pos/pos_money_model.dart';
import '../../../models/pos/pos_settings_model.dart';
import '../../../providers/access_provider.dart';

/// One customer with orders and dues. Re-read after every payment.
final posCustomerDetailProvider = FutureProvider.autoDispose.family<PosCustomerDetail, String>(
  (ref, id) => ref.watch(posCustomersRepositoryProvider).detail(id),
);

/// The shop's WhatsApp messages (saved ones, or Epic's defaults).
final posMessageTemplatesProvider = FutureProvider.autoDispose<List<MessageTemplate>>(
  (ref) => ref.watch(posSettingsRepositoryProvider).messageTemplates(),
);

final posStaffProvider = FutureProvider.autoDispose<List<PosStaffMember>>(
  (ref) => ref.watch(posSettingsRepositoryProvider).staff(),
);

/// The open cash drawer session, or `null`.
final posCurrentShiftProvider = FutureProvider.autoDispose<CashShift?>(
  (ref) => ref.watch(posExpenseRepositoryProvider).currentShift(),
);

final posShiftHistoryProvider = FutureProvider.autoDispose<List<CashShift>>(
  (ref) => ref.watch(posExpenseRepositoryProvider).listShifts(),
);

/// The permission catalogue has no "finance" right, so the money screens follow the closest ones:
/// Expense + cash drawer = whoever may process orders (counter staff handle cash); Report = whoever may see analytics.
/// The server refuses riders but does not check these rights, so they only decide what is *shown* (see PROGRESS.md).
final posCanUseCashProvider = Provider<bool>((ref) => ref.watch(myAccessProvider).can('orders.process'));
final posCanSeeReportProvider = Provider<bool>((ref) => ref.watch(myAccessProvider).can('analytics.view'));
