import 'package:flutter_test/flutter_test.dart';

import 'package:davidan_prototype/core/utils/time.dart';

void main() {
  test('elapsed time is mm:ss, and h:mm:ss from one hour on', () {
    expect(formatElapsed(Duration.zero), '00:00');
    expect(formatElapsed(const Duration(minutes: 4, seconds: 12)), '04:12');
    expect(formatElapsed(const Duration(minutes: 59, seconds: 59)), '59:59');
    expect(
      formatElapsed(const Duration(hours: 1, minutes: 4, seconds: 12)),
      '1:04:12',
    );
  });

  test('a negative duration shows as 00:00', () {
    expect(formatElapsed(const Duration(seconds: -30)), '00:00');
  });

  test('date and time is dd.MM.yyyy, HH:mm', () {
    expect(formatDateTime(DateTime(2026, 9, 5, 9, 5)), '05.09.2026, 09:05');
    expect(formatDateTime(DateTime(2026, 12, 31, 23, 59)), '31.12.2026, 23:59');
  });
}
