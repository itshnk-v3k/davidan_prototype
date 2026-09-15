// Generates the logo for dark backgrounds from the DaviDan logo: the charcoal
// wordmark and wheat "D" turn cream, and the blue dot over the "i" stays blue.
// Nothing is downloaded; it reads assets/images/brand/logo-davidan.webp. Run
// it again after the logo or the dark palette changes:
//
//   flutter test tools/brand/generate_logo_on_dark_test.dart
//
// It writes assets/images/brand/logo-davidan-on-dark.png. `flutter test` on
// its own doesn't run it: it lives outside test/.
import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';

import 'package:davidan_prototype/core/theme/app_palette.dart';

const _logoPath = 'assets/images/brand/logo-davidan.webp';
const _outputPath = 'assets/images/brand/logo-davidan-on-dark.png';

/// Pixels whose channels differ by less than this share are treated as the
/// charcoal ink (and its grey anti-aliasing), not the blue dot.
const _neutralSaturation = 0.25;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('generate the logo for dark backgrounds', () async {
    final codec = await ui.instantiateImageCodec(
      File(_logoPath).readAsBytesSync(),
    );
    final logo = (await codec.getNextFrame()).image;
    final pixels = (await logo.toByteData(
      format: ui.ImageByteFormat.rawStraightRgba,
    ))!.buffer.asUint8List();

    // The darkest neutral pixel is full-strength ink; lighter greys (the
    // wheat's highlights) keep their share of it as partial opacity.
    var inkLightness = 1.0;
    for (var i = 0; i < pixels.length; i += 4) {
      if (pixels[i + 3] > 200 && _isNeutral(pixels, i)) {
        inkLightness = math.min(inkLightness, _lightness(pixels, i));
      }
    }

    final cream = AppPalette.cream;
    final out = Uint8List.fromList(pixels);
    for (var i = 0; i < out.length; i += 4) {
      if (out[i + 3] == 0 || !_isNeutral(pixels, i)) continue;
      final ink = ((1 - _lightness(pixels, i)) / (1 - inkLightness)).clamp(
        0.0,
        1.0,
      );
      out[i] = (cream.r * 255).round();
      out[i + 1] = (cream.g * 255).round();
      out[i + 2] = (cream.b * 255).round();
      out[i + 3] = (pixels[i + 3] * ink).round();
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

double _lightness(Uint8List pixels, int i) =>
    (pixels[i] + pixels[i + 1] + pixels[i + 2]) / (3 * 255);
