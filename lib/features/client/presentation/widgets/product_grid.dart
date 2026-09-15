import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/data/models/product.dart';
import 'package:davidan_prototype/features/client/application/cart_notifier.dart';
import 'package:davidan_prototype/features/client/application/favorites_notifier.dart';
import 'package:davidan_prototype/features/client/presentation/widgets/product_card.dart';

/// Two-column product grid (a sliver), shared by the home, catalog and
/// favourites screens. Every card opens its product, adds to and removes from
/// the cart, and saves or unsaves the product as a favourite, the same way on
/// every screen.
class ProductGrid extends ConsumerWidget {
  const ProductGrid({super.key, required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quantities = ref.watch(cartQuantitiesProvider);
    final favoriteIds = ref.watch(favoriteIdsProvider);
    CartNotifier cart() => ref.read(cartProvider.notifier);

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        0,
        AppSpacing.gutter,
        AppSpacing.xl,
      ),
      sliver: SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: 0.66,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCard(
            product: product,
            quantity: quantities[product.id] ?? 0,
            favorite: favoriteIds.contains(product.id),
            onTap: () => context.push(Routes.clientProduct(product.id)),
            onAdd: () => cart().add(product.id),
            onRemove: () => cart().removeOne(product.id),
            onToggleFavorite: () =>
                ref.read(favoritesProvider.notifier).toggle(product.id),
          );
        },
      ),
    );
  }
}
