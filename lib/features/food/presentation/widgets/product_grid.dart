import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';
import 'package:davidan_prototype/data/models/product.dart';
import 'package:davidan_prototype/features/food/application/product_layout_notifier.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/connected_product_card.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/product_card.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// A list of products (a sliver), shared by the menu, the favourites, the
/// water page and search: a [title] with the button that switches between two
/// columns of cards and one column of wide rows, then the products that way.
/// The choice is saved and the same in every list. Home shows its products in
/// sideways rows instead (ProductShelf).
class ProductGrid extends ConsumerWidget {
  const ProductGrid({
    super.key,
    required this.products,
    required this.title,
    this.showBrand = false,
  });

  final List<Product> products;

  /// The heading beside the layout button, such as how many products there
  /// are.
  final String title;

  /// For a list mixing brands: see [ConnectedProductCard.showBrand].
  final bool showBrand;

  /// Between cards, and between rows. Kept to [AppSpacing.md] so that two
  /// columns on a 360 dp phone come to 158 dp a card: below about that, a
  /// three-figure price and a stepper stop fitting the price row side by side
  /// (see [ProductPriceRow]).
  static const _gap = AppSpacing.md;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layout = ref.watch(productLayoutProvider);

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(child: _Heading(title: title)),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            0,
            AppSpacing.gutter,
            AppSpacing.xl,
          ),
          sliver: switch (layout) {
            ProductLayout.grid => SliverLayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = (constraints.crossAxisExtent - _gap) / 2;
                return SliverGrid.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: _gap,
                    crossAxisSpacing: _gap,
                    // As tall as the text needs at the phone's text size.
                    mainAxisExtent: ProductCard.heightFor(
                      context,
                      cardWidth,
                      names: [for (final product in products) product.name],
                    ),
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) => ConnectedProductCard(
                    product: products[index],
                    showBrand: showBrand,
                  ),
                );
              },
            ),
            ProductLayout.list => SliverList.separated(
              itemCount: products.length,
              separatorBuilder: (_, _) => const SizedBox(height: _gap),
              itemBuilder: (context, index) => ConnectedProductCard(
                product: products[index],
                showBrand: showBrand,
                style: ProductTileStyle.listTile,
              ),
            ),
          },
        ),
      ],
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    // The button's clear margin takes the place of the padding beside it, so
    // its circle lines up with the cards' right edge.
    final margin = TapTarget.marginFor(ProductLayoutToggle.size);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        0,
        AppSpacing.gutter - margin,
        AppSpacing.md - margin,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: context.textStyles.subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const ProductLayoutToggle(),
        ],
      ),
    );
  }
}

/// The button that switches every product list between cards and wide rows:
/// the one saved [ProductLayout], wherever it's tapped. It shows the layout a
/// tap switches to.
class ProductLayoutToggle extends ConsumerWidget {
  const ProductLayoutToggle({super.key});

  static const size = 36.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layout = ref.watch(productLayoutProvider);
    return AppIconButton(
      icon: layout == ProductLayout.grid
          ? PhosphorIconsRegular.rows
          : PhosphorIconsRegular.squaresFour,
      semanticLabel: layout == ProductLayout.grid
          ? context.l10n.showAsList
          : context.l10n.showAsGrid,
      size: size,
      onPressed: () => ref.read(productLayoutProvider.notifier).toggle(),
    );
  }
}

/// Cards or rows, side by side as two small segments with the current one
/// lit: where a toggle stands on its own above a list, rather than beside a
/// heading. The same saved [ProductLayout] as [ProductLayoutToggle].
class ProductLayoutSwitch extends ConsumerWidget {
  const ProductLayoutSwitch({super.key});

  static const _height = 36.0;
  static const _segmentWidth = 44.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layout = ref.watch(productLayoutProvider);
    final colors = context.colors;
    const inset = AppSpacing.xxs + 1;
    final outer = BorderRadius.circular(AppRadii.pill);

    Widget segment(ProductLayout value, IconData icon, String label) {
      final selected = layout == value;
      return Semantics(
        button: true,
        selected: selected,
        label: label,
        excludeSemantics: true,
        child: Material(
          color: selected ? colors.surface : Colors.transparent,
          borderRadius: outer,
          elevation: 0,
          child: InkWell(
            borderRadius: outer,
            onTap: selected
                ? null
                : () => ref.read(productLayoutProvider.notifier).toggle(),
            child: SizedBox(
              width: _segmentWidth,
              height: _height - 2 * inset,
              child: Icon(
                icon,
                size: 18,
                color: selected ? colors.primary : colors.textSecondary,
              ),
            ),
          ),
        ),
      );
    }

    // The segments are 30 px tall; the taps reach TapTarget.min around them.
    return SizedBox(
      height: TapTarget.min,
      // As wide as the segments, so it lines up where it's placed.
      child: Center(
        widthFactor: 1,
        child: Container(
          padding: const EdgeInsets.all(inset),
          decoration: BoxDecoration(
            color: colors.surfaceMuted,
            borderRadius: outer,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              segment(
                ProductLayout.grid,
                PhosphorIconsRegular.squaresFour,
                context.l10n.showAsGrid,
              ),
              segment(
                ProductLayout.list,
                PhosphorIconsRegular.rows,
                context.l10n.showAsList,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
