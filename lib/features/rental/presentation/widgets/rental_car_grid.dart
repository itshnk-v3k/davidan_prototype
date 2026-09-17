import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/utils/money.dart';
import 'package:davidan_prototype/core/widgets/app_card.dart';
import 'package:davidan_prototype/core/widgets/photo_hero.dart';
import 'package:davidan_prototype/data/models/rental_car.dart';
import 'package:davidan_prototype/features/rental/presentation/car_detail_screen.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// Cars two to a row, the way the menus show products, each opening its page.
/// Both cards of a row are as tall as the taller one, so the prices line up.
class RentalCarGrid extends StatelessWidget {
  const RentalCarGrid({super.key, required this.cars, required this.onOpen});

  final List<RentalCar> cars;
  final ValueChanged<RentalCar> onOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < cars.length; index += 2)
          Padding(
            key: ValueKey(cars[index].id),
            padding: EdgeInsets.only(top: index == 0 ? 0 : AppSpacing.md),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: _card(cars[index])),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: index + 1 < cars.length
                        ? _card(cars[index + 1])
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _card(RentalCar car) =>
      _CarCard(key: ValueKey(car.id), car: car, onTap: () => onOpen(car));
}

/// A car's photo, name, year and gearbox, its lowest price per day and, so
/// the listing doesn't only show the cheapest number, its price for 1–3 days.
class _CarCard extends StatelessWidget {
  const _CarCard({super.key, required this.car, required this.onTap});

  final RentalCar car;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const shortest = RentalTier.days1to3;

    return AppCard(
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
                top: Radius.circular(AppRadii.card),
              ),
              child: Image.asset(
                car.image,
                fit: BoxFit.cover,
                alignment: const Alignment(0, 0.5),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.xxs,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  car.name,
                  style: context.textStyles.bodyStrong,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '${car.year} · ${car.gearbox}',
                  style: context.textStyles.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.xs,
              AppSpacing.md,
              AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.rentalPriceFrom(l10n.formatEuro(car.lowestDayRateEur)),
                  style: context.textStyles.price,
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
    );
  }
}
