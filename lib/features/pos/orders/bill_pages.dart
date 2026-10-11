import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/repositories/api_pos_repositories.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../models/pos/pos_counter_order_model.dart';
import '../../../providers/app_mode_provider.dart';
import '../../../repositories/abstract/pos_repositories.dart';
import '../core/pos_widgets.dart';
import 'order_errors.dart';
import 'order_labels.dart';
import 'orders_providers.dart';
import 'pdf_viewer.dart';
import 'tag_pdf.dart';

/// Which PDF: the issued A4 invoice, or the narrow bill for 58 / 80 mm paper.
typedef BillKey = ({String orderId, bool mini, int paper});

final posBillProvider =
    FutureProvider.autoDispose.family<PosPdf, BillKey>((ref, k) {
  final repo = ref.watch(posOrdersRepositoryProvider);
  return k.mini
      ? repo.miniBillPdf(k.orderId, paperMm: k.paper)
      : repo.invoicePdf(k.orderId);
});

/// The invoice (A4, delivered orders) or the mini bill (58/80 mm), in the app, with Share and Print.
/// The server draws it from the same numbers as the order; nothing is worked out here.
class BillPage extends ConsumerStatefulWidget {
  const BillPage({required this.orderId, required this.mini, super.key});
  final String orderId;
  final bool mini;

  @override
  ConsumerState<BillPage> createState() => _BillPageState();
}

class _BillPageState extends ConsumerState<BillPage> {
  int _paper = 80;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final key = (orderId: widget.orderId, mini: widget.mini, paper: _paper);
    final pdf = ref.watch(posBillProvider(key));
    return PosThemeScope(
      child: Scaffold(
        appBar: AppBar(
            title:
                Text(widget.mini ? l10n.posMiniTitle : l10n.posInvoiceTitle)),
        body: Column(
          children: [
            if (widget.mini)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                // A Wrap: the label and both chips drop to a second line on a narrow phone or with large text.
                child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(l10n.posPaperLabel,
                          style: Theme.of(context).textTheme.titleSmall),
                      ChoiceChip(
                          label: Text(l10n.posPaper58),
                          selected: _paper == 58,
                          onSelected: (_) => setState(() => _paper = 58)),
                      ChoiceChip(
                          label: Text(l10n.posPaper80),
                          selected: _paper == 80,
                          onSelected: (_) => setState(() => _paper = 80)),
                    ]),
              ),
            Expanded(
              child: pdf.when(
                loading: () => Center(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 12),
                  Text(l10n.posOrdLoadingHint)
                ])),
                error: (e, _) =>
                    ListView(padding: const EdgeInsets.all(16), children: [
                  PosErrorNote(
                      message:
                          '${l10n.posInvoiceFailed}\n${orderErrorText(e, l10n)}',
                      onRetry: () => ref.invalidate(posBillProvider(key)),
                      retryLabel: l10n.posRetry)
                ]),
                data: (file) => ref.watch(posPdfViewerProvider)(context, file),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The garments of an order and their tag codes, with "Print or share tags" (one QR label per garment).
class TagsPage extends ConsumerStatefulWidget {
  const TagsPage({required this.orderId, super.key});
  final String orderId;

  @override
  ConsumerState<TagsPage> createState() => _TagsPageState();
}

class _TagsPageState extends ConsumerState<TagsPage> {
  bool _busy = false;

  Future<void> _print(OrderDetailLite d) async {
    final l10n = AppLocalizations.of(context);
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final shop = ref.read(appModeProvider).info?.shopName ?? '';
      final bytes = await buildTagsPdf(
          orderNumber: d.orderNumber,
          shopName: shop,
          units: d.units,
          items: d.items);
      final pdf = PosPdf(bytes: bytes, fileName: 'Tags-${d.orderNumber}.pdf');
      // The print history is a record: if it cannot be written, the tags still print.
      String? jobId;
      try {
        jobId = await ref
            .read(posOrdersRepositoryProvider)
            .createTagPrintJob(widget.orderId, [for (final u in d.units) u.id]);
      } catch (_) {
        jobId = null;
      }
      if (!mounted) return;
      await Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => PosThemeScope(
          child: Consumer(
            builder: (context, ref, _) => Scaffold(
              appBar: AppBar(title: Text(l10n.posTagsPdfTitle(d.orderNumber))),
              body: ref.watch(posPdfViewerProvider)(context, pdf,
                  onDone: jobId == null
                      ? null
                      : () => ref
                          .read(posOrdersRepositoryProvider)
                          .markPrintJobPrinted(jobId!)
                          .catchError((_) {})),
            ),
          ),
        ),
      ));
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            behavior: SnackBarBehavior.fixed,
            content: Text(l10n.posTagsFailed)));
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final async = ref.watch(posOrderDetailProvider(widget.orderId));
    final detail = async.valueOrNull;
    return PosThemeScope(
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.posTagsTitle)),
        body: detail == null
            ? (async.hasError
                ? ListView(padding: const EdgeInsets.all(16), children: [
                    PosErrorNote(
                        message:
                            '${l10n.posOrdLoadFailed}\n${orderErrorText(async.error, l10n)}',
                        onRetry: () => ref
                            .invalidate(posOrderDetailProvider(widget.orderId)),
                        retryLabel: l10n.posRetry)
                  ])
                : const Center(child: CircularProgressIndicator()))
            : detail.units.isEmpty
                ? Center(
                    child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(l10n.posTagsEmpty,
                            textAlign: TextAlign.center,
                            style: text.bodyLarge)))
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Text(l10n.posTagsHint, style: text.bodyMedium),
                      const SizedBox(height: 12),
                      for (final u in detail.units)
                        Card(
                          child: ListTile(
                            leading:
                                const Icon(Icons.qr_code_2_rounded, size: 32),
                            title: Text('${u.garmentName}  #${u.sequence}'),
                            subtitle: Text(u.tagCode),
                            trailing: PosStatusChip(
                                label: unitStateLabel(l10n, u.state),
                                tone: unitTone(u.state)),
                          ),
                        ),
                    ],
                  ),
        bottomNavigationBar: detail == null || detail.units.isEmpty
            ? null
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: SizedBox(
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: _busy
                          ? null
                          : () => _print(OrderDetailLite(
                              detail.order.orderNumber,
                              detail.units,
                              detail.order.items)),
                      icon: _busy
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2.5))
                          : const Icon(Icons.print_rounded),
                      label: Text(l10n.posTagsPrint),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

/// Just what the tag labels need from an order.
class OrderDetailLite {
  const OrderDetailLite(this.orderNumber, this.units, this.items);
  final String orderNumber;
  final List<GarmentUnit> units;
  final List<CounterOrderItem> items;
}
