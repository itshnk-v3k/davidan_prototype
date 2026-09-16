import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/widgets/app_button.dart';
import 'package:davidan_prototype/core/widgets/summary_row.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// Bottom bar with the running total and the next step, on the cart,
/// checkout and car rental request screens.
class TotalBar extends StatelessWidget {
  const TotalBar({
    super.key,
    required this.total,
    required this.actionLabel,
    required this.onAction,
  });

  /// Already formatted, in the brand's currency: "138 lei", "251 €".
  final String total;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SummaryRow(
                label: context.l10n.total,
                value: total,
                emphasized: true,
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton(label: actionLabel, onPressed: onAction),
            ],
          ),
        ),
      ),
    );
  }
}
