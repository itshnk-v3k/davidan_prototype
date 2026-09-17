import 'dart:async';

import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/data/models/promo_banner.dart';

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
      height: 172,
      // A swipe by hand restarts the wait before the next slide.
      child: NotificationListener<ScrollStartNotification>(
        onNotification: (notification) {
          if (notification.dragDetails != null) _restartTimer();
          return false;
        },
        child: PageView.builder(
          controller: _controller,
          itemCount: banners.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
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
                      context.colors.scrim.withValues(alpha: 0),
                      context.colors.scrim,
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
                      style: context.textStyles.title.copyWith(
                        color: context.colors.onImage,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        subtitle,
                        style: context.textStyles.body.copyWith(
                          color: context.colors.onImageSecondary,
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
