import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/toast/toast_notifier.dart';
import 'package:davidan_prototype/data/mock/placeholder_nutrition.dart';
import 'package:davidan_prototype/data/mock/placeholder_ratings.dart';
import 'package:davidan_prototype/data/models/product.dart';
import 'package:davidan_prototype/features/food/application/cart_notifier.dart';
import 'package:davidan_prototype/features/food/application/favorites_notifier.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/product_card.dart';
import 'package:davidan_prototype/l10n/app_language.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// A [ProductCard], [ProductListTile] or [FeaturedProductCard] ([style]), wired to the cart
/// and favourites, the same way in the menu, the favourites, search and home's
/// rows: it opens its product, adds to and removes from the cart, and saves or
/// unsaves the product. It watches only its own product, so adding one
/// product rebuilds one card. With [showBrand], for lists that mix brands, it
/// names its brand and adding says which brand's cart the product went to.
class ConnectedProductCard extends ConsumerWidget {
  const ConnectedProductCard({
    super.key,
    required this.product,
    this.heroScope,
    this.showBrand = false,
    this.style = ProductTileStyle.card,
  });

  final Product product;

  /// See [ProductTileData.heroScope]; also sent to the product page.
  final String? heroScope;
  final bool showBrand;

  final ProductTileStyle style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ProductKey(:brand, :id) = product.key;
    final quantity = ref.watch(
      cartQuantitiesProvider(brand).select((quantities) => quantities[id] ?? 0),
    );
    final favorite = ref.watch(
      favoriteKeysProvider.select((keys) => keys.contains(product.key)),
    );
    CartNotifier cart() => ref.read(cartProvider(brand).notifier);

    final data = ProductTileData(
      product: product,
      quantity: quantity,
      favorite: favorite,
      heroScope: heroScope,
      brandName: showBrand ? context.content.introOf(brand).name : null,
      // PLACEHOLDERS, NOT REAL DATA: no reviews or nutrition facts exist yet
      // (see both files).
      placeholderRating: placeholderRatingFor(product.key),
      placeholderNutrition: placeholderNutritionFor(product),
      onTap: () =>
          context.push(Routes.brandProduct(product.key, heroScope: heroScope)),
      onAdd: () {
        final firstOne = quantity == 0;
        cart().add(id);
        if (showBrand && firstOne) {
          final strings = ref.read(stringsProvider);
          ref
              .read(toastProvider.notifier)
              .show(
                strings.addedToBrandCart(
                  ref.read(contentProvider).introOf(brand).name,
                ),
                brand: brand,
              );
        }
      },
      onRemove: () => cart().removeOne(id),
      onToggleFavorite: () =>
          ref.read(favoritesProvider.notifier).toggle(product.key),
    );

    return switch (style) {
      ProductTileStyle.card => ProductCard(data: data),
      ProductTileStyle.listTile => ProductListTile(data: data),
      ProductTileStyle.featured => FeaturedProductCard(data: data),
    };
  }
}

/// How a product is drawn: a card in a grid or row, a wide row in a list, or
/// the popular row's big card.
enum ProductTileStyle { card, listTile, featured }
