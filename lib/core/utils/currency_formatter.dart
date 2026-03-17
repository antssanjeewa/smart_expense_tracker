import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String formatCurrency(double amount, {String currency = 'USD'}) {
    final NumberFormat formatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: 'Rs ',
    );
    return formatter.format(amount);
  }

  static String formatCurrencyWithoutSymbol(double amount) {
    final NumberFormat formatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: '',
    );
    return formatter.format(amount).trim();
  }

  static double parseCurrency(String currencyString) {
    final NumberFormat formatter = NumberFormat.currency(locale: 'en_US');
    return formatter.parse(currencyString) as double;
  }
}
