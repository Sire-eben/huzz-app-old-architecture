import 'package:intl/intl.dart';

class Utils {
  static formatPrice(double price) => '\NGN${price.toStringAsFixed(2)}';
  static formatDate(DateTime date) => DateFormat.yMd().format(date);
}
