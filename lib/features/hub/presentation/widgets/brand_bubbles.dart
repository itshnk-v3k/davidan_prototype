import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/press_scale.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/brand_intro.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// Every brand as its logo on a round white tile with its name, on a band of
/// DaviDan's caramel, in the client's order ([Brand]'s): three on the first
/// row of a phone, two centred below. A brand that isn't open in the app yet
/// says so on its bubble, so nobody taps into a page with nothing to order.
class BrandBubbles extends StatelessWidget {
  const BrandBubbles({super.key, required this.onOpen});

  final ValueChanged<Brand> onOpen;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.colors.hubBand,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.gutter,
          vertical: AppSpacing.xl,
        ),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: AppSpacing.lg,
          runSpacing: AppSpacing.lg,
          children: [
            for (final brand in Brand.values)
              _Bubble(
                intro: context.content.introOf(brand),
                onTap: () => onOpen(brand),
              ),
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.intro, required this.onTap});

  final BrandIntro intro;
  final VoidCallback onTap;

  static const _size = 80.0;

  /// Keeps a square mark's corners inside the circle; wordmarks, being wide
  /// and short, fit with room to spare.
  static const _logoInset = 10.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final tile = Container(
      width: _size,
      height: _size,
      padding: const EdgeInsets.all(_logoInset),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.hubBubble,
        shape: BoxShape.circle,
      ),
      child: Image.asset(intro.logo, fit: BoxFit.contain),
    );

    return Semantics(
      button: true,
      label: intro.comingSoon
          ? context.l10n.brandComingSoonLabel(intro.name)
          : intro.name,
      excludeSemantics: true,
      child: PressScale(
        builder: (onHighlightChanged) => InkWell(
          onTap: onTap,
          onHighlightChanged: onHighlightChanged,
          borderRadius: BorderRadius.circular(AppRadii.md),
          child: SizedBox(
            width: _size + AppSpacing.lg,
            child: Column(
              children: [
                if (intro.comingSoon)
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.bottomCenter,
                    children: [
                      tile,
                      // Overlaps the bubble's lower edge, like a sticker.
                      Positioned(
                        bottom: -AppSpacing.xs,
                        child: _ComingSoonPill(
                          label: context.l10n.comingSoonTitle,
                        ),
                      ),
                    ],
                  )
                else
                  tile,
                const SizedBox(height: AppSpacing.sm),
                Text(
                  intro.name,
                  style: context.textStyles.label.copyWith(
                    color: colors.onHubBand,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// "În curând" on a brand's bubble: espresso on the caramel band, the same
/// pairing as the bubbles' names.
class _ComingSoonPill extends StatelessWidget {
  const _ComingSoonPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.onHubBand,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs,
        ),
        child: Text(
          label,
          style: context.textStyles.badge.copyWith(color: colors.hubBand),
          maxLines: 1,
        ),
      ),
    );
  }
}
