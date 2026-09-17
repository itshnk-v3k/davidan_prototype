import 'dart:ui' show ImageFilter;

import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';

/// Liquid glass, the frosted material iOS floats its bars and buttons on: what
/// is behind it strongly blurred and its colours lifted, a thin tint of the
/// theme's surface (or of a brand's colour, [tint]) and a little light
/// pooling along the top. Small pieces (a notice, the buttons pinned over a
/// photo) add a faint [rim] to hold their shape; the large floating bars (the
/// tab bar, a brand's header) leave it off, so the glass alone defines their
/// edges.
///
/// Tinted glass carries white icons, so it also dims what's behind it: the
/// content still reads through as blurred colour, but white stays clear over a
/// white card or a bright photo.
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
    this.rim = true,
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

  /// A soft shadow under it, for a piece floating well above the page.
  final bool shadow;

  /// A faint rim of light round the edge.
  final bool rim;

  static const sigma = 30.0;

  /// The height the floating glass bars share, the tab bar and a brand's
  /// header, so the two read as a pair.
  static const barHeight = 58.0;

  /// The floating bars' corners.
  static const barRadius = 16.0;

  /// How much more colourful the blurred content turns, which makes the glass
  /// look lit rather than grey.
  static const _saturation = 1.9;

  /// The backdrop, blurred and saturated, then kept as it is (light glass),
  /// dimmed a little (dark glass) or dimmed well down (tinted glass under
  /// white icons).
  static final _clear = _filterFor(1);
  static final _dimmed = _filterFor(0.82);
  static final _deep = _filterFor(0.6);

  static ImageFilter _filterFor(double brightness) => ImageFilter.compose(
    outer: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
    inner: _saturate(_saturation, brightness),
  );

  /// Saturates by [s], then scales the brightness by [k].
  static ColorFilter _saturate(double s, double k) {
    const r = 0.2126, g = 0.7152, b = 0.0722;
    final i = 1 - s;
    return ColorFilter.matrix([
      (r * i + s) * k, g * i * k, b * i * k, 0, 0, //
      r * i * k, (g * i + s) * k, b * i * k, 0, 0, //
      r * i * k, g * i * k, (b * i + s) * k, 0, 0, //
      0, 0, 0, 1, 0, //
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final custom = tint;
    final darkTheme = Theme.of(context).brightness == Brightness.dark;
    // Glass tinted with a deep colour catches light like the dark theme's.
    final dark = custom != null || darkTheme;
    final base = custom ?? colors.surface;
    // Tinted glass is as clear as the theme's: only its colour differs.
    final opacity = tintOpacity ?? (darkTheme ? 0.5 : 0.55);
    // Without a blur behind it, the tint alone has to hide the content.
    final fill = base.withValues(
      alpha: blur ? opacity : (opacity + 0.25).clamp(0, 1),
    );

    Widget glass = CustomPaint(
      foregroundPainter: rim
          ? _RimPainter(borderRadius: borderRadius, dark: dark)
          : null,
      child: DecoratedBox(
        decoration: BoxDecoration(color: fill, borderRadius: borderRadius),
        child: DecoratedBox(
          // Light pooling along the top of the glass.
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withValues(alpha: dark ? 0.08 : 0.28),
                Colors.white.withValues(alpha: dark ? 0.02 : 0.05),
                Colors.white.withValues(alpha: 0),
              ],
              stops: const [0, 0.45, 1],
            ),
          ),
          child: child,
        ),
      ),
    );
    if (blur) {
      glass = BackdropFilter(
        filter: custom != null
            ? _deep
            : darkTheme
            ? _dimmed
            : _clear,
        child: glass,
      );
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

/// The glass's rim: a quiet catch of light at the upper left, gone along the
/// middle and barely there at the lower right.
class _RimPainter extends CustomPainter {
  const _RimPainter({required this.borderRadius, required this.dark});

  final BorderRadius borderRadius;
  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: dark ? 0.22 : 0.6),
          Colors.white.withValues(alpha: dark ? 0.03 : 0.12),
          Colors.white.withValues(alpha: dark ? 0.08 : 0.3),
        ],
        stops: const [0, 0.5, 1],
      ).createShader(rect);
    canvas.drawRRect(borderRadius.toRRect(rect).deflate(0.5), paint);
  }

  @override
  bool shouldRepaint(_RimPainter old) =>
      old.borderRadius != borderRadius || old.dark != dark;
}
