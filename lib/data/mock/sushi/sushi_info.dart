import 'package:davidan_prototype/data/mock/sushi/sushi_legal.dart';
import 'package:davidan_prototype/data/models/brand_info.dart';

/// davidansushi.md's footer, delivery page and legal pages
/// (docs/sources/davidansushi_md.md, sections 4 and 5). The delivery page's
/// visible part names the city; its terms, fees and hours sit in a block the
/// site hides, so they are left out, like every delivery fee in the app.
const sushiInfo = BrandInfo(
  name: 'DaviDan Sushi',
  website: 'davidansushi.md',
  lines: [
    (kind: BrandInfoKind.deliveryArea, value: 'or. Chișinău'),
    (kind: BrandInfoKind.address, value: 'Strada Vlaicu Pârcălab 52\nEtajul 2'),
    (kind: BrandInfoKind.phone, value: '+373 (67) 808 080'),
    (kind: BrandInfoKind.email, value: 'info@davidan.md'),
    (kind: BrandInfoKind.instagram, value: 'instagram.com/davidansushi.md'),
    // The operator named by its Termeni și Condiții.
    (kind: BrandInfoKind.company, value: 'S.R.L. DANVAL BAKERY'),
  ],
  documents: [
    LegalDocument(
      id: 'termeni-si-conditii',
      title: 'Termeni și Condiții',
      text: sushiTermsText,
    ),
    LegalDocument(
      id: 'politica-de-confidentialitate',
      title: 'Politica de Confidențialitate',
      text: sushiPrivacyText,
    ),
  ],
);
