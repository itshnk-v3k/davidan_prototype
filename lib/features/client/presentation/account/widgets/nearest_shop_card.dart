import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/utils/distance.dart';
import 'package:davidan_prototype/data/models/customer_account.dart';
import 'package:davidan_prototype/features/client/application/catalog_providers.dart';

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
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.accentSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.storefront_rounded,
                size: 20,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    AppStrings.nearestShopTitle,
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(shop.name, style: AppTextStyles.bodyStrong),
                  Text(
                    '${shop.address} · ${shop.openingHours}',
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    switch (account.matchedBy) {
                      ShopMatch.sector => AppStrings.matchedBySector(
                        account.sector,
                      ),
                      ShopMatch.location => AppStrings.matchedByLocation(
                        formatDistance(
                          (account.distanceMeters ?? 0).toDouble(),
                        ),
                      ),
                    },
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.primary,
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
