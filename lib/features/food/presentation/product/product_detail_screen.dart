import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/toast/toast_notifier.dart';
import 'package:davidan_prototype/core/utils/money.dart';
import 'package:davidan_prototype/core/widgets/app_button.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';
import 'package:davidan_prototype/core/widgets/info_note.dart';
import 'package:davidan_prototype/core/widgets/top_scrim.dart';
import 'package:davidan_prototype/data/models/product.dart';
import 'package:davidan_prototype/features/food/application/cart_notifier.dart';
import 'package:davidan_prototype/features/food/application/catalog_providers.dart';
import 'package:davidan_prototype/features/food/application/favorites_notifier.dart';
import 'package:davidan_prototype/features/food/application/product_quantity_notifier.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/favorite_toggle.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/product_image.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/quantity_stepper.dart';
import 'package:davidan_prototype/l10n/app_language.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// Product photo, name, price, pieces and weight (when the brand's site gives
/// them) and ingredients, with a heart to save it and a bar to pick a quantity.
/// For a product not yet in the cart the bar adds that many; for one already
/// in it, the bar starts at the cart's quantity and updates it, or takes the
/// product out at 0. Back returns to wherever the product was opened.
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
    void goBack() => context.canPop()
        ? context.pop()
        : context.go(Routes.brandHome(productKey.brand));

    if (product == null) return _ProductNotFound(onBack: goBack);

    final quantity = ref.watch(productQuantityProvider(productKey));
    final inCart =
        ref.watch(cartQuantitiesProvider(productKey.brand))[productKey.id] ?? 0;
    final favorite = ref.watch(favoriteKeysProvider).contains(productKey);
    // Where the buttons' circles sit; their clear tap margins reach beyond.
    const margin = TapTarget.iconButtonMargin;
    final buttonsTop =
        MediaQuery.paddingOf(context).top + AppSpacing.md - margin;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        // The theme's status bar icons once the photo has scrolled away.
        value: Theme.of(context).brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              // Light status bar icons on the photo's dark top fade.
              child: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.light,
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
                    // Keeps the status bar readable over a light photo.
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: TopScrim.heightOf(context),
                      child: const TopScrim(),
                    ),
                    Positioned(
                      top: buttonsTop,
                      left: AppSpacing.gutter - margin,
                      child: AppIconButton(
                        icon: PhosphorIconsRegular.arrowLeft,
                        semanticLabel: context.l10n.back,
                        onPressed: goBack,
                      ),
                    ),
                    Positioned(
                      top: buttonsTop,
                      right: AppSpacing.gutter - margin,
                      child: FavoriteToggle(
                        productName: product.name,
                        favorite: favorite,
                        onToggle: () => ref
                            .read(favoritesProvider.notifier)
                            .toggle(productKey),
                      ),
                    ),
                  ],
                ),
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
      ),
      bottomNavigationBar: _AddToCartBar(
        quantity: quantity,
        total: context.l10n.formatLei(product.priceBani * quantity),
        onIncrement: quantity < ProductQuantityNotifier.max
            ? () => ref
                  .read(productQuantityProvider(productKey).notifier)
                  .increment()
            : null,
        onDecrement:
            ref.watch(productQuantityProvider(productKey).notifier).canDecrement
            ? () => ref
                  .read(productQuantityProvider(productKey).notifier)
                  .decrement()
            : null,
        inCart: inCart > 0,
        onConfirm: () {
          final cart = ref.read(cartProvider(productKey.brand).notifier);
          final strings = ref.read(stringsProvider);
          final String message;
          if (inCart == 0) {
            cart.add(productKey.id, quantity: quantity);
            message = strings.addedToCart(quantity, product.name);
          } else {
            cart.setQuantity(productKey.id, quantity);
            message = quantity == 0
                ? strings.removedFromCart(product.name)
                : strings.cartUpdated(quantity, product.name);
          }
          ref
              .read(toastProvider.notifier)
              .show(message, brand: productKey.brand);
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
    final pieces = product.pieces;
    final weight = product.weight;
    final size = [
      if (pieces != null) context.l10n.productPieces(pieces),
      if (weight != null)
        _isVolume(weight)
            ? context.l10n.productVolume(weight)
            : context.l10n.productWeight(weight),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(product.name, style: context.textStyles.headline),
        const SizedBox(height: AppSpacing.sm),
        // The price, then how much is in the cart and the portion's size,
        // wrapping under the price when they don't fit beside it.
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.xs),
              child: Text(
                context.l10n.formatLei(product.priceBani),
                style: context.textStyles.priceLarge,
              ),
            ),
            if (inCartCount > 0)
              _Pill(
                label: context.l10n.inCart(inCartCount),
                icon: PhosphorIconsRegular.handbag,
                color: InfoNote.fillOf(context.colors),
                style: context.textStyles.label,
              ),
            for (final fact in size)
              _Pill(
                label: fact,
                color: context.colors.surfaceMuted,
                style: context.textStyles.caption,
              ),
          ],
        ),
        if (description != null) ...[
          const SizedBox(height: AppSpacing.xl),
          Text(
            context.l10n.descriptionTitle,
            style: context.textStyles.subtitle,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(description, style: context.textStyles.bodySecondary),
        ],
      ],
    );
  }
}

/// Whether a product's size is a volume ("0,5L", "330ml", "330мл"), which
/// reads "Volum", not "Masa".
bool _isVolume(String size) =>
    RegExp(r'(ml|l|мл|л)$', caseSensitive: false).hasMatch(size.trim());

/// A small fact about the product next to its price, with an [icon] in the
/// brand's colour when it has one.
class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.color,
    required this.style,
    this.icon,
  });

  final String label;
  final Color color;
  final TextStyle style;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm + AppSpacing.xxs,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon case final icon?) ...[
              Icon(icon, size: 14, color: context.colors.primary),
              const SizedBox(width: AppSpacing.xs),
            ],
            Text(label, style: style),
          ],
        ),
      ),
    );
  }
}

class _AddToCartBar extends StatelessWidget {
  const _AddToCartBar({
    required this.quantity,
    required this.total,
    required this.onIncrement,
    required this.onDecrement,
    required this.inCart,
    required this.onConfirm,
  });

  final int quantity;
  final String total;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  /// Whether the product was in the cart when the screen opened: the bar then
  /// updates the cart instead of adding to it.
  final bool inCart;
  final VoidCallback onConfirm;

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
                incrementLabel: context.l10n.increaseQuantity,
                decrementLabel: context.l10n.decreaseQuantity,
                buttonSize: 42,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppButton(
                  label: !inCart
                      ? context.l10n.addToCartTotal(total)
                      : quantity == 0
                      ? context.l10n.removeFromCartAction
                      : context.l10n.updateCartTotal(total),
                  variant: inCart && quantity == 0
                      ? AppButtonVariant.secondary
                      : AppButtonVariant.primary,
                  onPressed: onConfirm,
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
        // The back button's clear margin takes the place of the padding by it.
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter - TapTarget.iconButtonMargin,
            AppSpacing.gutter - TapTarget.iconButtonMargin,
            AppSpacing.gutter - TapTarget.iconButtonMargin,
            AppSpacing.gutter,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: AppIconButton(
                  icon: PhosphorIconsRegular.arrowLeft,
                  semanticLabel: context.l10n.back,
                  onPressed: onBack,
                ),
              ),
              const Spacer(),
              Icon(
                PhosphorIconsRegular.smileyMeh,
                size: 48,
                color: context.colors.primary,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                context.l10n.productNotFound,
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
