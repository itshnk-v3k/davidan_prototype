import 'dart:ui' show ImageFilter;

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
/// client's order ([Brand]'s), each one of the brand's own photos with its
/// white logo on top and its name underneath, scrolling sideways when they
/// don't all fit. Tapping one swaps the feed below without leaving the shell,
/// the way Glovo and Yandex Eda switch between their verticals.
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

  /// The five brands share the row's width evenly, so the bubble is as big as
  /// its fifth of the screen allows rather than a size picked to survive the
  /// narrowest phone. The photo fills the circle edge to edge, so this is the
  /// photo's size too.
  ///
  /// [minBubble] is where a brand's photo stops reading as a dish and the name
  /// under it starts to crowd; [maxBubble] is where five circles stop being a
  /// strip along the top and start being a screen of their own, which is what
  /// a tablet's width would otherwise make of them.
  static const minBubble = 48.0;
  static const maxBubble = 76.0;

  /// The least space left between one bubble and the next, whatever is left
  /// over after that goes into the bubbles themselves.
  static const _minGap = AppSpacing.sm;

  /// The diameter the row's width allows, within [minBubble]..[maxBubble].
  /// The row spans the screen, so its width is the screen's less the gutters
  /// on either side; [BrandShell] measures the chrome with the same figure.
  static double diameterFor(BuildContext context) {
    final row = MediaQuery.sizeOf(context).width - 2 * AppSpacing.gutter;
    final share = row / Brand.values.length;
    return (share - 2 * _ringRoom - _minGap).clamp(minBubble, maxBubble);
  }

  /// The size the white logos were drawn against; smaller and larger bubbles
  /// take theirs in proportion.
  static const _logoReference = 56.0;

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
      diameterFor(context) +
      _nameGap +
      _nameHeight * MediaQuery.textScalerOf(context).scale(1);

  /// Two lines of the name at [_nameSize] and [_nameLineHeight].
  static const _nameHeight = 24.0;
  static const _nameSize = 10.5;
  static const _nameLineHeight = 1.12;

  @override
  Widget build(BuildContext context) {
    // A fifth of the row each, so the five sit across the whole width with
    // the space between them growing with the screen rather than the fifth
    // brand falling off a narrow one. Nothing scrolls: all five are always
    // there.
    return SizedBox(
      height: heightFor(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
        child: Row(
          children: [
            for (final brand in Brand.values)
              Expanded(
                child: Builder(
                  builder: (context) {
                    final intro = context.content.introOf(brand);
                    return _BrandBubble(
                      brand: brand,
                      name: intro.name,
                      photo: intro.image,
                      diameter: diameterFor(context),
                      selected: brand == selected,
                      onTap: () => onSelected(brand),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BrandBubble extends StatelessWidget {
  const _BrandBubble({
    required this.brand,
    required this.name,
    required this.photo,
    required this.diameter,
    required this.selected,
    required this.onTap,
  });

  final Brand brand;
  final String name;

  /// The brand's own photo, the one its hub card carried, filling the bubble.
  /// Null for a brand with no photo yet, whose bubble is its colour alone.
  final String? photo;

  /// What the row's width allows (BrandSwitcherRow.diameterFor).
  final double diameter;
  final bool selected;
  final VoidCallback onTap;

  /// Each white logo's size inside the bubble, by eye so they carry the same
  /// weight: the wide wordmarks by width, the compact marks by height. Drawn
  /// against a bubble of [BrandSwitcherRow._logoReference], and taken in
  /// proportion on a bubble the width made larger or smaller.
  static Size _logoSize(Brand brand, double diameter) {
    final base = switch (brand) {
      Brand.restaurant || Brand.bakery => const Size(38, 8),
      Brand.sushi => const Size(35, 11),
      Brand.water => const Size(20, 13),
      Brand.carRental => const Size(22, 22),
    };
    final scale = diameter / BrandSwitcherRow._logoReference;
    return Size(base.width * scale, base.height * scale);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    // The brand's own colour, not the theme's: the ring marks which brand is
    // open even while the feed below is already in that brand's colours.
    final ring = BrandColors.of(brand, Theme.of(context).brightness).primary;
    final logo = _logoSize(brand, diameter);
    final size = diameter;
    const room = BrandSwitcherRow._ringRoom;

    return Semantics(
      button: true,
      selected: selected,
      label: name,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onTap,
        radius: size / 2 + room,
        // The whole fifth of the row is the item's: the bubble is centred in
        // it and the name has that width to wrap in, which is what keeps
        // "Apă naturală" and "Питьевая вода" on two tidy lines.
        child: SizedBox(
          width: double.infinity,
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

/// What fills a bubble behind its logo: the brand's own photo, cropped to the
/// circle and shown as it was taken — no colour over it, so the dish or the
/// bottle is what the bubble shows. Only a pool of the brand's deepest shade
/// gathers in the middle, under the logo, so the white wordmark holds over a
/// bright plate or a white car; it is gone by the bubble's edge, where the
/// photo is clear.
///
/// Without a photo it is the brand's gradient alone, as the bubbles were.
class _BubbleFace extends StatelessWidget {
  const _BubbleFace({required this.brand, required this.photo, this.child});

  final Brand brand;
  final String? photo;
  final Widget? child;

  /// The pool of the brand's deepest shade gathered in the middle, gone by the
  /// bubble's edge.
  static const _pool = 0.55;

  /// Behind the wordmark itself, the same shade blurred to the shape of its
  /// own letters: what carries white over the bright photos (the bottle on
  /// white, the white Audi) that the colour over the whole bubble used to
  /// carry it over. Two passes, since one blurred copy spreads too thin.
  static const _haloBlur = 2.5;
  static const _haloPasses = 2;

  @override
  Widget build(BuildContext context) {
    final photo = this.photo;
    if (photo == null) {
      // A pattern this small would only read as noise.
      return BrandSurface(brand: brand, texture: false, child: child);
    }
    final shade = BrandSurface.shadeOf(brand);

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(photo, fit: BoxFit.cover, excludeFromSemantics: true),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                shade.withValues(alpha: _pool),
                shade.withValues(alpha: _pool * 0.7),
                shade.withValues(alpha: 0),
              ],
              stops: const [0, 0.55, 1],
            ),
          ),
        ),
        if (child case final child?)
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                for (var pass = 0; pass < _haloPasses; pass++)
                  ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: _haloBlur,
                      sigmaY: _haloBlur,
                    ),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(shade, BlendMode.srcIn),
                      child: child,
                    ),
                  ),
                child,
              ],
            ),
          ),
      ],
    );
  }
}
