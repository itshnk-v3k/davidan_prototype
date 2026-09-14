import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/data/models/product.dart';
import 'package:davidan_prototype/features/client/presentation/widgets/product_card.dart';

/// Two-column product grid (a sliver), shared by the home and catalog screens.
class ProductGrid extends StatelessWidget {
  const ProductGrid({
    super.key,
    required this.products,
    required this.quantities,
    required this.onOpen,
    required this.onAdd,
    required this.onRemove,
  });

  final List<Product> products;

  /// Cart quantity per product id.
  final Map<String, int> quantities;
  final ValueChanged<Product> onOpen;
  final ValueChanged<Product> onAdd;
  final ValueChanged<Product> onRemove;

  @override
  Widget build(BuildContext context) {
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
            onTap: () => onOpen(product),
            onAdd: () => onAdd(product),
            onRemove: () => onRemove(product),
          );
        },
      ),
    );
  }
}
