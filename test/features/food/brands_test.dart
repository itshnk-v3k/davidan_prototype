// Every brand keeps its own cart, and favourites and orders know their brand,
// in Chrome against real localStorage:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/app_router.dart';
import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/storage/local_store.dart';
import 'package:davidan_prototype/data/mock/mock_catalogs.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/brand_catalog.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/data/models/product.dart';
import 'package:davidan_prototype/features/food/application/cart_notifier.dart';
import 'package:davidan_prototype/features/food/application/catalog_providers.dart';
import 'package:davidan_prototype/features/food/application/favorites_notifier.dart';
import 'package:davidan_prototype/features/food/presentation/product/product_detail_screen.dart';
import 'package:davidan_prototype/features/hub/presentation/hub_home_screen.dart';
import 'package:davidan_prototype/features/orders/application/order_lines_provider.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';

import '../../helpers/test_app.dart';

/// TEST FIXTURE, not app content: a second brand selling a product with the
/// same id as one of the bakery's, at a different price.
const _otherBrandCoke = Product(
  brand: Brand.sushi,
  id: 'coca-cola',
  categoryId: 'test-drinks',
  name: 'Coca Cola (test)',
  priceBani: 2300,
);

final List<Override> _withSecondBrand = [
  brandCatalogProvider.overrideWith(
    (ref, brand) => brand == Brand.sushi
        ? const BrandCatalog(products: [_otherBrandCoke])
        : mockCatalogs[brand] ?? const BrandCatalog(),
  ),
];

const _bakeryCoke = (brand: Brand.bakery, id: 'coca-cola');
const _otherCoke = (brand: Brand.sushi, id: 'coca-cola');

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  setUp(() async {
    final app = await startApp();
    await app.read(localStoreProvider).clearDemoData();
    app.dispose();
  });

  test('each brand has its own cart, also after a restart', () async {
    final session = await startApp(overrides: _withSecondBrand);
    session.read(cartProvider(Brand.bakery).notifier).add('coca-cola');
    session.read(cartProvider(Brand.sushi).notifier)
      ..add('coca-cola')
      ..add('coca-cola');

    expect(session.read(cartCountProvider(Brand.bakery)), 1);
    expect(session.read(cartCountProvider(Brand.sushi)), 2);
    expect(session.read(cartTotalProvider(Brand.sushi)), 2 * 2300);

    session.read(cartProvider(Brand.bakery).notifier).clear();
    expect(session.read(cartCountProvider(Brand.sushi)), 2);
    await flushWrites();
    session.dispose();

    final restarted = await startApp(overrides: _withSecondBrand);
    addTearDown(restarted.dispose);
    expect(restarted.read(cartCountProvider(Brand.bakery)), 0);
    expect(restarted.read(cartQuantitiesProvider(Brand.sushi)), {
      'coca-cola': 2,
    });
  });

  test('the same product id in two brands is two favourites', () async {
    final session = await startApp(overrides: _withSecondBrand);
    session.read(favoritesProvider.notifier)
      ..toggle(_bakeryCoke)
      ..toggle(_otherCoke);
    expect(
      [for (final p in session.read(favoriteProductsProvider)) p.name],
      ['Coca Cola (test)', 'Coca Cola'],
    );

    session.read(favoritesProvider.notifier).toggle(_bakeryCoke);
    await flushWrites();
    session.dispose();

    final restarted = await startApp(overrides: _withSecondBrand);
    addTearDown(restarted.dispose);
    expect(restarted.read(favoritesProvider), [_otherCoke]);
  });

  test('an order keeps its brand, and its lines come from that brand\'s '
      'catalog', () async {
    final session = await startApp(overrides: _withSecondBrand);
    final order = session
        .read(ordersProvider.notifier)
        .place(
          brand: Brand.sushi,
          items: const [
            OrderItem(productId: 'coca-cola', quantity: 1, priceBani: 2300),
          ],
          fulfilment: const HomeDelivery(address: 'str. Ismail 88'),
          payment: PaymentMethod.cash,
        );
    await flushWrites();
    session.dispose();

    final restarted = await startApp(overrides: _withSecondBrand);
    addTearDown(restarted.dispose);
    expect(restarted.read(orderByIdProvider(order.id))?.brand, Brand.sushi);
    expect(
      [
        for (final line in restarted.read(orderLinesProvider(order.id)))
          line.product.name,
      ],
      ['Coca Cola (test)'],
    );
  });

  testWidgets('a product link names its brand; an unknown brand goes home', (
    tester,
  ) async {
    final container = await createTestContainer(overrides: _withSecondBrand);
    await pumpApp(tester, container, Routes.brandProduct(_otherCoke));
    expect(
      tester
          .widget<ProductDetailScreen>(find.byType(ProductDetailScreen))
          .productKey,
      _otherCoke,
    );
    expect(find.text('Coca Cola (test)'), findsOneWidget);

    container.read(appRouterProvider).go('/b/pizzeria/product/coca-cola');
    await tester.pumpAndSettle();
    expect(find.byType(HubHomeScreen), findsOneWidget);
  });
}
