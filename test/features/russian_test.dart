// The app in Russian: the hub, every brand's content, ordering, the rental
// request, the account screens and the staff apps, in the real app, in
// Chrome, where longer Russian labels would overflow:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/app_router.dart';
import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/toast/toast_notifier.dart';
import 'package:davidan_prototype/core/utils/money.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/total_bar.dart';
import 'package:davidan_prototype/features/hub/presentation/widgets/coming_soon_feed.dart';
import 'package:davidan_prototype/features/hub/presentation/legal_document_screen.dart';
import 'package:davidan_prototype/features/hub/presentation/widgets/brand_switcher_row.dart';
import 'package:davidan_prototype/features/orders/presentation/order_confirmation_screen.dart';
import 'package:davidan_prototype/features/orders/presentation/orders_screen.dart';
import 'package:davidan_prototype/features/rental/presentation/rental_booking_screen.dart';
import 'package:davidan_prototype/l10n/app_language.dart';
import 'package:davidan_prototype/l10n/l10n.dart';
import 'package:davidan_prototype/staff/staff_build.dart';

import '../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  final ru = lookupAppLocalizations(const Locale('ru'));

  late ProviderContainer container;

  setUp(() async {
    container = await createTestContainer();
    container.read(appLanguageProvider.notifier).select(AppLanguage.ru);
  });

  const tall = Size(400, 1800);
  const logan = 'dacia-1-0-benzina-gpl-2022';

  void expectTexts(List<String> texts) {
    for (final text in texts) {
      expect(find.text(text), findsWidgets, reason: text);
    }
  }

  testWidgets('the hub\'s tabs, brand bubbles and "для тебя" row, and the '
      'restaurant\'s page', (tester) async {
    await pumpApp(tester, container, Routes.clientHome);

    expectTexts([
      ru.navHome,
      ru.navOrders,
      ru.navFavorites,
      ru.navProfile,
      ru.chooseAddress,
      ru.forYouTitleSignedOut,
    ]);
    expect(
      [
        for (final text in tester.widgetList<Text>(
          find.descendant(
            of: find.byType(BrandSwitcherRow),
            matching: find.byType(Text),
          ),
        ))
          text.data,
      ],
      // The restaurant's bubble says "Скоро" on the photo, above its name.
      [
        ru.comingSoonTitle,
        'Ресторан',
        'Суши',
        'Выпечка',
        'Питьевая вода',
        'Rent Car',
      ],
    );

    await tester.tap(find.text('Ресторан'));
    await tester.pumpAndSettle();
    expect(find.byType(ComingSoonFeed), findsOneWidget);
    expectTexts([
      ru.comingSoonTitle,
      'Незабываемые гастрономические впечатления в элегантной и уютной '
          'атмосфере.',
    ]);
  });

  testWidgets(
    'a bakery order from the menu to its confirmation: Russian names, '
    'ingredients, prices in L and the toast',
    (tester) async {
      await pumpApp(tester, container, Routes.brandHome(Brand.bakery));
      expectTexts(['Куртош', 'Выпечка', 'Плацинды и панини', ru.popularTitle]);

      await pumpApp(
        tester,
        container,
        Routes.brandProduct((brand: Brand.bakery, id: 'kurtos-vanilie')),
      );
      expectTexts(['Куртош с ванилью', ru.formatLei(3600)]);
      expect(
        find.textContaining('Ингредиенты: пшеничная мука в/с'),
        findsOneWidget,
      );
      await tapVisible(
        tester,
        find.text(ru.addToCartTotal(ru.formatLei(3600))),
      );
      expect(find.text(ru.addedToCart(1, 'Куртош с ванилью')), findsOneWidget);
      await tester.pump(ToastNotifier.duration);
      await tester.pumpAndSettle();

      await pumpApp(tester, container, Routes.brandCart(Brand.bakery));
      expectTexts([
        ru.brandCartTitle('Выпечка'),
        'Куртош с ванилью',
        ru.continueOrder,
      ]);
      await tester.tap(find.text(ru.continueOrder));
      await tester.pumpAndSettle();

      expectTexts([ru.checkoutTitle, ru.delivery, ru.pickup, ru.paymentCash]);
      await tester.enterText(find.byType(TextFormField), 'ул. Измаил 88');
      await tester.tap(
        find.descendant(
          of: find.byType(TotalBar),
          matching: find.text(ru.placeOrder),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(OrderConfirmationScreen), findsOneWidget);
      expectTexts([
        ru.orderPlacedTitle,
        ru.orderStatus(OrderStatus.placed),
        ru.paymentMethod(PaymentMethod.cash),
      ]);
    },
  );

  testWidgets(
    'sushi keeps the site\'s Russian; its information page is Russian and '
    'its legal pages stay Romanian under a note',
    (tester) async {
      await pumpApp(
        tester,
        container,
        Routes.brandProduct((brand: Brand.sushi, id: 'alasca')),
      );
      expectTexts([
        'Аляска',
        ru.productWeight('250г'),
        'Ингредиенты: нори, рис, сливочный сыр, огурец, лосось, тобико',
      ]);

      await pumpApp(tester, container, Routes.brandHome(Brand.sushi));
      expectTexts(['Японские сладости', 'Суши', 'Сеты', ru.categoriesTitle]);

      await pumpApp(tester, container, Routes.brandInfo(Brand.sushi));
      expectTexts([
        ru.brandContactsTitle,
        'г. Кишинёв',
        'ул. Vlaicu Pârcălab 52\nВторой этаж',
        'S.R.L. DANVAL BAKERY',
        'Условия и положения',
        'Политика конфиденциальности',
        ru.legalDocumentHint('davidansushi.md'),
      ]);

      await tapVisible(tester, find.text('Условия и положения'));
      expect(find.byType(LegalDocumentScreen), findsOneWidget);
      expectTexts([ru.legalDocumentRomanianOnly('davidansushi.md')]);
      expect(find.textContaining('este un brand operat'), findsOneWidget);
    },
  );

  testWidgets(
    'water, and a Rent Car request from the fleet to Comenzi, in Russian',
    (tester) async {
      await pumpApp(tester, container, Routes.brandHome(Brand.water));
      expectTexts([
        'Вода DaviDan',
        'Вода DaviDan негазированная',
        'Вода DaviDan газированная',
        ru.orderAgainHint,
      ]);

      await pumpApp(tester, container, Routes.brandHome(Brand.carRental));
      expectTexts([
        'Аренда автомобилей быстро и просто',
        ru.rentalFleetHint('11 €'),
        'от 30 € / день',
        '70 € / день при аренде на 1–3 дня',
      ]);

      await pumpApp(tester, container, Routes.rentalCar(logan), size: tall);
      expectTexts([
        ru.rentalSpecGearbox,
        'Механика',
        'Бензин/газ',
        'Без ограничений',
        'Низкий расход',
        '1–3 дня',
        '4–10 дней',
        '11–20 дней',
        '21 день и больше',
        ru.rentalInsurance,
        'Действующее водительское удостоверение, выданное не менее 3 лет '
            'назад;',
      ]);

      signInTestAccount(container);
      await pumpApp(tester, container, Routes.rentalRequest(logan), size: tall);
      expectTexts([
        ru.rentalPickupTitle,
        ru.rentalLocationAirport,
        ru.rentalExtraUnlimitedKm,
        '3 дня × 30 €',
        ru.rentalRateForTier('1–3 дня'),
        '251 €',
      ]);
      await tester.tap(find.text(ru.rentalSendRequest));
      await tester.pumpAndSettle();

      expect(find.byType(RentalBookingScreen), findsOneWidget);
      expectTexts([
        ru.rentalRequestSentTitle,
        'Мы свяжемся с вами в ближайшее время.',
        'Dacia Logan',
        'Кишинёв · 16.09.2026, 09:00',
      ]);

      container.read(appRouterProvider).go(Routes.clientOrders);
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byType(OrdersScreen),
          matching: find.text(ru.rentalBookingNumber('RC-1001')),
        ),
        findsOneWidget,
      );
      expectTexts([ru.ordersActiveTitle, ru.rentalBookingStatus]);
    },
  );

  testWidgets(
    'switching the language turns the content on screen and what is in the '
    'cart to the other language at once',
    (tester) async {
      container.read(appLanguageProvider.notifier).select(AppLanguage.ro);
      await pumpApp(
        tester,
        container,
        Routes.brandProduct((brand: Brand.sushi, id: 'alasca')),
      );
      expectTexts(['Alasca', ro.productWeight('250g')]);

      container.read(appLanguageProvider.notifier).select(AppLanguage.ru);
      await tester.pumpAndSettle();
      expectTexts(['Аляска', ru.productWeight('250г')]);
      expect(find.text('Alasca'), findsNothing);

      container.read(appLanguageProvider.notifier).select(AppLanguage.ro);
      await tester.pumpAndSettle();
      expectTexts(['Alasca']);
    },
  );

  testWidgets(
    'the account screens: sign-in, location, profile, favourites and carts',
    (tester) async {
      await pumpApp(tester, container, Routes.signIn);
      expectTexts([ru.signInTitle, ru.sendCode, ru.signInLater]);

      await pumpApp(tester, container, Routes.clientLocation);
      expectTexts([ru.locationTitle, ru.delivery, ru.pickup]);

      await pumpApp(tester, container, Routes.clientFavorites);
      expectTexts([ru.favoritesEmptyTitle]);

      await pumpApp(tester, container, Routes.openCarts);
      expectTexts([ru.openCartsEmptyTitle]);

      signInTestAccount(container);
      await pumpApp(tester, container, Routes.clientProfile);
      expectTexts([
        ru.profileTitle,
        ru.sectorOf('Ботаника'),
        ru.languageTitle,
        ru.themeTitle,
        ru.resetDemoData,
      ]);
    },
  );

  testWidgets('the staff build\'s launcher, courier app and store panel', (
    tester,
  ) async {
    final staff = await createTestContainer(overrides: staffBuildOverrides);
    staff.read(appLanguageProvider.notifier).select(AppLanguage.ru);
    placeTestOrder(staff);

    await pumpApp(tester, staff, Routes.launcher);
    expectTexts([ru.launcherTitle, ru.launcherCourier, ru.launcherKds]);

    await pumpApp(tester, staff, Routes.courierOrders);
    expectTexts([ru.courierOrdersTitle]);

    await pumpApp(tester, staff, Routes.kds, size: const Size(1280, 800));
    expectTexts([
      ru.kdsTitle,
      ru.kdsIncoming,
      ru.kdsInKitchen,
      ru.kdsReady,
      ru.advanceToAccepted,
      ru.kdsNewTag,
    ]);
  });
}
