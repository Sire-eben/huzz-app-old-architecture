import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';
import 'package:huzz/core/util/util.dart';
import 'package:huzz/data/repository/bank_account_repository.dart';
import 'package:huzz/data/repository/business_repository.dart';
import 'package:huzz/data/repository/file_upload_repository.dart';
import 'package:huzz/data/repository/miscellaneous_repository.dart';
import 'package:huzz/data/repository/product_repository.dart';
import 'package:huzz/data/api_link.dart';
import 'package:huzz/presentation/invoice/preview_invoice.dart';
import 'package:huzz/data/model/bank.dart';
import 'package:huzz/data/model/customer_model.dart';
import 'package:huzz/data/model/invoice.dart';
import 'package:huzz/data/model/payment_history.dart';
import 'package:huzz/data/model/payment_item.dart';
import 'package:huzz/data/model/product.dart';
import 'package:http/http.dart' as http;
import 'package:huzz/data/model/transaction_model.dart';
import 'package:huzz/data/sqlite/sqlite_db.dart';
import 'package:uuid/uuid.dart';
import 'auth_repository.dart';
import 'customer_repository.dart';

enum AddingInvoiceStatus { Loading, Error, Success, Empty }

enum InvoiceStatus { Loading, Error, Available, Empty, UnAuthorized }

class InvoiceRepository extends GetxController {
  final Rx<List<Invoice>> _offlineInvoices = Rx([]);
  List<Invoice> get offlineInvoices => _offlineInvoices.value;
  final _uploadImageController = Get.find<FileUploadRepository>();
  final _customerController = Get.find<CustomerRepository>();
  final _productController = Get.find<ProductRepository>();
  // ignore: non_constant_identifier_names
  List<Invoice> OnlineInvoice = [];
  List<Invoice> pendingInvoice = [];
  final Rx<List<PaymentItem>> _allPaymentItem = Rx([]);
  List<PaymentItem> get allPaymentItem => _allPaymentItem.value;

  final _userController = Get.find<AuthRepository>();
  final _businessController = Get.find<BusinessRepository>();

  final expenses = 0.obs;
  final income = 0.obs;
  final numberOfIncome = 0.obs;
  final numberOfExpenses = 0.obs;
  final totalBalance = 0.obs;
  bool isBusyAdding = false;
  bool isBusyUpdating = false;
  bool isBusyDeleting = false;
  final debtors = 0.obs;
  List<PaymentItem> productList = [];
  List<Invoice> todayInvoice = [];
  SqliteDb sqliteDb = SqliteDb();
  final itemNameController = TextEditingController();
  MoneyMaskedTextController amountController = MoneyMaskedTextController(
      decimalSeparator: '.', thousandSeparator: ',', precision: 1);
  final quantityController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final paymentController = TextEditingController();
  final paymentSourceController = TextEditingController();
  final receiptFileController = TextEditingController();
  MoneyMaskedTextController amountPaidController = MoneyMaskedTextController(
      decimalSeparator: '.', thousandSeparator: ',', precision: 1);
  final taxController = TextEditingController();
  final discountController = TextEditingController();
  final noteController = TextEditingController();
  Bank? invoiceBank;
  // final TextEditingController dateController = TextEditingController();
  // final TextEditingController timeController = TextEditingController();
  final TextEditingController contactName = TextEditingController();
  final TextEditingController contactPhone = TextEditingController();
  final TextEditingController contactMail = TextEditingController();
  List<Invoice> deletedItem = [];
  final _addingInvoiceStatus = AddingInvoiceStatus.Empty.obs;
  final _invoiceStatus = InvoiceStatus.Empty.obs;

  var uuid = const Uuid();
  final _bankController = Get.find<BankAccountRepository>();
// final _uploadFileController=Get.find<FileUploadRepository>();
  AddingInvoiceStatus get addingInvoiceStatus => _addingInvoiceStatus.value;
  InvoiceStatus get invoiceStatus => _invoiceStatus.value;

  Product? selectedProduct;
  Bank? selectedBank;
  int? remain;
  Customer? selectedCustomer;
  DateTime? date;
  TimeOfDay? time;
  File? image;
  int selectedValue = 0;
  int customerType = 0;
  int paymentValue = 0;
  bool addCustomer = false;
  List<String> paymentSource = ["POS", "CASH", "TRANSFER", "OTHERS"];
  String? selectedPaymentSource;
  List<String> paymentMode = ["FULLY_PAID", "DEPOSIT"];
  String? selectedPaymentMode;
  List<Invoice> pendingInvoiceToBeAdded = [];
  final _miscellaneousController = Get.find<MiscellaneousRepository>();
  final Rx<List<Invoice>> _paidInvoiceList = Rx([]);
  final Rx<List<Invoice>> _invoicePendingList = Rx([]);
  final Rx<List<Invoice>> _invoiceDepositList = Rx([]);
  final Rx<List<Invoice>> _invoiceDueList = Rx([]);
  List<Invoice> get paidInvoiceList => _paidInvoiceList.value;
  List<Invoice> get invoicePendingList => _invoicePendingList.value;
  List<Invoice> get invoiceDepositList => _invoiceDepositList.value;
  List<Invoice> get invoiceDueList => _invoiceDueList.value;
  List<Invoice> pendingUpdatedInvoiceList = [];
  List<Invoice> pendingJobToBeUpdated = [];
  // final bankName=TextEditingController();
  // final bankAccountNumber=TextEditingController();
  // final bankAccountName=TextEditingController();

  @override
  void onInit() async {
    super.onInit();
    // TODO: implement onInit
    // print("getting Invoice repo");

    _miscellaneousController.businessTransactionPaymentSourceList.listen((p0) {
      if (p0.isNotEmpty) {
        paymentSource = p0;
      }
    });

    _miscellaneousController.businessTransactionPaymentModeList.listen((p0) {
      if (p0.isNotEmpty) {
        paymentMode = p0;
      }
    });
    _userController.mToken.listen((p0) {
      // print("token gotten $p0");
      if (p0.isNotEmpty || p0 != "0") {
        final value = _businessController.selectedBusiness.value;
        if (value != null && value.businessId != null) {
          getOnlineInvoice(value.businessId!);

          // getSpending(value.businessId!);

          getOfflineInvoices(value.businessId!);
        } else {
          // print("current business is null");
        }
        _businessController.selectedBusiness.listen((p0) {
          if (p0 != null && p0.businessId != null) {
            amountController = MoneyMaskedTextController(
                leftSymbol: '${Utils.getCurrency()} ',
                decimalSeparator: '.',
                thousandSeparator: ',',
                precision: 1);

            amountPaidController = MoneyMaskedTextController(
                leftSymbol: '${Utils.getCurrency()} ',
                decimalSeparator: '.',
                thousandSeparator: ',',
                precision: 1);
            // print("business id ${p0.businessId}");
            _offlineInvoices([]);
            _allPaymentItem([]);
            OnlineInvoice = [];
            getOnlineInvoice(p0.businessId!);

            getOfflineInvoices(p0.businessId!);

            // getSpending(p0.businessId!);

          }
        });
      }
    });
    _userController.monLineStatus.listen((po) {
      if (po == OnlineStatus.Onilne) {
        _businessController.selectedBusiness.listen((p0) {
          checkIfInvoiceThatIsYetToBeAdded();
          checkPendingTransactionBeUpdatedToServer();
          //update server with pending job
        });
      }
    });
  }

  // Future getAllPaymentItem() async {
  //   if (todayInvoice.isEmpty) return;
  //   List<PaymentItem> items = [];
  //   todayInvoice.forEach((element) {
  //     items.addAll(element.is!);
  //   });

  //   _allPaymentItem(items);
  // }

  Future getOnlineInvoice(String businessId) async {
    try {
      _invoiceStatus(InvoiceStatus.Loading);
      var response = await http.get(
          Uri.parse(ApiLink.invoiceLink + "?businessId=" + businessId),
          headers: {"Authorization": "Bearer ${_userController.token}"});
      var json = jsonDecode(response.body);
      // print("get online Invoice $json");
      if (response.statusCode == 200) {
        var result = List.from(json['data']).map((e) => Invoice.fromJson(e));

        OnlineInvoice.addAll(result);
        // print("online Invoice ${result.length}");
        // getTodayInvoice();
        getInvoiceYetToBeSavedLocally();
        result.isNotEmpty
            ? _invoiceStatus(InvoiceStatus.Available)
            : _invoiceStatus(InvoiceStatus.Empty);
      } else if (response.statusCode == 500) {
        _invoiceStatus(InvoiceStatus.UnAuthorized);
      } else {
        _invoiceStatus(InvoiceStatus.Error);
      }
    } catch (error) {
      // print(error.toString());
      _invoiceStatus(InvoiceStatus.Error);
    }
  }

  Future getOfflineInvoices(String id) async {
    try {
      _invoiceStatus(InvoiceStatus.Loading);
      var results = await _businessController.sqliteDb.getOfflineInvoices(id);
      // print("offline Invoice ${results.length}");

      _offlineInvoices(results.reversed.toList());
      categorizedInvoice();
      results.isNotEmpty
          ? _invoiceStatus(InvoiceStatus.Available)
          : _invoiceStatus(InvoiceStatus.Empty);
    } catch (error) {
      (error.toString());
      _invoiceStatus(InvoiceStatus.Error);
    }
  }

  Future categorizedInvoice() async {
    // print("invoice list to be category is ${offlineInvoices.length}");
    List<Invoice> _pending = [];
    List<Invoice> _paid = [];
    List<Invoice> _deposit = [];
    List<Invoice> _overDue = [];

    for (int i = 0; i < offlineInvoices.length; ++i) {
      var element = offlineInvoices[i];
      // print("invoice status ${offlineInvoices[i].businessInvoiceStatus}");
      if (element.businessInvoiceStatus == "PENDING") {
        // print("pending is found");
        _pending.add(element);

        // print("found pending");
      } else if (element.businessInvoiceStatus == "PAID") {
        // print("found paid");
        _paid.add(element);
      } else if (element.businessInvoiceStatus == "DEPOSIT") {
        // print("found deposit");
        _deposit.add(element);
      }
      if (element.dueDateTime!.isBefore(DateTime.now())) {
        _overDue.add(element);
      }
//    if(element.businessInvoiceStatus=="OVERDUE" || element.dueDateTime!.isAfter(DateTime.now())){
//     // print("found overdue");
// _overDue.add(element);

//   }

    }
//    await Future.forEach<Invoice>(offlineInvoices, (element){
//  // print("invoice status ${element.businessInvoiceStatus}");
//  if(element.businessInvoiceStatus=="PENDING"){
// // _pending.add(element);

// print("found pending");
//   }else if(element.businessInvoiceStatus=="PAID"){
// print("found paid");
// // _paid.add(element);

//   }else if(element.businessInvoiceStatus=="DEPOSIT"){
// print("found deposit");
// // _deposit.add(element);

//   }
//    if(element.businessInvoiceStatus=="OVERDUE" || element.dueDateTime!.isAfter(DateTime.now())){

// // _overDue.add(element);

//   }

//     });

    _invoicePendingList(_pending);
    _paidInvoiceList(_paid);
    _invoiceDepositList(_deposit);
    _invoiceDueList(_overDue);
  }

  // Future getTodayInvoice() async {
  //   List<Invoice> _todayInvoice = [];
  //   final date = DateTime.now();
  //   offlineInvoices.forEach((element) {
  //     // print("element test date ${element.createdTime!.toIso8601String()}");
  //     final d = DateTime(element.createdTime!.year, element.createdTime!.month,
  //         element.createdTime!.day);
  //     if (d.isAtSameMomentAs(DateTime(date.year, date.month, date.day))) {
  //       _todayInvoice.add(element);

  //       // print("found date for today");
  //     }
  //   });
  //   todayInvoice = _todayInvoice;
  //   getAllPaymentItem();
  //   calculateOverView();
  // }

  Future getInvoiceYetToBeSavedLocally() async {
    for (var element in OnlineInvoice) {
      if (!checkIfInvoiceAvailable(element.id!)) {
        if (!element.isPending!) pendingInvoice.add(element);
      }
    }
    // print("does contain value ${pendingInvoice.first.isPending}");
    // print("item yet to be save yet ${pendingInvoice.length}");
    savePendingJob();
  }

  Future pendingInvoices() async {}

  bool checkIfInvoiceAvailable(String id) {
    bool result = false;
    for (var element in offlineInvoices) {
      // print("checking Invoice whether exist");
      if (element.id == id) {
        // print("Invoice   found");
        result = true;
      }
    }
    return result;
  }

  Future savePendingJob() async {
    if (pendingInvoice.isEmpty) {
      return;
    }
    var saveNext = pendingInvoice.first;
    await _businessController.sqliteDb.insertInvoice(saveNext);
    pendingInvoice.remove(saveNext);
    if (pendingInvoice.isNotEmpty) {
      savePendingJob();
    }
    getOfflineInvoices(saveNext.businessId!);
  }

  Future getSpending(String id) async {
    final now = DateTime.now();
    var day = now.day >= 10 ? now.day.toString() : "0" + now.day.toString();
    var month =
        now.month >= 10 ? now.month.toString() : "0" + now.month.toString();
    final date = "" + now.year.toString() + "-" + month + "-" + day;
    // print("today date is $date");
    final response = await http.get(
        Uri.parse(ApiLink.dashboardOverview +
            "?businessId=" +
            id +
            "&from=$date 00:00&to=$date 23:59"),
        headers: {"Authorization": "Bearer ${_userController.token}"});
    var json = jsonDecode(response.body);
    // print("overview result $json");
    if (response.statusCode == 200) {
      var totalIncome = json['data']['totalIncomeAmount'];
      var totalExpenses = json['data']['totalExpenditureAmount'];
      var balance = json['data']['differences'];
      var numberOfIncome = json['data']['numberOfIncomeInvoices'];
      var numberOfExpenses = json['data']['numberOfExpenditureInvoices'];
      var debtor = json['totalIncomeBalanceAmount'] ?? 0;
      income(totalIncome);
      expenses(totalExpenses);
      totalBalance(balance);
      numberOfExpenses(numberOfExpenses);
      numberOfIncome(numberOfIncome);
      debtors(debtor);
    }
  }

//   Future createInvoice(String type) async {
//     try {
//       _addingInvoiceStatus(AddingInvoiceStatus.Loading);
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
//         // print("date Time to string ${date!.toIso8601String()}");
//       }
// // String? timeday=date!.toIso8601String();
//       String body = jsonEncode({
//         "paymentItemRequestList": productList,
//         "InvoiceType": type,
//         "paymentSource": selectedPaymentSource,
//         "businessId": _businessController.selectedBusiness.value!.businessId,
//         "paymentMode": selectedPaymentMode,
//         "customerId": customerId,
//         "businessInvoiceFileStoreId": fileid,
//         "entyDateTime": date!.toIso8601String()
//       });
//       // print("Invoice body $body");
//       final response =
//           await http.post(Uri.parse(ApiLink.get_business_Invoice),
//               headers: {
//                 "Authorization": "Bearer ${_userController.token}",
//                 "Content-Type": "application/json"
//               },
//               body: body);

//       print({"creatng Invoice response ${response.body}"});
//       if (response.statusCode == 200) {
//         _addingInvoiceStatus(AddingInvoiceStatus.Success);
//         Get.to(() => IncomeSuccess());
//         getOnlineInvoice(
//             _businessController.selectedBusiness.value!.businessId!);

//         GetOfflineInvoices(
//             _businessController.selectedBusiness.value!.businessId!);
//         getSpending(_businessController.selectedBusiness.value!.businessId!);
//       } else {
//         _addingInvoiceStatus(AddingInvoiceStatus.Error);
//       }
//     } catch (ex) {
//       // print("error occurred ${ex.toString()}");
//       _addingInvoiceStatus(AddingInvoiceStatus.Error);
//     }
//   }
  Future createBusinessInvoice() async {
    if (_userController.onlineStatus == OnlineStatus.Onilne) {
      createInvoiceOnline();
    } else {
      createInvoiceOffline();
    }
  }

  Future createInvoiceOnline() async {
    try {
      _addingInvoiceStatus(AddingInvoiceStatus.Loading);
      String? customerId;

      if (quantityController.text.isEmpty) {
        quantityController.text = "1";
      }

      if (customerType == 1) {
        customerId =
            await _customerController.addBusinessCustomerWithString("INCOME");
      } else {
        if (selectedCustomer != null) customerId = selectedCustomer!.customerId;
      }

      if (time != null && date != null) {
// date!.hour=time!.hour;
        date!.add(Duration(hours: time!.hour, minutes: time!.minute));
        // print("date Time to string ${date!.toIso8601String()}");
      }
      double tax = 0;
      dynamic totalAmount = 0;
      for (var element in productList) {
        totalAmount = totalAmount + element.totalAmount!;
      }
      if (taxController.text.isNotEmpty) {
        tax = (double.parse(taxController.text) * totalAmount) / 100;
      }

      double discount = 0;

      if (discountController.text.isNotEmpty) {
        discount = (double.parse(discountController.text) * totalAmount) / 100;
      }
      String? bankselectedId;
      if (paymentValue == 1) {
        bankselectedId = await _bankController.addBusinessBankWithString();
        // print("addied bank id is $bankselectedId");
      } else {
        bankselectedId = selectedBank!.id;
      }
      double newTotalAmount = totalAmount + tax - discount;

      String body = jsonEncode({
        "paymentItemRequestList": productList.map((e) => e.toJson("")).toList(),
        "paymentSource": selectedPaymentSource,
        "businessId": _businessController.selectedBusiness.value!.businessId,
        "paymentMode": selectedPaymentMode,
        "customerId": customerId,
        "tax": tax,
        "note": noteController.text,
        "discountAmount": discount,
        "totalAmount": newTotalAmount,
        "bankInfoId": bankselectedId,
        "dueDateTime": date!.toIso8601String().split("T")[0] + " 00:00"
      });
      // print("Invoice body $body");
      final response = await http.post(Uri.parse(ApiLink.invoiceLink),
          headers: {
            "Authorization": "Bearer ${_userController.token}",
            "Content-Type": "application/json"
          },
          body: body);

      // print({"creating Invoice response ${response.body}"});
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        var result = Invoice.fromJson(json['data']);
        result.paymentItemRequestList = productList;
        // print("second result is ${result.toJson()}");

        //  Get.to(() => IncomeSuccess(Invoice: result,title: "Invoice",));
        await getOnlineInvoice(
            _businessController.selectedBusiness.value!.businessId!);

        getOfflineInvoices(
            _businessController.selectedBusiness.value!.businessId!);
        _addingInvoiceStatus(AddingInvoiceStatus.Success);
        clearValue();
        Get.to(() => PreviewInvoice(invoice: result));
      } else {
        Get.snackbar("Error", "Error creating invoice, try again!");
        _addingInvoiceStatus(AddingInvoiceStatus.Error);
      }
    } catch (ex) {
      // print("error occurred ${ex.toString()}");
      _addingInvoiceStatus(AddingInvoiceStatus.Error);
    }
  }

  Future createInvoiceOffline() async {
    String? customerId;

    if (quantityController.text.isEmpty) {
      quantityController.text = "1";
    }

    if (customerType == 1) {
      customerId = await _customerController
          .addBusinessCustomerOfflineWithString("INCOME");
    } else {
      if (selectedCustomer != null) customerId = selectedCustomer!.customerId;
    }
    double tax = 0;
    dynamic totalAmount = 0;
    for (var element in productList) {
      totalAmount = totalAmount + element.totalAmount!;
    }
    if (taxController.text.isNotEmpty) {
      tax = (double.parse(taxController.text) * totalAmount) / 100;
    }

    double discount = 0;

    if (discountController.text.isNotEmpty) {
      discount = (double.parse(discountController.text) * totalAmount) / 100;
    }
    double newTotalAmount = totalAmount + tax - discount;

    // print("trying to save offline");

    Invoice? value;
    String? bankselectedId;
    if (paymentValue == 1) {
      bankselectedId = await _bankController.addBusinessBankOfflineWithString();
    } else {
      bankselectedId = selectedBank!.id;
    }

    value = Invoice(
        id: uuid.v1(),
        totalAmount: newTotalAmount,
        createdDateTime: DateTime.now(),
        insuranceDateTime: DateTime.now(),
        customerId: customerId,
        businessId: _businessController.selectedBusiness.value!.businessId,
        paymentItemRequestList: productList,
        isPending: true,
        tax: tax,
        note: noteController.text,
        discountAmount: discount,
        bankId: bankselectedId,
        dueDateTime: date,
        businessTransaction: TransactionModel(
          balance: 0,
          id: uuid.v1(),
          createdTime: DateTime.now(),
          entryDateTime: DateTime.now(),
          transactionType: "INCOME",
          paymentSource: "CASH",
          customerId: customerId,
          businessId: _businessController.selectedBusiness.value!.businessId,
          deleted: false,
          paymentMethod: "FULLY_PAID",
          isPending: false,
          totalAmount: newTotalAmount.toInt(),
        ));

    // print("offline saving to database ${value.toJson()}}");
    await _businessController.sqliteDb.insertInvoice(value);
    getOfflineInvoices(_businessController.selectedBusiness.value!.businessId!);
    // Get.to(() => IncomeSuccess(Invoice: value!,title: "Invoice",));
    Get.to(() => PreviewInvoice(invoice: value!));
    clearValue();
  }

  Future checkIfInvoiceThatIsYetToBeAdded() async {
    // print("hoping Invoice to be added");
    var list = await _businessController.sqliteDb.getOfflineInvoices(
        _businessController.selectedBusiness.value!.businessId!);
    // print("number of Invoice is ${list.length}");
    for (var element in list) {
      if (element.isPending!) {
        pendingInvoiceToBeAdded.add(element);
        // print("is pending to be added");
      }
    }
    /**
      print(
          "number of Invoice that is yet to saved on server is ${pendingInvoiceToBeAdded.length}");
    */
    saveInvoiceOnline();
  }

  bool checkIfSelectedForDeleted(String id) {
    bool result = false;
    for (var element in deletedItem) {
      // print("checking transaction whether exist");
      if (element.id == id) {
        // print("Invoice added to delete list   found");
        result = true;
      }
    }
    return result;
  }

  Future saveInvoiceOnline() async {
    if (pendingInvoiceToBeAdded.isEmpty) {
      return;
    }

// pendingInvoice.forEach((e)async{
    // print("loading Invoice to server ");
    try {
// if(!isBusyAdding){
      var savenext = pendingInvoiceToBeAdded.first;
      isBusyAdding = true;
      // print("saved next is ${savenext.toJson()}");
      if (savenext.customerId != null && savenext.customerId != " ") {
        // print("saved yet customer is not null");

        var customervalue = await _businessController.sqliteDb
            .getOfflineCustomer(savenext.customerId!);
        if (customervalue != null && customervalue.isCreatedFromInvoice!) {
          String? customerId = await _customerController
              .addBusinessCustomerWithStringWithValue(customervalue);
          savenext.customerId = customerId;
          _businessController.sqliteDb.deleteCustomer(customervalue);
        } else {
          // print("saved yet customer is null");
        }
      }
// if(savenext.businessInvoiceFileStoreId!=null&& savenext.businessInvoiceFileStoreId!=''){

//   String image=await _uploadImageController.uploadFile(savenext.businessInvoiceFileStoreId!);

//   File _file=File(savenext.businessInvoiceFileStoreId!);
//   savenext.businessInvoiceFileStoreId=image;
//   _file.deleteSync();

// }
      var firstItem = savenext
          .businessTransaction!.businessTransactionPaymentHistoryList![0];
      // print("server first payment is ${firstItem.toJson()} ");

      savenext.businessTransaction!.businessTransactionPaymentHistoryList!
          .remove(firstItem);
      String body = jsonEncode({
        "paymentItemRequestList":
            savenext.paymentItemRequestList!.map((e) => e.toJson("")).toList(),
        "businessId": savenext.businessId,
        "customerId": savenext.customerId,
        "amountPaid": savenext.totalAmount,
        "bankInfoId": savenext.bankId,
        "dueDateTime":
            savenext.dueDateTime!.toIso8601String().split("T")[0] + " 00:00"
      });
      // print("Invoice body $body");
      final response = await http.post(Uri.parse(ApiLink.invoiceLink),
          headers: {
            "Authorization": "Bearer ${_userController.token}",
            "Content-Type": "application/json"
          },
          body: body);

      ({"sending to server Invoice response ${response.body}"});
      await deleteItem(savenext);
      pendingInvoiceToBeAdded.remove(savenext);
      if (response.statusCode == 200) {
        // print("Invoice response ${response.body}");
// pendingInvoice.remove(savenext);
        var json = jsonDecode(response.body);
        if (savenext.businessTransaction!.businessTransactionPaymentHistoryList!
            .isNotEmpty) {
          var response = Invoice.fromJson(json['data']);
          response.businessTransaction!.businessTransactionPaymentHistoryList =
              savenext
                  .businessTransaction!.businessTransactionPaymentHistoryList!;
          await updateInvoiceHisotryList(response);
        }
// deletedItem.add(savenext);
        // saveInvoiceOnline();

        if (pendingInvoiceToBeAdded.isNotEmpty) {
          // print("saved size  left is ${pendingInvoiceToBeAdded.length}");
          saveInvoiceOnline();
          // await GetOfflineInvoices(_businessController.selectedBusiness.value!.businessId!);
          //  getOnlineInvoice(_businessController.selectedBusiness.value!.businessId!);

// getSpending(_businessController.selectedBusiness.value!.businessId!);
        } else {
          // print("done uploading  Invoice to server ");
          await getOfflineInvoices(
              _businessController.selectedBusiness.value!.businessId!);
          getOnlineInvoice(
              _businessController.selectedBusiness.value!.businessId!);
        }
        isBusyAdding = false;
      } else {
        isBusyAdding = false;

//   // print("pending Invoice is uploaded finished");
//   deleteItems();

        Future.delayed(const Duration(seconds: 5));
      }
    } catch (ex) {}
  }

  Future deleteItem(Invoice model) async {
    await _businessController.sqliteDb.deleteInvoice(model);
  }

  void deleteItems() {
    for (var element in deletedItem) {
      deleteBusinessInvoice(element);
    }
  }

  Future deleteInvoiceOnline(Invoice invoice) async {
    var response = await http.delete(
        Uri.parse(ApiLink.invoiceLink +
            "/${invoice.id}?businessId=${invoice.businessId}"),
        headers: {"Authorization": "Bearer ${_userController.token}"});
    // print("delete response ${response.body}");
    if (response.statusCode == 200) {
    } else {}
    await _businessController.sqliteDb.deleteInvoice(invoice);
    getOfflineInvoices(_businessController.selectedBusiness.value!.businessId!);
  }

  Future deleteBusinessInvoice(Invoice invoice) async {
    if (_userController.onlineStatus == OnlineStatus.Onilne) {
      deleteInvoiceOnline(invoice);
    } else {
      deleteBusinessInvoiceOffline(invoice);
    }
  }

  Future deleteBusinessInvoiceOffline(Invoice invoice) async {
    invoice.deleted = true;

    if (!invoice.isPending!) {
      await _businessController.sqliteDb.updateOfflineInvoice(invoice);
    } else {
      await _businessController.sqliteDb.deleteInvoice(invoice);
    }
    getOfflineInvoices(_businessController.selectedBusiness.value!.businessId!);
    // getOfflineInvoice(_businessController.selectedBusiness.value!.businessId!);
  }

  clearValue() {
    // print("clearing value");
    itemNameController.text = "";
    amountController.text = "";
    quantityController.text = "";
    dateController.text = "";
    timeController.text = "";
    paymentController.text = "";
    paymentSourceController.text = "";
    receiptFileController.text = "";
    amountPaidController.text = "";
    noteController.text = '';
    date = null;
    image = null;
    selectedPaymentMode = null;
    selectedCustomer = null;
    selectedPaymentSource = null;
    selectedProduct = null;
    productList = [];
  }
// Future calculateOverView()async{

// var todayBalance=0;
// var todayMoneyIn=0;
// var todayMoneyout=0;

// todayInvoice.forEach((element) {
//      if(element.totalAmount==null){
//       return;
//     }
//   if(element.InvoiceType=="INCOME"){

// todayMoneyIn=todayMoneyIn+ element.totalAmount!;

//   }else{

//     // print("total amount is ${element.totalAmount} ${element.toJson()}");
// todayMoneyout=todayMoneyout+element.totalAmount!;

//   }

// });
// todayBalance=todayMoneyIn-todayMoneyout;
// income(todayMoneyIn);
// expenses(todayMoneyout);
// totalbalance(todayBalance);
// }
  void addMoreProduct() {
    if (selectedValue == 0) {
      if (selectedProduct != null) {
        productList.add(PaymentItem(
            productId: selectedProduct!.productId!,
            itemName: selectedProduct!.productName,
            amount: (amountController.text.isEmpty)
                ? selectedProduct!.sellingPrice
                : amountController.numberValue,
            totalAmount: (amountController.text.isEmpty)
                ? (selectedProduct!.sellingPrice! *
                    (quantityController.text.isEmpty
                        ? 1
                        : int.parse(quantityController.text)))
                : amountController.numberValue *
                    (quantityController.text.isEmpty
                        ? 1
                        : int.parse(quantityController.text)),
            quality: (quantityController.text.isEmpty)
                ? 1
                : int.parse(quantityController.text)));
      }
    } else {
      if (itemNameController.text.isNotEmpty &&
          amountController.text.isNotEmpty) {
        productList.add(PaymentItem(
            itemName: itemNameController.text,
            quality: int.parse(quantityController.text),
            amount: amountController.numberValue,
            totalAmount: amountController.numberValue *
                int.parse(quantityController.text)));
      }
    }

    selectedProduct = null;
    quantityController.text = "1";
    amountController.clear();
    itemNameController.text = "";
  }

// void addBankInvoice(){
// if(paymentValue==0){

// invoiceBank=selectedBank;

// }else{
// invoiceBank=Bank(
//   bankName: bankName.text,
//   bankAccountName: bankAccountName.text,
//   bankAccountNumber: bankAccountNumber.text

// );

// }

// }

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

  Future checkPendingTransactionBeUpdatedToServer() async {
    var list = await _businessController.sqliteDb.getOfflineInvoices(
        _businessController.selectedBusiness.value!.businessId!);
    for (var element in list) {
      if (element.isHistoryPending! && !element.isPending!) {
        pendingJobToBeUpdated.add(element);
      }
    }
    pendingTransactionToBeUpdate();
  }

  Future pendingTransactionToBeUpdate() async {
    if (pendingJobToBeUpdated.isEmpty) {
      return;
    }
    var updatedNext = pendingJobToBeUpdated[0];
    try {
      updatedNext.businessTransaction!.businessTransactionPaymentHistoryList!
          .forEach((element) async {
        if (element.isPendingUpdating!) {
          var response = await http
              .put(Uri.parse(ApiLink.invoiceLink + "/" + updatedNext.id!),
                  body: jsonEncode({
                    "businessInvoiceRequest": {
                      "businessId": updatedNext.businessId
                    },
                    "paymentHistoryRequest": {
                      "amountPaid": element.amountPaid,
                      "paymentMode": element.paymentMode,
                      "paymentSource": element.paymentSource,
                    }
                  }),
                  headers: {
                "Authorization": "Bearer ${_userController.token}",
                "Content-Type": "application/json"
              });
          // print("update history to server ${response.body}");
        }
      });
    } finally {
      pendingJobToBeUpdated.remove(updatedNext);
      if (pendingJobToBeUpdated.isNotEmpty) {
        checkPendingTransactionBeUpdatedToServer();
      }
      getOnlineInvoice(_businessController.selectedBusiness.value!.businessId!);
    }
  }

  Future updateInvoiceHisotryList(Invoice invoice) async {
    var updatedNext = invoice;
    try {
      updatedNext.businessTransaction!.businessTransactionPaymentHistoryList!
          .forEach((element) async {
        var response = await http.put(
            Uri.parse(ApiLink.invoiceLink + "/" + updatedNext.id!),
            body: jsonEncode({
              "businessInvoiceRequest": {"businessId": updatedNext.businessId},
              "paymentHistoryRequest": {
                "amountPaid": element.amountPaid,
                "paymentMode": element.paymentMode,
                "paymentSource": element.paymentSource
              }
            }),
            headers: {
              "Authorization": "Bearer ${_userController.token}",
              "Content-Type": "application/json"
            });
        // print("update history to server ${response.body}");
      });
    } finally {
      await getOnlineInvoice(
          _businessController.selectedBusiness.value!.businessId!);
    }
  }

  Future updatePaymentHistoryOnline(String invoiceId, String businessId,
      int amount, String mode, String source) async {
    try {
      // print("business id is $businessId");
      _addingInvoiceStatus(AddingInvoiceStatus.Loading);
      var response =
          await http.put(Uri.parse(ApiLink.invoiceLink + "/" + invoiceId),
              body: jsonEncode({
                "businessTransactionRequest": {
                  "businessId":
                      _businessController.selectedBusiness.value!.businessId!
                },
                "paymentHistoryRequest": {
                  "amountPaid": amount,
                  "paymentMode": mode,
                  "paymentSource": source,
                }
              }),
              headers: {
            "Authorization": "Bearer ${_userController.token}",
            "Content-Type": "application/json"
          });
      /**
        print(
            "update payment history response status code is ${response.statusCode} ${response.body} ");
      */
      if (response.statusCode == 200) {
//
        var json = jsonDecode(response.body);
// List<PaymentHistory> transactionReponseList=List.from(json['data']['businessTransactionPaymentHistoryList']).map((e)=>PaymentHistory.fromJson(e)).toList();
// var transaction=getTransactionById(transactionId);
// transaction!.balance=json['data']['balance'];
// transaction.updatedTime=DateTime.parse(json['data']['updatedDateTime']);
// transaction.businessTransactionPaymentHistoryList=transactionReponseList;
        var invoice = Invoice.fromJson(json['data']);
        updateInvoice(invoice);
        return invoice;
      } else {
        Get.snackbar("Error", "Unable to Update Transaction");
      }
    } catch (ex) {
      _addingInvoiceStatus(AddingInvoiceStatus.Empty);
      // print("error occurred ${ex.toString()}");
    } finally {
      _addingInvoiceStatus(AddingInvoiceStatus.Empty);
      Get.back();
    }
  }

  Invoice? getInvoiceById(String id) {
    Invoice? result;
    for (var element in offlineInvoices) {
      // print("comparing with ${element.id} to $id");
      if (element.id == id) {
        result = element;
        // print("search transaction is found");
        continue;
      }
    }
    return result;
  }

  Future updatePaymentHistoryOffline(String invoiceId, String businessId,
      int amount, String mode, String source) async {
    try {
      _addingInvoiceStatus(AddingInvoiceStatus.Loading);
      var invoice = getInvoiceById(invoiceId);
      var invoiceList =
          invoice!.businessTransaction!.businessTransactionPaymentHistoryList;
      invoiceList!.add(PaymentHistory(
        id: uuid.v1(),
        isPendingUpdating: true,
        amountPaid: amount,
        paymentMode: mode,
        createdDateTime: DateTime.now(),
        updateDateTime: DateTime.now(),
        deleted: false,
      ));

      invoice.isHistoryPending = true;

      invoice.businessTransaction!.businessTransactionPaymentHistoryList =
          invoiceList;
      updateInvoice(invoice);
      return invoice;
    } catch (ex) {
      _addingInvoiceStatus(AddingInvoiceStatus.Empty);
    } finally {
      _addingInvoiceStatus(AddingInvoiceStatus.Empty);
      Get.back();
    }
  }

  Future updateInvoice(Invoice invoice) async {
    _businessController.sqliteDb.updateOfflineInvoice(invoice);
    await getOfflineInvoices(
        _businessController.selectedBusiness.value!.businessId!);
  }

  Future<Invoice?> updateTransactionHistory(String invoiceId, String businessId,
      int amount, String mode, String source) async {
    var result;
    if (_userController.onlineStatus == OnlineStatus.Onilne) {
      result = await updatePaymentHistoryOnline(
          invoiceId, businessId, amount, mode, source);
    } else {
      result = await updatePaymentHistoryOffline(
          invoiceId, businessId, amount, mode, source);
    }

    return result;
  }
}
