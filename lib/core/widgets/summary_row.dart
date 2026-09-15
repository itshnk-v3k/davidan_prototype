import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';

/// Label on the left, amount on the right: "2 × Coca Cola ··· 50 lei".
/// [emphasized] is for the total.
class SummaryRow extends StatelessWidget {
  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Expanded(
          child: Text(
            label,
            style: emphasized
                ? context.textStyles.subtitle
                : context.textStyles.body,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Text(
          value,
          style: emphasized
              ? context.textStyles.priceLarge
              : context.textStyles.bodyStrong,
        ),
      ],
    );
  }
}
