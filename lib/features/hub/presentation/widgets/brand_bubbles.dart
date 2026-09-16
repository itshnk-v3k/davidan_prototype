import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/press_scale.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/brand_intro.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// Every brand as a round photo with its name, on a band of DaviDan's caramel,
/// in the client's order ([Brand]'s): three on the first row of a phone, two
/// centred below.
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

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final image = intro.image;

    return Semantics(
      button: true,
      label: intro.name,
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
                Container(
                  width: _size,
                  height: _size,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: colors.hubBubble,
                    shape: BoxShape.circle,
                  ),
                  child: image == null
                      ? Icon(
                          Icons.directions_car_rounded,
                          size: 40,
                          color: colors.hubBand,
                        )
                      : Image.asset(image, fit: BoxFit.cover),
                ),
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
