import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/friendly_error.dart';
import '../../../core/router/app_routes.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../core/money.dart';
import '../core/pos_providers.dart';
import '../core/pos_widgets.dart';
import 'add_customer_sheet.dart';

/// Every customer the shop has dealt with: search by name or phone, tap for the profile and what they owe.
class PosCustomersPage extends ConsumerStatefulWidget {
  const PosCustomersPage({super.key, this.debounce = const Duration(milliseconds: 300)});
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
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.posCustomerAdded(c.displayName))));
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
              decoration: InputDecoration(hintText: l10n.posCustSearchHint, prefixIcon: const Icon(Icons.search_rounded)),
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
                error: (e, _) => ListView(padding: const EdgeInsets.all(16), children: [
                  PosErrorNote(
                    message: '${l10n.posCustLoadError}\n${friendlyError(e)}',
                    onRetry: () => ref.invalidate(posCustomerSearchProvider(_query)),
                    retryLabel: l10n.posRetry,
                  ),
                ]),
                data: (list) => list.isEmpty
                    ? ListView(padding: const EdgeInsets.all(32), children: [
                        Icon(Icons.people_outline_rounded, size: 56, color: scheme.onSurfaceVariant),
                        const SizedBox(height: 12),
                        Text(_query.isEmpty ? l10n.posCustEmpty : l10n.posCustNoMatch(_query), textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
                      ])
                    : ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 96),
                        itemCount: list.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, i) {
                          final c = list[i];
                          final name = c.displayName.trim();
                          return ListTile(
                            minTileHeight: 64,
                            leading: CircleAvatar(
                              backgroundColor: scheme.primaryContainer,
                              child: Text(name.isEmpty ? '?' : name.characters.first.toUpperCase(), style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w700)),
                            ),
                            title: Text(name),
                            subtitle: Text([c.phone, if (c.orderCount != null) l10n.posCustOrdersCount(c.orderCount!, formatPaise(c.spentPaise))].where((e) => e.isNotEmpty).join(' · ')),
                            trailing: const Icon(Icons.chevron_right_rounded),
                            onTap: () => context.push(AppRoutes.posCustomerPath(c.id)),
                          );
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
