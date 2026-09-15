import 'package:flutter/widgets.dart';

/// Colour tokens from davidan.md: the logo's charcoal wordmark and the site's
/// caramel accent (#C3812D), which also matches the product photo backdrops.
abstract final class AppColors {
  // Brand
  /// Buttons, prices, active states. The lightest shade of the site's caramel
  /// that passes WCAG AA (4.5:1) with white text; #C3812D itself reaches 3.2:1.
  static const primary = Color(0xFFA26B25);
  static const onPrimary = Color(0xFFFFFFFF);

  /// The site's caramel. Decoration and large shapes only, never small text.
  static const accent = Color(0xFFC3812D);

  /// Light caramel tint for icon backgrounds, steppers and image placeholders.
  static const accentSoft = Color(0xFFF3E4D0);

  // Surfaces
  static const background = Color(0xFFFCF8F8);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFF3F2EE);
  static const border = Color(0xFFE2E2E2);

  // Text
  /// Logo wordmark colour.
  static const textPrimary = Color(0xFF242430);
  static const textSecondary = Color(0xFF6F6F6F);
  static const textDisabled = Color(0xFFABABAB);

  // Feedback
  /// Form errors and overdue timers. 6.5:1 on white.
  static const error = Color(0xFFB3261E);

  /// Timers getting close to overdue. Amber dark enough for small text:
  /// about 5:1 on white.
  static const warning = Color(0xFFB45309);

  // Text and overlays on photos
  static const onImage = Color(0xFFFFFFFF);
  static const onImageSecondary = Color(0xE6FFFFFF);
  static const scrim = Color(0xB3242430);

  // Desktop presentation
  static const desktopBackdrop = Color(0xFFEDE6DC);
  static const shadow = Color(0x29242430);
}
