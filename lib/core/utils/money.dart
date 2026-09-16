import 'package:davidan_prototype/l10n/l10n.dart';

extension MoneyFormat on AppLocalizations {
  /// Formats a price in bani (1/100 MDL): 1900 → "19 lei", 1950 → "19,50 lei".
  String formatLei(int bani) {
    final lei = bani ~/ 100;
    final rest = bani % 100;
    return priceLei(
      rest == 0 ? '$lei' : '$lei,${rest.toString().padLeft(2, '0')}',
    );
  }

  /// Formats a price in whole euros, as DaviDan Rent Car prices its cars:
  /// 19 → "19 €".
  String formatEuro(int euros) => priceEuro('$euros');
}
