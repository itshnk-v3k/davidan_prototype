import 'package:flutter/foundation.dart';

/// What a line of a brand's information page is about. Its label and icon
/// are UI text; its value is the brand's.
enum BrandInfoKind { deliveryArea, address, phone, email, instagram, company }

/// A brand's information page: its contacts and legal pages, quoted from its
/// site (docs/sources/). Only what the site says; a brand whose site has none
/// has no page.
@immutable
class BrandInfo {
  const BrandInfo({
    required this.name,
    required this.website,
    required this.lines,
    this.documents = const [],
  });

  /// The brand's full name, e.g. "DaviDan Sushi".
  final String name;

  /// The site the information comes from, e.g. "davidansushi.md".
  final String website;

  /// In display order.
  final List<({BrandInfoKind kind, String value})> lines;
  final List<LegalDocument> documents;
}

/// One of a brand's legal pages, with its whole text.
@immutable
class LegalDocument {
  const LegalDocument({
    required this.id,
    required this.title,
    required this.text,
  });

  /// The page's slug on the brand's site, also used in the app's link.
  final String id;

  /// The page's title on the site.
  final String title;

  /// The page's text, in LegalText's format.
  final String text;
}
