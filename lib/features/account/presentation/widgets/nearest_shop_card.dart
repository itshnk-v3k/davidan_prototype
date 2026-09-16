import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/utils/distance.dart';
import 'package:davidan_prototype/data/models/customer_account.dart';
import 'package:davidan_prototype/features/food/application/shop_providers.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// The shop nearest the customer and how it was found: by sector, or by the
/// phone's location with the distance. Nothing when the shop no longer exists.
class NearestShopCard extends ConsumerWidget {
  const NearestShopCard({super.key, required this.account});

  final CustomerAccount account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shop = ref.watch(locationByIdProvider(account.nearestLocationId));
    if (shop == null) return const SizedBox.shrink();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: context.colors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: context.colors.accentSoft,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.storefront_rounded,
                size: 20,
                color: context.colors.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.nearestShopTitle,
                    style: context.textStyles.caption,
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(shop.name, style: context.textStyles.bodyStrong),
                  Text(
                    '${shop.address} · ${shop.openingHours}',
                    style: context.textStyles.caption,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    switch (account.matchedBy) {
                      ShopMatch.sector => context.l10n.matchedBySector(
                        account.sector,
                      ),
                      ShopMatch.location => context.l10n.matchedByLocation(
                        formatDistance(
                          (account.distanceMeters ?? 0).toDouble(),
                        ),
                      ),
                    },
                    style: context.textStyles.label.copyWith(
                      color: context.colors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
