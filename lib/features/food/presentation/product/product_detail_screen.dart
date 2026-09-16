import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/toast/toast_notifier.dart';
import 'package:davidan_prototype/core/utils/money.dart';
import 'package:davidan_prototype/core/widgets/app_button.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';
import 'package:davidan_prototype/data/models/product.dart';
import 'package:davidan_prototype/features/food/application/cart_notifier.dart';
import 'package:davidan_prototype/features/food/application/catalog_providers.dart';
import 'package:davidan_prototype/features/food/application/favorites_notifier.dart';
import 'package:davidan_prototype/features/food/application/product_quantity_notifier.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/favorite_toggle.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/product_image.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/quantity_stepper.dart';

/// Product photo, name, price and ingredients, with a heart to save it and a
/// bar to pick a quantity and add it to the cart. Back returns to wherever
/// the product was opened.
class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({
    super.key,
    required this.productKey,
    this.heroScope,
  });

  final ProductKey productKey;

  /// The row the product was opened from, when home shows it in more than
  /// one, so the photo flies back and forth with that card.
  final String? heroScope;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(productByIdProvider(productKey));

    // Opened from home or the catalog, this route was pushed and pops back.
    // Opened straight from a URL there is nothing to pop, so go home.
    void goBack() =>
        context.canPop() ? context.pop() : context.go(Routes.clientHome);

    if (product == null) return _ProductNotFound(onBack: goBack);

    final quantity = ref.watch(productQuantityProvider(productKey));
    final inCart =
        ref.watch(cartQuantitiesProvider(productKey.brand))[productKey.id] ?? 0;
    final favorite = ref.watch(favoriteKeysProvider).contains(productKey);
    final buttonsTop = MediaQuery.paddingOf(context).top + AppSpacing.md;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: ProductImage(
                    path: product.image,
                    heroTag: ProductImage.heroTagFor(
                      productKey,
                      scope: heroScope,
                    ),
                  ),
                ),
                Positioned(
                  top: buttonsTop,
                  left: AppSpacing.gutter,
                  child: AppIconButton(
                    icon: Icons.arrow_back_rounded,
                    semanticLabel: AppStrings.back,
                    onPressed: goBack,
                  ),
                ),
                Positioned(
                  top: buttonsTop,
                  right: AppSpacing.gutter,
                  child: FavoriteToggle(
                    productName: product.name,
                    favorite: favorite,
                    onToggle: () =>
                        ref.read(favoritesProvider.notifier).toggle(productKey),
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              AppSpacing.xl,
              AppSpacing.gutter,
              AppSpacing.xxl,
            ),
            sliver: SliverToBoxAdapter(
              child: _ProductInfo(product: product, inCartCount: inCart),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _AddToCartBar(
        quantity: quantity,
        total: formatLei(product.priceBani * quantity),
        onIncrement: quantity < ProductQuantityNotifier.max
            ? () => ref
                  .read(productQuantityProvider(productKey).notifier)
                  .increment()
            : null,
        onDecrement: quantity > 1
            ? () => ref
                  .read(productQuantityProvider(productKey).notifier)
                  .decrement()
            : null,
        onAdd: () {
          ref
              .read(cartProvider(productKey.brand).notifier)
              .add(productKey.id, quantity: quantity);
          ref
              .read(toastProvider.notifier)
              .show(AppStrings.addedToCart(quantity, product.name));
          goBack();
        },
      ),
    );
  }
}

class _ProductInfo extends StatelessWidget {
  const _ProductInfo({required this.product, required this.inCartCount});

  final Product product;
  final int inCartCount;

  @override
  Widget build(BuildContext context) {
    final description = product.description;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(product.name, style: context.textStyles.headline),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Text(
              formatLei(product.priceBani),
              style: context.textStyles.priceLarge,
            ),
            if (inCartCount > 0) ...[
              const SizedBox(width: AppSpacing.md),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: context.colors.accentSoft,
                  borderRadius: BorderRadius.circular(AppRadii.pill),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm + AppSpacing.xxs,
                    vertical: AppSpacing.xs,
                  ),
                  child: Text(
                    AppStrings.inCart(inCartCount),
                    style: context.textStyles.label,
                  ),
                ),
              ),
            ],
          ],
        ),
        if (description != null) ...[
          const SizedBox(height: AppSpacing.xl),
          Text(AppStrings.descriptionTitle, style: context.textStyles.subtitle),
          const SizedBox(height: AppSpacing.sm),
          Text(description, style: context.textStyles.bodySecondary),
        ],
      ],
    );
  }
}

class _AddToCartBar extends StatelessWidget {
  const _AddToCartBar({
    required this.quantity,
    required this.total,
    required this.onIncrement,
    required this.onDecrement,
    required this.onAdd,
  });

  final int quantity;
  final String total;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(top: BorderSide(color: context.colors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.gutter),
          child: Row(
            children: [
              QuantityStepper(
                quantity: quantity,
                onIncrement: onIncrement,
                onDecrement: onDecrement,
                incrementLabel: AppStrings.increaseQuantity,
                decrementLabel: AppStrings.decreaseQuantity,
                buttonSize: 42,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppButton(
                  label: AppStrings.addToCartTotal(total),
                  onPressed: onAdd,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductNotFound extends StatelessWidget {
  const _ProductNotFound({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.gutter),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: AppIconButton(
                  icon: Icons.arrow_back_rounded,
                  semanticLabel: AppStrings.back,
                  onPressed: onBack,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.search_off_rounded,
                size: 48,
                color: context.colors.accent,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                AppStrings.productNotFound,
                style: context.textStyles.subtitle,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
