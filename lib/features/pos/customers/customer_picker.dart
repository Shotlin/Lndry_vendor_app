import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/friendly_error.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../models/pos/pos_customer_model.dart';
import '../core/pos_providers.dart';
import '../core/pos_widgets.dart';
import 'add_customer_sheet.dart';
import 'phone.dart';

/// Lets the owner find a customer by name or phone, or add a new one. Returns the chosen customer.
Future<PosCustomer?> showCustomerPicker(BuildContext context) {
  return showModalBottomSheet<PosCustomer>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => const PosThemeScope(child: CustomerPicker()),
  );
}

class CustomerPicker extends ConsumerStatefulWidget {
  const CustomerPicker({super.key, this.debounce = const Duration(milliseconds: 300)});
  final Duration debounce;

  @override
  ConsumerState<CustomerPicker> createState() => _CustomerPickerState();
}

class _CustomerPickerState extends ConsumerState<CustomerPicker> {
  final _controller = TextEditingController();
  Timer? _timer;
  String _query = '';

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _timer?.cancel();
    _timer = Timer(widget.debounce, () {
      if (mounted) setState(() => _query = value.trim());
    });
  }

  Future<void> _addNew({String? phone}) async {
    final created = await showAddCustomerSheet(context, initialPhone: phone);
    if (created != null && mounted) Navigator.of(context).pop(created);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final results = ref.watch(posCustomerSearchProvider(_query));
    final typedMobile = normalizeMobile(_query);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.85,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.posCustomerPick, style: text.titleLarge),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _controller,
                    autofocus: true,
                    onChanged: _onChanged,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(hintText: l10n.posCustomerSearchHint, prefixIcon: const Icon(Icons.search_rounded)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: results.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Padding(
                  padding: const EdgeInsets.all(20),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: PosErrorNote(message: friendlyError(e), onRetry: () => ref.invalidate(posCustomerSearchProvider(_query)), retryLabel: l10n.posRetry),
                  ),
                ),
                data: (customers) {
                  final exact = typedMobile != null && customers.any((c) => normalizeMobile(c.phone) == typedMobile);
                  return ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    children: [
                      if (_query.isEmpty && customers.isNotEmpty)
                        Padding(padding: const EdgeInsets.fromLTRB(8, 4, 8, 4), child: Text(l10n.posCustomerRecent, style: text.labelLarge?.copyWith(color: scheme.onSurfaceVariant))),
                      if (typedMobile != null && !exact)
                        ListTile(
                          minTileHeight: _tileHeight,
                          leading: CircleAvatar(backgroundColor: scheme.primaryContainer, child: Icon(Icons.person_add_alt_1_rounded, color: scheme.primary)),
                          title: Text(l10n.posCustomerAddWithPhone(typedMobile)),
                          onTap: () => _addNew(phone: typedMobile),
                        ),
                      if (customers.isEmpty && typedMobile == null)
                        Padding(padding: const EdgeInsets.all(24), child: Center(child: Text(l10n.posCustomerNone, style: text.bodyLarge))),
                      for (final c in customers)
                        ListTile(
                          minTileHeight: _tileHeight,
                          leading: CircleAvatar(
                            backgroundColor: scheme.primaryContainer,
                            child: Text(_initial(c), style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w700)),
                          ),
                          title: Text(c.displayName),
                          subtitle: Text([c.phone, if (c.orderCount != null) l10n.posCustomerOrderCount(c.orderCount!)].where((e) => e.isNotEmpty).join(' · ')),
                          onTap: () => Navigator.of(context).pop(c),
                        ),
                    ],
                  );
                },
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: FilledButton.tonalIcon(
                  onPressed: _addNew,
                  icon: const Icon(Icons.person_add_alt_1_rounded),
                  label: Text(l10n.posCustomerAddNew),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _initial(PosCustomer c) {
    final n = c.displayName.trim();
    return n.isEmpty ? '?' : n.characters.first.toUpperCase();
  }
}

const double _tileHeight = 56;
