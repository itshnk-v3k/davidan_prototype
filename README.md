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

## Android APK (for the client's phone)

The client uses Android, so the demo can be handed over as a single APK file: no Play Store and no developer account.

### Build it

**Regular client demo** (`lib/main.dart`):

```sh
flutter build apk --release
```

**All-roles board build** (`lib/main_demo.dart`):

```sh
flutter build apk --release -t lib/main_demo.dart
```

Output: `build/app/outputs/flutter-apk/app-release.apk`, about 54 MB. The first build takes about 3 minutes; later ones are faster.

> **Warning:** both builds write the same `app-release.apk` and share one app ID, so on the phone one replaces the other. Rebuild the one you need right before sending it.

There is no Android equivalent of `--no-web-resources-cdn`, and none is needed: the APK always contains Flutter's engine, Roboto, the icons and every product photo. The release build doesn't even declare the internet permission, so the app cannot make network requests and works in airplane mode.

This is a universal APK. It carries the engine for all three phone CPU types, so it installs on any Android phone, and that's most of its size. `flutter build apk --release --split-per-abi` writes one file per CPU type instead (`app-arm64-v8a-release.apk` is about 20 MB and fits most recent phones). Only use that if 54 MB is a problem, because then you have to send the right file.

### Before sending a new version

Raise both parts of `version` in `pubspec.yaml`, for example `1.0.0+1` → `1.0.1+2`. Android won't install a lower build number (`+N`) over a higher one, and **Settings → Apps → DaviDan** shows the part before `+`, so you and the client can tell which version is on the phone.

An update keeps the demo data on the phone, as long as the new APK is signed with the same key.

### App name and icon

The app is called **DaviDan Delivery** on the phone's home screen (`android:label` in `android/app/src/main/AndroidManifest.xml`) and in the browser tab (`web/index.html`, `web/manifest.json`, `AppStrings.appTitle`).

The icon is the logo's wheat "D" in white on the site's caramel, for Android and for the web favicon and PWA icons. It is generated from `assets/images/brand/logo-davidan.webp`, with nothing downloaded:

```sh
flutter test tools/app_icon/generate_app_icons_test.dart
```

Run it again after changing the logo or the icon design, then rebuild the APK. The logo is only 111 px tall, so the largest icons are slightly soft; a vector logo from the client would make them sharp.

### Signing

The APK is signed with this Mac's debug key (`~/.android/debug.keystore`, created by the Android SDK). It installs normally, but the phone ties the installed app to that key:

- A new APK built on this Mac installs over the old one as an update.
- An APK built on any other machine has a different debug key. The phone refuses it as an update, so the client would have to uninstall DaviDan first, which erases its demo data.

Switching to a dedicated release keystore hasn't been decided yet. If one is added, `key.properties`, `*.jks` and `*.keystore` are already git-ignored in `android/.gitignore`.

### Walking the client through the install

First-time install, in the order the phone asks:

1. **Send the file.** Telegram or WhatsApp (as a file), Google Drive, or a USB cable all work. Gmail doesn't: it blocks `.apk` attachments.
2. **Open it on the phone.** Tap the file in the chat, or find it in **Files → Downloads**.
3. **Allow the source.** Android says the app that opened the file (Telegram, Chrome, Files…) isn't allowed to install apps. Tap **Settings**, turn on **Allow from this source**, then go back. The permission is per app, so it's asked again if an APK is later opened from somewhere else.
4. **Install.** Tap **Install**. Google Play Protect may say it doesn't recognise the app and offer to scan it. Scanning is fine and takes a few seconds. The app asks for no sensitive permissions, so it shouldn't be blocked; if a warning appears anyway, tap **More details → Install anyway**.
5. **Open DaviDan** from the app list. **Allow from this source** can be turned off again afterwards.

If it won't install:

- **Samsung phones:** **Auto Blocker** (**Settings → Security and privacy → Auto Blocker**) blocks apps from outside the official stores. Turn it off for the install and back on afterwards.
- **"App not installed" or a conflict with an existing app:** a DaviDan signed with a different key is already on the phone. Uninstall it first; this deletes its demo data.
- **Install it yourself over USB:** on the phone, open **Settings → About phone** and tap **Build number** 7 times, then turn on **Developer options → USB debugging**. Plug it in and run:

  ```sh
  ~/Library/Android/sdk/platform-tools/adb install -r build/app/outputs/flutter-apk/app-release.apk
  ```

### Google's developer verification

Google is starting to require apps installed outside the Play Store to come from a verified developer. It starts on 30 September 2026 in Brazil, Indonesia, Singapore and Thailand and expands globally in 2027. Until it reaches Moldova, the steps above are all that's needed. After that, an APK from an unregistered developer installs only through Android's advanced flow (developer mode, a restart and a one-day wait) or over USB. Avoiding that means registering the app ID and the signing key's SHA-256 fingerprint under a verified developer account. A free limited-distribution account covers up to 20 devices.

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
