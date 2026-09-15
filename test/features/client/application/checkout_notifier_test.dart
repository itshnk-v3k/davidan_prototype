import 'package:flutter_test/flutter_test.dart';

import 'package:davidan_prototype/features/client/application/checkout_notifier.dart';

DateTime at(int hour, [int minute = 0, int second = 0]) =>
    DateTime(2026, 9, 15, hour, minute, second);

void main() {
  test('slots are six half hours, starting at least 30 minutes away', () {
    expect(timeSlotsAfter(at(10, 7)), [
      at(11),
      at(11, 30),
      at(12),
      at(12, 30),
      at(13),
      at(13, 30),
    ]);
  });

  test('a time exactly on the half hour keeps that slot', () {
    expect(timeSlotsAfter(at(10)).first, at(10, 30));
    expect(timeSlotsAfter(at(10, 30, 1)).first, at(11, 30));
  });

  test('early in the morning slots start at 08:00', () {
    expect(timeSlotsAfter(at(6, 10)), [
      at(8),
      at(8, 30),
      at(9),
      at(9, 30),
      at(10),
      at(10, 30),
    ]);
  });

  test('the last slot is 20:00', () {
    expect(timeSlotsAfter(at(18, 20)), [at(19), at(19, 30), at(20)]);
    expect(timeSlotsAfter(at(19, 30)), [at(20)]);
  });

  test('from 19:31 there are no slots, so none roll past midnight', () {
    expect(timeSlotsAfter(at(19, 31)), isEmpty);
    expect(timeSlotsAfter(at(23, 50)), isEmpty);
  });
}
