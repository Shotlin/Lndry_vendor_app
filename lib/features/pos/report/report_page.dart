import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../api/repositories/api_pos_repositories.dart';
import '../../../core/network/friendly_error.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../models/pos/pos_money_model.dart';
import '../core/money.dart';
import '../core/pos_money_providers.dart';
import '../core/pos_widgets.dart';
import '../expense/expense_labels.dart';
import '../orders/order_labels.dart';
import 'invoice_tab.dart';
import 'line_chart.dart';
import 'report_providers.dart';

/// Report tab: what was billed, collected, still owed and spent — for today, 7 days, this month or any dates.
/// Every number is the server's. The screen only lays them out; a missing number shows "—", never 0.
class PosReportPage extends ConsumerStatefulWidget {
  const PosReportPage({super.key, this.now});

  /// Override the clock in tests.
  final DateTime? now;

  @override
  ConsumerState<PosReportPage> createState() => _PosReportPageState();
}

class _PosReportPageState extends ConsumerState<PosReportPage> {
  ReportPreset _preset = ReportPreset.today;
  ReportRange? _custom;
  bool _exporting = false;

  DateTime get _now => widget.now ?? DateTime.now();
  ReportRange get _range => _preset == ReportPreset.custom && _custom != null ? _custom! : reportRangeFor(_preset, _now);

  Future<void> _pickCustom() async {
    final l10n = AppLocalizations.of(context);
    final now = _now;
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 3),
      lastDate: now,
      initialDateRange: DateTimeRange(start: DateTime.tryParse(_range.from) ?? now, end: DateTime.tryParse(_range.to) ?? now),
    );
    if (picked == null || !mounted) return;
    if (picked.end.difference(picked.start).inDays + 1 > kMaxReportDays) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.posRepRangeTooLong)));
      return;
    }
    setState(() {
      _custom = (from: isoDay(picked.start), to: isoDay(picked.end));
      _preset = ReportPreset.custom;
    });
  }

  Future<void> _export() async {
    if (_exporting) return;
    final l10n = AppLocalizations.of(context);
    final range = _range;
    setState(() => _exporting = true);
    try {
      final csv = await ref.read(posReportRepositoryProvider).exportCsv(from: range.from, to: range.to);
      await ref.read(posCsvSharerProvider)(csvFileName(range), csv);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${l10n.posRepExportFailed} ${friendlyError(e)}')));
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (!ref.watch(posCanSeeReportProvider)) {
      return Scaffold(appBar: AppBar(title: Text(l10n.posRepTitle)), body: Padding(padding: const EdgeInsets.all(24), child: PosNote(icon: Icons.lock_outline_rounded, text: l10n.posMoneyNoAccess)));
    }
    final range = _range;
    final async = ref.watch(posReportProvider(range));
    final df = DateFormat.yMMMd(Localizations.localeOf(context).toString());
    final from = DateTime.tryParse(range.from);
    final to = DateTime.tryParse(range.to);
    final chips = Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Wrap(spacing: 8, runSpacing: 4, children: [
          for (final (p, label) in [(ReportPreset.today, l10n.posRepToday), (ReportPreset.week, l10n.posRep7Days), (ReportPreset.month, l10n.posRepMonth)])
            ChoiceChip(label: Text(label), selected: _preset == p, onSelected: (_) => setState(() => _preset = p)),
          ChoiceChip(avatar: const Icon(Icons.date_range_rounded, size: 18), label: Text(l10n.posRepCustom), selected: _preset == ReportPreset.custom, onSelected: (_) => _pickCustom()),
        ]),
        if (from != null && to != null && range.from != range.to)
          Padding(padding: const EdgeInsets.only(top: 8), child: Text(l10n.posRepPeriod(df.format(from), df.format(to)), style: Theme.of(context).textTheme.bodySmall)),
      ]),
    );
    Widget tab(Widget Function(PosReport r) build) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(posReportProvider(range));
            try {
              await ref.read(posReportProvider(range).future);
            } catch (_) {
              // Shown below.
            }
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            children: [
              async.when(
                loading: () => const Padding(padding: EdgeInsets.all(32), child: Center(child: CircularProgressIndicator())),
                error: (e, _) => PosErrorNote(message: '${l10n.posRepLoadError}\n${friendlyError(e)}', onRetry: () => ref.invalidate(posReportProvider(range)), retryLabel: l10n.posRetry),
                data: build,
              ),
            ],
          ),
        );
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.posRepTitle),
          bottom: TabBar(isScrollable: true, tabAlignment: TabAlignment.start, tabs: [Tab(text: l10n.posRepTabSummary), Tab(text: l10n.posRepTabInvoices), Tab(text: l10n.posRepTabCollection), Tab(text: l10n.posRepTabExpense)]),
        ),
        body: Column(children: [
          chips,
          Expanded(
            child: TabBarView(children: [
              tab((r) => _ReportBody(report: r, exporting: _exporting, onExport: _export)),
              InvoiceTab(range: range, report: async),
              tab((r) => _CollectionTab(report: r)),
              tab((r) => _ExpenseTab(report: r)),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _ReportBody extends StatelessWidget {
  const _ReportBody({required this.report, required this.exporting, required this.onExport});
  final PosReport report;
  final bool exporting;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final r = report;
    final text = Theme.of(context).textTheme;
    final nothing = (r.orderCount ?? 0) == 0 && (r.expenseCount ?? 0) == 0 && (r.collectionPaise ?? 0) == 0;
    final mix = r.paymentMix;
    final mixRows = <(String, int?)>[
      (l10n.posExpModeCash, mix.cashPaise),
      (l10n.posExpModeUpi, mix.upiPaise),
      (l10n.posExpModeCard, mix.cardPaise),
      (l10n.posExpModeBank, mix.bankPaise),
      (l10n.posRepModeWallet, mix.walletPaise),
    ].where((e) => (e.$2 ?? 0) > 0).toList();
    final mixTotal = mixRows.fold<int>(0, (s, e) => s + (e.$2 ?? 0));
    final st = r.ordersByStatus;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (nothing) Padding(padding: const EdgeInsets.only(bottom: 12), child: PosNote(icon: Icons.info_outline_rounded, text: l10n.posRepEmpty)),
        _TileRow(
          left: _Kpi(label: l10n.posRepBilled, value: formatPaise(r.revenuePaise), hint: r.orderCount == null ? l10n.posRepBilledHint : l10n.posRepOrdersCount(r.orderCount!)),
          right: _Kpi(label: l10n.posRepCollected, value: formatPaise(r.collectionPaise), hint: l10n.posRepCollectedHint, tone: PosTone.success),
        ),
        const SizedBox(height: 12),
        _TileRow(
          left: _Kpi(label: l10n.posRepDues, value: formatPaise(r.duesPaise), hint: r.duesOrderCount == null ? null : l10n.posRepDuesHint(r.duesOrderCount!), tone: (r.duesPaise ?? 0) > 0 ? PosTone.attention : PosTone.neutral),
          right: _Kpi(label: l10n.posRepSpent, value: formatPaise(r.expensesPaise), hint: r.expenseCount == null ? null : l10n.posRepSpentHint(r.expenseCount!)),
        ),
        const SizedBox(height: 12),
        _Kpi(label: l10n.posRepNet, value: formatPaise(r.netPaise), tone: (r.netPaise ?? 0) < 0 ? PosTone.danger : PosTone.neutral, wide: true),
        _Section(l10n.posRepOrders),
        Wrap(spacing: 8, runSpacing: 8, children: [
          _CountChip(l10n.posRepStBooked, st.booked),
          _CountChip(l10n.posRepStProcess, st.inProcess),
          _CountChip(l10n.posRepStReady, st.ready),
          _CountChip(l10n.posRepStDelivered, st.delivered),
          _CountChip(l10n.posRepStCancelled, st.cancelled),
        ]),
        _Section(l10n.posRepPayMix),
        if (mixRows.isEmpty)
          Text(l10n.posRepNoPayments, style: text.bodyMedium)
        else
          for (final e in mixRows) _Bar(label: e.$1, amountText: formatPaise(e.$2), fraction: mixTotal == 0 ? 0 : (e.$2 ?? 0) / mixTotal),
        if (r.topGarments.isNotEmpty) ...[
          _Section(l10n.posRepTopGarments),
          for (final (i, g) in r.topGarments.indexed)
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: CircleAvatar(radius: 14, backgroundColor: Theme.of(context).colorScheme.primaryContainer, child: Text('${i + 1}', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700))),
              title: Text(g.name),
              trailing: Text(l10n.posRepQty(_qty(g.qty), formatPaise(g.revenuePaise))),
            ),
        ],
        if (r.expenseByCategory.isNotEmpty) ...[
          _Section(l10n.posRepSpendBy),
          for (final c in r.expenseByCategory)
            _Bar(label: expenseCategoryLabel(l10n, c.category), amountText: formatPaise(c.totalPaise), fraction: (r.expensesPaise ?? 0) == 0 ? 0 : c.totalPaise / r.expensesPaise!),
        ],
        if (r.daily.length > 1) ...[
          _Section(l10n.posRepDaily),
          for (final d in r.daily.reversed)
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text(dateText(context, d.date)),
              subtitle: Text(l10n.posRepDayLine(formatPaise(d.revenuePaise), formatPaise(d.collectionPaise), formatPaise(d.expensesPaise))),
            ),
        ],
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: exporting ? null : onExport,
          icon: exporting ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.ios_share_rounded),
          label: Text(l10n.posRepExport),
        ),
        const SizedBox(height: 6),
        Text(l10n.posRepExportHint, style: text.bodySmall, textAlign: TextAlign.center),
      ],
    );
  }

  /// 4 → "4", 2.5 → "2.5" (kilograms).
  static String _qty(double q) => q == q.roundToDouble() ? q.toInt().toString() : q.toStringAsFixed(1);
}

class _Section extends StatelessWidget {
  const _Section(this.title);
  final String title;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 8),
        child: Semantics(header: true, child: Text(title, style: Theme.of(context).textTheme.titleMedium)),
      );
}

class _TileRow extends StatelessWidget {
  const _TileRow({required this.left, required this.right});
  final Widget left;
  final Widget right;
  @override
  Widget build(BuildContext context) => IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Expanded(child: left), const SizedBox(width: 12), Expanded(child: right)]),
      );
}

class _Kpi extends StatelessWidget {
  const _Kpi({required this.label, required this.value, this.hint, this.tone = PosTone.neutral, this.wide = false});
  final String label;
  final String value;
  final String? hint;
  final PosTone tone;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final c = posToneColors(context, tone);
    final neutral = tone == PosTone.neutral;
    return Semantics(
      container: true,
      label: '$label: $value${hint == null ? '' : '. $hint'}',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: neutral ? Theme.of(context).colorScheme.surface : c.bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: neutral ? Theme.of(context).colorScheme.outline : c.fg.withValues(alpha: 0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: text.labelLarge),
            const SizedBox(height: 4),
            FittedBox(fit: BoxFit.scaleDown, alignment: AlignmentDirectional.centerStart, child: Text(value, style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: neutral ? null : c.fg))),
            if (hint != null) ...[const SizedBox(height: 2), Text(hint!, style: text.bodySmall)],
          ],
        ),
      ),
    );
  }
}

class _CountChip extends StatelessWidget {
  const _CountChip(this.label, this.count);
  final String label;
  final int? count;
  @override
  Widget build(BuildContext context) => Chip(label: Text('$label: ${count ?? '—'}'));
}

class _Bar extends StatelessWidget {
  const _Bar({required this.label, required this.amountText, required this.fraction});
  final String label;
  final String amountText;
  final double fraction;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Semantics(
        label: '$label: $amountText',
        excludeSemantics: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(children: [Expanded(child: Text(label)), Text(amountText, style: const TextStyle(fontWeight: FontWeight.w700))]),
            const SizedBox(height: 4),
            ClipRRect(borderRadius: BorderRadius.circular(6), child: LinearProgressIndicator(value: fraction.clamp(0.0, 1.0), minHeight: 10, backgroundColor: scheme.surfaceContainerHighest, color: scheme.primary)),
          ],
        ),
      ),
    );
  }
}

List<ChartPoint> _points(BuildContext context, List<ReportDay> days, int Function(ReportDay) pick) => [
      for (final d in days) ChartPoint(_short(d.date), pick(d)),
    ];

/// `2026-10-11` → `11/10`.
String _short(String ymd) => ymd.length >= 10 ? '${ymd.substring(8, 10)}/${ymd.substring(5, 7)}' : ymd;

class _CollectionTab extends StatelessWidget {
  const _CollectionTab({required this.report});
  final PosReport report;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final mix = report.paymentMix;
    final rows = <(String, int?)>[
      (l10n.posExpModeCash, mix.cashPaise),
      (l10n.posExpModeUpi, mix.upiPaise),
      (l10n.posExpModeCard, mix.cardPaise),
      (l10n.posExpModeBank, mix.bankPaise),
      (l10n.posRepModeWallet, mix.walletPaise),
    ].where((e) => (e.$2 ?? 0) > 0).toList();
    final total = rows.fold<int>(0, (s, e) => s + (e.$2 ?? 0));
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      _Kpi(label: l10n.posRepCollected, value: formatPaise(report.collectionPaise), hint: l10n.posRepCollectedHint, tone: PosTone.success, wide: true),
      _Section(l10n.posRepPayMix),
      if (rows.isEmpty) Text(l10n.posRepNoPayments) else for (final e in rows) _Bar(label: e.$1, amountText: formatPaise(e.$2), fraction: total == 0 ? 0 : (e.$2 ?? 0) / total),
      _Section(l10n.posRepChartCollected),
      MoneyLineChart(title: l10n.posRepChartCollected, points: _points(context, report.daily, (d) => d.collectionPaise)),
    ]);
  }
}

class _ExpenseTab extends StatelessWidget {
  const _ExpenseTab({required this.report});
  final PosReport report;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spent = report.expensesPaise ?? 0;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      _Kpi(label: l10n.posRepSpent, value: formatPaise(report.expensesPaise), hint: report.expenseCount == null ? null : l10n.posRepSpentHint(report.expenseCount!), wide: true),
      _Section(l10n.posRepSpendBy),
      if (report.expenseByCategory.isEmpty) Text(l10n.posRepEmpty) else for (final c in report.expenseByCategory) _Bar(label: expenseCategoryLabel(l10n, c.category), amountText: formatPaise(c.totalPaise), fraction: spent == 0 ? 0 : c.totalPaise / spent),
      _Section(l10n.posRepChartSpent),
      MoneyLineChart(title: l10n.posRepChartSpent, points: _points(context, report.daily, (d) => d.expensesPaise)),
    ]);
  }
}
