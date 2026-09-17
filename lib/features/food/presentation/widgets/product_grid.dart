import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/data/models/product.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/connected_product_card.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/product_card.dart';

/// Two-column product grid (a sliver), shared by the menu and favourites
/// screens. Home shows its products in rows instead (ProductShelf).
class ProductGrid extends StatelessWidget {
  const ProductGrid({
    super.key,
    required this.products,
    this.showBrand = false,
  });

  final List<Product> products;

  /// For a grid mixing brands: see [ConnectedProductCard.showBrand].
  final bool showBrand;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        0,
        AppSpacing.gutter,
        AppSpacing.xl,
      ),
      sliver: SliverLayoutBuilder(
        builder: (context, constraints) {
          final cardWidth = (constraints.crossAxisExtent - AppSpacing.md) / 2;
          return SliverGrid.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              // As tall as the text needs at the phone's text size.
              mainAxisExtent: ProductCard.heightFor(context, cardWidth),
            ),
            itemCount: products.length,
            itemBuilder: (context, index) => ConnectedProductCard(
              product: products[index],
              showBrand: showBrand,
            ),
          );
        },
      ),
    );
  }
}
