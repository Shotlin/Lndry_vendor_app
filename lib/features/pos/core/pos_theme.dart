import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pos_colors.dart';

/// Material 3 theme for POS mode (light + dark). Manrope — the same font as the
/// Epic POS — falls back to the platform font offline, and Devanagari renders
/// through the system font so Hindi never shows boxes.
abstract final class PosTheme {
  PosTheme._();

  static const double minTouch = 48;
  static const double radius = 14;

  static ThemeData light() => _build(
        brightness: Brightness.light,
        scheme: const ColorScheme.light(
          primary: PosColors.brand,
          onPrimary: Colors.white,
          primaryContainer: PosColors.brandWash,
          onPrimaryContainer: PosColors.brandStrong,
          secondary: PosColors.success,
          onSecondary: Colors.white,
          // Material paints selected tabs, segmented buttons and progress tracks from the *secondary container*.
          // Left at its default it turns green/grey next to a violet brand — pin it to the brand wash.
          secondaryContainer: PosColors.brandWash,
          onSecondaryContainer: PosColors.brandStrong,
          surface: PosColors.paper,
          onSurface: PosColors.ink,
          onSurfaceVariant: PosColors.copy,
          outline: PosColors.line,
          error: PosColors.danger,
          onError: Colors.white,
        ),
        canvas: PosColors.canvas,
        ink: PosColors.ink,
        line: PosColors.line,
      );

  static ThemeData dark() => _build(
        brightness: Brightness.dark,
        scheme: const ColorScheme.dark(
          primary: PosColors.darkBrand,
          onPrimary: PosColors.darkCanvas,
          primaryContainer: PosColors.darkBrandWash,
          onPrimaryContainer: PosColors.darkBrand,
          secondary: PosColors.darkSuccess,
          onSecondary: PosColors.darkCanvas,
          secondaryContainer: PosColors.darkBrandWash,
          onSecondaryContainer: PosColors.darkBrand,
          surface: PosColors.darkPaper,
          onSurface: PosColors.darkInk,
          onSurfaceVariant: PosColors.darkCopy,
          outline: PosColors.darkLine,
          error: Color(0xFFF87171),
          onError: PosColors.darkCanvas,
        ),
        canvas: PosColors.darkCanvas,
        ink: PosColors.darkInk,
        line: PosColors.darkLine,
      );

  static ThemeData _build({
    required Brightness brightness,
    required ColorScheme scheme,
    required Color canvas,
    required Color ink,
    required Color line,
  }) {
    final base = ThemeData(brightness: brightness, useMaterial3: true, colorScheme: scheme);
    final text = GoogleFonts.manropeTextTheme(base.textTheme)
        .apply(bodyColor: ink, displayColor: ink)
        .copyWith(
          // Big, readable defaults: nothing on a POS screen is smaller than 14.
          bodyMedium: GoogleFonts.manrope(fontSize: 15, height: 1.35, color: ink),
          bodySmall: GoogleFonts.manrope(fontSize: 14, height: 1.3, color: scheme.onSurfaceVariant),
          titleMedium: GoogleFonts.manrope(fontSize: 17, fontWeight: FontWeight.w700, color: ink),
          titleLarge: GoogleFonts.manrope(fontSize: 22, fontWeight: FontWeight.w800, color: ink),
        );
    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));
    return base.copyWith(
      scaffoldBackgroundColor: canvas,
      textTheme: text,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: ink,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: text.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(color: line),
        ),
      ),
      dividerTheme: DividerThemeData(color: line, space: 1, thickness: 1),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(minTouch),
          shape: shape,
          textStyle: text.titleMedium,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(minTouch),
          shape: shape,
          side: BorderSide(color: scheme.primary),
          textStyle: text.titleMedium,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(minimumSize: const Size(minTouch, minTouch), textStyle: text.titleMedium),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: BorderSide(color: line)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: BorderSide(color: line)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: BorderSide(color: scheme.primary, width: 2)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: BorderSide(color: scheme.error)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: BorderSide(color: scheme.error, width: 2)),
        labelStyle: text.bodyMedium,
        helperStyle: text.bodySmall,
        errorStyle: GoogleFonts.manrope(fontSize: 13, color: scheme.error),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primaryContainer,
        height: 68,
        // Selected = brand colour on the brand wash; unselected = readable grey. Never white-on-pale.
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(color: states.contains(WidgetState.selected) ? scheme.primary : scheme.onSurfaceVariant),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: states.contains(WidgetState.selected) ? scheme.primary : scheme.onSurfaceVariant,
          ),
        ),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow, // every icon has a word
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.primaryContainer,
        circularTrackColor: scheme.primaryContainer,
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: shape,
        side: BorderSide(color: line),
        labelStyle: text.bodyMedium,
        selectedColor: scheme.primaryContainer,
      ),
      snackBarTheme: SnackBarThemeData(behavior: SnackBarBehavior.floating, shape: shape),
    );
  }
}
