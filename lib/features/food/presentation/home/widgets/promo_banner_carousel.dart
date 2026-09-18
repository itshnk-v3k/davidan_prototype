import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_card.dart';
import 'package:davidan_prototype/core/widgets/card_carousel.dart';
import 'package:davidan_prototype/data/models/promo_banner.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// Banner slides that advance on their own every few seconds and can still be
/// swiped (see [CardCarousel]). Every brand's slides keep the same
/// proportions, whatever the size of the photo behind them.
class PromoBannerCarousel extends StatelessWidget {
  const PromoBannerCarousel({
    super.key,
    required this.banners,
    required this.onBannerTap,
  });

  final List<PromoBanner> banners;
  final ValueChanged<PromoBanner> onBannerTap;

  /// A slide's width to its height: 16:10, near the site's own 16:9 slides,
  /// with room for a two-line headline, the site's line and the button.
  /// Half the height it carried: a hero the depth of a card left the menu
  /// itself below the fold on every brand.
  static const aspectRatio = 3.38;

  /// The least room that text needs.
  static const minHeight = 97.0;

  @override
  Widget build(BuildContext context) {
    return CardCarousel(
      itemCount: banners.length,
      aspectRatio: aspectRatio,
      minHeight: minHeight,
      autoAdvance: true,
      itemBuilder: (context, index) => _BannerSlide(
        banner: banners[index],
        onTap: () => onBannerTap(banners[index]),
      ),
    );
  }
}

/// A slide as an advert: the photo, darkened from the lower left where the
/// text sits, the headline large and bold, the site's line under it, and a
/// button-like "Comandă acum" in the brand's colour. The whole slide opens
/// its category; the button only says so.
class _BannerSlide extends StatelessWidget {
  const _BannerSlide({required this.banner, required this.onTap});

  final PromoBanner banner;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final title = banner.title;
    final subtitle = banner.subtitle;

    return AppCard(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            banner.image,
            fit: BoxFit.cover,
            alignment: Alignment(banner.focusX, 0),
          ),
          if (title != null) ...[
            // Dark under the text from below and from the left, clear towards
            // the top right, where the photo shows as it is.
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    colors.scrim.withValues(alpha: colors.scrim.a * 0.9),
                    colors.scrim.withValues(alpha: 0),
                  ],
                  stops: const [0, 0.9],
                ),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colors.scrim.withValues(alpha: colors.scrim.a * 0.5),
                    colors.scrim.withValues(alpha: 0),
                  ],
                  stops: const [0, 0.7],
                ),
              ),
            ),
            Positioned(
              left: AppSpacing.lg,
              right: AppSpacing.xl,
              bottom: AppSpacing.md,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.textStyles.title.copyWith(
                      fontSize: 17,
                      height: 1.15,
                      letterSpacing: -0.2,
                      color: colors.onImage,
                    ),
                    // What the shorter banner holds: two lines to itself, or
                    // one with the site's line under it.
                    maxLines: subtitle == null ? 2 : 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle,
                      style: context.textStyles.caption.copyWith(
                        fontSize: 12,
                        color: colors.onImageSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.sm),
                  _CallToAction(label: context.l10n.bannerCta),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// The slide's button look: a pill in the brand's colour with an arrow.
class _CallToAction extends StatelessWidget {
  const _CallToAction({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      height: 28,
      padding: const EdgeInsets.only(left: AppSpacing.md, right: AppSpacing.sm),
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: context.textStyles.button.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Icon(PhosphorIconsBold.arrowRight, size: 14, color: colors.onPrimary),
        ],
      ),
    );
  }
}
