import 'package:flutter/widgets.dart';

/// Motion tokens: how long animations last and how they ease. The app keeps
/// motion to what the platform expects (page transitions, the photo flying to
/// its page, toasts) plus a few quiet fades, and changes everything else at
/// once.
abstract final class AppMotion {
  /// A colour changing: a selected option.
  static const fast = Duration(milliseconds: 150);

  /// Something appearing: a toast sliding in, a photo fading in once decoded.
  static const medium = Duration(milliseconds: 250);

  /// Settling into place.
  static const standard = Curves.easeOutCubic;

  /// [duration], or zero when the device is set to remove animations.
  static Duration of(BuildContext context, Duration duration) =>
      MediaQuery.disableAnimationsOf(context) ? Duration.zero : duration;
}
