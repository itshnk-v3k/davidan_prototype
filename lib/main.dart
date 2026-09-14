import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:davidan_prototype/app.dart';
import 'package:davidan_prototype/core/storage/local_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved demo state before the first frame, so Notifiers restore it
  // synchronously: no empty-cart flash, and route redirects can read it.
  final prefs = await LocalStore.openPreferences();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const DaviDanApp(),
    ),
  );
}
