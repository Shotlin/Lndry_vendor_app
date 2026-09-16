import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lndry_vendor_app/core/services/storage_service.dart';
import 'package:lndry_vendor_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          storageServiceProvider.overrideWithValue(StorageService(prefs: prefs)),
        ],
        child: const LndryVendorApp(),
      ),
    );

    // Verify that the app builds without errors
    expect(find.byType(MaterialApp), findsOneWidget);

    // Advance past the splash transition and the bounded secure-storage
    // fallback used on a fresh install. Without this, the test intentionally
    // disposes while that defensive timeout is still pending.
    await tester.pump(const Duration(seconds: 6));
    await tester.pumpAndSettle();
  });
}
