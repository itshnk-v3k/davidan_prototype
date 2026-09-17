import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/theme/brand_colors.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// The hub's frame: the active tab plus the bottom navigation bar. A brand's
/// browse screens (home, menu, information) open inside Acasă and keep the
/// bar; its task screens, which have their own bottom button (product, cart,
/// checkout, car, request), open full screen above it.
class ClientShell extends StatelessWidget {
  const ClientShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  /// Holds the tabs' navigators for the StatefulShellRoute in app_router.dart.
  /// Like go_router's indexedStack it keeps every tab alive but only shows and
  /// animates the current one. It also turns heroes off in hidden tabs.
  /// Otherwise a product shown in two tabs (home's popular list and the menu)
  /// would have two photo heroes with the same tag, and opening it would fail.
  static Widget tabStack(
    BuildContext context,
    StatefulNavigationShell navigationShell,
    List<Widget> children,
  ) {
    Widget tab(bool active, Widget child) => Offstage(
      offstage: !active,
      child: TickerMode(
        enabled: active,
        child: HeroMode(enabled: active, child: child),
      ),
    );

    return IndexedStack(
      index: navigationShell.currentIndex,
      children: [
        for (final (index, child) in children.indexed)
          tab(index == navigationShell.currentIndex, child),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    return Scaffold(
      backgroundColor: context.colors.background,
      body: navigationShell,
      // Inside a brand's pages the bar takes the brand's colour, so it rebuilds
      // as the open page changes, pushed pages included.
      bottomNavigationBar: ListenableBuilder(
        listenable: router.routerDelegate,
        builder: (context, _) => _BottomNav(
          currentIndex: navigationShell.currentIndex,
          brand: _brandAt(router.state.matchedLocation),
          // Tapping the active tab again returns it to its first screen.
          onTap: (index) => navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          ),
        ),
      ),
    );
  }

  /// The brand whose pages [location] is in (`.../b/:brand/...`), if any.
  static Brand? _brandAt(String location) {
    final segments = Uri.parse(location).pathSegments;
    final at = segments.indexOf('b');
    if (at == -1 || at + 1 >= segments.length) return null;
    return Brand.values.asNameMap()[segments[at + 1]];
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.currentIndex,
    required this.brand,
    required this.onTap,
  });

  final int currentIndex;

  /// The brand whose pages are open, whose colour the bar takes; DaviDan's
  /// own colours elsewhere.
  final Brand? brand;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    // Same order as the branches of the StatefulShellRoute in app_router.dart.
    // The current tab's icon is filled and the others are outlines, as
    // Material 3 does. The icon font has no rounded outline of the house or
    // the receipt, so those two use the outlined set.
    final items = [
      (
        icon: Icons.home_outlined,
        selectedIcon: Icons.home_rounded,
        label: context.l10n.navHome,
      ),
      (
        icon: Icons.receipt_long_outlined,
        selectedIcon: Icons.receipt_long_rounded,
        label: context.l10n.navOrders,
      ),
      (
        icon: Icons.favorite_border_rounded,
        selectedIcon: Icons.favorite_rounded,
        label: context.l10n.navFavorites,
      ),
      (
        icon: Icons.person_outline_rounded,
        selectedIcon: Icons.person_rounded,
        label: context.l10n.navProfile,
      ),
    ];

    final brand = this.brand;
    final colors = brand == null
        ? context.colors
        : BrandColors.of(brand, Theme.of(context).brightness);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(
          top: brand == null
              ? BorderSide(color: context.colors.border)
              : BorderSide(color: colors.primary, width: 2),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              for (final (index, item) in items.indexed)
                Expanded(
                  child: _NavItem(
                    icon: index == currentIndex ? item.selectedIcon : item.icon,
                    label: item.label,
                    selected: index == currentIndex,
                    selectedColor: colors.primary,
                    indicatorColor: colors.accentSoft,
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
    required this.selectedColor,
    required this.indicatorColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final Color selectedColor;

  /// The pill behind the selected tab's icon.
  final Color indicatorColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? selectedColor : context.colors.textSecondary;

    return Semantics(
      selected: selected,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 56,
              height: 30,
              decoration: BoxDecoration(
                color: selected ? indicatorColor : Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadii.pill),
              ),
              child: Icon(icon, size: 24, color: color),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              label,
              style: context.textStyles.label.copyWith(
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
