import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
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
          SizedBox(
            width: buttonSize * 0.75,
            child: Text(
              '$quantity',
              style: large ? AppTextStyles.subtitle : AppTextStyles.bodyStrong,
              textAlign: TextAlign.center,
            ),
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
