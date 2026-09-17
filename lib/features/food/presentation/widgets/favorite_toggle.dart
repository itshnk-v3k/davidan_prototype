import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// Heart that saves a product to the favourites or removes it, on product
/// cards and on the product page.
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
      iconColor: favorite ? context.colors.primary : context.colors.textPrimary,
      size: size,
      semanticLabel: favorite
          ? context.l10n.removeFromFavorites(productName)
          : context.l10n.addToFavorites(productName),
      onPressed: onToggle,
    );
  }
}
