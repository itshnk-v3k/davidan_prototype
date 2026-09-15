import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:davidan_prototype/core/router/demo_tool.dart';
import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/widgets/phone_frame.dart';
import 'package:davidan_prototype/features/client/presentation/cart/cart_screen.dart';
import 'package:davidan_prototype/features/client/presentation/catalog/catalog_screen.dart';
import 'package:davidan_prototype/features/client/presentation/checkout/checkout_screen.dart';
import 'package:davidan_prototype/features/client/presentation/home/home_screen.dart';
import 'package:davidan_prototype/features/client/presentation/location/location_screen.dart';
import 'package:davidan_prototype/features/client/presentation/orders/order_confirmation_screen.dart';
import 'package:davidan_prototype/features/client/presentation/product/product_detail_screen.dart';
import 'package:davidan_prototype/features/client/presentation/profile/profile_screen.dart';
import 'package:davidan_prototype/features/client/presentation/shell/client_shell.dart';
import 'package:davidan_prototype/features/client/presentation/splash/splash_screen.dart';
import 'package:davidan_prototype/features/courier/presentation/courier_delivery_screen.dart';
import 'package:davidan_prototype/features/courier/presentation/courier_orders_screen.dart';
import 'package:davidan_prototype/features/kds/presentation/kds_screen.dart';
import 'package:davidan_prototype/features/launcher/presentation/demo_launcher_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: Routes.launcher,
    routes: [
      // The launcher, customer app and courier app are phone apps: on a
      // desktop browser they render inside PhoneFrame. The frame is part of
      // the route tree, so nothing above the Router has to listen to route
      // changes. Dialogs opened here should pass useRootNavigator: false, or
      // they appear outside the frame.
      ShellRoute(
        builder: (_, _, child) => PhoneFrame(child: child),
        routes: [
          GoRoute(
            path: Routes.launcher,
            builder: (_, _) => const DemoLauncherScreen(),
          ),

          // --- Customer app ---
          // The launcher enters the customer app here. The splash replaces
          // itself with home, or with the location screen on first run.
          GoRoute(
            path: Routes.clientSplash,
            builder: (_, _) => const SplashScreen(),
          ),
          // Opened with go() on first run, pushed from the home location bar
          // afterwards.
          GoRoute(
            path: Routes.clientLocation,
            builder: (_, _) => const LocationScreen(),
          ),
          // Tabs: each branch keeps its own navigation stack. Keep the branch
          // order in sync with the bottom navigation items in ClientShell.
          StatefulShellRoute.indexedStack(
            builder: (_, _, navigationShell) =>
                ClientShell(navigationShell: navigationShell),
            branches: [
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: Routes.clientHome,
                    builder: (_, _) => const HomeScreen(),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: Routes.clientMenu,
                    // The category is a query parameter
                    // (Routes.clientCategory). go_router keys the page by
                    // path only, so switching category reuses this page
                    // without a transition and just rebuilds CatalogScreen.
                    builder: (_, state) => CatalogScreen(
                      categoryId: state.uri.queryParameters['category'],
                    ),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: Routes.clientCart,
                    builder: (_, _) => const CartScreen(),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: Routes.clientProfile,
                    builder: (_, _) => const ProfileScreen(),
                  ),
                ],
              ),
            ],
          ),
          // Full-screen routes above the tabs (no bottom bar). Screens push
          // these, so back returns to the screen they were opened from.
          GoRoute(
            path: '/client/product/:productId',
            builder: (_, state) => ProductDetailScreen(
              productId: state.pathParameters['productId']!,
            ),
          ),
          GoRoute(
            path: Routes.clientCheckout,
            builder: (_, _) => const CheckoutScreen(),
          ),
          // Opened with go() after checkout, so back doesn't return to the
          // emptied checkout.
          GoRoute(
            path: '/client/orders/:orderId',
            builder: (_, state) => OrderConfirmationScreen(
              orderId: state.pathParameters['orderId']!,
            ),
          ),

          // --- Courier app ---
          GoRoute(
            path: Routes.courierOrders,
            builder: (_, _) => const CourierOrdersScreen(),
            routes: [
              // A child route, so the list is underneath and back returns to
              // it even when a delivery is opened straight from a URL.
              GoRoute(
                path: ':orderId',
                builder: (_, state) => CourierDeliveryScreen(
                  orderId: state.pathParameters['orderId']!,
                ),
              ),
            ],
          ),
        ],
      ),

      // --- Store panel (KDS): a tablet/desktop screen, outside the frame ---
      GoRoute(path: Routes.kds, builder: (_, _) => const KdsScreen()),

      // --- Demo tools: none unless the entry point registers some ---
      for (final tool in ref.watch(demoToolsProvider)) tool.route,
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
