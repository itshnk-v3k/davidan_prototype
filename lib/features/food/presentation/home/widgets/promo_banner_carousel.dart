import 'dart:async';

import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_card.dart';
import 'package:davidan_prototype/data/models/promo_banner.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// Banner slides that advance on their own every few seconds and can still be
/// swiped. A swipe restarts the wait. With reduced motion on, they only move
/// by hand.
class PromoBannerCarousel extends StatefulWidget {
  const PromoBannerCarousel({
    super.key,
    required this.banners,
    required this.onBannerTap,
  });

  final List<PromoBanner> banners;
  final ValueChanged<PromoBanner> onBannerTap;

  /// Room for a two-line headline, the site's line and the button.
  static const height = 204.0;

  @override
  State<PromoBannerCarousel> createState() => _PromoBannerCarouselState();
}

class _PromoBannerCarouselState extends State<PromoBannerCarousel> {
  static const _interval = Duration(seconds: 4);

  final _controller = PageController(viewportFraction: 0.92);
  Timer? _timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _restartTimer();
  }

  @override
  void didUpdateWidget(PromoBannerCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.banners.length != widget.banners.length) _restartTimer();
  }

  void _restartTimer() {
    _timer?.cancel();
    if (widget.banners.length < 2 || MediaQuery.disableAnimationsOf(context)) {
      return;
    }
    _timer = Timer.periodic(_interval, (_) {
      if (!_controller.hasClients) return;
      final page = (_controller.page ?? 0).round();
      _controller.animateToPage(
        (page + 1) % widget.banners.length,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final banners = widget.banners;

    return SizedBox(
      // Room under the slides for their shadows.
      height: PromoBannerCarousel.height + AppCard.shadowReach,
      // A swipe by hand restarts the wait before the next slide.
      child: NotificationListener<ScrollStartNotification>(
        onNotification: (notification) {
          if (notification.dragDetails != null) _restartTimer();
          return false;
        },
        child: PageView.builder(
          controller: _controller,
          // The slides' shadows reach past the row.
          clipBehavior: Clip.none,
          itemCount: banners.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.xs,
              right: AppSpacing.xs,
              bottom: AppCard.shadowReach,
            ),
            child: _BannerSlide(
              banner: banners[index],
              onTap: () => widget.onBannerTap(banners[index]),
            ),
          ),
        ),
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
          Image.asset(banner.image, fit: BoxFit.cover),
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
              bottom: AppSpacing.lg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.textStyles.title.copyWith(
                      fontSize: 22,
                      height: 1.15,
                      letterSpacing: -0.2,
                      color: colors.onImage,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle,
                      style: context.textStyles.caption.copyWith(
                        fontSize: 13,
                        color: colors.onImageSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.md),
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
      height: 36,
      padding: const EdgeInsets.only(left: AppSpacing.lg, right: AppSpacing.md),
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
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Icon(Icons.arrow_forward_rounded, size: 18, color: colors.onPrimary),
        ],
      ),
    );
  }
}
