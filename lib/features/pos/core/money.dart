/// Money in the POS is ALWAYS whole paise (an `int`). Rupee text is only produced for display and only
/// parsed from what the user types; no `double` ever holds an amount.
library;

/// `123456` paise → `₹1,234.56`; whole rupees drop the decimals (`₹1,234`) unless [alwaysShowPaise].
/// Indian digit grouping (₹12,34,567). Negative amounts show a leading minus. `null` → `—` (never a fake 0).
String formatPaise(int? paise, {bool alwaysShowPaise = false}) {
  if (paise == null) return '—';
  final negative = paise < 0;
  final abs = negative ? -paise : paise;
  final rupees = abs ~/ 100;
  final rest = abs % 100;
  final grouped = _groupIndian(rupees.toString());
  final decimals = rest == 0 && !alwaysShowPaise ? '' : '.${rest.toString().padLeft(2, '0')}';
  return '${negative ? '-' : ''}₹$grouped$decimals';
}

String _groupIndian(String digits) {
  if (digits.length <= 3) return digits;
  final last3 = digits.substring(digits.length - 3);
  var head = digits.substring(0, digits.length - 3);
  final parts = <String>[];
  while (head.length > 2) {
    parts.insert(0, head.substring(head.length - 2));
    head = head.substring(0, head.length - 2);
  }
  if (head.isNotEmpty) parts.insert(0, head);
  return '${parts.join(',')},$last3';
}

final RegExp _rupeeInput = RegExp(r'^\d{1,9}(\.\d{1,2})?$');

/// What a person typed in a price box → paise, or `null` if it is not a plain amount.
/// Accepts `80`, `80.5`, `80.50`, `₹80`, `1,250`; rejects `abc`, `-5`, `1.234`, `` (empty).
int? parseRupeesToPaise(String? input) {
  if (input == null) return null;
  final t = input.replaceAll('₹', '').replaceAll(',', '').replaceAll(' ', '');
  if (!_rupeeInput.hasMatch(t)) return null;
  final dot = t.indexOf('.');
  if (dot < 0) return int.parse(t) * 100;
  final whole = int.parse(t.substring(0, dot));
  var frac = t.substring(dot + 1);
  if (frac.length == 1) frac = '${frac}0';
  return whole * 100 + int.parse(frac);
}

/// Paise → the text for an editable box (`8000` → `80`, `8050` → `80.50`), no symbol, no grouping.
String paiseToInput(int paise) {
  final whole = paise ~/ 100;
  final rest = paise % 100;
  return rest == 0 ? '$whole' : '$whole.${rest.toString().padLeft(2, '0')}';
}
