import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_palette.dart';

/// Colour roles. [dark] and [light] give the palette's colours their jobs;
/// widgets read the active set with `context.colors`, so a widget styled once
/// works in both themes. Every text pairing below meets WCAG AA
/// (4.5:1) in both sets.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.primary,
    required this.onPrimary,
    required this.accent,
    required this.accentSoft,
    required this.background,
    required this.surface,
    required this.surfaceMuted,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textDisabled,
    required this.error,
    required this.warning,
    required this.onImage,
    required this.onImageSecondary,
    required this.scrim,
    required this.desktopBackdrop,
    required this.shadow,
    required this.cardOutline,
    required this.cardShadow,
    required this.cardShadowContact,
    required this.edgeScrim,
    required this.star,
  });

  static const dark = AppColors(
    primary: AppPalette.caramel300,
    onPrimary: AppPalette.espresso,
    accent: AppPalette.caramel500,
    accentSoft: AppPalette.caramel950,
    background: AppPalette.ink950,
    surface: AppPalette.ink900,
    surfaceMuted: AppPalette.ink850,
    border: AppPalette.ink800,
    textPrimary: AppPalette.cream,
    textSecondary: AppPalette.stone300,
    textDisabled: AppPalette.stone500,
    error: AppPalette.red200,
    warning: AppPalette.amber300,
    onImage: AppPalette.white,
    onImageSecondary: AppPalette.white90,
    scrim: AppPalette.charcoal70,
    desktopBackdrop: AppPalette.ink700,
    shadow: AppPalette.black40,
    // On the near-black background a card stands apart mostly by its lighter
    // tone; a deep, wide shadow and a faint hairline soften its edge.
    cardOutline: AppPalette.white06,
    cardShadow: AppPalette.black50,
    cardShadowContact: AppPalette.black30,
    edgeScrim: AppPalette.black45,
    star: AppPalette.gold400,
  );

  static const light = AppColors(
    primary: AppPalette.caramel700,
    onPrimary: AppPalette.white,
    accent: AppPalette.caramel500,
    accentSoft: AppPalette.caramel100,
    background: AppPalette.linen,
    surface: AppPalette.white,
    surfaceMuted: AppPalette.oat,
    border: AppPalette.sandLine,
    textPrimary: AppPalette.graphite,
    textSecondary: AppPalette.taupe600,
    textDisabled: AppPalette.taupe400,
    error: AppPalette.red700,
    warning: AppPalette.amber700,
    onImage: AppPalette.white,
    onImageSecondary: AppPalette.white90,
    scrim: AppPalette.charcoal70,
    desktopBackdrop: AppPalette.sand,
    shadow: AppPalette.charcoal16,
    cardOutline: AppPalette.clear,
    cardShadow: AppPalette.charcoal08,
    cardShadowContact: AppPalette.charcoal04,
    edgeScrim: AppPalette.black45,
    star: AppPalette.gold500,
  );

  // Brand
  /// Buttons, prices, links and active states.
  final Color primary;

  /// Text and icons on a [primary] fill.
  final Color onPrimary;

  /// The brand's bright colour. Decoration and large shapes only, never text
  /// or icons.
  final Color accent;

  /// Caramel tint behind icons and image placeholders. Icons on it are
  /// [primary].
  final Color accentSoft;

  // Surfaces
  final Color background;
  final Color surface;
  final Color surfaceMuted;
  final Color border;

  // Text
  final Color textPrimary;

  /// Secondary text, and the outline of an unticked radio button or checkbox
  /// (a control that still works needs 3:1).
  final Color textSecondary;

  /// Disabled controls only, which need no contrast.
  final Color textDisabled;

  // Feedback
  /// Form errors and overdue timers.
  final Color error;

  /// Timers getting close to overdue.
  final Color warning;

  // Text and overlays on photos, the same in both themes
  final Color onImage;
  final Color onImageSecondary;
  final Color scrim;

  // Desktop presentation
  final Color desktopBackdrop;
  final Color shadow;

  // Cards (AppCard)
  /// A card's edge: none on light, where its shadow lifts it; a faint
  /// hairline on dark.
  final Color cardOutline;

  /// A card's wide soft shadow and its faint contact shadow.
  final Color cardShadow;
  final Color cardShadowContact;

  /// The dark fade at the top of a brand's header, behind the status bar and
  /// the buttons (TopScrim), the same in both themes.
  final Color edgeScrim;

  /// The star beside a product's rating. Decoration: the number beside it
  /// carries the rating.
  final Color star;

  @override
  AppColors copyWith({
    Color? primary,
    Color? onPrimary,
    Color? accent,
    Color? accentSoft,
    Color? background,
    Color? surface,
    Color? surfaceMuted,
    Color? border,
    Color? textPrimary,
    Color? textSecondary,
    Color? textDisabled,
    Color? error,
    Color? warning,
    Color? onImage,
    Color? onImageSecondary,
    Color? scrim,
    Color? desktopBackdrop,
    Color? shadow,
    Color? cardOutline,
    Color? cardShadow,
    Color? cardShadowContact,
    Color? edgeScrim,
    Color? star,
  }) => AppColors(
    primary: primary ?? this.primary,
    onPrimary: onPrimary ?? this.onPrimary,
    accent: accent ?? this.accent,
    accentSoft: accentSoft ?? this.accentSoft,
    background: background ?? this.background,
    surface: surface ?? this.surface,
    surfaceMuted: surfaceMuted ?? this.surfaceMuted,
    border: border ?? this.border,
    textPrimary: textPrimary ?? this.textPrimary,
    textSecondary: textSecondary ?? this.textSecondary,
    textDisabled: textDisabled ?? this.textDisabled,
    error: error ?? this.error,
    warning: warning ?? this.warning,
    onImage: onImage ?? this.onImage,
    onImageSecondary: onImageSecondary ?? this.onImageSecondary,
    scrim: scrim ?? this.scrim,
    desktopBackdrop: desktopBackdrop ?? this.desktopBackdrop,
    shadow: shadow ?? this.shadow,
    cardOutline: cardOutline ?? this.cardOutline,
    cardShadow: cardShadow ?? this.cardShadow,
    cardShadowContact: cardShadowContact ?? this.cardShadowContact,
    edgeScrim: edgeScrim ?? this.edgeScrim,
    star: star ?? this.star,
  );

  /// Blends the two sets while MaterialApp animates a theme change.
  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      primary: mix(primary, other.primary),
      onPrimary: mix(onPrimary, other.onPrimary),
      accent: mix(accent, other.accent),
      accentSoft: mix(accentSoft, other.accentSoft),
      background: mix(background, other.background),
      surface: mix(surface, other.surface),
      surfaceMuted: mix(surfaceMuted, other.surfaceMuted),
      border: mix(border, other.border),
      textPrimary: mix(textPrimary, other.textPrimary),
      textSecondary: mix(textSecondary, other.textSecondary),
      textDisabled: mix(textDisabled, other.textDisabled),
      error: mix(error, other.error),
      warning: mix(warning, other.warning),
      onImage: mix(onImage, other.onImage),
      onImageSecondary: mix(onImageSecondary, other.onImageSecondary),
      scrim: mix(scrim, other.scrim),
      desktopBackdrop: mix(desktopBackdrop, other.desktopBackdrop),
      shadow: mix(shadow, other.shadow),
      cardOutline: mix(cardOutline, other.cardOutline),
      cardShadow: mix(cardShadow, other.cardShadow),
      cardShadowContact: mix(cardShadowContact, other.cardShadowContact),
      edgeScrim: mix(edgeScrim, other.edgeScrim),
      star: mix(star, other.star),
    );
  }
}

extension AppColorsContext on BuildContext {
  /// The active theme's colours.
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
