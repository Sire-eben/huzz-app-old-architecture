import 'package:get/get.dart';
import 'package:huzz/data/Repository/auth_respository.dart';
import 'package:huzz/data/Repository/bank_account_repository.dart';
import 'package:huzz/data/Repository/business_respository.dart';
import 'package:huzz/data/Repository/customer_repository.dart';
import 'package:huzz/data/Repository/debtors_repository.dart';
import 'package:huzz/data/Repository/file_upload_respository.dart';
import 'package:huzz/data/Repository/home_respository.dart';
import 'package:huzz/data/Repository/invoice_repository.dart';
import 'package:huzz/data/Repository/miscellaneous_respository.dart';
import 'package:huzz/data/Repository/notification_repository.dart';
import 'package:huzz/data/Repository/product_repository.dart';
import 'package:huzz/data/Repository/team_repository.dart';
import 'package:huzz/data/Repository/transaction_respository.dart';

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
