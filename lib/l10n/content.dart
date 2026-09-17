import 'package:flutter/widgets.dart';

import 'package:davidan_prototype/data/mock/mock_brand.dart';
import 'package:davidan_prototype/data/mock/ru/ru_content.dart';
import 'package:davidan_prototype/data/models/brand.dart';
import 'package:davidan_prototype/data/models/brand_info.dart';
import 'package:davidan_prototype/data/models/brand_intro.dart';
import 'package:davidan_prototype/data/models/menu_category.dart';
import 'package:davidan_prototype/data/models/product.dart';
import 'package:davidan_prototype/data/models/promo_banner.dart';
import 'package:davidan_prototype/data/models/rental_car.dart';
import 'package:davidan_prototype/data/models/store_location.dart';

/// The brands' content (menus, shops, the fleet, brand pages) in the app's
/// language, as a backend would send it for `?lang=ru`. The mock data is
/// written in Romanian, as the brands' sites are. Its Russian is in
/// lib/data/mock/ru/, keyed by the Romanian it translates, like a gettext
/// catalogue. The catalog, shop and fleet providers apply it, so screens get
/// their content already translated; widgets that read brand constants
/// directly use `context.content`.
///
/// What stays as it is: names that are names (product brands like Coca Cola,
/// car models, "DaviDan Sushi"), phone numbers, e-mails, prices, and the text
/// of legal pages, which the sites have only in Romanian.
@immutable
class ContentTranslator {
  const ContentTranslator(this.lookup);

  /// Content as the mock data has it.
  static const romanian = ContentTranslator(_asWritten);

  static final russian = ContentTranslator((ro) => ruContent[ro] ?? ro);

  /// The translator for [locale], Romanian for any language but Russian.
  static ContentTranslator of(Locale locale) =>
      locale.languageCode == 'ru' ? russian : romanian;

  /// The text for a Romanian one. Tests pass their own to see which texts
  /// the app translates.
  final String Function(String ro) lookup;

  static String _asWritten(String ro) => ro;

  bool get _asIs => identical(this, romanian);

  String text(String ro) => lookup(ro);

  String? textOrNull(String? ro) => ro == null ? null : lookup(ro);

  Product product(Product product) => _asIs
      ? product
      : Product(
          brand: product.brand,
          id: product.id,
          categoryId: product.categoryId,
          name: text(product.name),
          priceBani: product.priceBani,
          image: product.image,
          description: textOrNull(product.description),
          weight: textOrNull(product.weight),
          pieces: textOrNull(product.pieces),
        );

  MenuCategory category(MenuCategory category) => _asIs
      ? category
      : MenuCategory(
          id: category.id,
          name: text(category.name),
          image: category.image,
          description: textOrNull(category.description),
        );

  PromoBanner banner(PromoBanner banner) => _asIs
      ? banner
      : PromoBanner(
          id: banner.id,
          image: banner.image,
          title: textOrNull(banner.title),
          subtitle: textOrNull(banner.subtitle),
          categoryId: banner.categoryId,
        );

  /// Opening hours are digits, the same in every language.
  StoreLocation shop(StoreLocation shop) => _asIs
      ? shop
      : StoreLocation(
          id: shop.id,
          name: text(shop.name),
          address: text(shop.address),
          openingHours: shop.openingHours,
          position: shop.position,
        );

  /// The model's name, year, engine size and prices stay as they are.
  RentalCar car(RentalCar car) => _asIs
      ? car
      : RentalCar(
          id: car.id,
          name: car.name,
          tagline: text(car.tagline),
          image: car.image,
          year: car.year,
          fuel: text(car.fuel),
          gearbox: text(car.gearbox),
          consumption: text(car.consumption),
          passengers: car.passengers,
          engine: car.engine,
          doors: car.doors,
          mileage: text(car.mileage),
          features: [for (final feature in car.features) text(feature)],
          dayRatesEur: car.dayRatesEur,
          insuranceEur: car.insuranceEur,
        );

  /// [brand]'s bubble and intro page.
  BrandIntro introOf(Brand brand) {
    final intro = brandIntros[brand]!;
    return _asIs
        ? intro
        : BrandIntro(
            name: text(intro.name),
            logo: intro.logo,
            image: intro.image,
            description: textOrNull(intro.description),
            comingSoon: intro.comingSoon,
          );
  }

  /// [brand]'s information page, or null for a brand without one. Places and
  /// hours are translated; the brand's name, phone, e-mail, Instagram and
  /// company are names. Legal pages get a translated title but keep their
  /// Romanian text.
  BrandInfo? infoOf(Brand brand) {
    final info = brandInfos[brand];
    if (info == null || _asIs) return info;
    return BrandInfo(
      name: info.name,
      website: info.website,
      lines: [
        for (final line in info.lines)
          (
            kind: line.kind,
            value: switch (line.kind) {
              BrandInfoKind.deliveryArea ||
              BrandInfoKind.address ||
              BrandInfoKind.hours => text(line.value),
              BrandInfoKind.phone ||
              BrandInfoKind.email ||
              BrandInfoKind.instagram ||
              BrandInfoKind.company => line.value,
            },
          ),
      ],
      documents: [
        for (final document in info.documents)
          LegalDocument(
            id: document.id,
            title: text(document.title),
            text: document.text,
          ),
      ],
    );
  }
}
