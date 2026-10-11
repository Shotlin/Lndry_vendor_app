import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/repositories/api_pos_repositories.dart';
import '../../../core/network/friendly_error.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../models/pos/pos_catalogue_model.dart';
import '../core/money.dart';
import '../core/pos_providers.dart';
import '../core/pos_widgets.dart';

/// Adds (or, when the garment + service already have a price, changes) a shop price.
/// Returns `true` when something was saved. Pass [garmentId] + [serviceId] to open on one price.
Future<bool?> showAddGarmentPriceSheet(BuildContext context, {String? garmentId, String? serviceId}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => PosThemeScope(child: AddGarmentPriceSheet(garmentId: garmentId, serviceId: serviceId)),
  );
}

String unitLabelOf(AppLocalizations l10n, String unit) {
  switch (unit) {
    case 'kg':
      return l10n.posUnitKg;
    case 'pair':
      return l10n.posUnitPair;
    case 'sqft':
      return l10n.posUnitSqft;
    default:
      return l10n.posUnitPiece;
  }
}

class AddGarmentPriceSheet extends ConsumerStatefulWidget {
  const AddGarmentPriceSheet({super.key, this.garmentId, this.serviceId});
  final String? garmentId;
  final String? serviceId;

  @override
  ConsumerState<AddGarmentPriceSheet> createState() => _AddGarmentPriceSheetState();
}

enum _Kind { garment, category, service }

class _AddGarmentPriceSheetState extends ConsumerState<AddGarmentPriceSheet> {
  final _rate = TextEditingController();
  String? _garmentId;
  String? _categoryId;
  String? _serviceId;
  String _unit = 'piece';
  bool _busy = false;
  String? _error;
  bool _rateTouched = false;
  bool _seeded = false;

  @override
  void initState() {
    super.initState();
    _garmentId = widget.garmentId;
    _serviceId = widget.serviceId;
  }

  @override
  void dispose() {
    _rate.dispose();
    super.dispose();
  }

  void _seed(PosCatalogue c) {
    if (_seeded) return;
    _seeded = true;
    final g = _garmentId == null ? null : c.garment(_garmentId!);
    if (g != null) {
      _categoryId = g.categoryId;
      _unit = g.unit;
    }
    _syncRate(c);
  }

  /// When an existing price is selected, show it in the box so it can be changed.
  void _syncRate(PosCatalogue c) {
    if (_rateTouched) return;
    final price = (_garmentId != null && _serviceId != null) ? c.priceOf(_garmentId!, _serviceId!) : null;
    _rate.text = price == null ? '' : paiseToInput(price.ratePaise);
  }

  Future<void> _create(_Kind kind, PosCatalogue c) async {
    final l10n = AppLocalizations.of(context);
    final title = switch (kind) { _Kind.garment => l10n.posPriceNewGarment, _Kind.category => l10n.posPriceNewCategory, _Kind.service => l10n.posPriceNewService };
    final name = await showDialog<String>(context: context, builder: (_) => _NameDialog(title: title));
    if (name == null || !mounted) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final repo = ref.read(posCatalogueRepositoryProvider);
      switch (kind) {
        case _Kind.garment:
          final g = await repo.createGarment(name: name, unit: _unit, categoryId: _categoryId);
          _garmentId = g.id;
        case _Kind.category:
          final cat = await repo.createCategory(name);
          _categoryId = cat.id;
        case _Kind.service:
          final s = await repo.createService(name);
          _serviceId = s.id;
      }
      ref.invalidate(posCatalogueProvider);
      final fresh = await ref.read(posCatalogueProvider.future);
      if (!mounted) return;
      setState(() => _busy = false);
      _syncRate(fresh);
    } catch (e) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = friendlyError(e);
        });
      }
    }
  }

  Future<void> _save(PosCatalogue c) async {
    final l10n = AppLocalizations.of(context);
    final paise = parseRupeesToPaise(_rate.text);
    String? problem;
    if (_garmentId == null) {
      problem = l10n.posPriceErrGarment;
    } else if (_serviceId == null) {
      problem = l10n.posPriceErrService;
    } else if (paise == null || paise <= 0) {
      problem = l10n.posPriceErrRate;
    }
    if (problem != null) {
      setState(() => _error = problem);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final repo = ref.read(posCatalogueRepositoryProvider);
      final existing = c.priceOf(_garmentId!, _serviceId!);
      if (existing == null) {
        await repo.createPrice(garmentId: _garmentId!, serviceId: _serviceId!, ratePaise: paise!);
      } else {
        await repo.updatePrice(priceId: existing.id, ratePaise: paise!);
      }
      ref.invalidate(posCatalogueProvider);
      if (mounted) Navigator.of(context).pop(true);
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
    final catalogue = ref.watch(posCatalogueProvider);
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 20 + MediaQuery.viewInsetsOf(context).bottom),
      child: catalogue.when(
        loading: () => const SizedBox(height: 220, child: Center(child: CircularProgressIndicator())),
        error: (e, _) => PosErrorNote(message: friendlyError(e), onRetry: () => ref.invalidate(posCatalogueProvider), retryLabel: l10n.posRetry),
        data: (c) {
          _seed(c);
          final garment = _garmentId == null ? null : c.garment(_garmentId!);
          final price = (_garmentId != null && _serviceId != null) ? c.priceOf(_garmentId!, _serviceId!) : null;
          final garments = [...c.garments.where((g) => g.active)]..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(price == null ? l10n.posAddPriceTitle : l10n.posEditPriceTitle, style: text.titleLarge),
                const SizedBox(height: 16),
                _PickerRow(
                  label: l10n.posPriceGarment,
                  value: garment?.id,
                  items: [for (final g in garments) DropdownMenuItem(value: g.id, child: Text(g.name, overflow: TextOverflow.ellipsis))],
                  onChanged: _busy
                      ? null
                      : (id) => setState(() {
                            _garmentId = id;
                            final g = id == null ? null : c.garment(id);
                            if (g != null) {
                              _categoryId = g.categoryId;
                              _unit = g.unit;
                            }
                            _rateTouched = false;
                            _syncRate(c);
                          }),
                  onCreate: _busy ? null : () => _create(_Kind.garment, c),
                ),
                const SizedBox(height: 12),
                _PickerRow(
                  label: l10n.posPriceCategory,
                  value: c.categories.any((e) => e.id == _categoryId) ? _categoryId : null,
                  items: [for (final e in c.activeCategories) DropdownMenuItem(value: e.id, child: Text(e.name, overflow: TextOverflow.ellipsis))],
                  // An existing garment keeps its category; only a garment about to be created can choose one.
                  onChanged: (_busy || garment != null) ? null : (id) => setState(() => _categoryId = id),
                  onCreate: _busy ? null : () => _create(_Kind.category, c),
                ),
                const SizedBox(height: 12),
                _PickerRow(
                  label: l10n.posPriceService,
                  value: c.services.any((e) => e.id == _serviceId) ? _serviceId : null,
                  items: [for (final e in c.activeServices) DropdownMenuItem(value: e.id, child: Text(e.name, overflow: TextOverflow.ellipsis))],
                  onChanged: _busy
                      ? null
                      : (id) => setState(() {
                            _serviceId = id;
                            _rateTouched = false;
                            _syncRate(c);
                          }),
                  onCreate: _busy ? null : () => _create(_Kind.service, c),
                ),
                const SizedBox(height: 12),
                _PickerRow(
                  label: l10n.posPriceUnit,
                  value: _unit,
                  items: [for (final u in kPosUnits) DropdownMenuItem(value: u, child: Text(unitLabelOf(l10n, u)))],
                  onChanged: (_busy || garment != null) ? null : (u) => setState(() => _unit = u ?? 'piece'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _rate,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,₹]')), LengthLimitingTextInputFormatter(12)],
                  onChanged: (_) => _rateTouched = true,
                  decoration: InputDecoration(labelText: l10n.posPriceRate, prefixIcon: const Icon(Icons.currency_rupee_rounded)),
                ),
                if (price != null) ...[
                  const SizedBox(height: 6),
                  Text(l10n.posPriceCurrent(formatPaise(price.ratePaise)), style: text.bodySmall),
                ],
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  PosErrorNote(message: _error!),
                ],
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: _busy ? null : () => _save(c),
                  icon: _busy ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5)) : const Icon(Icons.check_rounded),
                  label: Text(price == null ? l10n.posPriceAdd : l10n.posPriceSave),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// A labelled drop-down with an optional "+" to create a new entry on the spot.
class _PickerRow extends StatelessWidget {
  const _PickerRow({required this.label, required this.value, required this.items, required this.onChanged, this.onCreate});
  final String label;
  final String? value;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?>? onChanged;
  final VoidCallback? onCreate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            key: ValueKey('$label-$value-${items.length}'),
            initialValue: value,
            isExpanded: true,
            items: items,
            onChanged: onChanged,
            decoration: InputDecoration(labelText: label),
            hint: Text(l10n.posPricePickOne),
          ),
        ),
        if (onCreate != null) ...[
          const SizedBox(width: 8),
          IconButton.filledTonal(
            onPressed: onCreate,
            tooltip: '${l10n.posPriceCreateTooltip}: $label',
            icon: const Icon(Icons.add_rounded),
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          ),
        ],
      ],
    );
  }
}

class _NameDialog extends StatefulWidget {
  const _NameDialog({required this.title});
  final String title;

  @override
  State<_NameDialog> createState() => _NameDialogState();
}

class _NameDialogState extends State<_NameDialog> {
  final _c = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _ok() {
    final name = _c.text.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (name.length < 2) {
      setState(() => _error = AppLocalizations.of(context).posPriceErrName);
      return;
    }
    Navigator.of(context).pop(name);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _c,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(labelText: l10n.posPriceCreateHint, errorText: _error),
        onSubmitted: (_) => _ok(),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.posCancel)),
        FilledButton(onPressed: _ok, child: Text(l10n.posPriceCreate)),
      ],
    );
  }
}
