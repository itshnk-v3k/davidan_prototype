// Generates the app icons from the DaviDan logo: the logo's wheat "D" in
// white on the site's caramel. Nothing is downloaded; it reads
// assets/images/brand/logo-davidan.webp. Run it again after the logo or the
// design changes:
//
//   flutter test tools/app_icon/generate_app_icons_test.dart
//
// It writes the Android launcher icons (a legacy icon, plus the foreground of
// the adaptive icon whose background is ic_launcher_background in
// android/app/src/main/res/values/colors.xml) and the web favicon and PWA
// icons. `flutter test` on its own doesn't run it: it lives outside test/.
//
// The logo is only 111 px tall, so the biggest icons are upscaled and a
// little soft. A vector logo from the client would make them sharp.
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:davidan_prototype/core/theme/app_palette.dart';

/// Where the wheat "D" sits in logo-davidan.webp (600 × 111), in pixels.
const _glyph = Rect.fromLTWH(318, 0, 102, 111);

const _logoPath = 'assets/images/brand/logo-davidan.webp';
const _androidRes = 'android/app/src/main/res';

/// Android launcher densities and their scale from mdpi.
const _densities = {
  'mdpi': 1.0,
  'hdpi': 1.5,
  'xhdpi': 2.0,
  'xxhdpi': 3.0,
  'xxxhdpi': 4.0,
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('generate app icons', () async {
    final codec = await ui.instantiateImageCodec(
      File(_logoPath).readAsBytesSync(),
    );
    final logo = (await codec.getNextFrame()).image;

    for (final MapEntry(key: density, value: scale) in _densities.entries) {
      // Legacy icon (Android 7): a rounded caramel square, 48 dp.
      await _writePng(
        '$_androidRes/mipmap-$density/ic_launcher.png',
        (48 * scale).round(),
        (canvas, size) => _roundedIcon(canvas, logo, size),
      );
      // Adaptive icon foreground (Android 8+): 108 dp, of which the launcher
      // may mask everything outside the central 66 dp circle.
      await _writePng(
        '$_androidRes/mipmap-$density/ic_launcher_foreground.png',
        (108 * scale).round(),
        (canvas, size) => _drawGlyph(
          canvas,
          logo,
          Rect.fromCenter(
            center: Offset(size / 2, size / 2),
            width: size,
            height: size * 44 / 108,
          ),
        ),
      );
    }

    await _writePng(
      'web/favicon.png',
      32,
      (canvas, size) => _roundedIcon(canvas, logo, size),
    );
    for (final size in [192, 512]) {
      await _writePng(
        'web/icons/Icon-$size.png',
        size,
        (canvas, size) => _roundedIcon(canvas, logo, size),
      );
      // Maskable: full-bleed background, glyph inside the 80 % safe circle.
      await _writePng('web/icons/Icon-maskable-$size.png', size, (
        canvas,
        size,
      ) {
        canvas.drawRect(
          Rect.fromLTWH(0, 0, size, size),
          Paint()..color = AppPalette.caramel500,
        );
        _drawGlyph(
          canvas,
          logo,
          Rect.fromCenter(
            center: Offset(size / 2, size / 2),
            width: size,
            height: size * 0.42,
          ),
        );
      });
    }
  });
}

/// A caramel square with rounded corners and the glyph at 58 % of its height.
void _roundedIcon(Canvas canvas, ui.Image logo, double size) {
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size, size),
      Radius.circular(size * 0.22),
    ),
    Paint()..color = AppPalette.caramel500,
  );
  _drawGlyph(
    canvas,
    logo,
    Rect.fromCenter(
      center: Offset(size / 2, size / 2),
      width: size,
      height: size * 0.58,
    ),
  );
}

/// Draws the wheat "D" in white, as large as fits in [target], centred.
void _drawGlyph(Canvas canvas, ui.Image logo, Rect target) {
  final scale = math.min(
    target.width / _glyph.width,
    target.height / _glyph.height,
  );
  canvas.drawImageRect(
    logo,
    _glyph,
    Rect.fromCenter(
      center: target.center,
      width: _glyph.width * scale,
      height: _glyph.height * scale,
    ),
    Paint()
      ..filterQuality = FilterQuality.high
      ..colorFilter = const ColorFilter.mode(AppPalette.white, BlendMode.srcIn),
  );
}

Future<void> _writePng(
  String path,
  int size,
  void Function(Canvas canvas, double size) paint,
) async {
  final recorder = ui.PictureRecorder();
  paint(Canvas(recorder), size.toDouble());
  final image = await recorder.endRecording().toImage(size, size);
  final png = await image.toByteData(format: ui.ImageByteFormat.png);
  File(path)
    ..createSync(recursive: true)
    ..writeAsBytesSync(png!.buffer.asUint8List());
}
