import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:davidan_prototype/core/location/location_result.dart';
import 'package:davidan_prototype/core/router/extra_app.dart';
import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/widgets/phone_frame.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/account/presentation/location/location_screen.dart';
import 'package:davidan_prototype/features/account/presentation/location/map_picker_screen.dart';
import 'package:davidan_prototype/features/account/presentation/profile/profile_screen.dart';
import 'package:davidan_prototype/features/account/presentation/sign_in/sign_in_code_screen.dart';
import 'package:davidan_prototype/features/account/presentation/sign_in/sign_in_details_screen.dart';
import 'package:davidan_prototype/features/account/presentation/sign_in/sign_in_phone_screen.dart';
import 'package:davidan_prototype/features/account/presentation/sign_in/welcome_screen.dart';
import 'package:davidan_prototype/features/food/application/catalog_providers.dart';
import 'package:davidan_prototype/features/food/presentation/cart/cart_screen.dart';
import 'package:davidan_prototype/features/food/presentation/catalog/catalog_screen.dart';
import 'package:davidan_prototype/features/food/presentation/checkout/checkout_screen.dart';
import 'package:davidan_prototype/features/food/presentation/favorites/favorites_screen.dart';
import 'package:davidan_prototype/features/food/presentation/home/brand_home_screen.dart';
import 'package:davidan_prototype/features/food/presentation/product/product_detail_screen.dart';
import 'package:davidan_prototype/features/hub/presentation/brand_intro_screen.dart';
import 'package:davidan_prototype/features/hub/presentation/client_shell.dart';
import 'package:davidan_prototype/features/hub/presentation/hub_home_screen.dart';
import 'package:davidan_prototype/features/hub/presentation/splash/splash_screen.dart';
import 'package:davidan_prototype/features/launcher/presentation/demo_launcher_screen.dart';
import 'package:davidan_prototype/features/orders/presentation/order_confirmation_screen.dart';
import 'package:davidan_prototype/features/orders/presentation/orders_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final extraApps = ref.watch(extraAppsProvider);
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
          // The demo launcher, when the entry point registers something
          // besides the customer app (lib/main_staff.dart). The customer app
          // build has nothing else to launch, so it opens on the splash.
          GoRoute(
            path: Routes.launcher,
            redirect: (_, _) => extraApps.isEmpty ? Routes.clientSplash : null,
            builder: (_, _) => const DemoLauncherScreen(),
          ),

          // --- Customer app ---
          // The launcher enters the customer app here. The splash replaces
          // itself with the demo sign-in on first launch, then with home, or
          // with the location screen when nothing is chosen yet.
          GoRoute(
            path: Routes.clientSplash,
            builder: (_, _) => const SplashScreen(),
          ),
          // Demo sign-in (no real SMS). Each step is pushed on the previous
          // one, so back returns to it and what was typed is kept.
          GoRoute(
            path: Routes.signIn,
            builder: (_, _) => const SignInPhoneScreen(),
            routes: [
              GoRoute(
                path: 'code',
                builder: (_, _) => const SignInCodeScreen(),
              ),
              GoRoute(
                path: 'details',
                builder: (_, _) => const SignInDetailsScreen(),
              ),
            ],
          ),
          // Opened with go() once the account exists, so back can't return
          // into the finished form.
          GoRoute(
            path: Routes.welcome,
            builder: (_, _) => const WelcomeScreen(),
          ),
          // Opened with go() on first run and after sign-up, pushed from the
          // home location bar otherwise.
          GoRoute(
            path: Routes.clientLocation,
            builder: (_, state) => LocationScreen(
              suggestNearest: state.uri.queryParameters['suggest'] == 'nearest',
            ),
            routes: [
              // Pushed when the phone's location isn't available.
              GoRoute(
                path: 'map',
                builder: (_, state) => MapPickerScreen(
                  failure: LocationFailure.values
                      .asNameMap()[state.uri.queryParameters['reason']],
                ),
              ),
            ],
          ),
          // The hub's tabs: each branch keeps its own navigation stack. Keep
          // the branch order in sync with the bottom navigation items in
          // ClientShell. ClientShell.tabStack works like indexedStack and
          // also keeps hidden tabs out of the product photo's hero flight.
          StatefulShellRoute(
            navigatorContainerBuilder: ClientShell.tabStack,
            builder: (_, _, navigationShell) =>
                ClientShell(navigationShell: navigationShell),
            branches: [
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: Routes.clientHome,
                    builder: (_, _) => const HubHomeScreen(),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: Routes.clientOrders,
                    builder: (_, _) => const OrdersScreen(),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: Routes.clientFavorites,
                    builder: (_, _) => const FavoritesScreen(),
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
          // A brand, full screen above the tabs (no bottom bar), pushed from
          // its bubble on the hub. Its screens push the ones below, so back
          // returns to the screen they were opened from. Each names its brand
          // (Routes.brandHome and the others); an unknown brand goes to the
          // hub.
          GoRoute(
            path: '/b/:${Routes.brandParam}',
            redirect: _unknownBrandGoesHome,
            builder: (_, state) => switch (_brandIn(state)!) {
              Brand.bakery => const BrandHomeScreen(brand: Brand.bakery),
              // The client has no restaurant menu yet: its intro stays.
              Brand.restaurant => const BrandIntroScreen(
                brand: Brand.restaurant,
              ),
              // TEMPORARY until their own pages are built (hub round steps
              // 5, 6 and 7).
              final brand => BrandIntroScreen(brand: brand, inProgress: true),
            },
          ),
          GoRoute(
            path: '/b/:${Routes.brandParam}/menu',
            // A brand without a menu shows its home instead.
            redirect: (context, state) =>
                _unknownBrandGoesHome(context, state) ??
                (ref.read(categoriesProvider(_brandIn(state)!)).isEmpty
                    ? Routes.brandHome(_brandIn(state)!)
                    : null),
            // The category is a query parameter (Routes.brandMenu). Switching
            // category replaces this page, keeping its key, so there is no
            // transition and CatalogScreen just rebuilds.
            builder: (_, state) => CatalogScreen(
              brand: _brandIn(state)!,
              categoryId: state.uri.queryParameters['category'],
            ),
          ),
          // Pushed by the brand's cart button.
          GoRoute(
            path: '/b/:${Routes.brandParam}/cart',
            redirect: _unknownBrandGoesHome,
            builder: (_, state) => CartScreen(brand: _brandIn(state)!),
          ),
          GoRoute(
            path: '/b/:${Routes.brandParam}/product/:productId',
            redirect: _unknownBrandGoesHome,
            builder: (_, state) => ProductDetailScreen(
              productKey: (
                brand: _brandIn(state)!,
                id: state.pathParameters['productId']!,
              ),
              heroScope: state.uri.queryParameters['from'],
            ),
          ),
          GoRoute(
            path: '/b/:${Routes.brandParam}/checkout',
            redirect: _unknownBrandGoesHome,
            builder: (_, state) => CheckoutScreen(brand: _brandIn(state)!),
          ),
          // Opened with go() after checkout, so back doesn't return to the
          // emptied checkout.
          GoRoute(
            path: '/client/orders/:orderId',
            builder: (_, state) => OrderConfirmationScreen(
              orderId: state.pathParameters['orderId']!,
            ),
          ),

          // --- Staff phone apps (the courier app), when registered ---
          for (final app in extraApps) ...app.phoneRoutes,
        ],
      ),

      // --- Whole-window screens (the store panel, the demo board), when
      // registered ---
      for (final app in extraApps) ...app.windowRoutes,
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});

/// The brand a `/b/:brand/...` URL names, or null when it names none.
Brand? _brandIn(GoRouterState state) =>
    Brand.values.asNameMap()[state.pathParameters[Routes.brandParam]];

String? _unknownBrandGoesHome(BuildContext _, GoRouterState state) =>
    _brandIn(state) == null ? Routes.clientHome : null;
