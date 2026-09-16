/// Text of the internal demo tools, in Romanian only. Kept here rather than in
/// the ARB files (lib/l10n/), so the app's strings hold no demo-only text and
/// deleting this folder removes it.
abstract final class DemoToolStrings {
  static const allRolesTitle = 'Toate rolurile';
  static const allRolesHint =
      'Client, magazin și curier pe un singur ecran · intern';
  static const trackedOrder = 'Comanda urmărită:';
  static const testDelivery = 'Livrare de test';
  static const testPickup = 'Ridicare de test';
  static const customerPanel = 'Client · comanda urmărită';
  static const storePanel = 'Magazin';
  static const courierListPanel = 'Curier · comenzi';
  static const courierDeliveryPanel = 'Curier · livrarea comenzii urmărite';
  static const noOrderTitle = 'Nicio comandă deocamdată';
  static const noOrderMessage =
      'Plasează una din aplicația clientului sau cu butoanele de test.';
}
