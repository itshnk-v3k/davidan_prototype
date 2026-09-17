import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/theme/app_theme.dart';
import 'package:davidan_prototype/core/theme/brand_colors.dart';
import 'package:davidan_prototype/core/widgets/count_badge.dart';
import 'package:davidan_prototype/core/widgets/glass_surface.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/food/application/favorites_notifier.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// The hub's frame: the active tab plus the bottom navigation bar. A brand's
/// browse screens (home, menu, information) open inside Acasă and keep the
/// bar; its task screens, which have their own bottom button (product, cart,
/// checkout, car, request), open full screen above it.
///
/// The bar and the other tabs (Comenzi, Favorite, Profil) take the colours of
/// the brand open in Acasă, so moving between tabs keeps the brand the
/// customer is shopping in. With Acasă back on the hub, where no brand is
/// open, they return to DaviDan's own colours. Those tabs mix every brand's
/// products and orders, so no brand is right for them on its own; the one the
/// customer came from is the least surprising.
class ClientShell extends StatefulWidget {
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

  /// The brand whose pages [location] is in (`.../b/:brand/...`), if any.
  static Brand? _brandAt(String location) {
    final segments = Uri.parse(location).pathSegments;
    final at = segments.indexOf('b');
    if (at == -1 || at + 1 >= segments.length) return null;
    return Brand.values.asNameMap()[segments[at + 1]];
  }

  @override
  State<ClientShell> createState() => _ClientShellState();
}

class _ClientShellState extends State<ClientShell> {
  GoRouter? _router;

  /// The brand open in Acasă: the brand of the last page shown there.
  Brand? _homeBrand;

  /// The brand whose colours the bar and the tabs take: the open tab page's
  /// own brand (a brand's pages in Acasă, its information in Profil), else
  /// [_homeBrand].
  Brand? _brand;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final router = GoRouter.of(context);
    if (router == _router) return;
    _router?.routerDelegate.removeListener(_onRouteChanged);
    _router = router..routerDelegate.addListener(_onRouteChanged);
    _update();
  }

  @override
  void dispose() {
    _router?.routerDelegate.removeListener(_onRouteChanged);
    super.dispose();
  }

  void _onRouteChanged() => setState(_update);

  void _update() {
    final router = _router!;
    // A task screen above the tabs (a product, a cart, an order) leaves them
    // as they were, so nothing under it changes colour as it slides in or out.
    if (router.routerDelegate.currentConfiguration.matches.lastOrNull
        is! ShellRouteMatch) {
      return;
    }
    final location = router.state.matchedLocation;
    final pageBrand = ClientShell._brandAt(location);
    if (location.startsWith(Routes.clientHome)) _homeBrand = pageBrand;
    _brand = pageBrand ?? _homeBrand;
  }

  @override
  Widget build(BuildContext context) {
    final navigationShell = widget.navigationShell;
    final brand = _brand;
    final theme = Theme.of(context);
    final brandColors = brand == null
        ? null
        : BrandColors.of(brand, theme.brightness);
    // DaviDan's own colours need no second theme (see BrandTheme). The Theme
    // stays in the tree either way, so switching doesn't rebuild the tabs.
    final tabsTheme =
        brandColors == null ||
            identical(brandColors, AppColors.dark) ||
            identical(brandColors, AppColors.light)
        ? theme
        : AppTheme.forBrand(brand!, theme.brightness);

    return Scaffold(
      backgroundColor: context.colors.background,
      // The screens run behind the floating bar, which blurs them; each leaves
      // room for it at the end of its content (BottomBarSpace).
      extendBody: true,
      body: Theme(data: tabsTheme, child: navigationShell),
      bottomNavigationBar: _BottomNav(
        currentIndex: navigationShell.currentIndex,
        brand: brand,
        // Tapping the active tab again returns it to its first screen.
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}

class _BottomNav extends ConsumerWidget {
  const _BottomNav({
    required this.currentIndex,
    required this.brand,
    required this.onTap,
  });

  final int currentIndex;

  /// The brand whose colour the bar takes (see ClientShell); DaviDan's own
  /// colours when none.
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
    final radius = BorderRadius.circular(_radius);

    // Floats above the content as a slim bar of liquid glass, as wide as the
    // page's cards (the same gutters) and above the phone's own gesture area.
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        0,
        AppSpacing.gutter,
        AppSpacing.sm + MediaQuery.paddingOf(context).bottom,
      ),
      child: GlassSurface(
        borderRadius: radius,
        shadow: true,
        // Its own Material, so the selected tab's fill and the ripples paint on
        // the glass rather than under it.
        child: Material(
          type: MaterialType.transparency,
          child: SizedBox(
            height: _height,
            child: Padding(
              padding: const EdgeInsets.all(_inset),
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
                        onTap: () => onTap(index),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static const _height = 58.0;

  /// The bar's own corners, rounder than a card's.
  static const _radius = 14.0;

  /// The selected tab's corners, following the bar's across the [_inset].
  static const innerRadius = _radius - _inset;

  /// Between the bar's edge and the selected tab's own lighter fill.
  static const _inset = 4.0;
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.selectedColor,
    required this.onTap,
    this.badgeCount = 0,
  });

  final IconData icon;
  final String label;

  /// Shown on the icon's corner when above 0, like the carts button's count.
  final int badgeCount;
  final bool selected;
  final Color selectedColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? selectedColor : context.colors.textSecondary;
    final shape = BorderRadius.circular(_BottomNav.innerRadius);

    return Semantics(
      selected: selected,
      // The tab's label, then how many it holds.
      value: badgeCount > 0 ? '$badgeCount' : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: shape,
        // The selected tab sits in a lighter rounded fill of its own, tinted with
        // the brand's colour, the way iOS marks it on glass.
        child: Ink(
          decoration: BoxDecoration(
            color: selected
                ? selectedColor.withValues(alpha: 0.14)
                : Colors.transparent,
            borderRadius: shape,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(icon, size: 22, color: color),
                  // On the icon's top right corner.
                  if (badgeCount > 0)
                    Positioned(
                      top: -AppSpacing.xs,
                      left: 22 - AppSpacing.xs,
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
                  fontSize: 10.5,
                  height: 1.1,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
