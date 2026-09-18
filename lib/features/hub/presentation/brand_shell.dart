import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:davidan_prototype/core/router/extra_app.dart';
import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_motion.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/theme/app_theme.dart';
import 'package:davidan_prototype/core/theme/brand_colors.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';
import 'package:davidan_prototype/data/mock/mock_catalogs.dart';
import 'package:davidan_prototype/data/mock/mock_sectors.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/account/application/current_location_notifier.dart';
import 'package:davidan_prototype/features/account/application/fulfilment_choice_notifier.dart';
import 'package:davidan_prototype/features/food/application/cart_notifier.dart';
import 'package:davidan_prototype/features/food/application/shop_providers.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/cart_bar.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/cart_button.dart';
import 'package:davidan_prototype/features/hub/application/switcher_open_notifier.dart';
import 'package:davidan_prototype/features/hub/presentation/widgets/brand_switcher_row.dart';
import 'package:davidan_prototype/features/hub/presentation/widgets/notifications_button.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// Acasă's frame: where orders go and the notifications at the top, the brand
/// switcher under it, and the open brand's pages below. Both stay put while
/// the customer moves between brands and into a category, so switching brand
/// reads as filtering one shop rather than opening another.
///
/// It is a go_router ShellRoute inside the Acasă branch (app_router.dart), so
/// the bar and the row are built once and only the page beneath them changes.
/// The pages that are not part of browsing a brand (search, the brand's
/// information) name the branch's navigator instead, and so cover it.
///
/// The pages run under the chrome rather than after it, so their content
/// scrolls beneath the fade at its lower edge. Each starts its own scroll
/// view with [chromeHeight] of room ([BrandShellSpace]).
///
/// Scrolling down folds the switcher away and scrolling back up brings it
/// again, as Glovo and Yandex Eda do with the strip above their feeds: the
/// bar itself stays, since where the order goes, search and the bell have to
/// be reachable from anywhere in the brand, while the switcher is for the odd
/// change of shop. The pages know nothing of it either: the switcher folds
/// over what has already scrolled under it, so nothing below moves.
///
/// At the foot, once the brand's cart holds something, the [CartBar] floats
/// over the pages, above the tab bar. The pages need know nothing of it: the
/// shell adds its height to the bottom padding they already leave for the tab
/// bar, so the room they keep clear grows and shrinks with the bar.
class BrandShell extends ConsumerStatefulWidget {
  const BrandShell({
    super.key,
    required this.brand,
    required this.showBack,
    required this.child,
  });

  /// The brand whose pages are showing: the one the switcher marks.
  final Brand brand;

  /// Whether a page of the brand's is open over its feed (a category, all its
  /// categories): the bar then leads back to the feed, since the feed is no
  /// longer what the switcher's own bubble alone would return to.
  final bool showBack;
  final Widget child;

  /// The top bar's own height, without the status bar above it: the tap area
  /// of the buttons in it and no more, so the switcher sits right under the
  /// address rather than a line's depth below it.
  static const barHeight = TapTarget.min;

  /// How much room the bar and the switcher take at the top of the page,
  /// including the status bar: what a page below has to leave clear.
  /// [switcherOpen] is switcherOpenProvider: folded away, the row takes no
  /// room and the page moves up under the bar with it.
  static double chromeHeight(
    BuildContext context, {
    required bool switcherOpen,
  }) =>
      MediaQuery.paddingOf(context).top +
      AppSpacing.sm +
      barHeight +
      (switcherOpen ? _switcherGap + BrandSwitcherRow.heightFor(context) : 0) +
      _SwitcherHandle.height +
      _fadeHeight;

  /// The fade under the switcher, where the page appears from behind it.
  static const _fadeHeight = AppSpacing.sm;

  /// Between the bar and the brand switcher under it, so the bubbles don't sit
  /// against the address. It folds away with the row rather than staying
  /// behind as a band of nothing.
  static const _switcherGap = AppSpacing.sm;

  @override
  ConsumerState<BrandShell> createState() => _BrandShellState();
}

class _BrandShellState extends ConsumerState<BrandShell> {
  @override
  Widget build(BuildContext context) {
    final brand = widget.brand;
    final theme = Theme.of(context);
    final brandColors = BrandColors.of(brand, theme.brightness);
    // The brand's own colours, as ClientShell gives them to the tabs. DaviDan's
    // own need no second theme, and the Theme stays in the tree either way, so
    // switching brand doesn't rebuild the shell under it.
    final shellTheme =
        identical(brandColors, AppColors.dark) ||
            identical(brandColors, AppColors.light)
        ? theme
        : AppTheme.forBrand(brand, theme.brightness);

    // The bar is only there while the brand's cart holds something, and the
    // pages only leave room for it then.
    final showCartBar = ref.watch(cartCountProvider(brand)) > 0;

    return Theme(
      data: shellTheme,
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: context.colors.background,
          // Inside the page, where the bottom padding is the tab bar's height
          // (BottomBarSpace), which is what the cart bar rides above.
          body: Builder(
            builder: (context) {
              final media = MediaQuery.of(context);
              final bottom = media.padding.bottom;

              return Stack(
                children: [
                  // The MediaQuery stays in the tree whether the bar is up or
                  // not, only its bottom padding changes: taking it in and out
                  // would rebuild the page under it from scratch, and the feed
                  // would jump back to the top on the first thing added.
                  Positioned.fill(
                    child: MediaQuery(
                      data: media.copyWith(
                        padding: media.padding.copyWith(
                          bottom: bottom + (showCartBar ? CartBar.space : 0),
                        ),
                      ),
                      child: widget.child,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: _Chrome(brand: brand, showBack: widget.showBack),
                  ),
                  if (showCartBar)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: bottom + AppSpacing.sm,
                      child: CartBar(brand: brand),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// The room a page inside [BrandShell] leaves at the top of its scroll view
/// for the bar and the switcher above it.
class BrandShellSpace extends ConsumerWidget {
  const BrandShellSpace({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Grows and shrinks with the switcher, on the fold's own duration, so the
    // page rises under the bar as the row folds away rather than after it.
    return AnimatedContainer(
      height: BrandShell.chromeHeight(
        context,
        switcherOpen: ref.watch(switcherOpenProvider),
      ),
      duration: _foldDuration(context),
      curve: AppMotion.standard,
    );
  }
}

/// The sliver form of [BrandShellSpace], for a page built as a CustomScrollView.
class SliverBrandShellSpace extends StatelessWidget {
  const SliverBrandShellSpace({super.key});

  @override
  Widget build(BuildContext context) =>
      const SliverToBoxAdapter(child: BrandShellSpace());
}

class _Chrome extends ConsumerWidget {
  const _Chrome({required this.brand, required this.showBack});

  final Brand brand;
  final bool showBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final switcherUp = ref.watch(switcherOpenProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Opaque down to the switcher, so the page scrolling under it doesn't
        // show through the location, the bell or the brand names.
        ColoredBox(
          color: colors.background,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: MediaQuery.paddingOf(context).top),
              _LocationBar(brand: brand, showBack: showBack),
              // Folded away by its own height rather than taken out of the
              // tree: the row keeps where it was scrolled sideways to, and the
              // brand it marks doesn't flicker on the way back.
              ClipRect(
                child: AnimatedAlign(
                  alignment: Alignment.topCenter,
                  heightFactor: switcherUp ? 1 : 0,
                  duration: _foldDuration(context),
                  curve: AppMotion.standard,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: BrandShell._switcherGap,
                    ),
                    child: BrandSwitcherRow(
                      selected: brand,
                      onSelected: (chosen) => chosen == brand
                          // The open brand's own bubble returns to its feed,
                          // the way tapping the open tab returns to its first
                          // screen.
                          ? context.go(Routes.brandHome(brand))
                          // Replaces rather than pushes: the switcher filters
                          // the shell, so back doesn't walk through every
                          // brand tried.
                          : context.replace(Routes.brandHome(chosen)),
                    ),
                  ),
                ),
              ),
              _SwitcherHandle(
                open: switcherUp,
                onTap: () => ref.read(switcherOpenProvider.notifier).toggle(),
              ),
            ],
          ),
        ),
        // The page fades in under the switcher instead of being cut off by a
        // hard edge.
        IgnorePointer(
          child: SizedBox(
            height: BrandShell._fadeHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colors.background,
                    colors.background.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Where orders go, as a line of text that opens the location screen, the
/// launcher button (staff build only), search and the notifications: the
/// "Livrare la ▾" and bell header of Glovo, Wolt and Yandex Eda, kept to the
/// two buttons the reference apps carry beside the address.
///
/// Search is here and nowhere else: a field in the page scrolls away and a
/// category page never had one, so wherever the customer is in a brand, the
/// magnifier is on screen. The filter that once stood beside that field is on
/// the search screen this opens.
///
/// The cart is not: the [CartBar] at the foot carries the open brand's, and a
/// bag in the header would say the same thing twice. A brand with nothing to
/// sell (Rent Car, which is a request by phone, and the restaurant) has no
/// bar to carry it, so it keeps a bag that counts every cart and opens the
/// list of them, and no cart is ever out of reach.
class _LocationBar extends ConsumerWidget {
  const _LocationBar({required this.brand, required this.showBack});

  final Brand brand;
  final bool showBack;

  /// Every circle in the bar, back arrow and all: a size down from the app's
  /// default, so the bar reads as a line of small controls around the address
  /// rather than a row of buttons as tall as it.
  static const _buttonSize = 36.0;

  /// The pin or the storefront in front of the address, and the caret after
  /// it: both at the scale of the glyphs inside those circles, so nothing in
  /// the bar is drawn heavier than the address itself.
  static const _locationIconSize = 20.0;
  static const _caretSize = 12.0;

  /// The clear margin around each of those circles, which takes the place of
  /// the padding and the gaps beside it, so a circle sits where it would
  /// without one.
  static const _margin = (TapTarget.min - _buttonSize) / 2;

  /// What is left of the gap between two buttons once both their clear
  /// margins have been counted: at [_buttonSize] they more than cover it.
  static const _buttonGap = 2 * _margin >= AppSpacing.sm
      ? 0.0
      : AppSpacing.sm - 2 * _margin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinned = ref.watch(
      currentLocationProvider.select((state) => state.pinned),
    );
    // A location pinned for the next order comes first; the saved choice is
    // back once that order is placed or the pin is dropped.
    final location = pinned != null
        ? (
            icon: PhosphorIconsRegular.navigationArrow,
            label: context.l10n.deliverToCurrentLocation,
            value: context.l10n.currentLocationValue(
              context.l10n.areaName(sectorAt(pinned.point)),
            ),
          )
        : switch (ref.watch(fulfilmentChoiceProvider)) {
            HomeDelivery(:final address) => (
              icon: PhosphorIconsRegular.mapPin,
              label: context.l10n.deliverTo,
              value: address,
            ),
            StorePickup(:final locationId) => (
              icon: PhosphorIconsRegular.storefront,
              label: context.l10n.pickupFrom,
              value:
                  ref.watch(locationByIdProvider(locationId))?.name ??
                  locationId,
            ),
            null => (
              icon: PhosphorIconsRegular.mapPin,
              label: context.l10n.deliverTo,
              value: context.l10n.chooseAddress,
            ),
          };

    final colors = context.colors;
    final onClearLocation = pinned == null
        ? null
        : () => ref.read(currentLocationProvider.notifier).clear();
    // Only the staff build has a launcher to go back to.
    final onLauncherTap = ref.watch(extraAppsProvider).isEmpty
        ? null
        : () => context.go(Routes.launcher);
    final sells = mockCatalogs[brand]?.products.isNotEmpty ?? false;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter - AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.gutter - _margin,
        0,
      ),
      child: SizedBox(
        height: BrandShell.barHeight,
        child: Row(
          children: [
            if (showBack) ...[
              AppIconButton(
                icon: PhosphorIconsRegular.arrowLeft,
                semanticLabel: context.l10n.backHome,
                size: _buttonSize,
                onPressed: () => context.pop(),
              ),
              const SizedBox(width: _buttonGap),
            ],
            // The whole height of the bar takes the tap.
            Expanded(
              child: SizedBox(
                height: BrandShell.barHeight,
                child: InkWell(
                  onTap: () => context.push(Routes.clientLocation),
                  borderRadius: BorderRadius.circular(AppRadii.md),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          location.icon,
                          size: _locationIconSize,
                          color: colors.primary,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Flexible(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                location.label,
                                style: context.textStyles.caption,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      location.value,
                                      style: context.textStyles.subtitle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.xs),
                                  Icon(
                                    PhosphorIconsBold.caretDown,
                                    size: _caretSize,
                                    color: colors.textPrimary,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (onClearLocation != null)
              AppIconButton(
                icon: PhosphorIconsRegular.x,
                semanticLabel: context.l10n.dropCurrentLocation,
                size: 32,
                onPressed: onClearLocation,
              ),
            if (onLauncherTap case final onLauncherTap?)
              AppIconButton(
                icon: PhosphorIconsRegular.dotsNine,
                semanticLabel: context.l10n.openLauncher,
                size: _buttonSize,
                onPressed: onLauncherTap,
              ),
            const SizedBox(width: AppSpacing.sm - _margin),
            if (sells) ...[
              AppIconButton(
                icon: PhosphorIconsRegular.magnifyingGlass,
                semanticLabel: context.l10n.searchMenuHint,
                size: _buttonSize,
                onPressed: () => context.push(Routes.brandSearch(brand)),
              ),
              const SizedBox(width: _buttonGap),
            ],
            const NotificationsButton(size: _buttonSize),
            if (!sells) ...[
              const SizedBox(width: _buttonGap),
              const OpenCartsButton(size: _buttonSize),
            ],
          ],
        ),
      ),
    );
  }
}

/// How long the row takes to fold away and come back. The page's own room for
/// the chrome ([BrandShellSpace]) runs on the same token, so the two move as
/// one piece instead of the feed jumping ahead of the row.
Duration _foldDuration(BuildContext context) =>
    AppMotion.of(context, AppMotion.medium);

/// The handle under the brand switcher: a grabber and a chevron that folds
/// the row away, and brings it back from the slim strip it leaves behind. It
/// sits under the row, clear of the location, search and bell above, and stays
/// in the same place open or closed, so it is always where it was last found.
class _SwitcherHandle extends StatelessWidget {
  const _SwitcherHandle({required this.open, required this.onTap});

  final bool open;
  final VoidCallback onTap;

  /// The room the handle takes in the chrome: a slim strip, since all it
  /// shows is a grabber and a caret.
  static const height = 22.0;

  /// What can be tapped, which is larger than what is drawn: the caret alone
  /// is well under Android's 48 dp, so the hit box keeps the full size and
  /// reaches past the strip, above and below it in equal measure. It is only
  /// as wide as it needs to be, so the little it covers of the names above and
  /// the feed below is a narrow band in the middle rather than the whole
  /// width.
  static const _tapSize = TapTarget.min;

  /// The caret itself, which is the whole control: there is no dragging it,
  /// only tapping, so it carries no grabber bar pretending otherwise.
  static const _caretSize = 14.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Semantics(
      button: true,
      label: open ? l10n.hideBrands : l10n.showBrands,
      excludeSemantics: true,
      child: SizedBox(
        height: height,
        // The strip is what the layout gives up to the handle; the hit box
        // inside it is the full 48 dp, centred on the strip and allowed to
        // reach past it.
        child: Center(
          child: OverflowBox(
            maxWidth: _tapSize,
            maxHeight: _tapSize,
            child: InkWell(
              onTap: onTap,
              customBorder: const CircleBorder(),
              child: SizedBox(
                width: _tapSize,
                height: _tapSize,
                child: Center(
                  child: Icon(
                    open
                        ? PhosphorIconsBold.caretUp
                        : PhosphorIconsBold.caretDown,
                    size: _caretSize,
                    color: colors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
