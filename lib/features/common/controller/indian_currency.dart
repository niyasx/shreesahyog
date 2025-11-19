import 'package:intl/intl.dart';

class IndianCurrencyFormatter {
  static String format(double amount) {
    final formatCurrency = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    return formatCurrency.format(amount);
  }
}
