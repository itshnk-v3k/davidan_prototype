import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:davidan_prototype/core/theme/app_assets.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';
import 'package:davidan_prototype/core/widgets/glass_surface.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// The top of a brand's page, as a pinned sliver for its CustomScrollView:
/// liquid glass in the brand's colour from the very top of the phone (behind
/// the status bar) through the button row, with the way back, the brand's logo
/// in white, an optional [title] and the brand's buttons.
///
/// The same glass as the tab bar ([GlassSurface]), tinted with the brand's
/// deep tone: whatever scrolls under it is blurred and shows through only as
/// soft colour, so the white icons and the cart's count stay clear over any
/// photo. A hairline marks its lower edge.
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

  /// The button row's height under the status bar.
  static const rowHeight = TapTarget.min + 2 * AppSpacing.sm;

  /// The white logo each brand shows on its colour.
  static String logoOf(Brand brand) => switch (brand) {
    Brand.restaurant => AppAssets.logoWhite,
    Brand.bakery => AppAssets.logoWhite,
    Brand.sushi => AppAssets.sushiLogoWhite,
    Brand.water => AppAssets.waterLogoWhite,
    Brand.carRental => AppAssets.rentCarLogoWhite,
  };

  /// The header's colour: a deep, quiet tone of the brand's own, so the
  /// page's photos stay the brightest things on it. White reads on each at
  /// 4.5:1 or more.
  static Color colorOf(Brand brand) => switch (brand) {
    Brand.bakery => const Color(0xFFA8651F),
    Brand.restaurant => const Color(0xFF4A3426),
    Brand.sushi => const Color(0xFFBF4128),
    Brand.water => const Color(0xFF1D5DB0),
    Brand.carRental => const Color(0xFF0F7651),
  };

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;

    return PinnedHeaderSliver(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        // Light status bar icons on the brand's colour.
        value: SystemUiOverlayStyle.light,
        child: GlassSurface(
          borderRadius: BorderRadius.zero,
          tint: colorOf(brand),
          border: const Border(
            bottom: BorderSide(color: Color(0x2EFFFFFF), width: 0.8),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: top),
            child: SizedBox(
              height: rowHeight,
              child: _ButtonRow(
                brand: brand,
                onBack: onBack,
                title: title,
                actions: actions,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ButtonRow extends StatelessWidget {
  const _ButtonRow({
    required this.brand,
    required this.onBack,
    required this.title,
    required this.actions,
  });

  final Brand brand;
  final VoidCallback onBack;
  final String? title;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    // The buttons' clear margins take the place of the padding and gaps around
    // them, so their circles sit where they would without them.
    const margin = TapTarget.iconButtonMargin;
    final title = this.title;
    final square = brand == Brand.carRental;

    return AppIconButtonStyle.overlay(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.gutter - margin,
        ),
        child: Row(
          children: [
            AppIconButton(
              icon: PhosphorIconsRegular.arrowLeft,
              semanticLabel: context.l10n.backHome,
              onPressed: onBack,
            ),
            const SizedBox(width: AppSpacing.sm - margin),
            Image.asset(
              BrandHeaderBand.logoOf(brand),
              height: square ? 34 : 26,
              excludeFromSemantics: true,
            ),
            // The title takes all the room up to the buttons: beside a Spacer
            // it would only get half of it.
            if (title != null) ...[
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                // Shrinks a little rather than lose its end, at a large text
                // size on a small phone.
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    // A size down from a screen title, beside the logo.
                    style: context.textStyles.title.copyWith(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                  ),
                ),
              ),
            ] else
              const Spacer(),
            for (final (index, action) in actions.indexed) ...[
              if (index > 0) const SizedBox(width: AppSpacing.sm - 2 * margin),
              action,
            ],
          ],
        ),
      ),
    );
  }
}
