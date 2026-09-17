import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_palette.dart';
import 'package:davidan_prototype/core/theme/app_theme.dart';
import 'package:davidan_prototype/data/models/brand.dart';

/// Each brand's colours: the app's set for the theme, with the brand's accent
/// in the brand roles (primary, onPrimary, accent, accentSoft). Components,
/// surfaces and text stay the same everywhere; only the accent changes.
///
/// The restaurant and the bakery keep DaviDan's caramel. Sushi is a warm
/// vermilion and Rent Car an emerald green: their sites share one red, but in
/// the app they need telling apart at a glance. Water is the blue of its
/// bottle label.
abstract final class BrandColors {
  /// The brand's colour as a surface of its own (the hub's bubbles, a brand's
  /// header band), the same in both themes. The deep tones, so white logos
  /// and text on them read at 4.5:1 or more.
  static Color fillOf(Brand brand) => switch (brand) {
    Brand.restaurant || Brand.bakery => AppPalette.caramel700,
    Brand.sushi => AppPalette.vermilion700,
    Brand.carRental => AppPalette.emerald700,
    Brand.water => AppPalette.blue700,
  };

  static AppColors of(Brand brand, Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final base = dark ? AppColors.dark : AppColors.light;
    return switch (brand) {
      Brand.restaurant || Brand.bakery => base,
      Brand.sushi =>
        dark
            ? base.copyWith(
                primary: AppPalette.vermilion300,
                onPrimary: AppPalette.vermilionInk,
                accent: AppPalette.vermilion500,
                accentSoft: AppPalette.vermilion950,
              )
            : base.copyWith(
                primary: AppPalette.vermilion700,
                onPrimary: AppPalette.white,
                accent: AppPalette.vermilion500,
                accentSoft: AppPalette.vermilion100,
              ),
      Brand.carRental =>
        dark
            ? base.copyWith(
                primary: AppPalette.emerald300,
                onPrimary: AppPalette.emeraldInk,
                accent: AppPalette.emerald500,
                accentSoft: AppPalette.emerald950,
              )
            : base.copyWith(
                primary: AppPalette.emerald700,
                onPrimary: AppPalette.white,
                accent: AppPalette.emerald500,
                accentSoft: AppPalette.emerald100,
              ),
      Brand.water =>
        dark
            ? base.copyWith(
                primary: AppPalette.blue300,
                onPrimary: AppPalette.blueInk,
                accent: AppPalette.blue300,
                accentSoft: AppPalette.blue950,
              )
            : base.copyWith(
                primary: AppPalette.blue700,
                onPrimary: AppPalette.white,
                accent: AppPalette.blue700,
                accentSoft: AppPalette.blue100,
              ),
    };
  }
}

/// Gives a brand's pages its colours. The router wraps every `/b/:brand`
/// screen in one, so the screens themselves keep reading `context.colors`.
class BrandTheme extends StatelessWidget {
  const BrandTheme({super.key, required this.brand, required this.child});

  final Brand brand;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = BrandColors.of(brand, theme.brightness);
    // DaviDan's own colours need no second theme, which also keeps the app's
    // animated switch between dark and light.
    if (identical(colors, AppColors.dark) ||
        identical(colors, AppColors.light)) {
      return child;
    }
    return Theme(
      data: AppTheme.forBrand(brand, theme.brightness),
      child: child,
    );
  }
}
