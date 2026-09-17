import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';

/// A small count on an icon's corner: the items in a cart, the saved
/// favourites. "99+" past 99. Callers show it only for a count above 0 and
/// keep it out of semantics, since their own label says the count.
class CountBadge extends StatelessWidget {
  const CountBadge({super.key, required this.count, this.color});

  final int count;

  /// The theme's primary colour when null, such as a brand's inside its pages.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18,
      constraints: const BoxConstraints(minWidth: 18),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color ?? context.colors.primary,
        borderRadius: BorderRadius.circular(AppRadii.pill),
        border: Border.all(color: context.colors.background, width: 1.5),
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        style: context.textStyles.badge,
      ),
    );
  }
}
