import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:huzz/Repository/business_respository.dart';
import 'package:huzz/Repository/debtors_repository.dart';
import 'package:huzz/Repository/file_upload_respository.dart';
import 'package:huzz/Repository/product_repository.dart';
import 'package:huzz/api_link.dart';
import 'package:huzz/app/Utils/constants.dart';
import 'package:huzz/app/screens/home/income_success.dart';
import 'package:huzz/model/customer_model.dart';
import 'package:huzz/model/debtor.dart';
import 'package:huzz/model/payment_history.dart';
import 'package:huzz/model/payment_item.dart';
import 'package:huzz/model/product.dart';
import 'package:huzz/model/recordData.dart';
import 'package:huzz/model/transaction_model.dart';
import 'package:huzz/sqlite/sqlite_db.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:random_color/random_color.dart';
import 'package:uuid/uuid.dart';

import 'auth_respository.dart';
import 'customer_repository.dart';

enum AddingTransactionStatus { Loading, Error, Success, Empty }
enum TransactionStatus { Loading, Available, Error, Empty }

class TransactionRespository extends GetxController {
  Rx<List<TransactionModel>> _offlineTransactions = Rx([]);
  List<TransactionModel> get offlineTransactions => _offlineTransactions.value;
  final _uploadImageController = Get.find<FileUploadRespository>();
  final _customerController = Get.find<CustomerRepository>();
  final _productController = Get.find<ProductRepository>();
  final _debtorController = Get.find<DebtorRepository>();
  List<TransactionModel> OnlineTransaction = [];
  List<TransactionModel> pendingTransaction = [];
  Rx<List<PaymentItem>> _allPaymentItem = Rx([]);
  List<PaymentItem> get allPaymentItem => _allPaymentItem.value;
  final _userController = Get.find<AuthRepository>();
  final _businessController = Get.find<BusinessRespository>();
  dynamic expenses = 0.0.obs;
  dynamic income = 0.0.obs;
  final numberofincome = 0.obs;
  final numberofexpenses = 0.obs;
  dynamic totalbalance = 0.0.obs;
  bool isBusyAdding = false;
  bool isBusyUpdating = false;
  bool isbusyDeleting = false;
  final debtors = 0.obs;
  List<PaymentItem> productList = [];
  List<TransactionModel> todayTransaction = [];
  SqliteDb sqliteDb = SqliteDb();
  final itemNameController = TextEditingController();
  final amountController = MoneyMaskedTextController(
      leftSymbol: 'NGN ',
      decimalSeparator: '.',
      thousandSeparator: ',',
      precision: 1);
  final quantityController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final paymentController = TextEditingController();
  final paymentSourceController = TextEditingController();
  final receiptFileController = TextEditingController();
  final amountPaidController = new MoneyMaskedTextController(
      leftSymbol: 'NGN ',
      decimalSeparator: '.',
      thousandSeparator: ',',
      precision: 1);

  // final TextEditingController dateController = TextEditingController();
  // final TextEditingController timeController = TextEditingController();
  final TextEditingController contactName = TextEditingController();
  final TextEditingController contactPhone = TextEditingController();
  final TextEditingController contactMail = TextEditingController();
  List<TransactionModel> deletedItem = [];
  final _addingTransactionStatus = AddingTransactionStatus.Empty.obs;
  final _transactionStatus = TransactionStatus.Empty.obs;
  var uuid = Uuid();
// final _uploadFileController=Get.find<FileUploadRespository>();
  AddingTransactionStatus get addingTransactionStatus =>
      _addingTransactionStatus.value;
  TransactionStatus get transactionStatus => _transactionStatus.value;
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
  String? selectedCategoryExpenses;
  Rx<List<TransactionModel>> _allTransactionList = Rx([]);
  List<TransactionModel> get allTransactionList => _allTransactionList.value;
  List<String> paymentMode = ["FULLY_PAID", "DEPOSIT"];
  String? selectedPaymentMode;
  List<TransactionModel> pendingTransactionToBeAdded = [];
  List<TransactionModel> pendingJobToBeUpdated = [];
  List<TransactionModel> pendingJobToBeDelete = [];
  List<TransactionModel> pendingUpdatedTransactionList = [];

  Rx<List<RecordsData>> _allIncomeHoursData = Rx([]);
  Rx<List<RecordsData>> _allExpenditureHoursData = Rx([]);
  Rx<List<RecordsData>> _pieIncomeValue = Rx([]);
  Rx<List<RecordsData>> _pieExpenditureValue = Rx([]);
  List<RecordsData> get pieIncomeValue => _pieIncomeValue.value;
  List<RecordsData> get pieExpenditure => _pieExpenditureValue.value;
  Rx<String> value = "Today".obs;
  Rx<List<TransactionModel>> _allIncomeTransaction = Rx([]);
  Rx<List<TransactionModel>> _allExpenditureTransaction = Rx([]);
  List<TransactionModel> get allIncomeTransaction =>
      _allIncomeTransaction.value;
  List<TransactionModel> get allExpenditureTransaction =>
      _allExpenditureTransaction.value;
  List<RecordsData> get allIncomeHoursData => _allIncomeHoursData.value;
  List<RecordsData> get allExpenditureHoursData =>
      _allExpenditureHoursData.value;
  final expenseCategories = ["FINANCE", "GROCERY", "OTHERS"];

  Rx<dynamic> _recordBalance = Rx(0);
  Rx<dynamic> _recordMoneyIn = Rx(0);
  Rx<dynamic> _recordMoneyOut = Rx(0);
  dynamic get recordBalance => _recordBalance.value;
  dynamic get recordMoneyIn => _recordMoneyIn.value;
  dynamic get recordMoneyOut => _recordMoneyOut.value;
  RandomColor _randomColor = RandomColor();
  @override
  void onInit() async {
    // TODO: implement onInit
    print("getting transaction repo");

    _userController.Mtoken.listen((p0) async {
      print("token gotten $p0");
      if (p0.isNotEmpty || p0 != "0") {
        final value = _businessController.selectedBusiness.value;
        if (value != null) {
          await GetOfflineTransactions(value.businessId!);
          getOnlineTransaction(value.businessId!);

          // getSpending(value.businessId!);

        } else {
          print("current business is null");
        }
        _businessController.selectedBusiness.listen((p0) async {
          if (p0 != null) {
            print("business id ${p0.businessId}");
            _offlineTransactions([]);
            _allPaymentItem([]);
            OnlineTransaction = [];
            todayTransaction = [];
            _allIncomeHoursData([]);
            _allExpenditureHoursData([]);
            await GetOfflineTransactions(p0.businessId!);
            await getOnlineTransaction(p0.businessId!);
            splitCurrentTime();

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

  List<PaymentItem> getAllPaymentItemForRecord(RecordsData record) {
    List<PaymentItem> list = [];
    record.transactionList.forEach((element) {
      list.addAll(element.businessTransactionPaymentItemList!);
    });
    return list;
  }

  List<PaymentItem> getAllPaymentItemForRecordIncome(RecordsData record) {
    List<PaymentItem> list = [];
    record.transactionList.forEach((element) {
      if (element.transactionType == "INCOME")
        list.addAll(element.businessTransactionPaymentItemList!);
    });
    return list;
  }

  List<PaymentItem> getAllPaymentItemForRecordExpenditure(RecordsData record) {
    List<PaymentItem> list = [];
    record.transactionList.forEach((element) {
      if (element.transactionType == "EXPENDITURE")
        list.addAll(element.businessTransactionPaymentItemList!);
    });
    return list;
  }

  List<PaymentItem> getAllPaymentItemListForIncomeRecord() {
    List<PaymentItem> list = [];
    allIncomeHoursData.forEach((element) {
      if (element.value > 0) {
        list.addAll(getAllPaymentItemForRecordIncome(element));
      }
    });
    print("get record income list ${list.length}");
    return list;
  }

  List<PaymentItem> getAllPaymentItemListForExpenditure() {
    List<PaymentItem> list1 = [];

    allExpenditureHoursData.forEach((element) {
      if (element.value > 0) {
        list1.addAll(getAllPaymentItemForRecordExpenditure(element));
      }
    });
    print("get record expenditure list ${list1.length}");
    return list1;
  }

  Future getAllPaymentItem() async {
    if (todayTransaction.isEmpty) {
      _allPaymentItem([]);
      return;
    }
    ;
    List<PaymentItem> items = [];
    todayTransaction.forEach((element) {
      items.addAll(element.businessTransactionPaymentItemList!);
    });
// items.reversed.toList
    _allPaymentItem(items.reversed.toList());
  }

  Future getOnlineTransaction(String businessId) async {
    _transactionStatus(TransactionStatus.Loading);
    OnlineTransaction = [];
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
    } else if (response.statusCode == 401) {
      if (json['error'] == "Unauthorized") {
        _userController.tokenExpired = true;
        // Get.offAll(Signin());
      }
    } else {}
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

  Future updatePendingJob() async {
    if (pendingUpdatedTransactionList.isEmpty) {
      return;
    }
    var updateNext = pendingUpdatedTransactionList[0];
    _businessController.sqliteDb.updateOfflineTransaction(updateNext);
    pendingUpdatedTransactionList.remove(updateNext);
    if (pendingUpdatedTransactionList.isNotEmpty) {
      updatePendingJob();
    } else {
      GetOfflineTransactions(
          _businessController.selectedBusiness.value!.businessId!);
    }
  }

  Future GetOfflineTransactions(String id) async {
    var results = await _businessController.sqliteDb.getOfflineTransactions(id);
    print("offline transaction ${results.length}");

    _offlineTransactions(results
        .where((element) =>
            !element.deleted! &&
            element.businessTransactionPaymentItemList!.isNotEmpty)
        .toList());

    getTodayTransaction();
    //  getWeeklyRecordData();
    // getMonthlyRecord();
    // splitCurrentTime();
    // getYearRecord();
  }

  Future splitCurrentTime() async {
    TimeOfDay _timeday = TimeOfDay(hour: 0, minute: 0);
    List<String> value = [];
    for (int i = 0; i < 24; ++i) {
      value.add((_timeday.hour).toString());
      var timeofday =
          TimeOfDay(hour: _timeday.hour + 1, minute: _timeday.minute);
      _timeday = timeofday;
      print("splitting day hour " + _timeday.hour.toString() + ":00");
    }
    getSplitCurrentDate(value);
  }

  int daysInMonth(DateTime date) => DateTimeRange(
          start: DateTime(date.year, date.month, 1),
          end: DateTime(date.year, date.month + 1))
      .duration
      .inDays;

  Future getMonthlyRecord() async {
    var currentDate = DateTime.now();
    int days = daysInMonth(currentDate);
    print("number of days in the months $days");
    List<DateTime> value = [];
    for (int i = 1; i < days; ++i) {
      print("days number is $i");
      value.add(DateTime(currentDate.year, currentDate.month, i));
    }
    getSplitCurrentMonthly(value);
  }

  Future getAllTimeRecord() async {
    var currentDate = DateTime.now();
    DateTime startingYear = DateTime(2018);
    DateTime endingYear = DateTime(currentDate.year);
    List<DateTime> value = [];
    for (int i = startingYear.year; i < endingYear.year + 1; ++i) {
      print("year in list ${startingYear.year}");

      value.add(DateTime(startingYear.year));
      startingYear = DateTime(startingYear.year + 1);
    }
    print("all year to be calculated ${value.length}");
    getSplitAllTime(value);
  }

  Future getYearRecord() async {
    var currentDate = DateTime.now();
    List<DateTime> value = [];
    for (int i = 1; i < 12; ++i) {
      value.add(DateTime(currentDate.year, i));
    }

    getSplitCurrentYear(value);
  }

  Future getSplitAllTime(List<DateTime> years) async {
    List<TransactionModel> _currentHoursIncome = [];
    List<TransactionModel> _currentHoursExpenditure = [];
    List<RecordsData> _hourIncomeData = [];
    List<RecordsData> _hourExpenditureData = [];
    dynamic sundayTotalIncome = 0;
    dynamic mondayTotalIncome = 0;
    dynamic tuesdayTotalIncome = 0;
    dynamic wednesdayTotalIncome = 0;
    dynamic thursdayTotalIncome = 0;
    dynamic fridayTotalIncome = 0;
    dynamic saturdayTotalIncome = 0;

    dynamic sundayTotalExpenditure = 0;
    dynamic mondayTotalExpenditure = 0;
    dynamic tuesdayTotalExpenditure = 0;
    dynamic wednesdayTotalExpenditure = 0;
    dynamic thursdayTotalExpenditure = 0;
    dynamic fridayTotalExpenditure = 0;
    dynamic saturdayTotalExpenditure = 0;
    List<RecordsData> _pieIncome = [];
    List<RecordsData> _pieExpenditure = [];
    years.forEach((element1) {
      dynamic incomeTotalAmount = 0;
      dynamic expenditureTotalAmount = 0;
      List<TransactionModel> currentTran = [];
      if (todayTransaction.isEmpty)
        print("alltime is empty");
      else
        print("alltime transaction is not empty");
      offlineTransactions.forEach((element) {
        print(
            "alltime testing $element1 ${element.entryDateTime!.toIso8601String()} to ${element1.toIso8601String()}");

        if (element.entryDateTime != null &&
            DateTime(element.entryDateTime!.year)
                .isAtSameMomentAs(DateTime(element1.year))) {
          print("AllTime found");
          if (element.transactionType!.contains("INCOME")) {
            _currentHoursIncome.add(element);
            print("AllTime is  $element1 amount ${element.totalAmount}");
            incomeTotalAmount = incomeTotalAmount + element.totalAmount;
            print("AllTime is  $element1 amount $incomeTotalAmount");

            switch (element.entryDateTime!.weekday) {
              case 7:
                sundayTotalIncome = sundayTotalIncome + element.totalAmount!;
                break;
              case 1:
                mondayTotalIncome = mondayTotalIncome + element.totalAmount;
                break;
              case 2:
                tuesdayTotalIncome = tuesdayTotalIncome + element.totalAmount;
                break;
              case 3:
                wednesdayTotalIncome =
                    wednesdayTotalIncome + element.totalAmount!;
                break;
              case 4:
                thursdayTotalIncome =
                    thursdayTotalIncome + element.totalAmount!;
                break;
              case 5:
                fridayTotalIncome = fridayTotalIncome + element.totalAmount!;
                break;
              case 6:
                saturdayTotalIncome =
                    saturdayTotalIncome + element.totalAmount!;
            }
          } else {
            _currentHoursExpenditure.add(element);
            expenditureTotalAmount =
                expenditureTotalAmount + element.totalAmount ?? 0;
            print(
                "expenditure AllTime is  $element1 amount $expenditureTotalAmount");
            switch (element.entryDateTime!.weekday) {
              case 7:
                sundayTotalExpenditure =
                    sundayTotalExpenditure + element.totalAmount!;
                break;
              case 1:
                mondayTotalExpenditure =
                    mondayTotalExpenditure + element.totalAmount;
                break;
              case 2:
                tuesdayTotalExpenditure =
                    tuesdayTotalExpenditure + element.totalAmount;
                break;
              case 3:
                wednesdayTotalExpenditure =
                    wednesdayTotalExpenditure + element.totalAmount!;
                break;
              case 4:
                thursdayTotalExpenditure =
                    thursdayTotalExpenditure + element.totalAmount!;
                break;
              case 5:
                fridayTotalExpenditure =
                    fridayTotalExpenditure + element.totalAmount!;
                break;
              case 6:
                saturdayTotalExpenditure =
                    saturdayTotalExpenditure + element.totalAmount!;
            }
          }

          currentTran.add(element);
        }
      });
      _hourIncomeData.add(RecordsData(element1.formatDate(pattern: "y")!,
          incomeTotalAmount, currentTran, _randomColor.randomColor()));
      _hourExpenditureData.add(RecordsData(element1.formatDate(pattern: "y")!,
          expenditureTotalAmount, currentTran, _randomColor.randomColor()));
    });
    _allIncomeHoursData(_hourIncomeData);
    _allExpenditureHoursData(_hourExpenditureData);
    _pieIncome.add(
        RecordsData("Sun", sundayTotalIncome, [], _randomColor.randomColor()));
    _pieIncome.add(
        RecordsData("Mon", mondayTotalIncome, [], _randomColor.randomColor()));
    _pieIncome.add(
        RecordsData("Tue", tuesdayTotalIncome, [], _randomColor.randomColor()));
    _pieIncome.add(RecordsData(
        "Wed", wednesdayTotalIncome, [], _randomColor.randomColor()));
    _pieIncome.add(RecordsData(
        "Thur", thursdayTotalIncome, [], _randomColor.randomColor()));
    _pieIncome.add(
        RecordsData("Fri", fridayTotalIncome, [], _randomColor.randomColor()));
    _pieIncome.add(RecordsData(
        "Sat", saturdayTotalIncome, [], _randomColor.randomColor()));

    _pieExpenditure.add(RecordsData(
        "Sun", sundayTotalExpenditure, [], _randomColor.randomColor()));
    _pieExpenditure.add(RecordsData(
        "Mon", mondayTotalExpenditure, [], _randomColor.randomColor()));
    _pieExpenditure.add(RecordsData(
        "Tue", tuesdayTotalExpenditure, [], _randomColor.randomColor()));
    _pieExpenditure.add(RecordsData(
        "Wed", wednesdayTotalExpenditure, [], _randomColor.randomColor()));
    _pieExpenditure.add(RecordsData(
        "Thur", thursdayTotalExpenditure, [], _randomColor.randomColor()));
    _pieExpenditure.add(RecordsData(
        "Fri", fridayTotalExpenditure, [], _randomColor.randomColor()));
    _pieExpenditure.add(RecordsData(
        "Sat", saturdayTotalExpenditure, [], _randomColor.randomColor()));

    _pieIncomeValue(_pieIncome);
    _pieExpenditureValue(_pieExpenditure);
    _allIncomeTransaction(_currentHoursIncome);
    _allExpenditureTransaction(_currentHoursExpenditure);
    calculateRecordOverView();
  }

  Future getSplitCurrentYear(List<DateTime> months) async {
    List<TransactionModel> _currentHoursIncome = [];
    List<TransactionModel> _currentHoursExpenditure = [];
    List<RecordsData> _hourIncomeData = [];
    List<RecordsData> _hourExpenditureData = [];
    dynamic sundayTotalIncome = 0;
    dynamic mondayTotalIncome = 0;
    dynamic tuesdayTotalIncome = 0;
    dynamic wednesdayTotalIncome = 0;
    dynamic thursdayTotalIncome = 0;
    dynamic fridayTotalIncome = 0;
    dynamic saturdayTotalIncome = 0;

    dynamic sundayTotalExpenditure = 0;
    dynamic mondayTotalExpenditure = 0;
    dynamic tuesdayTotalExpenditure = 0;
    dynamic wednesdayTotalExpenditure = 0;
    dynamic thursdayTotalExpenditure = 0;
    dynamic fridayTotalExpenditure = 0;
    dynamic saturdayTotalExpenditure = 0;
    List<RecordsData> _pieIncome = [];
    List<RecordsData> _pieExpenditure = [];
    months.forEach((element1) {
      dynamic incomeTotalAmount = 0;
      dynamic expenditureTotalAmount = 0;
      List<TransactionModel> currentTran = [];
      if (todayTransaction.isEmpty)
        print(" transactonlist is empty");
      else
        print("today transaction is not empty");
      offlineTransactions.forEach((element) {
        print(
            "monthly testing $element1 ${element.entryDateTime!.toIso8601String()} to ${element1.toIso8601String()}");

        if (element.entryDateTime != null &&
            DateTime(element.entryDateTime!.year, element.entryDateTime!.month)
                .isAtSameMomentAs(DateTime(element1.year, element1.month))) {
          print("today hour found");
          if (element.transactionType!.contains("INCOME")) {
            _currentHoursIncome.add(element);
            print("income hour is  $element1 amount ${element.totalAmount}");
            incomeTotalAmount = incomeTotalAmount + element.totalAmount;
            print("income hour is  $element1 amount $incomeTotalAmount");

            switch (element.entryDateTime!.weekday) {
              case 7:
                sundayTotalIncome = sundayTotalIncome + element.totalAmount!;
                break;
              case 1:
                mondayTotalIncome = mondayTotalIncome + element.totalAmount;
                break;
              case 2:
                tuesdayTotalIncome = tuesdayTotalIncome + element.totalAmount;
                break;
              case 3:
                wednesdayTotalIncome =
                    wednesdayTotalIncome + element.totalAmount!;
                break;
              case 4:
                thursdayTotalIncome =
                    thursdayTotalIncome + element.totalAmount!;
                break;
              case 5:
                fridayTotalIncome = fridayTotalIncome + element.totalAmount!;
                break;
              case 6:
                saturdayTotalIncome =
                    saturdayTotalIncome + element.totalAmount!;
            }
          } else {
            _currentHoursExpenditure.add(element);
            expenditureTotalAmount =
                expenditureTotalAmount + element.totalAmount ?? 0;
            print(
                "expenditure hour is  $element1 amount $expenditureTotalAmount");
            switch (element.entryDateTime!.weekday) {
              case 7:
                sundayTotalExpenditure =
                    sundayTotalExpenditure + element.totalAmount!;
                break;
              case 1:
                mondayTotalExpenditure =
                    mondayTotalExpenditure + element.totalAmount;
                break;
              case 2:
                tuesdayTotalExpenditure =
                    tuesdayTotalExpenditure + element.totalAmount;
                break;
              case 3:
                wednesdayTotalExpenditure =
                    wednesdayTotalExpenditure + element.totalAmount!;
                break;
              case 4:
                thursdayTotalExpenditure =
                    thursdayTotalExpenditure + element.totalAmount!;
                break;
              case 5:
                fridayTotalExpenditure =
                    fridayTotalExpenditure + element.totalAmount!;
                break;
              case 6:
                saturdayTotalExpenditure =
                    saturdayTotalExpenditure + element.totalAmount!;
            }
          }
          currentTran.add(element);
        }
      });
      _hourIncomeData.add(RecordsData(element1.formatDate(pattern: "MMM")!,
          incomeTotalAmount, currentTran, _randomColor.randomColor()));
      _hourExpenditureData.add(RecordsData(element1.formatDate(pattern: "MMM")!,
          expenditureTotalAmount, currentTran, _randomColor.randomColor()));
    });
    _allIncomeHoursData(_hourIncomeData);
    _allExpenditureHoursData(_hourExpenditureData);
    _pieIncome.add(
        RecordsData("Sun", sundayTotalIncome, [], _randomColor.randomColor()));
    _pieIncome.add(
        RecordsData("Mon", mondayTotalIncome, [], _randomColor.randomColor()));
    _pieIncome.add(
        RecordsData("Tue", tuesdayTotalIncome, [], _randomColor.randomColor()));
    _pieIncome.add(RecordsData(
        "Wed", wednesdayTotalIncome, [], _randomColor.randomColor()));
    _pieIncome.add(RecordsData(
        "Thur", thursdayTotalIncome, [], _randomColor.randomColor()));
    _pieIncome.add(
        RecordsData("Fri", fridayTotalIncome, [], _randomColor.randomColor()));
    _pieIncome.add(RecordsData(
        "Sat", saturdayTotalIncome, [], _randomColor.randomColor()));

    _pieExpenditure.add(RecordsData(
        "Sun", sundayTotalExpenditure, [], _randomColor.randomColor()));
    _pieExpenditure.add(RecordsData(
        "Mon", mondayTotalExpenditure, [], _randomColor.randomColor()));
    _pieExpenditure.add(RecordsData(
        "Tue", tuesdayTotalExpenditure, [], _randomColor.randomColor()));
    _pieExpenditure.add(RecordsData(
        "Wed", wednesdayTotalExpenditure, [], _randomColor.randomColor()));
    _pieExpenditure.add(RecordsData(
        "Thur", thursdayTotalExpenditure, [], _randomColor.randomColor()));
    _pieExpenditure.add(RecordsData(
        "Fri", fridayTotalExpenditure, [], _randomColor.randomColor()));
    _pieExpenditure.add(RecordsData(
        "Sat", saturdayTotalExpenditure, [], _randomColor.randomColor()));

    _pieIncomeValue(_pieIncome);
    _pieExpenditureValue(_pieExpenditure);
    _allIncomeTransaction(_currentHoursIncome);
    _allExpenditureTransaction(_currentHoursExpenditure);
    calculateRecordOverView();
  }

  Future getSplitCurrentMonthly(List<DateTime> days) async {
    List<TransactionModel> _currentHoursIncome = [];
    List<TransactionModel> _currentHoursExpenditure = [];
    List<RecordsData> _hourIncomeData = [];
    List<RecordsData> _hourExpenditureData = [];
    dynamic sundayTotalIncome = 0;
    dynamic mondayTotalIncome = 0;
    dynamic tuesdayTotalIncome = 0;
    dynamic wednesdayTotalIncome = 0;
    dynamic thursdayTotalIncome = 0;
    dynamic fridayTotalIncome = 0;
    dynamic saturdayTotalIncome = 0;

    dynamic sundayTotalExpenditure = 0;
    dynamic mondayTotalExpenditure = 0;
    dynamic tuesdayTotalExpenditure = 0;
    dynamic wednesdayTotalExpenditure = 0;
    dynamic thursdayTotalExpenditure = 0;
    dynamic fridayTotalExpenditure = 0;
    dynamic saturdayTotalExpenditure = 0;
    List<RecordsData> _pieIncome = [];
    List<RecordsData> _pieExpenditure = [];
    days.forEach((element1) {
      dynamic incomeTotalAmount = 0;
      dynamic expenditureTotalAmount = 0;
      List<TransactionModel> currentTran = [];
      if (todayTransaction.isEmpty)
        print(" transactonlist is empty");
      else
        print("today transaction is not empty");
      offlineTransactions.forEach((element) {
        print(
            "monthly testing $element1 ${element.entryDateTime!.toIso8601String()} to ${element1.toIso8601String()}");

        if (element.entryDateTime != null &&
            DateTime(element.entryDateTime!.year, element.entryDateTime!.month,
                    element.entryDateTime!.day)
                .isAtSameMomentAs(
                    DateTime(element1.year, element1.month, element1.day))) {
          print("today hour found");
          if (element.transactionType!.contains("INCOME")) {
            _currentHoursIncome.add(element);
            print("income hour is  $element1 amount ${element.totalAmount}");
            incomeTotalAmount = incomeTotalAmount + element.totalAmount;
            print("income hour is  $element1 amount $incomeTotalAmount");

            switch (element.entryDateTime!.weekday) {
              case 7:
                sundayTotalIncome = sundayTotalIncome + element.totalAmount!;
                break;
              case 1:
                mondayTotalIncome = mondayTotalIncome + element.totalAmount;
                break;
              case 2:
                tuesdayTotalIncome = tuesdayTotalIncome + element.totalAmount;
                break;
              case 3:
                wednesdayTotalIncome =
                    wednesdayTotalIncome + element.totalAmount;
                break;
              case 4:
                thursdayTotalIncome = thursdayTotalIncome + element.totalAmount;
                break;
              case 5:
                fridayTotalIncome = fridayTotalIncome + element.totalAmount;
                break;
              case 6:
                saturdayTotalIncome = saturdayTotalIncome + element.totalAmount;
            }
          } else {
            _currentHoursExpenditure.add(element);
            expenditureTotalAmount =
                expenditureTotalAmount + element.totalAmount ?? 0;
            print(
                "expenditure hour is  $element1 amount $expenditureTotalAmount");
            switch (element.entryDateTime!.weekday) {
              case 7:
                sundayTotalExpenditure =
                    sundayTotalExpenditure + element.totalAmount!;
                break;
              case 1:
                mondayTotalExpenditure =
                    mondayTotalExpenditure + element.totalAmount;
                break;
              case 2:
                tuesdayTotalExpenditure =
                    tuesdayTotalExpenditure + element.totalAmount;
                break;
              case 3:
                wednesdayTotalExpenditure =
                    wednesdayTotalExpenditure + element.totalAmount!;
                break;
              case 4:
                thursdayTotalExpenditure =
                    thursdayTotalExpenditure + element.totalAmount!;
                break;
              case 5:
                fridayTotalExpenditure =
                    fridayTotalExpenditure + element.totalAmount!;
                break;
              case 6:
                saturdayTotalExpenditure =
                    saturdayTotalExpenditure + element.totalAmount!;
            }
          }
          currentTran.add(element);
        }
      });
      _hourIncomeData.add(RecordsData(element1.formatDate(pattern: "MMM,dd")!,
          incomeTotalAmount, currentTran, _randomColor.randomColor()));
      _hourExpenditureData.add(RecordsData(
          element1.formatDate(pattern: "MMM,dd")!,
          expenditureTotalAmount,
          currentTran,
          _randomColor.randomColor()));
    });
    _allIncomeHoursData(_hourIncomeData);
    _allExpenditureHoursData(_hourExpenditureData);

    _pieIncome.add(
        RecordsData("Sun", sundayTotalIncome, [], _randomColor.randomColor()));
    _pieIncome.add(
        RecordsData("Mon", mondayTotalIncome, [], _randomColor.randomColor()));
    _pieIncome.add(
        RecordsData("Tue", tuesdayTotalIncome, [], _randomColor.randomColor()));
    _pieIncome.add(RecordsData(
        "Wed", wednesdayTotalIncome, [], _randomColor.randomColor()));
    _pieIncome.add(RecordsData(
        "Thur", thursdayTotalIncome, [], _randomColor.randomColor()));
    _pieIncome.add(
        RecordsData("Fri", fridayTotalIncome, [], _randomColor.randomColor()));
    _pieIncome.add(RecordsData(
        "Sat", saturdayTotalIncome, [], _randomColor.randomColor()));

    _pieExpenditure.add(RecordsData(
        "Sun", sundayTotalExpenditure, [], _randomColor.randomColor()));
    _pieExpenditure.add(RecordsData(
        "Mon", mondayTotalExpenditure, [], _randomColor.randomColor()));
    _pieExpenditure.add(RecordsData(
        "Tue", tuesdayTotalExpenditure, [], _randomColor.randomColor()));
    _pieExpenditure.add(RecordsData(
        "Wed", wednesdayTotalExpenditure, [], _randomColor.randomColor()));
    _pieExpenditure.add(RecordsData(
        "Thur", thursdayTotalExpenditure, [], _randomColor.randomColor()));
    _pieExpenditure.add(RecordsData(
        "Fri", fridayTotalExpenditure, [], _randomColor.randomColor()));
    _pieExpenditure.add(RecordsData(
        "Sat", saturdayTotalExpenditure, [], _randomColor.randomColor()));

    _pieIncomeValue(_pieIncome);
    _pieExpenditureValue(_pieExpenditure);
    _allIncomeTransaction(_currentHoursIncome);
    _allExpenditureTransaction(_currentHoursExpenditure);
    calculateRecordOverView();
  }

  Future getSplitCurrentDate(List<String> hours) async {
    var currentDate = DateTime.now();
    List<TransactionModel> _currentHoursIncome = [];
    List<TransactionModel> _currentHoursExpenditure = [];
    List<RecordsData> _hourIncomeData = [];
    List<RecordsData> _hourExpenditureData = [];

    hours.forEach((element1) {
      dynamic incomeTotalAmount = 0;
      dynamic expenditureTotalAmount = 0;
      List<TransactionModel> currentTran = [];
      if (todayTransaction.isEmpty)
        print("today transactonlist is empty");
      else
        print("today transaction is not empty");
      todayTransaction.forEach((element) {
        print(
            "hour testing $element1 ${element.entryDateTime!.toIso8601String()}");

        if (element.entryDateTime!.isAfter(DateTime(currentDate.year,
                currentDate.month, currentDate.day, int.parse(element1), 00)) &&
            element.entryDateTime!.isBefore(DateTime(currentDate.year,
                currentDate.month, currentDate.day, int.parse(element1), 59))) {
          print("today hour found");
          if (element.transactionType!.contains("INCOME")) {
            _currentHoursIncome.add(element);
            incomeTotalAmount = incomeTotalAmount + element.totalAmount;
            print("income hour is  $element1 amount $incomeTotalAmount");
          } else {
            _currentHoursExpenditure.add(element);
            expenditureTotalAmount =
                expenditureTotalAmount + element.totalAmount;
            print(
                "expenditure hour is  $element1 amount $expenditureTotalAmount");
          }
          currentTran.add(element);
        }
      });
      _hourIncomeData.add(RecordsData(element1 + ":00", incomeTotalAmount,
          currentTran, _randomColor.randomColor()));
      _hourExpenditureData.add(RecordsData(element1 + ":00",
          expenditureTotalAmount, currentTran, _randomColor.randomColor()));
    });
    _allIncomeHoursData(_hourIncomeData);
    _allExpenditureHoursData(_hourExpenditureData);
    _allIncomeTransaction(_currentHoursIncome);
    _allExpenditureTransaction(_currentHoursExpenditure);
    calculateRecordOverView();
  }

  Future getWeeklyRecordData() async {
    DateTime currentDate = DateTime.now();
    print("today weekday is ${currentDate.weekday}");

    DateTime firstDay =
        currentDate.subtract(Duration(days: currentDate.weekday));
    print("first day of the week is ${firstDay.toString()}");
    if (currentDate.weekday == 7) {
      firstDay = DateTime.now();
    }
    List<DateTime> value = [];
    for (int i = 0; i < 7; ++i) {
      value.add(DateTime(firstDay.year, firstDay.month, firstDay.day));
      firstDay = DateTime(firstDay.year, firstDay.month, firstDay.day + 1);
    }
    getSplitCurrentWeek(value);
  }

  Future getDateRangeRecordData(DateTime startDate, DateTime endDate) async {
    int days = endDate.difference(startDate).inDays;
    print("days difference in range $days");
    List<DateTime> value = [];
    for (int i = 0; i <= days; ++i) {
      value.add(DateTime(startDate.year, startDate.month, startDate.day));
      startDate = DateTime(startDate.year, startDate.month, startDate.day + 1);
    }

    getSplitDataRangeRecord(value);
  }

  Future getPieDataRangeData(List<RecordsData> list) async {
    List<String> data = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Sunday'
    ];
    dynamic sundayTotalIncome = 0;
    dynamic mondayTotalIncome = 0;
    dynamic tuesdayTotalIncome = 0;
    dynamic wednesdayTotalIncome = 0;
    dynamic thursdayTotalIncome = 0;
    dynamic fridayTotalIncome = 0;
    dynamic saturdayTotalIncome = 0;

    dynamic sundayTotalExpenditure = 0;
    dynamic mondayTotalExpenditure = 0;
    dynamic tuesdayTotalExpenditure = 0;
    dynamic wednesdayTotalExpenditure = 0;
    dynamic thursdayTotalExpenditure = 0;
    dynamic fridayTotalExpenditure = 0;
    dynamic saturdayTotalExpenditure = 0;
    List<RecordsData> allWeekDays = [];
  }

  Future getSplitDataRangeRecord(List<DateTime> days) async {
    List<TransactionModel> _currentHoursIncome = [];
    List<TransactionModel> _currentHoursExpenditure = [];
    List<RecordsData> _hourIncomeData = [];
    List<RecordsData> _hourExpenditureData = [];
    List<String> data = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Sunday'
    ];
    dynamic sundayTotalIncome = 0;
    dynamic mondayTotalIncome = 0;
    dynamic tuesdayTotalIncome = 0;
    dynamic wednesdayTotalIncome = 0;
    dynamic thursdayTotalIncome = 0;
    dynamic fridayTotalIncome = 0;
    dynamic saturdayTotalIncome = 0;

    dynamic sundayTotalExpenditure = 0;
    dynamic mondayTotalExpenditure = 0;
    dynamic tuesdayTotalExpenditure = 0;
    dynamic wednesdayTotalExpenditure = 0;
    dynamic thursdayTotalExpenditure = 0;
    dynamic fridayTotalExpenditure = 0;
    dynamic saturdayTotalExpenditure = 0;
    List<RecordsData> _pieIncome = [];
    List<RecordsData> _pieExpenditure = [];

    days.forEach((element1) {
      dynamic incomeTotalAmount = 0;
      dynamic expenditureTotalAmount = 0;
      List<TransactionModel> currentTran = [];
      if (todayTransaction.isEmpty)
        print(" transactonlist is empty");
      else
        print("today transaction is not empty");
      offlineTransactions.forEach((element) {
        print(
            "data range testing $element1 ${element.entryDateTime!.toIso8601String()} to ${element1.toIso8601String()}");

        if (element.entryDateTime != null &&
            DateTime(element.entryDateTime!.year, element.entryDateTime!.month,
                    element.entryDateTime!.day)
                .isAtSameMomentAs(
                    DateTime(element1.year, element1.month, element1.day))) {
          print("data range found");
          if (element.transactionType!.contains("INCOME")) {
            _currentHoursIncome.add(element);
            print("income hour is  $element1 amount ${element.totalAmount}");
            incomeTotalAmount = incomeTotalAmount + element.totalAmount;
            print("income hour is  $element1 amount $incomeTotalAmount");
            switch (element.entryDateTime!.weekday) {
              case 7:
                sundayTotalIncome = sundayTotalIncome + element.totalAmount!;
                break;
              case 1:
                mondayTotalIncome = mondayTotalIncome + element.totalAmount;
                break;
              case 2:
                tuesdayTotalIncome = tuesdayTotalIncome + element.totalAmount;
                break;
              case 3:
                wednesdayTotalIncome =
                    wednesdayTotalIncome + element.totalAmount!;
                break;
              case 4:
                thursdayTotalIncome =
                    thursdayTotalIncome + element.totalAmount!;
                break;
              case 5:
                fridayTotalIncome = fridayTotalIncome + element.totalAmount!;
                break;
              case 6:
                saturdayTotalIncome =
                    saturdayTotalIncome + element.totalAmount!;
            }
          } else {
            _currentHoursExpenditure.add(element);
            expenditureTotalAmount =
                expenditureTotalAmount + element.totalAmount ?? 0;
            print(
                "expenditure hour is  $element1 amount $expenditureTotalAmount");
            switch (element.entryDateTime!.weekday) {
              case 7:
                sundayTotalExpenditure =
                    sundayTotalExpenditure + element.totalAmount!;
                break;
              case 1:
                mondayTotalExpenditure =
                    mondayTotalExpenditure + element.totalAmount;
                break;
              case 2:
                tuesdayTotalExpenditure =
                    tuesdayTotalExpenditure + element.totalAmount;
                break;
              case 3:
                wednesdayTotalExpenditure =
                    wednesdayTotalExpenditure + element.totalAmount!;
                break;
              case 4:
                thursdayTotalExpenditure =
                    thursdayTotalExpenditure + element.totalAmount!;
                break;
              case 5:
                fridayTotalExpenditure =
                    fridayTotalExpenditure + element.totalAmount!;
                break;
              case 6:
                saturdayTotalExpenditure =
                    saturdayTotalExpenditure + element.totalAmount!;
            }
          }
          currentTran.add(element);
        }
      });
      _hourIncomeData.add(RecordsData(element1.formatDate(pattern: "yMMMd")!,
          incomeTotalAmount, currentTran, _randomColor.randomColor()));
      _hourExpenditureData.add(RecordsData(
          element1.formatDate(pattern: "yMMMd")!,
          expenditureTotalAmount,
          currentTran,
          _randomColor.randomColor()));
    });
    _allIncomeHoursData(_hourIncomeData);
    _allExpenditureHoursData(_hourExpenditureData);
    _pieIncome.add(
        RecordsData("Sun", sundayTotalIncome, [], _randomColor.randomColor()));
    _pieIncome.add(
        RecordsData("Mon", mondayTotalIncome, [], _randomColor.randomColor()));
    _pieIncome.add(
        RecordsData("Tue", tuesdayTotalIncome, [], _randomColor.randomColor()));
    _pieIncome.add(RecordsData(
        "Wed", wednesdayTotalIncome, [], _randomColor.randomColor()));
    _pieIncome.add(RecordsData(
        "Thur", thursdayTotalIncome, [], _randomColor.randomColor()));
    _pieIncome.add(
        RecordsData("Fri", fridayTotalIncome, [], _randomColor.randomColor()));
    _pieIncome.add(RecordsData(
        "Sat", saturdayTotalIncome, [], _randomColor.randomColor()));

    _pieExpenditure.add(RecordsData(
        "Sun", sundayTotalExpenditure, [], _randomColor.randomColor()));
    _pieExpenditure.add(RecordsData(
        "Mon", mondayTotalExpenditure, [], _randomColor.randomColor()));
    _pieExpenditure.add(RecordsData(
        "Tue", tuesdayTotalExpenditure, [], _randomColor.randomColor()));
    _pieExpenditure.add(RecordsData(
        "Wed", wednesdayTotalExpenditure, [], _randomColor.randomColor()));
    _pieExpenditure.add(RecordsData(
        "Thur", thursdayTotalExpenditure, [], _randomColor.randomColor()));
    _pieExpenditure.add(RecordsData(
        "Fri", fridayTotalExpenditure, [], _randomColor.randomColor()));
    _pieExpenditure.add(RecordsData(
        "Sat", saturdayTotalExpenditure, [], _randomColor.randomColor()));
    _pieIncomeValue(_pieIncome);
    _pieExpenditureValue(_pieExpenditure);
    _allIncomeTransaction(_currentHoursIncome);
    _allExpenditureTransaction(_currentHoursExpenditure);
    calculateRecordOverView();
  }

  Future getSplitCurrentWeek(List<DateTime> days) async {
    List<TransactionModel> _currentHoursIncome = [];
    List<TransactionModel> _currentHoursExpenditure = [];
    List<RecordsData> _hourIncomeData = [];
    List<RecordsData> _hourExpenditureData = [];
    dynamic sundayTotalIncome = 0;
    dynamic mondayTotalIncome = 0;
    dynamic tuesdayTotalIncome = 0;
    dynamic wednesdayTotalIncome = 0;
    dynamic thursdayTotalIncome = 0;
    dynamic fridayTotalIncome = 0;
    dynamic saturdayTotalIncome = 0;

    dynamic sundayTotalExpenditure = 0;
    dynamic mondayTotalExpenditure = 0;
    dynamic tuesdayTotalExpenditure = 0;
    dynamic wednesdayTotalExpenditure = 0;
    dynamic thursdayTotalExpenditure = 0;
    dynamic fridayTotalExpenditure = 0;
    dynamic saturdayTotalExpenditure = 0;
    List<RecordsData> _pieIncome = [];
    List<RecordsData> _pieExpenditure = [];
    days.forEach((element1) {
      dynamic incomeTotalAmount = 0;
      dynamic expenditureTotalAmount = 0;
      List<TransactionModel> currentTran = [];
      if (todayTransaction.isEmpty)
        print("today transactonlist is empty");
      else
        print("today transaction is not empty");
      offlineTransactions.forEach((element) {
        print(
            "weekly testing $element1 ${element.entryDateTime!.toIso8601String()}");

        if (element.entryDateTime != null &&
            DateTime(element.entryDateTime!.year, element.entryDateTime!.month,
                    element.entryDateTime!.day)
                .isAtSameMomentAs(
                    DateTime(element1.year, element1.month, element1.day))) {
          print("today hour found");
          if (element.transactionType!.contains("INCOME")) {
            _currentHoursIncome.add(element);
            print("income hour is  $element1 amount ${element.totalAmount}");
            incomeTotalAmount = incomeTotalAmount + element.totalAmount ?? 0;
            print("income hour is  $element1 amount $incomeTotalAmount");
            switch (element.entryDateTime!.weekday) {
              case 7:
                sundayTotalIncome = sundayTotalIncome + element.totalAmount!;
                break;
              case 1:
                mondayTotalIncome = mondayTotalIncome + element.totalAmount;
                break;
              case 2:
                tuesdayTotalIncome = tuesdayTotalIncome + element.totalAmount;
                break;
              case 3:
                wednesdayTotalIncome =
                    wednesdayTotalIncome + element.totalAmount!;
                break;
              case 4:
                thursdayTotalIncome =
                    thursdayTotalIncome + element.totalAmount!;
                break;
              case 5:
                fridayTotalIncome = fridayTotalIncome + element.totalAmount!;
                break;
              case 6:
                saturdayTotalIncome =
                    saturdayTotalIncome + element.totalAmount!;
            }
          } else {
            _currentHoursExpenditure.add(element);
            expenditureTotalAmount =
                expenditureTotalAmount + element.totalAmount ?? 0;
            print(
                "expenditure hour is  $element1 amount $expenditureTotalAmount");
            switch (element.entryDateTime!.weekday) {
              case 7:
                sundayTotalExpenditure =
                    sundayTotalExpenditure + element.totalAmount!;
                break;
              case 1:
                mondayTotalExpenditure =
                    mondayTotalExpenditure + element.totalAmount;
                break;
              case 2:
                tuesdayTotalExpenditure =
                    tuesdayTotalExpenditure + element.totalAmount;
                break;
              case 3:
                wednesdayTotalExpenditure =
                    wednesdayTotalExpenditure + element.totalAmount!;
                break;
              case 4:
                thursdayTotalExpenditure =
                    thursdayTotalExpenditure + element.totalAmount!;
                break;
              case 5:
                fridayTotalExpenditure =
                    fridayTotalExpenditure + element.totalAmount!;
                break;
              case 6:
                saturdayTotalExpenditure =
                    saturdayTotalExpenditure + element.totalAmount!;
            }
          }

          currentTran.add(element);
        }
      });
      _hourIncomeData.add(RecordsData(element1.formatDate(pattern: "E")!,
          incomeTotalAmount, currentTran, _randomColor.randomColor()));
      _hourExpenditureData.add(RecordsData(element1.formatDate(pattern: "E")!,
          expenditureTotalAmount, currentTran, _randomColor.randomColor()));
    });
    _allIncomeHoursData(_hourIncomeData);
    _allExpenditureHoursData(_hourExpenditureData);
    _pieIncome.add(RecordsData(
        "Sunday", sundayTotalIncome, [], _randomColor.randomColor()));
    _pieIncome.add(
        RecordsData("Sun", sundayTotalIncome, [], _randomColor.randomColor()));
    _pieIncome.add(
        RecordsData("Mon", mondayTotalIncome, [], _randomColor.randomColor()));
    _pieIncome.add(
        RecordsData("Tue", tuesdayTotalIncome, [], _randomColor.randomColor()));
    _pieIncome.add(RecordsData(
        "Wed", wednesdayTotalIncome, [], _randomColor.randomColor()));
    _pieIncome.add(RecordsData(
        "Thur", thursdayTotalIncome, [], _randomColor.randomColor()));
    _pieIncome.add(
        RecordsData("Fri", fridayTotalIncome, [], _randomColor.randomColor()));
    _pieIncome.add(RecordsData(
        "Sat", saturdayTotalIncome, [], _randomColor.randomColor()));

    _pieExpenditure.add(RecordsData(
        "Sun", sundayTotalExpenditure, [], _randomColor.randomColor()));
    _pieExpenditure.add(RecordsData(
        "Mon", mondayTotalExpenditure, [], _randomColor.randomColor()));
    _pieExpenditure.add(RecordsData(
        "Tue", tuesdayTotalExpenditure, [], _randomColor.randomColor()));
    _pieExpenditure.add(RecordsData(
        "Wed", wednesdayTotalExpenditure, [], _randomColor.randomColor()));
    _pieExpenditure.add(RecordsData(
        "Thur", thursdayTotalExpenditure, [], _randomColor.randomColor()));
    _pieExpenditure.add(RecordsData(
        "Fri", fridayTotalExpenditure, [], _randomColor.randomColor()));
    _pieExpenditure.add(RecordsData(
        "Sat", saturdayTotalExpenditure, [], _randomColor.randomColor()));

    _pieIncomeValue(_pieIncome);
    _pieExpenditureValue(_pieExpenditure);
    _allIncomeTransaction(_currentHoursIncome);
    _allExpenditureTransaction(_currentHoursExpenditure);
    calculateRecordOverView();
  }

  Future getTodayTransaction() async {
    List<TransactionModel> _todayTransaction = [];
    final date = DateTime.now();
    offlineTransactions.forEach((element) {
      // print("element test date ${element.createdTime!.toIso8601String()}");
      final d = DateTime(element.entryDateTime!.year,
          element.entryDateTime!.month, element.entryDateTime!.day);
      if (d.isAtSameMomentAs(DateTime(date.year, date.month, date.day))) {
        _todayTransaction.add(element);

        // print("found date for today");
      }
    });
    todayTransaction = _todayTransaction;
    await getAllPaymentItem();
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
        "expenseCategory": selectedCategoryExpenses,
        "entryDateTime": (date == null)
            ? null
            : date!.toIso8601String().split("T")[0] +
                " " +
                "${time!.hour.toString().padLeft(2, '0')}:${time!.minute.toString().padLeft(2, '0')}",
        "amountPaid": selectedPaymentMode == "DEPOSIT"
            ? amountPaidController.numberValue
            : 0
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
        _debtorController.getOfflineDebtor(
            _businessController.selectedBusiness.value!.businessId!);
        _debtorController.getOnlineDebtor(
            _businessController.selectedBusiness.value!.businessId!);
// getSpending(_businessController.selectedBusiness.value!.businessId!);
        clearValue();
      } else {
        _addingTransactionStatus(AddingTransactionStatus.Error);
      }
    } catch (ex) {
      print("error occurred here ${ex.toString()}");
      _addingTransactionStatus(AddingTransactionStatus.Error);
    }
  }

  TransactionModel? getTransactionById(String id) {
    TransactionModel? result;
    offlineTransactions.forEach((element) {
      // print("comparing with ${element.id} to $id");
      if (element.id == id) {
        result = element;
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

    dynamic totalamount = 0;
    productList.forEach((element) {
      totalamount = totalamount + (element.totalAmount!);
    });
    // print("payment mode is $selectedPaymentMode");
    value = TransactionModel(
      expenseCategory: selectedCategoryExpenses,
      paymentMethod: selectedPaymentMode,
      paymentSource: selectedPaymentSource,
      id: uuid.v1(),
      totalAmount: totalamount,
      balance: (selectedPaymentMode == "DEPOSIT")
          ? totalamount - amountPaidController.numberValue
          : 0,
      createdTime: DateTime.now(),
      entryDateTime: DateTime(
          date!.year, date!.month, date!.day, time!.hour, time!.minute),
      transactionType: type,
      businessTransactionFileStoreId: (image == null) ? null : image!.path,
      customerId: customerId,
      businessId: _businessController.selectedBusiness.value!.businessId,
      businessTransactionPaymentItemList: productList,
      isPending: true,
    );
    List<PaymentHistory> transactionList = [];
    transactionList.add(PaymentHistory(
        id: uuid.v1(),
        isPendingUpdating: true,
        amountPaid: (selectedPaymentMode == "DEPOSIT")
            ? amountPaidController.numberValue
            : totalamount,
        paymentMode: selectedPaymentMode,
        createdDateTime: DateTime.now(),
        updateDateTime: DateTime.now(),
        deleted: false,
        businessTransactionId: value.id));

    value.businessTransactionPaymentHistoryList = transactionList;

    print("offline saving to database ${value.toJson()}}");
    if (customerId != null) if (selectedPaymentMode == "DEPOSIT") {
      Debtor debtor = Debtor(
          businessTransactionId: value.id,
          customerId: customerId,
          businessId: value.businessId,
          totalAmount: value.totalAmount,
          balance: value.balance,
          businessTransactionType: value.transactionType,
          createdTime: DateTime.now(),
          debtorId: uuid.v1());
      _businessController.sqliteDb.insertDebtor(debtor);
      _debtorController.getOfflineDebtor(
          _businessController.selectedBusiness.value!.businessId!);
    }
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
              .addBusinessCustomerWithStringWithValue(customervalue);
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
      print("server payment mode ${savenext.paymentMethod}");

      var firstItem = savenext.businessTransactionPaymentHistoryList![0];
      print("server first payment is ${firstItem.toJson()} ");

      savenext.businessTransactionPaymentHistoryList!.remove(firstItem);
//       savenext.businessTransactionPaymentHistoryList!.forEach((element) {
// print("server rest payment is ${element.toJson()} ");
//       });
      String body = jsonEncode({
        "paymentItemRequestList": savenext.businessTransactionPaymentItemList!
            .map((e) => e.toJson(""))
            .toList(),
        "transactionType": savenext.transactionType,
        "paymentSource": savenext.paymentSource,
        "businessId": savenext.businessId,
        "paymentMode": savenext.paymentMethod,
        "customerId": savenext.customerId,
        "expenseCategory": savenext.expenseCategory,
        "businessTransactionFileStoreId":
            savenext.businessTransactionFileStoreId,
        "entryDateTime": savenext.entryDateTime!.toIso8601String(),
        "amountPaid": (savenext.paymentMethod == "DEPOSIT")
            ? firstItem.amountPaid
            : savenext.totalAmount,

        // "businessTransactionPaymentHistoryList":

        // savenext.businessTransactionPaymentHistoryList!.map((e) => e.toJson()).toList()
      });

      print(" transaction body $body");

      final response =
          await http.post(Uri.parse(ApiLink.get_business_transaction),
              headers: {
                "Authorization": "Bearer ${_userController.token}",
                "Content-Type": "application/json"
              },
              body: body);

      print({"sending to server transaction response ${response.body}"});

      if (response.statusCode == 200) {
        print("transaction response ${response.body}");
        var json = jsonDecode(response.body);
        if (savenext.businessTransactionPaymentHistoryList!.isNotEmpty) {
          var response = TransactionModel.fromJson(json['data']);
          response.businessTransactionPaymentHistoryList =
              savenext.businessTransactionPaymentHistoryList!;
          await updateTransactionHisotryList(response);
//update Transaction

        }
        await deleteItem(savenext);
        var debtor = _debtorController.getDebtorByTransactionId(savenext.id!);
        if (debtor != null) {
          _businessController.sqliteDb.deleteOfflineDebtor(debtor);
          _debtorController.getOfflineDebtor(
              _businessController.selectedBusiness.value!.businessId!);
        }
        pendingTransactionToBeAdded.remove(savenext);
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
          _debtorController.getOnlineDebtor(
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
    amountController.clear();
    quantityController.text = "";
    dateController.text = "";
    timeController.text = "";
    paymentController.text = "";
    paymentSourceController.text = "";
    receiptFileController.text = "";
    amountPaidController.clear();
    date = null;
    image = null;
    selectedPaymentMode = null;
    selectedCustomer = null;
    selectedPaymentSource = null;
    selectedProduct = null;
    productList = [];
    selectedCategoryExpenses = null;
  }

  Future calculateRecordOverView() async {
    dynamic Balance = 0;
    dynamic MoneyIn = 0;
    dynamic Moneyout = 0;
    allExpenditureHoursData.forEach((element) {
      Moneyout = Moneyout + element.value;
    });

    allIncomeHoursData.forEach((element) {
      MoneyIn = MoneyIn + element.value;
    });

    Balance = MoneyIn - Moneyout;
    _recordMoneyOut(Moneyout);
    _recordMoneyIn(MoneyIn);
    _recordBalance(Balance);
    print("record money in  $MoneyIn");
    print("record money out $recordMoneyOut");
    print("record balance $Balance");
  }

  Future calculateOverView() async {
    dynamic todayBalance = 0;
    dynamic todayMoneyIn = 0;
    dynamic todayMoneyout = 0;
    print("total transaction size is ${todayTransaction.length}");
    todayTransaction.forEach((element) {
      if (element.totalAmount == null) {
        return;
      }
      if (element.transactionType == "INCOME") {
        todayMoneyIn = todayMoneyIn + (element.totalAmount - element.balance);
      } else {
        print("total amount is ${element.totalAmount} ${element.toJson()}");
        todayMoneyout = todayMoneyout + (element.totalAmount - element.balance);
      }
    });

    todayBalance = todayMoneyIn - todayMoneyout;
    income(todayMoneyIn * 1.0);
    expenses(todayMoneyout * 1.0);
    totalbalance(todayBalance * 1.0);
  }

  void addMoreProduct() {
    print("qunatity text is ${amountController.numberValue}");
    if (selectedValue == 0) {
      if (selectedProduct != null)
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
    } else {
      if (itemNameController.text.isNotEmpty &&
          amountController.numberValue > 0)
        productList.add(PaymentItem(
            itemName: itemNameController.text,
            quality: int.parse(quantityController.text),
            amount: amountController.numberValue,
            totalAmount: amountController.numberValue *
                int.parse(quantityController.text)));
    }

    selectedProduct = null;
    quantityController.text = "1";
    amountController.clear();
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
    item.amount = amountController.numberValue;
    productList[index] = item;
    quantityController.text = "1";
    amountController.clear();
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

  Future updatePaymentHistoryOnline(String transactionId, String businessId,
      dynamic amount, String mode) async {
    try {
      print("business id is $businessId");
      _addingTransactionStatus(AddingTransactionStatus.Loading);
      var response = await http.put(
          Uri.parse(ApiLink.get_business_transaction + "/" + transactionId),
          body: jsonEncode({
            "businessTransactionRequest": {
              "businessId":
                  _businessController.selectedBusiness.value!.businessId!
            },
            "paymentHistoryRequest": {"amountPaid": amount, "paymentMode": mode}
          }),
          headers: {
            "Authorization": "Bearer ${_userController.token}",
            "Content-Type": "application/json"
          });
      print(
          "update payment history response status code is ${response.statusCode} ${response.body} ");
      if (response.statusCode == 200) {
//
        var json = jsonDecode(response.body);
        List<PaymentHistory> transactionReponseList =
            List.from(json['data']['businessTransactionPaymentHistoryList'])
                .map((e) => PaymentHistory.fromJson(e))
                .toList();
        var transaction = getTransactionById(transactionId);
        transaction!.balance = json['data']['balance'];
        transaction.updatedTime =
            DateTime.parse(json['data']['updatedDateTime']);
        transaction.businessTransactionPaymentHistoryList =
            transactionReponseList;
        updateTransaction(transaction);
        return transaction;
      } else {
        Get.snackbar("Error", "Unable to Update Transaction");
      }
    } catch (ex) {
      _addingTransactionStatus(AddingTransactionStatus.Empty);
      print("error occurred ${ex.toString()}");
    } finally {
      _addingTransactionStatus(AddingTransactionStatus.Empty);
      Get.back();
    }
  }

  Future updatePaymentHistoryOffline(String transactionId, String businessId,
      dynamic amount, String mode) async {
    try {
      _addingTransactionStatus(AddingTransactionStatus.Loading);
      var transaction = getTransactionById(transactionId);
      var transactionList = transaction!.businessTransactionPaymentHistoryList;
      transactionList!.add(PaymentHistory(
          id: uuid.v1(),
          isPendingUpdating: true,
          amountPaid: amount,
          paymentMode: mode,
          createdDateTime: DateTime.now(),
          updateDateTime: DateTime.now(),
          deleted: false,
          businessTransactionId: transactionId));

      transaction.isHistoryPending = true;
      transaction.balance = transaction.balance! - amount;
      transaction.businessTransactionPaymentHistoryList = transactionList;
      updateTransaction(transaction);

      var debtor = _debtorController.getDebtorByTransactionId(transactionId);
      if (debtor != null) {
        if (transaction.balance == 0) {
          _debtorController.deleteBusinessDebtor(debtor);
        } else {
          // debtor.balance=transaction.balance;
          _debtorController.updateBusinessDebtorOffline(debtor, amount);
        }
      }
      _debtorController.getOnlineDebtor(
          _businessController.selectedBusiness.value!.businessId!);
      return transaction;
    } catch (ex) {
      _addingTransactionStatus(AddingTransactionStatus.Empty);
    } finally {
      _addingTransactionStatus(AddingTransactionStatus.Empty);
      Get.back();
    }
  }

  Future updateTransaction(TransactionModel transactionModel) async {
    _businessController.sqliteDb.updateOfflineTransaction(transactionModel);
    await GetOfflineTransactions(
        _businessController.selectedBusiness.value!.businessId!);
  }

  Future<TransactionModel?> updateTransactionHistory(String transactionId,
      String businessId, dynamic amount, String mode) async {
    var result;
    if (_userController.onlineStatus == OnlineStatus.Onilne) {
      result = await updatePaymentHistoryOnline(
          transactionId, businessId, amount, mode);
    } else {
      result = await updatePaymentHistoryOffline(
          transactionId, businessId, amount, mode);
    }

    return result;
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

  Future pendingTransactionToBeUpdate() async {
    if (pendingJobToBeUpdated.isEmpty) {
      return;
    }
    var updatedNext = pendingJobToBeUpdated[0];
    try {
      updatedNext.businessTransactionPaymentHistoryList!
          .forEach((element) async {
        if (element.isPendingUpdating!) {
          var response = await http.put(
              Uri.parse(
                  ApiLink.get_business_transaction + "/" + updatedNext.id!),
              body: jsonEncode({
                "businessTransactionRequest": {
                  "businessId": updatedNext.businessId
                },
                "paymentHistoryRequest": {
                  "amountPaid": element.amountPaid,
                  "paymentMode": element.paymentMode
                }
              }),
              headers: {
                "Authorization": "Bearer ${_userController.token}",
                "Content-Type": "application/json"
              });
          print("update history to server ${response.body}");
        }
      });
    } catch (ex) {
    } finally {
      pendingJobToBeUpdated.remove(updatedNext);
      if (pendingJobToBeUpdated.isNotEmpty) {
        checkPendingTransactionbeUpdatedToServer();
      }
      getOnlineTransaction(
          _businessController.selectedBusiness.value!.businessId!);
    }
  }

  Future updateTransactionHisotryList(TransactionModel transactionModel) async {
    var updatedNext = transactionModel;
    try {
      updatedNext.businessTransactionPaymentHistoryList!
          .forEach((element) async {
        var response = await http.put(
            Uri.parse(ApiLink.get_business_transaction + "/" + updatedNext.id!),
            body: jsonEncode({
              "businessTransactionRequest": {
                "businessId": updatedNext.businessId
              },
              "paymentHistoryRequest": {
                "amountPaid": element.amountPaid,
                "paymentMode": element.paymentMode
              }
            }),
            headers: {
              "Authorization": "Bearer ${_userController.token}",
              "Content-Type": "application/json"
            });
        print("update history to server ${response.body}");
      });
    } catch (ex) {
    } finally {
      await getOnlineTransaction(
          _businessController.selectedBusiness.value!.businessId!);
      _debtorController.getOnlineDebtor(
          _businessController.selectedBusiness.value!.businessId!);

      _debtorController.getOnlineDebtor(
          _businessController.selectedBusiness.value!.businessId!);
    }
  }

  Future deleteTransactionOnline(TransactionModel transactionModel) async {
    try {
      print("deleting from online");
      var response = await http.delete(
          Uri.parse(
              ApiLink.get_business_transaction + "/" + transactionModel.id!),
          headers: {
            "Authorization": "Bearer ${_userController.token}",
            "Content-Type": "application/json"
          });
      print("transaction deletion detail response ${response.body}}");

      if (response.statusCode == 200) {
        await _businessController.sqliteDb
            .deleteOfflineTransaction(transactionModel);
        var debtor =
            _debtorController.getDebtorByTransactionId(transactionModel.id!);
        if (debtor != null) _debtorController.deleteBusinessDebtor(debtor);
        _debtorController.getOnlineDebtor(
            _businessController.selectedBusiness.value!.businessId!);
        await GetOfflineTransactions(
            _businessController.selectedBusiness.value!.businessId!);
        Get.back();
      } else if (response.statusCode == 404) {
        await _businessController.sqliteDb
            .deleteOfflineTransaction(transactionModel);

        await GetOfflineTransactions(
            _businessController.selectedBusiness.value!.businessId!);
        _debtorController.getOnlineDebtor(
            _businessController.selectedBusiness.value!.businessId!);
        Get.back();
      }
    } catch (ex) {
      print("error from transaction deletion ${ex.toString()}");
    }
  }

  Future deleteTransactionOffline(TransactionModel transactionModel) async {
    transactionModel.deleted = true;
    if (transactionModel.isPending) {
      _businessController.sqliteDb.deleteOfflineTransaction(transactionModel);
      await GetOfflineTransactions(
          _businessController.selectedBusiness.value!.businessId!);
    } else {
      updateTransaction(transactionModel);
    }
    var debtor =
        _debtorController.getDebtorByTransactionId(transactionModel.id!);
    if (debtor != null) {
      print("debtor foundsss ${debtor.toJson()}");
      _businessController.sqliteDb.deleteOfflineDebtor(debtor);
      _debtorController.getOfflineDebtor(
          _businessController.selectedBusiness.value!.businessId!);
    }
    Get.back();
  }

  Future deleteTransaction(TransactionModel transactionModel) async {
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

  Future deletePendingJobToServer() async {
    try {
      if (pendingJobToBeDelete.isEmpty) return;

      var deleteNext = pendingJobToBeDelete[0];
      var response = await http.delete(
          Uri.parse(ApiLink.get_business_transaction + "/" + deleteNext.id!),
          headers: {
            "Authorization": "Bearer ${_userController.token}",
            "Content-Type": "application/json"
          });
      if (response.statusCode == 200) {
        _businessController.sqliteDb.deleteOfflineTransaction(deleteNext);
      }
      pendingJobToBeDelete.remove(deleteNext);
    } catch (ex) {
    } finally {
      if (pendingJobToBeDelete.isNotEmpty) {
        deletePendingJobToServer();
      } else {
        await GetOfflineTransactions(
            _businessController.selectedBusiness.value!.businessId!);
      }
    }
  }
}
