import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/repositories/api_pos_repositories.dart';
import '../../../core/network/friendly_error.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../models/pos/pos_customer_model.dart';
import '../core/pos_widgets.dart';
import 'phone.dart';

/// Asks for a name and a mobile number and returns the customer the server found or created
/// (`null` if the sheet was dismissed). [initialPhone] pre-fills the number the owner already typed.
Future<PosCustomer?> showAddCustomerSheet(BuildContext context, {String? initialPhone}) {
  return showModalBottomSheet<PosCustomer>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => PosThemeScope(child: AddCustomerSheet(initialPhone: initialPhone)),
  );
}

class AddCustomerSheet extends ConsumerStatefulWidget {
  const AddCustomerSheet({super.key, this.initialPhone});
  final String? initialPhone;

  @override
  ConsumerState<AddCustomerSheet> createState() => _AddCustomerSheetState();
}

class _AddCustomerSheetState extends ConsumerState<AddCustomerSheet> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _name = TextEditingController();
  late final TextEditingController _phone = TextEditingController(text: normalizeMobile(widget.initialPhone) ?? '');
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_busy || !(_form.currentState?.validate() ?? false)) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final customer = await ref.read(posCounterRepositoryProvider).createCustomer(name: _name.text.trim().replaceAll(RegExp(r'\s+'), ' '), phone: normalizeMobile(_phone.text)!);
      if (mounted) Navigator.of(context).pop(customer);
    } catch (e) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = friendlyError(e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 20 + MediaQuery.viewInsetsOf(context).bottom),
      child: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.posAddCustomerTitle, style: text.titleLarge),
              const SizedBox(height: 16),
              TextFormField(
                controller: _name,
                autofocus: widget.initialPhone == null,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: l10n.posCustomerName, prefixIcon: const Icon(Icons.person_outline_rounded)),
                validator: (v) => (v ?? '').trim().length < 2 ? l10n.posErrCustomerName : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _phone,
                autofocus: widget.initialPhone != null,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+\- ]')), LengthLimitingTextInputFormatter(16)],
                decoration: InputDecoration(labelText: l10n.posCustomerPhone, prefixIcon: const Icon(Icons.phone_outlined)),
                validator: (v) => normalizeMobile(v) == null ? l10n.posErrCustomerPhone : null,
                onFieldSubmitted: (_) => _submit(),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                PosErrorNote(message: _error!),
              ],
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _busy ? null : _submit,
                icon: _busy ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5)) : const Icon(Icons.person_add_alt_1_rounded),
                label: Text(l10n.posActionAddCustomer),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
