import 'dart:io';

import 'package:intl/intl.dart';

class Utils{


  String getCurrency(String countryCode) {
  var format = NumberFormat.simpleCurrency(locale: Platform.localeName, name: 'NGN');
  return format.currencySymbol;
}
}