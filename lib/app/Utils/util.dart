import 'dart:io';

import 'package:get/get.dart';
import 'package:huzz/Repository/business_respository.dart';
import 'package:intl/intl.dart';

class Utils{
static final _businessRepository=Get.find<BusinessRespository>();

 static String getCurrency() {
  var format = NumberFormat.simpleCurrency(locale: Platform.localeName, name:"USD");
  return format.currencySymbol;
}
}