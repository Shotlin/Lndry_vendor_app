import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/friendly_error.dart';
import '../../../core/router/app_routes.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../models/pos/pos_customer_model.dart';
import '../core/money.dart';
import '../core/pos_providers.dart';
import '../core/pos_widgets.dart';
import '../orders/orders_providers.dart';
import 'add_customer_sheet.dart';

/// Every customer the shop has dealt with: search by name or phone, tap for the profile and what they owe.
class PosCustomersPage extends ConsumerStatefulWidget {
  const PosCustomersPage(
      {super.key, this.debounce = const Duration(milliseconds: 300)});
  final Duration debounce;

  @override
  ConsumerState<PosCustomersPage> createState() => _PosCustomersPageState();
}

class _PosCustomersPageState extends ConsumerState<PosCustomersPage> {
  final _box = TextEditingController();
  Timer? _timer;
  String _query = '';

  @override
  void dispose() {
    _timer?.cancel();
    _box.dispose();
    super.dispose();
  }

  void _onChanged(String v) {
    _timer?.cancel();
    _timer = Timer(widget.debounce, () {
      if (mounted) setState(() => _query = v.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final async = ref.watch(posCustomerSearchProvider(_query));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.posCustTitle)),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: Text(l10n.posCustNewCustomer),
        onPressed: () async {
          final c = await showAddCustomerSheet(context);
          if (c != null && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.posCustomerAdded(c.displayName))));
            ref.invalidate(posCustomerSearchProvider);
            context.push(AppRoutes.posCustomerPath(c.id));
          }
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _box,
              onChanged: _onChanged,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                  hintText: l10n.posCustSearchHint,
                  prefixIcon: const Icon(Icons.search_rounded)),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(posCustomerSearchProvider(_query));
                try {
                  await ref.read(posCustomerSearchProvider(_query).future);
                } catch (_) {
                  // The error card shows it.
                }
              },
              child: async.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) =>
                    ListView(padding: const EdgeInsets.all(16), children: [
                  PosErrorNote(
                    message: '${l10n.posCustLoadError}\n${friendlyError(e)}',
                    onRetry: () =>
                        ref.invalidate(posCustomerSearchProvider(_query)),
                    retryLabel: l10n.posRetry,
                  ),
                ]),
                data: (list) => list.isEmpty
                    ? ListView(padding: const EdgeInsets.all(32), children: [
                        Icon(Icons.people_outline_rounded,
                            size: 56, color: scheme.onSurfaceVariant),
                        const SizedBox(height: 12),
                        Text(
                            _query.isEmpty
                                ? l10n.posCustEmpty
                                : l10n.posCustNoMatch(_query),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge),
                      ])
                    : _AlphaList(customers: list, showIndex: _query.isEmpty),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// "A" for Asha, "#" for anything that does not start with a letter.
String letterOf(String name) {
  final t = name.trim();
  if (t.isEmpty) return '#';
  final c = t.characters.first.toUpperCase();
  return RegExp(r'[A-Z]').hasMatch(c) ? c : '#';
}

sealed class _Row {}

class _Head extends _Row {
  _Head(this.letter);
  final String letter;
}

class _Cust extends _Row {
  _Cust(this.customer);
  final PosCustomer customer;
}

/// Customers A to Z with a letter strip on the right (letters nobody starts with are greyed). Each row has a labelled
/// Call and Profile button; tapping the name opens the profile too.
class _AlphaList extends StatefulWidget {
  const _AlphaList({required this.customers, required this.showIndex});
  final List<PosCustomer> customers;
  final bool showIndex;

  @override
  State<_AlphaList> createState() => _AlphaListState();
}

class _AlphaListState extends State<_AlphaList> {
  final _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  List<_Row> _rows() {
    final sorted = [...widget.customers]..sort((a, b) =>
        a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()));
    final rows = <_Row>[];
    String? last;
    for (final c in sorted) {
      final l = letterOf(c.displayName);
      if (l != last) {
        rows.add(_Head(l));
        last = l;
      }
      rows.add(_Cust(c));
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final scale = MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 2.0);
    final headH = 36.0 * scale;
    final rowH = 76.0 * scale;
    final rows = _rows();
    final present = {for (final r in rows.whereType<_Head>()) r.letter};
    double offsetOf(String letter) {
      var y = 0.0;
      for (final r in rows) {
        if (r is _Head && r.letter == letter) return y;
        y += r is _Head ? headH : rowH;
      }
      return 0;
    }

    return Row(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scroll,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 96),
            itemCount: rows.length,
            itemExtentBuilder: (i, _) => rows[i] is _Head ? headH : rowH,
            itemBuilder: (context, i) {
              final r = rows[i];
              if (r is _Head) {
                return Container(
                  alignment: AlignmentDirectional.centerStart,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  color: scheme.primaryContainer,
                  child: Semantics(
                      header: true,
                      child: Text(r.letter,
                          style: text.titleMedium?.copyWith(
                              color: scheme.primary,
                              fontWeight: FontWeight.w800))),
                );
              }
              final c = (r as _Cust).customer;
              return _CustomerRow(customer: c);
            },
          ),
        ),
        if (widget.showIndex)
          SizedBox(
            width: 28,
            child: LayoutBuilder(builder: (context, box) {
              const letters = [
                'A',
                'B',
                'C',
                'D',
                'E',
                'F',
                'G',
                'H',
                'I',
                'J',
                'K',
                'L',
                'M',
                'N',
                'O',
                'P',
                'Q',
                'R',
                'S',
                'T',
                'U',
                'V',
                'W',
                'X',
                'Y',
                'Z',
                '#'
              ];
              final h = (box.maxHeight / letters.length).clamp(14.0, 34.0);
              return SingleChildScrollView(
                child: Column(children: [
                  for (final l in letters)
                    Semantics(
                      button: true,
                      enabled: present.contains(l),
                      label: l,
                      excludeSemantics: true,
                      child: InkWell(
                        onTap: present.contains(l)
                            ? () => _scroll.animateTo(
                                offsetOf(l).clamp(
                                    0.0, _scroll.position.maxScrollExtent),
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeOut)
                            : null,
                        child: SizedBox(
                            height: h,
                            width: 28,
                            child: Center(
                                child: Text(l,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        color: present.contains(l)
                                            ? scheme.primary
                                            : scheme.outline)))),
                      ),
                    ),
                ]),
              );
            }),
          ),
      ],
    );
  }
}

class _CustomerRow extends ConsumerWidget {
  const _CustomerRow({required this.customer});
  final PosCustomer customer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final c = customer;
    Widget action(IconData icon, String label, VoidCallback? onTap) =>
        Semantics(
          button: true,
          label: label,
          excludeSemantics: true,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 52, minHeight: 52),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon,
                        color: onTap == null ? scheme.outline : scheme.primary),
                    Text(label,
                        style: text.labelSmall?.copyWith(color: scheme.primary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ]),
            ),
          ),
        );
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: scheme.outline))),
      padding: const EdgeInsetsDirectional.only(start: 12, end: 4),
      child: Row(children: [
        Expanded(
          child: Semantics(
            button: true,
            label: [c.displayName.trim(), c.phone]
                .where((e) => e.isNotEmpty)
                .join(', '),
            excludeSemantics: true,
            child: InkWell(
              onTap: () => context.push(AppRoutes.posCustomerPath(c.id)),
              child: Row(children: [
                CircleAvatar(
                  backgroundColor: scheme.primaryContainer,
                  child: Icon(Icons.person_rounded, color: scheme.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(c.displayName.trim(),
                            style: text.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        Text(
                            [
                              c.phone,
                              if (c.orderCount != null)
                                l10n.posCustOrdersCount(
                                    c.orderCount!, formatPaise(c.spentPaise))
                            ].where((e) => e.isNotEmpty).join(' · '),
                            style: text.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ]),
                ),
              ]),
            ),
          ),
        ),
        action(
            Icons.call_rounded,
            l10n.posCustCall,
            c.phone.isEmpty
                ? null
                : () async {
                    final ok = await ref.read(posUrlOpenerProvider)(
                        Uri(scheme: 'tel', path: c.phone));
                    if (!ok && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.posOrdCallFailed)));
                    }
                  }),
        action(Icons.person_rounded, l10n.posCustProfile,
            () => context.push(AppRoutes.posCustomerPath(c.id))),
      ]),
    );
  }
}
