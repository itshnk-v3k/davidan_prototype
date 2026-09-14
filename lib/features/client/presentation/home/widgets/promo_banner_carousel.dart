import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/data/models/promo_banner.dart';

/// Swipeable banner slides with page dots. The current page index is local
/// UI state, so it lives in the widget rather than in a Notifier.
class PromoBannerCarousel extends StatefulWidget {
  const PromoBannerCarousel({
    super.key,
    required this.banners,
    required this.onBannerTap,
  });

  final List<PromoBanner> banners;
  final ValueChanged<PromoBanner> onBannerTap;

  @override
  State<PromoBannerCarousel> createState() => _PromoBannerCarouselState();
}

class _PromoBannerCarouselState extends State<PromoBannerCarousel> {
  final _controller = PageController(viewportFraction: 0.92);
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final banners = widget.banners;

    return Column(
      children: [
        SizedBox(
          height: 172,
          child: PageView.builder(
            controller: _controller,
            itemCount: banners.length,
            onPageChanged: (page) => setState(() => _page = page),
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: _BannerSlide(
                banner: banners[index],
                onTap: () => widget.onBannerTap(banners[index]),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < banners.length; i++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: i == _page ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: i == _page ? AppColors.primary : AppColors.border,
                  borderRadius: BorderRadius.circular(AppRadii.pill),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _BannerSlide extends StatelessWidget {
  const _BannerSlide({required this.banner, required this.onTap});

  final PromoBanner banner;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final title = banner.title;
    final subtitle = banner.subtitle;

    return Material(
      borderRadius: BorderRadius.circular(AppRadii.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(banner.image, fit: BoxFit.cover),
            if (title != null) ...[
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.scrim.withValues(alpha: 0),
                      AppColors.scrim,
                    ],
                    stops: const [0.3, 1],
                  ),
                ),
              ),
              Positioned(
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                bottom: AppSpacing.lg,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.title.copyWith(
                        color: AppColors.onImage,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        subtitle,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.onImageSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
