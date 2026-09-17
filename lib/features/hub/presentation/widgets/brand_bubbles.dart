import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/brand_header_band.dart';
import 'package:davidan_prototype/core/widgets/brand_texture.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/brand_intro.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// The service selector: the brands as a grid of tiles, two to a row in the
/// client's order ([Brand]'s), the last one full width when the count is odd.
/// Each tile is the brand's own surface (colours and texture) with its logo
/// in white and its name, and opens the brand. A brand that isn't open in the
/// app yet says so on its tile.
class BrandBubbles extends StatelessWidget {
  const BrandBubbles({super.key, required this.onOpen});

  final ValueChanged<Brand> onOpen;

  @override
  Widget build(BuildContext context) {
    const brands = Brand.values;
    Widget tile(Brand brand) => _BrandTile(
      brand: brand,
      intro: context.content.introOf(brand),
      onTap: () => onOpen(brand),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        0,
        AppSpacing.gutter,
        AppSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var index = 0; index < brands.length; index += 2) ...[
            if (index > 0) const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(child: tile(brands[index])),
                if (index + 1 < brands.length) ...[
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: tile(brands[index + 1])),
                ],
              ],
            ),
          ],
        ],
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

  static const _height = 136.0;
  static const _radius = AppRadii.lg;

  /// Every logo sits in a slot this tall, so the names line up tile to tile.
  static const _logoSlot = 40.0;

  /// Each logo's size, tuned by eye so they carry the same visual weight: the
  /// wide wordmarks by width, the compact marks by height. A tile narrower
  /// than a wordmark shrinks it to fit.
  static Size _logoSize(Brand brand) => switch (brand) {
    Brand.restaurant || Brand.bakery => const Size(120, 22),
    Brand.sushi => const Size(112, 29),
    Brand.water => const Size(62, 36),
    Brand.carRental => const Size(40, 40),
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final logo = _logoSize(brand);
    final shape = BorderRadius.circular(_radius);

    return Semantics(
      button: true,
      label: intro.comingSoon
          ? context.l10n.brandComingSoonLabel(intro.name)
          : intro.name,
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: shape,
          boxShadow: [
            BoxShadow(
              color: colors.shadow,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: shape,
          child: DecoratedBox(
            // A hairline a shade lighter than the tile's own colours defines
            // its edge.
            position: DecorationPosition.foreground,
            decoration: BoxDecoration(
              borderRadius: shape,
              border: Border.all(color: const Color(0x2EFFFFFF)),
            ),
            child: SizedBox(
              height: _height,
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
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  intro.name,
                                  style: context.textStyles.subtitle.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.2,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (!intro.comingSoon) ...[
                                const SizedBox(width: AppSpacing.sm),
                                const _OpenArrow(),
                              ],
                            ],
                          ),
                          if (intro.comingSoon) ...[
                            const SizedBox(height: AppSpacing.xs),
                            _ComingSoonPill(
                              label: context.l10n.comingSoonTitle,
                            ),
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
      ),
    );
  }
}

/// The frosted look the arrow and the "În curând" pill share.
const _frostFill = Color(0x26FFFFFF);
const _frostBorder = Color(0x4DFFFFFF);

/// A frosted circle with an arrow: the tile opens the brand.
class _OpenArrow extends StatelessWidget {
  const _OpenArrow();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: _frostFill,
        shape: BoxShape.circle,
        border: Border.all(color: _frostBorder),
      ),
      child: const Icon(
        Icons.arrow_forward_rounded,
        color: Colors.white,
        size: 16,
      ),
    );
  }
}

/// "În curând" on a brand's tile, under its name.
class _ComingSoonPill extends StatelessWidget {
  const _ComingSoonPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _frostFill,
        borderRadius: BorderRadius.circular(AppRadii.pill),
        border: Border.all(color: _frostBorder),
      ),
      child: Text(
        label,
        style: context.textStyles.label.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
        maxLines: 1,
      ),
    );
  }
}
