import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/clock_ticker.dart';
import 'package:davidan_prototype/features/orders/application/order_simulation.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// Pretend map of a delivery on its way: a drawn street grid, the route from
/// the shop to the customer, and a courier icon moving along it. There is no
/// real map, GPS or network. The courier's position is simply the time since
/// the order left the shop, out of [tripDuration].
class CourierRouteMap extends StatelessWidget {
  const CourierRouteMap({super.key, required this.since});

  /// When the courier took the order.
  final DateTime since;

  /// How long the pretend trip takes: short enough to watch during a demo.
  static const tripDuration = courierTripDuration;

  // The pretend neighbourhood, as fractions of the map's width and height.
  // The route follows the streets from the shop (first point) to the
  // customer (last point).
  static const _streetsX = [0.12, 0.30, 0.46, 0.66, 0.84];
  static const _streetsY = [0.30, 0.56, 0.82];
  static const _route = [
    Offset(0.12, 0.82),
    Offset(0.12, 0.56),
    Offset(0.46, 0.56),
    Offset(0.46, 0.30),
    Offset(0.84, 0.30),
    Offset(0.84, 0.14),
  ];

  @override
  Widget build(BuildContext context) {
    return ClockTicker(
      builder: (context, now) {
        final elapsed = now.difference(since);
        final progress = (elapsed.inMilliseconds / tripDuration.inMilliseconds)
            .clamp(0.0, 1.0);
        final remaining = tripDuration - elapsed;
        final arrived = remaining <= Duration.zero;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ExcludeSemantics(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadii.card),
                child: AspectRatio(
                  aspectRatio: 16 / 10,
                  child: LayoutBuilder(
                    builder: (context, constraints) =>
                        _MapView(size: constraints.biggest, progress: progress),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(
                  arrived
                      ? PhosphorIconsFill.checkCircle
                      : PhosphorIconsRegular.clock,
                  size: 18,
                  color: context.colors.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    arrived
                        ? context.l10n.courierArrived
                        : context.l10n.courierArrivesIn(
                            (remaining.inSeconds / 60).ceil().clamp(
                              1,
                              tripDuration.inMinutes,
                            ),
                          ),
                    style: context.textStyles.bodyStrong,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _MapView extends StatelessWidget {
  const _MapView({required this.size, required this.progress});

  final Size size;

  /// Share of the route covered, from 0 to 1.
  final double progress;

  static const _pinSize = 32.0;
  static const _courierSize = 36.0;

  @override
  Widget build(BuildContext context) {
    if (size.isEmpty) return const SizedBox.shrink();

    Offset at(Offset fraction) =>
        Offset(fraction.dx * size.width, fraction.dy * size.height);
    final route = Path()
      ..addPolygon([
        for (final point in CourierRouteMap._route) at(point),
      ], false);
    final metric = route.computeMetrics().first;

    // The clock ticks once a second; the courier glides between ticks instead
    // of jumping.
    return TweenAnimationBuilder<double>(
      tween: Tween(end: progress),
      duration: const Duration(seconds: 1),
      builder: (context, value, _) {
        final courier = metric
            .getTangentForOffset(metric.length * value)!
            .position;
        return Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _MapPainter(
                  colors: context.colors,
                  route: route,
                  progress: value,
                ),
              ),
            ),
            _centeredOn(
              at(CourierRouteMap._route.first),
              _pinSize,
              const _Pin(icon: PhosphorIconsFill.storefront),
            ),
            _centeredOn(
              at(CourierRouteMap._route.last),
              _pinSize,
              const _Pin(icon: PhosphorIconsFill.house),
            ),
            _centeredOn(courier, _courierSize, const _CourierMarker()),
          ],
        );
      },
    );
  }

  static Widget _centeredOn(Offset center, double size, Widget child) =>
      Positioned(
        left: center.dx - size / 2,
        top: center.dy - size / 2,
        width: size,
        height: size,
        child: child,
      );
}

/// Streets, the whole route, and the part the courier has covered.
class _MapPainter extends CustomPainter {
  const _MapPainter({
    required this.colors,
    required this.route,
    required this.progress,
  });

  /// A painter has no BuildContext, so the widget passes the theme's colours.
  final AppColors colors;
  final Path route;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = colors.surfaceMuted);

    final street = Paint()
      ..color = colors.surface
      ..strokeWidth = 12;
    for (final x in CourierRouteMap._streetsX) {
      canvas.drawLine(
        Offset(x * size.width, 0),
        Offset(x * size.width, size.height),
        street,
      );
    }
    for (final y in CourierRouteMap._streetsY) {
      canvas.drawLine(
        Offset(0, y * size.height),
        Offset(size.width, y * size.height),
        street,
      );
    }

    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(route, line..color = colors.accent.withValues(alpha: 0.4));
    final metric = route.computeMetrics().first;
    canvas.drawPath(
      metric.extractPath(0, metric.length * progress),
      line..color = colors.primary,
    );
  }

  @override
  bool shouldRepaint(_MapPainter oldDelegate) =>
      oldDelegate.colors != colors ||
      oldDelegate.progress != progress ||
      oldDelegate.route != route;
}

class _Pin extends StatelessWidget {
  const _Pin({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: context.colors.primary, width: 2),
      ),
      child: Icon(icon, size: 18, color: context.colors.primary),
    );
  }
}

class _CourierMarker extends StatelessWidget {
  const _CourierMarker();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        PhosphorIconsFill.moped,
        size: 20,
        color: context.colors.onPrimary,
      ),
    );
  }
}
