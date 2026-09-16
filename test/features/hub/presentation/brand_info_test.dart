// A brand's information page and legal pages (/b/:brand/info/...), in the
// real app, in Chrome:
//   flutter test --platform chrome
@TestOn('browser')
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:davidan_prototype/core/router/routes.dart';
import 'package:davidan_prototype/core/theme/app_text_styles.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/features/food/presentation/home/brand_home_screen.dart';
import 'package:davidan_prototype/features/hub/presentation/brand_info_screen.dart';
import 'package:davidan_prototype/features/hub/presentation/legal_document_screen.dart';

import '../../../helpers/test_app.dart';

void main() {
  setUpAll(() => SharedPreferencesAsyncWeb.registerWith(null));

  late ProviderContainer container;

  setUp(() async => container = await createTestContainer());

  Finder infoButton() =>
      find.bySemanticsLabel(ro.openBrandInfo('DaviDan Sushi'));

  Future<void> tapBack(WidgetTester tester, Type screen) async {
    await tester.tap(
      find.descendant(
        of: find.byType(screen),
        matching: find.byIcon(Icons.arrow_back_rounded),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'the sushi home\'s info button opens its contacts from davidansushi.md '
    'and both legal pages in full; back returns one step at a time',
    (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpApp(tester, container, Routes.brandHome(Brand.sushi));
      await tester.tap(infoButton());
      await tester.pumpAndSettle();
      semantics.dispose();

      final info = find.byType(BrandInfoScreen);
      expect(info, findsOneWidget);
      for (final text in [
        'DaviDan Sushi',
        'or. Chișinău',
        'Strada Vlaicu Pârcălab 52\nEtajul 2',
        '+373 (67) 808 080',
        'info@davidan.md',
        'instagram.com/davidansushi.md',
        'S.R.L. DANVAL BAKERY',
        ro.brandInfoPhone,
        ro.legalDocumentHint('davidansushi.md'),
      ]) {
        expect(
          find.descendant(of: info, matching: find.text(text)),
          text == ro.legalDocumentHint('davidansushi.md')
              ? findsNWidgets(2)
              : findsOneWidget,
          reason: text,
        );
      }

      await tapVisible(tester, find.text('Termeni și Condiții'));
      final document = find.byType(LegalDocumentScreen);
      expect(document, findsOneWidget);
      expect(
        find.descendant(
          of: document,
          matching: find.textContaining(
            'Produsele alimentare nu pot fi returnate din motive de igienă',
            findRichText: true,
          ),
        ),
        findsOneWidget,
      );
      // The legal entity's details, with "Chişinău" in its proper spelling.
      expect(
        find.descendant(
          of: document,
          matching: find.textContaining(
            'Adresa: mun. Chișinău, sec. Botanica',
            findRichText: true,
          ),
        ),
        findsOneWidget,
      );

      await tapBack(tester, LegalDocumentScreen);
      expect(info, findsOneWidget);
      await tapVisible(tester, find.text('Politica de Confidențialitate'));
      expect(
        find.descendant(
          of: document,
          matching: find.textContaining(
            '– Obiective statistice.',
            findRichText: true,
          ),
        ),
        findsOneWidget,
      );

      await tapBack(tester, LegalDocumentScreen);
      await tapBack(tester, BrandInfoScreen);
      expect(find.byType(BrandHomeScreen), findsOneWidget);
    },
  );

  testWidgets(
    'the bakery has no info button, and its info link shows its home; an '
    'unknown legal page shows the information page, which goes back to the '
    'brand\'s home when opened from a link',
    (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpApp(tester, container, Routes.brandHome(Brand.bakery));
      expect(find.bySemanticsLabel(RegExp(ro.openBrandInfo(''))), findsNothing);
      semantics.dispose();

      await pumpApp(tester, container, Routes.brandInfo(Brand.bakery));
      expect(find.byType(BrandHomeScreen), findsOneWidget);
      expect(find.byType(BrandInfoScreen), findsNothing);

      await pumpApp(
        tester,
        container,
        Routes.brandLegal(Brand.sushi, 'politica-de-returnare'),
      );
      expect(find.byType(BrandInfoScreen), findsOneWidget);
      await tapBack(tester, BrandInfoScreen);
      expect(
        tester.widget<BrandHomeScreen>(find.byType(BrandHomeScreen)).brand,
        Brand.sushi,
      );

      await pumpApp(
        tester,
        container,
        Routes.brandLegal(Brand.sushi, 'termeni-si-conditii'),
      );
      await tapBack(tester, LegalDocumentScreen);
      expect(find.byType(BrandInfoScreen), findsOneWidget);
    },
  );

  testWidgets(
    'legal text keeps the site\'s layout: bold labels, headings, and line '
    'breaks within a paragraph, with none of the markup showing',
    (tester) async {
      await pumpApp(
        tester,
        container,
        Routes.brandLegal(Brand.sushi, 'termeni-si-conditii'),
      );
      final styles = tester
          .element(find.byType(LegalDocumentScreen))
          .textStyles;

      expect(
        tester.widget<Text>(find.text('Obiective generale')).style,
        styles.subtitle,
      );

      final prices = tester.widget<RichText>(
        find.byWidgetPredicate(
          (widget) =>
              widget is RichText &&
              widget.text.toPlainText().startsWith('Prețurile: Prețurile'),
        ),
      );
      final paragraph = (prices.text as TextSpan).children!.single as TextSpan;
      final [label, text] = paragraph.children!.cast<TextSpan>();
      expect(label.text, 'Prețurile:');
      expect(label.style, styles.bodyStrong);
      expect(
        text.text,
        startsWith(' Prețurile produselor sunt afișate în lei'),
      );
      expect(text.style, isNull);

      await tester.scrollUntilVisible(
        find.textContaining('BIC: AGRNMD2X', findRichText: true),
        300,
        scrollable: find.byType(Scrollable).last,
      );
      expect(
        find.textContaining(
          'Denumire: S.R.L. DANVAL BAKERY\nC/F: 1023600044712\n',
          findRichText: true,
        ),
        findsOneWidget,
      );
      expect(find.textContaining('**', findRichText: true), findsNothing);
      expect(find.textContaining('# ', findRichText: true), findsNothing);
    },
  );
}
