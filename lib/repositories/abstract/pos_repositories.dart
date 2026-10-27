import 'dart:typed_data';

import '../../models/pos/pos_catalogue_model.dart';
import '../../models/pos/pos_counter_order_model.dart';
import '../../models/pos/pos_customer_detail_model.dart';
import '../../models/pos/pos_customer_model.dart';
import '../../models/pos/pos_dashboard_model.dart';
import '../../models/pos/pos_money_model.dart';
import '../../models/pos/pos_order_model.dart';
import '../../models/pos/pos_search_model.dart';
import '../../models/pos/pos_settings_model.dart';

abstract class PosDashboardRepository {
  Future<PosDashboard> getDashboard();
}

abstract class PosCatalogueRepository {
  Future<PosCatalogue> getCatalogue();
  Future<PosCategory> createCategory(String name);
  Future<PosService> createService(String name);
  Future<PosGarment> createGarment({required String name, required String unit, String? categoryId});

  /// Adds a shop-wide price for (garment, service).
  Future<PosPrice> createPrice({required String garmentId, required String serviceId, required int ratePaise});
  Future<PosPrice> updatePrice({required String priceId, required int ratePaise});

  /// `kind` is `charge` or `discount`.
  Future<List<PosAdjustmentRule>> listRules(String kind);
}

abstract class PosCounterRepository {
  /// Customers who have bought from this shop, newest first. An empty [search] returns the recent ones.
  Future<List<PosCustomer>> searchCustomers(String search);

  /// Finds the customer by phone or creates them.
  Future<PosCustomer> createCustomer({required String name, required String phone});

  Future<PosQuote> quote(OrderRequest request);

  /// [idempotencyKey] (a UUID v4) makes a retried save return the same order instead of booking twice.
  Future<BookedOrder> book(OrderRequest request, {required String idempotencyKey});
}

/// A PDF the server rendered (invoice or mini bill).
class PosPdf {
  const PosPdf({required this.bytes, required this.fileName});
  final Uint8List bytes;
  final String fileName;
}

/// Counter orders after booking: list, detail, moving along, paying, cancelling, bills and tags.
abstract class PosOrdersRepository {
  /// One page of the list, newest first. A page shorter than [limit] is the last one.
  Future<List<CounterOrder>> listOrders(OrderFilter filter, {int limit = 30, int offset = 0});

  Future<OrderDetail> getOrder(String id);

  /// Delivery date, delivery mode, express and remarks only — what the server lets an open order change.
  Future<CounterOrder> updateOrder(String id, OrderEdit edit, {int? version});

  /// What the order would cost with these garment lines. Saves nothing.
  Future<OrderEditPreview> previewOrderItems(String id, List<CartLine> lines);

  /// Moves the order to [state]. [allowIncomplete] ("mark ready anyway") and [allowUnpaid] ("deliver with balance due")
  /// are only ever set after the owner has said so.
  Future<CounterOrder> transition(String id, String state, {bool allowIncomplete = false, bool allowUnpaid = false, int? version});

  Future<CounterOrder> cancel(String id, String reason);

  Future<CounterOrder> assignCaptain(String id, {String? pickupCaptainId, String? deliveryCaptainId});

  /// Records a payment of [amountPaise] (> 0, never above the balance — the server refuses it too).
  /// [mode] is `CASH`, `UPI`, `CARD` or `BANK`. Returns the order with its new paid / balance.
  Future<({CounterOrder order, List<OrderPayment> payments})> collectPayment(String id, {required int amountPaise, required String mode, String? reference});

  Future<List<OrderCaptain>> listCaptains();

  /// Logs that tags were printed / shared for an order (best effort — the print history is a record, not a gate).
  Future<String?> createTagPrintJob(String orderId, List<String> garmentUnitIds);
  Future<void> markPrintJobPrinted(String jobId);

  /// The issued A4 invoice (delivered orders only).
  Future<PosPdf> invoicePdf(String id);

  /// The narrow counter bill for 58 or 80 mm paper.
  Future<PosPdf> miniBillPdf(String id, {int paperMm = 80});
}

/// The Search tab: one box for orders, customers and garment tags.
abstract class PosSearchRepository {
  /// [query] must be at least 2 characters (the server refuses less).
  Future<PosSearchResults> search(String query);
}

/// Customers beyond the booking picker: the profile with orders and dues.
abstract class PosCustomersRepository {
  Future<PosCustomerDetail> detail(String customerId);
}

/// Expenses and the cash drawer.
abstract class PosExpenseRepository {
  /// Expenses dated `from`..`to` (`YYYY-MM-DD`, inclusive), newest first; cancelled ones are included and marked.
  Future<List<PosExpense>> listExpenses({required String from, required String to, int limit = 100});
  Future<PosExpense> createExpense(ExpenseDraft draft);
  Future<PosExpense> updateExpense(String id, ExpenseDraft draft, {required String reason});
  Future<PosExpense> cancelExpense(String id, {required String reason});

  /// The open drawer session, or `null` when none is open.
  Future<CashShift?> currentShift();
  Future<CashShift> openShift({required int openingCashPaise, String? note});

  /// Closes the drawer. A count that differs from the expected cash needs [note] and [approvedBy] (the server insists).
  Future<CashShift> closeShift(String id, {required int countedCashPaise, String? note, String? approvedBy});
  Future<List<CashShift>> listShifts({int limit = 10});
}

abstract class PosReportRepository {
  Future<PosReport> report({required String from, required String to});

  /// The counter sales in the range as CSV text (header + one row per order).
  Future<String> exportCsv({required String from, required String to});
}

abstract class PosSettingsRepository {
  /// The shop's saved WhatsApp messages, or the defaults when none were saved.
  Future<List<MessageTemplate>> messageTemplates();
  Future<List<PosStaffMember>> staff();
}
