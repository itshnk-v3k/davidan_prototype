// Generates each brand's logo in white, for the brand-colour bubbles on the
// hub and the brand-colour header bands: every visible pixel of the site's
// logo turns white and keeps its opacity. Nothing is downloaded; it reads the
// logos in assets/images/brand/. Run it again after a logo changes:
//
//   flutter test tools/brand/generate_white_logos_test.dart
//
// It writes the *-white.png files next to the logos. `flutter test` on its
// own doesn't run it: it lives outside test/.
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';

const _brand = 'assets/images/brand';

/// Source logo, output, and the part of the source to keep (null for all).
const _logos = <(String, String, ui.Rect?)>[
  ('logo-davidan.webp', 'logo-davidan-white.png', null),
  // The wheat "D" alone, as the app icon uses it (logo-davidan.webp is
  // 600 × 111).
  (
    'logo-davidan.webp',
    'logo-davidan-mark-white.png',
    ui.Rect.fromLTWH(318, 0, 102, 111),
  ),
  ('logo-davidan-sushi.webp', 'logo-davidan-sushi-white.png', null),
  ('logo-apa-davidan.webp', 'logo-apa-davidan-white.png', null),
  ('logo-davidan-rent-car.webp', 'logo-davidan-rent-car-white.png', null),
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  for (final (source, output, crop) in _logos) {
    test('generate $output', () async {
      final codec = await ui.instantiateImageCodec(
        File('$_brand/$source').readAsBytesSync(),
      );
      final logo = (await codec.getNextFrame()).image;
      final pixels = (await logo.toByteData(
        format: ui.ImageByteFormat.rawStraightRgba,
      ))!.buffer.asUint8List();

      final area =
          crop ??
          ui.Rect.fromLTWH(0, 0, logo.width.toDouble(), logo.height.toDouble());
      final left = area.left.round();
      final top = area.top.round();
      final width = area.width.round();
      final height = area.height.round();

      final out = Uint8List(width * height * 4);
      for (var y = 0; y < height; y++) {
        for (var x = 0; x < width; x++) {
          final from = ((top + y) * logo.width + left + x) * 4;
          final to = (y * width + x) * 4;
          out[to] = 255;
          out[to + 1] = 255;
          out[to + 2] = 255;
          out[to + 3] = pixels[from + 3];
        }
      }

      final completer = Completer<ui.Image>();
      ui.decodeImageFromPixels(
        out,
        width,
        height,
        ui.PixelFormat.rgba8888,
        completer.complete,
      );
      final png = await (await completer.future).toByteData(
        format: ui.ImageByteFormat.png,
      );
      File('$_brand/$output').writeAsBytesSync(png!.buffer.asUint8List());
    });
  }
}
