import 'dart:io';

import 'package:get/get.dart';
import 'package:huzz/Repository/business_respository.dart';
import 'package:intl/intl.dart';

class Utils{
static final _businessRepository=Get.find<BusinessRespository>();

 static String getCurrency() {
   String code;
   if(  _businessRepository.selectedBusiness==null&&_businessRepository.selectedBusiness.value==null &&_businessRepository.selectedBusiness.value!.businessId==null){

code="NGN";
   }
  var format = NumberFormat.simpleCurrency(locale: Platform.localeName, name:_businessRepository.selectedBusiness.value!.businessCurrency!);
  return format.currencySymbol;
}

}