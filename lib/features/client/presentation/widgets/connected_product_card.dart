import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/data/models/product.dart';
import 'package:davidan_prototype/features/client/application/cart_notifier.dart';
import 'package:davidan_prototype/features/client/application/favorites_notifier.dart';
import 'package:davidan_prototype/features/client/presentation/widgets/product_card.dart';

/// A [ProductCard] wired to the cart and favourites, the same way in the
/// menu, the favourites and home's rows: it opens its product, adds to and
/// removes from the cart, and saves or unsaves the product. It watches only
/// its own product, so adding one product rebuilds one card.
class ConnectedProductCard extends ConsumerWidget {
  const ConnectedProductCard({
    super.key,
    required this.product,
    this.heroScope,
    this.compact = false,
  });

  final Product product;

  /// See [ProductCard.heroScope]; also sent to the product page.
  final String? heroScope;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = product.id;
    final quantity = ref.watch(
      cartQuantitiesProvider.select((quantities) => quantities[id] ?? 0),
    );
    final favorite = ref.watch(
      favoriteIdsProvider.select((ids) => ids.contains(id)),
    );
    CartNotifier cart() => ref.read(cartProvider.notifier);

    return ProductCard(
      product: product,
      quantity: quantity,
      favorite: favorite,
      heroScope: heroScope,
      compact: compact,
      onTap: () => context.push(Routes.clientProduct(id, heroScope: heroScope)),
      onAdd: () => cart().add(id),
      onRemove: () => cart().removeOne(id),
      onToggleFavorite: () => ref.read(favoritesProvider.notifier).toggle(id),
    );
  }
}
