import 'package:flutter_test/flutter_test.dart';
import 'package:lndry_vendor_app/features/pos/core/money.dart';

void main() {
  group('formatPaise', () {
    test('Indian grouping', () {
      expect(formatPaise(0), '₹0');
      expect(formatPaise(99), '₹0.99');
      expect(formatPaise(8000), '₹80');
      expect(formatPaise(123400), '₹1,234');
      expect(formatPaise(123456), '₹1,234.56');
      expect(formatPaise(10000000), '₹1,00,000');
      expect(formatPaise(123456789), '₹12,34,567.89');
      expect(formatPaise(3000000000), '₹3,00,00,000');
    });
    test('alwaysShowPaise keeps .00', () => expect(formatPaise(8000, alwaysShowPaise: true), '₹80.00'));
    test('negative', () => expect(formatPaise(-12550), '-₹125.50'));
    test('null is a dash, never 0', () => expect(formatPaise(null), '—'));
  });

  group('parseRupeesToPaise', () {
    test('plain amounts', () {
      expect(parseRupeesToPaise('80'), 8000);
      expect(parseRupeesToPaise('80.5'), 8050);
      expect(parseRupeesToPaise('80.05'), 8005);
      expect(parseRupeesToPaise('₹1,250'), 125000);
      expect(parseRupeesToPaise(' 0 '), 0);
      expect(parseRupeesToPaise('0.99'), 99);
    });
    test('no floating point drift', () {
      // 19.99 * 100 is 1998.9999999999998 in doubles; the parser must give exactly 1999.
      expect(parseRupeesToPaise('19.99'), 1999);
      expect(parseRupeesToPaise('1.15'), 115);
      expect(parseRupeesToPaise('4.35'), 435);
    });
    test('rejects what is not an amount', () {
      for (final bad in ['', 'abc', '-5', '1.234', '1.', '.5', '1e3', '12345678901', null]) {
        expect(parseRupeesToPaise(bad), isNull, reason: '"$bad"');
      }
    });
    test('round trip with paiseToInput', () {
      for (final p in [0, 1, 99, 100, 8000, 8050, 123456]) {
        expect(parseRupeesToPaise(paiseToInput(p)), p);
      }
      expect(paiseToInput(8000), '80');
      expect(paiseToInput(8050), '80.50');
      expect(paiseToInput(8005), '80.05');
    });
  });
}
