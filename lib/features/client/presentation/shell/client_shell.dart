import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/features/client/application/cart_notifier.dart';

/// Customer app frame: the active tab plus the bottom navigation bar.
class ClientShell extends ConsumerWidget {
  const ClientShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartCountProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: navigationShell,
      bottomNavigationBar: _BottomNav(
        currentIndex: navigationShell.currentIndex,
        cartCount: cartCount,
        // Tapping the active tab again returns it to its first screen.
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.currentIndex,
    required this.cartCount,
    required this.onTap,
  });

  /// Same order as the branches of the StatefulShellRoute in app_router.dart.
  static const _items = <({IconData icon, String label})>[
    (icon: Icons.home_rounded, label: AppStrings.navHome),
    (icon: Icons.restaurant_menu_rounded, label: AppStrings.navMenu),
    (icon: Icons.shopping_bag_rounded, label: AppStrings.navCart),
    (icon: Icons.person_rounded, label: AppStrings.navProfile),
  ];
  static const _cartIndex = 2;

  final int currentIndex;
  final int cartCount;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              for (final (index, item) in _items.indexed)
                Expanded(
                  child: _NavItem(
                    icon: item.icon,
                    label: item.label,
                    selected: index == currentIndex,
                    badgeCount: index == _cartIndex ? cartCount : 0,
                    onTap: () => onTap(index),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.badgeCount,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final int badgeCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.textSecondary;

    return Semantics(
      selected: selected,
      label: badgeCount > 0 ? AppStrings.itemsInCart(badgeCount) : null,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, size: 24, color: color),
                if (badgeCount > 0)
                  Positioned(
                    top: -6,
                    right: -12,
                    child: _Badge(count: badgeCount),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: AppTextStyles.label.copyWith(
                color: color,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18,
      constraints: const BoxConstraints(minWidth: 18),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadii.pill),
        border: Border.all(color: AppColors.surface, width: 1.5),
      ),
      child: Text(count > 99 ? '99+' : '$count', style: AppTextStyles.badge),
    );
  }
}
