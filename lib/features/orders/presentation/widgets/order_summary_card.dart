import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/utils/money.dart';
import 'package:davidan_prototype/core/widgets/summary_row.dart';
import 'package:davidan_prototype/data/models/cart_item.dart';

/// Each item with its line total, then the order total.
class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({
    super.key,
    required this.lines,
    required this.totalBani,
  });

  final List<CartLine> lines;
  final int totalBani;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (index, line) in lines.indexed)
              Padding(
                padding: EdgeInsets.only(top: index == 0 ? 0 : AppSpacing.sm),
                child: SummaryRow(
                  label: AppStrings.lineItem(line.quantity, line.product.name),
                  value: formatLei(line.priceBani * line.quantity),
                ),
              ),
            const Divider(height: AppSpacing.xl, color: AppColors.border),
            SummaryRow(
              label: AppStrings.total,
              value: formatLei(totalBani),
              emphasized: true,
            ),
          ],
        ),
      ),
    );
  }
}
