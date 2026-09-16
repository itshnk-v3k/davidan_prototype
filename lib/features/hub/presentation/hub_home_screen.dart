import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/extra_app.dart';
import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/core/widgets/app_icon_button.dart';
import 'package:davidan_prototype/core/widgets/brand_logo.dart';
import 'package:davidan_prototype/data/mock/mock_sectors.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/account/application/current_location_notifier.dart';
import 'package:davidan_prototype/features/account/application/fulfilment_choice_notifier.dart';
import 'package:davidan_prototype/features/food/application/shop_providers.dart';
import 'package:davidan_prototype/features/hub/presentation/widgets/active_orders_strip.dart';
import 'package:davidan_prototype/features/hub/presentation/widgets/brand_bubbles.dart';
import 'package:davidan_prototype/features/hub/presentation/widgets/for_you_sheet.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// The Acasă tab: DaviDan's logo, where orders go (pinned at the top), the
/// orders still on their way, the brands as bubbles on DaviDan's caramel, each
/// opening the brand full screen above the tabs, and "pentru tine", products
/// from every brand.
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
            SliverToBoxAdapter(
              child: _HubHeader(
                // Only the staff build has a launcher to go back to.
                onLauncherTap: ref.watch(extraAppsProvider).isEmpty
                    ? null
                    : () => context.go(Routes.launcher),
              ),
            ),
            // Stays at the top while everything below scrolls beneath it, so
            // the address or pickup shop is always one tap away.
            PinnedHeaderSliver(
              child: _LocationBar(
                location: location,
                onTap: () => context.push(Routes.clientLocation),
                onClear: pinned == null
                    ? null
                    : () => ref.read(currentLocationProvider.notifier).clear(),
              ),
            ),
            SliverToBoxAdapter(
              child: ActiveOrdersStrip(
                onOpen: (order) => context.push(Routes.clientOrder(order.id)),
              ),
            ),
            SliverToBoxAdapter(
              child: BrandBubbles(
                onOpen: (brand) => context.push(Routes.brandHome(brand)),
              ),
            ),
            const SliverToBoxAdapter(child: ForYouSheet()),
          ],
        ),
      ),
    );
  }
}

class _HubHeader extends StatelessWidget {
  const _HubHeader({required this.onLauncherTap});

  /// Null hides the launcher button.
  final VoidCallback? onLauncherTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.md,
        AppSpacing.gutter,
        0,
      ),
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            const BrandLogo(height: 26),
            const Spacer(),
            if (onLauncherTap case final onLauncherTap?)
              AppIconButton(
                icon: Icons.apps_rounded,
                semanticLabel: context.l10n.openLauncher,
                onPressed: onLauncherTap,
              ),
          ],
        ),
      ),
    );
  }
}

class _LocationBar extends StatelessWidget {
  const _LocationBar({
    required this.location,
    required this.onTap,
    required this.onClear,
  });

  /// What the bar shows: a pinned current location, the saved choice, or a
  /// prompt to make one.
  final ({IconData icon, String label, String value}) location;
  final VoidCallback onTap;

  /// Drops a pinned current location. Null when none is pinned.
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final onClear = this.onClear;

    // Opaque, so the content scrolling beneath doesn't show through.
    return ColoredBox(
      color: context.colors.background,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.gutter,
          AppSpacing.md,
          AppSpacing.gutter,
          AppSpacing.lg,
        ),
        child: Material(
          color: context.colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md),
            side: BorderSide(color: context.colors.border),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm + AppSpacing.xxs),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: context.colors.accentSoft,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      location.icon,
                      size: 20,
                      color: context.colors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(location.label, style: context.textStyles.caption),
                        Text(
                          location.value,
                          style: context.textStyles.bodyStrong,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (onClear != null)
                    AppIconButton(
                      icon: Icons.close_rounded,
                      semanticLabel: context.l10n.dropCurrentLocation,
                      size: 32,
                      onPressed: onClear,
                    )
                  else
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: context.colors.textSecondary,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
