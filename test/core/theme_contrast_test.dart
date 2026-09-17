// Contrast of the colour pairings the screens use, in both themes, against
// WCAG AA: 4.5:1 for text, 3:1 for icons and the shapes of controls.
//   flutter test --platform chrome
import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_palette.dart';
import 'package:davidan_prototype/core/theme/brand_colors.dart';
import 'package:davidan_prototype/core/widgets/info_note.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/quantity_stepper.dart';
import 'package:davidan_prototype/features/hub/presentation/widgets/brand_switcher_row.dart';

double contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

void main() {
  // DaviDan's own sets, then each brand's (the same set with its accent).
  for (final (name, colors) in [
    ('dark theme', AppColors.dark),
    ('light theme', AppColors.light),
    for (final brand in Brand.values)
      for (final brightness in Brightness.values)
        (
          '${brand.name} in the ${brightness.name} theme',
          BrandColors.of(brand, brightness),
        ),
  ]) {
    group(name, () {
      test('text is at least 4.5:1 on every surface', () {
        for (final (textName, text) in [
          ('textPrimary', colors.textPrimary),
          ('textSecondary', colors.textSecondary),
          ('primary', colors.primary),
          ('error', colors.error),
          ('warning', colors.warning),
        ]) {
          for (final (surfaceName, surface) in [
            ('background', colors.background),
            ('surface', colors.surface),
            ('surfaceMuted', colors.surfaceMuted),
          ]) {
            expect(
              contrast(text, surface),
              greaterThanOrEqualTo(4.5),
              reason: '$textName on $surfaceName',
            );
          }
        }
        expect(
          contrast(colors.onPrimary, colors.primary),
          greaterThanOrEqualTo(4.5),
          reason: 'onPrimary on primary',
        );
        expect(
          contrast(colors.textPrimary, colors.accentSoft),
          greaterThanOrEqualTo(4.5),
          reason: 'textPrimary on accentSoft',
        );
      });

      test('an unticked radio button or checkbox is outlined at 3:1 on its '
          'tile', () {
        for (final (surfaceName, surface) in [
          ('surface', colors.surface),
          ('surfaceMuted', colors.surfaceMuted),
        ]) {
          expect(
            contrast(colors.textSecondary, surface),
            greaterThanOrEqualTo(3),
            reason: 'unticked outline on $surfaceName',
          );
        }
      });

      test('icons on the accent tint (link cards, empty states, photo '
          'placeholders) are 3:1', () {
        expect(
          contrast(colors.primary, colors.accentSoft),
          greaterThanOrEqualTo(3),
          reason: 'primary icon on accentSoft',
        );
      });

      test('notes and tags on their neutral fill: text 4.5:1, the brand\'s '
          'icon 3:1', () {
        final fill = InfoNote.fillOf(colors);
        expect(
          contrast(colors.textPrimary, fill),
          greaterThanOrEqualTo(4.5),
          reason: 'text on a note',
        );
        expect(
          contrast(colors.primary, fill),
          greaterThanOrEqualTo(3),
          reason: 'brand icon on a note',
        );
      });

      test('the quantity stepper: its number 4.5:1, its buttons 3:1', () {
        final stepper = QuantityStepper.paletteFor(colors);
        expect(
          contrast(colors.textPrimary, stepper.track),
          greaterThanOrEqualTo(4.5),
          reason: 'number on the track',
        );
        expect(
          contrast(colors.onPrimary, colors.primary),
          greaterThanOrEqualTo(4.5),
          reason: 'plus icon on its fill',
        );
        expect(
          contrast(colors.primary, colors.surface),
          greaterThanOrEqualTo(3),
          reason: 'plus button against a card',
        );
        expect(
          contrast(colors.primary, stepper.tonal),
          greaterThanOrEqualTo(3),
          reason: 'minus icon on its tint',
        );
      });
    });
  }

  // The brand switcher's bubbles, which carry each brand's own colour rather
  // than the theme's.
  for (final brightness in Brightness.values) {
    final colors = brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;
    group('the ${brightness.name} theme\'s brand switcher', () {
      test('every brand\'s name reads on the page, its white logo on its own '
          'bubble, and its bubble against the page', () {
        expect(
          contrast(colors.textSecondary, colors.background),
          greaterThanOrEqualTo(4.5),
          reason: 'a brand\'s name under its bubble',
        );
        for (final brand in Brand.values) {
          final fill = BrandColors.fillOf(brand);
          final marked = BrandColors.of(brand, brightness).primary;
          expect(
            contrast(AppPalette.white, fill),
            greaterThanOrEqualTo(4.5),
            reason: '${brand.name}: its white logo on its bubble',
          );
          // Its edge reads either by its own colour or by the hairline
          // round it, whichever separates from the page.
          const rim = BrandSwitcherRow.bubbleRim;
          expect(
            math.max(
              contrast(fill, colors.background),
              contrast(Color.alphaBlend(rim, fill), colors.background),
            ),
            greaterThanOrEqualTo(3),
            reason: '${brand.name}: its bubble\'s edge against the page',
          );
          expect(
            contrast(marked, colors.background),
            greaterThanOrEqualTo(4.5),
            reason: '${brand.name}: its name and ring when it is the open one',
          );
        }
      });
    });
  }
}
