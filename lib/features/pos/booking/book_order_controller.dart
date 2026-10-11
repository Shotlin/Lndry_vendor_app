import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../api/repositories/api_pos_repositories.dart';
import '../../../core/network/friendly_error.dart';
import '../../../core/services/storage_service.dart';
import '../../../models/pos/pos_catalogue_model.dart';
import '../../../models/pos/pos_customer_model.dart';
import '../../../models/pos/pos_order_model.dart';
import '../../../providers/app_mode_provider.dart';
import '../../../repositories/abstract/pos_repositories.dart';
import 'book_order_state.dart';

String draftKeyFor(String vendorId) => 'pos_order_draft_v1:$vendorId';

/// Default delivery is this many days after booking until the owner picks a date.
const int kDefaultDeliveryDays = 2;

String formatDate(DateTime d) => '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// Drives the Book Order screen.
///
///  * The server is the only source of money: every cart change asks `/orders/quote` (after [quoteDelay])
///    and the screen shows that answer. Saving is blocked until the answer matches the cart on screen.
///  * The cart survives a phone call or an app switch: it is written to the device after every change and
///    read back when the screen opens again.
///  * Tapping Save twice, or retrying after a dropped connection, books ONE order: the same
///    `Idempotency-Key` is reused until the owner changes something.
class BookOrderController extends StateNotifier<BookOrderState> {
  BookOrderController({
    required PosCounterRepository repo,
    required StorageService? storage,
    required String? vendorId,
    DateTime Function()? now,
    this.quoteDelay = const Duration(milliseconds: 300),
    String Function()? newKey,
  })  : _repo = repo,
        _storage = storage,
        _vendorId = vendorId,
        _now = now ?? DateTime.now,
        _newKey = newKey ?? (() => const Uuid().v4()),
        super(BookOrderState(expectedDate: formatDate((now ?? DateTime.now)().add(const Duration(days: kDefaultDeliveryDays))))) {
    _restore();
    if (state.lines.isNotEmpty) _scheduleQuote(immediate: true);
  }

  final PosCounterRepository _repo;
  final StorageService? _storage;
  final String? _vendorId;
  final DateTime Function() _now;
  final String Function() _newKey;
  final Duration quoteDelay;

  /// True when the screen opened with a cart read back from the device.
  bool restoredFromDraft = false;

  Timer? _timer;
  int _seq = 0;
  String? _idempotencyKey;
  String? _keyFingerprint;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ── Choices ───────────────────────────────────────────────────────────────

  void setCustomer(PosCustomer? c) => _change(state.copyWith(customer: c, clearCustomer: c == null), reprice: true);
  void setDate(DateTime d) => _change(state.copyWith(expectedDate: formatDate(d)));

  /// Home Delivery / Pickup are tapped on and off; both off means the customer collects at the counter.
  void toggleDeliveryMode(DeliveryMode m) => _change(state.copyWith(deliveryMode: state.deliveryMode == m ? DeliveryMode.walkIn : m));
  void setExpress({required bool value}) => _change(state.copyWith(isExpress: value));
  void setPayment(PosPaymentMode m) => _change(state.copyWith(paymentMode: m));
  void setNotes(String v) => _change(state.copyWith(notes: v));

  void selectService(String id) => _change(state.copyWith(serviceId: id));
  void selectCategory(String? id) => _change(state.copyWith(categoryId: id, clearCategory: id == null), persist: false);
  void setSearch(String v) => _change(state.copyWith(search: v), persist: false);

  void toggleCharge(String id) => _change(state.copyWith(chargeRuleIds: _toggled(state.chargeRuleIds, id)), reprice: true);
  void toggleDiscount(String id) => _change(state.copyWith(discountRuleIds: _toggled(state.discountRuleIds, id)), reprice: true);
  void selectTax(PosTaxRule? rule) =>
      _change(rule == null ? state.copyWith(clearTax: true) : state.copyWith(taxRuleId: rule.id, taxRateBps: rule.rateBps), reprice: true);

  List<String> _toggled(List<String> ids, String id) => ids.contains(id) ? ids.where((e) => e != id).toList() : [...ids, id];

  // ── Cart ──────────────────────────────────────────────────────────────────

  /// Adds one of [garmentId] in the selected service (or one more if already there).
  void add(String garmentId) {
    final service = state.serviceId;
    if (service == null) return;
    setQty(garmentId, service, state.qtyOf(garmentId, service) + 1);
  }

  void setQty(String garmentId, String serviceId, int qty) {
    final others = state.lines.where((l) => !l.matches(garmentId, serviceId)).toList();
    final index = state.lines.indexWhere((l) => l.matches(garmentId, serviceId));
    final next = [...others];
    if (qty > 0) {
      final line = CartLine(garmentId: garmentId, serviceId: serviceId, qty: qty > 9999 ? 9999 : qty);
      // Keep the line where it was, so the cart does not reshuffle while the owner taps + and −.
      next.insert(index < 0 || index > next.length ? next.length : index, line);
    }
    _change(state.copyWith(lines: next), reprice: true);
  }

  void remove(String garmentId, String serviceId) => setQty(garmentId, serviceId, 0);

  /// After the price list is (re)loaded: drop cart lines whose garment/service/price no longer exists, and
  /// pick a first service if none is chosen. Returns how many lines were dropped.
  int reconcile(PosCatalogue catalogue) {
    final kept = state.lines.where((l) => catalogue.garment(l.garmentId)?.active == true && catalogue.service(l.serviceId)?.active == true && catalogue.priceOf(l.garmentId, l.serviceId) != null).toList();
    final dropped = state.lines.length - kept.length;
    final services = catalogue.activeServices;
    final serviceOk = state.serviceId != null && services.any((s) => s.id == state.serviceId);
    final taxOk = state.taxRuleId == null || catalogue.activeTaxRules.any((t) => t.id == state.taxRuleId);
    if (dropped == 0 && serviceOk && taxOk) return 0;
    var next = state;
    if (dropped > 0) next = next.copyWith(lines: kept);
    if (!serviceOk) next = services.isEmpty ? next : next.copyWith(serviceId: services.first.id);
    if (!taxOk) next = next.copyWith(clearTax: true);
    _change(next, reprice: dropped > 0 || !taxOk);
    return dropped;
  }

  /// Drops rule ids the shop no longer has (so a deleted discount cannot block saving).
  void reconcileRules({required Set<String> chargeIds, required Set<String> discountIds}) {
    final c = state.chargeRuleIds.where(chargeIds.contains).toList();
    final d = state.discountRuleIds.where(discountIds.contains).toList();
    if (c.length == state.chargeRuleIds.length && d.length == state.discountRuleIds.length) return;
    _change(state.copyWith(chargeRuleIds: c, discountRuleIds: d), reprice: true);
  }

  // ── Server price ──────────────────────────────────────────────────────────

  void retryQuote() => _scheduleQuote(immediate: true);

  void _scheduleQuote({bool immediate = false}) {
    _timer?.cancel();
    final seq = ++_seq;
    if (state.lines.isEmpty) {
      state = state.copyWith(clearQuote: true, quoteStatus: QuoteStatus.idle, clearQuoteError: true);
      return;
    }
    state = state.copyWith(quoteStatus: QuoteStatus.loading, clearQuoteError: true);
    final request = state.request;
    final key = request.priceKey;
    Future<void> run() async {
      try {
        final quote = await _repo.quote(request);
        if (!mounted || seq != _seq) return; // a newer cart was asked for meanwhile
        state = state.copyWith(quote: quote, quotedKey: key, quoteStatus: QuoteStatus.ready, clearQuoteError: true);
      } catch (e) {
        if (!mounted || seq != _seq) return;
        state = state.copyWith(quoteStatus: QuoteStatus.failed, quoteError: friendlyError(e));
      }
    }

    if (immediate || quoteDelay == Duration.zero) {
      unawaited(run());
    } else {
      _timer = Timer(quoteDelay, run);
    }
  }

  // ── Save ──────────────────────────────────────────────────────────────────

  Future<BookedOrder?> save() async {
    if (!state.canSave) return null;
    // One key per distinct order: a retry of the SAME order (dropped connection, double tap) reuses it and the
    // server returns the order it already made; once anything about the order changes it gets a fresh key.
    final fingerprint = jsonEncode(state.request.toJson());
    if (_idempotencyKey == null || _keyFingerprint != fingerprint) {
      _idempotencyKey = _newKey();
      _keyFingerprint = fingerprint;
    }
    state = state.copyWith(saving: true, clearSaveError: true);
    try {
      final order = await _repo.book(state.request, idempotencyKey: _idempotencyKey!);
      if (!mounted) return order;
      _idempotencyKey = null;
      _keyFingerprint = null;
      await _clearDraft();
      if (!mounted) return order;
      state = state.copyWith(saving: false, booked: order);
      return order;
    } catch (e) {
      if (mounted) state = state.copyWith(saving: false, saveError: friendlyError(e));
      return null;
    }
  }

  /// "Book Another": a clean cart. The customer and choices of the finished order are forgotten.
  void reset() {
    _timer?.cancel();
    _seq++;
    _idempotencyKey = null;
    _keyFingerprint = null;
    final services = state.serviceId;
    state = BookOrderState(expectedDate: formatDate(_now().add(const Duration(days: kDefaultDeliveryDays))), serviceId: services);
    unawaited(_clearDraft());
  }

  // ── Plumbing ──────────────────────────────────────────────────────────────

  void _change(BookOrderState next, {bool reprice = false, bool persist = true}) {
    state = next.copyWith(clearSaveError: true);
    if (reprice) _scheduleQuote();
    if (persist) unawaited(_persist());
  }

  Future<void> _persist() async {
    final storage = _storage;
    final vendor = _vendorId;
    if (storage == null || vendor == null || state.booked != null) return;
    final s = state;
    if (s.lines.isEmpty && s.customer == null && s.notes.isEmpty) {
      await storage.remove(draftKeyFor(vendor));
      return;
    }
    await storage.saveString(
      draftKeyFor(vendor),
      jsonEncode({
        'customer': s.customer?.toJson(),
        'date': s.expectedDate,
        'deliveryMode': s.deliveryMode.wire,
        'express': s.isExpress,
        'serviceId': s.serviceId,
        'lines': [for (final l in s.lines) l.toJson()],
        'payment': s.paymentMode.wire,
        'notes': s.notes,
        'chargeRuleIds': s.chargeRuleIds,
        'discountRuleIds': s.discountRuleIds,
        'taxRuleId': s.taxRuleId,
        'taxRateBps': s.taxRateBps,
      }),
    );
  }

  Future<void> _clearDraft() async {
    final vendor = _vendorId;
    if (_storage != null && vendor != null) await _storage.remove(draftKeyFor(vendor));
  }

  void _restore() {
    final storage = _storage;
    final vendor = _vendorId;
    if (storage == null || vendor == null) return;
    final raw = storage.getString(draftKeyFor(vendor));
    if (raw == null) return;
    try {
      final j = jsonDecode(raw) as Map<String, dynamic>;
      final saved = j['date']?.toString();
      final today = formatDate(_now());
      // A date that has already passed is replaced by the default.
      final date = saved != null && saved.compareTo(today) >= 0 ? saved : state.expectedDate;
      final c = j['customer'];
      state = BookOrderState(
        expectedDate: date,
        customer: c is Map<String, dynamic> ? PosCustomer.fromJson(c) : null,
        deliveryMode: DeliveryMode.parse(j['deliveryMode']),
        isExpress: j['express'] == true,
        serviceId: j['serviceId']?.toString(),
        lines: (j['lines'] is List ? j['lines'] as List : const <dynamic>[]).whereType<Map<String, dynamic>>().map(CartLine.fromJson).where((l) => l.qty > 0).toList(),
        paymentMode: PosPaymentMode.parse(j['payment']),
        notes: (j['notes'] ?? '').toString(),
        chargeRuleIds: (j['chargeRuleIds'] is List ? j['chargeRuleIds'] as List : const <dynamic>[]).map((e) => e.toString()).toList(),
        discountRuleIds: (j['discountRuleIds'] is List ? j['discountRuleIds'] as List : const <dynamic>[]).map((e) => e.toString()).toList(),
        taxRuleId: j['taxRuleId']?.toString(),
        taxRateBps: j['taxRateBps'] is num ? (j['taxRateBps'] as num).toInt() : null,
      );
      restoredFromDraft = state.lines.isNotEmpty || state.customer != null;
    } catch (_) {
      // A damaged draft is thrown away rather than crashing the screen.
      unawaited(_clearDraft());
    }
  }
}

final bookOrderControllerProvider = StateNotifierProvider.autoDispose<BookOrderController, BookOrderState>((ref) {
  final vendorId = ref.watch(appModeProvider.select((s) => s.info?.vendorId));
  return BookOrderController(
    repo: ref.watch(posCounterRepositoryProvider),
    storage: ref.watch(storageServiceProvider),
    vendorId: vendorId,
  );
});
