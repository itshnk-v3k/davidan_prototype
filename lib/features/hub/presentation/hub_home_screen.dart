import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/extra_app.dart';
import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';
import 'package:davidan_prototype/core/widgets/search_bar_button.dart';
import 'package:davidan_prototype/data/mock/mock_sectors.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/account/application/current_location_notifier.dart';
import 'package:davidan_prototype/features/account/application/fulfilment_choice_notifier.dart';
import 'package:davidan_prototype/features/food/application/shop_providers.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/cart_button.dart';
import 'package:davidan_prototype/features/hub/presentation/widgets/active_orders_strip.dart';
import 'package:davidan_prototype/features/hub/presentation/widgets/brand_bubbles.dart';
import 'package:davidan_prototype/features/hub/presentation/widgets/notifications_button.dart';
import 'package:davidan_prototype/features/orders/application/customer_requests_provider.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// The Acasă tab: where orders go, the notifications and the way into every
/// brand's cart (pinned at the top), the search across every brand, the
/// orders and rental requests still under way, and the brands as a grid of
/// tiles, each opening the brand's pages inside Acasă.
class HubHomeScreen extends ConsumerWidget {
  const HubHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinned = ref.watch(
      currentLocationProvider.select((state) => state.pinned),
    );
    // A location pinned for the next order comes first; the saved choice is
    // back once that order is placed or the pin is dropped.
    final location = pinned != null
        ? (
            icon: Icons.my_location_rounded,
            label: context.l10n.deliverToCurrentLocation,
            value: context.l10n.currentLocationValue(
              context.l10n.areaName(sectorAt(pinned.point)),
            ),
          )
        : switch (ref.watch(fulfilmentChoiceProvider)) {
            HomeDelivery(:final address) => (
              icon: Icons.location_on_rounded,
              label: context.l10n.deliverTo,
              value: address,
            ),
            StorePickup(:final locationId) => (
              icon: Icons.storefront_rounded,
              label: context.l10n.pickupFrom,
              value:
                  ref.watch(locationByIdProvider(locationId))?.name ??
                  locationId,
            ),
            null => (
              icon: Icons.location_on_rounded,
              label: context.l10n.deliverTo,
              value: context.l10n.chooseAddress,
            ),
          };

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            // Stays at the top while everything below scrolls beneath it, so
            // the address or pickup shop, the notifications and the carts are
            // always one tap away.
            PinnedHeaderSliver(
              child: _HubHeader(
                location: location,
                onLocationTap: () => context.push(Routes.clientLocation),
                onClearLocation: pinned == null
                    ? null
                    : () => ref.read(currentLocationProvider.notifier).clear(),
                // Only the staff build has a launcher to go back to.
                onLauncherTap: ref.watch(extraAppsProvider).isEmpty
                    ? null
                    : () => context.go(Routes.launcher),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.gutter,
                  AppSpacing.xs,
                  AppSpacing.gutter,
                  AppSpacing.lg,
                ),
                child: SearchBarButton(
                  hint: context.l10n.searchHubHint,
                  onTap: () => context.push(Routes.clientSearch),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: ActiveOrdersStrip(
                onOpen: (request) => context.push(switch (request) {
                  OrderRequest(:final order) => Routes.clientOrder(order.id),
                  BookingRequest(:final booking) => Routes.clientBooking(
                    booking.id,
                  ),
                }),
              ),
            ),
            // The service selector: the brands as a grid of tiles.
            SliverToBoxAdapter(
              child: BrandBubbles(
                onOpen: (brand) => context.push(Routes.brandHome(brand)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Where orders go, as a line of text that opens the location screen, the
/// launcher button (staff build only), the notifications and the carts: the
/// "Livrare la ▾" and bell header of Glovo, Wolt and Yandex Eda.
class _HubHeader extends StatelessWidget {
  const _HubHeader({
    required this.location,
    required this.onLocationTap,
    required this.onClearLocation,
    required this.onLauncherTap,
  });

  /// What the header shows: a pinned current location, the saved choice, or a
  /// prompt to make one.
  final ({IconData icon, String label, String value}) location;
  final VoidCallback onLocationTap;

  /// Drops a pinned current location. Null when none is pinned.
  final VoidCallback? onClearLocation;

  /// Null hides the launcher button.
  final VoidCallback? onLauncherTap;

  @override
  Widget build(BuildContext context) {
    // The buttons' clear margins take the place of the padding and the gaps
    // between them, so the circles sit where they would without them.
    const margin = TapTarget.iconButtonMargin;
    final onClearLocation = this.onClearLocation;
    final colors = context.colors;

    // Opaque, so the content scrolling beneath doesn't show through.
    return ColoredBox(
      color: colors.background,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.gutter - AppSpacing.sm,
          AppSpacing.sm,
          AppSpacing.gutter - margin,
          AppSpacing.sm,
        ),
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              // The whole height of the header takes the tap.
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: InkWell(
                    onTap: onLocationTap,
                    borderRadius: BorderRadius.circular(AppRadii.md),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                      ),
                      child: Row(
                        children: [
                          Icon(location.icon, size: 24, color: colors.primary),
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
                                    Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 22,
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
                  icon: Icons.close_rounded,
                  semanticLabel: context.l10n.dropCurrentLocation,
                  size: 32,
                  onPressed: onClearLocation,
                ),
              if (onLauncherTap case final onLauncherTap?)
                AppIconButton(
                  icon: Icons.apps_rounded,
                  semanticLabel: context.l10n.openLauncher,
                  onPressed: onLauncherTap,
                ),
              const SizedBox(width: AppSpacing.sm - margin),
              const NotificationsButton(),
              const SizedBox(width: AppSpacing.sm - 2 * margin),
              const OpenCartsButton(),
            ],
          ),
        ),
      ),
    );
  }
}
