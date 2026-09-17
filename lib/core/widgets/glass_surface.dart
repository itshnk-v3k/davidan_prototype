import 'dart:ui' show ImageFilter;

import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';

/// Liquid glass, the frosted material iOS floats its bars and buttons on: what
/// is behind it blurred and its colours lifted, a thin tint of the theme's
/// surface (or of a brand's colour, [tint]), light catching the top edge and a
/// bright hairline rim. For the app's floating pieces (the tab bar, a notice,
/// the buttons pinned over a photo, a brand's pinned header).
///
/// Each [blur] is a pass over everything behind it, so small pieces repeated
/// in a scrolling list (a card's heart) take the glass look without it.
class GlassSurface extends StatelessWidget {
  const GlassSurface({
    super.key,
    required this.borderRadius,
    required this.child,
    this.blur = true,
    this.tint,
    this.tintOpacity,
    this.shadow = false,
    this.border,
  });

  final BorderRadius borderRadius;
  final Widget child;
  final bool blur;

  /// The colour the glass is tinted with, for glass carrying white content
  /// (a brand's header). The theme's surface when null.
  final Color? tint;

  /// How much of the tint covers the blur: more for a surface carrying text.
  /// The default for the theme, or for [tint], when null.
  final double? tintOpacity;

  /// The rim, where not all four edges show (a header's bottom edge only).
  /// A hairline all round when null.
  final BoxBorder? border;

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
    final custom = tint;
    // Glass tinted with a deep colour catches light like the dark theme's.
    final dark =
        custom != null || Theme.of(context).brightness == Brightness.dark;
    final base = custom ?? colors.surface;
    final opacity =
        tintOpacity ?? (custom != null ? 0.85 : (dark ? 0.55 : 0.62));
    // Without a blur behind it, the tint alone has to hide the content.
    final solidTint = base.withValues(
      alpha: blur ? opacity : (opacity + 0.2).clamp(0, 1),
    );

    // No corners at all for square glass, which also lets a rim on one edge
    // only ([border]) be drawn.
    final corners = borderRadius == BorderRadius.zero ? null : borderRadius;

    Widget glass = DecoratedBox(
      decoration: BoxDecoration(color: solidTint, borderRadius: corners),
      child: DecoratedBox(
        // Light catching the top of the glass.
        decoration: BoxDecoration(
          borderRadius: corners,
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
            borderRadius: corners,
            border:
                border ??
                Border.all(
                  color: Colors.white.withValues(
                    alpha: custom != null ? 0.2 : (dark ? 0.14 : 0.6),
                  ),
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
