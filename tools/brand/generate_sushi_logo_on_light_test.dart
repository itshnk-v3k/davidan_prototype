// Generates DaviDan Sushi's logo for light backgrounds from the site's logo,
// which is made for dark ones: the near-white "DaviDan" turns charcoal, and
// the red fish and "SUSHI" stay red. Nothing is downloaded; it reads
// assets/images/brand/logo-davidan-sushi.webp. Run it again after the logo or
// the light palette changes:
//
//   flutter test tools/brand/generate_sushi_logo_on_light_test.dart
//
// It writes assets/images/brand/logo-davidan-sushi-on-light.png. `flutter
// test` on its own doesn't run it: it lives outside test/.
import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';

import 'package:davidan_prototype/core/theme/app_palette.dart';

const _logoPath = 'assets/images/brand/logo-davidan-sushi.webp';
const _outputPath = 'assets/images/brand/logo-davidan-sushi-on-light.png';

/// Pixels whose channels differ by less than this share are treated as the
/// near-white wordmark, not the red.
const _neutralSaturation = 0.25;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('generate the sushi logo for light backgrounds', () async {
    final codec = await ui.instantiateImageCodec(
      File(_logoPath).readAsBytesSync(),
    );
    final logo = (await codec.getNextFrame()).image;
    final pixels = (await logo.toByteData(
      format: ui.ImageByteFormat.rawStraightRgba,
    ))!.buffer.asUint8List();

    // The wordmark's edges are anti-aliased with its own colour at partial
    // opacity, so only the colour changes; the opacity stays.
    const charcoal = AppPalette.charcoal;
    final out = Uint8List.fromList(pixels);
    for (var i = 0; i < out.length; i += 4) {
      if (out[i + 3] == 0 || !_isNeutral(pixels, i)) continue;
      out[i] = (charcoal.r * 255).round();
      out[i + 1] = (charcoal.g * 255).round();
      out[i + 2] = (charcoal.b * 255).round();
    }

    final completer = Completer<ui.Image>();
    ui.decodeImageFromPixels(
      out,
      logo.width,
      logo.height,
      ui.PixelFormat.rgba8888,
      completer.complete,
    );
    final png = await (await completer.future).toByteData(
      format: ui.ImageByteFormat.png,
    );
    File(_outputPath).writeAsBytesSync(png!.buffer.asUint8List());
  });
}

bool _isNeutral(Uint8List pixels, int i) {
  final channels = [pixels[i], pixels[i + 1], pixels[i + 2]];
  return (channels.reduce(math.max) - channels.reduce(math.min)) / 255 <
      _neutralSaturation;
}
