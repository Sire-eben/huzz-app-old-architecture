import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/business_respository.dart';
import 'package:huzz/Repository/file_upload_respository.dart';
import 'package:huzz/api_link.dart';
import 'package:huzz/app/screens/home/income_success.dart';
import 'package:huzz/model/customer_model.dart';
import 'package:huzz/model/offline_business.dart';
import 'package:huzz/model/payment_item.dart';
import 'package:huzz/model/product.dart';
import 'package:huzz/model/transaction_model.dart';
import 'package:http/http.dart' as http;
import 'package:huzz/sqlite/sqlite_db.dart';

import 'auth_respository.dart';
import 'customer_repository.dart';

enum AddingTransactionStatus { Loading, Error, Success, Empty }

class TransactionRespository extends GetxController {
  Rx<List<TransactionModel>> _offlineTransactions = Rx([]);
  List<TransactionModel> get offlineTransactions => _offlineTransactions.value;
  final _uploadImageController = Get.find<FileUploadRespository>();
  final _customerController = Get.find<CustomerRepository>();
  List<TransactionModel> OnlineTransaction = [];
  List<TransactionModel> pendingTransaction = [];
  Rx<List<PaymentItem>> _allPaymentItem = Rx([]);
  List<PaymentItem> get allPaymentItem => _allPaymentItem.value;
  final _userController = Get.find<AuthRepository>();
  final _businessController = Get.find<BusinessRespository>();
  final expenses = 0.obs;
  final income = 0.obs;
  final numberofincome = 0.obs;
  final numberofexpenses = 0.obs;
  final totalbalance = 0.obs;
  final debtors = 0.obs;
  List<TransactionModel> todayTransaction = [];
  SqliteDb sqliteDb = SqliteDb();
  final itemNameController = TextEditingController();
  final amountController = TextEditingController();
  final quantityController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final paymentController = TextEditingController();
  final paymentSourceController = TextEditingController();
  final receiptFileController = TextEditingController();
  final amountPaidController = TextEditingController();
  // final TextEditingController dateController = TextEditingController();
  // final TextEditingController timeController = TextEditingController();
  final TextEditingController contactName = TextEditingController();
  final TextEditingController contactPhone = TextEditingController();
  final TextEditingController contactMail = TextEditingController();
  final _addingTransactionStatus = AddingTransactionStatus.Empty.obs;
// final _uploadFileController=Get.find<FileUploadRespository>();
  AddingTransactionStatus get addingTransactionStatus =>
      _addingTransactionStatus.value;
  Product? selectedProduct;
  int? remain;
  Rx<Customer?> selectedCustomer = Rx(null);
  DateTime? date;
  TimeOfDay? time;
  File? image;
  int selectedValue = 0;
  int customerType = 0;
  bool addCustomer = false;
  List<String> paymentSource = ["POS", "CASH", "TRANSFER", "OTHERS"];
  String? selectedPaymentSource;
  List<String> paymentMode = ["FULLY_PAID", "DEPOSIT"];
  String? selectedPaymentMode;

  @override
  void onInit() async {
    // TODO: implement onInit
    print("getting transaction repo");

    _userController.Mtoken.listen((p0) {
      print("token gotten $p0");
      if (p0.isNotEmpty || p0 != "0") {
        final value = _businessController.selectedBusiness.value;
        if (value != null) {
          getOnlineTransaction(value.businessId!);

          getSpending(value.businessId!);

          GetOfflineTransactions(value.businessId!);
        } else {
          print("current business is null");
        }
        _businessController.selectedBusiness.listen((p0) {
          if (p0 != null) {
            print("business id ${p0.businessId}");
            _offlineTransactions([]);
            _allPaymentItem([]);
            OnlineTransaction = [];
            getOnlineTransaction(p0.businessId!);

            GetOfflineTransactions(p0.businessId!);
            getSpending(p0.businessId!);
          }
        });
      }
    });
  }

  Future getAllPaymentItem() async {
    if (todayTransaction.isEmpty) return;
    List<PaymentItem> items = [];
    todayTransaction.forEach((element) {
      items.addAll(element.businessTransactionPaymentItemList!);
    });

    _allPaymentItem(items);
  }

  Future getOnlineTransaction(String businessId) async {
    var response = await http.get(
        Uri.parse(
            ApiLink.get_business_transaction + "?businessId=" + businessId),
        headers: {"Authorization": "Bearer ${_userController.token}"});
    var json = jsonDecode(response.body);
    print("get online transaction $json");
    if (response.statusCode == 200) {
      var result =
          List.from(json['data']).map((e) => TransactionModel.fromJson(e));

      OnlineTransaction.addAll(result);

      getTransactionYetToBeSavedLocally();
    } else {}
  }

  Future GetOfflineTransactions(String id) async {
    var results = await _businessController.sqliteDb.getOfflineTransactions(id);
    print("offline transaction ${results.length}");

    _offlineTransactions(results);

    getTodayTransaction();
  }

  Future getTodayTransaction() async {
    List<TransactionModel> _todayTransaction = [];
    final date = DateTime.now();
    offlineTransactions.forEach((element) {
      print("element test date ${element.createdTime!.toIso8601String()}");
      final d = DateTime(element.createdTime!.year, element.createdTime!.month,
          element.createdTime!.day);
      if (d.isAtSameMomentAs(DateTime(date.year, date.month, date.day))) {
        _todayTransaction.add(element);

        print("found date for today");
      }
    });
    todayTransaction = _todayTransaction;
    getAllPaymentItem();
  }

  Future getTransactionYetToBeSavedLocally() async {
    OnlineTransaction.forEach((element) {
      if (!checkifTransactionAvailable(element.id!)) {
        print("doesnt contain value");

        pendingTransaction.add(element);
      }
    });

    savePendingJob();
  }

  Future PendingTransaction() async {}

  bool checkifTransactionAvailable(String id) {
    bool result = false;
    offlineTransactions.forEach((element) {
      print("checking transaction whether exist");
      if (element.id == id) {
        print("transaction   found");
        result = true;
      }
    });
    return result;
  }

  Future savePendingJob() async {
    if (pendingTransaction.isEmpty) {
      return;
    }
    var savenext = pendingTransaction.first;
    await _businessController.sqliteDb.insertTransaction(savenext);
    pendingTransaction.remove(savenext);
    if (pendingTransaction.isNotEmpty) {
      savePendingJob();
    }
    GetOfflineTransactions(savenext.businessId!);
  }

  Future getSpending(String id) async {
    final now = DateTime.now();
    var day = now.day >= 10 ? now.day.toString() : "0" + now.day.toString();
    var month =
        now.month >= 10 ? now.month.toString() : "0" + now.month.toString();
    final date = "" + now.year.toString() + "-" + month + "-" + day;
    print("today date is $date");
    final response = await http.get(
        Uri.parse(ApiLink.dashboard_overview +
            "?businessId=" +
            id +
            "&from=$date 00:00&to=$date 23:59"),
        headers: {"Authorization": "Bearer ${_userController.token}"});
    var json = jsonDecode(response.body);
    print("overview result $json");
    if (response.statusCode == 200) {
      var totalIncome = json['data']['totalIncomeAmount'];
      var totalExpenses = json['data']['totalExpenditureAmount'];
      var balance = json['data']['differences'];
      var numberofIncome = json['data']['numberOfIncomeTransactions'];
      var numberofExpenses = json['data']['numberOfExpenditureTransactions'];
      var Debtor = json['totalIncomeBalanceAmount'] ?? 0;
      income(totalIncome);
      expenses(totalExpenses);
      totalbalance(balance);
      numberofexpenses(numberofExpenses);
      numberofincome(numberofIncome);
      debtors(Debtor);
    }
  }

//   Future createTransaction(String type) async {
//     try {
//       _addingTransactionStatus(AddingTransactionStatus.Loading);
//       String? fileid;
//       String? customerId;
//       var productList = [];
//       if (image != null) {
//         fileid = await _uploadImageController.uploadFile(image!.path);
//       }

//       if (addCustomer) {
//         if (customerType == 1) {
//           customerId =
//               await _customerController.addBusinessCustomerWithString(type);
//         } else {
//           if (selectedCustomer.value != null)
//             customerId = selectedCustomer.value!.customerId;
//         }
//       }

//       if (selectedValue == 0) {
//         productList.add({
//           "productId": selectedProduct!.productId!,
//           "itemName": null,
//           "quantity": null,
//           "amount": null
//         });
//       } else {
//         productList.add({
//           "productId": null,
//           "itemName": itemNameController.text,
//           "quantity": null,
//           "amount": amountController.text
//         });
//       }

//       if (time != null && date != null) {
// // date!.hour=time!.hour;
//         date!.add(Duration(hours: time!.hour, minutes: time!.minute));
//         print("date Time to string ${date!.toIso8601String()}");
//       }
// // String? timeday=date!.toIso8601String();
//       String body = jsonEncode({
//         "paymentItemRequestList": productList,
//         "transactionType": type,
//         "paymentSource": selectedPaymentSource,
//         "businessId": _businessController.selectedBusiness.value!.businessId,
//         "paymentMode": selectedPaymentMode,
//         "customerId": customerId,
//         "businessTransactionFileStoreId": fileid,
//         "entyDateTime": date!.toIso8601String()
//       });
//       print("transaction body $body");
//       final response =
//           await http.post(Uri.parse(ApiLink.get_business_transaction),
//               headers: {
//                 "Authorization": "Bearer ${_userController.token}",
//                 "Content-Type": "application/json"
//               },
//               body: body);

//       print({"creatng transaction response ${response.body}"});
//       if (response.statusCode == 200) {
//         _addingTransactionStatus(AddingTransactionStatus.Success);
//         Get.to(() => IncomeSuccess());
//         getOnlineTransaction(
//             _businessController.selectedBusiness.value!.businessId!);

//         GetOfflineTransactions(
//             _businessController.selectedBusiness.value!.businessId!);
//         getSpending(_businessController.selectedBusiness.value!.businessId!);
//       } else {
//         _addingTransactionStatus(AddingTransactionStatus.Error);
//       }
//     } catch (ex) {
//       print("error occurred ${ex.toString()}");
//       _addingTransactionStatus(AddingTransactionStatus.Error);
//     }
//   }


Future createTransaction(String type)async{
  try{
  _addingTransactionStatus(AddingTransactionStatus.Loading);
  String? fileid;
  String? customerId;
  var productList=[];
if(image!=null){

fileid=await _uploadImageController.uploadFile(image!.path);

}

if(addCustomer){
if(customerType==1){
customerId=await _customerController.addBusinessCustomerWithString(type);
}else{
  if(selectedCustomer.value!=null)
  customerId=selectedCustomer.value!.customerId;
}
}

if(selectedValue==0){
 productList.add(

  {
"productId":selectedProduct!.productId!,
 "itemName": null,
            "quantity":null,
            "amount": null
  }
 );

}else{
 productList.add(

  {
"productId":null,
 "itemName": itemNameController.text,
            "quantity": quantityController.text,
            "amount": amountController.text
  }
 );


}

if(time!=null&&date!=null){
// date!.hour=time!.hour;
date!.add(Duration(hours: time!.hour,minutes: time!.minute));
print("date Time to string ${date!.toIso8601String()}");
}
// String? timeday=date!.toIso8601String();
String body=jsonEncode({

"paymentItemRequestList":productList,
    "transactionType":type,
    "paymentSource": selectedPaymentSource,
    "businessId":_businessController.selectedBusiness.value!.businessId,

    "paymentMode":selectedPaymentMode,
    "customerId":customerId,
    "businessTransactionFileStoreId":fileid,
    "entyDateTime":date!.toIso8601String(),
    "amountPaid":amountPaidController.text


});
print("transaction body $body");
final response=await http.post(Uri.parse(ApiLink.get_business_transaction),headers: {
"Authorization":"Bearer ${_userController.token}",
"Content-Type":"application/json"

},body:body );

print({"creatng transaction response ${response.body}"});
if(response.statusCode==200){
 _addingTransactionStatus(AddingTransactionStatus.Success);
           Get.to(() => IncomeSuccess());
         getOnlineTransaction(_businessController.selectedBusiness.value!.businessId!);

GetOfflineTransactions(_businessController.selectedBusiness.value!.businessId!);
getSpending(_businessController.selectedBusiness.value!.businessId!);

}else{
 _addingTransactionStatus(AddingTransactionStatus.Error);

}
}
catch(ex){
  print("error occurred ${ex.toString()}");
_addingTransactionStatus(AddingTransactionStatus.Error);

}

}
}
