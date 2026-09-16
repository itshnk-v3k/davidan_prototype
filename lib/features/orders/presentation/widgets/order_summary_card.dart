import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/utils/money.dart';
import 'package:davidan_prototype/core/widgets/summary_row.dart';
import 'package:davidan_prototype/data/models/cart_item.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

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
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: context.colors.border),
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
                  label: context.l10n.lineItem(
                    line.quantity,
                    line.product.name,
                  ),
                  value: context.l10n.formatLei(line.priceBani * line.quantity),
                ),
              ),
            Divider(height: AppSpacing.xl, color: context.colors.border),
            SummaryRow(
              label: context.l10n.total,
              value: context.l10n.formatLei(totalBani),
              emphasized: true,
            ),
          ],
        ),
      ),
    );
  }
}
