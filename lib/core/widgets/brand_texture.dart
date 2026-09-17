import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/data/models/brand.dart';

/// A brand's own surface: a bright gradient in its colours with a drawn
/// texture (wheat for the bakery, gold lattice for the restaurant, waves for
/// sushi, ripples for water, racing stripes for Rent Car), for the hub's brand
/// tiles. Drawn, not photographed, so it never passes for a product photo.
///
/// With [scrim] (the hub's tiles, where a logo and a name sit on it) a light
/// shade of the brand's own colour settles along the leading side and the
/// bottom, under the logo and the name, while the colour and the pattern
/// stay bright everywhere else.
class BrandSurface extends StatelessWidget {
  const BrandSurface({
    super.key,
    required this.brand,
    this.scrim = false,
    this.texture = true,
    this.child,
  });

  final Brand brand;
  final bool scrim;

  /// False for the plain gradient, where a pattern would crowd small content
  /// like a header's logo and buttons.
  final bool texture;
  final Widget? child;

  /// The gradient's two ends, light to deep: bright and vivid, the
  /// restaurant a warm bronze rather than near-black.
  static (Color, Color) colorsOf(Brand brand) => switch (brand) {
    Brand.bakery => (const Color(0xFFFFB547), const Color(0xFFE8820F)),
    Brand.restaurant => (const Color(0xFF8A5A36), const Color(0xFF4A2B18)),
    Brand.sushi => (const Color(0xFFFF7445), const Color(0xFFF04A22)),
    Brand.water => (const Color(0xFF5AB6FF), const Color(0xFF1E72E6)),
    Brand.carRental => (const Color(0xFF2BCB85), const Color(0xFF0CA36A)),
  };

  /// The darkest tone of the brand's own hue, for [scrim]. Darkening with it
  /// keeps a card warm caramel, red or green; black would turn it muddy.
  static Color shadeOf(Brand brand) => switch (brand) {
    Brand.bakery => const Color(0xFF4A2200),
    Brand.restaurant => const Color(0xFF1A0E07),
    Brand.sushi => const Color(0xFF4F0E02),
    Brand.water => const Color(0xFF03214F),
    Brand.carRental => const Color(0xFF002A1A),
  };

  @override
  Widget build(BuildContext context) {
    final (light, deep) = colorsOf(brand);
    final child = this.child;
    final shade = shadeOf(brand);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [light, deep],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (texture) CustomPaint(painter: _TexturePainter(brand)),
          if (scrim) ...[
            // A light shade on the leading side, under the logo, gone by the
            // trailing edge.
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    shade.withValues(alpha: 0.3),
                    shade.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
            // More along the bottom, under the name.
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    shade.withValues(alpha: 0.5),
                    shade.withValues(alpha: 0),
                  ],
                  stops: const [0, 0.6],
                ),
              ),
            ),
          ],
          ?child,
        ],
      ),
    );
  }
}

class _TexturePainter extends CustomPainter {
  _TexturePainter(this.brand);

  final Brand brand;

  static Paint _stroke(Color color, [double width = 1.5]) => Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    _paintPattern(canvas, size);
  }

  void _paintPattern(Canvas canvas, Size size) {
    switch (brand) {
      case Brand.bakery:
        _wheat(canvas, size);
      case Brand.restaurant:
        _lattice(canvas, size);
      case Brand.sushi:
        _waves(canvas, size);
      case Brand.water:
        _ripples(canvas, size);
      case Brand.carRental:
        _stripes(canvas, size);
    }
  }

  /// Ears of wheat: staggered pairs of slanted grains along short stalks.
  void _wheat(Canvas canvas, Size size) {
    final grain = Paint()..color = const Color(0x33FFFFFF);
    final stalk = _stroke(const Color(0x29FFFFFF), 1.2);
    const step = 56.0;
    for (var row = 0; row * step < size.height + step; row++) {
      for (var col = 0; col * step < size.width + step; col++) {
        final origin = Offset(
          col * step + (row.isEven ? 0 : step / 2),
          row * step,
        );
        canvas
          ..save()
          ..translate(origin.dx, origin.dy)
          ..rotate(-math.pi / 6)
          ..drawLine(const Offset(0, 12), const Offset(0, -12), stalk);
        for (var i = 0; i < 3; i++) {
          final y = -8.0 + i * 6;
          for (final side in [-1.0, 1.0]) {
            canvas
              ..save()
              ..translate(side * 2.6, y)
              ..rotate(side * math.pi / 5)
              ..drawOval(
                Rect.fromCenter(center: Offset.zero, width: 3.2, height: 7),
                grain,
              )
              ..restore();
          }
        }
        canvas.restore();
      }
    }
  }

  /// A fine gold diamond lattice, like a restaurant's wallpaper.
  void _lattice(Canvas canvas, Size size) {
    final gold = _stroke(const Color(0x4DF2C98A), 1);
    const step = 26.0;
    for (var x = -size.height; x < size.width + size.height; x += step) {
      canvas
        ..drawLine(Offset(x, 0), Offset(x + size.height, size.height), gold)
        ..drawLine(Offset(x + size.height, 0), Offset(x, size.height), gold);
    }
    final dot = Paint()..color = const Color(0x73F2C98A);
    for (var y = 0.0; y < size.height + step; y += step) {
      for (var x = 0.0; x < size.width + step; x += step) {
        canvas.drawCircle(Offset(x, y), 1.3, dot);
      }
    }
  }

  /// Seigaiha on vermilion: rows of overlapping half-circle arcs.
  void _waves(Canvas canvas, Size size) {
    const radius = 20.0;
    final crest = _stroke(const Color(0x4DFFFFFF), 1.4);
    final faint = _stroke(const Color(0x2EFFFFFF), 1);
    for (var row = 0; row * radius / 2 < size.height + radius; row++) {
      final dy = row * radius / 2;
      final offset = row.isEven ? 0.0 : radius;
      for (
        var dx = offset - radius;
        dx < size.width + radius;
        dx += radius * 2
      ) {
        for (final (index, r) in [
          radius,
          radius * 0.66,
          radius * 0.33,
        ].indexed) {
          canvas.drawArc(
            Rect.fromCircle(center: Offset(dx, dy), radius: r),
            math.pi,
            math.pi,
            false,
            index == 0 ? crest : faint,
          );
        }
      }
    }
  }

  /// Water: soft rings and ripples.
  void _ripples(Canvas canvas, Size size) {
    final ink = _stroke(const Color(0x33FFFFFF), 1.4);
    const gap = 14.0;
    const wave = 48.0;
    for (var dy = gap / 2; dy < size.height + gap; dy += gap) {
      final path = Path()..moveTo(0, dy);
      for (var x = 0.0; x <= size.width; x += 4) {
        path.lineTo(x, dy + math.sin((x + dy * 1.7) / wave * 2 * math.pi) * 3);
      }
      canvas.drawPath(path, ink);
    }
    final ring = _stroke(const Color(0x40FFFFFF), 1.6);
    final center = Offset(size.width * 0.82, size.height * 0.35);
    for (var r = 14.0; r < 70; r += 16) {
      canvas.drawCircle(center, r, ring);
    }
  }

  /// Racing stripes: two bold light bands and a thin white one, diagonal, on
  /// the trailing side.
  void _stripes(Canvas canvas, Size size) {
    // Drawn for a wide card; narrower on a small tile.
    final k = math.min(1.0, size.width / 200);
    final start = size.width * 0.5;
    void band(double offset, double width, Color color) {
      offset *= k;
      width *= k;
      final path = Path()
        ..moveTo(start + offset, size.height)
        ..lineTo(start + offset + size.height * 0.6, 0)
        ..lineTo(start + offset + width + size.height * 0.6, 0)
        ..lineTo(start + offset + width, size.height)
        ..close();
      canvas.drawPath(path, Paint()..color = color);
    }

    band(0, 22, const Color(0x40FFFFFF));
    band(30, 5, const Color(0x99FFFFFF));
    band(43, 22, const Color(0x40FFFFFF));
    final lane = _stroke(const Color(0x24FFFFFF), 1);
    for (var y = 10.0; y < size.height; y += 12) {
      canvas.drawLine(Offset(0, y), Offset(size.width * 0.5, y), lane);
    }
  }

  @override
  bool shouldRepaint(_TexturePainter old) => old.brand != brand;
}
