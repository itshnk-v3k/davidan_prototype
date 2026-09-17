import 'dart:ui' show ImageFilter;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/theme/brand_colors.dart';
import 'package:davidan_prototype/core/widgets/count_badge.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/food/application/favorites_notifier.dart';
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
      // The screens run behind the floating bar, which blurs them; each leaves
      // room for it at the end of its content (BottomBarSpace).
      extendBody: true,
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

class _BottomNav extends ConsumerWidget {
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

  /// The Favorite tab's place in [items].
  static const _favoritesIndex = 2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteCount = ref.watch(
      favoriteKeysProvider.select((keys) => keys.length),
    );
    // Same order as the branches of the StatefulShellRoute in app_router.dart.
    // The current tab's icon is filled and the others are Phosphor's soft
    // line icons, as Material 3 does with its own.
    final items = [
      (
        icon: PhosphorIconsRegular.house,
        selectedIcon: PhosphorIconsFill.house,
        label: context.l10n.navHome,
      ),
      (
        icon: PhosphorIconsRegular.receipt,
        selectedIcon: PhosphorIconsFill.receipt,
        label: context.l10n.navOrders,
      ),
      (
        icon: PhosphorIconsRegular.heart,
        selectedIcon: PhosphorIconsFill.heart,
        label: context.l10n.navFavorites,
      ),
      (
        icon: PhosphorIconsRegular.user,
        selectedIcon: PhosphorIconsFill.user,
        label: context.l10n.navProfile,
      ),
    ];

    final brand = this.brand;
    final colors = brand == null
        ? context.colors
        : BrandColors.of(brand, Theme.of(context).brightness);
    const radius = BorderRadius.all(Radius.circular(_radius));

    // Floats above the content, inset from the sides and above the phone's own
    // gesture area, on a frosted, translucent surface.
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.md + MediaQuery.paddingOf(context).bottom,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: [
            BoxShadow(
              color: context.colors.cardShadow,
              blurRadius: 28,
              spreadRadius: -4,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: context.colors.surface.withValues(alpha: 0.82),
                borderRadius: radius,
                border: Border.all(
                  color: context.colors.border.withValues(alpha: 0.6),
                ),
              ),
              child: SizedBox(
                height: 64,
                child: Row(
                  children: [
                    for (final (index, item) in items.indexed)
                      Expanded(
                        child: _NavItem(
                          icon: index == currentIndex
                              ? item.selectedIcon
                              : item.icon,
                          label: item.label,
                          badgeCount: index == _favoritesIndex
                              ? favoriteCount
                              : 0,
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
          ),
        ),
      ),
    );
  }

  static const _radius = 24.0;
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.selectedColor,
    required this.indicatorColor,
    required this.onTap,
    this.badgeCount = 0,
  });

  final IconData icon;
  final String label;

  /// Shown on the icon's corner when above 0, like the carts button's count.
  final int badgeCount;
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
      // The tab's label, then how many it holds.
      value: badgeCount > 0 ? '$badgeCount' : null,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
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
                // On the icon's top right corner.
                if (badgeCount > 0)
                  Positioned(
                    top: -AppSpacing.xs,
                    left: 28 + AppSpacing.xs,
                    child: ExcludeSemantics(
                      child: CountBadge(
                        count: badgeCount,
                        color: selectedColor,
                      ),
                    ),
                  ),
              ],
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
