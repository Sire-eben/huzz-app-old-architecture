import 'package:get/get.dart';

import '../data/Repository/auth_respository.dart';
import '../data/Repository/bank_account_repository.dart';
import '../data/Repository/business_respository.dart';
import '../data/Repository/customer_repository.dart';
import '../data/Repository/debtors_repository.dart';
import '../data/Repository/file_upload_respository.dart';
import '../data/Repository/home_respository.dart';
import '../data/Repository/invoice_repository.dart';
import '../data/Repository/miscellaneous_respository.dart';
import '../data/Repository/notification_repository.dart';
import '../data/Repository/product_repository.dart';
import '../data/Repository/team_repository.dart';
import '../data/Repository/transaction_respository.dart';


class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeRespository(), permanent: true);
    Get.put(AuthRepository(), permanent: true);
    Get.put(MiscellaneousRepository(), permanent: true);
    Get.put(BusinessRespository(), permanent: true);
    Get.put(FileUploadRespository(), permanent: true);
    Get.put(ProductRepository(), permanent: true);
    Get.put(CustomerRepository(), permanent: true);
    Get.put(DebtorRepository(), permanent: true);
    Get.put(TransactionRespository(), permanent: true);
    Get.put(BankAccountRepository(), permanent: true);
    Get.put(InvoiceRespository(), permanent: true);
    Get.put(TeamRepository(), permanent: true);
    Get.put(NotificationRepository(), permanent: true);
  }
}
