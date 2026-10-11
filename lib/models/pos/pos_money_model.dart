/// Expenses, the cash drawer and the report. Money is whole paise (`int`) everywhere; a missing number is `null`,
/// never a made-up 0.
int? _int(Object? v) => v is num ? v.toInt() : null;
int _int0(Object? v) => v is num ? v.toInt() : 0;
String? _str(Object? v) => v == null || v.toString().trim().isEmpty ? null : v.toString();

/// `2026-10-11T00:00:00.000Z` (a DATE the server sent) → `2026-10-11`.
String? dayOf(Object? v) {
  final s = _str(v);
  if (s == null) return null;
  return s.length >= 10 ? s.substring(0, 10) : s;
}

/// `YYYY-MM-DD` for a local date — the form the server takes.
String isoDay(DateTime d) => '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

const kExpenseModes = ['CASH', 'UPI', 'BANK_TRANSFER', 'CARD', 'OTHER'];

/// The categories offered in the Add Expense sheet. The server keeps any text; these are the plain-word shortcuts.
const kExpenseCategories = ['RENT', 'SALARY', 'ELECTRICITY', 'WATER', 'DETERGENT', 'TRANSPORT', 'REPAIR', 'TEA', 'OTHER'];

class PosExpense {
  const PosExpense({
    required this.id,
    required this.name,
    required this.date,
    required this.amountPaise,
    required this.category,
    required this.paymentMode,
    required this.status,
    this.notes,
    this.receiver,
    this.cancellationReason,
  });

  factory PosExpense.fromJson(Map<String, dynamic> j) => PosExpense(
        id: j['id'].toString(),
        name: (j['expenseName'] ?? '').toString(),
        date: dayOf(j['expenseDate']) ?? '',
        amountPaise: _int0(j['amountPaise']),
        category: (j['category'] ?? 'UNCLASSIFIED').toString(),
        paymentMode: (j['paymentMode'] ?? 'CASH').toString(),
        status: (j['status'] ?? 'PAID').toString(),
        notes: _str(j['notes']),
        receiver: _str(j['paymentReceiver']),
        cancellationReason: _str(j['cancellationReason']),
      );

  final String id;
  final String name;

  /// `YYYY-MM-DD`.
  final String date;
  final int amountPaise;
  final String category;
  final String paymentMode;

  /// `PAID` or `CANCELLED`.
  final String status;
  final String? notes;
  final String? receiver;
  final String? cancellationReason;

  bool get cancelled => status == 'CANCELLED';
}

/// What the Add / Edit Expense sheet sends.
class ExpenseDraft {
  const ExpenseDraft({required this.name, required this.date, required this.amountPaise, required this.category, required this.paymentMode, this.notes, this.receiver});
  final String name;
  final String date;
  final int amountPaise;
  final String category;
  final String paymentMode;
  final String? notes;
  final String? receiver;

  Map<String, dynamic> toJson() => {
        'expenseName': name.trim(),
        'expenseDate': date,
        'amountPaise': amountPaise,
        'category': category,
        'paymentMode': paymentMode,
        if ((notes ?? '').trim().isNotEmpty) 'notes': notes!.trim(),
        if ((receiver ?? '').trim().isNotEmpty) 'paymentReceiver': receiver!.trim(),
      };
}

/// One counter cash-drawer session.
class CashShift {
  const CashShift({
    required this.id,
    required this.register,
    required this.open,
    required this.openingCashPaise,
    this.openedAt,
    this.closedAt,
    this.collectionsPaise,
    this.expensesPaise,
    this.expectedCashPaise,
    this.countedCashPaise,
    this.variancePaise,
    this.closeNote,
  });

  factory CashShift.fromJson(Map<String, dynamic> j) => CashShift(
        id: j['id'].toString(),
        register: (j['register'] ?? '').toString(),
        open: j['status'] == 'OPEN',
        openingCashPaise: _int0(j['openingCashPaise']),
        openedAt: DateTime.tryParse((j['openedAt'] ?? '').toString())?.toLocal(),
        closedAt: DateTime.tryParse((j['closedAt'] ?? '').toString())?.toLocal(),
        collectionsPaise: _int(j['collectionsPaise']),
        expensesPaise: _int(j['expensesPaise']),
        expectedCashPaise: _int(j['expectedCashPaise']),
        countedCashPaise: _int(j['countedCashPaise']),
        variancePaise: _int(j['variancePaise']),
        closeNote: _str(j['closeNote']),
      );

  final String id;
  final String register;
  final bool open;
  final int openingCashPaise;
  final DateTime? openedAt;
  final DateTime? closedAt;

  /// Cash taken in during the shift (server figure).
  final int? collectionsPaise;

  /// Cash paid out during the shift (server figure).
  final int? expensesPaise;

  /// Opening + collections − expenses, worked out by the server. This is what the drawer should hold.
  final int? expectedCashPaise;
  final int? countedCashPaise;
  final int? variancePaise;
  final String? closeNote;
}

class ReportOrdersByStatus {
  const ReportOrdersByStatus({this.booked, this.inProcess, this.ready, this.delivered, this.cancelled});
  factory ReportOrdersByStatus.fromJson(Map<String, dynamic> j) => ReportOrdersByStatus(
        booked: _int(j['booked']),
        inProcess: _int(j['inProcess']),
        ready: _int(j['ready']),
        delivered: _int(j['delivered']),
        cancelled: _int(j['cancelled']),
      );
  final int? booked;
  final int? inProcess;
  final int? ready;
  final int? delivered;
  final int? cancelled;
}

class ReportPaymentMix {
  const ReportPaymentMix({this.cashPaise, this.upiPaise, this.cardPaise, this.bankPaise, this.walletPaise});
  factory ReportPaymentMix.fromJson(Map<String, dynamic> j) => ReportPaymentMix(
        cashPaise: _int(j['cashPaise']),
        upiPaise: _int(j['upiPaise']),
        cardPaise: _int(j['cardPaise']),
        bankPaise: _int(j['bankPaise']),
        walletPaise: _int(j['walletPaise']),
      );
  final int? cashPaise;
  final int? upiPaise;
  final int? cardPaise;
  final int? bankPaise;
  final int? walletPaise;
}

class ReportDay {
  const ReportDay({required this.date, required this.revenuePaise, required this.collectionPaise, required this.expensesPaise});
  factory ReportDay.fromJson(Map<String, dynamic> j) => ReportDay(
        date: (j['date'] ?? '').toString(),
        revenuePaise: _int0(j['revenuePaise']),
        collectionPaise: _int0(j['collectionPaise']),
        expensesPaise: _int0(j['expensesPaise']),
      );
  final String date;
  final int revenuePaise;
  final int collectionPaise;
  final int expensesPaise;
}

class ReportTopGarment {
  const ReportTopGarment({required this.name, required this.qty, required this.revenuePaise});
  factory ReportTopGarment.fromJson(Map<String, dynamic> j) =>
      ReportTopGarment(name: (j['name'] ?? '').toString(), qty: j['qty'] is num ? (j['qty'] as num).toDouble() : 0, revenuePaise: _int0(j['revenuePaise']));
  final String name;

  /// Pieces, or kilograms for weighed items.
  final double qty;
  final int revenuePaise;
}

class ReportCategorySpend {
  const ReportCategorySpend({required this.category, required this.totalPaise});
  factory ReportCategorySpend.fromJson(Map<String, dynamic> j) => ReportCategorySpend(category: (j['category'] ?? '').toString(), totalPaise: _int0(j['totalPaise']));
  final String category;
  final int totalPaise;
}

/// `GET /vendor/pos/report` — every figure is the server's. The app only lays it out.
class PosReport {
  const PosReport({
    required this.from,
    required this.to,
    required this.days,
    this.orderCount,
    this.revenuePaise,
    this.collectionPaise,
    this.duesPaise,
    this.duesOrderCount,
    this.expensesPaise,
    this.expenseCount,
    this.netPaise,
    this.ordersByStatus = const ReportOrdersByStatus(),
    this.paymentMix = const ReportPaymentMix(),
    this.expenseByCategory = const [],
    this.topGarments = const [],
    this.daily = const [],
  });

  factory PosReport.fromJson(Map<String, dynamic> j) {
    Map<String, dynamic> m(Object? v) => v is Map<String, dynamic> ? v : const {};
    List<Map<String, dynamic>> l(Object? v) => v is List ? v.whereType<Map<String, dynamic>>().toList(growable: false) : const [];
    return PosReport(
      from: (j['from'] ?? '').toString(),
      to: (j['to'] ?? '').toString(),
      days: _int0(j['days']),
      orderCount: _int(j['orderCount']),
      revenuePaise: _int(j['revenuePaise']),
      collectionPaise: _int(j['collectionPaise']),
      duesPaise: _int(j['duesPaise']),
      duesOrderCount: _int(j['duesOrderCount']),
      expensesPaise: _int(j['expensesPaise']),
      expenseCount: _int(j['expenseCount']),
      netPaise: _int(j['netPaise']),
      ordersByStatus: ReportOrdersByStatus.fromJson(m(j['ordersByStatus'])),
      paymentMix: ReportPaymentMix.fromJson(m(j['paymentMix'])),
      expenseByCategory: l(j['expenseByCategory']).map(ReportCategorySpend.fromJson).toList(growable: false),
      topGarments: l(j['topGarments']).map(ReportTopGarment.fromJson).toList(growable: false),
      daily: l(j['daily']).map(ReportDay.fromJson).toList(growable: false),
    );
  }

  final String from;
  final String to;
  final int days;
  final int? orderCount;
  final int? revenuePaise;
  final int? collectionPaise;
  final int? duesPaise;
  final int? duesOrderCount;
  final int? expensesPaise;
  final int? expenseCount;
  final int? netPaise;
  final ReportOrdersByStatus ordersByStatus;
  final ReportPaymentMix paymentMix;
  final List<ReportCategorySpend> expenseByCategory;
  final List<ReportTopGarment> topGarments;
  final List<ReportDay> daily;
}
