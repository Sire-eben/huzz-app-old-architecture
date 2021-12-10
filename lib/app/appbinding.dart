import 'package:get/get.dart';
import 'package:huzz/Repository/auth_respository.dart';
import 'package:huzz/Repository/business_respository.dart';
import 'package:huzz/Repository/customer_repository.dart';
import 'package:huzz/Repository/file_upload_respository.dart';
import 'package:huzz/Repository/home_respository.dart';
import 'package:huzz/Repository/product_repository.dart';
import 'package:huzz/Repository/transaction_respository.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(HomeRespository(), permanent: true);
    Get.put(AuthRepository(), permanent: true);
    Get.put(BusinessRespository(), permanent: true);
    Get.put(FileUploadRespository(), permanent: true);

    Get.put(ProductRepository(), permanent: true);
    Get.put(CustomerRepository(), permanent: true);
    Get.put(TransactionRespository(), permanent: true);
  }
}
