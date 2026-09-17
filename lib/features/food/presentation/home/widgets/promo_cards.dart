import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_card.dart';
import 'package:davidan_prototype/data/mock/demo_promos.dart';
import 'package:davidan_prototype/data/models/menu_category.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// A brand's promo cards, one under the other and each the full width, so
/// every card shows whole: each a discount on one category, with the
/// category's photo, opening that category. Demo content (see
/// demo_promos.dart).
class PromoCards extends StatelessWidget {
  const PromoCards({super.key, required this.promos, required this.onOpen});

  /// Each promo with its category.
  final List<(DemoPromo, MenuCategory)> promos;
  final ValueChanged<MenuCategory> onOpen;

  static const _height = 112.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (index, (promo, category)) in promos.indexed) ...[
            if (index > 0) const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: _height,
              child: _PromoCard(
                promo: promo,
                category: category,
                onTap: () => onOpen(category),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

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

    return AppCard(
      radius: AppRadii.card,
      color: colors.accentSoft,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
              ),
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
                    style: context.textStyles.bodyStrong,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          category.name,
                          style: context.textStyles.caption.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Icon(
                        PhosphorIconsBold.arrowRight,
                        size: 14,
                        color: colors.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // The category's photo, fading into the card on its left edge.
          SizedBox(
            width: 120,
            child: ShaderMask(
              blendMode: BlendMode.dstIn,
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0x00FFFFFF), Color(0xFFFFFFFF)],
                stops: [0, 0.35],
              ).createShader(bounds),
              child: Image.asset(category.image, fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }
}
