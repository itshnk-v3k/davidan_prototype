/// Groups thousands with dots, the Romanian way: 2000000 → "2.000.000".
String formatCount(int value) =>
    value.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+$)'), (_) => '.');
