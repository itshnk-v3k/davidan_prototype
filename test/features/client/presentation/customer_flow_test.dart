// Drives the real app (router, screens, CartNotifier, localStorage) in Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/app.dart';
import 'package:davidan_prototype/core/router/app_router.dart';
import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/storage/local_store.dart';
import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/features/client/application/cart_notifier.dart';
import 'package:davidan_prototype/features/client/presentation/catalog/catalog_screen.dart';
import 'package:davidan_prototype/features/client/presentation/home/home_screen.dart';
import 'package:davidan_prototype/features/client/presentation/product/product_detail_screen.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  setUp(() async {
    final prefs = await LocalStore.openPreferences();
    await prefs.clear();
    container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(container.dispose);
  });

  Future<void> pumpApp(WidgetTester tester, String location) async {
    // Phone-sized viewport, so the app renders without the desktop frame.
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const DaviDanApp(),
      ),
    );
    container.read(appRouterProvider).go(location);
    await tester.pumpAndSettle();
  }

  Finder inScreen<T>(Finder finder) =>
      find.descendant(of: find.byType(T), matching: finder);

  Future<void> tapVisible(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  testWidgets('home category opens the catalog; chips switch category', (
    tester,
  ) async {
    await pumpApp(tester, Routes.clientHome);
    await tapVisible(tester, inScreen<HomeScreen>(find.text('Patiserie')));

    expect(find.byType(CatalogScreen), findsOneWidget);
    expect(
      inScreen<CatalogScreen>(find.text('Croissant cu ciocolată')),
      findsOneWidget,
    );

    await tapVisible(tester, inScreen<CatalogScreen>(find.text('Băuturi')));

    expect(inScreen<CatalogScreen>(find.text('Coca Cola')), findsOneWidget);
    expect(
      inScreen<CatalogScreen>(find.text('Croissant cu ciocolată')),
      findsNothing,
    );
  });

  testWidgets('card opens detail; add to cart adds the chosen quantity', (
    tester,
  ) async {
    await pumpApp(tester, Routes.clientCategory('bauturi'));
    await tapVisible(tester, inScreen<CatalogScreen>(find.text('Coca Cola')));

    expect(find.byType(ProductDetailScreen), findsOneWidget);
    await tester.tap(
      inScreen<ProductDetailScreen>(find.byIcon(Icons.add_rounded)),
    );
    await tester.pump();

    await tester.tap(
      inScreen<ProductDetailScreen>(
        find.text(AppStrings.addToCartTotal('50 lei')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ProductDetailScreen), findsNothing);
    expect(find.byType(CatalogScreen), findsOneWidget);
    expect(container.read(cartQuantitiesProvider), {'coca-cola': 2});
    expect(find.text(AppStrings.addedToCart(2, 'Coca Cola')), findsOneWidget);

    // Let the snack bar time out so no timer outlives the test.
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });

  testWidgets('back from product detail returns to home', (tester) async {
    await pumpApp(tester, Routes.clientHome);
    await tapVisible(
      tester,
      inScreen<HomeScreen>(find.text('Kurtos cu zahăr și scorțișoară')),
    );
    expect(find.byType(ProductDetailScreen), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(ProductDetailScreen), findsNothing);
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('description appears only for products that have one', (
    tester,
  ) async {
    await pumpApp(tester, Routes.clientProduct('placinta-branza'));
    expect(find.text(AppStrings.descriptionTitle), findsOneWidget);

    container.read(appRouterProvider).go(Routes.clientProduct('kurtos-fistic'));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.descriptionTitle), findsNothing);
  });

  testWidgets('unknown product id shows not found', (tester) async {
    await pumpApp(tester, Routes.clientProduct('no-such-product'));
    expect(find.text(AppStrings.productNotFound), findsOneWidget);
  });
}
