import 'package:flutter_test/flutter_test.dart';
import 'package:lndry_vendor_app/features/pos/onboarding/pos_onboarding_validators.dart';

void main() {
  group('required text fields', () {
    test('shop name 2..200 after trimming and collapsing spaces', () {
      expect(PosValidators.shopName('  '), PosFieldError.shopName);
      expect(PosValidators.shopName('A'), PosFieldError.shopName);
      expect(PosValidators.shopName(null), PosFieldError.shopName);
      expect(PosValidators.shopName('Ab'), isNull);
      expect(PosValidators.shopName('x' * 200), isNull);
      expect(PosValidators.shopName('x' * 201), PosFieldError.shopName);
    });
    test('owner, address, city have their own limits', () {
      expect(PosValidators.ownerName('A'), PosFieldError.ownerName);
      expect(PosValidators.ownerName('Ravi'), isNull);
      expect(PosValidators.address('12'), PosFieldError.address);
      expect(PosValidators.address('12 MG Road'), isNull);
      expect(PosValidators.city('P'), PosFieldError.city);
      expect(PosValidators.city('Pune'), isNull);
    });
    test('Hindi names are accepted', () {
      expect(PosValidators.shopName('चमक लॉन्ड्री'), isNull);
      expect(PosValidators.ownerName('रवि कुमार'), isNull);
    });
  });

  group('pincode (optional, 6 digits)', () {
    test('empty ok; 6 digits ok; else rejected', () {
      expect(PosValidators.pincode(''), isNull);
      expect(PosValidators.pincode(null), isNull);
      expect(PosValidators.pincode('411001'), isNull);
      expect(PosValidators.pincode('41100'), PosFieldError.pincode);
      expect(PosValidators.pincode('4110011'), PosFieldError.pincode);
      expect(PosValidators.pincode('41100a'), PosFieldError.pincode);
    });
  });

  group('GSTIN (only when GST is on)', () {
    test('ignored when GST is off, even if garbage', () {
      expect(PosValidators.gstin('nonsense', gstEnabled: false), isNull);
      expect(PosValidators.gstin('', gstEnabled: false), isNull);
    });
    test('valid GSTIN accepted in any case; bad ones rejected', () {
      expect(PosValidators.gstin('27ABCDE1234F1Z5', gstEnabled: true), isNull);
      expect(PosValidators.gstin('27abcde1234f1z5', gstEnabled: true), isNull);
      expect(PosValidators.gstin(' 27ABCDE1234F1Z5 ', gstEnabled: true), isNull);
      for (final bad in ['', 'BADGSTIN', '27ABCDE1234F1Z', '27ABCDE1234F0Z5', '2AABCDE1234F1Z5', '27ABCDE1234F1Y5']) {
        expect(PosValidators.gstin(bad, gstEnabled: true), PosFieldError.gstin, reason: bad);
      }
    });
  });

  group('UPI id (optional)', () {
    test('accepts name@bank forms, rejects the rest', () {
      for (final ok in ['', 'ravi@okbank', 'ravi.k-1_x@ybl', '9876543210@paytm']) {
        expect(PosValidators.upi(ok), isNull, reason: ok);
      }
      for (final bad in ['ravi', '@okbank', 'ravi@1', 'a b@bank', 'r@b', 'ravi@@bank']) {
        expect(PosValidators.upi(bad), PosFieldError.upi, reason: bad);
      }
    });
  });

  group('prefix (optional, 1-6 letters/digits)', () {
    test('upper-cased before checking', () {
      expect(PosValidators.prefix(''), isNull);
      expect(PosValidators.prefix('spk'), isNull);
      expect(PosValidators.prefix('AB12CD'), isNull);
      expect(PosValidators.prefix('TOOLONG1'), PosFieldError.prefix);
      expect(PosValidators.prefix('A-B'), PosFieldError.prefix);
    });
  });

  group('delivery days (optional, 0..30)', () {
    test('bounds', () {
      expect(PosValidators.deliveryDays(''), isNull);
      expect(PosValidators.deliveryDays('0'), isNull);
      expect(PosValidators.deliveryDays('30'), isNull);
      expect(PosValidators.deliveryDays('31'), PosFieldError.days);
      expect(PosValidators.deliveryDays('-1'), PosFieldError.days);
      expect(PosValidators.deliveryDays('2.5'), PosFieldError.days);
      expect(PosValidators.deliveryDays('abc'), PosFieldError.days);
    });
  });

  group('payload builders match the backend contract exactly', () {
    test('shop: trims, drops empty optionals', () {
      expect(
        PosOnboardingPayloads.shop(name: '  Sparkle  Laundry ', ownerName: 'Ravi', addressLine1: '12 MG Road', city: 'Pune'),
        {'name': 'Sparkle Laundry', 'ownerName': 'Ravi', 'addressLine1': '12 MG Road', 'city': 'Pune'},
      );
      final withOptional = PosOnboardingPayloads.shop(name: 'S', ownerName: 'R', addressLine1: 'A', city: 'C', state: 'MH', pincode: '411001');
      expect(withOptional['state'], 'MH');
      expect(withOptional['pincode'], '411001');
    });
    test('tax: GST off sends no gstin; GST on upper-cases it; currency is always INR', () {
      expect(PosOnboardingPayloads.tax(gstEnabled: false, gstin: '27ABCDE1234F1Z5'), {'gstEnabled': false, 'currency': 'INR'});
      final on = PosOnboardingPayloads.tax(gstEnabled: true, gstin: '27abcde1234f1z5', upiId: ' ravi@okbank ', invoicePrefix: 'spk');
      expect(on, {'gstEnabled': true, 'gstin': '27ABCDE1234F1Z5', 'upiId': 'ravi@okbank', 'currency': 'INR', 'invoicePrefix': 'SPK'});
    });
    test('counter: delivery days becomes an int, prefix upper-case, empties dropped', () {
      expect(
        PosOnboardingPayloads.counter(printerProfile: 'thermal-58mm', orderSeriesPrefix: 'sp', deliveryDays: '2'),
        {'printerProfile': 'thermal-58mm', 'orderSeriesPrefix': 'SP', 'defaultDeliveryDays': 2},
      );
      expect(PosOnboardingPayloads.counter(printerProfile: 'none'), {'printerProfile': 'none'});
    });
    test('pricelist', () {
      expect(PosOnboardingPayloads.pricelist(starter: true), {'choice': 'starter'});
      expect(PosOnboardingPayloads.pricelist(starter: false), {'choice': 'own'});
    });
  });

  group('resume', () {
    test('step order matches the backend and printer list is the accepted set', () {
      expect(kPosOnboardingSteps, ['shop', 'tax', 'counter', 'pricelist']);
      expect(kPosPrinterProfiles, ['none', 'system-default', 'thermal-58mm', 'thermal-80mm']);
    });
    test('opens at the first missing step; unknown or null opens the last page', () {
      expect(posResumeStepIndex('shop'), 0);
      expect(posResumeStepIndex('tax'), 1);
      expect(posResumeStepIndex('counter'), 2);
      expect(posResumeStepIndex('pricelist'), 3);
      expect(posResumeStepIndex(null), 3);
      expect(posResumeStepIndex('bogus'), 3);
    });
  });
}
