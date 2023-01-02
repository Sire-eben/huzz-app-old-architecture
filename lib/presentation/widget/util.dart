import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:number_display/number_display.dart';
import '../../data/repository/business_repository.dart';

class Utils {
  static final display = createDisplay(
    roundingType: RoundingType.floor,
    length: 15,
    decimal: 5,
  );
  static final _businessController=Get.find<BusinessRespository>();
  static formatPrice(dynamic price) => '${_businessController.selectedBusiness.value!.businessCurrency} ${display(price)}';
  static formatDate(DateTime date) => DateFormat.yMd().format(date);
}
