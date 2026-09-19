import 'package:flutter/services.dart';

/// Keeps a mobile-number field to digits only, at most 10 of them.
///
/// Anything else typed or pasted is dropped: letters, spaces, dashes, "+".
/// A pasted number with its country code ("+91 98765 43210", "919876543210")
/// keeps just the 10 digits — the country code is never counted or stored in
/// this field.
class TenDigitPhoneFormatter extends TextInputFormatter {
  const TenDigitPhoneFormatter();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 12 && digits.startsWith('91')) digits = digits.substring(2);
    if (digits.length > 10) digits = digits.substring(0, 10);
    if (digits == newValue.text) return newValue;
    return TextEditingValue(
      text: digits,
      selection: TextSelection.collapsed(offset: digits.length),
    );
  }
}

/// True only for exactly 10 digits.
bool isValidTenDigitPhone(String? value) => RegExp(r'^\d{10}$').hasMatch(value?.trim() ?? '');
