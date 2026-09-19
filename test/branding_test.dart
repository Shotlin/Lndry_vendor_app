import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The login and splash screens must show the real Partner app icon, not a
/// generic Material icon.
void main() {
  const logo = 'assets/images/logo/lndry_logo.png';

  test('the real logo asset exists and is bundled', () {
    expect(File(logo).existsSync(), isTrue);
    expect(File('pubspec.yaml').readAsStringSync(), contains('assets/images/logo/'));
  });

  for (final page in [
    'lib/features/auth/presentation/pages/login_page.dart',
    'lib/features/splash/presentation/pages/splash_page.dart',
  ]) {
    test('$page shows the real logo, not the generic laundry icon', () {
      final source = File(page).readAsStringSync();
      expect(source, contains(logo));
      expect(source, isNot(contains('Icons.local_laundry_service')));
    });
  }

  test('the native (pre-Flutter) splash config points at the same logo', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final config = pubspec.substring(pubspec.indexOf('flutter_native_splash:\n  color'));
    expect(config, contains(logo));
  });
}
