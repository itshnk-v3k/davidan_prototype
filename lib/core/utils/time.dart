import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The current time. Tests override it so time-based UI is predictable.
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// Formats a time of day as "HH:mm": 9:05 → "09:05".
String formatTime(DateTime time) =>
    '${time.hour.toString().padLeft(2, '0')}:'
    '${time.minute.toString().padLeft(2, '0')}';
