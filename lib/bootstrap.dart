import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

import 'package:davidan_prototype/app.dart';
import 'package:davidan_prototype/core/storage/local_store.dart';

/// Starts the app. The entry points (lib/main*.dart) differ only in the
/// [overrides] they pass.
Future<void> bootstrap({List<Override> overrides = const []}) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved demo state before the first frame, so Notifiers restore it
  // synchronously: no empty-cart flash, and route redirects can read it.
  final prefs = await LocalStore.openPreferences();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        ...overrides,
      ],
      child: const DaviDanApp(),
    ),
  );
}
