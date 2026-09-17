// Motion on the order screens: the store panel's new-order notice coming in.
// Real app, in Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/features/kds/presentation/kds_screen.dart';
import 'package:davidan_prototype/staff/staff_build.dart';

import '../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  setUp(
    () async =>
        container = await createTestContainer(overrides: staffBuildOverrides),
  );

  const tablet = Size(1280, 800);

  /// Partway through the notice's 250 ms.
  const midway = Duration(milliseconds: 100);

  testWidgets('a new-order notice drops in from the top', (tester) async {
    await pumpApp(tester, container, Routes.kds, size: tablet);

    final arriving = placeTestOrder(container);
    await tester.pump();
    await tester.pump(midway);

    Offset noticeOffset() => tester
        .widget<SlideTransition>(
          find
              .ancestor(
                of: find.text(ro.newOrderArrived(arriving.id)),
                matching: find.byType(SlideTransition),
              )
              .first,
        )
        .position
        .value;
    expect(noticeOffset().dy, lessThan(0));

    await tester.pumpAndSettle();
    expect(noticeOffset(), Offset.zero);

    // Let the notice time out so no timer outlives the test.
    await tester.pump(KdsScreen.noticeDuration);
    await tester.pumpAndSettle();
  });
}
