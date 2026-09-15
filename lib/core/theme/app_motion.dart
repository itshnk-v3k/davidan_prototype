import 'package:flutter/widgets.dart';

/// Motion tokens: how long animations last and how they ease. Every animation
/// picks from these, so the whole app moves at one pace.
abstract final class AppMotion {
  /// Small changes: a number rolling, an icon swapping, a press.
  static const fast = Duration(milliseconds: 150);

  /// Something changing shape: the add button becoming a stepper, a status
  /// pill resizing, a notice sliding in.
  static const medium = Duration(milliseconds: 250);

  /// Entrances and pops that are meant to be noticed.
  static const slow = Duration(milliseconds: 400);

  /// Settling into place.
  static const standard = Curves.easeOutCubic;

  /// Pops, with a slight overshoot.
  static const emphasized = Curves.easeOutBack;

  /// Pressed buttons and cards shrink to this scale.
  static const pressedScale = 0.98;

  /// [duration], or zero when the device is set to remove animations.
  static Duration of(BuildContext context, Duration duration) =>
      MediaQuery.disableAnimationsOf(context) ? Duration.zero : duration;
}
