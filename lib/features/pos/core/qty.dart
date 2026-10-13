/// Quantities are whole for pieces and pairs and have up to two decimals for kg and sq ft.
/// Shown without a trailing ".0" ("2", "0.6", "1.25").
String fmtQty(num q) {
  final r = double.parse(q.toStringAsFixed(2));
  if (r == r.roundToDouble()) return r.toInt().toString();
  var s = r.toStringAsFixed(2);
  if (s.endsWith('0')) s = s.substring(0, s.length - 1);
  return s;
}

/// Parses what the owner typed ("0.6", "1,2", " 2 "); null when it is not a usable quantity.
double? parseQty(String raw, {double min = 0.1, double max = 9999}) {
  final v = double.tryParse(raw.trim().replaceAll(',', '.'));
  if (v == null || !v.isFinite) return null;
  final r = double.parse(v.toStringAsFixed(2));
  if (r < min || r > max) return null;
  return r;
}
