import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lndry_vendor_app/features/pos/core/pos_colors.dart';
import 'package:lndry_vendor_app/features/pos/core/pos_theme.dart';

void main() {
  // PosTheme uses google_fonts, which needs the Flutter binding even when only reading theme values.
  TestWidgetsFlutterBinding.ensureInitialized();
  // "Easy for anyone" includes readable: every text/background pair used on a POS screen needs >= 4.5:1.
  final light = <String, (Color, Color)>{
    'ink on canvas': (PosColors.ink, PosColors.canvas),
    'ink on paper': (PosColors.ink, PosColors.paper),
    'copy on paper': (PosColors.copy, PosColors.paper),
    'copy on canvas': (PosColors.copy, PosColors.canvas),
    'muted on paper': (PosColors.muted, PosColors.paper),
    'white on brand (primary button)': (Colors.white, PosColors.brand),
    'white on brandStrong': (Colors.white, PosColors.brandStrong),
    'brandStrong on brandWash (selected chip)': (PosColors.brandStrong, PosColors.brandWash),
    'ink on brandWash': (PosColors.ink, PosColors.brandWash),
    'success on successWash (paid)': (PosColors.success, PosColors.successWash),
    'attentionText on attentionWash (balance due)': (PosColors.attentionText, PosColors.attentionWash),
    'attentionText on paper': (PosColors.attentionText, PosColors.paper),
    'dangerText on dangerWash (cancel)': (PosColors.dangerText, PosColors.dangerWash),
    'dangerText on paper': (PosColors.dangerText, PosColors.paper),
    'dangerText on canvas': (PosColors.dangerText, PosColors.canvas),
    'brand on paper (links)': (PosColors.brand, PosColors.paper),
  };
  final dark = <String, (Color, Color)>{
    'darkInk on darkCanvas': (PosColors.darkInk, PosColors.darkCanvas),
    'darkInk on darkPaper': (PosColors.darkInk, PosColors.darkPaper),
    'darkCopy on darkPaper': (PosColors.darkCopy, PosColors.darkPaper),
    'darkMuted on darkPaper': (PosColors.darkMuted, PosColors.darkPaper),
    'darkBrand on darkPaper': (PosColors.darkBrand, PosColors.darkPaper),
    'darkBrand on darkBrandWash': (PosColors.darkBrand, PosColors.darkBrandWash),
    'darkCanvas on darkBrand (primary button)': (PosColors.darkCanvas, PosColors.darkBrand),
    'darkSuccess on darkPaper': (PosColors.darkSuccess, PosColors.darkPaper),
    'darkAttention on darkPaper': (PosColors.darkAttention, PosColors.darkPaper),
  };

  group('contrast >= 4.5:1', () {
    light.forEach((name, pair) => test('light: $name', () {
          expect(PosColors.contrast(pair.$1, pair.$2), greaterThanOrEqualTo(4.5), reason: name);
        }));
    dark.forEach((name, pair) => test('dark: $name', () {
          expect(PosColors.contrast(pair.$1, pair.$2), greaterThanOrEqualTo(4.5), reason: name);
        }));
  });

  // Non-text parts (icons, borders, chip fills) need only 3:1 (WCAG 1.4.11). The raw Epic status colors
  // are allowed there but must never carry words — that is what the *Text variants are for.
  group('non-text contrast >= 3:1', () {
    final nonText = <String, (Color, Color)>{
      'attention icon on attentionWash': (PosColors.attention, PosColors.attentionWash),
      'danger icon on dangerWash': (PosColors.danger, PosColors.dangerWash),
      'success icon on successWash': (PosColors.success, PosColors.successWash),
      'brand border on paper': (PosColors.brand, PosColors.paper),
    };
    nonText.forEach((name, pair) => test(name, () {
          expect(PosColors.contrast(pair.$1, pair.$2), greaterThanOrEqualTo(3.0), reason: name);
        }));
  });

  test('contrast helper is symmetric and sane', () {
    expect(PosColors.contrast(Colors.black, Colors.white), closeTo(21, 0.01));
    expect(PosColors.contrast(Colors.white, Colors.black), closeTo(21, 0.01));
    expect(PosColors.contrast(Colors.white, Colors.white), closeTo(1, 0.001));
  });

  test('brand matches the Epic POS violet', () {
    expect(PosColors.brand, const Color(0xFF664CF0));
  });

  group('theme has no stray Material defaults (found as a green progress track and white-on-pale tab icons)', () {
    for (final (name, dark) in [('light', false), ('dark', true)]) {
      ThemeData build() => dark ? PosTheme.dark() : PosTheme.light();
      testWidgets('$name: secondary container is the brand wash, not a default tint', (tester) async {
        final c = build().colorScheme;
        expect(c.secondaryContainer, dark ? PosColors.darkBrandWash : PosColors.brandWash);
        expect(c.onSecondaryContainer, dark ? PosColors.darkBrand : PosColors.brandStrong);
        expect(PosColors.contrast(c.onSecondaryContainer, c.secondaryContainer), greaterThanOrEqualTo(4.5));
      });

      testWidgets('$name: selected tab icon is clearly visible on its indicator, unselected on the bar', (tester) async {
        final nav = build().navigationBarTheme;
        final selected = nav.iconTheme!.resolve({WidgetState.selected})!.color!;
        final unselected = nav.iconTheme!.resolve({})!.color!;
        expect(PosColors.contrast(selected, nav.indicatorColor!), greaterThanOrEqualTo(3.0), reason: 'selected icon on indicator');
        expect(PosColors.contrast(unselected, nav.backgroundColor!), greaterThanOrEqualTo(4.5), reason: 'unselected icon on bar');
        final label = nav.labelTextStyle!.resolve({WidgetState.selected})!.color!;
        expect(PosColors.contrast(label, nav.backgroundColor!), greaterThanOrEqualTo(4.5), reason: 'selected label on bar');
      });

      testWidgets('$name: progress bars use brand colours', (tester) async {
        final theme = build();
        final p = theme.progressIndicatorTheme;
        expect(p.color, theme.colorScheme.primary);
        expect(p.linearTrackColor, theme.colorScheme.primaryContainer);
      });
    }
  });
}
