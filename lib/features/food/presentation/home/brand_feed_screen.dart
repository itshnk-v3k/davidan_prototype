import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/widgets/bottom_bar_space.dart';
import 'package:davidan_prototype/core/widgets/link_card.dart';
import 'package:davidan_prototype/data/mock/mock_brand.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/food/presentation/home/menu_feed.dart';
import 'package:davidan_prototype/features/food/presentation/home/water_feed.dart';
import 'package:davidan_prototype/features/hub/application/last_brand_notifier.dart';
import 'package:davidan_prototype/features/orders/application/customer_requests_provider.dart';
import 'package:davidan_prototype/features/hub/presentation/brand_shell.dart';
import 'package:davidan_prototype/features/hub/presentation/widgets/active_orders_strip.dart';
import 'package:davidan_prototype/features/hub/presentation/widgets/coming_soon_feed.dart';
import 'package:davidan_prototype/features/rental/presentation/rental_feed.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

/// Acasă's page: one layout every brand opens in, under the shell's bar and
/// brand switcher ([BrandShell]). The orders still on their way come first,
/// then the brand's own content: its menu for the brands that have one, the
/// water's page, the rental fleet, or "În curând" for a brand that isn't open
/// in the app yet.
///
/// Every brand shares this screen rather than having one of its own, so the
/// switcher above only has to swap what is inside it.
class BrandFeedScreen extends ConsumerStatefulWidget {
  const BrandFeedScreen({super.key, required this.brand});

  final Brand brand;

  @override
  ConsumerState<BrandFeedScreen> createState() => _BrandFeedScreenState();
}

class _BrandFeedScreenState extends ConsumerState<BrandFeedScreen> {
  @override
  void initState() {
    super.initState();
    _remember();
  }

  @override
  void didUpdateWidget(BrandFeedScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.brand != oldWidget.brand) _remember();
  }

  /// Acasă opens on this brand next time. Written after the frame, since the
  /// switcher that changed it is being built right now.
  void _remember() {
    final brand = widget.brand;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(lastBrandProvider.notifier).remember(brand);
    });
  }

  @override
  Widget build(BuildContext context) {
    final brand = widget.brand;

    return CustomScrollView(
      // A new key per brand starts each feed at the top rather than at the
      // last brand's scroll position.
      key: ValueKey(brand),
      slivers: [
        const SliverBrandShellSpace(),
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
        switch (brand) {
          Brand.bakery || Brand.sushi => MenuFeed(brand: brand),
          Brand.water => const WaterFeed(),
          Brand.carRental => const RentalFeed(),
          // The client has no restaurant menu yet: its intro stays.
          Brand.restaurant => const ComingSoonFeed(brand: Brand.restaurant),
        },
        // The brand's contacts and legal pages, at the end of its feed, for a
        // brand that has them. The shell's bar has no room for a button of
        // its own, and this is where a shop page puts its details.
        if (brandInfos[brand] case final info?)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.gutter,
                AppSpacing.xl,
                AppSpacing.gutter,
                0,
              ),
              child: LinkCard(
                icon: PhosphorIconsRegular.info,
                title: context.l10n.openBrandInfo(info.name),
                hint: context.l10n.profileBrandInfoHint,
                onTap: () => context.push(Routes.brandInfo(brand)),
              ),
            ),
          ),
        const SliverBottomBarSpace(),
      ],
    );
  }
}
