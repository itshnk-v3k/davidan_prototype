import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_card.dart';

/// How the search page's field looks: a soft raised card, the magnifier in the
/// brand's colour and a quiet hint, with no outline. The way Glovo and Wolt
/// draw theirs.
///
/// Search opens from the magnifier in a brand's bar, not from a field in the
/// page: a field under the banners scrolls away and a category page never had
/// one, so wherever the customer is in a brand the magnifier is on screen.
abstract final class SearchField {
  static const height = 52.0;
  static const radius = AppRadii.card;

  static TextStyle hintStyleOf(BuildContext context) =>
      context.textStyles.bodySecondary.copyWith(fontSize: 14, height: 1.3);
}

/// The square filter button beside the search field, the same soft card. A dot
/// in the brand's colour says a filter is on.
class SearchFilterButton extends StatelessWidget {
  const SearchFilterButton({
    super.key,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      selected: active,
      label: label,
      excludeSemantics: true,
      child: SizedBox.square(
        dimension: SearchField.height,
        child: AppCard(
          radius: SearchField.radius,
          color: active ? colors.accentSoft : null,
          onTap: onTap,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                PhosphorIconsRegular.slidersHorizontal,
                size: 22,
                color: colors.primary,
              ),
              if (active)
                Positioned(
                  top: AppSpacing.md,
                  right: AppSpacing.md,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
