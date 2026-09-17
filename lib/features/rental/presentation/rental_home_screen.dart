import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/utils/money.dart';
import 'package:davidan_prototype/core/widgets/app_chip.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';
import 'package:davidan_prototype/core/widgets/brand_header_band.dart';
import 'package:davidan_prototype/core/widgets/info_note.dart';
import 'package:davidan_prototype/core/widgets/photo_hero.dart';
import 'package:davidan_prototype/data/mock/mock_brand.dart';
import 'package:davidan_prototype/data/mock/rental/rental_cars.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/rental_car.dart';
import 'package:davidan_prototype/features/rental/application/rental_providers.dart';
import 'package:davidan_prototype/features/rental/presentation/car_detail_screen.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// DaviDan Rent Car, full screen above the hub: its homepage's line, how its
/// prices work, and every car of the fleet, each opening its page. A rental
/// is a request the company confirms by phone, not a cart, so there is no
/// cart button.
class RentalHomeScreen extends ConsumerStatefulWidget {
  const RentalHomeScreen({super.key});

  @override
  ConsumerState<RentalHomeScreen> createState() => _RentalHomeScreenState();
}

class _RentalHomeScreenState extends ConsumerState<RentalHomeScreen> {
  /// The kind of car shown; null shows the whole fleet.
  RentalCarClass? _carClass;

  @override
  Widget build(BuildContext context) {
    final fleet = ref.watch(rentalCarsProvider);
    final cars = [
      for (final car in fleet)
        if (_carClass == null || car.carClass == _carClass) car,
    ];
    final classes = [
      for (final carClass in RentalCarClass.values)
        if (fleet.any((car) => car.carClass == carClass)) carClass,
    ];
    final info = brandInfos[Brand.carRental]!;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BrandHeaderBand(
            brand: Brand.carRental,
            title: RentalPage.title,
            onBack: () => context.pop(),
            actions: [
              AppIconButton(
                icon: Icons.info_outline_rounded,
                semanticLabel: context.l10n.openBrandInfo(info.name),
                onPressed: () =>
                    context.push(Routes.brandInfo(Brand.carRental)),
              ),
            ],
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
                Text(
                  context.content.text(RentalPage.line),
                  style: context.textStyles.body,
                ),
                const SizedBox(height: AppSpacing.lg),
                InfoNote(
                  icon: Icons.sell_rounded,
                  text: context.l10n.rentalFleetHint(
                    context.l10n.formatEuro(RentalTerms.locationFeeEur),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  child: Row(
                    children: [
                      for (final (index, carClass) in [
                        null,
                        ...classes,
                      ].indexed) ...[
                        if (index > 0) const SizedBox(width: AppSpacing.sm),
                        AppChip(
                          label: carClass == null
                              ? context.l10n.allBrands
                              : context.l10n.rentalCarClass(carClass.name),
                          selected: carClass == _carClass,
                          onTap: () => setState(() => _carClass = carClass),
                        ),
                      ],
                    ],
                  ),
                ),
                for (final car in cars)
                  Padding(
                    key: ValueKey(car.id),
                    padding: const EdgeInsets.only(top: AppSpacing.lg),
                    child: _CarCard(
                      car: car,
                      onTap: () => context.push(Routes.rentalCar(car.id)),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A car's photo, name and main specs, its lowest price per day and, so the
/// listing doesn't only show the cheapest number, its price for 1–3 days.
class _CarCard extends StatelessWidget {
  const _CarCard({required this.car, required this.onTap});

  final RentalCar car;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const shortest = RentalTier.days1to3;

    return Material(
      color: context.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        side: BorderSide(color: context.colors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 3 / 2,
              // The one square photo keeps the car, low in the frame.
              child: PhotoHero(
                tag: CarDetailScreen.heroTagFor(car.id),
                // The card's own top corners.
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadii.lg),
                ),
                child: Image.asset(
                  car.image,
                  fit: BoxFit.cover,
                  alignment: const Alignment(0, 0.5),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Expanded(
                        child: Text(
                          car.name,
                          style: context.textStyles.subtitle,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Text(
                        l10n.rentalPriceFrom(
                          l10n.formatEuro(car.lowestDayRateEur),
                        ),
                        style: context.textStyles.price,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    [
                      '${car.year}',
                      car.gearbox,
                      car.fuel,
                      l10n.rentalSeats(car.passengers),
                    ].join(' · '),
                    style: context.textStyles.caption,
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    l10n.rentalPriceForTier(
                      l10n.formatEuro(car.dayRatesEur[shortest]!),
                      l10n.rentalTier(shortest),
                    ),
                    style: context.textStyles.caption,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
