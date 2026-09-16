import 'package:flutter_riverpod/misc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/core/router/extra_app.dart';
import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/demo_tools/demo_tools.dart';
import 'package:davidan_prototype/features/courier/application/courier_online_notifier.dart';
import 'package:davidan_prototype/features/courier/presentation/courier_delivery_screen.dart';
import 'package:davidan_prototype/features/courier/presentation/courier_orders_screen.dart';
import 'package:davidan_prototype/features/kds/presentation/kds_screen.dart';
import 'package:davidan_prototype/features/orders/application/order_simulation.dart';

// The staff build: the customer app plus the courier app, the store panel and
// the all-roles board, for phase 2. The client asked for the staff apps to be
// left out of the demo, so only lib/main_staff.dart imports this folder
// (test/architecture checks that) and lib/main.dart never compiles them in.

/// The courier app and the store panel.
final List<ExtraApp> staffApps = [
  ExtraApp(
    title: (l10n) => l10n.launcherCourier,
    hint: (l10n) => l10n.launcherCourierHint,
    icon: Icons.delivery_dining_rounded,
    location: Routes.courierOrders,
    phoneRoutes: [
      GoRoute(
        path: Routes.courierOrders,
        builder: (_, _) => const CourierOrdersScreen(),
        routes: [
          // A child route, so the list is underneath and back returns to it
          // even when a delivery is opened straight from a URL.
          GoRoute(
            path: ':orderId',
            builder: (_, state) => CourierDeliveryScreen(
              orderId: state.pathParameters['orderId']!,
            ),
          ),
        ],
      ),
    ],
    savedState: [courierOnlineProvider],
  ),
  ExtraApp(
    title: (l10n) => l10n.launcherKds,
    hint: (l10n) => l10n.launcherKdsHint,
    icon: Icons.storefront_rounded,
    location: Routes.kds,
    // A tablet or desktop screen, outside the phone frame.
    windowRoutes: [
      GoRoute(path: Routes.kds, builder: (_, _) => const KdsScreen()),
    ],
  ),
];

/// Everything lib/main_staff.dart adds to the customer app.
final List<Override> staffBuildOverrides = [
  extraAppsProvider.overrideWithValue([...staffApps, ...demoTools]),
  // The store panel and the courier move orders on here, so nothing is
  // simulated.
  orderSimulationProvider.overrideWithValue(false),
];
