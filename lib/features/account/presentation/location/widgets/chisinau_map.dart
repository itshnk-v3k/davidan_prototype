import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/data/mock/mock_sectors.dart';
import 'package:davidan_prototype/data/models/chisinau_sector.dart';
import 'package:davidan_prototype/data/models/geo_point.dart';
import 'package:davidan_prototype/data/models/store_location.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// A schematic, offline map of Chișinău for placing a delivery point by hand
/// when the phone's location isn't available: the five sectors, the DaviDan
/// shops and a pin. Not a real map: no streets, tiles or network. Tapping
/// moves the pin.
class ChisinauMap extends StatelessWidget {
  const ChisinauMap({
    super.key,
    required this.point,
    required this.locations,
    required this.onPointChanged,
  });

  final GeoPoint point;
  final List<StoreLocation> locations;
  final ValueChanged<GeoPoint> onPointChanged;

  // The area shown, in degrees: the five sectors with a margin, about 15.6 km
  // wide and 15 km tall, hence the aspect ratio.
  static const _north = 47.085;
  static const _south = 46.950;
  static const _west = 28.740;
  static const _east = 28.945;
  static const _aspectRatio = 1.04;

  static const _pinSize = 40.0;
  static const _shopPinSize = 28.0;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: context.l10n.schematicMap,
      child: ExcludeSemantics(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          child: AspectRatio(
            aspectRatio: _aspectRatio,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = constraints.biggest;
                Offset toOffset(GeoPoint point) => Offset(
                  (point.longitude - _west) / (_east - _west) * size.width,
                  (_north - point.latitude) / (_north - _south) * size.height,
                );
                GeoPoint toPoint(Offset offset) => GeoPoint(
                  _north -
                      (offset.dy / size.height).clamp(0.0, 1.0) *
                          (_north - _south),
                  _west +
                      (offset.dx / size.width).clamp(0.0, 1.0) *
                          (_east - _west),
                );
                final pin = toOffset(point);

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp: (details) =>
                      onPointChanged(toPoint(details.localPosition)),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _MapPainter(
                            colors: context.colors,
                            cityCentre: toOffset(
                              sectorCentres[ChisinauSector.centru]!,
                            ),
                            areas: [
                              for (final centre in sectorCentres.values)
                                toOffset(centre),
                            ],
                            radius: size.width * 0.15,
                          ),
                        ),
                      ),
                      for (final MapEntry(key: sector, value: centre)
                          in sectorCentres.entries)
                        Positioned(
                          left: toOffset(centre).dx - 50,
                          top: toOffset(centre).dy + AppSpacing.md,
                          width: 100,
                          child: Text(
                            context.l10n.sectorName(sector),
                            textAlign: TextAlign.center,
                            style: context.textStyles.label.copyWith(
                              color: context.colors.textSecondary,
                            ),
                          ),
                        ),
                      for (final location in locations)
                        Positioned(
                          left:
                              toOffset(location.position).dx - _shopPinSize / 2,
                          top:
                              toOffset(location.position).dy - _shopPinSize / 2,
                          width: _shopPinSize,
                          height: _shopPinSize,
                          child: const _ShopPin(),
                        ),
                      // The tip of the pin marks the point.
                      Positioned(
                        left: pin.dx - _pinSize / 2,
                        top: pin.dy - _pinSize,
                        width: _pinSize,
                        height: _pinSize,
                        child: Icon(
                          Icons.location_on_rounded,
                          size: _pinSize,
                          color: context.colors.primary,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Sector areas as soft circles, joined to the centre by avenue-like lines.
class _MapPainter extends CustomPainter {
  const _MapPainter({
    required this.colors,
    required this.cityCentre,
    required this.areas,
    required this.radius,
  });

  /// A painter has no BuildContext, so the widget passes the theme's colours.
  final AppColors colors;
  final Offset cityCentre;
  final List<Offset> areas;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = colors.surfaceMuted);
    final area = Paint()..color = colors.accentSoft.withValues(alpha: 0.7);
    for (final centre in areas) {
      canvas.drawCircle(centre, radius, area);
    }
    final avenue = Paint()
      ..color = colors.surface
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    for (final centre in areas) {
      canvas.drawLine(cityCentre, centre, avenue);
    }
  }

  @override
  bool shouldRepaint(_MapPainter oldDelegate) =>
      oldDelegate.colors != colors ||
      oldDelegate.cityCentre != cityCentre ||
      oldDelegate.radius != radius ||
      !listEquals(oldDelegate.areas, areas);
}

class _ShopPin extends StatelessWidget {
  const _ShopPin();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: context.colors.primary, width: 2),
      ),
      child: Icon(
        Icons.storefront_rounded,
        size: 16,
        color: context.colors.primary,
      ),
    );
  }
}
