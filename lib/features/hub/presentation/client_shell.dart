import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// The hub's frame: the active tab plus the bottom navigation bar. Brands open
/// full screen above it, so a brand's pages never show this bar.
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
    return Scaffold(
      backgroundColor: context.colors.background,
      body: navigationShell,
      bottomNavigationBar: _BottomNav(
        currentIndex: navigationShell.currentIndex,
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
  const _BottomNav({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    // Same order as the branches of the StatefulShellRoute in app_router.dart.
    final items = [
      (icon: Icons.home_rounded, label: context.l10n.navHome),
      (icon: Icons.receipt_long_rounded, label: context.l10n.navOrders),
      (icon: Icons.favorite_rounded, label: context.l10n.navFavorites),
      (icon: Icons.person_rounded, label: context.l10n.navProfile),
    ];

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(top: BorderSide(color: context.colors.border)),
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
                    icon: item.icon,
                    label: item.label,
                    selected: index == currentIndex,
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
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? context.colors.primary
        : context.colors.textSecondary;

    return Semantics(
      selected: selected,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: AppSpacing.xs),
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
