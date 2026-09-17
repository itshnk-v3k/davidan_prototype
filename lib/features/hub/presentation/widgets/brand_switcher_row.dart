import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_assets.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/theme/brand_colors.dart';
import 'package:davidan_prototype/core/widgets/brand_texture.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// The service selector inside Acasă: the five brands as round bubbles in the
/// client's order ([Brand]'s), each the brand's own bright surface with its
/// white logo and its name underneath, scrolling sideways when they don't all
/// fit. Tapping one swaps the feed below without leaving the shell, the way
/// Glovo and Yandex Eda switch between their verticals.
///
/// The open brand's bubble carries a ring in its own colour and its name is
/// set in it; the others stay quiet. A brand that isn't open in the app yet
/// (the restaurant) still opens, on its "În curând" page.
class BrandSwitcherRow extends StatelessWidget {
  const BrandSwitcherRow({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final Brand selected;
  final ValueChanged<Brand> onSelected;

  /// The bubble's own diameter, without the ring around it.
  static const bubbleSize = 52.0;

  /// The hairline round a bubble, a shade lighter than its own colour: what
  /// holds its shape where the brand's deep tone is close to the page's.
  static const bubbleRim = Color(0x33FFFFFF);

  /// Between the bubble and the ring, so the ring reads as a ring.
  static const _ringGap = 3.0;
  static const _ringWidth = 2.0;
  static const _ringRoom = _ringGap + _ringWidth;

  /// How tall the whole row is: the ring's room, the bubble, the gap and two
  /// lines of name at the largest text size the app allows.
  static double heightFor(BuildContext context) =>
      2 * _ringRoom +
      bubbleSize +
      AppSpacing.xs +
      _nameHeight * MediaQuery.textScalerOf(context).scale(1);

  /// Two lines of the label style at its own height.
  static const _nameHeight = 30.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: heightFor(context),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        // The rings reach past the bubbles.
        clipBehavior: Clip.none,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
        itemCount: Brand.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) {
          final brand = Brand.values[index];
          return _BrandBubble(
            brand: brand,
            name: context.content.introOf(brand).name,
            selected: brand == selected,
            onTap: () => onSelected(brand),
          );
        },
      ),
    );
  }
}

class _BrandBubble extends StatelessWidget {
  const _BrandBubble({
    required this.brand,
    required this.name,
    required this.selected,
    required this.onTap,
  });

  final Brand brand;
  final String name;
  final bool selected;
  final VoidCallback onTap;

  /// Each white logo's size inside the bubble, by eye so they carry the same
  /// weight: the wide wordmarks by width, the compact marks by height.
  static Size _logoSize(Brand brand) => switch (brand) {
    Brand.restaurant || Brand.bakery => const Size(38, 8),
    Brand.sushi => const Size(36, 11),
    Brand.water => const Size(20, 13),
    Brand.carRental => const Size(22, 22),
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    // The brand's own colour, not the theme's: the ring marks which brand is
    // open even while the feed below is already in that brand's colours.
    final ring = BrandColors.of(brand, Theme.of(context).brightness).primary;
    final logo = _logoSize(brand);
    const size = BrandSwitcherRow.bubbleSize;
    const room = BrandSwitcherRow._ringRoom;

    return Semantics(
      button: true,
      selected: selected,
      label: name,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onTap,
        radius: size / 2 + room,
        child: SizedBox(
          // Wide enough for a two-word name like "Apă naturală" without
          // squeezing the bubbles together.
          width: size + 2 * room + AppSpacing.md,
          child: Column(
            children: [
              SizedBox(
                width: size + 2 * room,
                height: size + 2 * room,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected ? ring : Colors.transparent,
                      width: BrandSwitcherRow._ringWidth,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(room),
                    child: ClipOval(
                      child: DecoratedBox(
                        // A hairline a shade lighter than the bubble's own
                        // colour defines its edge, as the brand cards had it:
                        // the deep water blue alone doesn't separate from the
                        // dark theme's page (theme_contrast_test).
                        position: DecorationPosition.foreground,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.fromBorderSide(
                            BorderSide(color: BrandSwitcherRow.bubbleRim),
                          ),
                        ),
                        child: BrandSurface(
                          brand: brand,
                          // A pattern this small would only read as noise.
                          texture: false,
                          child: Center(
                            child: Image.asset(
                              BrandMarks.whiteLogoOf(brand),
                              width: logo.width,
                              height: logo.height,
                              fit: BoxFit.contain,
                              excludeFromSemantics: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Expanded(
                child: Text(
                  name,
                  style: context.textStyles.label.copyWith(
                    fontSize: 11,
                    height: 1.15,
                    color: selected ? ring : colors.textSecondary,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
