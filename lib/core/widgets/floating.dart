import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_motion.dart';

/// Whether [Floating] moves. Widget tests turn it off: an endless animation
/// never lets pumpAndSettle settle.
final floatingMotionProvider = Provider<bool>((ref) => true);

/// Rises [lift] pixels and settles back, slowly and without end
/// ([AppMotion.float]): a touch of life on the popular row's cards, small
/// enough never to read as something asking to be tapped. Still when the
/// phone's animations are off, and paused with its tab hidden (TickerMode).
class Floating extends ConsumerStatefulWidget {
  const Floating({
    super.key,
    required this.child,
    this.phase = 0,
    this.lift = 3,
  });

  final Widget child;

  /// Where in the rise and fall it starts, from 0 to 1, so cards side by side
  /// don't move in step.
  final double phase;

  final double lift;

  @override
  ConsumerState<Floating> createState() => _FloatingState();
}

class _FloatingState extends ConsumerState<Floating>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: AppMotion.float,
  );

  bool _still = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _still =
        MediaQuery.disableAnimationsOf(context) ||
        !ref.read(floatingMotionProvider);
    if (_still) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        if (_still) return child!;
        final turn = (_controller.value + widget.phase) % 1;
        // A cosine: slowest at the top and the bottom, like something resting
        // on air.
        final rise = (1 - math.cos(turn * 2 * math.pi)) / 2;
        return Transform.translate(
          offset: Offset(0, -rise * widget.lift),
          child: child,
        );
      },
      // The card is drawn once; each frame only moves it.
      child: RepaintBoundary(child: widget.child),
    );
  }
}
