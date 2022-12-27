import 'package:get/get.dart';

import '../data/repository/auth_respository.dart';
import '../data/repository/bank_account_repository.dart';
import '../data/repository/business_respository.dart';
import '../data/repository/customer_repository.dart';
import '../data/repository/debtors_repository.dart';
import '../data/repository/file_upload_respository.dart';
import '../data/repository/home_respository.dart';
import '../data/repository/invoice_repository.dart';
import '../data/repository/miscellaneous_respository.dart';
import '../data/repository/notification_repository.dart';
import '../data/repository/product_repository.dart';
import '../data/repository/team_repository.dart';
import '../data/repository/transaction_respository.dart';

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
