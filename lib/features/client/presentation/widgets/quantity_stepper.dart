import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_motion.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';

/// Round icon button: filled for "add", outlined for "remove". A null [onTap]
/// renders it disabled.
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
    final enabled = onTap != null;
    final background = filled
        ? (enabled ? AppColors.primary : AppColors.border)
        : Colors.transparent;
    final foreground = filled
        ? AppColors.onPrimary
        : (enabled ? AppColors.primary : AppColors.textDisabled);

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
          color: background,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: SizedBox.square(
              dimension: size,
              child: Icon(icon, size: size * 0.6, color: foreground),
            ),
          ),
        ),
      ),
    );
  }
}

/// "− quantity +" pill. A null [onDecrement] disables the minus button.
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
  final double buttonSize;

  @override
  Widget build(BuildContext context) {
    final large = buttonSize >= 40;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.accentSoft,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
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
            width: buttonSize * 0.75,
            style: large ? AppTextStyles.subtitle : AppTextStyles.bodyStrong,
          ),
          RoundIconButton(
            icon: Icons.add_rounded,
            semanticLabel: incrementLabel,
            onTap: onIncrement,
            size: buttonSize,
          ),
        ],
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
