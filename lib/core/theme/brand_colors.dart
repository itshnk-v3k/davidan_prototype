import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_palette.dart';
import 'package:davidan_prototype/core/theme/app_theme.dart';
import 'package:davidan_prototype/data/models/brand.dart';

/// Each brand's colours: the app's set for the theme, with the brand's accent
/// in the brand roles (primary, onPrimary, accent, accentSoft). Components,
/// surfaces and text stay the same everywhere; only the accent changes.
///
/// The restaurant and the bakery keep DaviDan's caramel. Sushi and Rent Car
/// share a red, because both sites use the same one, so they are told apart
/// by name and photo, never by colour. Water is the blue of its bottle label.
abstract final class BrandColors {
  static AppColors of(Brand brand, Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final base = dark ? AppColors.dark : AppColors.light;
    return switch (brand) {
      Brand.restaurant || Brand.bakery => base,
      Brand.sushi || Brand.carRental =>
        dark
            ? base.copyWith(
                primary: AppPalette.crimson300,
                onPrimary: AppPalette.crimsonInk,
                accent: AppPalette.crimson500,
                accentSoft: AppPalette.crimson950,
              )
            : base.copyWith(
                primary: AppPalette.crimson700,
                onPrimary: AppPalette.white,
                accent: AppPalette.crimson500,
                accentSoft: AppPalette.crimson100,
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
