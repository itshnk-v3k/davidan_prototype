import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/widgets/glass_surface.dart';

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

/// The look of the [AppIconButton]s below it: a brand's header gives its
/// buttons white icons on clear glass over its colour, and buttons floating
/// over a photo take the frosted glass of [GlassSurface].
class AppIconButtonStyle extends InheritedWidget {
  const AppIconButtonStyle({
    super.key,
    required this.fill,
    required this.icon,
    this.border,
    required super.child,
  }) : glass = false,
       blur = false;

  /// White icons on a clear glass circle with a bright rim, over a brand's
  /// colour.
  const AppIconButtonStyle.overlay({super.key, required super.child})
    : fill = const Color(0x29FFFFFF),
      icon = const Color(0xFFFFFFFF),
      border = const Color(0x40FFFFFF),
      glass = false,
      blur = false;

  /// The theme's icons on frosted glass ([GlassSurface]), for a button
  /// floating over a photo or the page. With [blur] the glass blurs what is
  /// behind it; leave it off for buttons repeated in a scrolling list.
  const AppIconButtonStyle.glass({
    super.key,
    this.blur = false,
    required super.child,
  }) : fill = null,
       icon = null,
       border = null,
       glass = true;

  final Color? fill;
  final Color? icon;
  final Color? border;
  final bool glass;
  final bool blur;

  static AppIconButtonStyle? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppIconButtonStyle>();

  @override
  bool updateShouldNotify(AppIconButtonStyle old) =>
      fill != old.fill ||
      icon != old.icon ||
      border != old.border ||
      glass != old.glass ||
      blur != old.blur;
}

/// Round icon button on a soft tonal circle with no outline, used in screen
/// headers and over photos, or in an [AppIconButtonStyle]'s look. It looks
/// [size] big and takes taps in [TapTarget.min], so a layout that lines it up
/// with something else offsets it by [TapTarget.marginFor].
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
    final border = style?.border;
    final glyph = Icon(
      icon,
      size: size * 0.55,
      color: iconColor ?? style?.icon ?? context.colors.textPrimary,
    );
    final target = math.max(size, TapTarget.min);
    if (style != null && style.glass) {
      final circle = BorderRadius.circular(size / 2);
      return Semantics(
        button: true,
        label: semanticLabel,
        // The clear margin around the circle takes the tap too.
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onPressed,
          child: SizedBox.square(
            dimension: target,
            child: Center(
              child: SizedBox.square(
                dimension: size,
                child: GlassSurface(
                  borderRadius: circle,
                  blur: style.blur,
                  // On the glass, so the ripple shows on it and not under it.
                  child: Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      onTap: onPressed,
                      excludeFromSemantics: true,
                      borderRadius: circle,
                      child: Center(child: glyph),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
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
            dimension: target,
            child: Center(
              // Painted on the Material, so the ripple shows above it.
              child: Ink(
                width: size,
                height: size,
                decoration: ShapeDecoration(
                  color: style?.fill ?? context.colors.surfaceMuted,
                  shape: CircleBorder(
                    side: border == null
                        ? BorderSide.none
                        : BorderSide(color: border, width: 0.8),
                  ),
                ),
                child: glyph,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
