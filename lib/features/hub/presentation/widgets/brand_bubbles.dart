import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_card.dart';
import 'package:davidan_prototype/core/widgets/brand_header_band.dart';
import 'package:davidan_prototype/core/widgets/brand_texture.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/brand_intro.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// The service selector: the brands as square tiles, two to a row in the
/// client's order ([Brand]'s), all the same size, the last one centred on its
/// own row when the count is odd. Each tile is the brand's own bright surface
/// (colours and texture) with its logo in white and its name, and opens the
/// brand. A brand that isn't open in the app yet says so on its tile.
class BrandBubbles extends StatelessWidget {
  const BrandBubbles({super.key, required this.onOpen});

  final ValueChanged<Brand> onOpen;

  static const _columns = 2;
  static const _gap = AppSpacing.lg;

  @override
  Widget build(BuildContext context) {
    const brands = Brand.values;
    Widget tile(Brand brand) => AspectRatio(
      aspectRatio: 1,
      child: _BrandTile(
        brand: brand,
        intro: context.content.introOf(brand),
        onTap: () => onOpen(brand),
      ),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        0,
        AppSpacing.gutter,
        AppSpacing.xl,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = (constraints.maxWidth - _gap) / _columns;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var row = 0; row < brands.length; row += _columns) ...[
                if (row > 0) const SizedBox(height: _gap),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (
                      var index = row;
                      index < row + _columns && index < brands.length;
                      index++
                    ) ...[
                      if (index > row) const SizedBox(width: _gap),
                      SizedBox(width: size, child: tile(brands[index])),
                    ],
                  ],
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _BrandTile extends StatelessWidget {
  const _BrandTile({
    required this.brand,
    required this.intro,
    required this.onTap,
  });

  final Brand brand;
  final BrandIntro intro;
  final VoidCallback onTap;

  static const _radius = AppRadii.card;

  /// Every logo sits in a slot this tall, so the names line up tile to tile.
  static const _logoSlot = 40.0;

  /// Each logo's size, tuned by eye so they carry the same visual weight: the
  /// wide wordmarks by width, the compact marks by height. A tile narrower
  /// than a wordmark shrinks it to fit.
  static Size _logoSize(Brand brand) => switch (brand) {
    Brand.restaurant || Brand.bakery => const Size(124, 23),
    Brand.sushi => const Size(118, 31),
    Brand.water => const Size(66, 38),
    Brand.carRental => const Size(40, 40),
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final logo = _logoSize(brand);
    final shape = BorderRadius.circular(_radius);
    final shade = BrandSurface.shadeOf(brand);

    return Semantics(
      button: true,
      label: intro.comingSoon
          ? context.l10n.brandComingSoonLabel(intro.name)
          : intro.name,
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: shape,
          boxShadow: AppCard.shadowsOf(colors),
        ),
        child: ClipRRect(
          borderRadius: shape,
          child: DecoratedBox(
            // A hairline a shade lighter than the tile's own colours defines
            // its edge.
            position: DecorationPosition.foreground,
            decoration: BoxDecoration(
              borderRadius: shape,
              border: Border.all(color: const Color(0x33FFFFFF)),
            ),
            child: BrandSurface(
              brand: brand,
              scrim: true,
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: onTap,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: _logoSlot,
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Image.asset(
                              BrandHeaderBand.logoOf(brand),
                              width: logo.width,
                              height: logo.height,
                              fit: BoxFit.contain,
                              alignment: Alignment.bottomLeft,
                              excludeFromSemantics: true,
                            ),
                          ),
                        ),
                        const Spacer(),
                        // The arrow sits beside the name, on its last line.
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                intro.name,
                                style: context.textStyles.subtitle.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  height: 1.2,
                                  shadows: [
                                    Shadow(
                                      color: shade.withValues(alpha: 0.5),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (!intro.comingSoon) ...[
                              const SizedBox(width: AppSpacing.sm - 2),
                              const _OpenArrow(),
                            ],
                          ],
                        ),
                        if (intro.comingSoon) ...[
                          const SizedBox(height: AppSpacing.xs),
                          _ComingSoonPill(label: context.l10n.comingSoonTitle),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A frosted circle with an arrow: the tile opens the brand.
class _OpenArrow extends StatelessWidget {
  const _OpenArrow();

  @override
  Widget build(BuildContext context) {
    // Small enough to leave a two-word name like "Apă naturală" its room at
    // a large text size on a small phone.
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: _frostFill,
        shape: BoxShape.circle,
        border: Border.all(color: _frostBorder),
      ),
      child: const Icon(
        PhosphorIconsBold.arrowRight,
        color: Colors.white,
        size: 16,
      ),
    );
  }
}

/// The frosted look the arrow and the "În curând" pill share.
const _frostFill = Color(0x26FFFFFF);
const _frostBorder = Color(0x4DFFFFFF);

/// "În curând" on a brand's tile, under its name.
class _ComingSoonPill extends StatelessWidget {
  const _ComingSoonPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: _frostFill,
        borderRadius: BorderRadius.circular(AppRadii.pill),
        border: Border.all(color: _frostBorder),
      ),
      // As wide as the label, not the tile.
      child: Center(
        widthFactor: 1,
        child: Text(
          label,
          style: context.textStyles.label.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
          ),
          maxLines: 1,
        ),
      ),
    );
  }
}
