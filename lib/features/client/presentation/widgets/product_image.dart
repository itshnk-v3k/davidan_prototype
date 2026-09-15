import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_motion.dart';

/// Product photo that fills its box, or a branded tile when there is no photo.
/// With a [heroTag], the photo flies between the screens that show it.
class ProductImage extends StatelessWidget {
  const ProductImage({super.key, required this.path, this.heroTag});

  final String? path;

  /// [heroTagFor] the product, on the product card, the cart line and the
  /// product page. A tag may appear only once per screen.
  final Object? heroTag;

  static Object heroTagFor(String productId) => 'product-photo:$productId';

  static const _placeholder = ColoredBox(
    color: AppColors.accentSoft,
    child: Center(
      child: Icon(Icons.restaurant_rounded, size: 32, color: AppColors.accent),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final path = this.path;
    final heroTag = this.heroTag;
    final image = path == null
        ? _placeholder
        : ColoredBox(
            color: AppColors.accentSoft,
            child: Image.asset(
              path,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _placeholder,
              // A photo already in memory shows at once. One still being
              // decoded (fast scrolling on a phone) fades in over the tint
              // instead of popping in.
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
                  wasSynchronouslyLoaded
                  ? child
                  : AnimatedOpacity(
                      opacity: frame == null ? 0 : 1,
                      duration: AppMotion.of(context, AppMotion.medium),
                      curve: AppMotion.standard,
                      child: child,
                    ),
            ),
          );
    return heroTag == null ? image : Hero(tag: heroTag, child: image);
  }
}
