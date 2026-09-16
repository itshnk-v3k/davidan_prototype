// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'DaviDan Delivery';

  @override
  String priceLei(String amount) {
    return '$amount lei';
  }

  @override
  String get launcherTitle => 'Prototip DaviDan';

  @override
  String get launcherSubtitle =>
      'Alege partea sistemului pe care vrei s-o vezi.';

  @override
  String get launcherClient => 'Aplicația clientului';

  @override
  String get launcherClientHint => 'Meniu, coș, comandă și urmărire';

  @override
  String get launcherCourier => 'Aplicația curierului';

  @override
  String get launcherCourierHint => 'Comenzi de livrat și statusul livrării';

  @override
  String get launcherKds => 'Panoul magazinului';

  @override
  String get launcherKdsHint => 'Comenzi noi, cronometru și acceptare';

  @override
  String get resetDemoData => 'Resetează datele demo';

  @override
  String get resetDemoDataDone => 'Datele demo au fost resetate.';

  @override
  String get launcherFooter =>
      'Prototip pentru prezentare. Datele sunt fictive și se păstrează doar pe acest dispozitiv.';

  @override
  String get openLauncher => 'Înapoi la prototip';

  @override
  String get themeTitle => 'Tema aplicației';

  @override
  String get themeDark => 'Întunecată';

  @override
  String get themeLight => 'Luminoasă';

  @override
  String get themeSystem => 'Ca telefonul';

  @override
  String get languageTitle => 'Limba aplicației';

  @override
  String get languageSystem => 'Ca telefonul';

  @override
  String get navHome => 'Acasă';

  @override
  String get navOrders => 'Comenzi';

  @override
  String get navFavorites => 'Favorite';

  @override
  String get navProfile => 'Profil';

  @override
  String get locationTitle => 'Livrare sau ridicare';

  @override
  String get menuTitle => 'Meniu';

  @override
  String get cartTitle => 'Coșul meu';

  @override
  String get checkoutTitle => 'Finalizează comanda';

  @override
  String get profileTitle => 'Profil';

  @override
  String get courierOrdersTitle => 'Comenzi de livrat';

  @override
  String get kdsTitle => 'Panoul magazinului';

  @override
  String get back => 'Înapoi';

  @override
  String get backHome => 'Înapoi acasă';

  @override
  String get comingSoonTitle => 'În curând';

  @override
  String get inProgressTitle => 'În lucru';

  @override
  String get inProgressMessage =>
      'Pagina acestui brand se construiește într-o etapă următoare a prototipului.';

  @override
  String forYouTitle(String name) {
    return '$name, pentru tine';
  }

  @override
  String get forYouTitleSignedOut => 'Pentru tine';

  @override
  String get locationPrompt =>
      'Alege cum primești comenzile. Poți schimba oricând din bara de sus a ecranului Acasă.';

  @override
  String get confirmAddress => 'Livrează la această adresă';

  @override
  String get recentAddressesTitle => 'Adrese folosite recent';

  @override
  String get nearestToYou => 'Cel mai aproape de tine';

  @override
  String get nearestSuggestion =>
      'Ți-am selectat localul cel mai apropiat. Confirmă-l sau alege altul.';

  @override
  String get confirmShop => 'Confirmă localul';

  @override
  String get useCurrentLocation => 'Folosește locația mea curentă';

  @override
  String get useCurrentLocationHint =>
      'Doar pentru comanda următoare. Adresa salvată rămâne.';

  @override
  String get locating => 'Se caută locația…';

  @override
  String get deliverToCurrentLocation => 'Livrare la locația curentă';

  @override
  String currentLocationValue(String area) {
    return '$area · doar comanda următoare';
  }

  @override
  String get dropCurrentLocation => 'Renunță la locația curentă';

  @override
  String get typeAddressInstead => 'Scrie o adresă';

  @override
  String get outsideChisinau => 'În afara Chișinăului';

  @override
  String areaOf(String sector) {
    return 'Zona $sector';
  }

  @override
  String pinnedAddress(String area, String coordinates) {
    return 'Locația clientului · $area ($coordinates)';
  }

  @override
  String get locationFailureDenied => 'Nu ai permis accesul la locație.';

  @override
  String get locationFailureDeniedForever =>
      'Accesul la locație e blocat din setările telefonului.';

  @override
  String get locationFailureServiceOff => 'Localizarea telefonului e oprită.';

  @override
  String get locationFailureTimeout =>
      'Nu am primit semnal de localizare la timp.';

  @override
  String get locationFailureUnavailable =>
      'Locația nu e disponibilă pe acest dispozitiv.';

  @override
  String get mapPickerTitle => 'Alege locația pe hartă';

  @override
  String get mapPickerHint => 'Atinge harta sau alege zona unde livrăm.';

  @override
  String get schematicMap => 'Hartă schematică a Chișinăului';

  @override
  String get chosenPoint => 'Punctul ales';

  @override
  String distanceToShop(String distance, String shopName) {
    return '$distance până la $shopName';
  }

  @override
  String get deliverHere => 'Livrează aici';

  @override
  String get signInTitle => 'Intră în cont';

  @override
  String get signInPrompt =>
      'Scrie numărul de telefon. Îți trimitem un cod ca să-l confirmi.';

  @override
  String get phoneLabel => 'Număr de telefon';

  @override
  String get phoneHint => '69 123 456';

  @override
  String get phoneInvalid =>
      'Scrie un număr de mobil din 8 cifre, care începe cu 6 sau 7.';

  @override
  String get sendCode => 'Primește codul';

  @override
  String get signInLater => 'Mai târziu';

  @override
  String get demoSignInNote =>
      'Cont demonstrativ: nu se trimite niciun SMS și nimic nu e verificat. Datele rămân doar pe acest dispozitiv.';

  @override
  String get codeTitle => 'Codul din SMS';

  @override
  String codeSentTo(String phone) {
    return 'Scrie codul de 4 cifre trimis la $phone.';
  }

  @override
  String get codeLabel => 'Cod de 4 cifre';

  @override
  String get codeIncomplete => 'Scrie toate cele 4 cifre.';

  @override
  String get confirmCode => 'Confirmă codul';

  @override
  String get resendCode => 'Retrimite codul';

  @override
  String get codeResent => 'Cod retrimis (demo, fără SMS real).';

  @override
  String get demoCodeNote => 'Demo: orice cod din 4 cifre este acceptat.';

  @override
  String get detailsTitle => 'Câteva detalii';

  @override
  String get nameLabel => 'Numele tău';

  @override
  String get nameMissing => 'Scrie-ți numele.';

  @override
  String get sectorTitle => 'Sectorul în care locuiești';

  @override
  String get sectorMissing => 'Alege sectorul.';

  @override
  String get useMyLocationForShop => 'Găsește localul după locația mea';

  @override
  String locationFoundNearest(String distance, String shopName) {
    return 'Locația găsită: $shopName e la $distance.';
  }

  @override
  String findShopBySectorAfter(String reason) {
    return '$reason Găsim localul după sectorul ales.';
  }

  @override
  String get createAccount => 'Creează contul';

  @override
  String welcomeTitle(String name) {
    return 'Bun venit, $name!';
  }

  @override
  String get welcomeMessage =>
      'Contul tău e gata. Iată localul DaviDan cel mai apropiat de tine.';

  @override
  String get nearestShopTitle => 'Cel mai apropiat local';

  @override
  String matchedBySectorOf(String sector) {
    return 'După sectorul $sector';
  }

  @override
  String matchedByLocation(String distance) {
    return 'După locația ta · $distance';
  }

  @override
  String get chooseHowToReceive => 'Alege cum primești comenzile';

  @override
  String get sectorBotanica => 'Botanica';

  @override
  String get sectorBuiucani => 'Buiucani';

  @override
  String get sectorCentru => 'Centru';

  @override
  String get sectorCiocana => 'Ciocana';

  @override
  String get sectorRiscani => 'Rîșcani';

  @override
  String sectorOf(String sector) {
    return 'Sectorul $sector';
  }

  @override
  String get accountLockedTitle => 'Contul tău';

  @override
  String get accountLockedMessage =>
      'Intră în cont ca să-ți vezi comenzile și localul cel mai apropiat.';

  @override
  String get signOut => 'Ieși din cont';

  @override
  String get myOrdersTitle => 'Comenzile mele';

  @override
  String get ordersEmptyTitle => 'Nicio comandă încă';

  @override
  String get ordersEmptyMessage =>
      'Comenzile tale apar aici, cu statusul lor la zi.';

  @override
  String get ordersActiveTitle => 'În curs';

  @override
  String get ordersPastTitle => 'Finalizate';

  @override
  String get allBrands => 'Toate';

  @override
  String get demoProfileNote =>
      'Cont demonstrativ, fără verificare reală prin SMS.';

  @override
  String get deliverTo => 'Livrare la';

  @override
  String get chooseAddress => 'Alege adresa sau localul';

  @override
  String get categoriesTitle => 'Categorii';

  @override
  String get popularTitle => 'Produse DaviDan';

  @override
  String get seeAll => 'Vezi mai mult';

  @override
  String seeAllProducts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vezi toate cele $count de produse',
      few: 'Vezi toate cele $count produse',
      one: 'Vezi $count produs',
    );
    return '$_temp0';
  }

  @override
  String get categoryEmpty => 'Momentan nu sunt produse în această categorie.';

  @override
  String get descriptionTitle => 'Descriere';

  @override
  String get productNotFound => 'Produsul nu a fost găsit.';

  @override
  String get increaseQuantity => 'Mărește cantitatea';

  @override
  String get decreaseQuantity => 'Micșorează cantitatea';

  @override
  String inCart(int count) {
    return 'În coș: $count';
  }

  @override
  String addToCartTotal(String total) {
    return 'Adaugă în coș · $total';
  }

  @override
  String addedToCart(int quantity, String productName) {
    return 'Adăugat în coș: $quantity × $productName';
  }

  @override
  String addToCart(String productName) {
    return 'Adaugă $productName în coș';
  }

  @override
  String removeOneFromCart(String productName) {
    return 'Scoate o bucată de $productName din coș';
  }

  @override
  String removeFromCart(String productName) {
    return 'Scoate $productName din coș';
  }

  @override
  String itemsInCart(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de produse în coș',
      few: '$count produse în coș',
      one: '$count produs în coș',
    );
    return '$_temp0';
  }

  @override
  String openCart(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Coșul meu, $count de produse în coș',
      few: 'Coșul meu, $count produse în coș',
      one: 'Coșul meu, $count produs în coș',
      zero: 'Coșul meu',
    );
    return '$_temp0';
  }

  @override
  String get cartEmptyTitle => 'Coșul tău e gol';

  @override
  String get cartEmptyMessage =>
      'Adaugă produse din meniu, apoi revino aici ca să finalizezi comanda.';

  @override
  String get browseMenu => 'Vezi meniul';

  @override
  String get continueOrder => 'Continuă comanda';

  @override
  String get total => 'Total';

  @override
  String unitPrice(String price) {
    return '$price / buc.';
  }

  @override
  String lineItem(int quantity, String productName) {
    return '$quantity × $productName';
  }

  @override
  String get fulfilmentTitle => 'Cum primești comanda';

  @override
  String get delivery => 'Livrare';

  @override
  String get pickup => 'Ridicare din local';

  @override
  String get deliveryAddress => 'Adresa de livrare';

  @override
  String get deliveryAddressHint => 'Strada, numărul, blocul, apartamentul';

  @override
  String get deliveryAddressMissing => 'Scrie adresa unde livrăm comanda.';

  @override
  String get deliveryTimeTitle => 'Ora livrării';

  @override
  String get pickupTimeTitle => 'Ora ridicării';

  @override
  String get asSoonAsPossible => 'Cât mai curând';

  @override
  String get paymentTitle => 'Achitare';

  @override
  String get paymentOnDelivery => 'Plătești curierului, la primirea comenzii.';

  @override
  String get paymentOnPickup => 'Plătești în local, la ridicarea comenzii.';

  @override
  String get orderSummaryTitle => 'Comanda ta';

  @override
  String get placeOrder => 'Plasează comanda';

  @override
  String get paymentCash => 'Numerar';

  @override
  String get paymentCard => 'Card prin POS';

  @override
  String get orderPlacedTitle => 'Comanda a fost plasată';

  @override
  String get orderNotFound => 'Comanda nu a fost găsită.';

  @override
  String get pickupFrom => 'Ridicare din';

  @override
  String get orderTime => 'Ora';

  @override
  String get trackingComingSoon =>
      'Urmărirea comenzii pas cu pas va apărea aici în etapele următoare.';

  @override
  String orderNumber(String id) {
    return 'Comanda nr. $id';
  }

  @override
  String get orderStatusPlaced => 'Plasată';

  @override
  String get orderStatusAccepted => 'Acceptată';

  @override
  String get orderStatusPreparing => 'Se pregătește';

  @override
  String get orderStatusReady => 'Gata';

  @override
  String get orderStatusOnTheWay => 'În livrare';

  @override
  String get orderStatusCompleted => 'Finalizată';

  @override
  String get advanceToAccepted => 'Acceptă';

  @override
  String get advanceToPreparing => 'Începe prepararea';

  @override
  String get advanceToReady => 'Marchează gata';

  @override
  String get advanceToOnTheWay => 'Am preluat comanda';

  @override
  String get advanceToCompleted => 'Predată clientului';

  @override
  String scheduledAt(String time) {
    return 'La $time';
  }

  @override
  String get kdsIncoming => 'Noi';

  @override
  String get kdsInKitchen => 'În lucru';

  @override
  String get kdsReady => 'Gata';

  @override
  String get kdsColumnEmpty => 'Nicio comandă';

  @override
  String get kdsEmptyTitle => 'Nicio comandă deocamdată';

  @override
  String get kdsEmptyMessage =>
      'Comenzile plasate din aplicația clientului apar aici.';

  @override
  String get waitingForCourier => 'Așteaptă curierul';

  @override
  String get kdsNewTag => 'NOUĂ';

  @override
  String newOrderArrived(String orderId) {
    return 'Comandă nouă: $orderId';
  }

  @override
  String pickupAt(String shopName) {
    return 'Ridicare · $shopName';
  }

  @override
  String timeSincePlaced(String elapsed) {
    return 'Timp de la plasare: $elapsed';
  }

  @override
  String get favoritesTitle => 'Produse favorite';

  @override
  String get favoritesEmptyTitle => 'Niciun produs favorit';

  @override
  String get favoritesEmptyMessage =>
      'Apasă inima de pe un produs ca să-l găsești repede aici.';

  @override
  String addToFavorites(String productName) {
    return 'Adaugă $productName la favorite';
  }

  @override
  String removeFromFavorites(String productName) {
    return 'Scoate $productName din favorite';
  }

  @override
  String courierArrivesIn(int minutes) {
    return 'Curierul ajunge în aproximativ $minutes min';
  }

  @override
  String get courierArrived => 'Curierul a ajuns la adresă';

  @override
  String get courierOnline => 'Online';

  @override
  String get courierOffline => 'Offline';

  @override
  String get courierOnlineHint => 'Primești comenzi noi';

  @override
  String get courierOfflineHint => 'Nu primești comenzi noi';

  @override
  String get courierOnTheWaySection => 'Pe drum spre client';

  @override
  String get courierReadySection => 'De preluat din local';

  @override
  String get courierOfflineTitle => 'Ești offline';

  @override
  String get courierOfflineMessage =>
      'Intră online ca să vezi comenzile de preluat din local.';

  @override
  String get courierEmptyTitle => 'Nicio livrare deocamdată';

  @override
  String get courierEmptyMessage =>
      'Comenzile cu livrare apar aici când localul le marchează gata.';

  @override
  String get toCollect => 'De încasat';

  @override
  String get itemsTitle => 'Produse';

  @override
  String get courierWaitingForStore => 'Localul încă pregătește comanda.';

  @override
  String get deliveryCompleted => 'Livrare finalizată.';

  @override
  String get backToDeliveries => 'Înapoi la comenzi';

  @override
  String get deliveryNotFound => 'Livrarea nu a fost găsită.';

  @override
  String deliveryTitle(String orderId) {
    return 'Livrare $orderId';
  }

  @override
  String amountToCollect(String total, String paymentMethod) {
    return '$total · $paymentMethod';
  }
}
