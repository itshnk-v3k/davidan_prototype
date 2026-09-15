// Order confirmation screen (/client/orders/:id) in the real app, in Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/widgets/app_button.dart';
import 'package:davidan_prototype/data/models/cart_item.dart';
import 'package:davidan_prototype/data/models/order.dart';
import 'package:davidan_prototype/features/client/presentation/home/home_screen.dart';
import 'package:davidan_prototype/features/client/presentation/orders/order_confirmation_screen.dart';
import 'package:davidan_prototype/features/orders/application/orders_notifier.dart';

import '../../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  setUp(() async => container = await createTestContainer());

  Order placeOrder({
    Fulfilment fulfilment = const HomeDelivery(address: 'str. Ismail 88'),
    DateTime? scheduledFor,
  }) => container
      .read(ordersProvider.notifier)
      .place(
        items: const [CartItem(productId: 'kurtos-fistic', quantity: 2)],
        totalBani: 11800,
        fulfilment: fulfilment,
        payment: PaymentMethod.card,
        scheduledFor: scheduledFor,
      );

  testWidgets('shows the order number, status and chosen details', (
    tester,
  ) async {
    final order = placeOrder(scheduledFor: DateTime(2026, 9, 15, 12, 30));
    await pumpApp(tester, container, Routes.clientOrder(order.id));

    expect(find.byType(OrderConfirmationScreen), findsOneWidget);
    expect(find.text(AppStrings.orderPlacedTitle), findsOneWidget);
    expect(find.text(AppStrings.orderNumber('DD-1001')), findsOneWidget);
    expect(
      find.text(AppStrings.orderStatus(OrderStatus.placed)),
      findsOneWidget,
    );
    expect(find.text(AppStrings.deliverTo), findsOneWidget);
    expect(find.text('str. Ismail 88'), findsOneWidget);
    expect(find.text('12:30'), findsOneWidget);
    expect(
      find.text(AppStrings.paymentMethod(PaymentMethod.card)),
      findsOneWidget,
    );
    expect(find.text('118 lei'), findsOneWidget);
  });

  testWidgets('pickup orders show the shop', (tester) async {
    final order = placeOrder(
      fulfilment: const StorePickup(locationId: 'buiucani'),
    );
    await pumpApp(tester, container, Routes.clientOrder(order.id));

    expect(find.text(AppStrings.pickupFrom), findsOneWidget);
    expect(
      find.text('DaviDan Buiucani · str. Alba Iulia 75, Chișinău'),
      findsOneWidget,
    );
    expect(find.text(AppStrings.asSoonAsPossible), findsOneWidget);
  });

  testWidgets('both "back home" buttons go to the home tab', (tester) async {
    final order = placeOrder();

    await pumpApp(tester, container, Routes.clientOrder(order.id));
    await tester.tap(find.widgetWithText(AppButton, AppStrings.backHome));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);

    await pumpApp(tester, container, Routes.clientOrder(order.id));
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('unknown order id shows not found', (tester) async {
    await pumpApp(tester, container, Routes.clientOrder('DD-9999'));

    expect(find.text(AppStrings.orderNotFound), findsOneWidget);
    await tester.tap(find.text(AppStrings.backHome));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('fits a 360 x 640 phone with a long address', (tester) async {
    final order = placeOrder(
      fulfilment: const HomeDelivery(
        address:
            'bd. Ștefan cel Mare și Sfânt 126, bloc 3, scara 2, etajul 9, '
            'apartamentul 214, interfon 214K, Chișinău',
      ),
    );
    await pumpApp(
      tester,
      container,
      Routes.clientOrder(order.id),
      size: const Size(360, 640),
    );
    expect(find.byType(OrderConfirmationScreen), findsOneWidget);
  });
}
