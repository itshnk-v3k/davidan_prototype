import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_card.dart';
import 'package:davidan_prototype/core/widgets/card_carousel.dart';
import 'package:davidan_prototype/data/mock/demo_promos.dart';
import 'package:davidan_prototype/data/models/menu_category.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// A brand's promo cards as big photo cards in a row swiped sideways, like
/// the banners above them (see [CardCarousel]): each a discount on one
/// category, over the category's photo, opening that category. Demo content
/// (see demo_promos.dart).
class PromoCards extends StatelessWidget {
  const PromoCards({super.key, required this.promos, required this.onOpen});

  /// Each promo with its category.
  final List<(DemoPromo, MenuCategory)> promos;
  final ValueChanged<MenuCategory> onOpen;

  /// A card's width to its height: wide, with the category's photo whole
  /// enough to recognise.
  static const aspectRatio = 2.0;

  /// The least room the badge, the line and the link need.
  static const minHeight = 150.0;

  @override
  Widget build(BuildContext context) {
    return CardCarousel(
      itemCount: promos.length,
      aspectRatio: aspectRatio,
      minHeight: minHeight,
      itemBuilder: (context, index) {
        final (promo, category) = promos[index];
        return _PromoCard(
          promo: promo,
          category: category,
          onTap: () => onOpen(category),
        );
      },
    );
  }
}

/// The category's photo across the whole card, darkened from the left where
/// the discount, "Reducere specială" and the category's link sit.
class _PromoCard extends StatelessWidget {
  const _PromoCard({
    required this.promo,
    required this.category,
    required this.onTap,
  });

  final DemoPromo promo;
  final MenuCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final scrim = colors.scrim;

    return AppCard(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            category.image,
            fit: BoxFit.cover,
            alignment: const Alignment(0.4, 0),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  scrim.withValues(alpha: scrim.a * 1.2),
                  scrim.withValues(alpha: scrim.a * 0.7),
                  scrim.withValues(alpha: 0),
                ],
                stops: const [0, 0.45, 0.85],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.62,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm + AppSpacing.xxs,
                      vertical: AppSpacing.xxs,
                    ),
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(AppRadii.sm),
                    ),
                    child: Text(
                      context.l10n.discountPercent(promo.percent),
                      style: context.textStyles.title.copyWith(
                        color: colors.onPrimary,
                        height: 1.15,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    context.l10n.specialDiscount,
                    style: context.textStyles.subtitle.copyWith(
                      color: colors.onImage,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          category.name,
                          style: context.textStyles.bodyStrong.copyWith(
                            color: colors.onImage,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Icon(
                        PhosphorIconsBold.arrowRight,
                        size: 16,
                        color: colors.onImage,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
