// What go_router does when navigation crosses the hub's tabs, on a small
// router shaped like app_router.dart's: the phone frame's shell, the tabs
// inside it, a brand's browse screens inside Acasă, and the task screens
// (cart, checkout) above the tabs. The app's routes rely on each of these.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  late StatefulShellRoute tabs;
  late GoRouter router;

  Future<void> pumpRouter(WidgetTester tester) async {
    Widget page(String name) => Scaffold(body: Center(child: Text(name)));
    tabs = StatefulShellRoute.indexedStack(
      builder: (_, _, shell) => Column(
        children: [
          Expanded(child: shell),
          Text('tab bar ${shell.currentIndex}'),
        ],
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (_, _) => page('hub'),
              routes: [
                GoRoute(
                  path: 'b/:brand',
                  builder: (_, state) =>
                      page('home ${state.pathParameters['brand']}'),
                  routes: [
                    GoRoute(path: 'menu', builder: (_, _) => page('menu')),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (_, _) => page('profile'),
              routes: [
                GoRoute(path: 'b/:brand/info', builder: (_, _) => page('info')),
              ],
            ),
          ],
        ),
      ],
    );
    router = GoRouter(
      initialLocation: '/home',
      routes: [
        ShellRoute(
          builder: (_, _, child) => child,
          routes: [
            tabs,
            GoRoute(path: '/b/:brand/cart', builder: (_, _) => page('cart')),
            GoRoute(
              path: '/b/:brand/checkout',
              builder: (_, _) => page('checkout'),
            ),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();
  }

  Future<void> navigate(WidgetTester tester, void Function() step) async {
    step();
    await tester.pumpAndSettle();
  }

  /// How many times the current matches hold the tabs.
  int tabsBuilt([List<RouteMatchBase>? matches]) {
    var count = 0;
    for (final match
        in matches ?? router.routerDelegate.currentConfiguration.matches) {
      if (match is ShellRouteMatch) {
        if (match.route == tabs) count++;
        count += tabsBuilt(match.matches);
      }
    }
    return count;
  }

  StatefulNavigationShell shell(WidgetTester tester) => tester
      .widget<StatefulNavigationShell>(find.byType(StatefulNavigationShell));

  testWidgets('a tab\'s route pushed inside the tab keeps the bar, and back '
      'returns', (tester) async {
    await pumpRouter(tester);

    await navigate(tester, () => router.push('/home/b/bakery'));
    expect(find.text('home bakery'), findsOneWidget);
    expect(find.text('tab bar 0'), findsOneWidget);

    await navigate(tester, () => router.push('/home/b/bakery/menu'));
    expect(find.text('menu'), findsOneWidget);
    expect(find.text('tab bar 0'), findsOneWidget);
    expect(tabsBuilt(), 1);

    await navigate(tester, router.pop);
    await navigate(tester, router.pop);
    expect(find.text('hub'), findsOneWidget);
  });

  testWidgets('a route outside the tabs covers the bar, and back returns to '
      'the tab\'s screens', (tester) async {
    await pumpRouter(tester);
    await navigate(tester, () => router.push('/home/b/bakery'));

    await navigate(tester, () => router.push('/b/bakery/cart'));
    expect(find.text('cart'), findsOneWidget);
    expect(find.textContaining('tab bar'), findsNothing);

    await navigate(tester, router.pop);
    expect(find.text('home bakery'), findsOneWidget);
    expect(find.text('tab bar 0'), findsOneWidget);
  });

  testWidgets('go() to a tab\'s route from above the tabs builds the tabs '
      'once, with the route\'s parents underneath; other tabs keep their '
      'screens', (tester) async {
    await pumpRouter(tester);
    await navigate(tester, () => router.go('/profile/b/sushi/info'));
    await navigate(tester, () => shell(tester).goBranch(0));
    await navigate(tester, () => router.push('/home/b/bakery'));
    await navigate(tester, () => router.push('/b/bakery/cart'));
    await navigate(tester, () => router.push('/b/bakery/checkout'));

    await navigate(tester, () => router.go('/home/b/bakery/menu'));
    expect(tabsBuilt(), 1);
    expect(find.text('menu'), findsOneWidget);
    expect(find.text('tab bar 0'), findsOneWidget);

    await navigate(tester, () => shell(tester).goBranch(1));
    expect(find.text('info'), findsOneWidget);
    await navigate(tester, () => shell(tester).goBranch(0));
    expect(find.text('menu'), findsOneWidget);

    await navigate(tester, router.pop);
    expect(find.text('home bakery'), findsOneWidget);
    await navigate(tester, router.pop);
    expect(find.text('hub'), findsOneWidget);
  });

  testWidgets('push() of a tab\'s route from above the tabs holds the tabs '
      'twice, which fails to build (duplicate navigator keys); '
      'pushReplacement() only merges when the replaced route sits right on '
      'the tabs', (tester) async {
    await pumpRouter(tester);
    await navigate(tester, () => router.push('/home/b/bakery'));
    await navigate(tester, () => router.push('/b/bakery/cart'));

    // The matches change synchronously, so each case is checked and undone
    // before a frame could build it.
    router.push('/home/b/bakery/menu');
    expect(tabsBuilt(), 2);
    router.go('/home/b/bakery');
    router.push('/b/bakery/cart');
    router.push('/b/bakery/checkout');
    router.pushReplacement('/home/b/bakery/menu');
    expect(tabsBuilt(), 2);

    router.go('/home/b/bakery');
    router.push('/b/bakery/cart');
    router.pushReplacement('/home/b/bakery/menu');
    expect(tabsBuilt(), 1);
    await tester.pumpAndSettle();
    expect(find.text('menu'), findsOneWidget);
  });

  testWidgets('another tab\'s route pushed from a tab opens inside the current '
      'tab, though its address names the other tab', (tester) async {
    await pumpRouter(tester);
    await navigate(tester, () => shell(tester).goBranch(1));

    await navigate(tester, () => router.push('/home/b/bakery'));
    expect(find.text('home bakery'), findsOneWidget);
    expect(find.text('tab bar 1'), findsOneWidget);
    expect(router.state.uri.path, '/home/b/bakery');
  });

  testWidgets('tapping the current tab again returns it to its first screen', (
    tester,
  ) async {
    await pumpRouter(tester);
    await navigate(tester, () => router.push('/home/b/bakery'));
    await navigate(tester, () => router.push('/home/b/bakery/menu'));

    await navigate(
      tester,
      () => shell(tester).goBranch(0, initialLocation: true),
    );
    expect(find.text('hub'), findsOneWidget);
    expect(tabsBuilt(), 1);
  });
}
