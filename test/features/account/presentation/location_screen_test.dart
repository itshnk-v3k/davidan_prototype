// Location screen (/client/location) and the home location bar in the real
// app, in Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/widgets/option_tile.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/account/application/fulfilment_choice_notifier.dart';
import 'package:davidan_prototype/features/account/presentation/location/location_screen.dart';
import 'package:davidan_prototype/features/food/presentation/home/home_screen.dart';

import '../../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  setUp(() async => container = await createTestContainer());

  Finder homeBar(String text) => inScreen<HomeScreen>(find.text(text));
  Fulfilment? savedChoice() => container.read(fulfilmentChoiceProvider);
  OptionTile tile(WidgetTester tester, String title) =>
      tester.widget<OptionTile>(find.widgetWithText(OptionTile, title));

  Future<void> openFromHomeBar(WidgetTester tester, String barText) async {
    await pumpApp(tester, container, Routes.clientHome);
    await tester.tap(homeBar(barText));
    await tester.pumpAndSettle();
    expect(find.byType(LocationScreen), findsOneWidget);
  }

  testWidgets('the home bar opens the screen; back returns home unchanged', (
    tester,
  ) async {
    await openFromHomeBar(tester, ro.chooseAddress);
    expect(find.text(ro.recentAddressesTitle), findsNothing);

    await tester.tap(
      inScreen<LocationScreen>(find.byIcon(Icons.arrow_back_rounded)),
    );
    await tester.pumpAndSettle();

    expect(find.byType(LocationScreen), findsNothing);
    expect(homeBar(ro.chooseAddress), findsOneWidget);
    expect(savedChoice(), isNull);
  });

  testWidgets('a typed address must not be blank, then shows in the home bar', (
    tester,
  ) async {
    await openFromHomeBar(tester, ro.chooseAddress);

    await tapVisible(tester, find.text(ro.confirmAddress));
    expect(find.byType(LocationScreen), findsOneWidget);
    expect(find.text(ro.deliveryAddressMissing), findsOneWidget);
    expect(savedChoice(), isNull);

    await tester.enterText(
      find.byType(TextFormField),
      'str. Ismail 88, ap. 12',
    );
    await tapVisible(tester, find.text(ro.confirmAddress));

    expect(find.byType(LocationScreen), findsNothing);
    expect(homeBar(ro.deliverTo), findsOneWidget);
    expect(homeBar('str. Ismail 88, ap. 12'), findsOneWidget);
    expect(
      savedChoice(),
      isA<HomeDelivery>().having(
        (c) => c.address,
        'address',
        'str. Ismail 88, ap. 12',
      ),
    );
  });

  testWidgets(
    'opens on the saved address; one tap on a shop switches to pickup',
    (tester) async {
      container
          .read(fulfilmentChoiceProvider.notifier)
          .chooseDelivery('str. Ismail 88');
      await openFromHomeBar(tester, 'str. Ismail 88');
      expect(
        inScreen<LocationScreen>(find.text('str. Ismail 88')),
        findsOneWidget,
      );

      await tapVisible(tester, find.text(ro.pickup));
      expect(find.byType(TextFormField), findsNothing);
      // Switching mode alone saves nothing.
      expect(savedChoice(), isA<HomeDelivery>());

      await tapVisible(tester, find.text('DaviDan Botanica'));

      expect(find.byType(LocationScreen), findsNothing);
      expect(homeBar(ro.pickupFrom), findsOneWidget);
      expect(homeBar('DaviDan Botanica'), findsOneWidget);
      expect(
        savedChoice(),
        isA<StorePickup>().having(
          (c) => c.locationId,
          'locationId',
          'botanica',
        ),
      );
    },
  );

  testWidgets('opens on the saved shop, in pickup mode', (tester) async {
    container.read(fulfilmentChoiceProvider.notifier).choosePickup('buiucani');
    await openFromHomeBar(tester, 'DaviDan Buiucani');

    expect(find.byType(TextFormField), findsNothing);
    expect(tile(tester, 'DaviDan Buiucani').selected, isTrue);
    expect(tile(tester, 'DaviDan Centru').selected, isFalse);
  });

  testWidgets('addresses of past deliveries are one tap away', (tester) async {
    placeTestOrder(
      container,
      fulfilment: const HomeDelivery(address: 'str. Ismail 88'),
    );
    placeTestOrder(
      container,
      fulfilment: const StorePickup(locationId: 'centru'),
    );
    placeTestOrder(
      container,
      fulfilment: const HomeDelivery(address: 'bd. Dacia 12'),
    );
    await openFromHomeBar(tester, ro.chooseAddress);

    expect(find.text(ro.recentAddressesTitle), findsOneWidget);
    expect(find.byType(OptionTile), findsNWidgets(2));
    expect(tile(tester, 'str. Ismail 88').selected, isFalse);

    await tapVisible(tester, find.widgetWithText(OptionTile, 'str. Ismail 88'));

    expect(find.byType(LocationScreen), findsNothing);
    expect(homeBar('str. Ismail 88'), findsOneWidget);
  });

  testWidgets('fits a 360 x 640 phone with a long address, in both modes', (
    tester,
  ) async {
    const long =
        'bd. Ștefan cel Mare și Sfânt 126, bloc 3, scara 2, etajul 9, '
        'apartamentul 214, interfon 214K, Chișinău';
    placeTestOrder(container, fulfilment: const HomeDelivery(address: long));
    container.read(fulfilmentChoiceProvider.notifier).chooseDelivery(long);
    const phone = Size(360, 640);

    await pumpApp(tester, container, Routes.clientHome, size: phone);
    expect(homeBar(long), findsOneWidget);

    await pumpApp(tester, container, Routes.clientLocation, size: phone);
    expect(find.byType(LocationScreen), findsOneWidget);
    await tapVisible(tester, find.text(ro.pickup));
    expect(find.text('DaviDan Buiucani'), findsOneWidget);
  });
}
