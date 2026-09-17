import 'dart:async';

import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/widgets/app_card.dart';

/// Big cards side by side, swiped one at a time: the first lines up with the
/// page's content and the next peeks in at the right edge, which tells people
/// the row scrolls. A single card takes the content's whole width. Every card
/// keeps the same [aspectRatio], so rows of them look alike from brand to
/// brand. With [autoAdvance] it moves on by itself every few seconds, and a
/// swipe restarts the wait; with reduced motion on, only by hand.
class CardCarousel extends StatefulWidget {
  const CardCarousel({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.aspectRatio,
    this.minHeight = 0,
    this.autoAdvance = false,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  /// A card's width to its height.
  final double aspectRatio;

  /// Room the cards' content needs whatever the phone's width.
  final double minHeight;
  final bool autoAdvance;

  /// How much of the next card shows at the right edge.
  static const peek = 28.0;
  static const gap = AppSpacing.md;

  @override
  State<CardCarousel> createState() => _CardCarouselState();
}

class _CardCarouselState extends State<CardCarousel> {
  static const _interval = Duration(seconds: 4);

  PageController? _controller;
  double? _fraction;
  Timer? _timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _restartTimer();
  }

  @override
  void didUpdateWidget(CardCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.itemCount != widget.itemCount ||
        oldWidget.autoAdvance != widget.autoAdvance) {
      _restartTimer();
    }
  }

  void _restartTimer() {
    _timer?.cancel();
    if (!widget.autoAdvance ||
        widget.itemCount < 2 ||
        MediaQuery.disableAnimationsOf(context)) {
      return;
    }
    _timer = Timer.periodic(_interval, (_) {
      final controller = _controller;
      if (controller == null || !controller.hasClients) return;
      final page = (controller.page ?? 0).round();
      controller.animateToPage(
        (page + 1) % widget.itemCount,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  /// The controller for pages [fraction] of the row wide. A new width (the
  /// phone turned) takes a new one; the old one goes once it's let go.
  PageController _controllerFor(double fraction) {
    final controller = _controller;
    if (controller != null && _fraction == fraction) return controller;
    if (controller != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => controller.dispose());
    }
    _fraction = fraction;
    return _controller = PageController(viewportFraction: fraction);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.itemCount;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final single = count < 2;
        final cardWidth = single
            ? width - 2 * AppSpacing.gutter
            : width - AppSpacing.gutter - CardCarousel.gap - CardCarousel.peek;
        final height = (cardWidth / widget.aspectRatio).clamp(
          widget.minHeight,
          double.infinity,
        );
        // The row starts at the gutter; each page is a card and the gap after
        // it, or a single card and the gutter on its right.
        final rowWidth = width - AppSpacing.gutter;
        final trailing = single ? AppSpacing.gutter : CardCarousel.gap;
        final controller = _controllerFor((cardWidth + trailing) / rowWidth);

        return SizedBox(
          // Room under the cards for their shadows.
          height: height + AppCard.shadowReach,
          child: Padding(
            padding: const EdgeInsets.only(left: AppSpacing.gutter),
            // A swipe by hand restarts the wait before the next card.
            child: NotificationListener<ScrollStartNotification>(
              onNotification: (notification) {
                if (notification.dragDetails != null) _restartTimer();
                return false;
              },
              child: PageView.builder(
                controller: controller,
                padEnds: false,
                // The cards' shadows, and a card on its way out, reach past
                // the row.
                clipBehavior: Clip.none,
                itemCount: count,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(
                    right: trailing,
                    bottom: AppCard.shadowReach,
                  ),
                  child: widget.itemBuilder(context, index),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
