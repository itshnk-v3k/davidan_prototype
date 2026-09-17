import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/theme/brand_colors.dart';
import 'package:davidan_prototype/core/utils/money.dart';
import 'package:davidan_prototype/core/widgets/app_card.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';
import 'package:davidan_prototype/data/mock/placeholder_nutrition.dart';
import 'package:davidan_prototype/data/models/product.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/favorite_toggle.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/product_image.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/quantity_stepper.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// What a product card or row shows and does, whichever layout draws it.
class ProductTileData {
  const ProductTileData({
    required this.product,
    required this.quantity,
    required this.favorite,
    required this.onTap,
    required this.onAdd,
    required this.onRemove,
    required this.onToggleFavorite,
    this.heroScope,
    this.brandName,
    this.placeholderRating,
    this.placeholderNutrition,
  });

  final Product product;
  final int quantity;
  final bool favorite;
  final VoidCallback onTap;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onToggleFavorite;

  /// See [ProductImage.heroTagFor].
  final String? heroScope;

  /// The brand's name; null inside the brand's own pages.
  final String? brandName;

  /// PLACEHOLDER, NOT A REAL RATING: see data/mock/placeholder_ratings.dart.
  /// Replace with the product's real average once reviews exist.
  final double? placeholderRating;

  /// PLACEHOLDER, NOT REAL NUTRITION: approximate calories, and a weight for
  /// products whose site gives none. See data/mock/placeholder_nutrition.dart.
  final PlaceholderNutrition? placeholderNutrition;
}

/// Product card, lifted off the page by a soft shadow: photo with a favourite
/// heart, then the name, a line with the rating and the portion (pieces and
/// weight, when the brand's site gives them), and the price with the add
/// button right beside it, which turns into a quantity stepper once the
/// product is in the cart. Tapping anywhere else opens the product; the photo
/// flies to the product page. Shown outside its brand (the hub, favourites),
/// the card names its brand on the photo, since "+" adds to that brand's cart.
/// How many lines the longest of [names] takes in [style] at [width] and the
/// phone's text size, from [min] to [max]: a row or grid of cards makes room
/// for its longest name, so no name is cut off and short names keep cards
/// compact.
int nameLinesFor(
  BuildContext context,
  Iterable<String> names, {
  required TextStyle style,
  required double width,
  required int min,
  required int max,
}) {
  var lines = min;
  final scaler = MediaQuery.textScalerOf(context);
  // As the Text will draw it, over the inherited style.
  final inherited = DefaultTextStyle.of(context).style;
  for (final name in names) {
    if (lines >= max) break;
    final painter = TextPainter(
      text: TextSpan(text: name, style: inherited.merge(style)),
      textDirection: Directionality.of(context),
      textScaler: scaler,
      maxLines: max,
    )..layout(maxWidth: width);
    lines = math.max(lines, painter.computeLineMetrics().length);
    painter.dispose();
  }
  return math.min(lines, max);
}

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.data});

  final ProductTileData data;

  /// The photo's width to its height.
  static const photoAspectRatio = 1.2;

  static const _textPadding = EdgeInsets.only(
    left: AppSpacing.md,
    top: AppSpacing.sm,
  );

  /// The most lines a name takes; past that it ends in an ellipsis.
  static const maxNameLines = 4;

  /// The room right of the name, clear of the card's edge.
  static const _nameEndPadding = AppSpacing.md;

  /// How tall a card [width] wide has to be at the phone's text size: the
  /// photo, as many lines of name as the longest of [names] takes (two at
  /// least), the rating and portion line, and the price row as tall as its
  /// buttons' tap area. Rows and grids size their cards with it, passing
  /// their products' names, so a long name (a Russian one especially) or
  /// large text is never cut off and never pushes the price out of the card.
  static double heightFor(
    BuildContext context,
    double width, {
    Iterable<String> names = const [],
  }) {
    final scaler = MediaQuery.textScalerOf(context);
    final styles = context.textStyles;
    double line(TextStyle style) =>
        scaler.scale(style.fontSize!) * style.height!;
    final nameLines = nameLinesFor(
      context,
      names,
      style: styles.bodyStrong,
      width: width - _textPadding.left - _nameEndPadding,
      min: 2,
      max: maxNameLines,
    );
    return width / photoAspectRatio +
        _textPadding.vertical +
        nameLines * line(styles.bodyStrong) +
        AppSpacing.xxs +
        line(styles.caption) +
        TapTarget.min +
        // Rounding in the text layout, which differs between platforms.
        AppSpacing.sm;
  }

  @override
  Widget build(BuildContext context) {
    final product = data.product;
    // The heart looks this far from the photo's edges; its clear tap margins
    // reach to the edges.
    const heartSize = 32.0;
    const heartOffset = AppSpacing.sm - (TapTarget.min - heartSize) / 2;

    return AppCard(
      onTap: data.onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: photoAspectRatio,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ProductImage(
                  path: product.image,
                  heroTag: ProductImage.heroTagFor(
                    product.key,
                    scope: data.heroScope,
                  ),
                  // The card's own top corners.
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppRadii.card),
                  ),
                ),
                if (data.brandName case final brandName?)
                  Positioned(
                    top: AppSpacing.sm,
                    left: AppSpacing.sm,
                    // Leaves room for the heart.
                    right: AppSpacing.sm + heartSize + AppSpacing.xs,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: _BrandTag(product: product, name: brandName),
                    ),
                  ),
                Positioned(
                  top: heartOffset,
                  right: heartOffset,
                  child: FavoriteToggle(
                    productName: product.name,
                    favorite: data.favorite,
                    onToggle: data.onToggleFavorite,
                    size: heartSize,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: _textPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _NameAndMeta(
                      data: data,
                      style: context.textStyles.bodyStrong,
                      maxLines: maxNameLines,
                      endPadding: _nameEndPadding,
                    ),
                  ),
                  ProductPriceRow(data: data),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A card's name over its rating line, at the top of the space above the
/// price. The name has all of that space to itself: sharing it with a Spacer
/// would halve it and cut the name's letters off.
class _NameAndMeta extends StatelessWidget {
  const _NameAndMeta({
    required this.data,
    required this.style,
    required this.maxLines,
    required this.endPadding,
  });

  final ProductTileData data;
  final TextStyle style;
  final int maxLines;
  final double endPadding;

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.only(right: endPadding);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Gives way rather than overflow if the text ever needs more than
        // heightFor allowed.
        Flexible(
          child: Padding(
            padding: padding,
            child: Text(
              data.product.name,
              style: style,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Padding(padding: padding, child: ProductMetaLine.of(data)),
      ],
    );
  }
}

/// The rating, the weight and the calories, on one quiet line: "★ 4,6 ·
/// 250g · 320 kcal". The rating and calories are placeholders for now, and so
/// is the weight where the brand's site gives none; the site's own weight is
/// shown as it is. None of it is announced, so a screen reader never reads a
/// placeholder as a fact.
class ProductMetaLine extends StatelessWidget {
  const ProductMetaLine({
    super.key,
    required this.product,
    this.placeholderRating,
    this.placeholderNutrition,
    this.style,
    this.withFacts = true,
  });

  /// The line for a card's or row's [data].
  ProductMetaLine.of(ProductTileData data, {Key? key})
    : this(
        key: key,
        product: data.product,
        placeholderRating: data.placeholderRating,
        placeholderNutrition: data.placeholderNutrition,
      );

  final Product product;

  /// PLACEHOLDER, NOT A REAL RATING: see [ProductTileData.placeholderRating].
  final double? placeholderRating;

  /// PLACEHOLDER, NOT REAL NUTRITION: see
  /// [ProductTileData.placeholderNutrition].
  final PlaceholderNutrition? placeholderNutrition;

  /// The caption style when null; the product page's is larger.
  final TextStyle? style;

  /// False for the rating alone: the product page gives the weight and the
  /// calories lines of their own, with labels.
  final bool withFacts;

  /// The weight to show for [product]: the site's own, else the
  /// placeholder's.
  static String? weightOf(
    BuildContext context,
    Product product,
    PlaceholderNutrition? placeholderNutrition,
  ) {
    final real = product.weight;
    if (real != null) return real;
    final nutrition = placeholderNutrition;
    if (nutrition == null) return null;
    return switch (nutrition.placeholderWeightUnit) {
      PlaceholderWeightUnit.grams => context.l10n.placeholderGrams(
        nutrition.placeholderWeight,
      ),
      PlaceholderWeightUnit.millilitres => context.l10n.placeholderMillilitres(
        nutrition.placeholderWeight,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final rating = placeholderRating;
    final calories = placeholderNutrition?.placeholderCalories;
    final base = style ?? context.textStyles.caption;
    final weight = withFacts
        ? weightOf(context, product, placeholderNutrition)
        : null;
    final energy = withFacts && calories != null
        ? context.l10n.calories(calories)
        : null;
    final facts = [?weight, ?energy].join(' · ');

    return ExcludeSemantics(
      child: Row(
        children: [
          if (rating != null) ...[
            Icon(
              PhosphorIconsFill.star,
              size: (base.fontSize ?? 12) + 3,
              color: context.colors.star,
            ),
            const SizedBox(width: AppSpacing.xxs),
            Text(
              rating.toStringAsFixed(1).replaceAll('.', ','),
              style: base.copyWith(
                color: context.colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (facts.isNotEmpty) Text(' · ', style: base),
          ],
          if (facts.isNotEmpty)
            Flexible(
              // The whole line when it fits; otherwise the weight alone
              // rather than a line cut off in the middle. One line tall
              // whatever it shows, which also answers the list row's
              // IntrinsicHeight without laying the text out.
              child: SizedBox(
                height:
                    MediaQuery.textScalerOf(context)
                        .scale(base.fontSize ?? 12) *
                    (base.height ?? 1.3),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final painter = TextPainter(
                      // As the Text will draw it, over the inherited style.
                      text: TextSpan(
                        text: facts,
                        style: DefaultTextStyle.of(context).style.merge(base),
                      ),
                      textDirection: Directionality.of(context),
                      textScaler: MediaQuery.textScalerOf(context),
                      maxLines: 1,
                    )..layout();
                    final fits = painter.width <= constraints.maxWidth;
                    painter.dispose();
                    return Text(
                      fits || weight == null ? facts : weight,
                      style: base,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// The popular row's card: bigger, with the photo as the main thing, then the
/// name, the rating line and the price with the add button.
class FeaturedProductCard extends StatelessWidget {
  const FeaturedProductCard({super.key, required this.data});

  final ProductTileData data;

  static const width = 264.0;
  static const photoAspectRatio = 4 / 3;

  /// The most lines a name takes; past that it ends in an ellipsis.
  static const maxNameLines = 3;

  /// How tall the card is at the phone's text size, with room for the
  /// longest of [names] (one line at least); see [ProductCard.heightFor].
  static double heightFor(
    BuildContext context, {
    Iterable<String> names = const [],
  }) {
    final scaler = MediaQuery.textScalerOf(context);
    final styles = context.textStyles;
    double line(TextStyle style) =>
        scaler.scale(style.fontSize!) * style.height!;
    final nameLines = nameLinesFor(
      context,
      names,
      style: _nameStyle(styles),
      width: width - 2 * AppSpacing.lg,
      min: 1,
      max: maxNameLines,
    );
    return width / photoAspectRatio +
        AppSpacing.md +
        nameLines * line(_nameStyle(styles)) +
        AppSpacing.xxs +
        line(styles.caption) +
        TapTarget.min +
        AppSpacing.sm;
  }

  static TextStyle _nameStyle(AppTextStyles styles) =>
      styles.subtitle.copyWith(fontWeight: FontWeight.w700);

  @override
  Widget build(BuildContext context) {
    final product = data.product;
    const heartSize = 36.0;
    const heartOffset = AppSpacing.md - (TapTarget.min - heartSize) / 2;

    return AppCard(
      radius: AppRadii.card,
      onTap: data.onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: photoAspectRatio,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ProductImage(
                  path: product.image,
                  heroTag: ProductImage.heroTagFor(
                    product.key,
                    scope: data.heroScope,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppRadii.card),
                  ),
                ),
                Positioned(
                  top: heartOffset,
                  right: heartOffset,
                  child: FavoriteToggle(
                    productName: product.name,
                    favorite: data.favorite,
                    onToggle: data.onToggleFavorite,
                    size: heartSize,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.lg,
                top: AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _NameAndMeta(
                      data: data,
                      style: _nameStyle(context.textStyles),
                      maxLines: maxNameLines,
                      endPadding: AppSpacing.lg,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.xs),
                    child: ProductPriceRow(data: data),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The price with the add button right beside it: "+" until the product is in
/// the cart, then a stepper. As tall as the buttons' tap area, and flush with
/// its container's right edge, where the buttons' clear margins take the
/// place of padding.
class ProductPriceRow extends StatelessWidget {
  const ProductPriceRow({super.key, required this.data});

  final ProductTileData data;

  /// The stepper's buttons, smaller than the add button so the price keeps
  /// room beside it on a narrow card.
  static const _stepperButton = 28.0;

  @override
  Widget build(BuildContext context) {
    final product = data.product;
    final quantity = data.quantity;
    // The add button's circle, and the stepper's pill, sit this far from the
    // row's right edge.
    const addMargin = (TapTarget.min - 32) / 2;
    final control = quantity == 0
        ? RoundIconButton(
            icon: PhosphorIconsBold.plus,
            semanticLabel: context.l10n.addToCart(product.name),
            onTap: data.onAdd,
          )
        : Padding(
            padding: EdgeInsets.only(
              right: addMargin - QuantityStepper.outsetFor(_stepperButton),
            ),
            child: QuantityStepper(
              quantity: quantity,
              onIncrement: data.onAdd,
              onDecrement: data.onRemove,
              incrementLabel: context.l10n.addToCart(product.name),
              decrementLabel: context.l10n.removeOneFromCart(product.name),
              buttonSize: _stepperButton,
            ),
          );

    return SizedBox(
      height: TapTarget.min,
      child: Row(
        children: [
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                context.l10n.formatLei(product.priceBani),
                style: context.textStyles.price,
                maxLines: 1,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          control,
        ],
      ),
    );
  }
}

/// The product as a wide row: its photo on the left with the heart, and
/// beside it the brand (outside its pages), the name, the rating and portion,
/// the ingredients when the site lists them, and the price with the add
/// button.
class ProductListTile extends StatelessWidget {
  const ProductListTile({super.key, required this.data});

  final ProductTileData data;

  static const _photoSize = 116.0;

  @override
  Widget build(BuildContext context) {
    final product = data.product;
    final description = product.description;
    // As on the card: the heart's clear tap margins reach the photo's edges.
    const heartSize = 32.0;
    const heartOffset = AppSpacing.sm - (TapTarget.min - heartSize) / 2;

    return AppCard(
      onTap: data.onTap,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox.square(
                  dimension: _photoSize,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ProductImage(
                        path: product.image,
                        heroTag: ProductImage.heroTagFor(
                          product.key,
                          scope: data.heroScope,
                        ),
                        borderRadius: BorderRadius.circular(AppRadii.sm),
                      ),
                      Positioned(
                        top: heartOffset,
                        right: heartOffset,
                        child: FavoriteToggle(
                          productName: product.name,
                          favorite: data.favorite,
                          onToggle: data.onToggleFavorite,
                          size: heartSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: AppSpacing.xs,
                  top: AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (data.brandName case final brandName?)
                      Text(
                        brandName,
                        style: context.textStyles.caption.copyWith(
                          color: _brandColor(context, product),
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.md),
                      child: Text(
                        product.name,
                        style: context.textStyles.bodyStrong,
                        // The row grows to fit a third line.
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.md),
                      child: ProductMetaLine.of(data),
                    ),
                    if (description != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.md),
                        child: Text(
                          description,
                          style: context.textStyles.caption,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                    const Spacer(),
                    ProductPriceRow(data: data),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _brandColor(BuildContext context, Product product) =>
    BrandColors.of(product.key.brand, Theme.of(context).brightness).primary;

/// A brand's name in its colour, on a pill that stays readable over any photo.
class _BrandTag extends StatelessWidget {
  const _BrandTag({required this.product, required this.name});

  final Product product;
  final String name;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs,
        ),
        child: Text(
          name,
          style: context.textStyles.label.copyWith(
            color: _brandColor(context, product),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
