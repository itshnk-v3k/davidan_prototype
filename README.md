# DaviDan Prototype

Clickable prototype of a delivery platform for DaviDan, a bakery chain in Moldova. Built with Flutter for web. No backend: all data is mocked and saved only on the device.

## Scope

A demo build for the client to review and decide what to keep or cut. This is not production code.

- **Customer app**: location selection, menu, product, cart, checkout, order tracking, profile
- **Courier app**: order list and delivery screen with status buttons
- **Store panel (KDS)**: incoming orders with a timer and an Accept button

## Stack

- Flutter 3.47 / Dart 3.13
- [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) 3.x for state, using hand-written Notifiers (no code generation)
- [go_router](https://pub.dev/packages/go_router) 18.x for routing
- [shared_preferences](https://pub.dev/packages/shared_preferences) 2.x for local storage (localStorage on web)

## Run

```sh
flutter pub get
flutter run -d chrome --web-port=8080 -t lib/main_demo.dart
```

There are two entry points:

- `lib/main_demo.dart`: the app plus internal demo tools. The launcher then also shows **Toate rolurile**, a board with the customer's order, the store panel and the courier app side by side, updating live in one window. Use this one to present the prototype.
- `lib/main.dart`: the app on its own. Demo tools live in `lib/demo_tools/`, which only `main_demo.dart` imports, so they are never compiled into this build.

Always use a fixed `--web-port`. localStorage belongs to the origin (host + port), and `flutter run` picks a random port by default, so saved data looks lost between runs.

To clear saved data, open Chrome DevTools → Application → Storage → **Clear site data** for `localhost:8080`.

## Demo build (works offline)

```sh
flutter build web --release --no-web-resources-cdn -t lib/main_demo.dart
```

`--no-web-resources-cdn` bundles Flutter's rendering engine instead of loading it from Google's CDN, and Roboto is bundled in `assets/fonts/`. The build makes no external requests, so it doesn't depend on the meeting room's wifi. Serve `build/web/` from any static server.

## Status

Setup phase. Dependencies are installed and no screens are built yet.
