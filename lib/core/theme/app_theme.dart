import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/theme/brand_colors.dart';
import 'package:davidan_prototype/data/models/brand.dart';

/// The two themes, built by one function from their token sets.
///
/// The tokens ride along as ThemeExtensions: screens style themselves with
/// `context.colors` and `context.textStyles`. Material widgets (ripples,
/// cursors, text fields) still read ThemeData for their defaults, so the
/// tokens are mapped onto it too and no Material purple leaks in.
abstract final class AppTheme {
  static ThemeData dark() =>
      _build(Brightness.dark, AppColors.dark, AppTextStyles.dark);

  static ThemeData light() =>
      _build(Brightness.light, AppColors.light, AppTextStyles.light);

  /// The theme for [brightness] in [brand]'s colours (BrandColors), built
  /// once per brand and brightness.
  static ThemeData forBrand(Brand brand, Brightness brightness) =>
      _brandThemes.putIfAbsent((brand, brightness), () {
        final colors = BrandColors.of(brand, brightness);
        return _build(brightness, colors, AppTextStyles.from(colors));
      });

  static final _brandThemes = <(Brand, Brightness), ThemeData>{};

  static ThemeData _build(
    Brightness brightness,
    AppColors colors,
    AppTextStyles textStyles,
  ) {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: colors.primary,
          brightness: brightness,
          dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
        ).copyWith(
          primary: colors.primary,
          onPrimary: colors.onPrimary,
          secondary: colors.accent,
          surface: colors.surface,
          onSurface: colors.textPrimary,
          onSurfaceVariant: colors.textSecondary,
          outline: colors.border,
          error: colors.error,
        );

    return ThemeData(
      fontFamily: AppTextStyles.fontFamily,
      colorScheme: colorScheme,
      extensions: [colors, textStyles],
      scaffoldBackgroundColor: colors.background,
      dividerColor: colors.border,
      splashFactory: InkRipple.splashFactory,
      splashColor: colors.accentSoft,
      highlightColor: Colors.transparent,
      // One page transition on every platform, so the web demo and the
      // Android app feel the same: Android's zoom, 300 ms. Flutter's newer
      // default (fade forwards) takes 450 ms and dips through the background
      // on the way; the zoom is shorter, and on phones it animates snapshots
      // of the two pages, which keeps it smooth on older devices.
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          for (final platform in TargetPlatform.values)
            platform: ZoomPageTransitionsBuilder(
              backgroundColor: colors.background,
            ),
        },
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colors.primary,
        selectionHandleColor: colors.primary,
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: colors.surface,
        labelStyle: textStyles.bodySecondary,
        hintStyle: textStyles.bodySecondary,
        errorStyle: textStyles.caption.copyWith(color: colors.error),
        prefixIconColor: colors.textSecondary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        border: _inputBorder(colors.border),
        enabledBorder: _inputBorder(colors.border),
        focusedBorder: _inputBorder(colors.primary, width: 2),
        errorBorder: _inputBorder(colors.error),
        focusedErrorBorder: _inputBorder(colors.error, width: 2),
      ),
    );
  }

  static OutlineInputBorder _inputBorder(Color color, {double width = 1}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.md),
        borderSide: BorderSide(color: color, width: width),
      );
}
