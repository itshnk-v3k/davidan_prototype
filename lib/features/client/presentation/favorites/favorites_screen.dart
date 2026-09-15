import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/widgets/empty_state.dart';
import 'package:davidan_prototype/core/widgets/screen_header.dart';
import 'package:davidan_prototype/features/client/application/favorites_notifier.dart';
import 'package:davidan_prototype/features/client/presentation/widgets/product_grid.dart';

/// Favorite tab: products saved with a heart, most recent first, in the same
/// grid as the menu.
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(favoriteProductsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ScreenHeader(title: AppStrings.favoritesTitle),
            Expanded(
              child: products.isEmpty
                  ? EmptyState(
                      icon: Icons.favorite_border_rounded,
                      title: AppStrings.favoritesEmptyTitle,
                      message: AppStrings.favoritesEmptyMessage,
                      actionLabel: AppStrings.browseMenu,
                      onAction: () => context.go(Routes.clientMenu),
                    )
                  : CustomScrollView(
                      slivers: [ProductGrid(products: products)],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
