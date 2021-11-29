import 'package:get/get.dart';
import 'package:huzz/Repository/auth_respository.dart';
import 'package:huzz/Repository/business_respository.dart';
import 'package:huzz/Repository/home_respository.dart';

class AppBinding extends Bindings{

@override
  void dependencies() {
    // TODO: implement dependencies
     Get.put(HomeRespository(), permanent: true);
     Get.put(AuthRepository(),permanent: true);
     Get.put(BusinessRespository(),permanent: true);
  }

}