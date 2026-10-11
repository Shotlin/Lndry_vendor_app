import 'package:flutter/material.dart';

/// POS mode colors — the Epic POS (desktop/website) violet palette, so the phone
/// POS looks like the same product. Source of truth: epic-laundry-desktop
/// `webapp/src/index.css` (`--lndry-*` tokens). Not the marketplace blue.
///
/// Every text/background pair used on screen must keep contrast >= 4.5:1
/// (checked in `test/pos/pos_colors_test.dart`).
abstract final class PosColors {
  PosColors._();

  // ── Brand ─────────────────────────────────────────────────────────────────
  static const Color brand = Color(0xFF664CF0);
  static const Color brandStrong = Color(0xFF5138CF);
  static const Color brandWash = Color(0xFFF0EDFF);
  static const Color brandMist = Color(0xFFE3DDFF);

  // ── Surfaces & text (light) ───────────────────────────────────────────────
  static const Color canvas = Color(0xFFF8F7FC);
  static const Color paper = Color(0xFFFFFEFE);
  static const Color line = Color(0xFFE5E0F2);
  static const Color ink = Color(0xFF241A45);
  static const Color copy = Color(0xFF4F4A62);
  static const Color muted = Color(0xFF767086);

  // ── Status ────────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF187B5C);
  static const Color successWash = Color(0xFFE9F7F1);
  static const Color attention = Color(0xFFA96916);
  static const Color attentionWash = Color(0xFFFFF3D7);
  static const Color danger = Color(0xFFDC2626);
  static const Color dangerWash = Color(0xFFFEF2F2);

  /// Epic's `attention` / `danger` are 4.04:1 / 4.41:1 on their washes — fine for fills, icons and
  /// borders (3:1 is enough there) but too faint for WORDS. Use these darker twins for any text
  /// written on a wash or on paper (5.67:1 / 5.91:1).
  static const Color attentionText = Color(0xFF8A5412);
  static const Color dangerText = Color(0xFFB91C1C);

  // ── Dark theme ────────────────────────────────────────────────────────────
  static const Color darkCanvas = Color(0xFF14121C);
  static const Color darkPaper = Color(0xFF201E2A);
  static const Color darkRaised = Color(0xFF292634);
  static const Color darkLine = Color(0xFF3A3546);
  static const Color darkInk = Color(0xFFF1EDF9);
  static const Color darkCopy = Color(0xFFD2CBDC);
  static const Color darkMuted = Color(0xFFB1A9BF);
  static const Color darkBrand = Color(0xFFB8AAFF);
  static const Color darkBrandWash = Color(0xFF322A4D);
  static const Color darkSuccess = Color(0xFFA9DFC8);
  static const Color darkAttention = Color(0xFFFFD48A);

  /// WCAG contrast ratio between two opaque colors (1.0 – 21.0).
  static double contrast(Color a, Color b) {
    final la = a.computeLuminance();
    final lb = b.computeLuminance();
    final hi = la > lb ? la : lb;
    final lo = la > lb ? lb : la;
    return (hi + 0.05) / (lo + 0.05);
  }
}
