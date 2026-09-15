import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';

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
      // Android app feel the same: new pages fade forwards. On Android the
      // back gesture also previews the page underneath (predictive back).
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          for (final platform in TargetPlatform.values)
            platform: platform == TargetPlatform.android
                ? PredictiveBackPageTransitionsBuilder(
                    fallbackColor: colors.background,
                  )
                : FadeForwardsPageTransitionsBuilder(
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
