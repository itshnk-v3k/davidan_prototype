import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Keys of everything the app saves. When a new Notifier persists state, add
/// its key here and invalidate that Notifier in DemoResetNotifier.
abstract final class StorageKeys {
  static const cart = 'cart';
  static const orders = 'orders';

  static const all = {cart, orders};
}

/// Opened once in main() before runApp and injected with a ProviderScope
/// override, so Notifiers can read saved state synchronously in build().
final sharedPreferencesProvider = Provider<SharedPreferencesWithCache>(
  (ref) => throw UnimplementedError('Overridden in main()'),
);

final localStoreProvider = Provider<LocalStore>(
  (ref) => LocalStore(ref.watch(sharedPreferencesProvider)),
);

/// JSON key-value storage for demo state (localStorage on web).
class LocalStore {
  LocalStore(this._prefs);

  /// Bump when a saved model changes shape. Data saved under the old version
  /// is then ignored instead of failing to decode.
  ///
  /// 2: order statuses gained `accepted`; order items record their price.
  static const schemaVersion = 2;
  static const _prefix = 'davidan.v$schemaVersion.';

  /// Opens storage limited to [StorageKeys.all]. Other data on the same
  /// origin (another app on localhost:8080, say) is never read, so it can't
  /// break startup, and resetting the demo never deletes it.
  static Future<SharedPreferencesWithCache> openPreferences() =>
      SharedPreferencesWithCache.create(
        cacheOptions: SharedPreferencesWithCacheOptions(
          allowList: {for (final key in StorageKeys.all) '$_prefix$key'},
        ),
      );

  final SharedPreferencesWithCache _prefs;

  /// Returns null when nothing is saved or the saved JSON no longer decodes.
  T? read<T>(String key, T Function(Object? json) decode) {
    assert(StorageKeys.all.contains(key), 'Add "$key" to StorageKeys.all');
    final raw = _prefs.getString('$_prefix$key');
    if (raw == null) return null;
    try {
      return decode(jsonDecode(raw));
    } catch (error) {
      debugPrint('LocalStore: ignoring unreadable "$key": $error');
      return null;
    }
  }

  /// Updates the in-memory cache immediately; the disk write finishes in the
  /// background.
  void write(String key, Object? json) {
    assert(StorageKeys.all.contains(key), 'Add "$key" to StorageKeys.all');
    unawaited(_prefs.setString('$_prefix$key', jsonEncode(json)));
  }

  /// Removes all saved demo data.
  Future<void> clearAll() => _prefs.clear();
}
