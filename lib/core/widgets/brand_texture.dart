import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/data/models/brand.dart';

/// A brand's own surface: a rich gradient in its colours with a drawn texture
/// (wheat for the bakery, gold lattice for the restaurant, red waves on
/// charcoal for sushi, ripples for water, racing stripes on graphite for Rent
/// Car), for the hub's brand cards and each brand's header band. Drawn, not
/// photographed, so it never passes for a product photo. White text and
/// logos read on every one of them; [scrim] darkens the leading side further
/// for text.
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

  /// The gradient's two ends, light to deep.
  static (Color, Color) colorsOf(Brand brand) => switch (brand) {
    Brand.bakery => (const Color(0xFFE9A445), const Color(0xFFA85A16)),
    Brand.restaurant => (const Color(0xFF4A3426), const Color(0xFF1B130F)),
    Brand.sushi => (const Color(0xFF2A2A2F), const Color(0xFF15090B)),
    Brand.water => (const Color(0xFF45A2F7), const Color(0xFF0D52B8)),
    Brand.carRental => (const Color(0xFF2E3036), const Color(0xFF131417)),
  };

  @override
  Widget build(BuildContext context) {
    final (light, deep) = colorsOf(brand);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [light, deep],
        ),
      ),
      child: CustomPaint(
        painter: texture ? _TexturePainter(brand) : null,
        foregroundPainter: scrim ? const _ScrimPainter() : null,
        child: child,
      ),
    );
  }
}

/// Darkens the leading side, where a card's name sits.
class _ScrimPainter extends CustomPainter {
  const _ScrimPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0x59000000), Color(0x00000000)],
          stops: [0, 0.7],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(_ScrimPainter old) => false;
}

class _TexturePainter extends CustomPainter {
  _TexturePainter(this.brand);

  final Brand brand;

  static Paint _stroke(Color color, [double width = 1.5]) => Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round;

  /// How strongly the pattern shows: a quiet texture under the logo and
  /// name, not a pattern competing with them.
  static const _strength = 0.5;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    canvas
      ..clipRect(bounds)
      ..saveLayer(bounds, Paint()..color = Color.fromRGBO(0, 0, 0, _strength));
    _paintPattern(canvas, size);
    canvas.restore();
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
    final grain = Paint()..color = const Color(0x17FFFFFF);
    final stalk = _stroke(const Color(0x12FFFFFF), 1.2);
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
    final gold = _stroke(const Color(0x40D9A45B), 1);
    const step = 26.0;
    for (var x = -size.height; x < size.width + size.height; x += step) {
      canvas
        ..drawLine(Offset(x, 0), Offset(x + size.height, size.height), gold)
        ..drawLine(Offset(x + size.height, 0), Offset(x, size.height), gold);
    }
    final dot = Paint()..color = const Color(0x59D9A45B);
    for (var y = 0.0; y < size.height + step; y += step) {
      for (var x = 0.0; x < size.width + step; x += step) {
        canvas.drawCircle(Offset(x, y), 1.3, dot);
      }
    }
  }

  /// Seigaiha in red on charcoal: rows of overlapping half-circle arcs.
  void _waves(Canvas canvas, Size size) {
    const radius = 20.0;
    final red = _stroke(const Color(0x66EF3B45), 1.4);
    final faint = _stroke(const Color(0x1FFFFFFF), 1);
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
            index == 0 ? red : faint,
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

  /// Racing stripes: two bold red bands and a thin white one, diagonal, on
  /// the trailing side.
  void _stripes(Canvas canvas, Size size) {
    final start = size.width * 0.58;
    void band(double offset, double width, Color color) {
      final path = Path()
        ..moveTo(start + offset, size.height)
        ..lineTo(start + offset + size.height * 0.6, 0)
        ..lineTo(start + offset + width + size.height * 0.6, 0)
        ..lineTo(start + offset + width, size.height)
        ..close();
      canvas.drawPath(path, Paint()..color = color);
    }

    band(0, 22, const Color(0xE6EF3B45));
    band(30, 5, const Color(0xCCFFFFFF));
    band(43, 22, const Color(0xE6EF3B45));
    final lane = _stroke(const Color(0x14FFFFFF), 1);
    for (var y = 10.0; y < size.height; y += 12) {
      canvas.drawLine(Offset(0, y), Offset(size.width * 0.5, y), lane);
    }
  }

  @override
  bool shouldRepaint(_TexturePainter old) => old.brand != brand;
}
