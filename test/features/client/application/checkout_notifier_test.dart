import 'package:flutter_test/flutter_test.dart';

import 'package:davidan_prototype/features/client/application/checkout_notifier.dart';

void main() {
  test('slots are six half hours, starting at least 30 minutes away', () {
    expect(timeSlotsAfter(DateTime(2026, 9, 15, 10, 7)), [
      for (final (hour, minute) in [
        (11, 0),
        (11, 30),
        (12, 0),
        (12, 30),
        (13, 0),
        (13, 30),
      ])
        DateTime(2026, 9, 15, hour, minute),
    ]);
  });

  test('a time exactly on the half hour keeps that slot', () {
    expect(
      timeSlotsAfter(DateTime(2026, 9, 15, 10)).first,
      DateTime(2026, 9, 15, 10, 30),
    );
    expect(
      timeSlotsAfter(DateTime(2026, 9, 15, 10, 30, 1)).first,
      DateTime(2026, 9, 15, 11, 30),
    );
  });

  test('late evening slots run past midnight into the next day', () {
    expect(
      timeSlotsAfter(DateTime(2026, 9, 15, 23, 50)).first,
      DateTime(2026, 9, 16, 0, 30),
    );
  });
}
