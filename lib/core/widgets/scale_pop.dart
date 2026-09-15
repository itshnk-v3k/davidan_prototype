import 'package:flutter/widgets.dart';

import 'package:davidan_prototype/core/theme/app_motion.dart';

/// Pops [child] once (grows to [scale] and settles back) whenever [value]
/// changes in a way [shouldPop] accepts: a heart being saved, the cart count
/// going up.
class ScalePop<T> extends StatefulWidget {
  const ScalePop({
    super.key,
    required this.value,
    required this.shouldPop,
    this.scale = 1.3,
    required this.child,
  });

  final T value;

  /// Called only when [value] changed.
  final bool Function(T previous, T current) shouldPop;
  final double scale;
  final Widget child;

  @override
  State<ScalePop<T>> createState() => _ScalePopState<T>();
}

class _ScalePopState<T> extends State<ScalePop<T>>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this);
  late Animation<double> _scale = _buildScale();

  Animation<double> _buildScale() => TweenSequence([
    TweenSequenceItem(
      tween: Tween(
        begin: 1.0,
        end: widget.scale,
      ).chain(CurveTween(curve: Curves.easeOut)),
      weight: 40,
    ),
    TweenSequenceItem(
      tween: Tween(
        begin: widget.scale,
        end: 1.0,
      ).chain(CurveTween(curve: Curves.easeIn)),
      weight: 60,
    ),
  ]).animate(_controller);

  @override
  void didUpdateWidget(ScalePop<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scale != oldWidget.scale) _scale = _buildScale();
    if (widget.value != oldWidget.value &&
        widget.shouldPop(oldWidget.value, widget.value)) {
      _controller
        ..duration = AppMotion.of(context, AppMotion.slow)
        ..forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _scale, child: widget.child);
  }
}
