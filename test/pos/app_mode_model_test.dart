import 'package:flutter_test/flutter_test.dart';
import 'package:lndry_vendor_app/models/pos/app_mode_model.dart';

void main() {
  group('AppModeInfo.fromJson', () {
    test('parses a full BOTH/COMPLETED answer', () {
      final info = AppModeInfo.fromJson({
        'hasVendor': true,
        'vendorId': 'v1',
        'shopName': 'Sparkle',
        'role': 'VENDOR_OWNER',
        'offering': 'BOTH',
        'posOnboardingStatus': 'COMPLETED',
        'posPlanName': 'Enterprise 5 Store',
        'posValidTo': '2026-11-03',
        'allowedModes': ['MARKETPLACE', 'POS'],
        'needsPosOnboarding': false,
        'canStartPos': false,
        'vendorType': 'PARTNER',
        'appSync': true,
        'walletAccess': true,
      });
      expect(info.offering, VendorOffering.both);
      expect(info.posOnboardingStatus, PosOnboardingStatus.completed);
      expect(info.allowedModes, [AppMode.marketplace, AppMode.pos]);
      expect(info.posValidTo, DateTime(2026, 11, 3));
      expect(info.canSwitchMode, isTrue);
      expect(info.isOwner, isTrue);
      expect(info.walletAccess, isTrue);
    });

    test('date is date-only: no timezone drift for any time-of-day suffix', () {
      expect(AppModeInfo.fromJson({'posValidTo': '2026-11-03T00:00:00.000Z'}).posValidTo, DateTime(2026, 11, 3));
      expect(AppModeInfo.fromJson({'posValidTo': '2026-11-03T23:59:59+05:30'}).posValidTo, DateTime(2026, 11, 3));
    });

    test('an empty / odd answer never throws and means "marketplace behaviour" defaults', () {
      for (final json in <Map<String, dynamic>>[
        {},
        {'allowedModes': 'nope', 'offering': 42, 'posValidTo': 'garbage', 'posOnboardingStatus': null},
        {'allowedModes': [null, 5, 'POS', 'pos', 'SOMETHING']},
      ]) {
        expect(() => AppModeInfo.fromJson(json), returnsNormally);
      }
      final empty = AppModeInfo.fromJson({});
      expect(empty.hasVendor, isFalse);
      expect(empty.offering, isNull);
      expect(empty.posOnboardingStatus, PosOnboardingStatus.notStarted);
      expect(empty.allowedModes, isEmpty);
      expect(empty.posValidTo, isNull);
      expect(empty.vendorType, 'STANDARD');
    });

    test('allowedModes drops unknown values and duplicates, keeps order', () {
      final info = AppModeInfo.fromJson({'allowedModes': ['POS', 'POS', 'junk', 'MARKETPLACE', 'pos']});
      expect(info.allowedModes, [AppMode.pos, AppMode.marketplace]);
    });

    test('enum parsing is case-insensitive and rejects unknowns', () {
      expect(VendorOffering.parse('pos'), VendorOffering.pos);
      expect(VendorOffering.parse('Both'), VendorOffering.both);
      expect(VendorOffering.parse('nope'), isNull);
      expect(VendorOffering.parse(null), isNull);
      expect(AppMode.parse('marketplace'), AppMode.marketplace);
      expect(AppMode.parse('x'), isNull);
      expect(PosOnboardingStatus.parse('in_progress'), PosOnboardingStatus.inProgress);
      expect(PosOnboardingStatus.parse('???'), PosOnboardingStatus.notStarted);
    });
  });

  group('PosOnboardingState.fromJson', () {
    test('keeps saved step maps and ignores non-map garbage', () {
      final s = PosOnboardingState.fromJson({
        'status': 'IN_PROGRESS',
        'data': {
          'shop': {'name': 'A', 'city': 'Pune'},
          'tax': 'not-a-map',
          'counter': {'printerProfile': 'none'},
        },
        'missingSteps': ['tax', 'pricelist'],
        'nextStep': 'tax',
      });
      expect(s.status, PosOnboardingStatus.inProgress);
      expect(s.step('shop')['city'], 'Pune');
      expect(s.step('tax'), isEmpty);
      expect(s.step('pricelist'), isEmpty);
      expect(s.missingSteps, ['tax', 'pricelist']);
      expect(s.nextStep, 'tax');
    });

    test('tolerates missing fields', () {
      final s = PosOnboardingState.fromJson({});
      expect(s.status, PosOnboardingStatus.notStarted);
      expect(s.data, isEmpty);
      expect(s.nextStep, isNull);
    });
  });
}
