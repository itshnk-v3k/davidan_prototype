import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/widgets/placeholder_screen.dart';
import 'package:davidan_prototype/features/client/presentation/home/home_screen.dart';
import 'package:davidan_prototype/features/client/presentation/shell/client_shell.dart';
import 'package:davidan_prototype/features/launcher/presentation/demo_launcher_screen.dart';

/// Order id used by placeholder links until real orders exist.
const _demoOrderId = 'DD-1042';

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: Routes.launcher,
    routes: [
      GoRoute(
        path: Routes.launcher,
        builder: (_, _) => const DemoLauncherScreen(),
      ),

      // --- Customer app ---
      GoRoute(
        path: Routes.clientSplash,
        builder: (_, _) => const PlaceholderScreen(
          title: AppStrings.splashTitle,
          location: Routes.clientSplash,
          links: [
            PlaceholderLink(AppStrings.continueLabel, Routes.clientLocation),
          ],
        ),
      ),
      GoRoute(
        path: Routes.clientLocation,
        builder: (_, _) => const PlaceholderScreen(
          title: AppStrings.locationTitle,
          location: Routes.clientLocation,
          links: [PlaceholderLink(AppStrings.continueLabel, Routes.clientHome)],
        ),
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
                builder: (_, _) => PlaceholderScreen(
                  title: AppStrings.menuTitle,
                  location: Routes.clientMenu,
                  links: [
                    PlaceholderLink(
                      AppStrings.openProduct,
                      Routes.clientProduct('croissant-ciocolata'),
                      push: true,
                    ),
                  ],
                ),
                routes: [
                  GoRoute(
                    path: ':categoryId',
                    builder: (_, state) => PlaceholderScreen(
                      title: AppStrings.menuTitle,
                      location: Routes.clientCategory(
                        state.pathParameters['categoryId']!,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.clientCart,
                builder: (_, _) => const PlaceholderScreen(
                  title: AppStrings.cartTitle,
                  location: Routes.clientCart,
                  links: [
                    PlaceholderLink(
                      AppStrings.goToCheckout,
                      Routes.clientCheckout,
                      push: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.clientProfile,
                builder: (_, _) => const PlaceholderScreen(
                  title: AppStrings.profileTitle,
                  location: Routes.clientProfile,
                ),
              ),
            ],
          ),
        ],
      ),
      // Full-screen routes above the tabs (no bottom bar).
      GoRoute(
        path: '/client/product/:productId',
        builder: (_, state) => PlaceholderScreen(
          title: AppStrings.productTitle,
          location: Routes.clientProduct(state.pathParameters['productId']!),
        ),
      ),
      GoRoute(
        path: Routes.clientCheckout,
        builder: (_, _) => PlaceholderScreen(
          title: AppStrings.checkoutTitle,
          location: Routes.clientCheckout,
          links: [
            PlaceholderLink(
              AppStrings.placeOrder,
              Routes.clientOrder(_demoOrderId),
            ),
          ],
        ),
      ),
      GoRoute(
        path: '/client/orders/:orderId',
        builder: (_, state) => PlaceholderScreen(
          title: AppStrings.orderTrackingTitle,
          location: Routes.clientOrder(state.pathParameters['orderId']!),
          links: const [
            PlaceholderLink(AppStrings.backHome, Routes.clientHome),
          ],
        ),
      ),

      // --- Courier app ---
      GoRoute(
        path: Routes.courierOrders,
        builder: (_, _) => PlaceholderScreen(
          title: AppStrings.courierOrdersTitle,
          location: Routes.courierOrders,
          links: [
            PlaceholderLink(
              AppStrings.openDelivery,
              Routes.courierDelivery(_demoOrderId),
              push: true,
            ),
          ],
        ),
        routes: [
          GoRoute(
            path: ':orderId',
            builder: (_, state) => PlaceholderScreen(
              title: AppStrings.courierDeliveryTitle,
              location: Routes.courierDelivery(
                state.pathParameters['orderId']!,
              ),
            ),
          ),
        ],
      ),

      // --- Store panel (KDS) ---
      GoRoute(
        path: Routes.kds,
        builder: (_, _) => const PlaceholderScreen(
          title: AppStrings.kdsTitle,
          location: Routes.kds,
        ),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
