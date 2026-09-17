import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_assets.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';
import 'package:davidan_prototype/core/widgets/brand_texture.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// The top of a brand's page, as a pinned sliver for its CustomScrollView:
/// the brand's colours from the very top of the phone (behind the status bar)
/// to just under the button row, with the way back, the brand's logo in
/// white, an optional [title] and the brand's buttons.
///
/// It is one piece: a gentle dark shade behind the status bar, the brand's
/// colour, and a soft edge where the colour fades out to nothing. The page
/// starts below that edge, and as it scrolls up it melts away under the soft
/// edge instead of being cut off by a line.
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

  /// How far below the button row the colour fades out.
  static const fadeHeight = AppSpacing.xl;

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
    final top = MediaQuery.paddingOf(context).top;
    final solid = top + rowHeight;
    final height = solid + fadeHeight;

    return PinnedHeaderSliver(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        // Light status bar icons on the brand's deep colour.
        value: SystemUiOverlayStyle.light,
        child: SizedBox(
          height: height,
          child: Stack(
            children: [
              Positioned.fill(
                // The colour and the shade fade out together over the soft
                // edge, so the header ends as one layer.
                child: ShaderMask(
                  blendMode: BlendMode.dstIn,
                  shaderCallback: (bounds) => LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: const [
                      Color(0xFFFFFFFF),
                      Color(0xFFFFFFFF),
                      Color(0x00FFFFFF),
                    ],
                    stops: [0, solid / height, 1],
                  ).createShader(bounds),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      BrandSurface(brand: brand, texture: false),
                      // A gentle shade behind the status bar, gone before the
                      // buttons.
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: top + rowHeight / 2,
                        child: const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0x40000000), Color(0x00000000)],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: top,
                left: 0,
                right: 0,
                height: rowHeight,
                child: _ButtonRow(
                  brand: brand,
                  onBack: onBack,
                  title: title,
                  actions: actions,
                ),
              ),
            ],
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
              icon: Icons.arrow_back_rounded,
              semanticLabel: context.l10n.backHome,
              onPressed: onBack,
            ),
            const SizedBox(width: AppSpacing.sm - margin),
            Image.asset(
              BrandHeaderBand.logoOf(brand),
              height: square ? 34 : 26,
              excludeFromSemantics: true,
            ),
            if (title != null) ...[
              const SizedBox(width: AppSpacing.sm),
              Flexible(
                child: Text(
                  title,
                  style: context.textStyles.title.copyWith(color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
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
