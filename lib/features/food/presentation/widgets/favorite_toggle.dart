import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// Heart that saves a product to the favourites or removes it, on product
/// cards and on the product page, on a glass circle over the photo. Only the
/// product page's, pinned over whatever scrolls under it, blurs ([blur]); a
/// card's, repeated down a list, takes the glass look without the blur.
class FavoriteToggle extends StatelessWidget {
  const FavoriteToggle({
    super.key,
    required this.productName,
    required this.favorite,
    required this.onToggle,
    this.size = 40,
    this.blur = false,
  });

  final String productName;
  final bool favorite;
  final VoidCallback onToggle;
  final double size;
  final bool blur;

  @override
  Widget build(BuildContext context) {
    return AppIconButtonStyle.glass(
      blur: blur,
      child: AppIconButton(
        icon: favorite ? PhosphorIconsFill.heart : PhosphorIconsRegular.heart,
        iconColor: favorite
            ? context.colors.primary
            : context.colors.textPrimary,
        size: size,
        semanticLabel: favorite
            ? context.l10n.removeFromFavorites(productName)
            : context.l10n.addToFavorites(productName),
        onPressed: onToggle,
      ),
    );
  }
}
