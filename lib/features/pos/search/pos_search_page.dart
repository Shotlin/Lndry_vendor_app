import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/network/friendly_error.dart';
import '../../../core/router/app_routes.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../models/pos/pos_search_model.dart';
import '../core/money.dart';
import '../core/pos_theme.dart';
import '../core/pos_widgets.dart';
import 'pos_search_controller.dart';

/// Search tab: one box finds orders (by number), customers (by name or phone) and garments (by tag text).
class PosSearchPage extends ConsumerStatefulWidget {
  const PosSearchPage({super.key});

  @override
  ConsumerState<PosSearchPage> createState() => _PosSearchPageState();
}

class _PosSearchPageState extends ConsumerState<PosSearchPage> {
  final _box = TextEditingController();

  @override
  void dispose() {
    _box.dispose();
    super.dispose();
  }

  void _open(String path) {
    ref.read(posSearchControllerProvider.notifier).remember(_box.text);
    context.push(path);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(posSearchControllerProvider);
    final ctl = ref.read(posSearchControllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.posTabSearch)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _box,
              autofocus: false,
              textInputAction: TextInputAction.search,
              onChanged: ctl.onChanged,
              onSubmitted: ctl.submit,
              decoration: InputDecoration(
                hintText: l10n.posSearchHint,
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _box.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: l10n.posSearchClearRecent,
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () {
                          _box.clear();
                          ctl.onChanged('');
                          setState(() {});
                        },
                      ),
              ),
            ),
          ),
          Expanded(child: _Body(state: state, onOpen: _open, onPickRecent: (q) {
            _box.text = q;
            _box.selection = TextSelection.collapsed(offset: q.length);
            ctl.submit(q);
            setState(() {});
          })),
        ],
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.state, required this.onOpen, required this.onPickRecent});
  final SearchState state;
  final void Function(String path) onOpen;
  final void Function(String query) onPickRecent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    if (state.tooShort) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.posSearchStart, style: text.bodyMedium),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(PosTheme.minTouch)),
            onPressed: () => context.push(AppRoutes.posCustomers),
            icon: const Icon(Icons.people_alt_outlined),
            label: Text(l10n.posSearchAllCustomers),
          ),
          if (state.recent.isNotEmpty) ...[
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: Semantics(header: true, child: Text(l10n.posSearchRecent, style: text.titleMedium))),
                TextButton(onPressed: ref.read(posSearchControllerProvider.notifier).clearRecent, child: Text(l10n.posSearchClearRecent)),
              ],
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [for (final q in state.recent) ActionChip(avatar: const Icon(Icons.history_rounded, size: 18), label: Text(q), onPressed: () => onPickRecent(q))],
            ),
          ],
        ],
      );
    }
    if (state.error != null) {
      return ListView(padding: const EdgeInsets.all(16), children: [
        PosErrorNote(
          message: '${l10n.posSearchFailed}\n${friendlyError(state.error)}',
          onRetry: () => ref.read(posSearchControllerProvider.notifier).submit(state.query),
          retryLabel: l10n.posRetry,
        ),
      ]);
    }
    final r = state.results;
    if (r == null) return const Center(child: CircularProgressIndicator());
    if (r.isEmpty) {
      return ListView(padding: const EdgeInsets.all(24), children: [
        if (state.loading) const LinearProgressIndicator(),
        const SizedBox(height: 16),
        Icon(Icons.search_off_rounded, size: 48, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(height: 12),
        Text(l10n.posSearchNone(state.query), textAlign: TextAlign.center, style: text.bodyLarge),
      ]);
    }
    final df = DateFormat.yMMMd(Localizations.localeOf(context).toString());
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        if (state.loading) const LinearProgressIndicator(),
        if (r.orders.isNotEmpty) _Header(l10n.posSearchOrders),
        for (final o in r.orders)
          ListTile(
            minVerticalPadding: 8,
            leading: const Icon(Icons.receipt_long_outlined),
            title: Text(o.orderNumber.isEmpty ? '—' : o.orderNumber),
            subtitle: Text(l10n.posSearchOrderLine(formatPaise(o.totalPaise), o.placedAt == null ? '—' : df.format(o.placedAt!))),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => onOpen(AppRoutes.posOrderDetailPath(o.id)),
          ),
        if (r.customers.isNotEmpty) _Header(l10n.posSearchCustomers),
        for (final c in r.customers)
          ListTile(
            minVerticalPadding: 8,
            leading: const Icon(Icons.person_outline_rounded),
            title: Text(c.displayName),
            subtitle: Text(c.phone),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => onOpen(AppRoutes.posCustomerPath(c.id)),
          ),
        if (r.garments.isNotEmpty) _Header(l10n.posSearchTags),
        for (final g in r.garments) _TagTile(g: g, onOpen: onOpen),
      ],
    );
  }
}

class _TagTile extends StatelessWidget {
  const _TagTile({required this.g, required this.onOpen});
  final SearchGarment g;
  final void Function(String path) onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListTile(
      minVerticalPadding: 8,
      leading: const Icon(Icons.qr_code_2_rounded),
      title: Text(l10n.posSearchTagLine(g.tagCode, g.state.replaceAll('_', ' ').toLowerCase())),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: g.orderId.isEmpty ? null : () => onOpen(AppRoutes.posOrderDetailPath(g.orderId)),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.title);
  final String title;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Semantics(header: true, child: Text(title, style: Theme.of(context).textTheme.titleMedium)),
      );
}
