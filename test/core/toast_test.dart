// Toasts: confirmations drop in at the top of the phone apps, inside the
// phone frame on a desktop, and go away on their own. Real app, in Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_spacing.dart';
import 'package:davidan_prototype/core/toast/toast_notifier.dart';
import 'package:davidan_prototype/core/widgets/toast_host.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/food/presentation/home/brand_home_screen.dart';

import '../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  setUp(() async => container = await createTestContainer());

  Finder toast(String message) =>
      find.descendant(of: find.byType(ToastHost), matching: find.text(message));

  Future<void> waitOutToast(WidgetTester tester) async {
    await tester.pump(ToastNotifier.duration);
    await tester.pumpAndSettle();
  }

  testWidgets(
    'adding from the product page confirms at the top of the screen, and the '
    'toast goes away on its own',
    (tester) async {
      await pumpApp(
        tester,
        container,
        Routes.brandProduct((brand: Brand.bakery, id: 'coca-cola')),
      );
      await tester.tap(find.text(ro.addToCartTotal('25 lei')));
      await tester.pumpAndSettle();

      final message = ro.addedToCart(1, 'Coca Cola');
      expect(find.byType(BrandHomeScreen), findsOneWidget);
      expect(toast(message), findsOneWidget);
      expect(tester.getTopLeft(toast(message)).dy, lessThan(80));
      expect(find.byType(SnackBar), findsNothing);
      // Taps go through to the screen underneath.
      expect(
        find.ancestor(
          of: toast(message),
          matching: find.byWidgetPredicate(
            (widget) => widget is IgnorePointer && widget.ignoring,
          ),
        ),
        findsWidgets,
      );

      await waitOutToast(tester);
      expect(toast(message), findsNothing);
    },
  );

  testWidgets('resetting the demo data confirms at the top', (tester) async {
    await pumpApp(tester, container, Routes.clientProfile);
    await tapVisible(tester, find.text(ro.resetDemoData));

    expect(toast(ro.resetDemoDataDone), findsOneWidget);
    expect(tester.getTopLeft(toast(ro.resetDemoDataDone)).dy, lessThan(80));
    expect(find.byType(SnackBar), findsNothing);

    await waitOutToast(tester);
  });

  testWidgets('a new toast replaces the one still up', (tester) async {
    await pumpApp(tester, container, Routes.clientHome);

    container.read(toastProvider.notifier).show('Primul');
    await tester.pumpAndSettle();
    container.read(toastProvider.notifier).show('Al doilea');
    await tester.pumpAndSettle();

    expect(toast('Primul'), findsNothing);
    expect(toast('Al doilea'), findsOneWidget);

    await waitOutToast(tester);
    expect(toast('Al doilea'), findsNothing);
  });

  testWidgets('on a desktop the toast shows at the top of the phone frame', (
    tester,
  ) async {
    const window = Size(1280, 800);
    await pumpApp(tester, container, Routes.clientHome, size: window);

    container.read(toastProvider.notifier).show('În ramă');
    await tester.pumpAndSettle();

    final phoneLeft = (window.width - AppLayout.phoneWidth) / 2;
    final rect = tester.getRect(toast('În ramă'));
    expect(rect.left, greaterThan(phoneLeft));
    expect(rect.right, lessThan(phoneLeft + AppLayout.phoneWidth));
    expect(rect.top, lessThan(AppSpacing.xl + 80));

    await waitOutToast(tester);
  });
}
