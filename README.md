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

- `lib/main_demo.dart`: the app plus internal demo tools. The launcher then also shows **Toate rolurile**, a board with the customer's order, the store panel and the courier app side by side, updating live in one window. Use this one when you want to show the board.
- `lib/main.dart`: the app on its own, used for the regular client-facing demo. Demo tools live in `lib/demo_tools/`, which only `main_demo.dart` imports, so they are never compiled into this build.

Always use a fixed `--web-port`. localStorage belongs to the origin (host + port), and `flutter run` picks a random port by default, so saved data looks lost between runs.

To clear saved data, open Chrome DevTools → Application → Storage → **Clear site data** for `localhost:8080`.

## Demo builds (work offline)

There is one build per entry point. Both need the same flags.

**Regular client demo** (`lib/main.dart`, without the all-roles board):

```sh
flutter build web --release --no-web-resources-cdn
```

**All-roles board build** (`lib/main_demo.dart`):

```sh
flutter build web --release --no-web-resources-cdn -t lib/main_demo.dart
```

> **Warning:** both builds write to `build/web/`, so only the most recently built entry point is served from there. Rebuild the one you need right before presenting.

`--no-web-resources-cdn` bundles Flutter's rendering engine instead of loading it from Google's CDN, and Roboto is bundled in `assets/fonts/`. The build makes no external requests, so it doesn't depend on the meeting room's wifi. Serve `build/web/` from any static server.

## Android emulator and DevTools (VS Code)

VS Code with the Dart and Flutter extensions is the editor. Android Studio is only needed once, to create the emulator.

### One-time: create the emulator

1. Open Android Studio. On the Welcome screen click **More Actions → Virtual Device Manager**. If a project window opens instead, use **View → Tool Windows → Device Manager**.
2. Click **+**, then **Create Virtual Device**.
3. Choose **Phone** → **Medium Phone** → **Next**. This is a generic mid-size phone, not a tablet.
4. Pick the **API 36** image with **Google APIs** for **arm64-v8a**. It is already downloaded, so it shows no download icon.
5. Open the **Additional settings** tab. Under **Emulated Performance**, set **Graphics acceleration** to **Hardware**. If there is a keyboard option, enable it so the Mac keyboard types into text fields.
6. Click **Finish** and quit Android Studio. It doesn't need to be open again.

To check it from a terminal, run `flutter emulators`. The new emulator should be listed.

### Run the app on the emulator

1. Click the device name at the bottom right of the status bar and pick the emulator. Picking one that isn't running starts it. **Flutter: Launch Emulator** in the command palette does the same.
2. Open `lib/main.dart` and press **F5**. The first Android build takes about 2 minutes; later runs are much faster.
3. While it runs, use **Hot Reload** / **Hot Restart** on the floating debug toolbar.

**All-roles board:** open `lib/main_demo.dart` and click **Run** or **Debug** above `main()`. It runs on the device picked in the status bar. On a phone-width screen the four panels stack, so scroll through them.

Saved demo data lives on the emulator, separate from Chrome's localStorage. Use **Resetează datele demo** in the launcher to clear it.

### Open DevTools

With a debug session running, run **Flutter: Open DevTools** from the command palette, or use the DevTools buttons on the debug toolbar. DevTools opens beside the editor, and the Widget Inspector opens in the sidebar.

- **Widget Inspector:** the widget tree, each widget's properties and layout, and **Select Widget Mode** to tap a widget on screen and find it in the tree. Chrome's own DevTools can't do this, because Flutter draws to a canvas.
- **Performance:** a bar per frame (UI and raster time), hints for slow frames, and **Rebuild Stats** (how often each widget rebuilt). This page works for Android, not for web apps.
- **Memory**, **CPU Profiler**, **Network**, **Logging:** available when you need them.

**If something feels slow, check first:**

1. **Performance → Rebuild Stats.** Turn on **Track widget rebuilds** and use the screen. Look for counts that keep rising while nothing on screen changes. This needs debug mode, so the emulator is the right place for it.
2. **Widget Inspector → Highlight oversized images.** Product photos are 800 px and banners 900 px, drawn much smaller.
3. **Frame times:** on an emulator, and in debug mode, compare them with each other only. They say nothing about real speed.

### Judging real performance

Debug mode is slow on purpose, especially on web: the code is compiled for debugging, not speed, and assertions are on. Don't judge how the app feels from a debug run.

- **How the demo really feels (web):** run `flutter run -d chrome --release --web-port=8080` in VS Code's terminal. This is the same optimized compile as the demo build, and the same port keeps your saved data.
- **Finding where time goes (web):** run `flutter run -d chrome --profile --web-port=8080`. In Chrome press F12 → **Performance** → **Record**, then use the app; Flutter's frame events show in the recording. Flutter's own DevTools can't connect in this mode.
- **Emulator:** debug mode only; Flutter doesn't support profile or release builds on emulators. Use it for phone layout, touch, the on-screen keyboard and Android back, plus Rebuild Stats. Don't use it to measure speed. Measuring speed on Android needs a real phone in profile mode.

## Status

Setup phase. Dependencies are installed and no screens are built yet.
