import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:davidan_prototype/core/location/location_result.dart';
import 'package:davidan_prototype/core/router/extra_app.dart';
import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/brand_colors.dart';
import 'package:davidan_prototype/core/widgets/phone_frame.dart';
import 'package:davidan_prototype/data/mock/mock_brand.dart';
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
import 'package:davidan_prototype/features/food/presentation/cart/open_carts_screen.dart';
import 'package:davidan_prototype/features/food/presentation/catalog/catalog_screen.dart';
import 'package:davidan_prototype/features/food/presentation/checkout/checkout_screen.dart';
import 'package:davidan_prototype/features/food/presentation/favorites/favorites_screen.dart';
import 'package:davidan_prototype/features/food/presentation/home/brand_home_screen.dart';
import 'package:davidan_prototype/features/food/presentation/home/water_home_screen.dart';
import 'package:davidan_prototype/features/food/presentation/product/product_detail_screen.dart';
import 'package:davidan_prototype/features/hub/presentation/brand_info_screen.dart';
import 'package:davidan_prototype/features/hub/presentation/brand_intro_screen.dart';
import 'package:davidan_prototype/features/hub/presentation/client_shell.dart';
import 'package:davidan_prototype/features/hub/presentation/hub_home_screen.dart';
import 'package:davidan_prototype/features/hub/presentation/legal_document_screen.dart';
import 'package:davidan_prototype/features/hub/presentation/splash/splash_screen.dart';
import 'package:davidan_prototype/features/launcher/presentation/demo_launcher_screen.dart';
import 'package:davidan_prototype/features/orders/presentation/order_confirmation_screen.dart';
import 'package:davidan_prototype/features/orders/presentation/orders_screen.dart';
import 'package:davidan_prototype/features/rental/application/rental_providers.dart';
import 'package:davidan_prototype/features/rental/presentation/car_detail_screen.dart';
import 'package:davidan_prototype/features/rental/presentation/rental_booking_screen.dart';
import 'package:davidan_prototype/features/rental/presentation/rental_home_screen.dart';
import 'package:davidan_prototype/features/rental/presentation/rental_request_screen.dart';

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
                    routes: [
                      // A brand's browse screens, above the hub and under the
                      // bottom bar, pushed from its bubble on the hub. Its
                      // screens push the ones below, so back returns to the
                      // screen they were opened from; opened straight from a
                      // link, the brand's home and the hub are underneath.
                      // Each names its brand (Routes.brandHome and the
                      // others); an unknown brand goes to the hub.
                      GoRoute(
                        path: 'b/:${Routes.brandParam}',
                        redirect: _unknownBrandGoesHome,
                        builder: (_, state) =>
                            _branded(state, switch (_brandIn(state)!) {
                              final brand && (Brand.bakery || Brand.sushi) =>
                                BrandHomeScreen(brand: brand),
                              Brand.water => const WaterHomeScreen(),
                              // The client has no restaurant menu yet: its
                              // intro stays.
                              Brand.restaurant => const BrandIntroScreen(
                                brand: Brand.restaurant,
                              ),
                              Brand.carRental => const RentalHomeScreen(),
                            }),
                        routes: [
                          GoRoute(
                            path: 'menu',
                            // A brand without a menu shows its home instead.
                            redirect: (_, state) =>
                                ref
                                    .read(categoriesProvider(_brandIn(state)!))
                                    .isEmpty
                                ? Routes.brandHome(_brandIn(state)!)
                                : null,
                            // The category is a query parameter
                            // (Routes.brandMenu). Switching category replaces
                            // this page, keeping its key, so there is no
                            // transition and CatalogScreen just rebuilds.
                            builder: (_, state) => _branded(
                              state,
                              CatalogScreen(
                                brand: _brandIn(state)!,
                                categoryId:
                                    state.uri.queryParameters['category'],
                              ),
                            ),
                          ),
                          // Pushed by the brand home's info button.
                          _brandInfoRoute('info', tab: Routes.clientHome),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: Routes.clientOrders,
                    // The brand filter is a query parameter
                    // (Routes.clientOrdersOf), like the menu's category.
                    builder: (_, state) => OrdersScreen(
                      brand: _brandNamed(state.uri.queryParameters['brand']),
                    ),
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
                    routes: [
                      // Pushed from the brand list, so they open inside
                      // Profil rather than Acasă.
                      _brandInfoRoute(
                        'b/:${Routes.brandParam}/info',
                        tab: Routes.clientProfile,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          // A brand's task screens, full screen above the tabs: each has its
          // own bottom button. They reach the brand's browse screens inside
          // Acasă with go() (see Routes).
          //
          // Pushed by the brand's cart button.
          GoRoute(
            path: '/b/:${Routes.brandParam}/cart',
            redirect: _unknownBrandGoesHome,
            builder: (_, state) =>
                _branded(state, CartScreen(brand: _brandIn(state)!)),
          ),
          GoRoute(
            path: '/b/:${Routes.brandParam}/product/:productId',
            redirect: _unknownBrandGoesHome,
            builder: (_, state) => _branded(
              state,
              ProductDetailScreen(
                productKey: (
                  brand: _brandIn(state)!,
                  id: state.pathParameters['productId']!,
                ),
                heroScope: state.uri.queryParameters['from'],
              ),
            ),
          ),
          GoRoute(
            path: '/b/:${Routes.brandParam}/checkout',
            redirect: _unknownBrandGoesHome,
            builder: (_, state) =>
                _branded(state, CheckoutScreen(brand: _brandIn(state)!)),
          ),
          // A car of the rental fleet, pushed from its card, and its request
          // form, pushed from the car. Only Rent Car has cars: any other
          // brand, or a car the fleet doesn't have, shows the brand's home.
          GoRoute(
            path: '/b/:${Routes.brandParam}/car/:carId',
            redirect: (context, state) =>
                _unknownBrandGoesHome(context, state) ??
                (_brandIn(state) != Brand.carRental ||
                        ref.read(
                              rentalCarByIdProvider(
                                state.pathParameters['carId']!,
                              ),
                            ) ==
                            null
                    ? Routes.brandHome(_brandIn(state)!)
                    : null),
            builder: (_, state) => _branded(
              state,
              CarDetailScreen(carId: state.pathParameters['carId']!),
            ),
            routes: [
              GoRoute(
                path: 'request',
                builder: (_, state) => _branded(
                  state,
                  RentalRequestScreen(carId: state.pathParameters['carId']!),
                ),
              ),
            ],
          ),
          // Pushed by the carts button on the hub's Acasă and Favorite tabs.
          GoRoute(
            path: Routes.openCarts,
            builder: (_, _) => const OpenCartsScreen(),
          ),
          // Opened with go() after checkout, so back doesn't return to the
          // emptied checkout.
          GoRoute(
            path: '/client/orders/:orderId',
            builder: (_, state) => OrderConfirmationScreen(
              orderId: state.pathParameters['orderId']!,
            ),
          ),

          // Opened with go() once a car rental request is sent, so back
          // doesn't return to the sent form; pushed from Comenzi and the hub.
          GoRoute(
            path: '/client/bookings/:bookingId',
            builder: (_, state) => RentalBookingScreen(
              bookingId: state.pathParameters['bookingId']!,
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

/// A brand's information page and its legal pages at [path], inside [tab]
/// (Routes.clientHome or Routes.clientProfile), for a brand that has an
/// information page; any other brand shows its home instead. A legal page the
/// brand doesn't have shows the information page.
GoRoute _brandInfoRoute(String path, {required String tab}) => GoRoute(
  path: path,
  redirect: (context, state) =>
      _unknownBrandGoesHome(context, state) ??
      (brandInfos[_brandIn(state)!] == null
          ? Routes.brandHome(_brandIn(state)!)
          : null),
  builder: (_, state) =>
      _branded(state, BrandInfoScreen(brand: _brandIn(state)!, tab: tab)),
  routes: [
    GoRoute(
      path: ':documentId',
      redirect: (_, state) {
        final brand = _brandIn(state)!;
        final documentId = state.pathParameters['documentId'];
        final documents = brandInfos[brand]!.documents;
        return documents.any((document) => document.id == documentId)
            ? null
            : Routes.brandInfo(brand, tab: tab);
      },
      builder: (_, state) => _branded(
        state,
        LegalDocumentScreen(
          brand: _brandIn(state)!,
          documentId: state.pathParameters['documentId']!,
        ),
      ),
    ),
  ],
);

/// The brand a `/b/:brand/...` URL names, or null when it names none.
Brand? _brandIn(GoRouterState state) =>
    _brandNamed(state.pathParameters[Routes.brandParam]);

Brand? _brandNamed(String? name) => Brand.values.asNameMap()[name];

/// A brand's screen in the brand's colours.
Widget _branded(GoRouterState state, Widget screen) =>
    BrandTheme(brand: _brandIn(state)!, child: screen);

String? _unknownBrandGoesHome(BuildContext _, GoRouterState state) =>
    _brandIn(state) == null ? Routes.clientHome : null;
