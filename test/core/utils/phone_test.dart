import 'package:flutter_test/flutter_test.dart';

import 'package:davidan_prototype/core/utils/phone.dart';

void main() {
  test('a number is kept to the 8 digits after +373', () {
    expect(MoldovanPhone.digitsOf('69123456'), '69123456');
    expect(MoldovanPhone.digitsOf('69 123 456'), '69123456');
    expect(MoldovanPhone.digitsOf('691234567'), '69123456');
  });

  test('the 0 dialled inside Moldova goes, as does a pasted +373', () {
    expect(MoldovanPhone.digitsOf('069123456'), '69123456');
    expect(MoldovanPhone.digitsOf('0'), '');
    expect(MoldovanPhone.digitsOf('+373 69 123 456'), '69123456');
    expect(MoldovanPhone.digitsOf('37379111222'), '79111222');
  });

  test('a number that merely starts with 373 digits is left alone', () {
    // 8 digits or fewer can't hold a prefix and a whole number.
    expect(MoldovanPhone.digitsOf('7373'), '7373');
    expect(MoldovanPhone.isValid(MoldovanPhone.digitsOf('373')), isFalse);
  });
}
