import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:huzz/data/repository/business_repository.dart';
import 'package:huzz/data/api_link.dart';
import 'package:huzz/data/model/customer_model.dart';
import 'package:huzz/data/model/debtor.dart';
import 'package:huzz/data/sqlite/sqlite_db.dart';
import 'package:uuid/uuid.dart';
import 'package:huzz/core/util/util.dart';
import 'auth_repository.dart';
import 'customer_repository.dart';

enum AddingDebtorStatus { Loading, Error, Success, Empty }

enum DebtorStatus { Loading, Error, Available, Empty, UnAuthorized }

class DebtorRepository extends GetxController
    with GetSingleTickerProviderStateMixin {
  final _userController = Get.find<AuthRepository>();
  final _customerController = Get.find<CustomerRepository>();
  final _businessController = Get.find<BusinessRepository>();

  final Rx<List<Debtor>> _onlineBusinessDebtor = Rx([]);
  final Rx<List<Debtor>> _offlineBusinessDebtor = Rx([]);

  List<Debtor> get onlineBusinessDebtor => _onlineBusinessDebtor.value;
  List<Debtor> get offlineBusinessDebtor => _offlineBusinessDebtor.value;

  List<Debtor> pendingBusinessDebtor = [];

  final Rx<List<Debtor>> _DebtorService = Rx([]);
  final Rx<List<Debtor>> _DebtorGoods = Rx([]);
  final Rx<List<Debtor>> _deleteDebtorList = Rx([]);

  final isDebtorService = false.obs;
  Rx<Debtor?> deletingItem = Rx(null);

  List<Debtor> get DebtorServices => _DebtorService.value;
  List<Debtor> get DebtorGoods => _DebtorGoods.value;

  Rx<File?> DebtorImage = Rx(null);
  SqliteDb sqliteDb = SqliteDb();

  MoneyMaskedTextController totalAmountController =
      MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  MoneyMaskedTextController amountController =
      MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final serviceDescription = TextEditingController();

  MoneyMaskedTextController DebtorSellingPriceController =
      MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  final DebtorQuantityController = TextEditingController();
  final DebtorUnitController = TextEditingController();

  AddingDebtorStatus get addingDebtorStatus => _addingDebtorStatus.value;
  TabController? tabController;

  List<Debtor> pendingUpdatedDebtorList = [];
  List<Debtor> pendingToUpdatedDebtorToServer = [];
  List<Debtor> pendingToBeAddedDebtorToServer = [];
  List<Debtor> pendingDeletedDebtorToServer = [];
  final Rx<List<Debtor>> _debtorsList = Rx([]);
  final Rx<List<Debtor>> _debtOwnedList = Rx([]);
  final Rx<List<Debtor>> _fullyPaidDebt = Rx([]);
  final Rx<List<Debtor>> _fullyPaidDebtOwned = Rx([]);
  List<Debtor> get fullyPaidDebt => _fullyPaidDebt.value;
  List<Debtor> get fullyPaidDebtOwned => _fullyPaidDebtOwned.value;

  List<Debtor> get debtorsList => _debtorsList.value;
  List<Debtor> get debtOwnedList => _debtOwnedList.value;
  final Rx<dynamic> _debotorAmount = Rx(0);
  final Rx<dynamic> _debtOwnedAmount = Rx(0);
  dynamic get totalDebt => _debotorAmount.value - _debtOwnedAmount.value;
  dynamic get debtorAmount => _debotorAmount.value;
  dynamic get debtOwnedAmount => _debtOwnedAmount.value;
  bool get isTotalDebtNegative => (totalDebt as num).sign == -1;
  List<Debtor> get deleteDebtorList => _deleteDebtorList.value;
  final isLoading = false.obs;

  final _addingDebtorStatus = AddingDebtorStatus.Empty.obs;
  final _debtorStatus = DebtorStatus.Empty.obs;

  DebtorStatus get debtorStatus => _debtorStatus.value;

  var uuid = Uuid();
  // ignore: avoid_init_to_null
  Customer? selectedCustomer = null;
  int customerType = 0;
  @override
  void onInit() async {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);

    //  await sqliteDb.openDatabae();
    _userController.mToken.listen((p0) {
      if (p0.isNotEmpty || p0 != "0") {
        final value = _businessController.selectedBusiness.value;
        if (value != null && value.businessId != null) {
          getOnlineDebtor(value.businessId!);
          getOfflineDebtor(value.businessId!);
        }
        _businessController.selectedBusiness.listen((p0) {
          if (p0 != null && p0.businessId != null) {
            totalAmountController = MoneyMaskedTextController(
                leftSymbol: '${Utils.getCurrency()} ',
                decimalSeparator: '.',
                thousandSeparator: ',');
            amountController = MoneyMaskedTextController(
                leftSymbol: '${Utils.getCurrency()} ',
                decimalSeparator: '.',
                thousandSeparator: ',');
            DebtorSellingPriceController = MoneyMaskedTextController(
                leftSymbol: '${Utils.getCurrency()} ',
                decimalSeparator: '.',
                thousandSeparator: ',');
            _offlineBusinessDebtor([]);

            _onlineBusinessDebtor([]);
            _DebtorService([]);
            _DebtorGoods([]);
            getOnlineDebtor(p0.businessId!);
            getOfflineDebtor(p0.businessId!);
          }
        });
      }
    });
    _userController.monLineStatus.listen((po) {
      if (po == OnlineStatus.Onilne) {
        _businessController.selectedBusiness.listen((p0) {
          checkPendingCustomerTobeUpdatedToServer();
          checkPendingDebtorToBeAddedToSever();
          checkPendingCustomerToBeDeletedOnServer();
          //update server with pending job
        });
      }
    });
  }

  Future addDebtorOnline(String type) async {
    try {
      _addingDebtorStatus(AddingDebtorStatus.Loading);
      // String? fileId = null;
      // if (DebtorImage.value != null) {
      //   fileId =
      //       await _uploadFileController.uploadFile(DebtorImage.value!.path);
      // }

      var customerId;
      if (customerType == 1) {
        customerId =
            await _customerController.addBusinessCustomerWithString(type);
      } else {
        if (selectedCustomer != null) customerId = selectedCustomer!.customerId;
      }

      var response = await http.post(Uri.parse(ApiLink.addDebtor),
          body: jsonEncode({
            "balance": totalAmountController.numberValue - 0,
            "totalAmount": totalAmountController.numberValue,
            "businessId":
                _businessController.selectedBusiness.value!.businessId!,
            "businessTransactionType": type,
            "customerId": customerId
          }),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${_userController.token}"
          });

      if (response.statusCode == 200) {
        await getOnlineDebtor(
            _businessController.selectedBusiness.value!.businessId!);
        getOfflineDebtor(
            _businessController.selectedBusiness.value!.businessId!);
        clearValue();
        _addingDebtorStatus(AddingDebtorStatus.Success);
        // Get.to(Confirmation(
        //   text: "Added",
        //   title: title,
        // ));
      } else {
        _addingDebtorStatus(AddingDebtorStatus.Error);
        Get.snackbar("Error", "Unable to add Debtor");
      }
    } catch (ex) {
      Get.snackbar("Error", "Unknown error occurred.. try again");
      _addingDebtorStatus(AddingDebtorStatus.Error);
    }
  }

  Future addBudinessDebtor(String type) async {
    if (_userController.onlineStatus == OnlineStatus.Onilne) {
      await addDebtorOnline(type);
      Get.back();
      if (type == "INCOME")
        Get.snackbar(
          "Sucessful",
          "New Debtor Added successfully",
        );
      else
        Get.snackbar(
          "Sucessful",
          "New Debt Owed Added successfully",
        );
    } else {
      await addBusinessDebtorOffline(type);
      Get.back();
      if (type == "INCOME")
        Get.snackbar(
          "Sucessful",
          "New Debtor Added successfully",
        );
      else
        Get.snackbar(
          "Sucessful",
          "New Debt Owed Added successfully",
        );
    }
  }

  // ignore: non_constant_identifier_names
  Future UpdateBusinessDebtor(Debtor debtor, dynamic amount) async {
    if (_userController.onlineStatus == OnlineStatus.Onilne) {
      await updateBusinessDebtorOnline(debtor, amount);
    } else {
      await updateBusinessDebtorOffline(debtor, amount);
    }
  }

  Future addBusinessDebtorOffline(String type) async {
    // File? outFile;
    // if (DebtorImage.value != null) {
    //   var list = await getApplicationDocumentsDirectory();

    //   Directory appDocDir = list;
    //   String appDocPath = appDocDir.path;

    //   String basename = path.basename(DebtorImage.value!.path);
    //   var newPath = appDocPath + basename;
    //   print("new file path is ${newPath}");
    //   outFile = File(newPath);
    //   DebtorImage.value!.copySync(outFile.path);
    // }

    Debtor debtor = Debtor();

    var customerId;
    if (customerType == 1) {
      customerId = await _customerController
          .addBusinessCustomerOfflineWithString(type, isdebtor: true);
    } else {
      if (selectedCustomer != null) customerId = selectedCustomer!.customerId;
    }
    debtor = Debtor(
        isPendingAdding: true,
        debtorId: uuid.v1(),
        businessId: _businessController.selectedBusiness.value!.businessId!,
        createdTime: DateTime.now(),
        businessTransactionType: type,
        totalAmount: totalAmountController.numberValue,
        balance: totalAmountController.numberValue - 0);
    _businessController.sqliteDb.insertDebtor(debtor);
    clearValue();
    getOfflineDebtor(_businessController.selectedBusiness.value!.businessId!);
    // Get.to(Confirmation(
    //   text: "Added",
    //   title: title,
    // ));
  }

  Future calculateDebtsAndDebtsOwned() async {
    dynamic totalDebotors = 0;
    debtorsList.forEach((element) {
      totalDebotors = totalDebotors + element.balance;
    });

    final _debtOwned =
        debtOwnedList.fold<num>(0, (acc, debt) => acc + debt.balance);

    _debotorAmount(totalDebotors);
    _debtOwnedAmount(_debtOwned);
  }

  Future updateBusinessDebtorOffline(Debtor debtor, dynamic amount) async {
    // File? outFile;
    // // ignore: unnecessary_null_comparison
    // if (DebtorImage != null) {
    //   var list = await getApplicationDocumentsDirectory();

    //   Directory appDocDir = list;
    //   String appDocPath = appDocDir.path;

    //   String basename = path.basename(DebtorImage.value!.path);
    //   var newPath = appDocPath + basename;
    //   // ignore: unnecessary_brace_in_string_interps
    //   print("new file path is ${newPath}");
    //   outFile = File(newPath);
    //   DebtorImage.value!.copySync(outFile.path);
    // }

    if (!debtor.isPendingUpdating! || !debtor.isPendingAdding!) {
      debtor.isPendingUpdating = true;
    }
    debtor.balance = debtor.balance! - amount;
    debtor.paid = debtor.balance! - amount == 0;

    _businessController.sqliteDb.updateOfflineDebtor(debtor);
    clearValue();
    // Get.to(Confirmation(
    //   text: "Updated",
    //   title: title,
    // ));
  }

  void clearValue() {
    DebtorImage(null);
    amountController.clear();
    DebtorQuantityController.text = "";
    totalAmountController.clear();
    DebtorSellingPriceController.clear();
    DebtorUnitController.text = "";
    serviceDescription.text = "";
  }

  Future updateBusinessDebtorOnline(Debtor debtor, dynamic amount) async {
    try {
      _addingDebtorStatus(AddingDebtorStatus.Loading);
      String? fileId;

      var response =
          await http.put(Uri.parse(ApiLink.addDebtor + "/" + debtor.debtorId!),
              body: jsonEncode({
                "balance": debtor.balance! - amount,
                "paid": debtor.balance! - amount == 0,

// "quantity":DebtorQuantityController.text,
                "businessId": debtor.businessId,
              }),
              headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${_userController.token}"
          });

      if (response.statusCode == 200) {
        _addingDebtorStatus(AddingDebtorStatus.Success);
        getOnlineDebtor(
            _businessController.selectedBusiness.value!.businessId!);

        // Get.to(Confirmation(
        //   text: "Updated",
        //   title: title,
        // ));
        clearValue();
      } else {
        _addingDebtorStatus(AddingDebtorStatus.Error);
        Get.snackbar("Error", "Unable to update Debtor");
      }
    } catch (ex) {
      _addingDebtorStatus(AddingDebtorStatus.Error);
    }
  }

  void setItem(Debtor debtor) {
    // DebtorNameController.text = Debtor.DebtorName!;
    // DebtorQuantityController.text = Debtor.quantity!.toString();
    // DebtorCostPriceController.text = Debtor.costPrice.toString();
    // DebtorSellingPriceController.text = Debtor.sellingPrice.toString();
    DebtorUnitController.text = "";
    serviceDescription.text = "";
  }

  Future getOfflineDebtor(String businessId) async {
    var result =
        await _businessController.sqliteDb.getOfflineDebtors(businessId);
    _offlineBusinessDebtor(result);
    classifiedDebt();
    calculateDebtsAndDebtsOwned();
    setPaidDebt();
    // setDebtorDifferent();
  }

  Future classifiedDebt() async {
    List<Debtor> debtors = [];
    List<Debtor> debtOwned = [];
    offlineBusinessDebtor.where((element) => !element.paid!).forEach((element) {
      if (element.businessTransactionType == "INCOME") {
        debtors.add(element);
      } else {
        debtOwned.add(element);
      }
    });
    _debtOwnedList(debtOwned);
    _debtorsList(debtors);
  }

  Future setPaidDebt() async {
    List<Debtor> debtors = [];
    List<Debtor> debtOwned = [];
    offlineBusinessDebtor.where((element) => element.paid!).forEach((element) {
      if (element.businessTransactionType == "INCOME") {
        debtors.add(element);
      } else {
        debtOwned.add(element);
      }
    });
    _fullyPaidDebtOwned(debtOwned);
    _fullyPaidDebt(debtors);
  }

  Debtor? getDebtorByTransactionId(String id) {
    Debtor? result;
    offlineBusinessDebtor.forEach((element) {
      // print("comparing with ${element.id} to $id");
      if (element.businessTransactionId == id) {
        result = element;
        return;
      }
    });
    return result;
  }

  Future getOnlineDebtor(String businessId) async {
    _debtorStatus(DebtorStatus.Loading);
    final response = await http.get(
        Uri.parse(ApiLink.addDebtor + "?businessId=" + businessId),
        headers: {"Authorization": "Bearer ${_userController.token}"});

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      if (json['success']) {
        var result = List.from(json['data']['content'])
            .map((e) => Debtor.fromJson(e))
            .toList();
        _onlineBusinessDebtor(result);
        result.isNotEmpty
            ? _debtorStatus(DebtorStatus.Available)
            : _debtorStatus(DebtorStatus.Empty);
        await getBusinessDebtorYetToBeSavedLocally();
        checkIfUpdateAvailable();
      }
    } else if ((response.statusCode == 500)) {
      _debtorStatus(DebtorStatus.UnAuthorized);
    } else {
      _debtorStatus(DebtorStatus.Error);
    }
  }

  Future getBusinessDebtorYetToBeSavedLocally() async {
    onlineBusinessDebtor.forEach((element) {
      if (!checkifDebtorAvailable(element.debtorId!)) {
        pendingBusinessDebtor.add(element);
      }
    });

    savePendingJob();
  }

  Future checkIfUpdateAvailable() async {
    onlineBusinessDebtor.forEach((element) async {
      var item = checkifDebtorAvailableWithValue(element.debtorId!);
      if (item != null) {
        if (!element.updatedTime!.isAtSameMomentAs(item.updatedTime!)) {
          pendingUpdatedDebtorList.add(element);
        }
      }
    });

    updatePendingJob();
  }

  // Future setDebtorDifferent() async {
  //   List<Debtor> goods = [];
  //   List<Debtor> services = [];
  //   offlineBusinessDebtor.forEach((element) {
  //     if (element.DebtorType == "SERVICES") {
  //       services.add(element);
  //     } else {
  //       goods.add(element);
  //     }
  //   });
  //   _DebtorGoods(goods);
  //   _DebtorService(services);
  // }

  Future updatePendingJob() async {
    if (pendingUpdatedDebtorList.isEmpty) {
      return;
    }

    var updatednext = pendingUpdatedDebtorList.first;
    await _businessController.sqliteDb.updateOfflineDebtor(updatednext);
    pendingUpdatedDebtorList.remove(updatednext);
    if (pendingUpdatedDebtorList.isNotEmpty) {
      updatePendingJob();
    }
    getOfflineDebtor(updatednext.businessId!);
  }

  Future savePendingJob() async {
    if (pendingBusinessDebtor.isEmpty) {
      return;
    }
    var savenext = pendingBusinessDebtor.first;
    await _businessController.sqliteDb.insertDebtor(savenext);
    pendingBusinessDebtor.remove(savenext);
    if (pendingBusinessDebtor.isNotEmpty) {
      savePendingJob();
    }
    getOfflineDebtor(savenext.businessId!);
  }

  bool checkifDebtorAvailable(String id) {
    bool result = false;
    offlineBusinessDebtor.forEach((element) {
      if (element.debtorId == id) {
        result = true;
      }
    });
    return result;
  }

  Debtor? checkifDebtorAvailableWithValue(String id) {
    Debtor? item;

    offlineBusinessDebtor.forEach((element) {
      if (element.debtorId == id) {
        item = element;
      }
    });
    return item;
  }

  Future deleteDebtorOnline(Debtor debtor) async {
    await http.delete(
        Uri.parse(ApiLink.addDebtor +
            "/${debtor.debtorId}?businessId=${debtor.businessId}"),
        headers: {"Authorization": "Bearer ${_userController.token}"});
  }

  Future deleteBusinessDebtor(Debtor debtor) async {
    deletingItem(debtor);
    if (_userController.onlineStatus == OnlineStatus.Onilne) {
      await deleteDebtorOnline(debtor);
      await getOnlineDebtor(
          _businessController.selectedBusiness.value!.businessId!);
    }
    await deleteBusinessDebtorOffline(debtor);
    getOfflineDebtor(_businessController.selectedBusiness.value!.businessId!);
    deletingItem(null);
  }

  Future deleteBusinessDebtorOffline(Debtor debtor) async {
    debtor.deleted = true;
    _businessController.sqliteDb.deleteOfflineDebtor(debtor);
    getOfflineDebtor(_businessController.selectedBusiness.value!.businessId!);
  }

  bool checkifSelectedForDelted(String id) {
    bool result = false;
    deleteDebtorList.forEach((element) {
      if (element.debtorId == id) {
        result = true;
      }
    });
    return result;
  }

  Future deleteSelectedItem() async {
    if (deleteDebtorList.isEmpty) {
      return;
    }
    var deleteNext = deleteDebtorList.first;
    await deleteBusinessDebtor(deleteNext);
    var list = deleteDebtorList;
    list.remove(deleteNext);
    _deleteDebtorList(list);

    if (deleteDebtorList.isNotEmpty) {
      deleteSelectedItem();
    }
    getOfflineDebtor(deleteNext.businessId!);
  }

  void addToDeleteList(Debtor Debtor) {
    var list = deleteDebtorList;
    list.add(Debtor);
    _deleteDebtorList(list);
  }

  void removeFromDeleteList(Debtor Debtor) {
    var list = deleteDebtorList;
    list.remove(Debtor);
    _deleteDebtorList(list);
  }

  Future checkPendingDebtorToBeAddedToSever() async {
    offlineBusinessDebtor.forEach((element) {
      if (element.isPendingAdding!) {
        pendingToBeAddedDebtorToServer.add(element);
      }
    });
    addPendingJobDebtorToServer();
  }

  Future checkPendingCustomerTobeUpdatedToServer() async {
    // offlineBusinessDebtor.forEach((element) {
    //   if (element.isUpdatingPending! && !element.isAddingPending!) {
    //     pendingToUpdatedDebtorToServer.add(element);
    //   }
    // });

    updatePendingJob();
  }

  Future checkPendingCustomerToBeDeletedOnServer() async {
    var list = await _businessController.sqliteDb.getOfflineDebtors(
        _businessController.selectedBusiness.value!.businessId!);

    list.forEach((element) {
      if (element.deleted!) {
        pendingDeletedDebtorToServer.add(element);
      }
    });
    deletePendingJobToServer();
  }

  Future addPendingJobDebtorToServer() async {
    if (pendingToBeAddedDebtorToServer.isEmpty) {
      return;
    }

    pendingToBeAddedDebtorToServer.forEach((element) async {
      var savenext = element;
      if (savenext.customerId != null && savenext.customerId != " ") {
        var customervalue = await _businessController.sqliteDb
            .getOfflineCustomer(savenext.customerId!);
        if (customervalue != null && customervalue.isCreatedFromDebtors!) {
          String? customerId = await _customerController
              .addBusinessCustomerWithStringWithValue(customervalue);
          savenext.customerId = customerId;
          _businessController.sqliteDb.deleteCustomer(customervalue);
        }
      } else {}

      // if (savenext.debtorLogoFileStoreId != null &&
      //     savenext.DebtorLogoFileStoreId != '') {
      //   String image = await _uploadImageController
      //       .uploadFile(savenext.DebtorLogoFileStoreId!);

      //   File _file = File(savenext.DebtorLogoFileStoreId!);
      //   savenext.DebtorLogoFileStoreId = image;
      //   _file.deleteSync();
      // }

      var response = await http.post(Uri.parse(ApiLink.addDebtor),
          body: jsonEncode(savenext.toJson()),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${_userController.token}"
          });
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        if (json['success']) {
          getOnlineDebtor(
              _businessController.selectedBusiness.value!.businessId!);

          // _businessController.sqliteDb.deleteDebtor(savenext);

          pendingToBeAddedDebtorToServer.remove(savenext);
        }
      }

      if (pendingToBeAddedDebtorToServer.isNotEmpty) {
        addPendingJobDebtorToServer();
      }
    });
  }

  Future addPendingJobToBeUpdateToServer() async {
    if (pendingToUpdatedDebtorToServer.isEmpty) {
      return;
    }
    pendingToUpdatedDebtorToServer.forEach((element) async {
      var updatenext = element;

      var response = await http.put(
          Uri.parse(ApiLink.addDebtor + "/" + updatenext.debtorId!),
          body: jsonEncode(updatenext.toJson()),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${_userController.token}"
          });

      if (response.statusCode == 200) {
        getOnlineDebtor(
            _businessController.selectedBusiness.value!.businessId!);
        pendingToUpdatedDebtorToServer.remove(updatenext);
      }
      if (pendingToUpdatedDebtorToServer.isNotEmpty)
        addPendingJobToBeUpdateToServer();
    });
  }

  Future deletePendingJobToServer() async {
    if (pendingDeletedDebtorToServer.isEmpty) {
      return;
    }
    pendingDeletedDebtorToServer.forEach((element) async {
      var deleteNext = element;
      var response = await http.delete(
          Uri.parse(ApiLink.addDebtor +
              "/${deleteNext.debtorId}?businessId=${deleteNext.businessId}"),
          headers: {"Authorization": "Bearer ${_userController.token}"});
      if (response.statusCode == 200) {
        _businessController.sqliteDb.deleteOfflineDebtor(deleteNext);
        getOfflineDebtor(
            _businessController.selectedBusiness.value!.businessId!);
      } else {}

      pendingDeletedDebtorToServer.remove(deleteNext);
      if (pendingDeletedDebtorToServer.isNotEmpty) {
        deletePendingJobToServer();
      }
    });
  }

  Future deleteDebtorItem(Debtor debtor) async {
    _businessController.sqliteDb.deleteOfflineDebtor(debtor);
    getOfflineDebtor(_businessController.selectedBusiness.value!.businessId!);
  }

  Future updateDebtorItem(Debtor debtor) async {
    _businessController.sqliteDb.updateOfflineDebtor(debtor);
    getOfflineDebtor(_businessController.selectedBusiness.value!.businessId!);
  }
}
