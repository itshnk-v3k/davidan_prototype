import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/utils/money.dart';
import 'package:davidan_prototype/core/widgets/summary_row.dart';
import 'package:davidan_prototype/data/models/rental_booking.dart';
import 'package:davidan_prototype/data/models/rental_car.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// A rental's price line by line, as davidanrentcar.md's cart adds it up: the
/// days at the price per day for that many days, each chosen extra, the
/// location fee and the car's insurance amount, then the total.
class RentalQuoteCard extends StatelessWidget {
  const RentalQuoteCard({super.key, required this.quote});

  final RentalQuote quote;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: context.colors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SummaryRow(
              label: l10n.rentalDaysAtRate(
                quote.days,
                l10n.formatEuro(quote.dayRateEur),
              ),
              value: l10n.formatEuro(quote.rentalEur),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              l10n.rentalRateForTier(
                l10n.rentalTier(RentalTier.of(quote.days)),
              ),
              style: context.textStyles.caption,
            ),
            for (final MapEntry(key: extra, value: amount)
                in quote.extrasEur.entries)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: SummaryRow(
                  label: l10n.rentalExtra(extra),
                  value: l10n.formatEuro(amount),
                ),
              ),
            const SizedBox(height: AppSpacing.sm),
            SummaryRow(
              label: l10n.rentalLocationFee,
              value: l10n.formatEuro(quote.locationFeeEur),
            ),
            const SizedBox(height: AppSpacing.sm),
            SummaryRow(
              label: l10n.rentalInsurance,
              value: l10n.formatEuro(quote.insuranceEur),
            ),
            Divider(height: AppSpacing.xl, color: context.colors.border),
            SummaryRow(
              label: l10n.total,
              value: l10n.formatEuro(quote.totalEur),
              emphasized: true,
            ),
          ],
        ),
      ),
    );
  }
}
