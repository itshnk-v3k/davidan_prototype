import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/features/account/application/account_notifier.dart';
import 'package:davidan_prototype/features/food/application/catalog_providers.dart';
import 'package:davidan_prototype/features/food/presentation/home/widgets/product_shelf.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// "{name}, pentru tine": a sheet that rises over the bottom of the brand
/// bubbles' caramel band, with a row of popular products from every brand
/// that has a menu. Adding a product puts it in its own brand's cart.
class ForYouSheet extends ConsumerWidget {
  const ForYouSheet({super.key});

  static const rowId = 'for-you';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(forYouProductsProvider);
    if (products.isEmpty) return const SizedBox.shrink();
    final account = ref.watch(accountProvider);
    final colors = context.colors;

    return ColoredBox(
      // Shows in the sheet's rounded top corners, so the band runs on.
      color: colors.hubBand,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppRadii.xl),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xl),
          child: ProductShelf(
            id: rowId,
            title: account == null
                ? context.l10n.forYouTitleSignedOut
                : context.l10n.forYouTitle(
                    account.name.trim().split(RegExp(r'\s+')).first,
                  ),
            products: products,
          ),
        ),
      ),
    );
  }
}
