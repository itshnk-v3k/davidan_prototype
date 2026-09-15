// Profile screen (/client/profile) in the real app, in Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/client/presentation/catalog/catalog_screen.dart';
import 'package:davidan_prototype/features/client/presentation/orders/order_confirmation_screen.dart';
import 'package:davidan_prototype/features/client/presentation/profile/profile_screen.dart';

import '../../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  setUp(() async => container = await createTestContainer());

  Finder inProfile(Finder finder) => inScreen<ProfileScreen>(finder);

  testWidgets('the Profil tab opens it', (tester) async {
    await pumpApp(tester, container, Routes.clientHome);
    await tester.tap(find.text(AppStrings.navProfile));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen), findsOneWidget);
  });

  testWidgets('without orders: an empty state that links to the menu', (
    tester,
  ) async {
    await pumpApp(tester, container, Routes.clientProfile);

    expect(inProfile(find.text(AppStrings.ordersEmptyTitle)), findsOneWidget);

    await tapVisible(tester, find.text(AppStrings.browseMenu));
    expect(find.byType(CatalogScreen), findsOneWidget);
  });

  testWidgets('the "Despre DaviDan" facts are gone', (tester) async {
    placeTestOrder(container);
    await pumpApp(tester, container, Routes.clientProfile);

    expect(inProfile(find.text('Despre DaviDan')), findsNothing);
    expect(inProfile(find.text('Angajați')), findsNothing);
    expect(inProfile(find.text('720')), findsNothing);
    expect(inProfile(find.text('74')), findsNothing);
    expect(inProfile(find.text('2.000.000+')), findsNothing);
  });

  testWidgets(
    'order history: newest first, with date, fulfilment, total and a status '
    'that follows the store',
    (tester) async {
      final delivery = placeTestOrder(container);
      final pickup = placeTestOrder(
        container,
        fulfilment: const StorePickup(locationId: 'botanica'),
      );
      await pumpApp(tester, container, Routes.clientProfile);

      expect(inProfile(find.text(AppStrings.ordersEmptyTitle)), findsNothing);
      expect(
        tester.getTopLeft(find.text(AppStrings.orderNumber(pickup.id))).dy,
        lessThan(
          tester.getTopLeft(find.text(AppStrings.orderNumber(delivery.id))).dy,
        ),
      );
      expect(inProfile(find.text('15.09.2026, 10:07')), findsNWidgets(2));
      expect(inProfile(find.text('str. Ismail 88')), findsOneWidget);
      expect(
        inProfile(find.text('DaviDan Botanica · bd. Dacia 47, Chișinău')),
        findsOneWidget,
      );
      expect(inProfile(find.text('138 lei')), findsNWidgets(2));
      expect(
        inProfile(find.text(AppStrings.orderStatus(OrderStatus.placed))),
        findsNWidgets(2),
      );

      advanceOrderTo(container, delivery.id, OrderStatus.onTheWay);
      await tester.pumpAndSettle();
      expect(
        inProfile(find.text(AppStrings.orderStatus(OrderStatus.onTheWay))),
        findsOneWidget,
      );
    },
  );

  testWidgets('tapping an order opens it', (tester) async {
    final order = placeTestOrder(container);
    await pumpApp(tester, container, Routes.clientProfile);

    await tapVisible(tester, find.text(AppStrings.orderNumber(order.id)));

    expect(find.byType(OrderConfirmationScreen), findsOneWidget);
    expect(
      inScreen<OrderConfirmationScreen>(
        find.text(AppStrings.orderNumber(order.id)),
      ),
      findsOneWidget,
    );
  });

  testWidgets('fits a 360 x 640 phone with long addresses', (tester) async {
    placeTestOrder(
      container,
      fulfilment: const HomeDelivery(
        address:
            'bd. Ștefan cel Mare și Sfânt 126, bloc 3, scara 2, etajul 9, '
            'apartamentul 214, interfon 214K, Chișinău',
      ),
    );
    placeTestOrder(
      container,
      fulfilment: const StorePickup(locationId: 'buiucani'),
    );
    await pumpApp(
      tester,
      container,
      Routes.clientProfile,
      size: const Size(360, 640),
    );

    expect(find.byType(ProfileScreen), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text(AppStrings.demoProfileNote),
      200,
      scrollable: find
          .descendant(
            of: find.byType(ProfileScreen),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(find.text(AppStrings.demoProfileNote), findsOneWidget);
  });
}
