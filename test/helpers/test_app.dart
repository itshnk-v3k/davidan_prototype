import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:davidan_prototype/app.dart';
import 'package:davidan_prototype/core/router/app_router.dart';
import 'package:davidan_prototype/core/storage/local_store.dart';
import 'package:davidan_prototype/core/utils/time.dart';

/// "Now" in widget tests: 15 September 2026, 10:07.
final testNow = DateTime(2026, 9, 15, 10, 7);

/// Providers wired the way main() wires them, on emptied local storage and
/// with the clock fixed at [testNow]. Call from setUp; disposed on tear down.
Future<ProviderContainer> createTestContainer() async {
  final prefs = await LocalStore.openPreferences();
  await prefs.clear();
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      clockProvider.overrideWithValue(() => testNow),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

/// Pumps the real app (router, screens, Notifiers) at [location]. The default
/// viewport is phone-sized, so the app renders without the desktop frame.
Future<void> pumpApp(
  WidgetTester tester,
  ProviderContainer container,
  String location, {
  Size size = const Size(400, 900),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const DaviDanApp()),
  );
  container.read(appRouterProvider).go(location);
  await tester.pumpAndSettle();
}

Finder inScreen<T>(Finder finder) =>
    find.descendant(of: find.byType(T), matching: finder);

/// Scrolls [finder] into view, then taps it.
Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}
