// Every button on the customer app's main screens can be tapped in at least
// 48 × 48 dp (Android's minimum; Apple's is 44 pt), even where it looks
// smaller: the heart, the stepper, the cart line's bin, the header buttons
// and the chips.
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/data/mock/rental/rental_cars.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/geo_point.dart';
import 'package:davidan_prototype/features/account/application/current_location_notifier.dart';
import 'package:davidan_prototype/features/food/application/cart_notifier.dart';
import 'package:davidan_prototype/features/food/application/favorites_notifier.dart';

import '../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  setUp(() async {
    container = await createTestContainer();
    // Something in every place a small button shows up: a pinned location
    // (its clear button), a cart (bins and steppers), a favourite (hearts),
    // and orders from two brands (Comenzi's brand chips).
    container
        .read(currentLocationProvider.notifier)
        .pinOnMap(const GeoPoint(47.0, 28.85));
    container.read(cartProvider(Brand.bakery).notifier)
      ..add('americano')
      ..add('kurtos-fistic');
    container.read(favoritesProvider.notifier).toggle((
      brand: Brand.bakery,
      id: 'americano',
    ));
    signInTestAccount(container);
    placeTestOrder(container);
    placeTestOrder(container, brand: Brand.sushi);
  });

  final car = rentalCars.first.id;
  final screens = {
    'the hub': Routes.clientHome,
    'Comenzi': Routes.clientOrders,
    'Favorite': Routes.clientFavorites,
    'Profil': Routes.clientProfile,
    'the bakery\'s home': Routes.brandHome(Brand.bakery),
    'the bakery\'s menu': Routes.brandMenu(Brand.bakery),
    'a product': Routes.brandProduct((brand: Brand.bakery, id: 'americano')),
    'the cart': Routes.brandCart(Brand.bakery),
    'checkout': Routes.brandCheckout(Brand.bakery),
    'Rent Car': Routes.brandHome(Brand.carRental),
    'a car': Routes.rentalCar(car),
    'a rental request': Routes.rentalRequest(car),
    'the location screen': Routes.clientLocation,
  };

  for (final MapEntry(key: name, value: location) in screens.entries) {
    testWidgets('$name: every button is at least 48 dp', (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpApp(tester, container, location);

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      semantics.dispose();
    });
  }
}
