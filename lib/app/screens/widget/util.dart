import 'package:intl/intl.dart';
import 'package:number_display/number_display.dart';

class Utils {
  static final display = createDisplay(
    roundingType: RoundingType.floor,
    length: 15,
    decimal: 5,
  );
  static formatPrice(dynamic price) => '\NGN ${display(price)}';
  static formatDate(DateTime date) => DateFormat.yMd().format(date);
}
