import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';

/// Typography tokens. Sizes and weights are written once in [AppTextStyles.from];
/// each theme's set only differs by the colours it is built from. Widgets read
/// the active set with `context.textStyles`.
///
/// Roboto is bundled in assets/fonts/ so the web demo works without internet;
/// replace [fontFamily] when the client provides brand fonts.
@immutable
class AppTextStyles extends ThemeExtension<AppTextStyles> {
  const AppTextStyles({
    required this.display,
    required this.headline,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.bodyStrong,
    required this.bodySecondary,
    required this.label,
    required this.caption,
    required this.price,
    required this.priceLarge,
    required this.button,
    required this.badge,
  });

  factory AppTextStyles.from(AppColors colors) => AppTextStyles(
    display: TextStyle(
      fontSize: 28,
      height: 1.2,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.4,
      color: colors.textPrimary,
    ),
    headline: TextStyle(
      fontSize: 24,
      height: 1.2,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.2,
      color: colors.textPrimary,
    ),
    title: TextStyle(
      fontSize: 20,
      height: 1.25,
      fontWeight: FontWeight.w700,
      color: colors.textPrimary,
    ),
    subtitle: TextStyle(
      fontSize: 16,
      height: 1.3,
      fontWeight: FontWeight.w600,
      color: colors.textPrimary,
    ),
    body: TextStyle(
      fontSize: 14,
      height: 1.4,
      fontWeight: FontWeight.w400,
      color: colors.textPrimary,
    ),
    bodyStrong: TextStyle(
      fontSize: 14,
      height: 1.35,
      fontWeight: FontWeight.w600,
      color: colors.textPrimary,
    ),
    bodySecondary: TextStyle(
      fontSize: 14,
      height: 1.4,
      fontWeight: FontWeight.w400,
      color: colors.textSecondary,
    ),
    label: TextStyle(
      fontSize: 12,
      height: 1.2,
      fontWeight: FontWeight.w600,
      color: colors.textPrimary,
    ),
    caption: TextStyle(
      fontSize: 12,
      height: 1.3,
      fontWeight: FontWeight.w400,
      color: colors.textSecondary,
    ),
    price: TextStyle(
      fontSize: 15,
      height: 1.2,
      fontWeight: FontWeight.w700,
      color: colors.textPrimary,
    ),
    priceLarge: TextStyle(
      fontSize: 20,
      height: 1.2,
      fontWeight: FontWeight.w700,
      color: colors.primary,
    ),
    button: TextStyle(
      fontSize: 15,
      height: 1.2,
      fontWeight: FontWeight.w600,
      color: colors.onPrimary,
    ),
    badge: TextStyle(
      fontSize: 11,
      height: 1,
      fontWeight: FontWeight.w700,
      color: colors.onPrimary,
    ),
  );

  static final dark = AppTextStyles.from(AppColors.dark);
  static final light = AppTextStyles.from(AppColors.light);

  /// Applied app-wide through AppTheme. If a brand font replaces it, keep
  /// Roboto bundled too: Flutter web otherwise downloads Roboto from
  /// fonts.gstatic.com as its fallback font.
  static const fontFamily = 'Roboto';

  final TextStyle display;
  final TextStyle headline;
  final TextStyle title;
  final TextStyle subtitle;
  final TextStyle body;
  final TextStyle bodyStrong;
  final TextStyle bodySecondary;
  final TextStyle label;
  final TextStyle caption;
  final TextStyle price;
  final TextStyle priceLarge;
  final TextStyle button;
  final TextStyle badge;

  @override
  AppTextStyles copyWith({
    TextStyle? display,
    TextStyle? headline,
    TextStyle? title,
    TextStyle? subtitle,
    TextStyle? body,
    TextStyle? bodyStrong,
    TextStyle? bodySecondary,
    TextStyle? label,
    TextStyle? caption,
    TextStyle? price,
    TextStyle? priceLarge,
    TextStyle? button,
    TextStyle? badge,
  }) => AppTextStyles(
    display: display ?? this.display,
    headline: headline ?? this.headline,
    title: title ?? this.title,
    subtitle: subtitle ?? this.subtitle,
    body: body ?? this.body,
    bodyStrong: bodyStrong ?? this.bodyStrong,
    bodySecondary: bodySecondary ?? this.bodySecondary,
    label: label ?? this.label,
    caption: caption ?? this.caption,
    price: price ?? this.price,
    priceLarge: priceLarge ?? this.priceLarge,
    button: button ?? this.button,
    badge: badge ?? this.badge,
  );

  /// Blends the two sets while MaterialApp animates a theme change.
  @override
  AppTextStyles lerp(AppTextStyles? other, double t) {
    if (other == null) return this;
    TextStyle mix(TextStyle a, TextStyle b) => TextStyle.lerp(a, b, t)!;
    return AppTextStyles(
      display: mix(display, other.display),
      headline: mix(headline, other.headline),
      title: mix(title, other.title),
      subtitle: mix(subtitle, other.subtitle),
      body: mix(body, other.body),
      bodyStrong: mix(bodyStrong, other.bodyStrong),
      bodySecondary: mix(bodySecondary, other.bodySecondary),
      label: mix(label, other.label),
      caption: mix(caption, other.caption),
      price: mix(price, other.price),
      priceLarge: mix(priceLarge, other.priceLarge),
      button: mix(button, other.button),
      badge: mix(badge, other.badge),
    );
  }
}

extension AppTextStylesContext on BuildContext {
  /// The active theme's text styles.
  AppTextStyles get textStyles => Theme.of(this).extension<AppTextStyles>()!;
}
