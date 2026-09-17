import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_assets.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';
import 'package:davidan_prototype/core/widgets/brand_texture.dart';
import 'package:davidan_prototype/core/widgets/top_scrim.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// The top of a brand's page, as a sliver for its CustomScrollView: the brand's
/// colours from the very top of the phone (behind the status bar) down, under
/// a dark fade that keeps the status bar and the white buttons readable, with
/// the way back, the brand's logo in white, an optional [title] and the
/// brand's buttons. An [overlap] (the banners, a photo) sits across the
/// colour's lower edge, so the header runs into the page instead of ending in
/// a line.
///
/// On scroll the overlap slides up under the button row, which stays pinned
/// at the top on the brand's colour.
class BrandHeaderBand extends StatelessWidget {
  const BrandHeaderBand({
    super.key,
    required this.brand,
    required this.onBack,
    this.title,
    this.actions = const [],
    this.overlap,
    this.overlapHeight = 0,
  }) : assert(
         overlap == null || overlapHeight > 0,
         'An overlap needs its height',
       );

  final Brand brand;
  final VoidCallback onBack;

  /// Shown after the logo, for a logo that doesn't spell the brand's name.
  final String? title;

  /// [AppIconButton]s (or built on one), lined up by their circles.
  final List<Widget> actions;

  /// Drawn [overlapHeight] tall across the colour's lower edge, padded to the
  /// screen's gutters by itself.
  final Widget? overlap;
  final double overlapHeight;

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

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _HeaderDelegate(
        topPadding: MediaQuery.paddingOf(context).top,
        brand: brand,
        row: _ButtonRow(
          brand: brand,
          onBack: onBack,
          title: title,
          actions: actions,
        ),
        overlap: overlap,
        overlapHeight: overlapHeight,
      ),
    );
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  _HeaderDelegate({
    required this.topPadding,
    required this.brand,
    required this.row,
    required this.overlap,
    required this.overlapHeight,
  });

  final double topPadding;
  final Brand brand;
  final Widget row;
  final Widget? overlap;
  final double overlapHeight;

  double get _barHeight => topPadding + BrandHeaderBand.rowHeight;

  /// Where the overlap starts, a little under the button row.
  double get _overlapTop => _barHeight + AppSpacing.xs;

  /// Where the brand's colour ends: halfway down the overlap, or a short way
  /// under the row without one.
  double get _colourBottom => overlap == null
      ? _barHeight + AppSpacing.sm
      : _overlapTop + overlapHeight / 2;

  @override
  double get minExtent => _barHeight;

  @override
  double get maxExtent => overlap == null
      ? _colourBottom
      // Room under the overlap for its shadow.
      : _overlapTop + overlapHeight + AppSpacing.md;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlaps) {
    final colourHeight = math.max(_barHeight, _colourBottom - shrinkOffset);
    final overlap = this.overlap;

    // The colour and its fade, the same size wherever they're drawn, so the
    // copy over the button row matches the one under the overlap exactly.
    final backdrop = SizedBox(
      height: colourHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          BrandSurface(brand: brand, texture: false),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: math.min(colourHeight, topPadding + TopScrim.reach),
            child: const TopScrim(),
          ),
        ],
      ),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Light status bar icons on the dark fade.
      value: SystemUiOverlayStyle.light,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(top: 0, left: 0, right: 0, child: backdrop),
          if (overlap != null) ...[
            Positioned(
              top: _overlapTop - shrinkOffset,
              left: 0,
              right: 0,
              height: overlapHeight,
              child: overlap,
            ),
            // The row's own strip of colour, over the overlap as it slides
            // up underneath.
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: _barHeight,
              child: ClipRect(
                child: OverflowBox(
                  alignment: Alignment.topCenter,
                  minHeight: colourHeight,
                  maxHeight: colourHeight,
                  child: backdrop,
                ),
              ),
            ),
          ],
          Positioned(
            top: topPadding,
            left: 0,
            right: 0,
            height: BrandHeaderBand.rowHeight,
            child: row,
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_HeaderDelegate old) => true;
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
              height: square ? 36 : 28,
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
