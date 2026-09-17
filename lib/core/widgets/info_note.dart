import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';

/// A short explanation on a neutral surface, with the icon in the brand's
/// colour: a demo disclaimer, why the map picker opened, what a rental request
/// commits to. Neutral, so it never reads as a warning in a red brand.
class InfoNote extends StatelessWidget {
  const InfoNote({
    super.key,
    required this.text,
    this.icon = Icons.info_outline_rounded,
  });

  final String text;
  final IconData icon;

  /// The note's background in [colors]' theme, for the contrast test.
  static Color fillOf(AppColors colors) => colors.surfaceMuted;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: fillOf(context.colors),
        border: Border.all(color: context.colors.border),
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: context.colors.primary),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(text, style: context.textStyles.body)),
          ],
        ),
      ),
    );
  }
}
