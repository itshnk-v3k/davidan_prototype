// THROWAWAY real-font probe for the Rubik pass; deleted after running.
@TestOn('vm')
library;

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

import 'package:davidan_prototype/core/router/app_router.dart';
import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/food/application/cart_notifier.dart';
import 'package:davidan_prototype/features/food/application/favorites_notifier.dart';
import 'package:davidan_prototype/features/food/application/product_layout_notifier.dart';
import 'package:davidan_prototype/l10n/app_language.dart';

import 'helpers/test_app.dart';

const shots =
    '/private/tmp/claude-501/-Users-macbookpro-Developer-davidan-prototype/684e1976-cb60-4f5e-af56-f2fab349317a/scratchpad/shots';

Future<void> loadFont(String family, List<String> files) async {
  final loader = FontLoader(family);
  for (final file in files) {
    final bytes = File(file).readAsBytesSync();
    loader.addFont(Future.value(ByteData.view(bytes.buffer)));
  }
  await loader.load();
}

Future<void> precacheAll(WidgetTester tester) async {
  await tester.runAsync(() async {
    for (final element in find.byType(Image).evaluate()) {
      final image = (element.widget as Image).image;
      await precacheImage(image, element);
    }
  });
  await tester.pump();
}

Future<void> shoot(WidgetTester tester, String name) async {
  await precacheAll(tester);
  await tester.runAsync(() async {
    final view = tester.binding.renderViews.first;
    final layer = view.debugLayer! as OffsetLayer;
    final size = view.size;
    final image = await layer.toImage(Offset.zero & size, pixelRatio: 2);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    File('$shots/$name.png').writeAsBytesSync(data!.buffer.asUint8List());
  });
}

const appClasses = {'AccountNotifier','ActiveOrdersStrip','AllRolesScreen','AppButton','AppCard','AppChip','AppColors','AppIconButton','AppIconButtonStyle','AppLanguageNotifier','AppLocalizationsRo','AppLocalizationsRu','AppTextStyles','BrandBubbles','BrandCatalog','BrandHeaderBand','BrandHomeScreen','BrandInfo','BrandInfoScreen','BrandIntro','BrandIntroScreen','BrandLogo','BrandSurface','BrandTheme','CarDetailScreen','CardCarousel','CartButton','CartItem','CartLineTile','CartNotifier','CartScreen','CatalogScreen','CategoriesScreen','CategoryChips','CategoryGrid','CategoryTile','CheckoutDraft','CheckoutNotifier','CheckoutScreen','ChisinauMap','ClientShell','ClockTicker','ConnectedProductCard','ContentTranslator','CountBadge','CourierDeliveryScreen','CourierOnlineNotifier','CourierOrderCard','CourierOrderDetails','CourierOrdersScreen','CourierRouteMap','CurrentLocationNotifier','CurrentLocationState','CustomerAccount','DaviDanApp','DeliveryAddressField','DemoLauncherScreen','DemoPromo','DemoResetNotifier','DetailRow','DeviceLocalesNotifier','ElapsedTimer','EmptyState','ExtraApp','FavoriteToggle','FavoritesNotifier','FavoritesScreen','FeaturedProductCard','Floating','ForYouSheet','FulfilmentChoiceNotifier','FulfilmentDetailRow','FulfilmentTypeChips','GeoPoint','GeolocatorLocationService','GlassSurface','HubHomeScreen','InfoNote','KdsOrderCard','KdsScreen','LanguageSelector','LegalDocument','LegalDocumentScreen','LegalText','LinkCard','LocalStore','LocationDraft','LocationDraftNotifier','LocationScreen','MapPickerScreen','MenuCategory','NearestShopCard','NotificationsButton','NotificationsScreen','OpenCartsButton','OpenCartsScreen','OptionTile','Order','OrderConfirmationScreen','OrderItem','OrderSimulator','OrderStatusPill','OrderSummaryCard','OrdersNotifier','OrdersScreen','PhoneFrame','PhotoHero','PickupShopList','PinnedLocation','PlaceholderNutrition','Product','ProductCard','ProductDetailScreen','ProductGrid','ProductImage','ProductLayoutNotifier','ProductLayoutSwitch','ProductLayoutToggle','ProductListTile','ProductMetaLine','ProductPriceRow','ProductQuantityNotifier','ProductShelf','ProductTileData','ProfileScreen','PromoBanner','PromoBannerCarousel','PromoCards','QuantityStepper','RentalBooking','RentalBookingScreen','RentalBookingStatusPill','RentalBookingsNotifier','RentalCar','RentalCarGrid','RentalHomeScreen','RentalQuote','RentalQuoteCard','RentalRequestDraft','RentalRequestNotifier','RentalRequestScreen','RoundIconButton','ScreenHeader','SearchBarButton','SearchFilterButton','SearchScreen','SectionTitle','SettingSelector','SignInCodeScreen','SignInDetailsScreen','SignInDraft','SignInDraftNotifier','SignInPhoneScreen','SignInSkippedNotifier','SliverBottomBarSpace','SplashScreen','StatusPill','StoreLocation','SummaryRow','ThemeModeNotifier','ThemeModeSelector','Toast','ToastHost','ToastNotifier','TopNotice','TopNoticeSwitcher','TopScrim','TotalBar','WaterHomeScreen','WelcomeScreen','_AccountCard','_ActionBar','_ActiveRequestCard','_AddToCartBar','_AppLocalizationsDelegate','_BagButton','_BannerSlide','_BottlesPhoto','_BottomNav','_BrandChips','_BrandTag','_BrandTile','_ButtonRow','_CallToAction','_CarCard','_CarSummary','_Card','_CardCarouselState','_CategoryChipsState','_ClientShellState','_ClippedPhoto','_ClockTickerState','_CodeBoxes','_ColumnTitle','_ComingSoonPill','_ConfirmDialog','_CourierMarker','_DateField','_EmptyCategory','_EmptyCheckout','_ExtraTile','_FeatureTag','_FilterChip','_FilterSheet','_FloatingState','_FulfilmentSection','_Group','_Heading','_HubHeader','_KdsScreenState','_LastOrderCard','_LocateSection','_MapPainter','_MapPickerScreenState','_MapView','_NameAndMeta','_NavItem','_NewTag','_NoOrder','_OfflineNote','_OnlineSwitch','_OpenArrow','_OpenCartCard','_OrderSimulatorState','_Panel','_Pill','_Pin','_PinnedLocationCard','_PlaceAndTime','_Placeholder','_Prices','_ProductInfo','_ProductNotFound','_ProfileSections','_PromoCard','_RecentAddresses','_RemoveButton','_RentalHomeScreenState','_RequestCard','_SearchScreenState','_Section','_SectionTitle','_SeeAllTile','_Segment','_ShopPin','_SideBySide','_Specs','_SplashScreenState','_Stacked','_SwipeUpToDismiss','_SwipeUpToDismissState','_Tagline','_TexturePainter','_TimeField','_UpdateCard'};

String ownerOf(RenderParagraph paragraph) {
  final creator = paragraph.debugCreator;
  if (creator is! DebugCreator) return '?';
  final names = <String>[];
  creator.element.visitAncestorElements((e) {
    final n = e.widget.runtimeType.toString().split('<').first;
    if (appClasses.contains(n) && (names.isEmpty || names.last != n)) names.add(n);
    return names.length < 3;
  });
  return names.join('<');
}

void main() {
  setUpAll(() async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    await loadFont('Rubik', [
      for (final w in ['Regular', 'Medium', 'SemiBold', 'Bold'])
        'assets/fonts/rubik/Rubik-$w.ttf',
    ]);
    await loadFont('Roboto', [
      for (final w in ['Regular', 'Medium', 'Bold'])
        'assets/fonts/roboto/Roboto-$w.ttf',
    ]);
  });

  final routes = <String>[
    Routes.clientHome,
    Routes.brandHome(Brand.sushi),
    Routes.brandHome(Brand.bakery),
    Routes.brandHome(Brand.water),
    Routes.brandHome(Brand.carRental),
    Routes.brandHome(Brand.restaurant),
    Routes.brandCategories(Brand.sushi),
    Routes.brandMenu(Brand.sushi),
    Routes.brandMenu(Brand.bakery),
    Routes.brandSearch(Brand.sushi),
    Routes.clientSearch,
    Routes.clientNotifications,
    Routes.brandProduct((brand: Brand.sushi, id: 'alasca')),
    Routes.brandProduct((brand: Brand.bakery, id: 'kurtos-scortisoara')),
    Routes.brandCart(Brand.sushi),
    Routes.openCarts,
    Routes.clientFavorites,
    Routes.clientOrders,
    Routes.clientProfile,
    Routes.brandInfo(Brand.sushi),
    Routes.rentalCar('audi-q5-2012'),
    Routes.rentalRequest('audi-q5-2012'),
  ];

  final report = <String>{};
  tearDownAll(() {
    File('$shots/report.txt').writeAsStringSync(report.join('\n'));
  });

  for (final size in const [Size(360, 740), Size(412, 870)]) {
    for (final language in const [AppLanguage.ro, AppLanguage.ru]) {
      for (final scale in const [1.0, 1.3]) {
        testWidgets('${size.width} ${language.name} x$scale', (tester) async {
          final container = await createTestContainer();
          container.read(appLanguageProvider.notifier).select(language);
          container.read(favoritesProvider.notifier)
            ..toggle((brand: Brand.sushi, id: 'alasca'))
            ..toggle((brand: Brand.bakery, id: 'kurtos-scortisoara'));
          container.read(cartProvider(Brand.sushi).notifier).add('alasca');
          tester.platformDispatcher.textScaleFactorTestValue = scale;
          addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
          await pumpApp(
            tester,
            container,
            Routes.clientHome,
            size: size,
            phoneBrightness: Brightness.dark,
          );
          final tag = '${size.width.toInt()}-${language.name}-x$scale';
          for (final list in [false, true]) {
            if (list) container.read(productLayoutProvider.notifier).toggle();
            for (final route in routes) {
              container.read(appRouterProvider).go(route);
              await tester.pumpAndSettle();
              final error = tester.takeException();
              if (error != null) {
                report.add('EXCEPTION $tag list:$list $route: '
                    '${error.toString().split('\n').first}');
              }
              for (final pass in [0, 1]) {
                // Clipped text: anything cut by maxLines on screen.
                for (final paragraph in tester.allRenderObjects
                    .whereType<RenderParagraph>()) {
                  if (!paragraph.attached || paragraph.debugNeedsLayout) {
                    continue;
                  }
                  if (paragraph.didExceedMaxLines) {
                    report.add('CLIPPED ${size.width.toInt()} ${language.name} '
                        'x$scale ${ownerOf(paragraph)} '
                        'w=${paragraph.size.width.toStringAsFixed(0)}: '
                        '"${paragraph.text.toPlainText()}"');
                  }
                }
                if (pass == 0) {
                  final scrollables = find.byType(Scrollable);
                  if (scrollables.evaluate().isEmpty) break;
                  await tester.drag(scrollables.first, const Offset(0, -700),
                      warnIfMissed: false);
                  await tester.pumpAndSettle();
                  final e2 = tester.takeException();
                  if (e2 != null) {
                    report.add('EXCEPTION scrolled $tag list:$list $route: '
                        '${e2.toString().split('\n').first}');
                  }
                }
              }
            }
          }
          // Screenshots for the eye: grid layout.
          if (const bool.fromEnvironment('SHOTS')) {
            container.read(productLayoutProvider.notifier).toggle();
            for (final (name, route) in [
              ('hub', Routes.clientHome),
              ('sushi', Routes.brandHome(Brand.sushi)),
              ('bakery', Routes.brandHome(Brand.bakery)),
            ]) {
              container.read(appRouterProvider).go(route);
              await tester.pumpAndSettle();
              await shoot(tester, '$tag-$name-top');
              if (name != 'hub') {
                await tester.drag(find.byType(Scrollable).first,
                    const Offset(0, -520), warnIfMissed: false);
                await tester.pumpAndSettle();
                await shoot(tester, '$tag-$name-scrolled');
              }
            }
            container.read(productLayoutProvider.notifier).toggle();
            container.read(appRouterProvider).go(Routes.brandHome(Brand.sushi));
            await tester.pumpAndSettle();
            await tester.drag(find.byType(Scrollable).first,
                const Offset(0, -1100), warnIfMissed: false);
            await tester.pumpAndSettle();
            await shoot(tester, '$tag-sushi-list');
          }
          // Leave nothing pending.
          await tester.pumpWidget(const SizedBox());
        });
      }
    }
  }
}
