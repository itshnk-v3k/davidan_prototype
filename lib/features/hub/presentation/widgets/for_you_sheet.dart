import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/features/account/application/account_notifier.dart';
import 'package:davidan_prototype/features/food/application/catalog_providers.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/product_grid.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// "{name}, pentru tine": products from every brand in a two-column grid, each
/// card naming its brand. A sliver, for the hub's scroll view.
class ForYouSheet extends ConsumerWidget {
  const ForYouSheet({super.key});

  static const rowId = 'for-you';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(forYouProductsProvider);
    if (products.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    final account = ref.watch(accountProvider);

    return ProductGrid(
      products: products,
      title: account == null
          ? context.l10n.forYouTitleSignedOut
          : context.l10n.forYouTitle(
              account.name.trim().split(RegExp(r'\s+')).first,
            ),
      showBrand: true,
    );
  }
}
