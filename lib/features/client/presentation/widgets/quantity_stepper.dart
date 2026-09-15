import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_motion.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/press_scale.dart';

/// Round icon button: solid caramel when [filled] ("add"), a caramel tint
/// otherwise ("remove"). It shrinks while pressed and ticks on phones that
/// support haptics. A null [onTap] renders it disabled.
class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    required this.icon,
    required this.semanticLabel,
    required this.onTap,
    this.filled = true,
    this.size = 32,
  });

  final IconData icon;
  final String semanticLabel;
  final VoidCallback? onTap;
  final bool filled;
  final double size;

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
        child: PressScale(
          scale: AppMotion.pressedScaleButton,
          builder: (onHighlightChanged) => DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: filled && enabled
                  ? [
                      BoxShadow(
                        color: colors.shadow,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Material(
              color: background,
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onTap == null
                    ? null
                    : () {
                        HapticFeedback.selectionClick();
                        onTap();
                      },
                onHighlightChanged: onHighlightChanged,
                child: SizedBox.square(
                  dimension: size,
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

/// "− quantity +" in one pill: both buttons sit inset in a muted track, the
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
  });

  final int quantity;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final String incrementLabel;
  final String decrementLabel;

  /// The stepper is this plus twice [inset] tall.
  final double buttonSize;

  /// Space between the track's edge and its buttons. A card's add button
  /// keeps the same space around it, so the stepper's plus appears exactly
  /// where the add button was.
  static const inset = 3.0;

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

    return DecoratedBox(
      decoration: BoxDecoration(
        color: paletteFor(context.colors).track,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.all(inset),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RoundIconButton(
              icon: Icons.remove_rounded,
              filled: false,
              semanticLabel: decrementLabel,
              onTap: onDecrement,
              size: buttonSize,
            ),
            _RollingCount(
              quantity: quantity,
              width: buttonSize * 0.8,
              style: numberStyle,
            ),
            RoundIconButton(
              icon: Icons.add_rounded,
              semanticLabel: incrementLabel,
              onTap: onIncrement,
              size: buttonSize,
            ),
          ],
        ),
      ),
    );
  }
}

/// The stepper's number. Like a counter, a higher number rolls in from below
/// and a lower one from above, while the old number leaves the other way.
class _RollingCount extends StatefulWidget {
  const _RollingCount({
    required this.quantity,
    required this.width,
    required this.style,
  });

  final int quantity;
  final double width;
  final TextStyle style;

  @override
  State<_RollingCount> createState() => _RollingCountState();
}

class _RollingCountState extends State<_RollingCount> {
  /// 1 after counting up, -1 after counting down.
  double _direction = 1;

  @override
  void didUpdateWidget(_RollingCount oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.quantity != oldWidget.quantity) {
      _direction = widget.quantity > oldWidget.quantity ? 1 : -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: ClipRect(
        child: AnimatedSwitcher(
          duration: AppMotion.of(context, AppMotion.fast),
          switchInCurve: AppMotion.standard,
          switchOutCurve: AppMotion.standard,
          // Rebuilt on every change, so the leaving number also picks up the
          // current direction.
          transitionBuilder: (child, animation) {
            final incoming = child.key == ValueKey(widget.quantity);
            final slide = Tween(
              begin: Offset(0, (incoming ? 0.6 : -0.6) * _direction),
              end: Offset.zero,
            );
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: slide.animate(animation),
                child: child,
              ),
            );
          },
          child: Text(
            '${widget.quantity}',
            key: ValueKey(widget.quantity),
            style: widget.style,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
