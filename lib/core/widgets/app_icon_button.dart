import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';

/// The smallest area a finger can reliably tap: 48 dp, Android's minimum
/// (Apple asks for 44 pt). Buttons that look smaller keep their look and take
/// this much room, with the rest a clear margin that still takes the tap.
abstract final class TapTarget {
  static const double min = 48;

  /// The clear margin around an [AppIconButton] of the default size, for
  /// layouts that keep such buttons where they would sit without it.
  static const double iconButtonMargin = (min - AppIconButton.defaultSize) / 2;

  /// The clear margin around a control that looks [size] big.
  static double marginFor(double size) => math.max(0, (min - size) / 2);
}

/// The look of the [AppIconButton]s below it: a brand-colour header gives its
/// buttons a frosted white circle and white icons.
class AppIconButtonStyle extends InheritedWidget {
  const AppIconButtonStyle({
    super.key,
    required this.fill,
    required this.icon,
    this.border,
    required super.child,
  });

  /// Translucent white on a brand's colour.
  const AppIconButtonStyle.frosted({super.key, required super.child})
    : fill = const Color(0x2EFFFFFF),
      icon = const Color(0xFFFFFFFF),
      border = const Color(0x40FFFFFF);

  final Color fill;
  final Color icon;
  final Color? border;

  static AppIconButtonStyle? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppIconButtonStyle>();

  @override
  bool updateShouldNotify(AppIconButtonStyle old) =>
      fill != old.fill || icon != old.icon || border != old.border;
}

/// Round icon button on a white surface, used in screen headers and over
/// photos, or in an [AppIconButtonStyle]'s look. It looks [size] big and takes
/// taps in [TapTarget.min], so a layout that lines it up with something else
/// offsets it by [TapTarget.marginFor].
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.semanticLabel,
    this.iconColor,
    this.size = defaultSize,
  });

  static const double defaultSize = 40;

  final IconData icon;
  final VoidCallback onPressed;
  final String semanticLabel;

  /// The theme's primary text colour when null.
  final Color? iconColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    final style = AppIconButtonStyle.maybeOf(context);
    final border = style == null ? context.colors.border : style.border;
    return Semantics(
      button: true,
      label: semanticLabel,
      child: Material(
        type: MaterialType.transparency,
        child: InkResponse(
          onTap: onPressed,
          // The ripple fills the visible circle only.
          radius: size / 2,
          child: SizedBox.square(
            dimension: math.max(size, TapTarget.min),
            child: Center(
              // Painted on the Material, so the ripple shows above it.
              child: Ink(
                width: size,
                height: size,
                decoration: ShapeDecoration(
                  color: style?.fill ?? context.colors.surface,
                  shape: CircleBorder(
                    side: border == null
                        ? BorderSide.none
                        : BorderSide(color: border),
                  ),
                ),
                child: Icon(
                  icon,
                  size: size * 0.55,
                  color: iconColor ?? style?.icon ?? context.colors.textPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
