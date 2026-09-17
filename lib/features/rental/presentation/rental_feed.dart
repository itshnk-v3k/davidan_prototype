import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/utils/money.dart';
import 'package:davidan_prototype/core/widgets/app_chip.dart';
import 'package:davidan_prototype/core/widgets/chip_row.dart';
import 'package:davidan_prototype/core/widgets/info_note.dart';
import 'package:davidan_prototype/data/mock/rental/rental_cars.dart';
import 'package:davidan_prototype/data/models/rental_car.dart';
import 'package:davidan_prototype/features/rental/application/rental_providers.dart';
import 'package:davidan_prototype/features/rental/presentation/widgets/rental_car_grid.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// DaviDan Rent Car, inside Acasă's shell: its homepage's line, how its
/// prices work, and every car of the fleet two to a row, each opening its
/// page. A rental is a request the company confirms by phone, not a cart, so
/// the shell's bag counts the other brands' carts instead.
class RentalFeed extends ConsumerStatefulWidget {
  const RentalFeed({super.key});

  @override
  ConsumerState<RentalFeed> createState() => _RentalFeedState();
}

class _RentalFeedState extends ConsumerState<RentalFeed> {
  /// The kind of car shown; null shows the whole fleet.
  RentalCarClass? _carClass;

  @override
  Widget build(BuildContext context) {
    final fleet = ref.watch(rentalCarsProvider);
    final cars = [
      for (final car in fleet)
        if (_carClass == null || car.carClass == _carClass) car,
    ];
    // The chips: the whole fleet, then the classes it holds.
    final filters = <RentalCarClass?>[
      null,
      for (final carClass in RentalCarClass.values)
        if (fleet.any((car) => car.carClass == carClass)) carClass,
    ];

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.sm,
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
            icon: PhosphorIconsRegular.tag,
            text: context.l10n.rentalFleetHint(
              context.l10n.formatEuro(RentalTerms.locationFeeEur),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // "Toate" first, then every class the fleet has. The row scrolls
          // the chosen chip into the middle of itself, so a class at the far
          // end (SUV, Premium) doesn't stay off-screen once it is picked.
          ChipRow(
            itemCount: filters.length,
            selectedIndex: filters.indexOf(_carClass),
            // The sliver's own gutter already insets the row.
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final carClass = filters[index];
              return AppChip(
                label: carClass == null
                    ? context.l10n.allBrands
                    : context.l10n.rentalCarClass(carClass.name),
                selected: carClass == _carClass,
                onTap: () => setState(() => _carClass = carClass),
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          RentalCarGrid(
            cars: cars,
            onOpen: (car) => context.push(Routes.rentalCar(car.id)),
          ),
        ],
      ),
    );
  }
}
