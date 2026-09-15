// Home screen (/client/home) pinned location bar, in the real app, in Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/strings/app_strings.dart';
import 'package:davidan_prototype/core/theme/app_assets.dart';
import 'package:davidan_prototype/features/client/presentation/home/home_screen.dart';
import 'package:davidan_prototype/features/client/presentation/location/location_screen.dart';

import '../../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  setUp(() async => container = await createTestContainer());

  testWidgets('the location bar stays pinned at the top while the page scrolls '
      'beneath it, and still opens the location screen', (tester) async {
    await pumpApp(tester, container, Routes.clientHome);
    final bar = inScreen<HomeScreen>(find.text(AppStrings.chooseAddress));
    final logo = inScreen<HomeScreen>(
      find.image(const AssetImage(AppAssets.logo)),
    );
    final barTopBefore = tester.getTopLeft(bar).dy;
    expect(tester.getTopLeft(logo).dy, lessThan(barTopBefore));

    await tester.drag(
      inScreen<HomeScreen>(find.byType(CustomScrollView)),
      const Offset(0, -800),
    );
    await tester.pumpAndSettle();

    // The logo row scrolled out of view (finders skip what's off screen);
    // the bar moved up by that row only and stays on screen.
    expect(logo, findsNothing);
    final barTopAfter = tester.getTopLeft(bar).dy;
    expect(barTopAfter, lessThan(barTopBefore));
    expect(barTopAfter, greaterThan(0));

    await tester.tap(bar);
    await tester.pumpAndSettle();
    expect(find.byType(LocationScreen), findsOneWidget);
  });
}
