/// A 10-digit Indian mobile number from what a person typed or pasted, or `null` if it is not one.
/// Accepts spaces, dashes, a leading `+91`/`91` or `0` (e.g. `+91 98111-22233`, `098111 22233`).
String? normalizeMobile(String? input) {
  if (input == null) return null;
  var d = input.replaceAll(RegExp(r'\D'), '');
  if (d.length == 12 && d.startsWith('91')) d = d.substring(2);
  if (d.length == 11 && d.startsWith('0')) d = d.substring(1);
  return d.length == 10 ? d : null;
}

/// Whether the text typed so far looks like a full mobile number (used to offer "Add as new customer").
bool looksLikeMobile(String input) => normalizeMobile(input) != null;
