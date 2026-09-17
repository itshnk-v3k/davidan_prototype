import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:davidan_prototype/core/theme/app_assets.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';
import 'package:davidan_prototype/core/widgets/glass_surface.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// The top of a brand's page, as a pinned sliver for its CustomScrollView: a
/// floating bar of liquid glass in the brand's colour, detached from the
/// screen's edges like the tab bar (the same gutters and corners), with the
/// way back, the brand's logo in white, an optional [title] and the brand's
/// buttons.
///
/// It is [GlassSurface] tinted with the brand's deep tone: whatever scrolls
/// under it is strongly blurred and dimmed, so it shows through as soft colour
/// while the white icons and the cart's count stay clear. Behind the status
/// bar, the page's own background fades in over the content, so the status
/// bar's icons read over whatever passes under them.
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

  /// The bar's height: a button's tap area and a little glass round it.
  static const barHeight = TapTarget.min + AppSpacing.sm;

  /// The bar's corners, the tab bar's.
  static const radius = 14.0;

  /// The white logo each brand shows on its colour.
  static String logoOf(Brand brand) => switch (brand) {
    Brand.restaurant => AppAssets.logoWhite,
    Brand.bakery => AppAssets.logoWhite,
    Brand.sushi => AppAssets.sushiLogoWhite,
    Brand.water => AppAssets.waterLogoWhite,
    Brand.carRental => AppAssets.rentCarLogoWhite,
  };

  /// The glass's tint: a deep, saturated tone of the brand's own. White reads
  /// on each at 4.5:1 or more.
  static Color colorOf(Brand brand) => switch (brand) {
    Brand.bakery => const Color(0xFFAE5C00),
    Brand.restaurant => const Color(0xFF4E2E18),
    Brand.sushi => const Color(0xFFC4331A),
    Brand.water => const Color(0xFF1052BE),
    Brand.carRental => const Color(0xFF00754B),
  };

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final background = context.colors.background;
    final dark = Theme.of(context).brightness == Brightness.dark;

    return PinnedHeaderSliver(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        // The status bar sits over the page now, not over the brand's colour.
        value: dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        child: Stack(
          children: [
            // The page's background behind the status bar, fading out by the
            // middle of the bar.
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: top + AppSpacing.sm + barHeight / 2,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        background.withValues(alpha: 0.92),
                        background.withValues(alpha: 0.6),
                        background.withValues(alpha: 0),
                      ],
                      stops: const [0, 0.55, 1],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.gutter,
                top + AppSpacing.sm,
                AppSpacing.gutter,
                AppSpacing.sm,
              ),
              child: GlassSurface(
                borderRadius: BorderRadius.circular(radius),
                tint: colorOf(brand),
                shadow: true,
                child: SizedBox(
                  height: barHeight,
                  child: _ButtonRow(
                    brand: brand,
                    onBack: onBack,
                    title: title,
                    actions: actions,
                  ),
                ),
              ),
            ),
          ],
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
          // The circles sit as far from the glass's sides as from its top.
          horizontal:
              (BrandHeaderBand.barHeight - AppIconButton.defaultSize) / 2 -
              margin,
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
