import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';

/// Add/remove button: solid caramel when [filled] ("add"), a caramel tint
/// otherwise ("remove"). It ticks on phones that support haptics. A null
/// [onTap] renders it disabled. It looks [size] big and takes taps in
/// [TapTarget.min].
///
/// A [circle] on its own — the "+" on a card, as the delivery apps the client
/// picked out draw it — and a softly rounded square inside a
/// [QuantityStepper]'s pill, where round buttons in a round track would read
/// as three circles in a row.
class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    required this.icon,
    required this.semanticLabel,
    required this.onTap,
    this.filled = true,
    this.size = 32,
    this.circle = false,
  });

  final IconData icon;
  final String semanticLabel;
  final VoidCallback? onTap;
  final bool filled;
  final double size;

  /// Round rather than a rounded square; see the class doc.
  final bool circle;

  /// Moderately rounded: soft, but clearly a square.
  static double cornerRadiusFor(double size) => size * 0.3;

  /// The corners this button is actually drawn with.
  double get _radius => circle ? size / 2 : cornerRadiusFor(size);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final onTap = this.onTap;
    final enabled = onTap != null;
    final (background, foreground) = switch ((filled, enabled)) {
      (true, true) => (colors.primary, colors.onPrimary),
      (false, true) => (
        QuantityStepper.paletteFor(colors).tonal,
        colors.primary,
      ),
      (true, false) => (colors.border, colors.textDisabled),
      (false, false) => (Colors.transparent, colors.textDisabled),
    };

    return Semantics(
      button: true,
      enabled: enabled,
      label: semanticLabel,
      // A disabled InkWell ignores taps, so they would reach a tappable card
      // underneath (a cart line opens its product). Swallow them instead.
      child: GestureDetector(
        onTap: enabled ? null : () {},
        excludeFromSemantics: true,
        child: Material(
          type: MaterialType.transparency,
          child: InkResponse(
            onTap: onTap == null
                ? null
                : () {
                    HapticFeedback.selectionClick();
                    onTap();
                  },
            // The ripple fills the visible square only.
            radius: size / 2,
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_radius),
            ),
            child: SizedBox.square(
              dimension: math.max(size, TapTarget.min),
              child: Center(
                // Painted on the Material, so the ripple shows above it.
                child: Ink(
                  width: size,
                  height: size,
                  decoration: ShapeDecoration(
                    color: background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_radius),
                    ),
                    shadows: filled && enabled
                        ? [
                            BoxShadow(
                              color: colors.shadow,
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(icon, size: size * 0.62, color: foreground),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// "− quantity +" in one rounded track: both buttons sit inset in it, the
/// minus on a caramel tint and the plus in solid caramel. A null
/// [onDecrement] disables the minus button.
class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.incrementLabel,
    required this.decrementLabel,
    this.buttonSize = 32,
    this.raised = false,
  });

  final int quantity;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final String incrementLabel;
  final String decrementLabel;

  /// The stepper is this plus twice [inset] tall.
  final double buttonSize;

  /// Casts a shadow, for a stepper over a photo.
  final bool raised;

  /// Space between the track's edge and its buttons, as they look. A card's
  /// add button keeps the same space around it, so the stepper's plus appears
  /// exactly where the add button was.
  static const inset = 3.0;

  /// How far the stepper's tap area reaches past its pill on each side, left
  /// and right (the pill is [buttonSize] plus twice [inset] tall; the stepper
  /// is at least [TapTarget.min]).
  static double outsetFor(double buttonSize) =>
      TapTarget.marginFor(buttonSize) - inset;

  /// The count column's width, as a share of [buttonSize]: as wide as a
  /// button, so the stepper reads as three even cells and a two-digit count
  /// — anything from 10 up to the 99 a product page allows — keeps clear air
  /// on either side. At 0.8 the column was 22 dp on a card for a 19 dp "99",
  /// which crowded it at the normal text size and overran it a step above.
  static const _countShare = 1.0;

  /// How wide a stepper with [buttonSize] buttons is laid out: both buttons
  /// take taps in [TapTarget.min], which on a card is far wider than they
  /// look, so this is wider than the pill drawn inside it.
  static double widthFor(double buttonSize) =>
      2 * math.max(buttonSize, TapTarget.min) +
      buttonSize * _countShare -
      2 * TapTarget.marginFor(buttonSize);

  /// The pill as it looks, inside [widthFor]. This, not [widthFor], is what a
  /// layout beside a stepper has to keep clear: the rest is the buttons'
  /// clear tap margins ([outsetFor]), which may reach over whatever sits next
  /// to it.
  static double pillWidthFor(double buttonSize) =>
      widthFor(buttonSize) - 2 * outsetFor(buttonSize);

  /// Share of caramel in the minus button's tint.
  static const _tintShare = 0.16;

  /// The track and the minus button's tint in [colors]' theme, both opaque, so
  /// the contrast test checks the colours actually drawn.
  static ({Color track, Color tonal}) paletteFor(AppColors colors) => (
    track: colors.surfaceMuted,
    tonal: Color.alphaBlend(
      colors.primary.withValues(alpha: _tintShare),
      colors.surfaceMuted,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final large = buttonSize >= 40;
    final numberStyle =
        (large ? context.textStyles.subtitle : context.textStyles.bodyStrong)
            .copyWith(
              fontWeight: FontWeight.w700,
              fontFeatures: const [FontFeature.tabularFigures()],
            );

    // The buttons take taps in TapTarget.min, more than they show. Their clear
    // margins overlap the pill's ends and the number, so the pill is drawn
    // behind them at the size it looks, and the number on top lets taps
    // through.
    final margin = TapTarget.marginFor(buttonSize);
    final countWidth = buttonSize * _countShare;
    final pillInset = outsetFor(buttonSize);

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: pillInset,
          right: pillInset,
          child: Container(
            height: buttonSize + 2 * inset,
            decoration: BoxDecoration(
              color: paletteFor(context.colors).track,
              // The buttons' corners, plus the inset around them.
              borderRadius: BorderRadius.circular(
                RoundIconButton.cornerRadiusFor(buttonSize) + inset,
              ),
              boxShadow: raised
                  ? [
                      BoxShadow(
                        color: context.colors.shadow,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RoundIconButton(
              icon: PhosphorIconsBold.minus,
              filled: false,
              semanticLabel: decrementLabel,
              onTap: onDecrement,
              size: buttonSize,
            ),
            SizedBox(width: countWidth - 2 * margin),
            RoundIconButton(
              icon: PhosphorIconsBold.plus,
              semanticLabel: incrementLabel,
              onTap: onIncrement,
              size: buttonSize,
            ),
          ],
        ),
        IgnorePointer(
          child: SizedBox(
            width: countWidth,
            child: Text(
              '$quantity',
              style: numberStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
