// DaviDan Rent Car (/b/carRental): the fleet, a car's page, the request form
// with its price, the sent request, its place in Comenzi and on the hub, and
// the information page, in the real app, in Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/app_router.dart';
import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_colors.dart';
import 'package:davidan_prototype/core/theme/brand_colors.dart';
import 'package:davidan_prototype/data/mock/mock_brand.dart';
import 'package:davidan_prototype/data/mock/rental/rental_cars.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/data/models/rental_booking.dart';
import 'package:davidan_prototype/features/food/presentation/home/brand_home_screen.dart';
import 'package:davidan_prototype/features/food/presentation/widgets/total_bar.dart';
import 'package:davidan_prototype/features/hub/presentation/brand_info_screen.dart';
import 'package:davidan_prototype/features/hub/presentation/hub_home_screen.dart';
import 'package:davidan_prototype/features/hub/presentation/legal_document_screen.dart';
import 'package:davidan_prototype/features/hub/presentation/widgets/active_orders_strip.dart';
import 'package:davidan_prototype/features/hub/presentation/widgets/brand_bubbles.dart';
import 'package:davidan_prototype/features/orders/application/customer_requests_provider.dart';
import 'package:davidan_prototype/features/orders/presentation/orders_screen.dart';
import 'package:davidan_prototype/features/rental/application/rental_bookings_notifier.dart';
import 'package:davidan_prototype/features/rental/application/rental_providers.dart';
import 'package:davidan_prototype/features/rental/presentation/car_detail_screen.dart';
import 'package:davidan_prototype/features/rental/presentation/rental_booking_screen.dart';
import 'package:davidan_prototype/features/rental/presentation/rental_home_screen.dart';
import 'package:davidan_prototype/features/rental/presentation/rental_request_screen.dart';
import 'package:davidan_prototype/features/rental/presentation/widgets/rental_quote_card.dart';

import '../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  setUp(() async => container = await createTestContainer());

  const logan = 'dacia-1-0-benzina-gpl-2022';
  const porsche = 'porsche-cayenne-3-0-plug-in-hybrid';

  /// Tall enough for a car's page or the request form to be built whole.
  const tall = Size(400, 1800);

  Finder inQuote(Finder finder) => inScreen<RentalQuoteCard>(finder);

  /// The quote card's lines, label and amount, top to bottom.
  List<String> quoteLines(WidgetTester tester) => [
    for (final text in tester.widgetList<Text>(
      find.descendant(
        of: find.byType(RentalQuoteCard),
        matching: find.byType(Text),
      ),
    ))
      text.data!,
  ];

  /// Opens the date picker of the field showing [shown] and picks [day] of
  /// the same month.
  Future<void> pickDay(WidgetTester tester, String shown, String day) async {
    await tapVisible(tester, find.text(shown));
    await tester.tap(find.text(day));
    await tester.pump();
    await tester.tap(
      find.text(
        MaterialLocalizations.of(tester.element(find.byType(DatePickerDialog)))
            .okButtonLabel,
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Opens the return's time menu and picks [time], scrolling the menu to
  /// it first.
  Future<void> pickReturnTime(WidgetTester tester, String time) async {
    await tapVisible(tester, find.byType(DropdownButtonFormField<int>).last);
    // The menu is the last to show every time of day.
    final item = find.text(time, skipOffstage: false).last;
    await tester.ensureVisible(item);
    await tester.pumpAndSettle();
    await tester.tap(item);
    await tester.pumpAndSettle();
  }

  Future<void> enterIn(WidgetTester tester, String label, String text) async {
    final field = find.widgetWithText(TextFormField, label);
    await Scrollable.ensureVisible(tester.element(field), alignment: 0.5);
    await tester.pumpAndSettle();
    await tester.enterText(field, text);
    await tester.pumpAndSettle();
  }

  group('pricing, as davidanrentcar.md\'s cart adds it up', () {
    test('every started day counts, on the calendar, so summer time ends '
        'without adding a day', () {
      DateTime at(int day, int hour, [int month = 9]) =>
          DateTime(2026, month, day, hour);

      expect(rentalDays(at(16, 9), at(17, 9)), 1);
      expect(rentalDays(at(16, 9), at(17, 8)), 1);
      // The site's own test: 1 day and 4 hours are 2 days.
      expect(rentalDays(at(16, 9), at(17, 13)), 2);
      expect(rentalDays(at(16, 9), at(19, 9)), 3);
      expect(rentalDays(at(16, 9), at(16, 11)), 1);
      // Moldova leaves summer time on 25 October 2026.
      expect(rentalDays(at(24, 9, 10), at(26, 9, 10)), 2);
    });

    test('the price per day follows the length: 1–3, 4–10, 11–20 and 21+ '
        'days', () {
      final car = container.read(rentalCarByIdProvider(logan))!;
      expect(
        {
          for (final days in [1, 3, 4, 10, 11, 20, 21, 30])
            days: car.dayRateFor(days),
        },
        {1: 30, 3: 30, 4: 25, 10: 25, 11: 23, 20: 23, 21: 19, 30: 19},
      );
      expect(car.lowestDayRateEur, 19);
    });

    test('the site\'s test rental: a Dacia Logan for 1 day with both extras '
        'is 30 + 10 + 5 + 11 + 150 = 206 €; longer rentals add the fee and '
        'insurance only once', () {
      final car = container.read(rentalCarByIdProvider(logan))!;
      final oneDay = quoteRental(
        car,
        days: 1,
        extras: RentalExtra.values.toSet(),
      );
      expect(oneDay.rentalEur, 30);
      expect(oneDay.extrasEur, {
        RentalExtra.childSeat: 10,
        RentalExtra.unlimitedKm: 5,
      });
      expect(oneDay.locationFeeEur, 11);
      expect(oneDay.insuranceEur, 150);
      expect(oneDay.priceEur, 56);
      expect(oneDay.totalEur, 206);

      final month = quoteRental(car, days: 21, extras: const {});
      expect(month.totalEur, 21 * 19 + 11 + 150);

      final porscheCar = container.read(rentalCarByIdProvider(porsche))!;
      expect(quoteRental(porscheCar, days: 1, extras: const {}).totalEur, 461);
    });

    test(
      'a sent request is saved with its price and survives a restart',
      () async {
        final car = container.read(rentalCarByIdProvider(logan))!;
        final booking = container
            .read(rentalBookingsProvider.notifier)
            .request(
              car: car,
              pickupLocation: RentalLocation.airport,
              returnLocation: RentalLocation.chisinau,
              pickupAt: DateTime(2026, 9, 20, 9),
              returnAt: DateTime(2026, 9, 24, 13),
              extras: {RentalExtra.childSeat},
              name: 'Ana Popescu',
              phone: '69123456',
              notes: 'Zbor la 08:30',
            );
        expect(booking.id, 'RC-1001');
        expect(booking.quote.days, 5);
        expect(booking.quote.totalEur, 5 * 25 + 10 + 11 + 150);
        await flushWrites();

        final restarted = await startApp();
        addTearDown(restarted.dispose);
        final [saved] = restarted.read(rentalBookingsProvider);
        expect(saved.toJson(), booking.toJson());
      },
    );

    test('a cancelled request keeps its number and price, and stays cancelled '
        'after a restart', () async {
      final notifier = container.read(rentalBookingsProvider.notifier);
      final booking = notifier.request(
        car: container.read(rentalCarByIdProvider(logan))!,
        pickupLocation: RentalLocation.chisinau,
        returnLocation: RentalLocation.chisinau,
        pickupAt: DateTime(2026, 9, 20, 9),
        returnAt: DateTime(2026, 9, 22, 9),
        extras: const {},
        name: 'Ana Popescu',
        phone: '69123456',
        notes: '',
      );
      notifier.cancel(booking.id);
      final [cancelled] = container.read(rentalBookingsProvider);
      expect(cancelled.cancelledAt, testNow);
      expect(cancelled.quote.toJson(), booking.quote.toJson());
      await flushWrites();

      final restarted = await startApp();
      addTearDown(restarted.dispose);
      final [saved] = restarted.read(rentalBookingsProvider);
      expect(saved.cancelled, isTrue);
      expect(saved.toJson(), cancelled.toJson());
    });
  });

  testWidgets(
    'the Rent Car bubble shows its site\'s key "D" and opens the fleet: its '
    'line, how prices work, and all 11 cars, each with its lowest price and '
    'its price for 1–3 days, in the Rent Car red',
    (tester) async {
      await pumpApp(tester, container, Routes.clientHome);
      expect(
        (tester
                    .widget<Image>(
                      find
                          .descendant(
                            of: find.byType(BrandBubbles),
                            matching: find.byType(Image),
                          )
                          .last,
                    )
                    .image
                as AssetImage)
            .assetName,
        'assets/images/brand/logo-davidan-rent-car.webp',
      );
      await tester.tap(
        find.descendant(
          of: find.byType(BrandBubbles),
          matching: find.text(brandIntros[Brand.carRental]!.name),
        ),
      );
      await tester.pumpAndSettle();

      final home = find.byType(RentalHomeScreen);
      expect(home, findsOneWidget);
      expect(find.text(ro.navOrders), findsNothing);
      expect(
        inScreen<RentalHomeScreen>(find.text('DaviDan Rent Car')),
        findsOneWidget,
      );
      expect(
        inScreen<RentalHomeScreen>(
          find.text('Mașini de Închiriat Rapid și Simplu'),
        ),
        findsOneWidget,
      );
      expect(
        inScreen<RentalHomeScreen>(find.text(ro.rentalFleetHint('11 €'))),
        findsOneWidget,
      );
      expect(
        Theme.of(tester.element(home)).extension<AppColors>()!.primary,
        BrandColors.of(Brand.carRental, Brightness.dark).primary,
      );

      expect(
        [for (final car in rentalCars) car.name],
        [
          'Audi Q5 2012',
          'Audi Q5 2021',
          'BMW X5',
          'Dacia Lodgy',
          'Dacia Logan',
          'Dacia Sandero',
          'Ford Focus',
          'Ford Kuga',
          'Mercedes-Benz',
          'Porsche Cayenne',
          'Toyota RAV4',
        ],
      );
      final list = find
          .descendant(of: home, matching: find.byType(Scrollable))
          .first;
      for (final car in rentalCars) {
        final name = inScreen<RentalHomeScreen>(find.text(car.name));
        await tester.scrollUntilVisible(name, 200, scrollable: list);
        expect(name, findsOneWidget);
        if (car.id != logan) continue;
        final card = find.ancestor(of: name, matching: find.byType(InkWell));
        for (final text in [
          'de la 19 € / zi',
          '2022 · Manuală · Benzină/GPL · 5 locuri',
          '30 € / zi pentru 1–3 zile',
        ]) {
          await tester.scrollUntilVisible(
            find.descendant(of: card, matching: find.text(text)),
            100,
            scrollable: list,
          );
          expect(
            find.descendant(of: card, matching: find.text(text)),
            findsOneWidget,
            reason: text,
          );
        }
      }

      await tapVisible(
        tester,
        inScreen<RentalHomeScreen>(find.text('Toyota RAV4')),
      );
      expect(
        inScreen<CarDetailScreen>(find.text('Toyota RAV4')),
        findsOneWidget,
      );
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();
      expect(find.byType(HubHomeScreen), findsOneWidget);
    },
  );

  testWidgets(
    'a car\'s page: its site\'s specs and equipment, every price per day, the '
    'location fee and its own insurance amount, and the licence and age the '
    'driver needs',
    (tester) async {
      await pumpApp(tester, container, Routes.rentalCar(porsche), size: tall);

      expect(find.byType(CarDetailScreen), findsOneWidget);
      Finder onPage(String text) => inScreen<CarDetailScreen>(find.text(text));

      for (final text in [
        'Porsche Cayenne',
        'Porsche Cayenne 3.0 Plug-in Hybrid 2017 – Lux și Performanță!',
        ro.rentalSpecYear,
        '2017',
        'Benzină/Plug-in Hybrid',
        'Automată',
        '10 l/100 km',
        ro.rentalSpecEngine,
        '3.0',
        ro.rentalSpecMileage,
        'Nelimitat',
        'Suspensie pneumatică',
        ro.rentalTierRange(1, 3),
        '150 € / zi',
        ro.rentalTierRange(4, 10),
        '90 € / zi',
        ro.rentalTierRange(11, 20),
        '70 € / zi',
        '21 de zile sau mai mult',
        '60 € / zi',
        ro.rentalLocationFee,
        '11 €',
        ro.rentalInsurance,
        '300 €',
        ro.rentalFeesNote,
        ro.rentalDocumentsTitle,
        'Un permis de conducere valid, eliberat cu cel puțin 3 ani;',
        'Buletinul de identitate (vârsta minimă variază între 21 și 25 de '
            'ani, în funcție de tipul automobilului).',
      ]) {
        expect(onPage(text), findsOneWidget, reason: text);
      }

      await tester.tap(find.text(ro.rentalRequestAction));
      await tester.pumpAndSettle();
      expect(find.byType(RentalRequestScreen), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();
      expect(find.byType(CarDetailScreen), findsOneWidget);

      // Opened from its link, back goes to the fleet.
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();
      expect(find.byType(RentalHomeScreen), findsOneWidget);
    },
  );

  testWidgets(
    'the request form starts tomorrow at 09:00 for 3 days and prices it line '
    'by line; a longer rental, extras and moved dates change the price; '
    'sending needs a name and phone',
    (tester) async {
      await pumpApp(tester, container, Routes.rentalRequest(logan), size: tall);

      expect(find.text('16.09.2026'), findsOneWidget);
      expect(find.text('19.09.2026'), findsOneWidget);
      expect(find.text('09:00'), findsNWidgets(2));
      expect(quoteLines(tester), [
        '3 zile × 30 €',
        '90 €',
        ro.rentalRateForTier('1–3 zile'),
        ro.rentalLocationFee,
        '11 €',
        ro.rentalPriceTotal,
        '101 €',
        ro.rentalInsurance,
        '150 €',
        ro.rentalTotalWithInsurance,
        '251 €',
      ]);
      // The bar leads with the rental's price; the insurance amount, which
      // DaviDan hasn't said comes back or not, is under it on its own.
      for (final text in [
        ro.rentalPriceTotal,
        '101 €',
        ro.rentalInsuranceExtra('150 €'),
      ]) {
        expect(
          find.descendant(of: find.byType(TotalBar), matching: find.text(text)),
          findsOneWidget,
          reason: text,
        );
      }

      // Returned an hour later: a fourth day, at the 4–10 day price.
      await pickReturnTime(tester, '10:00');
      expect(inQuote(find.text('4 zile × 25 €')), findsOneWidget);
      expect(
        inQuote(find.text(ro.rentalRateForTier('4–10 zile'))),
        findsOneWidget,
      );
      expect(inQuote(find.text('261 €')), findsOneWidget);

      for (final extra in [
        ro.rentalExtraChildSeat,
        ro.rentalExtraUnlimitedKm,
      ]) {
        await tapVisible(tester, find.text(extra));
      }
      expect(quoteLines(tester), [
        '4 zile × 25 €',
        '100 €',
        ro.rentalRateForTier('4–10 zile'),
        ro.rentalExtraChildSeat,
        '10 €',
        ro.rentalExtraUnlimitedKm,
        '20 €',
        ro.rentalLocationFee,
        '11 €',
        ro.rentalPriceTotal,
        '141 €',
        ro.rentalInsurance,
        '150 €',
        ro.rentalTotalWithInsurance,
        '291 €',
      ]);

      // A pickup moved past the return takes the return to a day later.
      await pickDay(tester, '16.09.2026', '20');
      expect(find.text('20.09.2026'), findsOneWidget);
      expect(find.text('21.09.2026'), findsOneWidget);
      expect(inQuote(find.text('1 zi × 30 €')), findsOneWidget);
      expect(inQuote(find.text('5 €')), findsOneWidget);

      // Brought back to the pickup's own time: no price, and it says why.
      await pickDay(tester, '21.09.2026', '20');
      expect(find.byType(RentalQuoteCard), findsNothing);
      expect(find.text(ro.rentalReturnNotAfterPickup), findsNWidgets(2));
      expect(
        find.descendant(of: find.byType(TotalBar), matching: find.text('–')),
        findsOneWidget,
      );

      await pickReturnTime(tester, '10:00');
      expect(inQuote(find.text('1 zi × 30 €')), findsOneWidget);

      await tester.tap(find.text(ro.rentalSendRequest));
      await tester.pumpAndSettle();
      expect(find.byType(RentalRequestScreen), findsOneWidget);
      expect(find.text(ro.nameMissing), findsOneWidget);
      expect(find.text(ro.phoneInvalid), findsOneWidget);
      expect(container.read(rentalBookingsProvider), isEmpty);

      await enterIn(tester, ro.nameLabel, 'Ion Rusu');
      await enterIn(tester, ro.phoneLabel, '79111222');
      await tester.tap(find.text(ro.rentalSendRequest));
      await tester.pumpAndSettle();

      expect(find.byType(RentalBookingScreen), findsOneWidget);
      final [booking] = container.read(rentalBookingsProvider);
      expect(booking.pickupAt, DateTime(2026, 9, 20, 9));
      expect(booking.returnAt, DateTime(2026, 9, 20, 10));
      expect(booking.name, 'Ion Rusu');
      expect(booking.phone, '79111222');
      expect(booking.quote.totalEur, 30 + 10 + 5 + 11 + 150);
    },
  );

  testWidgets(
    'a signed-in customer\'s details are filled in; the sent request says '
    'they will be contacted, and shows in Comenzi and on the hub, which open '
    'it again',
    (tester) async {
      signInTestAccount(container);
      final order = placeTestOrder(container);
      await pumpApp(tester, container, Routes.rentalCar(logan), size: tall);
      await tester.tap(find.text(ro.rentalRequestAction));
      await tester.pumpAndSettle();

      await tapVisible(tester, find.text(ro.rentalLocationAirport).first);
      await enterIn(tester, ro.rentalNotesLabel, 'Zbor la 08:30');
      await tester.tap(find.text(ro.rentalSendRequest));
      await tester.pumpAndSettle();

      final sent = find.byType(RentalBookingScreen);
      expect(sent, findsOneWidget);
      Finder onSent(String text) =>
          inScreen<RentalBookingScreen>(find.text(text));
      for (final text in [
        ro.rentalRequestSentTitle,
        ro.rentalBookingNumber('RC-1001'),
        ro.rentalBookingStatus,
        'Vă vom contacta în curând.',
        ro.rentalRequestNotReserved,
        'Dacia Logan',
        'Aeroport Chișinău · 16.09.2026, 09:00',
        'Chișinău · 19.09.2026, 09:00',
        'Ana Popescu · +373 69 123 456',
        'Zbor la 08:30',
      ]) {
        expect(onSent(text), findsOneWidget, reason: text);
      }
      expect(inQuote(find.text('251 €')), findsOneWidget);

      container.read(appRouterProvider).go(Routes.clientOrders);
      await tester.pumpAndSettle();
      Finder inOrders(Finder finder) => inScreen<OrdersScreen>(finder);
      expect(
        inOrders(find.text(ro.rentalBookingNumber('RC-1001'))),
        findsOneWidget,
      );
      expect(inOrders(find.text('Dacia Logan')), findsOneWidget);
      expect(
        inOrders(find.text('16.09.2026, 09:00 – 19.09.2026, 09:00')),
        findsOneWidget,
      );
      expect(inOrders(find.text(ro.rentalPriceTotal)), findsOneWidget);
      expect(inOrders(find.text('101 €')), findsOneWidget);
      expect(
        inOrders(find.text(brandIntros[Brand.carRental]!.name)),
        findsWidgets,
      );
      expect(inOrders(find.text(ro.orderNumber(order.id))), findsOneWidget);
      expect(
        [
          for (final request in container.read(customerRequestsProvider))
            request.id,
        ],
        [order.id, 'RC-1001'],
      );

      await tapVisible(
        tester,
        inOrders(find.text(ro.rentalBookingNumber('RC-1001'))),
      );
      expect(find.byType(RentalBookingScreen), findsOneWidget);

      container.read(appRouterProvider).go(Routes.clientHome);
      await tester.pumpAndSettle();
      // The strip names the car and when it's picked up, not the number.
      final inStrip = find.descendant(
        of: find.byType(ActiveOrdersStrip),
        matching: find.text(
          ro.activeBookingSummary('Dacia Logan', '16.09, 09:00'),
        ),
      );
      expect(inStrip, findsOneWidget);
      advanceOrderTo(container, order.id, OrderStatus.completed);
      await tester.pumpAndSettle();
      expect(inStrip, findsOneWidget);
      await tester.tap(inStrip);
      await tester.pumpAndSettle();
      expect(find.byType(RentalBookingScreen), findsOneWidget);
    },
  );

  testWidgets(
    'a waiting request can be cancelled, after a confirmation: it stays in '
    'Comenzi as cancelled and leaves the hub',
    (tester) async {
      final car = container.read(rentalCarByIdProvider(logan))!;
      container
          .read(rentalBookingsProvider.notifier)
          .request(
            car: car,
            pickupLocation: RentalLocation.chisinau,
            returnLocation: RentalLocation.chisinau,
            pickupAt: DateTime(2026, 9, 20, 9),
            returnAt: DateTime(2026, 9, 22, 9),
            extras: const {},
            name: 'Ana Popescu',
            phone: '69123456',
            notes: '',
          );
      await pumpApp(
        tester,
        container,
        Routes.clientBooking('RC-1001'),
        size: tall,
      );

      // Backing out of the dialog keeps it waiting.
      await tapVisible(tester, find.text(ro.rentalCancelRequest));
      expect(find.text(ro.rentalCancelRequestTitle), findsOneWidget);
      await tester.tap(find.text(ro.back));
      await tester.pumpAndSettle();
      expect(container.read(rentalBookingsProvider).single.cancelled, isFalse);

      await tapVisible(tester, find.text(ro.rentalCancelRequest));
      await tester.tap(find.text(ro.rentalCancelRequest).last);
      await tester.pumpAndSettle();
      final [booking] = container.read(rentalBookingsProvider);
      expect(booking.cancelledAt, testNow);
      for (final text in [
        ro.rentalRequestCancelledTitle,
        ro.rentalBookingCancelled,
      ]) {
        expect(
          inScreen<RentalBookingScreen>(find.text(text)),
          findsOneWidget,
          reason: text,
        );
      }
      expect(find.text(ro.rentalCancelRequest), findsNothing);
      expect(find.text(ro.rentalRequestNotReserved), findsNothing);

      container.read(appRouterProvider).go(Routes.clientHome);
      await tester.pumpAndSettle();
      expect(container.read(activeRequestsProvider), isEmpty);
      expect(
        find.text(ro.activeBookingSummary('Dacia Logan', '20.09, 09:00')),
        findsNothing,
      );

      signInTestAccount(container);
      container.read(appRouterProvider).go(Routes.clientOrders);
      await tester.pumpAndSettle();
      expect(
        inScreen<OrdersScreen>(find.text(ro.ordersPastTitle)),
        findsOneWidget,
      );
      expect(
        inScreen<OrdersScreen>(find.text(ro.rentalBookingCancelled)),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'the info button opens davidanrentcar.md\'s contacts and both legal '
    'pages in full',
    (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpApp(tester, container, Routes.brandHome(Brand.carRental));
      await tester.tap(
        find.bySemanticsLabel(ro.openBrandInfo('DaviDan Rent Car')),
      );
      await tester.pumpAndSettle();
      semantics.dispose();

      expect(find.byType(BrandInfoScreen), findsOneWidget);
      for (final text in [
        ro.brandInfoHours,
        'Lucrăm 24/24',
        'or. Chișinău, str. Vlaicu Pârcălab 52',
        '+373 79 816 666',
        'davidanrentcar@gmail.com',
        'instagram.com/davidanrentcar',
        'DAVIDAN RENT CAR SRL',
      ]) {
        expect(
          inScreen<BrandInfoScreen>(find.text(text)),
          findsOneWidget,
          reason: text,
        );
      }

      await tapVisible(tester, find.text('Termeni și Condiții'));
      expect(find.byType(LegalDocumentScreen), findsOneWidget);
      expect(
        find.textContaining('400 de kilometri gratuiti pe zi'),
        findsOneWidget,
      );
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();

      await tapVisible(tester, find.text('Politica de Confidențialitate'));
      expect(find.byType(LegalDocumentScreen), findsOneWidget);
      expect(find.text('DATELE DE CONTACT'), findsOneWidget);
    },
  );

  testWidgets(
    'links: an unknown car shows the fleet, a car under another brand shows '
    'that brand, and an unknown request says so',
    (tester) async {
      await pumpApp(tester, container, Routes.rentalCar('trabant'));
      expect(find.byType(RentalHomeScreen), findsOneWidget);

      await pumpApp(tester, container, '/b/sushi/car/$logan');
      expect(find.byType(BrandHomeScreen), findsOneWidget);

      await pumpApp(tester, container, Routes.rentalRequest('trabant'));
      expect(find.byType(RentalHomeScreen), findsOneWidget);

      await pumpApp(tester, container, Routes.brandMenu(Brand.carRental));
      expect(find.byType(RentalHomeScreen), findsOneWidget);

      await pumpApp(tester, container, Routes.clientBooking('RC-9999'));
      expect(find.text(ro.rentalBookingNotFound), findsOneWidget);
    },
  );
}
