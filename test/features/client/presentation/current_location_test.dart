// "Folosește locația mea curentă": a delivery point for the next order only,
// from the phone's location or, when that isn't available, the map picker.
// Real app, in Chrome, with a fake location service instead of GPS:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/location/location_result.dart';
import 'package:davidan_prototype/core/router/app_router.dart';
import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/widgets/app_chip.dart';
import 'package:davidan_prototype/data/mock/mock_sectors.dart';
import 'package:davidan_prototype/data/models/chisinau_sector.dart';
import 'package:davidan_prototype/data/models/geo_point.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/data/models/pinned_location.dart';
import 'package:davidan_prototype/features/client/application/cart_notifier.dart';
import 'package:davidan_prototype/features/client/application/current_location_notifier.dart';
import 'package:davidan_prototype/features/client/application/fulfilment_choice_notifier.dart';
import 'package:davidan_prototype/features/client/presentation/checkout/checkout_screen.dart';
import 'package:davidan_prototype/features/client/presentation/home/home_screen.dart';
import 'package:davidan_prototype/features/client/presentation/location/location_screen.dart';
import 'package:davidan_prototype/features/client/presentation/location/map_picker_screen.dart';
import 'package:davidan_prototype/features/client/presentation/location/widgets/chisinau_map.dart';
import 'package:davidan_prototype/features/client/presentation/orders/order_confirmation_screen.dart';
import 'package:davidan_prototype/features/courier/presentation/courier_delivery_screen.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';
import 'package:davidan_prototype/staff/staff_build.dart';

import '../../../helpers/fake_location_service.dart';
import '../../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  /// About 740 m north of the Botanica sector centre.
  const nearBotanica = GeoPoint(46.9915, 28.8575);
  final botanicaCentre = sectorCentres[ChisinauSector.botanica]!;

  Finder homeBar(String text) => inScreen<HomeScreen>(find.text(text));

  testWidgets(
    'the phone\'s location is pinned for the next order; the saved address '
    'stays, and the ✕ in the home bar drops the pin',
    (tester) async {
      final location = FakeLocationService.at(nearBotanica);
      final container = await createTestContainer(locationService: location);
      container
          .read(fulfilmentChoiceProvider.notifier)
          .chooseDelivery('str. Ismail 88');
      await pumpApp(tester, container, Routes.clientHome);

      await tester.tap(homeBar('str. Ismail 88'));
      await tester.pumpAndSettle();
      await tapVisible(tester, find.text(AppStrings.useCurrentLocation));

      expect(location.lookups, 1);
      expect(find.byType(LocationScreen), findsNothing);
      expect(homeBar(AppStrings.deliverToCurrentLocation), findsOneWidget);
      expect(
        homeBar(AppStrings.currentLocationValue('Zona Botanica')),
        findsOneWidget,
      );
      expect(
        container.read(currentLocationProvider).pinned,
        isA<PinnedLocation>()
            .having((p) => p.point, 'point', nearBotanica)
            .having((p) => p.source, 'source', PinSource.gps),
      );
      expect(
        container.read(fulfilmentChoiceProvider),
        isA<HomeDelivery>().having(
          (c) => c.address,
          'address',
          'str. Ismail 88',
        ),
      );

      await tester.tap(inScreen<HomeScreen>(find.byIcon(Icons.close_rounded)));
      await tester.pumpAndSettle();

      expect(find.byType(LocationScreen), findsNothing);
      expect(homeBar('str. Ismail 88'), findsOneWidget);
      expect(container.read(currentLocationProvider).pinned, isNull);
    },
  );

  testWidgets(
    'checkout delivers to the pinned location and uses it up; the order shows '
    'its area and coordinates to the customer and the courier',
    (tester) async {
      // The courier's side needs the staff build.
      final container = await createTestContainer(
        overrides: staffBuildOverrides,
      );
      container
          .read(fulfilmentChoiceProvider.notifier)
          .chooseDelivery('str. Ismail 88');
      container.read(currentLocationProvider.notifier).pinOnMap(botanicaCentre);
      container.read(cartProvider.notifier).add('americano');
      await pumpApp(tester, container, Routes.clientCheckout);

      expect(
        inScreen<CheckoutScreen>(
          find.text(AppStrings.deliverToCurrentLocation),
        ),
        findsOneWidget,
      );
      expect(find.byType(TextFormField), findsNothing);

      await tapVisible(tester, find.text(AppStrings.placeOrder));

      expect(find.byType(OrderConfirmationScreen), findsOneWidget);
      final order = container.read(ordersProvider).first;
      expect(
        order.fulfilment,
        isA<HomeDelivery>()
            .having((d) => d.point, 'point', botanicaCentre)
            .having((d) => d.address, 'address', ''),
      );
      final shown = AppStrings.pinnedAddress(
        'Zona Botanica',
        '46.98500, 28.85800',
      );
      expect(find.text(shown), findsOneWidget);
      expect(container.read(currentLocationProvider).pinned, isNull);
      expect(
        container.read(fulfilmentChoiceProvider),
        isA<HomeDelivery>().having(
          (c) => c.address,
          'address',
          'str. Ismail 88',
        ),
      );
      // A one-off point isn't offered again as a recent address.
      expect(container.read(recentAddressesProvider), isEmpty);

      advanceOrderTo(container, order.id, OrderStatus.ready);
      container.read(appRouterProvider).go(Routes.courierDelivery(order.id));
      await tester.pumpAndSettle();
      expect(inScreen<CourierDeliveryScreen>(find.text(shown)), findsOneWidget);
    },
  );

  testWidgets('at checkout the pin can be dropped for a typed address', (
    tester,
  ) async {
    final container = await createTestContainer();
    container
        .read(fulfilmentChoiceProvider.notifier)
        .chooseDelivery('str. Ismail 88');
    container.read(currentLocationProvider.notifier).pinOnMap(botanicaCentre);
    container.read(cartProvider.notifier).add('americano');
    await pumpApp(tester, container, Routes.clientCheckout);

    await tapVisible(tester, find.text(AppStrings.typeAddressInstead));

    expect(
      find.widgetWithText(TextFormField, 'str. Ismail 88'),
      findsOneWidget,
    );
    expect(container.read(currentLocationProvider).pinned, isNull);
  });

  for (final failure in [LocationFailure.denied, LocationFailure.timeout]) {
    testWidgets(
      'when the location is not available (${failure.name}) the map picker '
      'says why, and a sector can be chosen instead',
      (tester) async {
        final container = await createTestContainer(
          locationService: FakeLocationService.failing(failure),
        );
        await pumpApp(tester, container, Routes.clientLocation);

        await tapVisible(tester, find.text(AppStrings.useCurrentLocation));

        expect(find.byType(MapPickerScreen), findsOneWidget);
        expect(find.text(AppStrings.locationFailure(failure)), findsOneWidget);
        expect(container.read(currentLocationProvider).pinned, isNull);

        await tapVisible(tester, find.widgetWithText(AppChip, 'Ciocana'));
        expect(
          find.text(
            'Zona Ciocana · '
            '${AppStrings.distanceToShop('4,9 km', 'DaviDan Centru')}',
          ),
          findsOneWidget,
        );

        await tapVisible(tester, find.text(AppStrings.deliverHere));

        expect(
          homeBar(AppStrings.currentLocationValue('Zona Ciocana')),
          findsOneWidget,
        );
        expect(
          container.read(currentLocationProvider).pinned,
          isA<PinnedLocation>()
              .having(
                (p) => p.point,
                'point',
                sectorCentres[ChisinauSector.ciocana],
              )
              .having((p) => p.source, 'source', PinSource.map),
        );
      },
    );
  }

  testWidgets('tapping the map moves the pin; the picker fits a 360 x 640 '
      'phone', (tester) async {
    final container = await createTestContainer();
    await pumpApp(
      tester,
      container,
      Routes.clientLocationMap(null),
      size: const Size(360, 640),
    );
    expect(find.byType(MapPickerScreen), findsOneWidget);
    // On this small screen the chosen point is below the fold; an overflow
    // anywhere would already have failed the test.
    expect(
      find.textContaining('Zona Centru', skipOffstage: false),
      findsOneWidget,
    );

    // Rîșcani's centre, placed the way ChisinauMap projects coordinates.
    final map = tester.getRect(find.byType(ChisinauMap));
    final riscani = sectorCentres[ChisinauSector.riscani]!;
    await tester.tapAt(
      map.topLeft +
          Offset(
            (riscani.longitude - 28.740) / (28.945 - 28.740) * map.width,
            (47.085 - riscani.latitude) / (47.085 - 46.950) * map.height,
          ),
    );
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Zona Rîșcani', skipOffstage: false),
      findsOneWidget,
    );
  });
}
