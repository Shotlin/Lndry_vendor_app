import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/network/friendly_error.dart';
import '../../../core/router/app_routes.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../models/pos/pos_catalogue_model.dart';
import '../../../models/pos/pos_order_model.dart';
import '../core/money.dart';
import '../core/pos_providers.dart';
import '../core/pos_theme.dart';
import '../core/pos_widgets.dart';
import '../customers/customer_picker.dart';
import 'add_garment_price_sheet.dart';
import 'book_order_controller.dart';
import 'book_order_state.dart';
import 'cart_panel.dart';
import 'garment_grid.dart';
import 'payment_picker.dart';
import 'totals_card.dart';

/// Book Order: customer → how it travels → garments → bill → payment → Save.
class BookOrderPage extends ConsumerStatefulWidget {
  const BookOrderPage({super.key});

  @override
  ConsumerState<BookOrderPage> createState() => _BookOrderPageState();
}

class _BookOrderPageState extends ConsumerState<BookOrderPage> {
  final _notes = TextEditingController();
  final _search = TextEditingController();
  bool _noticeShown = false;

  @override
  void dispose() {
    _notes.dispose();
    _search.dispose();
    super.dispose();
  }

  BookOrderController get _c => ref.read(bookOrderControllerProvider.notifier);

  @override
  void initState() {
    super.initState();
    // A cart read back from the device: say so once, and show its remarks.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _notes.text = ref.read(bookOrderControllerProvider).notes;
      if (_c.restoredFromDraft && !_noticeShown) {
        _noticeShown = true;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(behavior: SnackBarBehavior.fixed, content: Text(AppLocalizations.of(context).posBookDraftRestored)));
      }
    });
  }

  Future<void> _pickCustomer() async {
    final c = await showCustomerPicker(context);
    if (c != null) _c.setCustomer(c);
  }

  Future<void> _pickDate(BookOrderState s) async {
    final today = DateUtils.dateOnly(DateTime.now());
    final current = DateTime.tryParse(s.expectedDate) ?? today;
    final picked = await showDatePicker(
      context: context,
      initialDate: current.isBefore(today) ? today : current,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
    );
    if (picked != null) _c.setDate(picked);
  }

  Future<void> _addPrice({String? garmentId, String? serviceId}) async {
    final saved = await showAddGarmentPriceSheet(context, garmentId: garmentId, serviceId: serviceId);
    if (saved == true && mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(behavior: SnackBarBehavior.fixed, content: Text(AppLocalizations.of(context).posPriceSaved)));
  }

  Future<void> _confirmClear() async {
    final l10n = AppLocalizations.of(context);
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.posBookClearTitle),
        content: Text(l10n.posBookClearBody),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text(l10n.posCancel)),
          FilledButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text(l10n.posBookClear)),
        ],
      ),
    );
    if (yes == true) {
      _c.reset();
      _notes.clear();
    }
  }

  Future<void> _save() async {
    final order = await _c.save();
    if (order == null || !mounted) return;
    ref.invalidate(posDashboardProvider);
    ref.invalidate(posCustomerSearchProvider);
    await _showSaved(order);
  }

  Future<void> _showSaved(BookedOrder order) async {
    final goToOrders = await showModalBottomSheet<bool>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      useSafeArea: true,
      builder: (_) => PosThemeScope(child: _SavedSheet(order: order)),
    );
    if (!mounted) return;
    _c.reset();
    _notes.clear();
    if (goToOrders == true) context.go(AppRoutes.posOrders);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final s = ref.watch(bookOrderControllerProvider);
    final catalogue = ref.watch(posCatalogueProvider);
    final charges = ref.watch(posChargeRulesProvider).valueOrNull ?? const <PosAdjustmentRule>[];
    final discounts = ref.watch(posDiscountRulesProvider).valueOrNull ?? const <PosAdjustmentRule>[];
    final canManage = ref.watch(posCanManageCatalogueProvider);

    ref.listen<AsyncValue<PosCatalogue>>(posCatalogueProvider, (prev, next) {
      final c = next.valueOrNull;
      if (c == null) return;
      final dropped = _c.reconcile(c);
      if (dropped > 0) {
        // Replaces the "restored" note: the more important message must not wait behind it.
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(behavior: SnackBarBehavior.fixed, content: Text(l10n.posBookDropped(dropped))));
      }
    });
    ref.listen<AsyncValue<List<PosAdjustmentRule>>>(posChargeRulesProvider, (_, next) {
      final ids = next.valueOrNull?.map((r) => r.id).toSet();
      if (ids != null) _c.reconcileRules(chargeIds: ids, discountIds: (ref.read(posDiscountRulesProvider).valueOrNull ?? const []).map((r) => r.id).toSet());
    });
    ref.listen<AsyncValue<List<PosAdjustmentRule>>>(posDiscountRulesProvider, (_, next) {
      final ids = next.valueOrNull?.map((r) => r.id).toSet();
      if (ids != null) _c.reconcileRules(chargeIds: (ref.read(posChargeRulesProvider).valueOrNull ?? const []).map((r) => r.id).toSet(), discountIds: ids);
    });

    return PosThemeScope(
      child: Builder(builder: (context) {
        final scheme = Theme.of(context).colorScheme;
        final hasContent = s.lines.isNotEmpty || s.customer != null;
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.posBookTitle),
            actions: [if (hasContent && !s.saving) TextButton(onPressed: _confirmClear, child: Text(l10n.posBookClear))],
          ),
          body: catalogue.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.topCenter,
                child: PosErrorNote(message: '${l10n.posBookCatalogueError}\n${friendlyError(e)}', onRetry: () => ref.invalidate(posCatalogueProvider), retryLabel: l10n.posRetry),
              ),
            ),
            data: (cat) => _body(context, s, cat, charges, discounts, canManage, scheme),
          ),
          bottomNavigationBar: _SaveBar(state: s, onSave: _save),
        );
      }),
    );
  }

  Widget _body(BuildContext context, BookOrderState s, PosCatalogue cat, List<PosAdjustmentRule> charges, List<PosAdjustmentRule> discounts, bool canManage, ColorScheme scheme) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final services = cat.activeServices;
    final garments = cat.garmentsFor(serviceId: s.serviceId, categoryId: s.categoryId, search: s.search);
    final date = DateTime.tryParse(s.expectedDate);
    final dateText = date == null ? s.expectedDate : DateFormat.yMMMEd(Localizations.localeOf(context).toString()).format(date);

    Widget title(String t) => Padding(
          padding: const EdgeInsets.only(top: 18, bottom: 8),
          child: Semantics(header: true, child: Text(t, style: text.titleMedium)),
        );

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          sliver: SliverList.list(children: [
            // Customer + delivery date
            _InfoTile(
              icon: Icons.person_rounded,
              label: l10n.posBookCustomer,
              value: s.customer == null ? l10n.posCustomerPick : s.customer!.displayName,
              detail: s.customer?.phone,
              emphasised: s.customer == null,
              onTap: _pickCustomer,
            ),
            const SizedBox(height: 10),
            _InfoTile(icon: Icons.event_rounded, label: l10n.posBookDeliveryDate, value: dateText, onTap: () => _pickDate(s)),
            const SizedBox(height: 12),
            Wrap(spacing: 8, runSpacing: 8, children: [
              _ToggleChip(icon: Icons.home_rounded, label: l10n.posBookHomeDelivery, on: s.deliveryMode == DeliveryMode.homeDelivery, onTap: () => _c.toggleDeliveryMode(DeliveryMode.homeDelivery)),
              _ToggleChip(icon: Icons.directions_walk_rounded, label: l10n.posBookPickup, on: s.deliveryMode == DeliveryMode.pickup, onTap: () => _c.toggleDeliveryMode(DeliveryMode.pickup)),
              _ToggleChip(icon: Icons.bolt_rounded, label: l10n.posBookExpress, on: s.isExpress, onTap: () => _c.setExpress(value: !s.isExpress)),
            ]),
            if (services.isEmpty) ...[
              const SizedBox(height: 16),
              PosErrorNote(message: l10n.posBookNoServices, onRetry: canManage ? () => _addPrice() : null, retryLabel: l10n.posActionAddPrice),
            ] else ...[
              title(l10n.posBookService),
              SizedBox(
                height: 48,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: services.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) => ChoiceChip(
                    label: Text(services[i].name),
                    selected: s.serviceId == services[i].id,
                    showCheckmark: true,
                    onSelected: (_) => _c.selectService(services[i].id),
                  ),
                ),
              ),
              title(l10n.posBookCategory),
              SizedBox(
                height: 48,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: cat.activeCategories.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    if (i == 0) return ChoiceChip(label: Text(l10n.posBookAll), selected: s.categoryId == null, onSelected: (_) => _c.selectCategory(null));
                    final cc = cat.activeCategories[i - 1];
                    return ChoiceChip(label: Text(cc.name), selected: s.categoryId == cc.id, onSelected: (_) => _c.selectCategory(cc.id));
                  },
                ),
              ),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(
                  child: TextField(
                    controller: _search,
                    onChanged: _c.setSearch,
                    decoration: InputDecoration(
                      hintText: l10n.posBookSearchGarment,
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: s.search.isEmpty ? null : IconButton(icon: const Icon(Icons.close_rounded), onPressed: () { _search.clear(); _c.setSearch(''); }),
                    ),
                  ),
                ),
                if (canManage) ...[
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: () => _addPrice(),
                    tooltip: l10n.posActionAddPrice,
                    icon: const Icon(Icons.add_rounded),
                    constraints: const BoxConstraints(minWidth: PosTheme.minTouch, minHeight: PosTheme.minTouch),
                  ),
                ],
              ]),
              const SizedBox(height: 12),
            ],
          ]),
        ),
        if (services.isNotEmpty && garments.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Center(child: Text(s.search.trim().isNotEmpty ? l10n.posBookNoMatch(s.search.trim()) : l10n.posBookNoGarments, style: text.bodyMedium, textAlign: TextAlign.center)),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 200, mainAxisExtent: 132, crossAxisSpacing: 10, mainAxisSpacing: 10),
              itemCount: garments.length,
              itemBuilder: (_, i) {
                final g = garments[i];
                final price = cat.priceOf(g.id, s.serviceId!)!;
                return GarmentTile(garment: g, ratePaise: price.ratePaise, qty: s.qtyOf(g.id, s.serviceId!), onSetQty: (q) => _c.setQty(g.id, s.serviceId!, q));
              },
            ),
          ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          sliver: SliverList.list(children: [
            title(l10n.posBookSelected),
            CartPanel(
              lines: s.lines,
              catalogue: cat,
              quote: s.quote,
              quoteIsCurrent: s.quoteIsCurrent,
              canChangePrice: canManage,
              onSetQty: (line, q) => _c.setQty(line.garmentId, line.serviceId, q),
              onChangePrice: (line) => _addPrice(garmentId: line.garmentId, serviceId: line.serviceId),
            ),
            if (charges.isNotEmpty || discounts.isNotEmpty || cat.activeTaxRules.isNotEmpty) ...[
              title(l10n.posBookExtras),
              _Extras(state: s, charges: charges, discounts: discounts, taxRules: cat.activeTaxRules, controller: _c),
            ],
            title(l10n.posBookBill),
            TotalsCard(state: s, onRetry: _c.retryQuote),
            title(l10n.posBookPayment),
            PaymentPicker(selected: s.paymentMode, onChanged: _c.setPayment),
            title(l10n.posBookRemarks),
            TextField(
              controller: _notes,
              onChanged: _c.setNotes,
              maxLines: 3,
              minLines: 2,
              maxLength: 1000,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(hintText: l10n.posBookRemarks),
            ),
          ]),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.icon, required this.label, required this.value, required this.onTap, this.detail, this.emphasised = false});
  final IconData icon;
  final String label;
  final String value;
  final String? detail;
  final bool emphasised;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      label: '$label: $value${detail == null ? '' : ', $detail'}',
      excludeSemantics: true,
      onTap: onTap,
      child: Material(
        color: emphasised ? scheme.primaryContainer : scheme.surface,
        borderRadius: BorderRadius.circular(PosTheme.radius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(PosTheme.radius),
          child: Container(
            constraints: const BoxConstraints(minHeight: 64),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(PosTheme.radius), border: Border.all(color: emphasised ? scheme.primary : scheme.outline, width: emphasised ? 2 : 1)),
            child: Row(children: [
              Icon(icon, color: scheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(label, style: text.labelMedium?.copyWith(color: scheme.onSurfaceVariant)),
                  Text(value, style: text.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                  if (detail != null && detail!.isNotEmpty) Text(detail!, style: text.bodySmall),
                ]),
              ),
              Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant),
            ]),
          ),
        ),
      ),
    );
  }
}

class _ToggleChip extends StatelessWidget {
  const _ToggleChip({required this.icon, required this.label, required this.on, required this.onTap});
  final IconData icon;
  final String label;
  final bool on;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => FilterChip(
        avatar: Icon(on ? Icons.check_rounded : icon, size: 18),
        label: Text(label),
        selected: on,
        showCheckmark: false,
        onSelected: (_) => onTap(),
        materialTapTargetSize: MaterialTapTargetSize.padded,
        visualDensity: VisualDensity.comfortable,
      );
}

class _Extras extends StatelessWidget {
  const _Extras({required this.state, required this.charges, required this.discounts, required this.taxRules, required this.controller});
  final BookOrderState state;
  final List<PosAdjustmentRule> charges;
  final List<PosAdjustmentRule> discounts;
  final List<PosTaxRule> taxRules;
  final BookOrderController controller;

  String _ruleText(PosAdjustmentRule r) =>
      r.isPercentage && r.percentageBps != null ? '${r.name} (${percentFromBps(r.percentageBps!)}%)' : (r.flatPaise != null ? '${r.name} (${formatPaise(r.flatPaise)})' : r.name);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    Widget group(String title, List<Widget> chips) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: const EdgeInsets.only(top: 4, bottom: 6), child: Text(title, style: text.labelLarge)),
            Wrap(spacing: 8, runSpacing: 8, children: chips),
          ],
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (charges.isNotEmpty)
          group(l10n.posBookChargesLabel, [
            for (final r in charges) FilterChip(label: Text(_ruleText(r)), selected: state.chargeRuleIds.contains(r.id), onSelected: (_) => controller.toggleCharge(r.id)),
          ]),
        if (discounts.isNotEmpty)
          group(l10n.posBookDiscountsLabel, [
            for (final r in discounts) FilterChip(label: Text(_ruleText(r)), selected: state.discountRuleIds.contains(r.id), onSelected: (_) => controller.toggleDiscount(r.id)),
          ]),
        if (taxRules.isNotEmpty)
          group(l10n.posBookGstLabel, [
            ChoiceChip(label: Text(l10n.posBookNoGst), selected: state.taxRuleId == null, onSelected: (_) => controller.selectTax(null)),
            for (final t in taxRules) ChoiceChip(label: Text('${t.name} (${percentFromBps(t.rateBps)}%)'), selected: state.taxRuleId == t.id, onSelected: (_) => controller.selectTax(t)),
          ]),
      ],
    );
  }
}

/// Grand total + the one big Save button. When Save is off it says why, in words.
class _SaveBar extends StatelessWidget {
  const _SaveBar({required this.state, required this.onSave});
  final BookOrderState state;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    String? why;
    if (state.lines.isEmpty) {
      why = l10n.posBookNeedGarment;
    } else if (state.customer == null) {
      why = l10n.posBookNeedCustomer;
    } else if (state.quoteStatus == QuoteStatus.failed) {
      why = l10n.posBookQuoteError;
    } else if (!state.canSave && !state.saving) {
      why = l10n.posBookWaitPrice;
    }
    return PosThemeScope(
      child: Builder(builder: (context) {
        return Material(
          elevation: 8,
          color: Theme.of(context).colorScheme.surface,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (state.saveError != null) ...[
                    PosErrorNote(message: state.saveError!),
                    const SizedBox(height: 8),
                  ],
                  Row(children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(l10n.posBookGrandTotal, style: text.labelMedium?.copyWith(color: scheme.onSurfaceVariant)),
                      Text(formatPaise(state.quoteIsCurrent ? state.quote?.totalPaise : null), style: text.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                    ]),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: state.canSave ? onSave : null,
                        icon: state.saving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5)) : const Icon(Icons.check_circle_rounded),
                        label: Text(state.saving ? l10n.posBookSaving : l10n.posBookSave),
                        style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
                      ),
                    ),
                  ]),
                  if (why != null) Padding(padding: const EdgeInsets.only(top: 6), child: Text(why, style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant), textAlign: TextAlign.end)),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _SavedSheet extends StatelessWidget {
  const _SavedSheet({required this.order});
  final BookedOrder order;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final paid = posToneColors(context, PosTone.success);
    final due = posToneColors(context, PosTone.attention);
    Widget cell(String label, String value, ({Color fg, Color bg}) c) => Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: c.bg, borderRadius: BorderRadius.circular(12)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: text.labelMedium?.copyWith(color: c.fg)),
              FittedBox(fit: BoxFit.scaleDown, child: Text(value, style: text.titleMedium?.copyWith(color: c.fg, fontWeight: FontWeight.w800))),
            ]),
          ),
        );
    final neutral = posToneColors(context, PosTone.neutral);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(child: Icon(Icons.check_circle_rounded, size: 56, color: paid.fg)),
          const SizedBox(height: 8),
          Text(l10n.posBookSavedTitle, textAlign: TextAlign.center, style: text.titleLarge),
          Text(l10n.posBookSavedBody(order.orderNumber, order.customer.displayName), textAlign: TextAlign.center, style: text.bodyMedium),
          const SizedBox(height: 16),
          Row(children: [
            cell(l10n.posBookSavedTotal, formatPaise(order.totalPaise), neutral),
            const SizedBox(width: 8),
            cell(l10n.posBookSavedPaid, formatPaise(order.amountPaidPaise), paid),
            const SizedBox(width: 8),
            cell(l10n.posBookSavedBalance, formatPaise(order.balancePaise), order.balancePaise > 0 ? due : neutral),
          ]),
          const SizedBox(height: 20),
          FilledButton.icon(onPressed: () => Navigator.of(context).pop(true), icon: const Icon(Icons.receipt_long_rounded), label: Text(l10n.posBookViewOrder), style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56))),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pop(false),
            icon: const Icon(Icons.add_shopping_cart_rounded),
            label: Text(l10n.posBookAnother),
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(56), side: BorderSide(color: scheme.primary)),
          ),
        ],
      ),
    );
  }
}
