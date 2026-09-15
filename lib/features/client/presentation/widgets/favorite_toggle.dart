import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';

/// Heart that saves a product to the favourites or removes it, on product
/// cards and on the product page. Saving pops the heart.
class FavoriteToggle extends StatelessWidget {
  const FavoriteToggle({
    super.key,
    required this.productName,
    required this.favorite,
    required this.onToggle,
    this.size = 40,
  });

  final String productName;
  final bool favorite;
  final VoidCallback onToggle;
  final double size;

  @override
  Widget build(BuildContext context) {
    return AppIconButton(
      icon: favorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
      iconColor: favorite ? AppColors.primary : AppColors.textPrimary,
      size: size,
      emphasized: favorite,
      semanticLabel: favorite
          ? AppStrings.removeFromFavorites(productName)
          : AppStrings.addToFavorites(productName),
      onPressed: onToggle,
    );
  }
}
