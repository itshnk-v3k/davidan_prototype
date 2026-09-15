import 'package:flutter_test/flutter_test.dart';

import 'package:davidan_prototype/core/utils/numbers.dart';

void main() {
  test('thousands are grouped with dots', () {
    expect(formatCount(0), '0');
    expect(formatCount(74), '74');
    expect(formatCount(720), '720');
    expect(formatCount(1000), '1.000');
    expect(formatCount(2000000), '2.000.000');
    expect(formatCount(5060000), '5.060.000');
  });
}
