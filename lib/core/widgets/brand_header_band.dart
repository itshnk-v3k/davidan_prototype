import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_assets.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';
import 'package:davidan_prototype/core/widgets/brand_texture.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// The top of a brand's home: the brand's colours as a clean gradient, from
/// the very top of the phone (behind the status bar) down, with the way back, the
/// brand's logo in white, an optional [title] and the brand's buttons.
class BrandHeaderBand extends StatelessWidget {
  const BrandHeaderBand({
    super.key,
    required this.brand,
    required this.onBack,
    this.title,
    this.actions = const [],
  });

  final Brand brand;
  final VoidCallback onBack;

  /// Shown after the logo, for a logo that doesn't spell the brand's name.
  final String? title;

  /// [AppIconButton]s (or built on one), lined up by their circles.
  final List<Widget> actions;

  /// The white logo each brand shows on its colour.
  static String logoOf(Brand brand) => switch (brand) {
    Brand.restaurant => AppAssets.logoWhite,
    Brand.bakery => AppAssets.logoWhite,
    Brand.sushi => AppAssets.sushiLogoWhite,
    Brand.water => AppAssets.waterLogoWhite,
    Brand.carRental => AppAssets.rentCarLogoWhite,
  };

  @override
  Widget build(BuildContext context) {
    // The buttons' clear margins take the place of the padding and gaps around
    // them, so their circles sit where they would without them.
    const margin = TapTarget.iconButtonMargin;
    final title = this.title;
    final square = brand == Brand.carRental;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Light status bar icons on the brand's deep colour.
      value: SystemUiOverlayStyle.light,
      child: BrandSurface(
        brand: brand,
        texture: false,
        child: AppIconButtonStyle.frosted(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.gutter - margin,
              MediaQuery.paddingOf(context).top + AppSpacing.md - margin,
              AppSpacing.gutter - margin,
              AppSpacing.lg - margin,
            ),
            child: Row(
              children: [
                AppIconButton(
                  icon: Icons.arrow_back_rounded,
                  semanticLabel: context.l10n.backHome,
                  onPressed: onBack,
                ),
                const SizedBox(width: AppSpacing.md - margin),
                Image.asset(
                  logoOf(brand),
                  height: square ? 36 : 28,
                  excludeFromSemantics: true,
                ),
                if (title != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Flexible(
                    child: Text(
                      title,
                      style: context.textStyles.title.copyWith(
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
                const Spacer(),
                for (final (index, action) in actions.indexed) ...[
                  if (index > 0)
                    const SizedBox(width: AppSpacing.sm - 2 * margin),
                  action,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
