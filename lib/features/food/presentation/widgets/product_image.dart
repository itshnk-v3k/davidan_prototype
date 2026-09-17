import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_motion.dart';
import 'package:davidan_prototype/core/widgets/photo_hero.dart';
import 'package:davidan_prototype/data/models/product.dart';

/// Product photo that fills its box, or a branded tile when there is no photo.
/// With a [heroTag], the photo flies between the screens that show it.
class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.path,
    this.heroTag,
    this.borderRadius = BorderRadius.zero,
  });

  final String? path;

  /// The photo's rounded corners, clipped inside the flying photo so they
  /// change smoothly in flight.
  final BorderRadius borderRadius;

  /// [heroTagFor] the product, on the product card, the cart line and the
  /// product page. A tag may appear only once per screen.
  final Object? heroTag;

  /// With a [scope] (the row a card sits in), the same product can be shown
  /// in several rows of one screen without two photos sharing a tag.
  static Object heroTagFor(ProductKey product, {String? scope}) => scope == null
      ? 'product-photo:${product.brand.name}:${product.id}'
      : 'product-photo:$scope:${product.brand.name}:${product.id}';

  @override
  Widget build(BuildContext context) {
    final path = this.path;
    final heroTag = this.heroTag;
    final image = path == null
        ? const _Placeholder()
        : ColoredBox(
            color: context.colors.accentSoft,
            child: Image.asset(
              path,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const _Placeholder(),
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
    if (heroTag != null) {
      return PhotoHero(tag: heroTag, borderRadius: borderRadius, child: image);
    }
    return borderRadius == BorderRadius.zero
        ? image
        : ClipRRect(borderRadius: borderRadius, child: image);
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.colors.accentSoft,
      child: Center(
        child: Icon(
          PhosphorIconsRegular.forkKnife,
          size: 32,
          color: context.colors.primary,
        ),
      ),
    );
  }
}
