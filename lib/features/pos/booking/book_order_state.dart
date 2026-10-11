import '../../../models/pos/pos_customer_model.dart';
import '../../../models/pos/pos_order_model.dart';

enum QuoteStatus { idle, loading, ready, failed }

/// Everything on the Book Order screen. The cart (lines + qty) and the choices are the app's; the
/// money (`quote`) is only ever what the server answered for the choices in [priceKey].
class BookOrderState {
  const BookOrderState({
    required this.expectedDate,
    this.customer,
    this.deliveryMode = DeliveryMode.walkIn,
    this.isExpress = false,
    this.serviceId,
    this.categoryId,
    this.search = '',
    this.lines = const [],
    this.paymentMode = PosPaymentMode.payLater,
    this.notes = '',
    this.chargeRuleIds = const [],
    this.discountRuleIds = const [],
    this.taxRuleId,
    this.taxRateBps,
    this.quote,
    this.quoteStatus = QuoteStatus.idle,
    this.quoteError,
    this.quotedKey,
    this.saving = false,
    this.saveError,
    this.booked,
  });

  /// `YYYY-MM-DD`
  final String expectedDate;
  final PosCustomer? customer;
  final DeliveryMode deliveryMode;
  final bool isExpress;
  final String? serviceId;
  final String? categoryId;
  final String search;
  final List<CartLine> lines;
  final PosPaymentMode paymentMode;
  final String notes;
  final List<String> chargeRuleIds;
  final List<String> discountRuleIds;
  final String? taxRuleId;
  final int? taxRateBps;
  final PosQuote? quote;
  final QuoteStatus quoteStatus;
  final String? quoteError;

  /// The [priceKey] the current [quote] was computed for.
  final String? quotedKey;
  final bool saving;
  final String? saveError;
  final BookedOrder? booked;

  OrderRequest get request => OrderRequest(
        lines: lines,
        customerId: customer?.id,
        expectedDeliveryDate: expectedDate,
        deliveryMode: deliveryMode,
        isExpress: isExpress,
        paymentMode: paymentMode,
        notes: notes,
        chargeRuleIds: chargeRuleIds,
        discountRuleIds: discountRuleIds,
        taxRatePercent: taxRateBps == null ? null : taxRateBps! / 100,
      );

  int get totalQty => lines.fold(0, (sum, l) => sum + l.qty);
  int qtyOf(String garmentId, String serviceId) {
    for (final l in lines) {
      if (l.matches(garmentId, serviceId)) return l.qty;
    }
    return 0;
  }

  /// The quote on screen belongs to the cart on screen (not to an older cart).
  bool get quoteIsCurrent => quote != null && quotedKey == request.priceKey;

  /// Save is possible only for a real customer, a non-empty cart and a server price for exactly this cart.
  bool get canSave => lines.isNotEmpty && customer != null && quoteStatus == QuoteStatus.ready && quoteIsCurrent && !saving && booked == null;

  BookOrderState copyWith({
    String? expectedDate,
    PosCustomer? customer,
    bool clearCustomer = false,
    DeliveryMode? deliveryMode,
    bool? isExpress,
    String? serviceId,
    String? categoryId,
    bool clearCategory = false,
    String? search,
    List<CartLine>? lines,
    PosPaymentMode? paymentMode,
    String? notes,
    List<String>? chargeRuleIds,
    List<String>? discountRuleIds,
    String? taxRuleId,
    int? taxRateBps,
    bool clearTax = false,
    PosQuote? quote,
    bool clearQuote = false,
    QuoteStatus? quoteStatus,
    String? quoteError,
    bool clearQuoteError = false,
    String? quotedKey,
    bool? saving,
    String? saveError,
    bool clearSaveError = false,
    BookedOrder? booked,
  }) =>
      BookOrderState(
        expectedDate: expectedDate ?? this.expectedDate,
        customer: clearCustomer ? null : (customer ?? this.customer),
        deliveryMode: deliveryMode ?? this.deliveryMode,
        isExpress: isExpress ?? this.isExpress,
        serviceId: serviceId ?? this.serviceId,
        categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
        search: search ?? this.search,
        lines: lines ?? this.lines,
        paymentMode: paymentMode ?? this.paymentMode,
        notes: notes ?? this.notes,
        chargeRuleIds: chargeRuleIds ?? this.chargeRuleIds,
        discountRuleIds: discountRuleIds ?? this.discountRuleIds,
        taxRuleId: clearTax ? null : (taxRuleId ?? this.taxRuleId),
        taxRateBps: clearTax ? null : (taxRateBps ?? this.taxRateBps),
        quote: clearQuote ? null : (quote ?? this.quote),
        quoteStatus: quoteStatus ?? this.quoteStatus,
        quoteError: clearQuoteError ? null : (quoteError ?? this.quoteError),
        quotedKey: clearQuote ? null : (quotedKey ?? this.quotedKey),
        saving: saving ?? this.saving,
        saveError: clearSaveError ? null : (saveError ?? this.saveError),
        booked: booked ?? this.booked,
      );
}
