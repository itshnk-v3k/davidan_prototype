import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_card.dart';

/// A search field at the top of a screen that opens the search page, where
/// the real field takes the typing: the way Glovo and Wolt open search, so the
/// keyboard never covers the screen it was opened from. A soft raised card,
/// the magnifier in the brand's colour and a quiet hint, with no outline.
class SearchBarButton extends StatelessWidget {
  const SearchBarButton({super.key, required this.hint, required this.onTap});

  /// What can be searched, in the field's place.
  final String hint;
  final VoidCallback onTap;

  static const height = 52.0;

  /// The corners the search page's field shares, so the one opens into the
  /// other.
  static const radius = 14.0;

  /// The hint's look, shared with the search page's field.
  static TextStyle hintStyleOf(BuildContext context) =>
      context.textStyles.bodySecondary.copyWith(fontSize: 15, height: 1.3);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: hint,
      excludeSemantics: true,
      child: AppCard(
        radius: radius,
        onTap: onTap,
        child: SizedBox(
          height: height,
          child: Row(
            children: [
              const SizedBox(width: AppSpacing.lg),
              Icon(
                PhosphorIconsRegular.magnifyingGlass,
                size: 22,
                color: context.colors.primary,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  hint,
                  style: hintStyleOf(context),
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
