/// DaviDan's brands, in the order the client wants them on the hub. Orders,
/// carts and favourites are saved with the brand's name, so renaming a value
/// needs a LocalStore.schemaVersion bump.
enum Brand {
  /// The gastronomic restaurant.
  restaurant,

  /// DaviDan Sushi (davidansushi.md).
  sushi,

  /// DaviDan Bakery: patisserie, kurtos and coffee (davidan.md).
  bakery,

  /// Apa DaviDan bottled water.
  water,

  /// DaviDan Rent Car (davidanrentcar.md).
  carRental,
}
