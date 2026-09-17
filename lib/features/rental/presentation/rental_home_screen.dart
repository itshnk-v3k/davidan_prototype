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
import 'package:davidan_prototype/data/mock/mock_brand.dart';
import 'package:davidan_prototype/data/mock/rental/rental_cars.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/rental_car.dart';
import 'package:davidan_prototype/features/rental/application/rental_providers.dart';
import 'package:davidan_prototype/features/rental/presentation/widgets/rental_car_grid.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// DaviDan Rent Car, inside Acasă: its homepage's line, how its prices work,
/// and every car of the fleet two to a row, each opening its page. A rental
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
      body: CustomScrollView(
        slivers: [
          BrandHeaderBand(
            brand: Brand.carRental,
            title: RentalPage.title,
            onBack: () => context.pop(),
            actions: [
              AppIconButton(
                icon: Icons.info_rounded,
                semanticLabel: context.l10n.openBrandInfo(info.name),
                onPressed: () =>
                    context.push(Routes.brandInfo(Brand.carRental)),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              0,
              AppSpacing.gutter,
              AppSpacing.xl,
            ),
            sliver: SliverList.list(
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
                const SizedBox(height: AppSpacing.lg),
                RentalCarGrid(
                  cars: cars,
                  onOpen: (car) => context.push(Routes.rentalCar(car.id)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
