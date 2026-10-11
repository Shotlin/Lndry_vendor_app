import 'dart:async';

import 'package:lndry_vendor_app/models/pos/pos_customer_detail_model.dart';
import 'package:lndry_vendor_app/models/pos/pos_customer_model.dart';
import 'package:lndry_vendor_app/models/pos/pos_money_model.dart';
import 'package:lndry_vendor_app/models/pos/pos_search_model.dart';
import 'package:lndry_vendor_app/models/pos/pos_settings_model.dart';
import 'package:lndry_vendor_app/repositories/abstract/pos_repositories.dart';

import 'pos_fakes.dart';

class FakeSearchRepo implements PosSearchRepository {
  final List<String> queries = [];
  PosSearchResults results = const PosSearchResults();
  Object? error;

  /// Control the answer (e.g. a Completer's future to finish it later).
  Future<PosSearchResults> Function(String q)? onSearch;

  @override
  Future<PosSearchResults> search(String query) {
    queries.add(query);
    if (onSearch != null) return onSearch!(query);
    if (error != null) return Future.error(error!);
    return Future.value(results);
  }
}

class FakeCustomersRepo implements PosCustomersRepository {
  FakeCustomersRepo({Map<String, PosCustomerDetail>? details}) : details = details ?? {};
  Map<String, PosCustomerDetail> details;
  Object? error;
  final List<String> asked = [];

  @override
  Future<PosCustomerDetail> detail(String customerId) {
    asked.add(customerId);
    if (error != null) return Future.error(error!);
    final d = details[customerId];
    return d == null ? Future.error(apiError('NOT_FOUND', 'Customer not found', status: 404)) : Future.value(d);
  }
}

PosExpense makeExpense({String id = 'x1', String name = 'Tea', int amount = 3000, String category = 'TEA', String mode = 'CASH', String status = 'PAID', String date = '2026-10-11', String? cancelReason}) =>
    PosExpense(id: id, name: name, date: date, amountPaise: amount, category: category, paymentMode: mode, status: status, cancellationReason: cancelReason);

CashShift makeShift({String id = 's1', bool open = true, int opening = 50000, int collections = 0, int expenses = 0, int? expected, int? counted, int? variance}) => CashShift(
      id: id,
      register: 'Main counter',
      open: open,
      openingCashPaise: opening,
      collectionsPaise: collections,
      expensesPaise: expenses,
      expectedCashPaise: expected ?? (opening + collections - expenses),
      countedCashPaise: counted,
      variancePaise: variance,
      openedAt: DateTime.utc(2026, 10, 11, 4),
    );

class FakeExpenseRepo implements PosExpenseRepository {
  FakeExpenseRepo({List<PosExpense>? expenses, this.shift}) : expenses = expenses ?? [];
  List<PosExpense> expenses;
  CashShift? shift;
  List<CashShift> history = [];
  Object? listError;
  Object? saveError;
  final List<({String from, String to})> listCalls = [];
  final List<ExpenseDraft> created = [];
  final List<({String id, ExpenseDraft draft, String reason})> updated = [];
  final List<({String id, String reason})> cancelled = [];
  final List<({int counted, String? note, String? approvedBy})> closeCalls = [];
  int? openedWith;
  int _n = 0;

  @override
  Future<List<PosExpense>> listExpenses({required String from, required String to, int limit = 100}) {
    listCalls.add((from: from, to: to));
    if (listError != null) return Future.error(listError!);
    return Future.value(expenses.where((e) => e.date.compareTo(from) >= 0 && e.date.compareTo(to) <= 0).toList());
  }

  @override
  Future<PosExpense> createExpense(ExpenseDraft draft) async {
    if (saveError != null) throw saveError!;
    created.add(draft);
    final e = PosExpense(id: 'new${_n++}', name: draft.name, date: draft.date, amountPaise: draft.amountPaise, category: draft.category, paymentMode: draft.paymentMode, status: 'PAID', notes: draft.notes);
    expenses = [e, ...expenses];
    return e;
  }

  @override
  Future<PosExpense> updateExpense(String id, ExpenseDraft draft, {required String reason}) async {
    if (saveError != null) throw saveError!;
    updated.add((id: id, draft: draft, reason: reason));
    final e = PosExpense(id: id, name: draft.name, date: draft.date, amountPaise: draft.amountPaise, category: draft.category, paymentMode: draft.paymentMode, status: 'PAID');
    expenses = [for (final x in expenses) x.id == id ? e : x];
    return e;
  }

  @override
  Future<PosExpense> cancelExpense(String id, {required String reason}) async {
    if (saveError != null) throw saveError!;
    cancelled.add((id: id, reason: reason));
    final old = expenses.firstWhere((e) => e.id == id);
    final e = makeExpense(id: id, name: old.name, amount: old.amountPaise, category: old.category, mode: old.paymentMode, status: 'CANCELLED', date: old.date, cancelReason: reason);
    expenses = [for (final x in expenses) x.id == id ? e : x];
    return e;
  }

  @override
  Future<CashShift?> currentShift() async => shift;

  @override
  Future<CashShift> openShift({required int openingCashPaise, String? note}) async {
    if (saveError != null) throw saveError!;
    openedWith = openingCashPaise;
    return shift = makeShift(opening: openingCashPaise);
  }

  @override
  Future<CashShift> closeShift(String id, {required int countedCashPaise, String? note, String? approvedBy}) async {
    closeCalls.add((counted: countedCashPaise, note: note, approvedBy: approvedBy));
    if (saveError != null) throw saveError!;
    final s = shift!;
    final variance = countedCashPaise - (s.expectedCashPaise ?? 0);
    if (variance != 0 && (approvedBy ?? '').trim().isEmpty) {
      throw apiError('VARIANCE_APPROVAL_REQUIRED', 'A non-zero cash variance requires supervisor approval', status: 400);
    }
    shift = null;
    return makeShift(open: false, expected: s.expectedCashPaise, counted: countedCashPaise, variance: variance);
  }

  @override
  Future<List<CashShift>> listShifts({int limit = 10}) async => history;
}

PosReport makeReport({int revenue = 32000, int collection = 16000, int dues = 16000, int expenses = 28000, int orders = 2}) => PosReport(
      from: '2026-10-11',
      to: '2026-10-11',
      days: 1,
      orderCount: orders,
      revenuePaise: revenue,
      collectionPaise: collection,
      duesPaise: dues,
      duesOrderCount: 1,
      expensesPaise: expenses,
      expenseCount: 2,
      netPaise: collection - expenses,
      ordersByStatus: const ReportOrdersByStatus(booked: 2, inProcess: 0, ready: 0, delivered: 0, cancelled: 0),
      paymentMix: const ReportPaymentMix(cashPaise: 16000, upiPaise: 0, cardPaise: 0, bankPaise: 0, walletPaise: 0),
      expenseByCategory: const [ReportCategorySpend(category: 'UTILITIES', totalPaise: 25000), ReportCategorySpend(category: 'TEA', totalPaise: 3000)],
      topGarments: const [ReportTopGarment(name: 'Shirt', qty: 4, revenuePaise: 32000)],
      daily: [ReportDay(date: '2026-10-11', revenuePaise: revenue, collectionPaise: collection, expensesPaise: expenses)],
    );

class FakeReportRepo implements PosReportRepository {
  PosReport Function(String from, String to)? make;
  Object? error;
  Object? exportError;
  String csv = 'Order Number,Placed At\nLND-1,2026-10-11T00:00:00Z\n';
  final List<({String from, String to})> calls = [];
  final List<({String from, String to})> exports = [];

  @override
  Future<PosReport> report({required String from, required String to}) {
    calls.add((from: from, to: to));
    if (error != null) return Future.error(error!);
    return Future.value(make != null ? make!(from, to) : makeReport());
  }

  @override
  Future<String> exportCsv({required String from, required String to}) {
    exports.add((from: from, to: to));
    if (exportError != null) return Future.error(exportError!);
    return Future.value(csv);
  }
}

class FakeSettingsRepo implements PosSettingsRepository {
  List<MessageTemplate> templates = kDefaultMessageTemplates;
  List<PosStaffMember> team = const [PosStaffMember(id: 'e1', name: 'Raj', phone: '9000000001', role: 'VENDOR_OWNER', active: true)];
  Object? templatesError;
  Object? staffError;

  @override
  Future<List<MessageTemplate>> messageTemplates() => templatesError != null ? Future.error(templatesError!) : Future.value(templates);

  @override
  Future<List<PosStaffMember>> staff() => staffError != null ? Future.error(staffError!) : Future.value(team);
}

PosCustomerDetail makeCustomerDetail({PosCustomer customer = sampleCustomer, List<dynamic>? orders, int? ledger}) => PosCustomerDetail(
      customer: customer,
      orders: List.of((orders ?? const []).cast()),
      ledgerBalancePaise: ledger,
    );
