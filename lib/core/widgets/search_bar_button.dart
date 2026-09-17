import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_card.dart';

/// A search field at the top of a screen that opens the search page, where
/// the real field takes the typing: the way Glovo and Wolt open search, so the
/// keyboard never covers the screen it was opened from. A soft raised card,
/// the magnifier in the brand's colour and a quiet hint, with no outline. With
/// [onFilter], a square filter button of the same card sits beside it.
class SearchBarButton extends StatelessWidget {
  const SearchBarButton({
    super.key,
    required this.hint,
    required this.onTap,
    this.onFilter,
    this.filterLabel,
  }) : assert(
         (onFilter == null) == (filterLabel == null),
         'A filter button needs its label',
       );

  /// What can be searched, in the field's place.
  final String hint;
  final VoidCallback onTap;
  final VoidCallback? onFilter;
  final String? filterLabel;

  static const height = 52.0;

  /// The corners the search page's field shares, so the one opens into the
  /// other.
  static const radius = 14.0;

  /// The hint's look, shared with the search page's field.
  static TextStyle hintStyleOf(BuildContext context) =>
      context.textStyles.bodySecondary.copyWith(fontSize: 15, height: 1.3);

  @override
  Widget build(BuildContext context) {
    final onFilter = this.onFilter;
    final bar = Semantics(
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
    if (onFilter == null) return bar;
    return Row(
      children: [
        Expanded(child: bar),
        const SizedBox(width: AppSpacing.md),
        SearchFilterButton(label: filterLabel!, onTap: onFilter),
      ],
    );
  }
}

/// The square filter button beside a search field, the same soft card. A dot
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
        dimension: SearchBarButton.height,
        child: AppCard(
          radius: SearchBarButton.radius,
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
