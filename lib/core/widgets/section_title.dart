import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';

/// Title of a group of items, with an optional count in a pill beside it:
/// a store panel column, a section of the courier's list.
class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title, this.count});

  final String title;
  final int? count;

  @override
  Widget build(BuildContext context) {
    final count = this.count;

    return Row(
      children: [
        Flexible(child: Text(title, style: context.textStyles.subtitle)),
        if (count != null) ...[
          const SizedBox(width: AppSpacing.sm),
          DecoratedBox(
            decoration: BoxDecoration(
              color: context.colors.accentSoft,
              borderRadius: BorderRadius.circular(AppRadii.pill),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xxs,
              ),
              child: Text('$count', style: context.textStyles.label),
            ),
          ),
        ],
      ],
    );
  }
}
