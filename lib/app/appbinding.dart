import 'package:get/get.dart';
import 'package:huzz/Repository/auth_respository.dart';
import 'package:huzz/Repository/bank_account_repository.dart';
import 'package:huzz/Repository/business_respository.dart';
import 'package:huzz/Repository/customer_repository.dart';
import 'package:huzz/Repository/debtors_repository.dart';
import 'package:huzz/Repository/file_upload_respository.dart';
import 'package:huzz/Repository/home_respository.dart';
import 'package:huzz/Repository/invoice_repository.dart';
import 'package:huzz/Repository/miscellaneous_respository.dart';
import 'package:huzz/Repository/notification_repository.dart';
import 'package:huzz/Repository/product_repository.dart';
import 'package:huzz/Repository/transaction_respository.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeRespository(), permanent: true);
    Get.put(AuthRepository(), permanent: true);
    Get.put(MiscellaneousRepository(),permanent: true);
    Get.put(BusinessRespository(), permanent: true);
    Get.put(FileUploadRespository(), permanent: true);
    Get.put(ProductRepository(), permanent: true);
    Get.put(CustomerRepository(), permanent: true);
    Get.put(DebtorRepository(), permanent: true);
    Get.put(TransactionRespository(), permanent: true);
    Get.put(BankAccountRepository(), permanent: true);
    Get.put(InvoiceRespository(), permanent: true);
    Get.put(NotificationRepository(), permanent: true);
  }
}
