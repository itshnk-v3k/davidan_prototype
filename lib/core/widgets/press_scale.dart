import 'package:flutter/widgets.dart';

import 'package:davidan_prototype/core/theme/app_motion.dart';

/// Shrinks a button or card slightly while it is pressed.
///
/// [builder] gets the callback to pass as the InkWell's `onHighlightChanged`.
/// The InkWell already knows when a press starts, when a scroll cancels it,
/// and when a button inside the card takes the press instead, so a card
/// doesn't shrink while the grid scrolls or while its heart is tapped.
class PressScale extends StatefulWidget {
  const PressScale({
    super.key,
    required this.builder,
    this.scale = AppMotion.pressedScale,
  });

  final Widget Function(ValueChanged<bool> onHighlightChanged) builder;

  /// How far it shrinks: [AppMotion.pressedScale], or
  /// [AppMotion.pressedScaleButton] for small round buttons.
  final double scale;

  @override
  State<PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<PressScale> {
  bool _pressed = false;

  void _setPressed(bool pressed) {
    if (!mounted || pressed == _pressed) return;
    setState(() => _pressed = pressed);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _pressed ? widget.scale : 1,
      duration: AppMotion.of(context, AppMotion.fast),
      curve: AppMotion.standard,
      child: widget.builder(_setPressed),
    );
  }
}
