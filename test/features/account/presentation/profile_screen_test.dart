// Profile screen (/client/profile) in the real app, in Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/toast/toast_notifier.dart';
import 'package:davidan_prototype/core/widgets/app_button.dart';
import 'package:davidan_prototype/core/widgets/empty_state.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/chisinau_sector.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/account/application/account_notifier.dart';
import 'package:davidan_prototype/features/account/presentation/profile/profile_screen.dart';
import 'package:davidan_prototype/features/account/presentation/sign_in/sign_in_phone_screen.dart';
import 'package:davidan_prototype/features/food/application/cart_notifier.dart';
import 'package:davidan_prototype/features/food/presentation/catalog/catalog_screen.dart';
import 'package:davidan_prototype/features/hub/presentation/splash/splash_screen.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';
import 'package:davidan_prototype/features/orders/presentation/order_confirmation_screen.dart';
import 'package:davidan_prototype/l10n/l10n.dart';

import '../../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  setUp(() async => container = await createTestContainer());

  Finder inProfile(Finder finder) => inScreen<ProfileScreen>(finder);

  testWidgets('the Profil tab opens it', (tester) async {
    await pumpApp(tester, container, Routes.clientHome);
    await tester.tap(find.text(ro.navProfile));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen), findsOneWidget);
  });

  testWidgets(
    'signed out it is locked: no orders, and "Intră în cont" opens the '
    'sign-in',
    (tester) async {
      placeTestOrder(container);
      await pumpApp(tester, container, Routes.clientProfile);

      expect(inProfile(find.text(ro.accountLockedTitle)), findsOneWidget);
      expect(inProfile(find.text(ro.myOrdersTitle)), findsNothing);
      expect(inProfile(find.text('138 lei')), findsNothing);

      await tapVisible(tester, find.text(ro.signInTitle));
      expect(find.byType(SignInPhoneScreen), findsOneWidget);
    },
  );

  testWidgets(
    'signed in: name, masked number, sector and nearest shop; signing out '
    'locks it',
    (tester) async {
      signInTestAccount(
        container,
        name: 'Ana Popescu',
        sector: ChisinauSector.buiucani,
      );
      await pumpApp(tester, container, Routes.clientProfile);

      expect(inProfile(find.text('Ana Popescu')), findsOneWidget);
      expect(inProfile(find.text('+373 69 *** 456')), findsOneWidget);
      expect(
        inProfile(find.text(ro.sectorLabel(ChisinauSector.buiucani))),
        findsOneWidget,
      );
      expect(inProfile(find.text(ro.nearestShopTitle)), findsOneWidget);
      expect(inProfile(find.text('DaviDan Buiucani')), findsOneWidget);

      await tapVisible(tester, find.text(ro.signOut));

      expect(inProfile(find.text(ro.accountLockedTitle)), findsOneWidget);
      expect(container.read(accountProvider), isNull);
    },
  );

  testWidgets(
    'resetting the demo data, signed in or not, starts the demo over from '
    'the splash',
    (tester) async {
      for (final signedIn in [true, false]) {
        if (signedIn) signInTestAccount(container);
        placeTestOrder(container);
        container.read(cartProvider(Brand.bakery).notifier).add('americano');
        await pumpApp(tester, container, Routes.clientProfile);

        await tapVisible(tester, find.text(ro.resetDemoData));

        expect(find.byType(SplashScreen), findsOneWidget, reason: '$signedIn');
        expect(container.read(accountProvider), isNull);
        expect(container.read(ordersProvider), isEmpty);
        expect(container.read(cartCountProvider(Brand.bakery)), 0);
        // Lets the confirmation toast time out.
        await tester.pump(ToastNotifier.duration);
        await tester.pumpAndSettle();
      }
    },
  );

  testWidgets('without orders: an empty state that links to the menu', (
    tester,
  ) async {
    signInTestAccount(container);
    await pumpApp(tester, container, Routes.clientProfile);

    expect(inProfile(find.text(ro.ordersEmptyTitle)), findsOneWidget);

    await tapVisible(tester, find.text(ro.browseMenu));
    expect(find.byType(CatalogScreen), findsOneWidget);
  });

  testWidgets('the "Despre DaviDan" facts are gone', (tester) async {
    signInTestAccount(container);
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
      signInTestAccount(container);
      final delivery = placeTestOrder(container);
      final pickup = placeTestOrder(
        container,
        fulfilment: const StorePickup(locationId: 'botanica'),
      );
      await pumpApp(tester, container, Routes.clientProfile);

      expect(inProfile(find.text(ro.ordersEmptyTitle)), findsNothing);
      expect(
        tester.getTopLeft(find.text(ro.orderNumber(pickup.id))).dy,
        lessThan(tester.getTopLeft(find.text(ro.orderNumber(delivery.id))).dy),
      );
      expect(inProfile(find.text('15.09.2026, 10:07')), findsNWidgets(2));
      expect(inProfile(find.text('str. Ismail 88')), findsOneWidget);
      expect(
        inProfile(find.text('DaviDan Botanica · bd. Dacia 47, Chișinău')),
        findsOneWidget,
      );
      expect(inProfile(find.text('138 lei')), findsNWidgets(2));
      expect(
        inProfile(find.text(ro.orderStatus(OrderStatus.placed))),
        findsNWidgets(2),
      );

      advanceOrderTo(container, delivery.id, OrderStatus.onTheWay);
      await tester.pumpAndSettle();
      expect(
        inProfile(find.text(ro.orderStatus(OrderStatus.onTheWay))),
        findsOneWidget,
      );
    },
  );

  testWidgets('tapping an order opens it', (tester) async {
    signInTestAccount(container);
    final order = placeTestOrder(container);
    await pumpApp(tester, container, Routes.clientProfile);

    await tapVisible(tester, find.text(ro.orderNumber(order.id)));

    expect(find.byType(OrderConfirmationScreen), findsOneWidget);
    expect(
      inScreen<OrderConfirmationScreen>(find.text(ro.orderNumber(order.id))),
      findsOneWidget,
    );
  });

  testWidgets(
    'signed out on a 360 x 640 phone, "Intră în cont" shows in full and the '
    'settings scroll into view below it',
    (tester) async {
      await pumpApp(
        tester,
        container,
        Routes.clientProfile,
        size: const Size(360, 640),
      );

      final signIn = find.widgetWithText(AppButton, ro.signInTitle);
      final lockMessage = tester.getRect(find.byType(EmptyState));
      expect(
        lockMessage.contains(tester.getRect(signIn).topLeft) &&
            lockMessage.contains(tester.getRect(signIn).bottomRight),
        isTrue,
        reason: 'the button is cut off by the settings under it',
      );

      await tester.scrollUntilVisible(
        find.text(ro.resetDemoData),
        200,
        scrollable: inProfile(find.byType(Scrollable)).first,
      );
      expect(find.text(ro.languageTitle), findsOneWidget);
      await tapVisible(tester, signIn);
      expect(find.byType(SignInPhoneScreen), findsOneWidget);
    },
  );

  testWidgets('fits a 360 x 640 phone with long addresses', (tester) async {
    signInTestAccount(container, name: 'Alexandru-Constantin Popescu');
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
      find.text(ro.demoProfileNote),
      200,
      scrollable: find
          .descendant(
            of: find.byType(ProfileScreen),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(find.text(ro.demoProfileNote), findsOneWidget);
  });
}
