import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ro'),
    Locale('ru'),
  ];

  /// App name; the browser tab title.
  ///
  /// In ro, this message translates to:
  /// **'DaviDan'**
  String get appTitle;

  /// A price in Moldovan lei. amount is already formatted, e.g. "19" or "19,50".
  ///
  /// In ro, this message translates to:
  /// **'{amount} lei'**
  String priceLei(String amount);

  /// No description provided for @launcherTitle.
  ///
  /// In ro, this message translates to:
  /// **'Prototip DaviDan'**
  String get launcherTitle;

  /// No description provided for @launcherSubtitle.
  ///
  /// In ro, this message translates to:
  /// **'Alege partea sistemului pe care vrei s-o vezi.'**
  String get launcherSubtitle;

  /// No description provided for @launcherClient.
  ///
  /// In ro, this message translates to:
  /// **'Aplicația clientului'**
  String get launcherClient;

  /// No description provided for @launcherClientHint.
  ///
  /// In ro, this message translates to:
  /// **'Meniu, coș, comandă și urmărire'**
  String get launcherClientHint;

  /// No description provided for @launcherCourier.
  ///
  /// In ro, this message translates to:
  /// **'Aplicația curierului'**
  String get launcherCourier;

  /// No description provided for @launcherCourierHint.
  ///
  /// In ro, this message translates to:
  /// **'Comenzi de livrat și statusul livrării'**
  String get launcherCourierHint;

  /// No description provided for @launcherKds.
  ///
  /// In ro, this message translates to:
  /// **'Panoul magazinului'**
  String get launcherKds;

  /// No description provided for @launcherKdsHint.
  ///
  /// In ro, this message translates to:
  /// **'Comenzi noi, cronometru și acceptare'**
  String get launcherKdsHint;

  /// No description provided for @resetDemoData.
  ///
  /// In ro, this message translates to:
  /// **'Resetează datele demo'**
  String get resetDemoData;

  /// No description provided for @resetDemoDataDone.
  ///
  /// In ro, this message translates to:
  /// **'Datele demo au fost resetate.'**
  String get resetDemoDataDone;

  /// No description provided for @launcherFooter.
  ///
  /// In ro, this message translates to:
  /// **'Prototip pentru prezentare. Datele sunt fictive și se păstrează doar pe acest dispozitiv.'**
  String get launcherFooter;

  /// No description provided for @openLauncher.
  ///
  /// In ro, this message translates to:
  /// **'Înapoi la prototip'**
  String get openLauncher;

  /// No description provided for @themeTitle.
  ///
  /// In ro, this message translates to:
  /// **'Tema aplicației'**
  String get themeTitle;

  /// No description provided for @themeDark.
  ///
  /// In ro, this message translates to:
  /// **'Întunecată'**
  String get themeDark;

  /// No description provided for @themeLight.
  ///
  /// In ro, this message translates to:
  /// **'Luminoasă'**
  String get themeLight;

  /// Theme follows the phone setting.
  ///
  /// In ro, this message translates to:
  /// **'Ca telefonul'**
  String get themeSystem;

  /// No description provided for @languageTitle.
  ///
  /// In ro, this message translates to:
  /// **'Limba aplicației'**
  String get languageTitle;

  /// Language follows the phone's language (Romanian when the phone uses neither Romanian nor Russian).
  ///
  /// In ro, this message translates to:
  /// **'Ca telefonul'**
  String get languageSystem;

  /// No description provided for @navHome.
  ///
  /// In ro, this message translates to:
  /// **'Acasă'**
  String get navHome;

  /// No description provided for @navOrders.
  ///
  /// In ro, this message translates to:
  /// **'Comenzi'**
  String get navOrders;

  /// No description provided for @navFavorites.
  ///
  /// In ro, this message translates to:
  /// **'Favorite'**
  String get navFavorites;

  /// No description provided for @navProfile.
  ///
  /// In ro, this message translates to:
  /// **'Profil'**
  String get navProfile;

  /// No description provided for @locationTitle.
  ///
  /// In ro, this message translates to:
  /// **'Livrare sau ridicare'**
  String get locationTitle;

  /// No description provided for @menuTitle.
  ///
  /// In ro, this message translates to:
  /// **'Meniu'**
  String get menuTitle;

  /// Title of a brand's cart. brand is the brand's bubble name.
  ///
  /// In ro, this message translates to:
  /// **'Coșul · {brand}'**
  String brandCartTitle(String brand);

  /// No description provided for @checkoutTitle.
  ///
  /// In ro, this message translates to:
  /// **'Finalizează comanda'**
  String get checkoutTitle;

  /// No description provided for @profileTitle.
  ///
  /// In ro, this message translates to:
  /// **'Profil'**
  String get profileTitle;

  /// No description provided for @courierOrdersTitle.
  ///
  /// In ro, this message translates to:
  /// **'Comenzi de livrat'**
  String get courierOrdersTitle;

  /// No description provided for @kdsTitle.
  ///
  /// In ro, this message translates to:
  /// **'Panoul magazinului'**
  String get kdsTitle;

  /// No description provided for @back.
  ///
  /// In ro, this message translates to:
  /// **'Înapoi'**
  String get back;

  /// No description provided for @backHome.
  ///
  /// In ro, this message translates to:
  /// **'Înapoi acasă'**
  String get backHome;

  /// Title of a brand's page when the brand has no menu in the app, e.g. the restaurant.
  ///
  /// In ro, this message translates to:
  /// **'În curând'**
  String get comingSoonTitle;

  /// Screen reader label of a brand's hub bubble when the brand isn't open in the app yet.
  ///
  /// In ro, this message translates to:
  /// **'{name}, în curând'**
  String brandComingSoonLabel(String name);

  /// Heading of the hub's row of products from every brand, with the signed-in customer's first name.
  ///
  /// In ro, this message translates to:
  /// **'{name}, pentru tine'**
  String forYouTitle(String name);

  /// forYouTitle when no one is signed in.
  ///
  /// In ro, this message translates to:
  /// **'Pentru tine'**
  String get forYouTitleSignedOut;

  /// Toast after adding a product from a row that mixes brands (hub, favourites): which brand's cart it went to. brand is the brand's bubble name.
  ///
  /// In ro, this message translates to:
  /// **'Adăugat în coș · {brand}'**
  String addedToBrandCart(String brand);

  /// No description provided for @locationPrompt.
  ///
  /// In ro, this message translates to:
  /// **'Alege cum primești comenzile. Poți schimba oricând din bara de sus a ecranului Acasă.'**
  String get locationPrompt;

  /// No description provided for @confirmAddress.
  ///
  /// In ro, this message translates to:
  /// **'Livrează la această adresă'**
  String get confirmAddress;

  /// No description provided for @recentAddressesTitle.
  ///
  /// In ro, this message translates to:
  /// **'Adrese folosite recent'**
  String get recentAddressesTitle;

  /// No description provided for @nearestToYou.
  ///
  /// In ro, this message translates to:
  /// **'Cel mai aproape de tine'**
  String get nearestToYou;

  /// No description provided for @nearestSuggestion.
  ///
  /// In ro, this message translates to:
  /// **'Ți-am selectat localul cel mai apropiat. Confirmă-l sau alege altul.'**
  String get nearestSuggestion;

  /// No description provided for @confirmShop.
  ///
  /// In ro, this message translates to:
  /// **'Confirmă localul'**
  String get confirmShop;

  /// No description provided for @useCurrentLocation.
  ///
  /// In ro, this message translates to:
  /// **'Folosește locația mea curentă'**
  String get useCurrentLocation;

  /// No description provided for @useCurrentLocationHint.
  ///
  /// In ro, this message translates to:
  /// **'Doar pentru comanda următoare. Adresa salvată rămâne.'**
  String get useCurrentLocationHint;

  /// No description provided for @locating.
  ///
  /// In ro, this message translates to:
  /// **'Se caută locația…'**
  String get locating;

  /// No description provided for @deliverToCurrentLocation.
  ///
  /// In ro, this message translates to:
  /// **'Livrare la locația curentă'**
  String get deliverToCurrentLocation;

  /// Home header value when the next order goes to the phone's location. area is areaOf(...) or outsideChisinau.
  ///
  /// In ro, this message translates to:
  /// **'{area} · doar comanda următoare'**
  String currentLocationValue(String area);

  /// No description provided for @dropCurrentLocation.
  ///
  /// In ro, this message translates to:
  /// **'Renunță la locația curentă'**
  String get dropCurrentLocation;

  /// No description provided for @typeAddressInstead.
  ///
  /// In ro, this message translates to:
  /// **'Scrie o adresă'**
  String get typeAddressInstead;

  /// Area name for a point outside the Chișinău sectors.
  ///
  /// In ro, this message translates to:
  /// **'În afara Chișinăului'**
  String get outsideChisinau;

  /// Area name of a point inside a Chișinău sector. sector is a sector name (sectorBotanica…).
  ///
  /// In ro, this message translates to:
  /// **'Zona {sector}'**
  String areaOf(String sector);

  /// Address shown for a delivery to the customer's current location.
  ///
  /// In ro, this message translates to:
  /// **'Locația clientului · {area} ({coordinates})'**
  String pinnedAddress(String area, String coordinates);

  /// The customer's own order delivered to their current location, without coordinates.
  ///
  /// In ro, this message translates to:
  /// **'Locația ta · {area}'**
  String pinnedAddressCustomer(String area);

  /// No description provided for @locationFailureDenied.
  ///
  /// In ro, this message translates to:
  /// **'Nu ai permis accesul la locație.'**
  String get locationFailureDenied;

  /// No description provided for @locationFailureDeniedForever.
  ///
  /// In ro, this message translates to:
  /// **'Accesul la locație e blocat din setările telefonului.'**
  String get locationFailureDeniedForever;

  /// No description provided for @locationFailureServiceOff.
  ///
  /// In ro, this message translates to:
  /// **'Localizarea telefonului e oprită.'**
  String get locationFailureServiceOff;

  /// No description provided for @locationFailureTimeout.
  ///
  /// In ro, this message translates to:
  /// **'Nu am primit semnal de localizare la timp.'**
  String get locationFailureTimeout;

  /// No description provided for @locationFailureUnavailable.
  ///
  /// In ro, this message translates to:
  /// **'Locația nu e disponibilă pe acest dispozitiv.'**
  String get locationFailureUnavailable;

  /// No description provided for @mapPickerTitle.
  ///
  /// In ro, this message translates to:
  /// **'Alege locația pe hartă'**
  String get mapPickerTitle;

  /// No description provided for @mapPickerHint.
  ///
  /// In ro, this message translates to:
  /// **'Atinge harta sau alege zona unde livrăm.'**
  String get mapPickerHint;

  /// No description provided for @schematicMap.
  ///
  /// In ro, this message translates to:
  /// **'Hartă schematică a Chișinăului'**
  String get schematicMap;

  /// No description provided for @chosenPoint.
  ///
  /// In ro, this message translates to:
  /// **'Punctul ales'**
  String get chosenPoint;

  /// Distance from the chosen map point to the nearest shop.
  ///
  /// In ro, this message translates to:
  /// **'{distance} până la {shopName}'**
  String distanceToShop(String distance, String shopName);

  /// No description provided for @deliverHere.
  ///
  /// In ro, this message translates to:
  /// **'Livrează aici'**
  String get deliverHere;

  /// No description provided for @signInTitle.
  ///
  /// In ro, this message translates to:
  /// **'Intră în cont'**
  String get signInTitle;

  /// No description provided for @signInPrompt.
  ///
  /// In ro, this message translates to:
  /// **'Scrie numărul de telefon. Îți trimitem un cod ca să-l confirmi.'**
  String get signInPrompt;

  /// No description provided for @phoneLabel.
  ///
  /// In ro, this message translates to:
  /// **'Număr de telefon'**
  String get phoneLabel;

  /// Example Moldovan mobile number in the phone field.
  ///
  /// In ro, this message translates to:
  /// **'69 123 456'**
  String get phoneHint;

  /// No description provided for @phoneInvalid.
  ///
  /// In ro, this message translates to:
  /// **'Scrie un număr de mobil din 8 cifre, care începe cu 6 sau 7.'**
  String get phoneInvalid;

  /// No description provided for @sendCode.
  ///
  /// In ro, this message translates to:
  /// **'Primește codul'**
  String get sendCode;

  /// No description provided for @signInLater.
  ///
  /// In ro, this message translates to:
  /// **'Mai târziu'**
  String get signInLater;

  /// No description provided for @demoSignInNote.
  ///
  /// In ro, this message translates to:
  /// **'Cont demonstrativ: nu se trimite niciun SMS și nimic nu e verificat. Datele rămân doar pe acest dispozitiv.'**
  String get demoSignInNote;

  /// No description provided for @codeTitle.
  ///
  /// In ro, this message translates to:
  /// **'Codul din SMS'**
  String get codeTitle;

  /// Sign-in code prompt.
  ///
  /// In ro, this message translates to:
  /// **'Scrie codul de 4 cifre trimis la {phone}.'**
  String codeSentTo(String phone);

  /// No description provided for @codeLabel.
  ///
  /// In ro, this message translates to:
  /// **'Cod de 4 cifre'**
  String get codeLabel;

  /// No description provided for @codeIncomplete.
  ///
  /// In ro, this message translates to:
  /// **'Scrie toate cele 4 cifre.'**
  String get codeIncomplete;

  /// No description provided for @confirmCode.
  ///
  /// In ro, this message translates to:
  /// **'Confirmă codul'**
  String get confirmCode;

  /// No description provided for @resendCode.
  ///
  /// In ro, this message translates to:
  /// **'Retrimite codul'**
  String get resendCode;

  /// The resend button while it waits.
  ///
  /// In ro, this message translates to:
  /// **'Retrimite codul în {seconds} s'**
  String resendCodeIn(int seconds);

  /// No description provided for @codeResent.
  ///
  /// In ro, this message translates to:
  /// **'Cod retrimis (demo, fără SMS real).'**
  String get codeResent;

  /// No description provided for @demoCodeNote.
  ///
  /// In ro, this message translates to:
  /// **'Demo: orice cod din 4 cifre este acceptat.'**
  String get demoCodeNote;

  /// No description provided for @detailsTitle.
  ///
  /// In ro, this message translates to:
  /// **'Câteva detalii'**
  String get detailsTitle;

  /// No description provided for @nameLabel.
  ///
  /// In ro, this message translates to:
  /// **'Numele tău'**
  String get nameLabel;

  /// No description provided for @nameMissing.
  ///
  /// In ro, this message translates to:
  /// **'Scrie-ți numele.'**
  String get nameMissing;

  /// No description provided for @sectorTitle.
  ///
  /// In ro, this message translates to:
  /// **'Sectorul în care locuiești'**
  String get sectorTitle;

  /// No description provided for @sectorMissing.
  ///
  /// In ro, this message translates to:
  /// **'Alege sectorul.'**
  String get sectorMissing;

  /// No description provided for @useMyLocationForShop.
  ///
  /// In ro, this message translates to:
  /// **'Găsește localul după locația mea'**
  String get useMyLocationForShop;

  /// Sign-in: the nearest shop was found from the phone's location.
  ///
  /// In ro, this message translates to:
  /// **'Locația găsită: {shopName} e la {distance}.'**
  String locationFoundNearest(String distance, String shopName);

  /// Sign-in: the phone's location failed. reason is one of the locationFailure… messages.
  ///
  /// In ro, this message translates to:
  /// **'{reason} Găsim localul după sectorul ales.'**
  String findShopBySectorAfter(String reason);

  /// No description provided for @createAccount.
  ///
  /// In ro, this message translates to:
  /// **'Creează contul'**
  String get createAccount;

  /// Title after creating the demo account.
  ///
  /// In ro, this message translates to:
  /// **'Bun venit, {name}!'**
  String welcomeTitle(String name);

  /// No description provided for @welcomeMessage.
  ///
  /// In ro, this message translates to:
  /// **'Contul tău e gata. Iată localul DaviDan cel mai apropiat de tine.'**
  String get welcomeMessage;

  /// No description provided for @nearestShopTitle.
  ///
  /// In ro, this message translates to:
  /// **'Cel mai apropiat local'**
  String get nearestShopTitle;

  /// How the nearest shop was chosen. sector is a sector name.
  ///
  /// In ro, this message translates to:
  /// **'După sectorul {sector}'**
  String matchedBySectorOf(String sector);

  /// How the nearest shop was chosen.
  ///
  /// In ro, this message translates to:
  /// **'După locația ta · {distance}'**
  String matchedByLocation(String distance);

  /// No description provided for @chooseHowToReceive.
  ///
  /// In ro, this message translates to:
  /// **'Alege cum primești comenzile'**
  String get chooseHowToReceive;

  /// Chișinău sector name.
  ///
  /// In ro, this message translates to:
  /// **'Botanica'**
  String get sectorBotanica;

  /// Chișinău sector name.
  ///
  /// In ro, this message translates to:
  /// **'Buiucani'**
  String get sectorBuiucani;

  /// Chișinău sector name.
  ///
  /// In ro, this message translates to:
  /// **'Centru'**
  String get sectorCentru;

  /// Chișinău sector name.
  ///
  /// In ro, this message translates to:
  /// **'Ciocana'**
  String get sectorCiocana;

  /// Chișinău sector name.
  ///
  /// In ro, this message translates to:
  /// **'Rîșcani'**
  String get sectorRiscani;

  /// A sector with its name, e.g. on the profile.
  ///
  /// In ro, this message translates to:
  /// **'Sectorul {sector}'**
  String sectorOf(String sector);

  /// No description provided for @accountLockedTitle.
  ///
  /// In ro, this message translates to:
  /// **'Contul tău'**
  String get accountLockedTitle;

  /// No description provided for @accountLockedMessage.
  ///
  /// In ro, this message translates to:
  /// **'Intră în cont ca să-ți vezi comenzile și localul cel mai apropiat.'**
  String get accountLockedMessage;

  /// No description provided for @signOut.
  ///
  /// In ro, this message translates to:
  /// **'Ieși din cont'**
  String get signOut;

  /// Title of the dialog confirming sign-out.
  ///
  /// In ro, this message translates to:
  /// **'Ieși din cont?'**
  String get signOutConfirmTitle;

  /// Message of the dialog confirming sign-out: what stays.
  ///
  /// In ro, this message translates to:
  /// **'Coșurile, comenzile și favoritele rămân pe acest dispozitiv.'**
  String get signOutConfirmMessage;

  /// Profil section with links to the brands' information pages.
  ///
  /// In ro, this message translates to:
  /// **'Contacte și informații'**
  String get profileBrandsTitle;

  /// Hint under a brand's link in Profil.
  ///
  /// In ro, this message translates to:
  /// **'Contacte și documente'**
  String get profileBrandInfoHint;

  /// Profil section holding the demo reset.
  ///
  /// In ro, this message translates to:
  /// **'Demo'**
  String get profileDemoTitle;

  /// No description provided for @ordersEmptyTitle.
  ///
  /// In ro, this message translates to:
  /// **'Nicio comandă încă'**
  String get ordersEmptyTitle;

  /// No description provided for @ordersEmptyMessage.
  ///
  /// In ro, this message translates to:
  /// **'Comenzile tale apar aici, cu statusul lor la zi.'**
  String get ordersEmptyMessage;

  /// Comenzi tab section: orders not yet completed.
  ///
  /// In ro, this message translates to:
  /// **'În curs'**
  String get ordersActiveTitle;

  /// Comenzi tab section: completed orders.
  ///
  /// In ro, this message translates to:
  /// **'Finalizate'**
  String get ordersPastTitle;

  /// A group of cars on the Rent Car fleet's filter chips.
  ///
  /// In ro, this message translates to:
  /// **'{carClass, select, economy{Economice} family{Familie} suv{SUV} premium{Premium} other{Altele}}'**
  String rentalCarClass(String carClass);

  /// Filter chip showing orders from every brand.
  ///
  /// In ro, this message translates to:
  /// **'Toate'**
  String get allBrands;

  /// Screen reader label of the info button on a brand's home.
  ///
  /// In ro, this message translates to:
  /// **'Informații despre {brandName}'**
  String openBrandInfo(String brandName);

  /// No description provided for @brandContactsTitle.
  ///
  /// In ro, this message translates to:
  /// **'Contacte'**
  String get brandContactsTitle;

  /// No description provided for @brandInfoDeliveryArea.
  ///
  /// In ro, this message translates to:
  /// **'Zona de livrare'**
  String get brandInfoDeliveryArea;

  /// No description provided for @brandInfoAddress.
  ///
  /// In ro, this message translates to:
  /// **'Adresa'**
  String get brandInfoAddress;

  /// Opening hours on a brand's information page, e.g. DaviDan Rent Car's "Lucrăm 24/24".
  ///
  /// In ro, this message translates to:
  /// **'Program'**
  String get brandInfoHours;

  /// No description provided for @brandInfoPhone.
  ///
  /// In ro, this message translates to:
  /// **'Telefon'**
  String get brandInfoPhone;

  /// No description provided for @brandInfoEmail.
  ///
  /// In ro, this message translates to:
  /// **'E-mail'**
  String get brandInfoEmail;

  /// No description provided for @brandInfoInstagram.
  ///
  /// In ro, this message translates to:
  /// **'Instagram'**
  String get brandInfoInstagram;

  /// No description provided for @brandInfoCompany.
  ///
  /// In ro, this message translates to:
  /// **'Companie'**
  String get brandInfoCompany;

  /// No description provided for @legalDocumentsTitle.
  ///
  /// In ro, this message translates to:
  /// **'Informații legale'**
  String get legalDocumentsTitle;

  /// Under a legal page's title on a brand's information page.
  ///
  /// In ro, this message translates to:
  /// **'Textul de pe {website}'**
  String legalDocumentHint(String website);

  /// A price in euros, as DaviDan Rent Car prices its cars. amount is already formatted, e.g. "19".
  ///
  /// In ro, this message translates to:
  /// **'{amount} €'**
  String priceEuro(String amount);

  /// Note above the car list: the per-day price depends on the rental length, and every booking adds the location fee and the car's insurance amount.
  ///
  /// In ro, this message translates to:
  /// **'Prețul pe zi scade cu cât închiriezi mai multe zile. La fiecare rezervare se adaugă taxa de locație de {fee} și suma de asigurare a mașinii.'**
  String rentalFleetHint(String fee);

  /// A car's lowest price per day (for 21 days or more), as davidanrentcar.md's slider words it ("De la 19 € / ziua").
  ///
  /// In ro, this message translates to:
  /// **'de la {price} / zi'**
  String rentalPriceFrom(String price);

  /// A price per day.
  ///
  /// In ro, this message translates to:
  /// **'{price} / zi'**
  String rentalPricePerDay(String price);

  /// A car's price per day for a band of rental lengths. tier is rentalTierRange or rentalTierFrom.
  ///
  /// In ro, this message translates to:
  /// **'{price} / zi pentru {tier}'**
  String rentalPriceForTier(String price, String tier);

  /// A band of rental lengths, e.g. "1–3 zile", "11–20 de zile".
  ///
  /// In ro, this message translates to:
  /// **'{from}–{to, plural, one{{to} zi} few{{to} zile} other{{to} de zile}}'**
  String rentalTierRange(int from, int to);

  /// The last band of rental lengths, with no end: "21 de zile sau mai mult".
  ///
  /// In ro, this message translates to:
  /// **'{from, plural, one{{from} zi} few{{from} zile} other{{from} de zile}} sau mai mult'**
  String rentalTierFrom(int from);

  /// How many people a car seats, on its card.
  ///
  /// In ro, this message translates to:
  /// **'{count, plural, one{{count} loc} few{{count} locuri} other{{count} de locuri}}'**
  String rentalSeats(int count);

  /// Car spec label, as on davidanrentcar.md.
  ///
  /// In ro, this message translates to:
  /// **'Anul mașinii'**
  String get rentalSpecYear;

  /// Car spec label, as on davidanrentcar.md.
  ///
  /// In ro, this message translates to:
  /// **'Combustibil'**
  String get rentalSpecFuel;

  /// Car spec label, as on davidanrentcar.md.
  ///
  /// In ro, this message translates to:
  /// **'Cutie de viteze'**
  String get rentalSpecGearbox;

  /// Car spec label, as on davidanrentcar.md.
  ///
  /// In ro, this message translates to:
  /// **'Consumul de combustibil'**
  String get rentalSpecConsumption;

  /// Car spec label, as on davidanrentcar.md.
  ///
  /// In ro, this message translates to:
  /// **'Max pasageri'**
  String get rentalSpecPassengers;

  /// Car spec label, as on davidanrentcar.md.
  ///
  /// In ro, this message translates to:
  /// **'Capacitatea motorului'**
  String get rentalSpecEngine;

  /// Car spec label, as on davidanrentcar.md.
  ///
  /// In ro, this message translates to:
  /// **'Uși'**
  String get rentalSpecDoors;

  /// Car spec label, as on davidanrentcar.md.
  ///
  /// In ro, this message translates to:
  /// **'Kilometraj'**
  String get rentalSpecMileage;

  /// Heading of a car's equipment list; davidanrentcar.md's descriptions call it "Dotări".
  ///
  /// In ro, this message translates to:
  /// **'Dotări'**
  String get rentalFeaturesTitle;

  /// Heading of a car's price table; davidanrentcar.md's is "Tabel de Prețuri pe Zile".
  ///
  /// In ro, this message translates to:
  /// **'Prețuri pe zile'**
  String get rentalPricesTitle;

  /// Fee added to every rental, labelled as in davidanrentcar.md's cart.
  ///
  /// In ro, this message translates to:
  /// **'Taxa de locație'**
  String get rentalLocationFee;

  /// The car's insurance amount added to every rental, labelled as in davidanrentcar.md's cart.
  ///
  /// In ro, this message translates to:
  /// **'Suma de asigurare'**
  String get rentalInsurance;

  /// A rental's price: days, extras and the location fee, without the insurance amount.
  ///
  /// In ro, this message translates to:
  /// **'Total chirie'**
  String get rentalPriceTotal;

  /// Under a rental request's total: the car's insurance amount, shown apart from the price.
  ///
  /// In ro, this message translates to:
  /// **'+ {amount} suma de asigurare'**
  String rentalInsuranceExtra(String amount);

  /// A rental's price plus the insurance amount, as davidanrentcar.md's cart adds it up.
  ///
  /// In ro, this message translates to:
  /// **'Total cu suma de asigurare'**
  String get rentalTotalWithInsurance;

  /// Under a car's price table.
  ///
  /// In ro, this message translates to:
  /// **'Taxa de locație și suma de asigurare se adaugă o singură dată la fiecare rezervare, oricâte zile ar avea.'**
  String get rentalFeesNote;

  /// Heading of what the driver must show; davidanrentcar.md's terms call it "Acte Necesare pentru Închiriere".
  ///
  /// In ro, this message translates to:
  /// **'Acte necesare'**
  String get rentalDocumentsTitle;

  /// Button on a car's page that opens the request form, where the dates are picked.
  ///
  /// In ro, this message translates to:
  /// **'Alege datele'**
  String get rentalRequestAction;

  /// Title of the request form; davidanrentcar.md's tab name.
  ///
  /// In ro, this message translates to:
  /// **'Cerere de rezervare'**
  String get rentalRequestTitle;

  /// Where and when the car is picked up.
  ///
  /// In ro, this message translates to:
  /// **'Ridicare'**
  String get rentalPickupTitle;

  /// Where and when the car is returned.
  ///
  /// In ro, this message translates to:
  /// **'Predare'**
  String get rentalReturnTitle;

  /// Pickup or return place offered by davidanrentcar.md.
  ///
  /// In ro, this message translates to:
  /// **'Aeroport Chișinău'**
  String get rentalLocationAirport;

  /// Pickup or return place offered by davidanrentcar.md.
  ///
  /// In ro, this message translates to:
  /// **'Chișinău'**
  String get rentalLocationChisinau;

  /// Date field of the request form.
  ///
  /// In ro, this message translates to:
  /// **'Data'**
  String get rentalDateLabel;

  /// Time field of the request form.
  ///
  /// In ro, this message translates to:
  /// **'Ora'**
  String get rentalTimeLabel;

  /// No description provided for @rentalPickupPassed.
  ///
  /// In ro, this message translates to:
  /// **'Ora ridicării a trecut deja. Alege una mai târzie.'**
  String get rentalPickupPassed;

  /// No description provided for @rentalReturnNotAfterPickup.
  ///
  /// In ro, this message translates to:
  /// **'Predarea trebuie să fie după ridicare.'**
  String get rentalReturnNotAfterPickup;

  /// davidanrentcar.md's "Serviciu suplimentar".
  ///
  /// In ro, this message translates to:
  /// **'Servicii suplimentare'**
  String get rentalExtrasTitle;

  /// Extra service, as named on davidanrentcar.md.
  ///
  /// In ro, this message translates to:
  /// **'Scaun pentru copii'**
  String get rentalExtraChildSeat;

  /// Extra service, as named on davidanrentcar.md.
  ///
  /// In ro, this message translates to:
  /// **'Kilometri nelimitați'**
  String get rentalExtraUnlimitedKm;

  /// Price of an extra charged once per rental; davidanrentcar.md writes "10,00 € / Total".
  ///
  /// In ro, this message translates to:
  /// **'{price} / rezervare'**
  String rentalPriceWholeRental(String price);

  /// Heading of the name and phone fields of the request form.
  ///
  /// In ro, this message translates to:
  /// **'Datele tale'**
  String get rentalContactTitle;

  /// Optional notes field; davidanrentcar.md's placeholder.
  ///
  /// In ro, this message translates to:
  /// **'Informații suplimentare'**
  String get rentalNotesLabel;

  /// Heading of the price breakdown.
  ///
  /// In ro, this message translates to:
  /// **'Prețul rezervării'**
  String get rentalQuoteTitle;

  /// Price breakdown: the days charged at the price per day.
  ///
  /// In ro, this message translates to:
  /// **'{days, plural, one{{days} zi} few{{days} zile} other{{days} de zile}} × {rate}'**
  String rentalDaysAtRate(int days, String rate);

  /// Price breakdown: which band of rental lengths the price per day is for. tier is rentalTierRange or rentalTierFrom.
  ///
  /// In ro, this message translates to:
  /// **'Prețul pe zi pentru {tier}'**
  String rentalRateForTier(String tier);

  /// Under the request form's price.
  ///
  /// In ro, this message translates to:
  /// **'Nu plătești nimic acum. Te contactăm ca să confirmăm rezervarea.'**
  String get rentalNoPaymentNote;

  /// No description provided for @rentalSendRequest.
  ///
  /// In ro, this message translates to:
  /// **'Trimite cererea'**
  String get rentalSendRequest;

  /// No description provided for @rentalRequestSentTitle.
  ///
  /// In ro, this message translates to:
  /// **'Cererea a fost trimisă'**
  String get rentalRequestSentTitle;

  /// Title of a cancelled rental request's page.
  ///
  /// In ro, this message translates to:
  /// **'Cererea a fost anulată'**
  String get rentalRequestCancelledTitle;

  /// Under the sent request, quoting davidanrentcar.md's thank-you page (formal, as the site words it).
  ///
  /// In ro, this message translates to:
  /// **'Vă vom contacta în curând.'**
  String get rentalWillContact;

  /// Under a sent rental request: what the request doesn't mean yet.
  ///
  /// In ro, this message translates to:
  /// **'Mașina nu e încă rezervată până nu te contactăm. Nu ai plătit nimic.'**
  String get rentalRequestNotReserved;

  /// Button that cancels a waiting rental request, and the dialog's confirming button.
  ///
  /// In ro, this message translates to:
  /// **'Anulează cererea'**
  String get rentalCancelRequest;

  /// Title of the dialog confirming a rental request's cancellation.
  ///
  /// In ro, this message translates to:
  /// **'Anulezi cererea?'**
  String get rentalCancelRequestTitle;

  /// Message of the dialog confirming a rental request's cancellation.
  ///
  /// In ro, this message translates to:
  /// **'Poți trimite oricând o cerere nouă.'**
  String get rentalCancelRequestMessage;

  /// Title of a car rental request.
  ///
  /// In ro, this message translates to:
  /// **'Cererea nr. {id}'**
  String rentalBookingNumber(String id);

  /// A rental request on the hub's strip: the car and when it's picked up ("17.09, 09:00").
  ///
  /// In ro, this message translates to:
  /// **'{car} · {pickup}'**
  String activeBookingSummary(String car, String pickup);

  /// Status of a rental request waiting for DaviDan Rent Car to call.
  ///
  /// In ro, this message translates to:
  /// **'În așteptare'**
  String get rentalBookingStatus;

  /// Status of a rental request the customer cancelled.
  ///
  /// In ro, this message translates to:
  /// **'Anulată'**
  String get rentalBookingCancelled;

  /// No description provided for @rentalBookingNotFound.
  ///
  /// In ro, this message translates to:
  /// **'Cererea nu a fost găsită.'**
  String get rentalBookingNotFound;

  /// Label of the car on a sent request.
  ///
  /// In ro, this message translates to:
  /// **'Mașina'**
  String get rentalCar;

  /// Label of the name and phone on a sent request.
  ///
  /// In ro, this message translates to:
  /// **'Contact'**
  String get rentalContact;

  /// Above a brand's legal page when the app isn't in Romanian: the sites have their legal pages only in Romanian, so the text isn't translated. Never shown in Romanian.
  ///
  /// In ro, this message translates to:
  /// **'Textul este disponibil doar în limba română, ca pe {website}.'**
  String legalDocumentRomanianOnly(String website);

  /// No description provided for @demoProfileNote.
  ///
  /// In ro, this message translates to:
  /// **'Cont demonstrativ, fără verificare reală prin SMS.'**
  String get demoProfileNote;

  /// No description provided for @deliverTo.
  ///
  /// In ro, this message translates to:
  /// **'Livrare la'**
  String get deliverTo;

  /// No description provided for @chooseAddress.
  ///
  /// In ro, this message translates to:
  /// **'Alege adresa sau localul'**
  String get chooseAddress;

  /// No description provided for @categoriesTitle.
  ///
  /// In ro, this message translates to:
  /// **'Categorii'**
  String get categoriesTitle;

  /// Heading over the home page's featured products, as on davidan.md.
  ///
  /// In ro, this message translates to:
  /// **'Produse DaviDan'**
  String get popularTitle;

  /// Heading over a brand home's featured products when the brand's site has no heading of its own (sushi).
  ///
  /// In ro, this message translates to:
  /// **'Populare'**
  String get popularTitlePlain;

  /// Link at the end of a home shelf; davidan.md's wording on its category list.
  ///
  /// In ro, this message translates to:
  /// **'Vezi mai mult'**
  String get seeAll;

  /// Button under a home shelf that opens the whole category.
  ///
  /// In ro, this message translates to:
  /// **'{count, plural, one{Vezi {count} produs} few{Vezi toate cele {count} produse} other{Vezi toate cele {count} de produse}}'**
  String seeAllProducts(int count);

  /// No description provided for @categoryEmpty.
  ///
  /// In ro, this message translates to:
  /// **'Momentan nu sunt produse în această categorie.'**
  String get categoryEmpty;

  /// No description provided for @descriptionTitle.
  ///
  /// In ro, this message translates to:
  /// **'Descriere'**
  String get descriptionTitle;

  /// Product page: how many pieces, labelled as on davidansushi.md. pieces is the site's value as written.
  ///
  /// In ro, this message translates to:
  /// **'Bucăți: {pieces}'**
  String productPieces(String pieces);

  /// Product page: weight or volume, labelled as on davidansushi.md. weight is the site's value as written.
  ///
  /// In ro, this message translates to:
  /// **'Masa: {weight}'**
  String productWeight(String weight);

  /// A drink's size on its page, e.g. "Volum: 0,5L".
  ///
  /// In ro, this message translates to:
  /// **'Volum: {volume}'**
  String productVolume(String volume);

  /// No description provided for @productNotFound.
  ///
  /// In ro, this message translates to:
  /// **'Produsul nu a fost găsit.'**
  String get productNotFound;

  /// No description provided for @increaseQuantity.
  ///
  /// In ro, this message translates to:
  /// **'Mărește cantitatea'**
  String get increaseQuantity;

  /// No description provided for @decreaseQuantity.
  ///
  /// In ro, this message translates to:
  /// **'Micșorează cantitatea'**
  String get decreaseQuantity;

  /// How many of this product are in the cart.
  ///
  /// In ro, this message translates to:
  /// **'În coș: {count}'**
  String inCart(int count);

  /// Product page button.
  ///
  /// In ro, this message translates to:
  /// **'Adaugă în coș · {total}'**
  String addToCartTotal(String total);

  /// Button on a product's page when the product is already in the cart: sets the quantity picked.
  ///
  /// In ro, this message translates to:
  /// **'Actualizează coșul · {total}'**
  String updateCartTotal(String total);

  /// Button on a product's page when its quantity is taken down to 0.
  ///
  /// In ro, this message translates to:
  /// **'Scoate din coș'**
  String get removeFromCartAction;

  /// Toast after adding a product.
  ///
  /// In ro, this message translates to:
  /// **'Adăugat în coș: {quantity} × {productName}'**
  String addedToCart(int quantity, String productName);

  /// Toast after changing a product's quantity in the cart from its page.
  ///
  /// In ro, this message translates to:
  /// **'Coș actualizat: {quantity} × {productName}'**
  String cartUpdated(int quantity, String productName);

  /// Toast after taking a product out of the cart from its page.
  ///
  /// In ro, this message translates to:
  /// **'Scos din coș: {productName}'**
  String removedFromCart(String productName);

  /// Screen reader label of the add button.
  ///
  /// In ro, this message translates to:
  /// **'Adaugă {productName} în coș'**
  String addToCart(String productName);

  /// Screen reader label of the minus button.
  ///
  /// In ro, this message translates to:
  /// **'Scoate o bucată de {productName} din coș'**
  String removeOneFromCart(String productName);

  /// Screen reader label of the remove button.
  ///
  /// In ro, this message translates to:
  /// **'Scoate {productName} din coș'**
  String removeFromCart(String productName);

  /// Number of products in the cart.
  ///
  /// In ro, this message translates to:
  /// **'{count, plural, one{{count} produs în coș} few{{count} produse în coș} other{{count} de produse în coș}}'**
  String itemsInCart(int count);

  /// Screen reader label of a brand's cart button, with itemsInCart when the cart has anything.
  ///
  /// In ro, this message translates to:
  /// **'{count, plural, =0{Coșul meu} one{Coșul meu, {count} produs în coș} few{Coșul meu, {count} produse în coș} other{Coșul meu, {count} de produse în coș}}'**
  String openCart(int count);

  /// The hub's list of every brand's cart that has something in it.
  ///
  /// In ro, this message translates to:
  /// **'Coșurile mele'**
  String get openCartsTitle;

  /// Screen reader label of the hub's carts button: openCartsTitle, plus the products in every cart.
  ///
  /// In ro, this message translates to:
  /// **'{count, plural, =0{Coșurile mele} one{Coșurile mele, {count} produs în coș} few{Coșurile mele, {count} produse în coș} other{Coșurile mele, {count} de produse în coș}}'**
  String openCarts(int count);

  /// No description provided for @openCartsEmptyTitle.
  ///
  /// In ro, this message translates to:
  /// **'Nimic în coș deocamdată'**
  String get openCartsEmptyTitle;

  /// No description provided for @openCartsEmptyMessage.
  ///
  /// In ro, this message translates to:
  /// **'Fiecare meniu are coșul lui. Coșurile în care ai adăugat ceva apar aici.'**
  String get openCartsEmptyMessage;

  /// Heading of a brand's most recent order on its page (the water page), above the button that repeats it.
  ///
  /// In ro, this message translates to:
  /// **'Ultima comandă'**
  String get lastOrderTitle;

  /// Button that puts the items of the brand's last order back in its cart.
  ///
  /// In ro, this message translates to:
  /// **'Comandă din nou'**
  String get orderAgain;

  /// Shown instead of the last order before the brand's first one.
  ///
  /// In ro, this message translates to:
  /// **'După prima comandă, o poți repeta de aici cu o singură apăsare.'**
  String get orderAgainHint;

  /// No description provided for @cartEmptyTitle.
  ///
  /// In ro, this message translates to:
  /// **'Coșul tău e gol'**
  String get cartEmptyTitle;

  /// No description provided for @cartEmptyMessage.
  ///
  /// In ro, this message translates to:
  /// **'Adaugă produse din meniu, apoi revino aici ca să finalizezi comanda.'**
  String get cartEmptyMessage;

  /// Empty cart message for a brand that sells from its page and has no menu (water).
  ///
  /// In ro, this message translates to:
  /// **'Adaugă produse, apoi revino aici ca să finalizezi comanda.'**
  String get cartEmptyMessageNoMenu;

  /// No description provided for @browseMenu.
  ///
  /// In ro, this message translates to:
  /// **'Vezi meniul'**
  String get browseMenu;

  /// Empty cart button for a brand with no menu (water): back to its page.
  ///
  /// In ro, this message translates to:
  /// **'Vezi produsele'**
  String get browseProducts;

  /// No description provided for @continueOrder.
  ///
  /// In ro, this message translates to:
  /// **'Continuă comanda'**
  String get continueOrder;

  /// No description provided for @total.
  ///
  /// In ro, this message translates to:
  /// **'Total'**
  String get total;

  /// Price of one piece.
  ///
  /// In ro, this message translates to:
  /// **'{price} / buc.'**
  String unitPrice(String price);

  /// An order line.
  ///
  /// In ro, this message translates to:
  /// **'{quantity} × {productName}'**
  String lineItem(int quantity, String productName);

  /// No description provided for @fulfilmentTitle.
  ///
  /// In ro, this message translates to:
  /// **'Cum primești comanda'**
  String get fulfilmentTitle;

  /// No description provided for @delivery.
  ///
  /// In ro, this message translates to:
  /// **'Livrare'**
  String get delivery;

  /// No description provided for @pickup.
  ///
  /// In ro, this message translates to:
  /// **'Ridicare din local'**
  String get pickup;

  /// No description provided for @deliveryAddress.
  ///
  /// In ro, this message translates to:
  /// **'Adresa de livrare'**
  String get deliveryAddress;

  /// No description provided for @deliveryAddressHint.
  ///
  /// In ro, this message translates to:
  /// **'Strada, numărul, blocul, apartamentul'**
  String get deliveryAddressHint;

  /// No description provided for @deliveryAddressMissing.
  ///
  /// In ro, this message translates to:
  /// **'Scrie adresa unde livrăm comanda.'**
  String get deliveryAddressMissing;

  /// No description provided for @deliveryTimeTitle.
  ///
  /// In ro, this message translates to:
  /// **'Ora livrării'**
  String get deliveryTimeTitle;

  /// No description provided for @pickupTimeTitle.
  ///
  /// In ro, this message translates to:
  /// **'Ora ridicării'**
  String get pickupTimeTitle;

  /// No description provided for @asSoonAsPossible.
  ///
  /// In ro, this message translates to:
  /// **'Cât mai curând'**
  String get asSoonAsPossible;

  /// davidan.md's "Livrare și achitare" page calls payment "achitare": cash or the courier's POS terminal.
  ///
  /// In ro, this message translates to:
  /// **'Achitare'**
  String get paymentTitle;

  /// No description provided for @paymentOnDelivery.
  ///
  /// In ro, this message translates to:
  /// **'Plătești curierului, la primirea comenzii.'**
  String get paymentOnDelivery;

  /// No description provided for @paymentOnPickup.
  ///
  /// In ro, this message translates to:
  /// **'Plătești în local, la ridicarea comenzii.'**
  String get paymentOnPickup;

  /// No description provided for @orderSummaryTitle.
  ///
  /// In ro, this message translates to:
  /// **'Comanda ta'**
  String get orderSummaryTitle;

  /// No description provided for @placeOrder.
  ///
  /// In ro, this message translates to:
  /// **'Plasează comanda'**
  String get placeOrder;

  /// No description provided for @paymentCash.
  ///
  /// In ro, this message translates to:
  /// **'Numerar'**
  String get paymentCash;

  /// Pay by card when receiving the order, on the courier's or shop's terminal.
  ///
  /// In ro, this message translates to:
  /// **'Card, la primire (terminal POS)'**
  String get paymentCard;

  /// No description provided for @orderPlacedTitle.
  ///
  /// In ro, this message translates to:
  /// **'Comanda a fost plasată'**
  String get orderPlacedTitle;

  /// No description provided for @orderNotFound.
  ///
  /// In ro, this message translates to:
  /// **'Comanda nu a fost găsită.'**
  String get orderNotFound;

  /// No description provided for @pickupFrom.
  ///
  /// In ro, this message translates to:
  /// **'Ridicare din'**
  String get pickupFrom;

  /// No description provided for @orderTime.
  ///
  /// In ro, this message translates to:
  /// **'Ora'**
  String get orderTime;

  /// No description provided for @trackingComingSoon.
  ///
  /// In ro, this message translates to:
  /// **'Urmărirea comenzii pas cu pas va apărea aici în etapele următoare.'**
  String get trackingComingSoon;

  /// Order title.
  ///
  /// In ro, this message translates to:
  /// **'Comanda nr. {id}'**
  String orderNumber(String id);

  /// An order on the hub's strip: how many products and the total.
  ///
  /// In ro, this message translates to:
  /// **'{count, plural, one{{count} produs} few{{count} produse} other{{count} de produse}} · {total}'**
  String activeOrderSummary(int count, String total);

  /// Order status.
  ///
  /// In ro, this message translates to:
  /// **'Plasată'**
  String get orderStatusPlaced;

  /// Order status.
  ///
  /// In ro, this message translates to:
  /// **'Acceptată'**
  String get orderStatusAccepted;

  /// Order status.
  ///
  /// In ro, this message translates to:
  /// **'Se pregătește'**
  String get orderStatusPreparing;

  /// Order status.
  ///
  /// In ro, this message translates to:
  /// **'Gata'**
  String get orderStatusReady;

  /// Order status.
  ///
  /// In ro, this message translates to:
  /// **'În livrare'**
  String get orderStatusOnTheWay;

  /// Order status.
  ///
  /// In ro, this message translates to:
  /// **'Finalizată'**
  String get orderStatusCompleted;

  /// Store panel button that accepts an order.
  ///
  /// In ro, this message translates to:
  /// **'Acceptă'**
  String get advanceToAccepted;

  /// Store panel button.
  ///
  /// In ro, this message translates to:
  /// **'Începe prepararea'**
  String get advanceToPreparing;

  /// Store panel button.
  ///
  /// In ro, this message translates to:
  /// **'Marchează gata'**
  String get advanceToReady;

  /// Courier app button: the courier has collected the order.
  ///
  /// In ro, this message translates to:
  /// **'Am preluat comanda'**
  String get advanceToOnTheWay;

  /// Courier app or store panel button: handed to the customer.
  ///
  /// In ro, this message translates to:
  /// **'Predată clientului'**
  String get advanceToCompleted;

  /// A scheduled order time.
  ///
  /// In ro, this message translates to:
  /// **'La {time}'**
  String scheduledAt(String time);

  /// Store panel column: new orders.
  ///
  /// In ro, this message translates to:
  /// **'Noi'**
  String get kdsIncoming;

  /// Store panel column: orders being prepared.
  ///
  /// In ro, this message translates to:
  /// **'În lucru'**
  String get kdsInKitchen;

  /// Store panel column: orders ready.
  ///
  /// In ro, this message translates to:
  /// **'Gata'**
  String get kdsReady;

  /// No description provided for @kdsColumnEmpty.
  ///
  /// In ro, this message translates to:
  /// **'Nicio comandă'**
  String get kdsColumnEmpty;

  /// No description provided for @kdsEmptyTitle.
  ///
  /// In ro, this message translates to:
  /// **'Nicio comandă deocamdată'**
  String get kdsEmptyTitle;

  /// No description provided for @kdsEmptyMessage.
  ///
  /// In ro, this message translates to:
  /// **'Comenzile plasate din aplicația clientului apar aici.'**
  String get kdsEmptyMessage;

  /// No description provided for @waitingForCourier.
  ///
  /// In ro, this message translates to:
  /// **'Așteaptă curierul'**
  String get waitingForCourier;

  /// Badge on a new order in the store panel.
  ///
  /// In ro, this message translates to:
  /// **'NOUĂ'**
  String get kdsNewTag;

  /// Store panel toast.
  ///
  /// In ro, this message translates to:
  /// **'Comandă nouă: {orderId}'**
  String newOrderArrived(String orderId);

  /// Store panel order card.
  ///
  /// In ro, this message translates to:
  /// **'Ridicare · {shopName}'**
  String pickupAt(String shopName);

  /// Screen reader label of the store panel timer.
  ///
  /// In ro, this message translates to:
  /// **'Timp de la plasare: {elapsed}'**
  String timeSincePlaced(String elapsed);

  /// No description provided for @favoritesTitle.
  ///
  /// In ro, this message translates to:
  /// **'Produse favorite'**
  String get favoritesTitle;

  /// No description provided for @favoritesEmptyTitle.
  ///
  /// In ro, this message translates to:
  /// **'Niciun produs favorit'**
  String get favoritesEmptyTitle;

  /// No description provided for @favoritesEmptyMessage.
  ///
  /// In ro, this message translates to:
  /// **'Apasă inima de pe un produs ca să-l găsești repede aici.'**
  String get favoritesEmptyMessage;

  /// Screen reader label of the heart button.
  ///
  /// In ro, this message translates to:
  /// **'Adaugă {productName} la favorite'**
  String addToFavorites(String productName);

  /// Screen reader label of the heart button.
  ///
  /// In ro, this message translates to:
  /// **'Scoate {productName} din favorite'**
  String removeFromFavorites(String productName);

  /// Delivery map.
  ///
  /// In ro, this message translates to:
  /// **'Curierul ajunge în aproximativ {minutes} min'**
  String courierArrivesIn(int minutes);

  /// No description provided for @courierArrived.
  ///
  /// In ro, this message translates to:
  /// **'Curierul a ajuns la adresă'**
  String get courierArrived;

  /// Courier availability switch.
  ///
  /// In ro, this message translates to:
  /// **'Online'**
  String get courierOnline;

  /// Courier availability switch.
  ///
  /// In ro, this message translates to:
  /// **'Offline'**
  String get courierOffline;

  /// No description provided for @courierOnlineHint.
  ///
  /// In ro, this message translates to:
  /// **'Primești comenzi noi'**
  String get courierOnlineHint;

  /// No description provided for @courierOfflineHint.
  ///
  /// In ro, this message translates to:
  /// **'Nu primești comenzi noi'**
  String get courierOfflineHint;

  /// No description provided for @courierOnTheWaySection.
  ///
  /// In ro, this message translates to:
  /// **'Pe drum spre client'**
  String get courierOnTheWaySection;

  /// No description provided for @courierReadySection.
  ///
  /// In ro, this message translates to:
  /// **'De preluat din local'**
  String get courierReadySection;

  /// No description provided for @courierOfflineTitle.
  ///
  /// In ro, this message translates to:
  /// **'Ești offline'**
  String get courierOfflineTitle;

  /// No description provided for @courierOfflineMessage.
  ///
  /// In ro, this message translates to:
  /// **'Intră online ca să vezi comenzile de preluat din local.'**
  String get courierOfflineMessage;

  /// No description provided for @courierEmptyTitle.
  ///
  /// In ro, this message translates to:
  /// **'Nicio livrare deocamdată'**
  String get courierEmptyTitle;

  /// No description provided for @courierEmptyMessage.
  ///
  /// In ro, this message translates to:
  /// **'Comenzile cu livrare apar aici când localul le marchează gata.'**
  String get courierEmptyMessage;

  /// Courier app: money to collect from the customer.
  ///
  /// In ro, this message translates to:
  /// **'De încasat'**
  String get toCollect;

  /// No description provided for @itemsTitle.
  ///
  /// In ro, this message translates to:
  /// **'Produse'**
  String get itemsTitle;

  /// No description provided for @courierWaitingForStore.
  ///
  /// In ro, this message translates to:
  /// **'Localul încă pregătește comanda.'**
  String get courierWaitingForStore;

  /// No description provided for @deliveryCompleted.
  ///
  /// In ro, this message translates to:
  /// **'Livrare finalizată.'**
  String get deliveryCompleted;

  /// No description provided for @backToDeliveries.
  ///
  /// In ro, this message translates to:
  /// **'Înapoi la comenzi'**
  String get backToDeliveries;

  /// No description provided for @deliveryNotFound.
  ///
  /// In ro, this message translates to:
  /// **'Livrarea nu a fost găsită.'**
  String get deliveryNotFound;

  /// Courier app delivery screen title.
  ///
  /// In ro, this message translates to:
  /// **'Livrare {orderId}'**
  String deliveryTitle(String orderId);

  /// Courier app: amount to collect and how.
  ///
  /// In ro, this message translates to:
  /// **'{total} · {paymentMethod}'**
  String amountToCollect(String total, String paymentMethod);

  /// A banner's button: the banner opens its category.
  ///
  /// In ro, this message translates to:
  /// **'Comandă acum'**
  String get bannerCta;

  /// The search field on the hub: every brand's menu and the Rent Car fleet.
  ///
  /// In ro, this message translates to:
  /// **'Caută în DaviDan'**
  String get searchHubHint;

  /// The search field on a brand's home: that brand's menu.
  ///
  /// In ro, this message translates to:
  /// **'Caută în meniu'**
  String get searchMenuHint;

  /// The search field's clear button.
  ///
  /// In ro, this message translates to:
  /// **'Șterge textul'**
  String get searchClear;

  /// The search page before anything is typed.
  ///
  /// In ro, this message translates to:
  /// **'Ce cauți?'**
  String get searchPromptTitle;

  /// What the hub's search finds.
  ///
  /// In ro, this message translates to:
  /// **'Scrie numele unui produs, un ingredient sau marca unei mașini.'**
  String get searchPromptHub;

  /// What a brand's menu search finds.
  ///
  /// In ro, this message translates to:
  /// **'Scrie numele unui produs sau un ingredient.'**
  String get searchPromptMenu;

  /// The search page when nothing matches.
  ///
  /// In ro, this message translates to:
  /// **'Nimic găsit'**
  String get searchNoResultsTitle;

  /// The search page when nothing matches what was typed.
  ///
  /// In ro, this message translates to:
  /// **'Nu am găsit nimic pentru „{query}”. Încearcă alt cuvânt.'**
  String searchNoResultsMessage(String query);

  /// The heading over the products search found.
  ///
  /// In ro, this message translates to:
  /// **'{count, plural, one{{count} produs} few{{count} produse} other{{count} de produse}}'**
  String searchProductsTitle(int count);

  /// The heading over the rental cars search found.
  ///
  /// In ro, this message translates to:
  /// **'{count, plural, one{{count} mașină} few{{count} mașini} other{{count} de mașini}}'**
  String searchCarsTitle(int count);

  /// The bell's label for screen readers.
  ///
  /// In ro, this message translates to:
  /// **'Deschide notificările'**
  String get openNotifications;

  /// The bell's page.
  ///
  /// In ro, this message translates to:
  /// **'Notificări'**
  String get notificationsTitle;

  /// The bell's page before any order or request.
  ///
  /// In ro, this message translates to:
  /// **'Nicio notificare'**
  String get notificationsEmptyTitle;

  /// The bell's page before any order or request.
  ///
  /// In ro, this message translates to:
  /// **'Aici apar noutățile despre comenzile și cererile tale.'**
  String get notificationsEmptyMessage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ro', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ro':
      return AppLocalizationsRo();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
