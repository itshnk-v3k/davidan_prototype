import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/brand_header_band.dart';
import 'package:davidan_prototype/core/widgets/brand_texture.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/brand_intro.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// The service selector: every brand as a full-width card, one under the
/// other in the client's order ([Brand]'s), each on its own surface (colours
/// and texture) with its logo in white and its name. Tapping a card opens the
/// brand. A brand that isn't open in the app yet says so on its card.
class BrandBubbles extends StatelessWidget {
  const BrandBubbles({super.key, required this.onOpen});

  final ValueChanged<Brand> onOpen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.xs,
        AppSpacing.gutter,
        AppSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (index, brand) in Brand.values.indexed) ...[
            if (index > 0) const SizedBox(height: AppSpacing.md),
            _BrandCard(
              brand: brand,
              intro: context.content.introOf(brand),
              onTap: () => onOpen(brand),
            ),
          ],
        ],
      ),
    );
  }
}

class _BrandCard extends StatelessWidget {
  const _BrandCard({
    required this.brand,
    required this.intro,
    required this.onTap,
  });

  final Brand brand;
  final BrandIntro intro;
  final VoidCallback onTap;

  static const _height = 116.0;
  static const _radius = AppRadii.md;

  /// Every logo sits in a slot this tall, so the names line up card to card.
  static const _logoSlot = 44.0;

  /// Each logo's size, tuned by eye so they carry the same visual weight: the
  /// wide wordmarks by width, the compact marks by height.
  static Size _logoSize(Brand brand) => switch (brand) {
    Brand.restaurant || Brand.bakery => const Size(132, 24),
    Brand.sushi => const Size(124, 32),
    Brand.water => const Size(68, 40),
    Brand.carRental => const Size(44, 44),
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
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        // A hairline a shade lighter than the card's own colours defines its
        // edge.
        position: DecorationPosition.background,
        child: ClipRRect(
          borderRadius: shape,
          child: DecoratedBox(
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg + AppSpacing.xs,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  intro.name,
                                  style: context.textStyles.subtitle.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.2,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          if (intro.comingSoon)
                            _ComingSoonPill(label: context.l10n.comingSoonTitle)
                          else
                            const _OpenArrow(),
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

/// A frosted circle with an arrow: the card opens the brand.
class _OpenArrow extends StatelessWidget {
  const _OpenArrow();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: _frostFill,
        shape: BoxShape.circle,
        border: Border.all(color: _frostBorder),
      ),
      child: const Icon(
        Icons.arrow_forward_rounded,
        color: Colors.white,
        size: 20,
      ),
    );
  }
}

/// "În curând" on a brand's card, as tall as the arrow on the others.
class _ComingSoonPill extends StatelessWidget {
  const _ComingSoonPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
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
