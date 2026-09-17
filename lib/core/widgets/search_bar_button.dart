import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_card.dart';

/// A search field at the top of a screen that opens the search page, where
/// the real field takes the typing: the way Glovo and Wolt open search, so the
/// keyboard never covers the screen it was opened from.
class SearchBarButton extends StatelessWidget {
  const SearchBarButton({super.key, required this.hint, required this.onTap});

  /// What can be searched, in the field's place.
  final String hint;
  final VoidCallback onTap;

  static const height = 48.0;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: hint,
      excludeSemantics: true,
      child: AppCard(
        radius: AppRadii.pill,
        onTap: onTap,
        child: SizedBox(
          height: height,
          child: Row(
            children: [
              const SizedBox(width: AppSpacing.lg),
              Icon(
                Icons.search_rounded,
                size: 22,
                color: context.colors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  hint,
                  style: context.textStyles.bodySecondary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
