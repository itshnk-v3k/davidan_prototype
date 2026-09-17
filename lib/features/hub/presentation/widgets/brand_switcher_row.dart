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
/// client's order ([Brand]'s), each one of the brand's own photos under a veil
/// of its colour with its white logo on top and its name underneath, scrolling
/// sideways when they don't all fit. Tapping one swaps the feed below without
/// leaving the shell, the way Glovo and Yandex Eda switch between their
/// verticals.
///
/// It is a slim strip rather than a section of its own: small bubbles, close
/// together, with the name right under them, so the banners below start near
/// the top of the page.
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
  static const bubbleSize = 44.0;

  /// The hairline round a bubble, a shade lighter than its own colour: what
  /// holds its shape where the brand's deep tone is close to the page's.
  static const bubbleRim = Color(0x33FFFFFF);

  /// Between the bubble and the ring, so the ring reads as a ring.
  static const _ringGap = 2.0;
  static const _ringWidth = 2.0;
  static const _ringRoom = _ringGap + _ringWidth;

  /// Between the bubble and the name under it.
  static const _nameGap = AppSpacing.xxs;

  /// How tall the whole row is: the ring's room, the bubble, the gap and two
  /// lines of name at the largest text size the app allows.
  static double heightFor(BuildContext context) =>
      2 * _ringRoom +
      bubbleSize +
      _nameGap +
      _nameHeight * MediaQuery.textScalerOf(context).scale(1);

  /// Two lines of the name at [_nameSize] and [_nameLineHeight].
  static const _nameHeight = 24.0;
  static const _nameSize = 10.5;
  static const _nameLineHeight = 1.12;

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
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final brand = Brand.values[index];
          final intro = context.content.introOf(brand);
          return _BrandBubble(
            brand: brand,
            name: intro.name,
            photo: intro.image,
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
    required this.photo,
    required this.selected,
    required this.onTap,
  });

  final Brand brand;
  final String name;

  /// The brand's own photo, the one its hub card carried, filling the bubble
  /// under a veil of the brand's colour. Null for a brand with no photo yet,
  /// whose bubble is its colour alone.
  final String? photo;
  final bool selected;
  final VoidCallback onTap;

  /// Each white logo's size inside the bubble, by eye so they carry the same
  /// weight: the wide wordmarks by width, the compact marks by height.
  static Size _logoSize(Brand brand) => switch (brand) {
    Brand.restaurant || Brand.bakery => const Size(32, 7),
    Brand.sushi => const Size(30, 9),
    Brand.water => const Size(17, 11),
    Brand.carRental => const Size(19, 19),
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
          width: size + 2 * room + AppSpacing.lg,
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
                        child: _BubbleFace(
                          brand: brand,
                          photo: photo,
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
              const SizedBox(height: BrandSwitcherRow._nameGap),
              Expanded(
                child: Text(
                  name,
                  style: context.textStyles.label.copyWith(
                    fontSize: BrandSwitcherRow._nameSize,
                    height: BrandSwitcherRow._nameLineHeight,
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

/// What fills a bubble behind its logo: the brand's photo cropped to the
/// circle, then a veil of the brand's own gradient over it, so the bubble
/// still reads as that brand's colour and the white logo stays legible even
/// over a bright photo (the water bottle on white, the white Audi). A soft
/// pool of the brand's deepest shade sits in the middle, under the logo.
///
/// Without a photo it is the brand's gradient alone, as the bubbles were.
class _BubbleFace extends StatelessWidget {
  const _BubbleFace({required this.brand, required this.photo, this.child});

  final Brand brand;
  final String? photo;
  final Widget? child;

  /// How much of the brand's colour covers the photo, from the light end of
  /// its gradient to the deep one. Enough for the colour to lead and for the
  /// logo to hold, little enough that the photo still shows through.
  static const _veilLight = 0.58;
  static const _veilDeep = 0.88;

  /// The pool of the brand's deepest shade under the logo.
  static const _pool = 0.32;

  @override
  Widget build(BuildContext context) {
    final photo = this.photo;
    if (photo == null) {
      // A pattern this small would only read as noise.
      return BrandSurface(brand: brand, texture: false, child: child);
    }
    final (light, deep) = BrandSurface.colorsOf(brand);
    final shade = BrandSurface.shadeOf(brand);

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(photo, fit: BoxFit.cover, excludeFromSemantics: true),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                light.withValues(alpha: _veilLight),
                deep.withValues(alpha: _veilDeep),
              ],
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                shade.withValues(alpha: _pool),
                shade.withValues(alpha: 0),
              ],
            ),
          ),
        ),
        if (child case final child?) Center(child: child),
      ],
    );
  }
}
