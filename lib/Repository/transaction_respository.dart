import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:huzz/Repository/business_respository.dart';
import 'package:huzz/Repository/file_upload_respository.dart';
import 'package:huzz/Repository/product_repository.dart';
import 'package:huzz/api_link.dart';
import 'package:huzz/app/screens/home/income_success.dart';
import 'package:huzz/model/customer_model.dart';
import 'package:huzz/model/payment_history.dart';
import 'package:huzz/model/payment_item.dart';
import 'package:huzz/model/product.dart';
import 'package:huzz/model/transaction_model.dart';
import 'package:huzz/sqlite/sqlite_db.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'auth_respository.dart';
import 'customer_repository.dart';

enum AddingTransactionStatus { Loading, Error, Success, Empty }

class TransactionRespository extends GetxController {
  Rx<List<TransactionModel>> _offlineTransactions = Rx([]);
  List<TransactionModel> get offlineTransactions => _offlineTransactions.value;
  final _uploadImageController = Get.find<FileUploadRespository>();
  final _customerController = Get.find<CustomerRepository>();
  final _productController = Get.find<ProductRepository>();
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
  bool isBusyAdding = false;
  bool isBusyUpdating = false;
  bool isbusyDeleting = false;
  final debtors = 0.obs;
  List<PaymentItem> productList = [];
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
  List<TransactionModel> deletedItem = [];
  final _addingTransactionStatus = AddingTransactionStatus.Empty.obs;
  var uuid = Uuid();
// final _uploadFileController=Get.find<FileUploadRespository>();
  AddingTransactionStatus get addingTransactionStatus =>
      _addingTransactionStatus.value;
  Product? selectedProduct;
  int? remain;
  Customer? selectedCustomer = null;
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
  List<TransactionModel> pendingTransactionToBeAdded = [];
  List<TransactionModel>pendingJobToBeUpdated=[];
   List<TransactionModel> pendingJobToBeDelete = [];
   List<TransactionModel> pendingUpdatedTransactionList=[];

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

          // getSpending(value.businessId!);

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
            // getSpending(p0.businessId!);

          }
        });
      }
    });
    _userController.MonlineStatus.listen((po) {
      if (po == OnlineStatus.Onilne) {
        _businessController.selectedBusiness.listen((p0) {
          checkIfTransactionThatIsYetToBeAdded();
          checkPendingTransactionbeUpdatedToServer();
          checkPendingTransactionToBeDeletedOnServer();
          //update server with pending job
        });
      }
    });
  }

  Future getAllPaymentItem() async {
    if (todayTransaction.isEmpty){
_allPaymentItem([]);
      return;
    };
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
      print("online transaction ${result.length}");
      // getTodayTransaction();
      getTransactionYetToBeSavedLocally();
      checkIfUpdateAvailable();
    } else {

    }
  }

   Future checkIfUpdateAvailable() async {
   OnlineTransaction.forEach((element) async {
      var item = getTransactionById(element.id!);
      if (item != null) {
        print("item Transaction is found");
        print("updated offline ${item.updatedTime!.toIso8601String()}");
        print("updated online ${element.updatedTime!.toIso8601String()}");
        if (!element.updatedTime!.isAtSameMomentAs(item.updatedTime!)) {
          print("found Transaction to updated");
          pendingUpdatedTransactionList.add(element);
        }
      }
    });

    updatePendingJob();
  }
Future  updatePendingJob()async{

if(pendingUpdatedTransactionList.isEmpty){

  return;
}
var updateNext=pendingUpdatedTransactionList[0];
_businessController.sqliteDb.updateOfflineTransaction(updateNext);
pendingUpdatedTransactionList.remove(updateNext);
if(pendingUpdatedTransactionList.isNotEmpty){
  updatePendingJob();
}else{

  
        GetOfflineTransactions(
            _businessController.selectedBusiness.value!.businessId!);
}

}


  Future GetOfflineTransactions(String id) async {
    var results = await _businessController.sqliteDb.getOfflineTransactions(id);
    print("offline transaction ${results.length}");

    _offlineTransactions(results.where((element) => !element.deleted!).toList());

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
    calculateOverView();
  }

  Future getTransactionYetToBeSavedLocally() async {
    OnlineTransaction.forEach((element) {
      if (!checkifTransactionAvailable(element.id!)) {
        if (!element.isPending) pendingTransaction.add(element);
      }
    });
    // print("does contain value ${pendingTransaction.first.isPending}");
    print("item yet to be save yet ${pendingTransaction.length}");
    savePendingJob();
  }

  // ignore: non_constant_identifier_names
  Future PendingTransaction() async {}

  bool checkifTransactionAvailable(String id) {
    bool result = false;
    offlineTransactions.forEach((element) {
      // print("checking transaction whether exist");
      if (element.id == id) {
        // print("transaction   found");
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

  Future getSpendings(String id) async {
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
  Future createBusinessTransaction(String type) async {
    if (_userController.onlineStatus == OnlineStatus.Onilne) {
      createTransactionOnline(type);
    } else {
      createTransactionOffline(type);
    }
  }

  Future createTransactionOnline(String type) async {
    try {
      _addingTransactionStatus(AddingTransactionStatus.Loading);
      String? fileid;
      String? customerId = null;

      if (quantityController.text.isEmpty) {
        quantityController.text = "1";
      }
      if (image != null) {
        fileid = await _uploadImageController.uploadFile(image!.path);
      }

      if (addCustomer) {
        if (customerType == 1) {
          customerId =
              await _customerController.addBusinessCustomerWithString(type);
        } else {
          if (selectedCustomer != null)
            customerId = selectedCustomer!.customerId;
        }
      } else {
        customerId = null;
      }

      if (time != null && date != null) {
// date!.hour=time!.hour;
        date!.add(Duration(hours: time!.hour, minutes: time!.minute));
        print("date Time to string ${date!.toIso8601String()}");
      }
// String? timeday=date!.toIso8601String();
      String body = jsonEncode({
        "paymentItemRequestList": productList.map((e) => e.toJson("")).toList(),
        "transactionType": type,
        "paymentSource": selectedPaymentSource,
        "businessId": _businessController.selectedBusiness.value!.businessId,
        "paymentMode": selectedPaymentMode,
        "customerId": customerId,
        "businessTransactionFileStoreId": fileid,
        "entyDateTime": (date == null) ? null : date!.toIso8601String(),
        "amountPaid": amountPaidController.text
      });
      print("transaction body $body");
      final response =
          await http.post(Uri.parse(ApiLink.get_business_transaction),
              headers: {
                "Authorization": "Bearer ${_userController.token}",
                "Content-Type": "application/json"
              },
              body: body);

      print({"creatng transaction response ${response.body}"});
      if (response.statusCode == 200) {
        _addingTransactionStatus(AddingTransactionStatus.Success);
        var json = jsonDecode(response.body);
        var result = TransactionModel.fromJson(json['data']);
        Get.to(() => IncomeSuccess(
              transactionModel: result,
              title: "transaction",
            ));
        getOnlineTransaction(
            _businessController.selectedBusiness.value!.businessId!);

        GetOfflineTransactions(
            _businessController.selectedBusiness.value!.businessId!);
// getSpending(_businessController.selectedBusiness.value!.businessId!);
        clearValue();
      } else {
        _addingTransactionStatus(AddingTransactionStatus.Error);
      }
    } catch (ex) {
      print("error occurred ${ex.toString()}");
      _addingTransactionStatus(AddingTransactionStatus.Error);
    }
  }
  TransactionModel? getTransactionById(String id){
    
TransactionModel? result;
offlineTransactions.forEach((element) {
  // print("comparing with ${element.id} to $id");
  if(element.id==id){
result=element;
print("search transaction is found");
return;

  }


});
return result;

  }

  Future createTransactionOffline(String type) async {
    String? fileid;
    String? customerId = null;
    File? outFile;
    if (image != null) {
      var list = await getApplicationDocumentsDirectory();

      Directory appDocDir = list;
      String appDocPath = appDocDir.path;

      String basename = path.basename(image!.path);
      var newPath = appDocPath + basename;
      print("new file path is ${newPath}");
      outFile = File(newPath);
      image!.copySync(outFile.path);
    }

    if (quantityController.text.isEmpty) {
      quantityController.text = "1";
    }
    if (addCustomer) {
      if (customerType == 1) {
        customerId = await _customerController
            .addBusinessCustomerOfflineWithString(type);
      } else {
        if (selectedCustomer != null) customerId = selectedCustomer!.customerId;
      }
    } else {
      customerId = null;
    }

    print("trying to save offline");

    TransactionModel? value;

    var totalamount = 0;
    productList.forEach((element) {
      totalamount = totalamount + (element.totalAmount!);
    });

    value = TransactionModel(
      paymentMethod: selectedPaymentMode,
      paymentSource: selectedPaymentSource,
      id: uuid.v1(),
      totalAmount: totalamount,
      createdTime: DateTime.now(),
      entryDateTime: date,
      transactionType: type,
      businessTransactionFileStoreId: (image == null) ? null : image!.path,
      customerId: customerId,
      businessId: _businessController.selectedBusiness.value!.businessId,
      businessTransactionPaymentItemList: productList,
      isPending: true,
    );

    print("offline saving to database ${value.toJson()}}");
    await _businessController.sqliteDb.insertTransaction(value);
    GetOfflineTransactions(
        _businessController.selectedBusiness.value!.businessId!);
    Get.to(() => IncomeSuccess(
          transactionModel: value!,
          title: "Transaction",
        ));
    clearValue();
  }

  Future checkIfTransactionThatIsYetToBeAdded() async {
    print("hoping transaction to be added");
    var list = await _businessController.sqliteDb.getOfflineTransactions(
        _businessController.selectedBusiness.value!.businessId!);
    print("number of transaction is ${list.length}");
    list.forEach((element) {
      if (element.isPending) {
        pendingTransactionToBeAdded.add(element);
        print("is pending to be added");
      }
    });
    print(
        "number of transaction that is yet to saved on server is ${pendingTransactionToBeAdded.length}");
    saveTransactionOnline();
  }

  Future saveTransactionOnline() async {
    if (pendingTransactionToBeAdded.isEmpty) {
      return;
    }

// pendingTransaction.forEach((e)async{
    print("loading transaction to server ");
    try {
// if(!isBusyAdding){
      var savenext = pendingTransactionToBeAdded.first;
      isBusyAdding = true;
      print("saved next is ${savenext.toJson()}");
      if (savenext.customerId != null && savenext.customerId != " ") {
        print("saved yet customer is not null");

        var customervalue = await _businessController.sqliteDb
            .getOfflineCustomer(savenext.customerId!);
        if (customervalue != null && customervalue.isCreatedFromTransaction!) {
          String? customerId = await _customerController
              .addBusinessCustomerWithString(savenext.transactionType!);
          savenext.customerId = customerId;
          _businessController.sqliteDb.deleteCustomer(customervalue);
        } else {
          print("saved yet customer is null");
        }
      }
      if (savenext.businessTransactionFileStoreId != null &&
          savenext.businessTransactionFileStoreId != '') {
        String image = await _uploadImageController
            .uploadFile(savenext.businessTransactionFileStoreId!);

        File _file = File(savenext.businessTransactionFileStoreId!);
        savenext.businessTransactionFileStoreId = image;
        _file.deleteSync();
      }

      String body = jsonEncode({
        "paymentItemRequestList": savenext.businessTransactionPaymentItemList!
            .map((e) => e.toJson(""))
            .toList(),
        "transactionType": savenext.transactionType,
        "paymentSource": savenext.paymentSource,
        "businessId": savenext.businessId,
        "paymentMode": savenext.paymentMethod,
        "customerId": savenext.customerId,
        "businessTransactionFileStoreId":
            savenext.businessTransactionFileStoreId,
        "entyDateTime": savenext.entryDateTime!.toIso8601String(),
        "amountPaid": savenext.totalAmount,
      });
      print("transaction body $body");
      final response =
          await http.post(Uri.parse(ApiLink.get_business_transaction),
              headers: {
                "Authorization": "Bearer ${_userController.token}",
                "Content-Type": "application/json"
              },
              body: body);

      print({"sending to server transaction response ${response.body}"});
      await deleteItem(savenext);
      pendingTransactionToBeAdded.remove(savenext);
      if (response.statusCode == 200) {
        print("transaction response ${response.body}");
// pendingTransaction.remove(savenext);

// deletedItem.add(savenext);
        // saveTransactionOnline();

        if (pendingTransactionToBeAdded.isNotEmpty) {
          print("saved size  left is ${pendingTransactionToBeAdded.length}");
          saveTransactionOnline();
          // await GetOfflineTransactions(_businessController.selectedBusiness.value!.businessId!);
          //  getOnlineTransaction(_businessController.selectedBusiness.value!.businessId!);

// getSpending(_businessController.selectedBusiness.value!.businessId!);
        } else {
          print("done uploading  transaction to server ");
          await GetOfflineTransactions(
              _businessController.selectedBusiness.value!.businessId!);
          getOnlineTransaction(
              _businessController.selectedBusiness.value!.businessId!);
        }
        isBusyAdding = false;
      } else {
        isBusyAdding = false;

//   print("pending transaction is uploaded finished");
//   deleteItems();

        Future.delayed(Duration(seconds: 5));
      }
    } catch (ex) {}
  }

  Future deleteItem(TransactionModel model) async {
    await _businessController.sqliteDb.deleteOfflineTransaction(model);
  }

  void deleteItems() {
    deletedItem.forEach((element) {
      _businessController.sqliteDb.deleteOfflineTransaction(element);
    });
  }

  clearValue() {
    print("clearing value");
    itemNameController.text = "";
    amountController.text = "";
    quantityController.text = "";
    dateController.text = "";
    timeController.text = "";
    paymentController.text = "";
    paymentSourceController.text = "";
    receiptFileController.text = "";
    amountPaidController.text = "";
    date = null;
    image = null;
    selectedPaymentMode = null;
    selectedCustomer = null;
    selectedPaymentSource = null;
    selectedProduct = null;
    productList = [];
  }

  Future calculateOverView() async {
    var todayBalance = 0;
    var todayMoneyIn = 0;
    var todayMoneyout = 0;

    todayTransaction.forEach((element) {
      if (element.totalAmount == null) {
        return;
      }
      if (element.transactionType == "INCOME") {
        todayMoneyIn = todayMoneyIn + element.totalAmount!;
      } else {
        print("total amount is ${element.totalAmount} ${element.toJson()}");
        todayMoneyout = todayMoneyout + element.totalAmount!;
      }
    });
    todayBalance = todayMoneyIn - todayMoneyout;
    income(todayMoneyIn);
    expenses(todayMoneyout);
    totalbalance(todayBalance);
  }

  void addMoreProduct() {
    if (selectedValue == 0) {
      if (selectedProduct != null)
        productList.add(PaymentItem(
            productId: selectedProduct!.productId!,
            itemName: selectedProduct!.productName,
            amount: (amountController.text.isEmpty)
                ? selectedProduct!.sellingPrice
                : int.parse(amountController.text),
            totalAmount: (amountController.text.isEmpty)
                ? (selectedProduct!.sellingPrice! *
                    (quantityController.text.isEmpty
                        ? 1
                        : int.parse(quantityController.text)))
                : int.parse(amountController.text) *
                    (quantityController.text.isEmpty
                        ? 1
                        : int.parse(quantityController.text)),
            quality: (quantityController.text.isEmpty)
                ? 1
                : int.parse(quantityController.text)));
    } else {
      if (itemNameController.text.isNotEmpty &&
          amountController.text.isNotEmpty)
        productList.add(PaymentItem(
            itemName: itemNameController.text,
            quality: int.parse(quantityController.text),
            amount: int.parse(amountController.text),
            totalAmount: int.parse(amountController.text) *
                int.parse(quantityController.text)));
    }

    selectedProduct = null;
    quantityController.text = "1";
    amountController.text = "";
    itemNameController.text = "";
  }

  Future selectEditValue(PaymentItem item) async {
    quantityController.text = item.quality.toString();
    amountController.text = item.amount.toString();
    itemNameController.text = item.itemName!;
  }

  Future updatePaymetItem(PaymentItem item, int index) async {
    item.itemName = itemNameController.text;
    item.quality = int.parse(quantityController.text);
    item.amount = int.parse(amountController.text);
    productList[index] = item;
    quantityController.text = "1";
    amountController.text = "";
    itemNameController.text = "";
  }

  Future setValue(PaymentItem item) async {
    if (item.productId == null || item.productId!.isEmpty) {
      quantityController.text = item.quality.toString();
      amountController.text = item.amount.toString();
      itemNameController.text = item.itemName!;
      selectedValue = 1;
    } else {
      selectedValue = 0;
      selectedProduct = _productController.productGoods
          .where((element) => element.productId == item.productId)
          .toList()
          .first;
    }
  }
  Future updatePaymentHistoryOnline(String transactionId,String businessId,int amount,String mode)async{
  try{
    print("business id is $businessId");
    _addingTransactionStatus(AddingTransactionStatus.Loading);
var response=await http.put(Uri.parse(ApiLink.get_business_transaction+"/"+transactionId),
body: jsonEncode({
  "businessTransactionRequest": {
        "businessId":  _businessController.selectedBusiness.value!.businessId!
    },
    "paymentHistoryRequest": {
        "amountPaid":amount,
        "paymentMode":mode
    }

}),
headers: {
     "Authorization": "Bearer ${_userController.token}",
                "Content-Type": "application/json"
});
print("update payment history response ${response.body}");
if(response.statusCode==200){

//         
var json=jsonDecode(response.body);
var transactionReponse=TransactionModel.fromJson(json['data']);
updateTransaction(transactionReponse);

}else{
Get.snackbar("Error", "Unable to Update Transaction");

}
  



  }catch(ex){
 _addingTransactionStatus(AddingTransactionStatus.Empty);



  }finally{

 _addingTransactionStatus(AddingTransactionStatus.Empty);
 Get.back();
  }



  }
  Future updatePaymentHistoryOffline(String transactionId,String businessId,int amount,String mode)async{

try{
    _addingTransactionStatus(AddingTransactionStatus.Loading);
var transaction=getTransactionById(transactionId);
var transactionList=transaction!.businessTransactionPaymentHistoryList;
transactionList!.add(PaymentHistory(

  id: uuid.v1(),
  isPendingUpdating: true,
  amountPaid: amount,
  paymentMode: mode,
  createdDateTime: DateTime.now(),
  updateDateTime: DateTime.now(),
  deleted: false,
  businessTransactionId: transactionId
));

transaction.isHistoryPending=true;
transaction.businessTransactionPaymentHistoryList=transactionList;
updateTransaction(transaction);
}catch(ex){
 _addingTransactionStatus(AddingTransactionStatus.Empty);
}finally{

 _addingTransactionStatus(AddingTransactionStatus.Empty);
 Get.back();
  
}

  }
  Future updateTransaction(TransactionModel transactionModel)async{
    _businessController.sqliteDb.updateOfflineTransaction(transactionModel);
  await GetOfflineTransactions(
              _businessController.selectedBusiness.value!.businessId!);
  }

Future updateTransactionHistory(String transactionId,String businessId,int amount,String mode)async{
  if (_userController.onlineStatus == OnlineStatus.Onilne) {
      updatePaymentHistoryOnline(transactionId,businessId, amount, mode);
    } else {
    updatePaymentHistoryOffline(transactionId, businessId,amount,mode);
    }


}
 Future checkPendingTransactionbeUpdatedToServer() async {
    var list = await _businessController.sqliteDb.getOfflineTransactions(
        _businessController.selectedBusiness.value!.businessId!);
    list.forEach((element) {
      if (element.isHistoryPending! && !element.isPending) {
        pendingJobToBeUpdated.add(element);
      }
    });
pendingTransactionToBeUpdate();
   
  }
  Future pendingTransactionToBeUpdate()async{
if(pendingJobToBeUpdated.isEmpty){
  return;
}
var updatedNext=pendingJobToBeUpdated[0];
try{
  updatedNext.businessTransactionPaymentHistoryList!.forEach((element) async{
    if(element.isPendingUpdating!){
   var response=await http.put(Uri.parse(ApiLink.get_business_transaction+"/"+updatedNext.id!),
body: jsonEncode({
  "businessTransactionRequest": {
        "businessId":updatedNext.businessId
    },
    "paymentHistoryRequest": {
        "amountPaid":element.amountPaid,
        "paymentMode":element.paymentMode
    }

}),
headers: {
     "Authorization": "Bearer ${_userController.token}",
                "Content-Type": "application/json"
}); 
    }

  });
  

}catch(ex){

}finally{
  pendingJobToBeUpdated.remove(updatedNext);
if(pendingJobToBeUpdated.isNotEmpty){

  checkPendingTransactionbeUpdatedToServer();
}
  getOnlineTransaction(
              _businessController.selectedBusiness.value!.businessId!);



}

  }

Future deleteTransactionOnline(TransactionModel transactionModel)async{

try{
var response=await http.delete(Uri.parse(ApiLink.get_business_transaction+"/"+transactionModel.id!),headers: {

       "Authorization": "Bearer ${_userController.token}",
                "Content-Type": "application/json"
});
print("transaction detail response ${response.body}}");

if(response.statusCode==200){

await _businessController.sqliteDb.deleteOfflineTransaction(transactionModel);

 await GetOfflineTransactions(
              _businessController.selectedBusiness.value!.businessId!);
Get.back();
}else if(response.statusCode==404){


await _businessController.sqliteDb.deleteOfflineTransaction(transactionModel);

 await GetOfflineTransactions(
              _businessController.selectedBusiness.value!.businessId!);
Get.back();
}

}catch(ex){



}

}
Future deleteTransactionOffline(TransactionModel transactionModel)async{
transactionModel.deleted=true;
if(transactionModel.isPending){
  _businessController.sqliteDb.deleteOfflineTransaction(transactionModel);
 await GetOfflineTransactions(
              _businessController.selectedBusiness.value!.businessId!);
}else{
updateTransaction(transactionModel);
}
Get.back();

}

Future deleteTransaction(TransactionModel transactionModel)async{
  if (_userController.onlineStatus == OnlineStatus.Onilne) {
     deleteTransactionOnline(transactionModel);
    } else {
   deleteTransactionOffline(transactionModel);
    }
}

  Future checkPendingTransactionToBeDeletedOnServer() async {
    print("checking transaction to be deleted");
    var list = await _businessController.sqliteDb.getOfflineTransactions(
        _businessController.selectedBusiness.value!.businessId!);
    print("checking transaction to be deleted list ${list.length}");
    list.forEach((element) {
      if (element.deleted!) {
        pendingJobToBeDelete.add(element);
        print("Transaction to be deleted is found ");
      }
    });
    print("Transaction to be deleted ${pendingJobToBeDelete.length}");
    deletePendingJobToServer();
  }
  Future deletePendingJobToServer()async{

try{
if(pendingJobToBeDelete.isEmpty)
return;

var deleteNext=pendingJobToBeDelete[0];
var response=await http.delete(Uri.parse(ApiLink.get_business_transaction+"/"+deleteNext.id!),headers: {
       "Authorization": "Bearer ${_userController.token}",
                "Content-Type": "application/json"
});
if(response.statusCode==200){

_businessController.sqliteDb.deleteOfflineTransaction(deleteNext);}
pendingJobToBeDelete.remove(deleteNext);

  }catch(ex){


  }finally{
if(pendingJobToBeDelete.isNotEmpty){
  deletePendingJobToServer();
}else{
 await GetOfflineTransactions(
              _businessController.selectedBusiness.value!.businessId!);

}


  }
  }
}
