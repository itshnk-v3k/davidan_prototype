// Contrast of the colour pairings the screens use, in both themes, against
// WCAG AA: 4.5:1 for text, 3:1 for icons and the shapes of controls.
//   flutter test --platform chrome
import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/quantity_stepper.dart';

double contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

void main() {
  for (final (name, colors) in [
    ('dark', AppColors.dark),
    ('light', AppColors.light),
  ]) {
    group('$name theme', () {
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

      test('the hub\'s brand bubbles: names 4.5:1 on the caramel band, and '
          'an icon, or the bubble against the band, 3:1', () {
        expect(
          contrast(colors.onHubBand, colors.hubBand),
          greaterThanOrEqualTo(4.5),
          reason: 'brand name on the band',
        );
        expect(
          contrast(colors.hubBand, colors.hubBubble),
          greaterThanOrEqualTo(3),
          reason: 'icon on a bubble',
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
}
