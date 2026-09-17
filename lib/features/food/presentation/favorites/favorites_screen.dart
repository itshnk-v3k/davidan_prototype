import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/widgets/empty_state.dart';
import 'package:davidan_prototype/core/widgets/screen_header.dart';
import 'package:davidan_prototype/features/food/application/favorites_notifier.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/cart_button.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/product_grid.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// Favorite tab: products saved with a heart, most recent first, in the same
/// grid as the menu.
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(favoriteProductsProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(
              title: context.l10n.favoritesTitle,
              // Saved products come from every brand, so this opens the list
              // of every brand's cart.
              actions: const [OpenCartsButton()],
            ),
            Expanded(
              child: products.isEmpty
                  ? EmptyState(
                      icon: PhosphorIconsRegular.heart,
                      title: context.l10n.favoritesEmptyTitle,
                      message: context.l10n.favoritesEmptyMessage,
                      actionLabel: context.l10n.backHome,
                      onAction: () => context.go(Routes.clientHome),
                    )
                  : CustomScrollView(
                      slivers: [
                        ProductGrid(
                          products: products,
                          title: context.l10n.productCount(products.length),
                          showBrand: true,
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
