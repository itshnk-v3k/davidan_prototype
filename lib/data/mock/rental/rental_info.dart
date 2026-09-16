import 'package:davidan_prototype/data/mock/rental/rental_legal.dart';
import 'package:davidan_prototype/data/models/brand_info.dart';

/// davidanrentcar.md's footer, contacts and legal pages
/// (docs/sources/davidanrentcar_md.md, sections 3 and 4). The address is the
/// legal one its Termeni și Condiții give; the hours are its rental
/// department's, since the footer's "Service Centre" lines contradict
/// themselves.
const rentalInfo = BrandInfo(
  name: 'DaviDan Rent Car',
  website: 'davidanrentcar.md',
  lines: [
    (
      kind: BrandInfoKind.address,
      value: 'or. Chișinău, str. Vlaicu Pârcălab 52',
    ),
    (kind: BrandInfoKind.hours, value: 'Lucrăm 24/24'),
    (kind: BrandInfoKind.phone, value: '+373 79 816 666'),
    (kind: BrandInfoKind.email, value: 'davidanrentcar@gmail.com'),
    (kind: BrandInfoKind.instagram, value: 'instagram.com/davidanrentcar'),
    (kind: BrandInfoKind.company, value: 'DAVIDAN RENT CAR SRL'),
  ],
  documents: [
    LegalDocument(
      id: 'termeni-si-conditii',
      title: 'Termeni și Condiții',
      text: rentalTermsText,
    ),
    LegalDocument(
      id: 'politica-de-confidentialitate',
      title: 'Politica de Confidențialitate',
      text: rentalPrivacyText,
    ),
  ],
);
