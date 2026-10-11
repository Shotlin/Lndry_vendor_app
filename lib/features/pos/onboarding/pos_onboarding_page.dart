import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../api/repositories/api_app_mode_repository.dart';
import '../../../core/network/friendly_error.dart';
import '../../../core/router/app_routes.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../models/pos/app_mode_model.dart';
import '../../../providers/app_mode_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../repositories/abstract/app_mode_repository.dart';
import '../core/pos_widgets.dart';
import 'pos_onboarding_validators.dart';

/// The 4-step POS setup: shop details → tax & payments → counter setup → price list.
/// Each step is saved on the server as soon as the owner taps Next, so closing the app never loses
/// work, and re-opening resumes at the first unfinished step.
class PosOnboardingPage extends ConsumerStatefulWidget {
  const PosOnboardingPage({super.key});

  @override
  ConsumerState<PosOnboardingPage> createState() => _PosOnboardingPageState();
}

enum _Phase { loading, loadFailed, form, done }

class _PosOnboardingPageState extends ConsumerState<PosOnboardingPage> {
  final _formKey = GlobalKey<FormState>();

  // step 0 — shop
  final _name = TextEditingController();
  final _owner = TextEditingController();
  final _address = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _pincode = TextEditingController();
  // step 1 — tax
  bool _gst = false;
  final _gstin = TextEditingController();
  final _upi = TextEditingController();
  final _invoicePrefix = TextEditingController(text: 'INV');
  // step 2 — counter
  String _printer = 'none';
  final _orderPrefix = TextEditingController(text: 'LN');
  final _days = TextEditingController(text: '3');
  // step 3 — price list
  bool _starter = true;

  _Phase _phase = _Phase.loading;
  int _step = 0;
  bool _saving = false;
  String? _error;
  Map<String, int>? _starterCounts;

  AppModeRepository get _repo => ref.read(appModeRepositoryProvider);

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    for (final c in [_name, _owner, _address, _city, _state, _pincode, _gstin, _upi, _invoicePrefix, _orderPrefix, _days]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _phase = _Phase.loading;
      _error = null;
    });
    try {
      final saved = await _repo.getPosOnboarding();
      if (!mounted) return;
      _prefill(saved);
      setState(() {
        _step = saved.status == PosOnboardingStatus.completed ? 0 : posResumeStepIndex(saved.nextStep);
        _phase = _Phase.form;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = friendlyError(e);
        _phase = _Phase.loadFailed;
      });
    }
  }

  void _prefill(PosOnboardingState s) {
    final shop = s.step('shop');
    final tax = s.step('tax');
    final counter = s.step('counter');
    final price = s.step('pricelist');
    void set(TextEditingController c, Object? v) {
      if (v is String && v.isNotEmpty) c.text = v;
    }

    final info = ref.read(appModeProvider).info;
    set(_name, shop['name'] ?? ((info?.shopName ?? '') == 'My Shop' ? null : info?.shopName));
    set(_owner, shop['ownerName']);
    set(_address, shop['addressLine1']);
    set(_city, shop['city']);
    set(_state, shop['state']);
    set(_pincode, shop['pincode']);
    if (tax['gstEnabled'] is bool) _gst = tax['gstEnabled'] as bool;
    set(_gstin, tax['gstin']);
    set(_upi, tax['upiId']);
    set(_invoicePrefix, tax['invoicePrefix']);
    final printer = counter['printerProfile'];
    if (printer is String && kPosPrinterProfiles.contains(printer)) _printer = printer;
    set(_orderPrefix, counter['orderSeriesPrefix']);
    if (counter['defaultDeliveryDays'] != null) _days.text = '${counter['defaultDeliveryDays']}';
    if (price['choice'] is String) _starter = price['choice'] == 'starter';
  }

  Map<String, dynamic> _payloadFor(int step) => switch (step) {
        0 => PosOnboardingPayloads.shop(
            name: _name.text,
            ownerName: _owner.text,
            addressLine1: _address.text,
            city: _city.text,
            state: _state.text,
            pincode: _pincode.text,
          ),
        1 => PosOnboardingPayloads.tax(gstEnabled: _gst, gstin: _gstin.text, upiId: _upi.text, invoicePrefix: _invoicePrefix.text),
        2 => PosOnboardingPayloads.counter(printerProfile: _printer, orderSeriesPrefix: _orderPrefix.text, deliveryDays: _days.text),
        _ => PosOnboardingPayloads.pricelist(starter: _starter),
      };

  Future<void> _next() async {
    if (_saving) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final last = _step == kPosOnboardingSteps.length - 1;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await _repo.savePosOnboardingStep(kPosOnboardingSteps[_step], _payloadFor(_step));
      if (!mounted) return;
      if (!last) {
        setState(() {
          _step += 1;
          _saving = false;
        });
        return;
      }
      final result = await _repo.completePosOnboarding();
      if (!mounted) return;
      ref.read(appModeProvider.notifier).adoptCompleted(result.info);
      setState(() {
        _starterCounts = result.starterCounts;
        _phase = _Phase.done;
        _saving = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = friendlyError(e);
        _saving = false;
      });
    }
  }

  void _back() {
    if (_saving || _step == 0) return;
    setState(() {
      _step -= 1;
      _error = null;
    });
  }

  String? _fieldError(AppLocalizations l10n, PosFieldError? e) => switch (e) {
        null => null,
        PosFieldError.shopName => l10n.posErrShopName,
        PosFieldError.ownerName => l10n.posErrOwnerName,
        PosFieldError.address => l10n.posErrAddress,
        PosFieldError.city => l10n.posErrCity,
        PosFieldError.pincode => l10n.posErrPincode,
        PosFieldError.gstin => l10n.posErrGstin,
        PosFieldError.upi => l10n.posErrUpi,
        PosFieldError.prefix => l10n.posErrPrefix,
        PosFieldError.days => l10n.posErrDays,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final mode = ref.watch(appModeProvider);

    // Only the owner can set POS up; staff see a plain explanation.
    if (mode.info != null && mode.info!.hasVendor && !mode.info!.isOwner) {
      return PosThemeScope(child: _OwnerOnly(l10n: l10n));
    }

    return PosThemeScope(
      child: Builder(builder: (context) {
        final scheme = Theme.of(context).colorScheme;
        return PopScope(
          canPop: _phase != _Phase.form || _step == 0,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _back();
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(l10n.posOnbTitle),
              leading: _phase == _Phase.form && _step > 0
                  ? IconButton(icon: const Icon(Icons.arrow_back_rounded), tooltip: l10n.posBack, onPressed: _back)
                  : null,
              automaticallyImplyLeading: false,
              actions: [
                if (_phase != _Phase.done)
                  TextButton(
                    onPressed: _logout,
                    child: Text(l10n.posLogOut, style: TextStyle(color: scheme.onSurfaceVariant)),
                  ),
              ],
            ),
            body: SafeArea(child: _body(context, l10n)),
          ),
        );
      }),
    );
  }

  Future<void> _logout() => ref.read(authProvider.notifier).logout();

  Widget _body(BuildContext context, AppLocalizations l10n) {
    switch (_phase) {
      case _Phase.loading:
        return const Center(child: CircularProgressIndicator());
      case _Phase.loadFailed:
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Center(child: PosErrorNote(message: _error ?? '', onRetry: _load, retryLabel: l10n.commonRetry)),
        );
      case _Phase.done:
        return _Done(l10n: l10n, starterCount: _starterCounts?['garments'], onOpen: () => context.go(AppRoutes.posHome));
      case _Phase.form:
        break;
    }

    final text = Theme.of(context).textTheme;
    final titles = [l10n.posOnbStepShop, l10n.posOnbStepTax, l10n.posOnbStepCounter, l10n.posOnbStepPrices];
    final last = _step == kPosOnboardingSteps.length - 1;
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    label: l10n.posOnbStepOf(_step + 1, kPosOnboardingSteps.length),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(value: (_step + 1) / kPosOnboardingSteps.length, minHeight: 8),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(l10n.posOnbStepOf(_step + 1, kPosOnboardingSteps.length), style: text.bodySmall),
                  const SizedBox(height: 4),
                  Text(titles[_step], style: text.titleLarge),
                  const SizedBox(height: 20),
                  ..._fields(context, l10n),
                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    PosErrorNote(message: _error!),
                  ],
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: FilledButton(
            onPressed: _saving ? null : _next,
            child: _saving
                ? Row(mainAxisSize: MainAxisSize.min, children: [
                    const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white)),
                    const SizedBox(width: 12),
                    Text(l10n.posSaving),
                  ])
                : Text(last ? l10n.posFinish : l10n.posNext),
          ),
        ),
      ],
    );
  }

  List<Widget> _fields(BuildContext context, AppLocalizations l10n) {
    const gap = SizedBox(height: 16);
    switch (_step) {
      case 0:
        return [
          TextFormField(
            controller: _name,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(labelText: l10n.posOnbShopName),
            validator: (v) => _fieldError(l10n, PosValidators.shopName(v)),
          ),
          gap,
          TextFormField(
            controller: _owner,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            autofillHints: const [AutofillHints.name],
            decoration: InputDecoration(labelText: l10n.posOnbOwnerName),
            validator: (v) => _fieldError(l10n, PosValidators.ownerName(v)),
          ),
          gap,
          TextFormField(
            controller: _address,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.sentences,
            autofillHints: const [AutofillHints.fullStreetAddress],
            decoration: InputDecoration(labelText: l10n.posOnbAddress),
            validator: (v) => _fieldError(l10n, PosValidators.address(v)),
          ),
          gap,
          TextFormField(
            controller: _city,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            autofillHints: const [AutofillHints.addressCity],
            decoration: InputDecoration(labelText: l10n.posOnbCity),
            validator: (v) => _fieldError(l10n, PosValidators.city(v)),
          ),
          gap,
          TextFormField(
            controller: _state,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(labelText: l10n.posOnbState),
          ),
          gap,
          TextFormField(
            controller: _pincode,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
            autofillHints: const [AutofillHints.postalCode],
            decoration: InputDecoration(labelText: l10n.posOnbPincode),
            validator: (v) => _fieldError(l10n, PosValidators.pincode(v)),
          ),
        ];
      case 1:
        return [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.posOnbGstSwitch, style: Theme.of(context).textTheme.titleMedium),
            value: _gst,
            onChanged: (v) => setState(() => _gst = v),
          ),
          if (_gst) ...[
            gap,
            TextFormField(
              controller: _gstin,
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.next,
              inputFormatters: [LengthLimitingTextInputFormatter(15)],
              decoration: InputDecoration(labelText: l10n.posOnbGstin),
              validator: (v) => _fieldError(l10n, PosValidators.gstin(v, gstEnabled: _gst)),
            ),
          ],
          gap,
          TextFormField(
            controller: _upi,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: l10n.posOnbUpi, hintText: l10n.posOnbUpiHint),
            validator: (v) => _fieldError(l10n, PosValidators.upi(v)),
          ),
          gap,
          TextFormField(
            controller: _invoicePrefix,
            textCapitalization: TextCapitalization.characters,
            textInputAction: TextInputAction.done,
            inputFormatters: [LengthLimitingTextInputFormatter(6)],
            decoration: InputDecoration(labelText: l10n.posOnbInvoicePrefix),
            validator: (v) => _fieldError(l10n, PosValidators.prefix(v)),
          ),
        ];
      case 2:
        final printers = {
          'none': (Icons.print_disabled_outlined, l10n.posPrinterNone),
          'system-default': (Icons.print_outlined, l10n.posPrinterSystem),
          'thermal-58mm': (Icons.receipt_long_outlined, l10n.posPrinter58),
          'thermal-80mm': (Icons.receipt_long_outlined, l10n.posPrinter80),
        };
        return [
          Text(l10n.posOnbPrinter, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          for (final id in kPosPrinterProfiles) ...[
            PosChoiceCard(
              icon: printers[id]!.$1,
              title: printers[id]!.$2,
              selected: _printer == id,
              onTap: () => setState(() => _printer = id),
            ),
            const SizedBox(height: 8),
          ],
          gap,
          TextFormField(
            controller: _orderPrefix,
            textCapitalization: TextCapitalization.characters,
            textInputAction: TextInputAction.next,
            inputFormatters: [LengthLimitingTextInputFormatter(6)],
            decoration: InputDecoration(labelText: l10n.posOnbOrderPrefix),
            validator: (v) => _fieldError(l10n, PosValidators.prefix(v)),
          ),
          gap,
          TextFormField(
            controller: _days,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)],
            decoration: InputDecoration(labelText: l10n.posOnbDeliveryDays),
            validator: (v) => _fieldError(l10n, PosValidators.deliveryDays(v)),
          ),
        ];
      default:
        return [
          Text(l10n.posOnbPricesTitle, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          PosChoiceCard(
            icon: Icons.auto_awesome_outlined,
            title: l10n.posOnbPricesStarter,
            body: l10n.posOnbPricesStarterBody,
            selected: _starter,
            onTap: () => setState(() => _starter = true),
          ),
          const SizedBox(height: 12),
          PosChoiceCard(
            icon: Icons.edit_note_rounded,
            title: l10n.posOnbPricesOwn,
            body: l10n.posOnbPricesOwnBody,
            selected: !_starter,
            onTap: () => setState(() => _starter = false),
          ),
        ];
    }
  }
}

class _Done extends StatelessWidget {
  const _Done({required this.l10n, required this.starterCount, required this.onOpen});
  final AppLocalizations l10n;
  final int? starterCount;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Spacer(),
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(color: scheme.primaryContainer, shape: BoxShape.circle),
            child: Icon(Icons.check_rounded, size: 56, color: scheme.primary),
          ),
          const SizedBox(height: 24),
          Text(l10n.posDoneTitle, style: text.titleLarge, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(l10n.posDoneBody, style: text.bodyMedium, textAlign: TextAlign.center),
          if (starterCount != null && starterCount! > 0) ...[
            const SizedBox(height: 16),
            Text(l10n.posDoneStarterNote(starterCount!), style: text.bodySmall, textAlign: TextAlign.center),
          ],
          const Spacer(),
          FilledButton(onPressed: onOpen, child: Text(l10n.posDoneButton)),
        ],
      ),
    );
  }
}

class _OwnerOnly extends ConsumerWidget {
  const _OwnerOnly({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.posOnbTitle), automaticallyImplyLeading: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline_rounded, size: 56, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 16),
              Text(l10n.posOnbOwnerOnlyTitle, style: text.titleLarge, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(l10n.posOnbOwnerOnlyBody, style: text.bodyMedium, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              OutlinedButton(onPressed: () => ref.read(authProvider.notifier).logout(), child: Text(l10n.posLogOut)),
            ],
          ),
        ),
      ),
    );
  }
}
