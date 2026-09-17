import 'dart:ui' show ImageFilter;

import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';

/// Liquid glass, the frosted material iOS floats its bars and buttons on: what
/// is behind it blurred and its colours lifted, a thin tint of the theme's
/// surface, light catching the top edge and a bright hairline rim. For the
/// app's floating pieces (the tab bar, a notice, the buttons pinned over a
/// photo).
///
/// Each [blur] is a pass over everything behind it, so small pieces repeated
/// in a scrolling list (a card's heart) take the glass look without it.
class GlassSurface extends StatelessWidget {
  const GlassSurface({
    super.key,
    required this.borderRadius,
    required this.child,
    this.blur = true,
    this.tintOpacity,
    this.shadow = false,
  });

  final BorderRadius borderRadius;
  final Widget child;
  final bool blur;

  /// How much of the surface colour covers the blur: more for a surface
  /// carrying text. The theme's default when null.
  final double? tintOpacity;

  /// A soft shadow under it, for a piece floating well above the page.
  final bool shadow;

  static const sigma = 24.0;

  /// How much more colourful the blurred content turns, which makes the glass
  /// look lit rather than grey.
  static const _saturation = 1.8;

  static final _filter = ImageFilter.compose(
    outer: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
    inner: _saturate(_saturation),
  );

  static ColorFilter _saturate(double s) {
    const r = 0.2126, g = 0.7152, b = 0.0722;
    final i = 1 - s;
    return ColorFilter.matrix([
      r * i + s, g * i, b * i, 0, 0, //
      r * i, g * i + s, b * i, 0, 0, //
      r * i, g * i, b * i + s, 0, 0, //
      0, 0, 0, 1, 0, //
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final tint = colors.surface.withValues(
      alpha: tintOpacity ?? (dark ? 0.55 : 0.62),
    );
    // Without a blur behind it, the tint alone has to hide the content.
    final solidTint = blur
        ? tint
        : colors.surface.withValues(alpha: (tint.a + 0.2).clamp(0, 1));

    Widget glass = DecoratedBox(
      decoration: BoxDecoration(color: solidTint, borderRadius: borderRadius),
      child: DecoratedBox(
        // Light catching the top of the glass.
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withValues(alpha: dark ? 0.10 : 0.32),
              Colors.white.withValues(alpha: 0),
            ],
            stops: const [0, 0.55],
          ),
        ),
        child: DecoratedBox(
          position: DecorationPosition.foreground,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: Border.all(
              color: Colors.white.withValues(alpha: dark ? 0.14 : 0.6),
              width: 0.8,
            ),
          ),
          child: child,
        ),
      ),
    );
    if (blur) {
      glass = BackdropFilter(filter: _filter, child: glass);
    }
    glass = ClipRRect(borderRadius: borderRadius, child: glass);
    if (!shadow) return glass;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: colors.cardShadow,
            blurRadius: 30,
            spreadRadius: -6,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: glass,
    );
  }
}
