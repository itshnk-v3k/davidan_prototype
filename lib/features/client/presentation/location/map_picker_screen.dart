import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/location/location_result.dart';
import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/utils/distance.dart';
import 'package:davidan_prototype/core/widgets/app_button.dart';
import 'package:davidan_prototype/core/widgets/app_chip.dart';
import 'package:davidan_prototype/core/widgets/detail_row.dart';
import 'package:davidan_prototype/core/widgets/info_note.dart';
import 'package:davidan_prototype/core/widgets/screen_header.dart';
import 'package:davidan_prototype/data/mock/mock_sectors.dart';
import 'package:davidan_prototype/data/models/chisinau_sector.dart';
import 'package:davidan_prototype/data/models/geo_point.dart';
import 'package:davidan_prototype/features/client/application/account_notifier.dart';
import 'package:davidan_prototype/features/client/application/catalog_providers.dart';
import 'package:davidan_prototype/features/client/application/current_location_notifier.dart';
import 'package:davidan_prototype/features/client/application/nearby.dart';
import 'package:davidan_prototype/features/client/presentation/location/widgets/chisinau_map.dart';

/// The fallback for "Folosește locația mea curentă" when the phone's location
/// isn't available: says why, then lets the customer place the delivery point
/// on a schematic map or pick a sector. Like a GPS location, the point is for
/// the next order only.
class MapPickerScreen extends ConsumerStatefulWidget {
  const MapPickerScreen({super.key, this.failure});

  /// Why the location lookup failed; null when opened directly.
  final LocationFailure? failure;

  @override
  ConsumerState<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends ConsumerState<MapPickerScreen> {
  /// The point on screen, until the customer confirms it. Starts at an
  /// earlier pinned point, the account's sector, or the city centre.
  late GeoPoint _point =
      ref.read(currentLocationProvider).pinned?.point ??
      sectorCentres[ref.read(accountProvider)?.sector ??
          ChisinauSector.centru]!;

  @override
  Widget build(BuildContext context) {
    final locations = ref.watch(locationsProvider);
    final nearest = nearestLocation(_point, locations);
    final failure = widget.failure;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(
              title: AppStrings.mapPickerTitle,
              onBack: () => context.canPop()
                  ? context.pop()
                  : context.go(Routes.clientLocation),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.gutter,
                  0,
                  AppSpacing.gutter,
                  AppSpacing.xl,
                ),
                children: [
                  if (failure != null) ...[
                    InfoNote(
                      icon: Icons.location_off_rounded,
                      text: AppStrings.locationFailure(failure),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  const Text(
                    AppStrings.mapPickerHint,
                    style: AppTextStyles.bodySecondary,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ChisinauMap(
                    point: _point,
                    locations: locations,
                    onPointChanged: (point) => setState(() => _point = point),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      for (final MapEntry(key: sector, value: centre)
                          in sectorCentres.entries)
                        AppChip(
                          label: AppStrings.sectorName(sector),
                          selected: centre == _point,
                          onTap: () => setState(() => _point = centre),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  DetailRow(
                    icon: Icons.place_rounded,
                    label: AppStrings.chosenPoint,
                    value:
                        '${AppStrings.areaName(sectorAt(_point))} · '
                        '${AppStrings.distanceToShop(formatDistance(nearest.meters), nearest.location.name)}',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 32,
                      top: AppSpacing.xxs,
                    ),
                    child: Text(
                      formatCoordinates(_point),
                      style: AppTextStyles.caption,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.gutter),
          child: AppButton(
            label: AppStrings.deliverHere,
            onPressed: () {
              ref.read(currentLocationProvider.notifier).pinOnMap(_point);
              context.go(Routes.clientHome);
            },
          ),
        ),
      ),
    );
  }
}
