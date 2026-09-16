import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/utils/money.dart';
import 'package:davidan_prototype/core/widgets/app_button.dart';
import 'package:davidan_prototype/core/widgets/screen_header.dart';
import 'package:davidan_prototype/core/widgets/summary_row.dart';
import 'package:davidan_prototype/data/mock/rental/rental_cars.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/rental_car.dart';
import 'package:davidan_prototype/features/rental/application/rental_providers.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// A car of the rental fleet, full screen above the brand's home, which opens
/// it: its photo and description line, its specs and equipment as
/// davidanrentcar.md lists them, every price per day with what each rental
/// adds, and the documents the driver needs, then the way to its request
/// form. The router only opens it for a car of the fleet.
class CarDetailScreen extends ConsumerWidget {
  const CarDetailScreen({super.key, required this.carId});

  final String carId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final car = ref.watch(rentalCarByIdProvider(carId))!;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(
              title: car.name,
              // Opened straight from a link, there's nothing to go back to.
              onBack: () => context.canPop()
                  ? context.pop()
                  : context.go(Routes.brandHome(Brand.carRental)),
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadii.lg),
                    child: AspectRatio(
                      aspectRatio: 3 / 2,
                      child: Image.asset(
                        car.image,
                        fit: BoxFit.cover,
                        alignment: const Alignment(0, 0.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(car.tagline, style: context.textStyles.bodySecondary),
                  const SizedBox(height: AppSpacing.lg),
                  _Card(child: _Specs(car: car)),
                  _Section(
                    title: l10n.rentalFeaturesTitle,
                    child: Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        for (final feature in car.features)
                          _FeatureTag(feature),
                      ],
                    ),
                  ),
                  _Section(
                    title: l10n.rentalPricesTitle,
                    child: _Card(child: _Prices(car: car)),
                  ),
                  _Section(
                    title: l10n.rentalDocumentsTitle,
                    child: _Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (final (index, document)
                              in RentalTerms.documents.indexed)
                            Padding(
                              padding: EdgeInsets.only(
                                top: index == 0 ? 0 : AppSpacing.md,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.badge_outlined,
                                    size: 20,
                                    color: context.colors.primary,
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Text(
                                      document,
                                      style: context.textStyles.body,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.surface,
          border: Border(top: BorderSide(color: context.colors.border)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              AppSpacing.md,
              AppSpacing.gutter,
              AppSpacing.gutter,
            ),
            child: AppButton(
              label: l10n.rentalRequestAction,
              icon: Icons.event_available_rounded,
              onPressed: () => context.push(Routes.rentalRequest(car.id)),
            ),
          ),
        ),
      ),
    );
  }
}

/// The site's spec list, two to a row.
class _Specs extends StatelessWidget {
  const _Specs({required this.car});

  final RentalCar car;

  @override
  Widget build(BuildContext context) {
    final specs = car.specs;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < specs.length; index += 2)
          Padding(
            padding: EdgeInsets.only(top: index == 0 ? 0 : AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final (spec, value) in specs.skip(index).take(2))
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.rentalSpecLabel(spec),
                            style: context.textStyles.caption,
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          Text(value, style: context.textStyles.bodyStrong),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Every price per day, then the location fee and the car's insurance amount,
/// which every rental adds once.
class _Prices extends StatelessWidget {
  const _Prices({required this.car});

  final RentalCar car;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (index, tier) in RentalTier.values.indexed)
          Padding(
            padding: EdgeInsets.only(top: index == 0 ? 0 : AppSpacing.sm),
            child: SummaryRow(
              label: l10n.rentalTier(tier),
              value: l10n.rentalPricePerDay(
                l10n.formatEuro(car.dayRatesEur[tier]!),
              ),
            ),
          ),
        Divider(height: AppSpacing.xl, color: context.colors.border),
        SummaryRow(
          label: l10n.rentalLocationFee,
          value: l10n.formatEuro(RentalTerms.locationFeeEur),
        ),
        const SizedBox(height: AppSpacing.sm),
        SummaryRow(
          label: l10n.rentalInsurance,
          value: l10n.formatEuro(car.insuranceEur),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(l10n.rentalFeesNote, style: context.textStyles.caption),
      ],
    );
  }
}

class _FeatureTag extends StatelessWidget {
  const _FeatureTag(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.accentSoft,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs + AppSpacing.xxs,
        ),
        child: Text(label, style: context.textStyles.label),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: context.colors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: child,
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: context.textStyles.subtitle),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }
}
