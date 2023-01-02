import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:huzz/data/repository/auth_repository.dart';
import 'package:huzz/data/repository/business_repository.dart';
import 'package:huzz/data/repository/file_upload_respository.dart';
import 'package:huzz/data/api_link.dart';
import 'package:huzz/data/model/bank.dart';
import 'package:huzz/data/sqlite/sqlite_db.dart';
import 'package:random_color/random_color.dart';
import 'package:uuid/uuid.dart';

enum AddingBankInfoStatus { Loading, Error, Success, Empty, UnAuthorized }

class BankAccountRepository extends GetxController {
  final bankAccountNameController = TextEditingController();
  final accoutNumberController = TextEditingController();

  final bankNameController = TextEditingController();
  final _businessController = Get.find<BusinessRespository>();
  final _userController = Get.find<AuthRepository>();
  final _addingBankStatus = AddingBankInfoStatus.Empty.obs;
  var uuid = Uuid();
  Rx<List<Bank>> _onlineBusinessBank = Rx([]);
  Rx<List<Bank>> _offlineBusinessBank = Rx([]);
  List<Bank> get offlineBusinessBank => _offlineBusinessBank.value;
  List<Bank> get onlineBusinessBank => _onlineBusinessBank.value;
  List<Bank> pendingBusinessBank = [];
  AddingBankInfoStatus get addingBankStatus => _addingBankStatus.value;
  TabController? tabController;
  Rx<List<Bank>> _deleteBankList = Rx([]);
  List<Bank> get deleteBankList => _deleteBankList.value;
  List<Bank> pendingUpdatedBankList = [];
  Rx<List<Bank>> _offlineBank = Rx([]);
  // Rx<List<Bank>> _BankMerchant = Rx([]);
  final isBankService = false.obs;
  List<Bank> get offlineBank => _offlineBank.value;
  // List<Bank> get BankMerchant => _BankMerchant.value;
  List<Contact> contactList = [];

  Rx<File?> BankImage = Rx(null);
  final _uploadFileController = Get.find<FileUploadRespository>();
  SqliteDb sqliteDb = SqliteDb();
  RandomColor _randomColor = RandomColor();
  List<Bank> pendingJobToBeAdded = [];
  List<Bank> pendingJobToBeUpdated = [];
  List<Bank> pendingJobToBeDelete = [];

  @override
  void onInit() {
    // TODO: implement onInit

    _userController.mToken.listen((p0) {
      if (p0.isNotEmpty || p0 != "0") {
        final value = _businessController.selectedBusiness.value;
        if (value != null && value.businessId != null) {
          getOnlineBank(value.businessId!);
          getOfflineBank(value.businessId!);
        }
        _businessController.selectedBusiness.listen((p0) {
          if (p0 != null && p0.businessId != null) {
            print("business id ${p0.businessId}");
            _offlineBusinessBank([]);

            _onlineBusinessBank([]);

            getOnlineBank(p0.businessId!);
            getOfflineBank(p0.businessId!);
          }
        });
      }
    });

    _userController.monLineStatus.listen((po) {
      if (po == OnlineStatus.Onilne) {
        _businessController.selectedBusiness.listen((p0) {
          checkPendingBankToBeAddedToSever();
          checkPendingBankToBeDeletedOnServer();
          checkPendingBankTobeUpdatedToServer();
          //update server with pending job
        });
      }
    });

    // getPhoneContact();
  }

  // Future getPhoneContact() async {
  //   print("trying phone contact list");
  //   if (await FlutterContacts.requestPermission()) {
  //     contactList = await FlutterContacts.getContacts(
  //         withProperties: true, withPhoto: false);
  //     print("phone contact ${contactList.length}");
  //   }
  // }

  Future addBusinnessBank() async {
    if (_userController.onlineStatus == OnlineStatus.Onilne) {
      addBusinessBankOnline();
    } else {
      addBusinessBankOffline();
    }
  }

  Future updateBusinessBank(Bank item) async {
    if (_userController.onlineStatus == OnlineStatus.Onilne) {
      updateBankOnline(item);
    } else {
      updateBankOffline(item);
    }
  }

  Future deleteBusinessBank(Bank item) async {
    if (_userController.onlineStatus == OnlineStatus.Onilne) {
      deleteBankOnline(item);
    } else {
      deleteBankOffline(item);
    }
  }

  Future addBusinessBankOnline() async {
    try {
      _addingBankStatus(AddingBankInfoStatus.Loading);
      var response = await http.post(Uri.parse(ApiLink.addBankInfo),
          body: jsonEncode({
            "businessId":
                _businessController.selectedBusiness.value!.businessId,
            "bankName": bankNameController.text,
            "bankAccountNumber": accoutNumberController.text,
            "bankAccountName": bankAccountNameController.text
          }),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${_userController.token}"
          });

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        if (json['success']) {
          _addingBankStatus(AddingBankInfoStatus.Success);
          getOnlineBank(
              _businessController.selectedBusiness.value!.businessId!);
          clearValue();
          Get.back();
          // Get.to(ConfirmationBank(
          //   text: "Added",
          // ));
          return json['data']['id'];
        } else {
          _addingBankStatus(AddingBankInfoStatus.Error);
          Get.snackbar("Error", "Unable to add Bank");
        }
      } else {
        _addingBankStatus(AddingBankInfoStatus.Error);
        Get.snackbar("Error", "Unable to add Bank");
      }
    } catch (ex) {
      _addingBankStatus(AddingBankInfoStatus.Error);
      Get.snackbar("Error", "Unknown error occurred.. try again");
    }
  }

  Future<String?> addBusinessBankWithString() async {
    try {
      var response = await http.post(Uri.parse(ApiLink.addBankInfo),
          body: jsonEncode({
            "businessId":
                _businessController.selectedBusiness.value!.businessId,
            "bankName": bankNameController.text,
            "bankAccountNumber": accoutNumberController.text,
            "bankAccountName": bankAccountNameController.text
          }),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${_userController.token}"
          });

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        if (json['success']) {
          await getOnlineBank(
              _businessController.selectedBusiness.value!.businessId!);
          clearValue();

          return json['data']['id'];
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (ex) {
      return null;
    }
  }

  Future<String?> addBusinessBankOfflineWithString() async {
    var bank = Bank(
        bankName: bankNameController.text,
        bankAccountName: bankAccountNameController.text,
        bankAccountNumber: accoutNumberController.text,
        businessId: _businessController.selectedBusiness.value!.businessId,
        id: uuid.v1(),
        isCreatedFromInvoice: true,
        createdDateTime: DateTime.now(),
        updatedDateTime: DateTime.now());

    await _businessController.sqliteDb.insertBankAccount(bank);
    await getOfflineBank(
        _businessController.selectedBusiness.value!.businessId!);
    clearValue();
    return bank.id!;
  }

  Future addBusinessBankOffline() async {
    var bank = Bank(
        bankName: bankNameController.text,
        bankAccountName: bankAccountNameController.text,
        bankAccountNumber: accoutNumberController.text,
        businessId: _businessController.selectedBusiness.value!.businessId,
        id: uuid.v1(),
        isAddingPending: true,
        createdDateTime: DateTime.now(),
        updatedDateTime: DateTime.now());
    // print("bank json is ${bank.toJson()}");
    await _businessController.sqliteDb.insertBankAccount(bank);
    getOfflineBank(bank.businessId!);
    clearValue();
    Get.back();
    //  Get.to(ConfirmationBank(
    //           text: "Added",
    //         ));
  }

  Future updateBankOnline(Bank bank) async {
    try {
      _addingBankStatus(AddingBankInfoStatus.Loading);
      String? fileId;

      if (BankImage.value != null) {
        fileId = await _uploadFileController.uploadFile(BankImage.value!.path);
      }
      var response =
          await http.put(Uri.parse(ApiLink.addBankInfo + "/" + bank.id!),
              body: jsonEncode({
                "businessId":
                    _businessController.selectedBusiness.value!.businessId,
                "bankName": bankNameController.text,
                "bankAccountNumber": accoutNumberController.text,
                "bankAccountName": bankAccountNameController.text
              }),
              headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${_userController.token}"
          });

      // print("update Bank response ${response.body}");
      if (response.statusCode == 200) {
        _addingBankStatus(AddingBankInfoStatus.Success);
        getOnlineBank(_businessController.selectedBusiness.value!.businessId!);

        // Get.to(ConfirmationBank(
        //   text: "Updated",
        // ));
        Get.back();
        clearValue();
      } else {
        _addingBankStatus(AddingBankInfoStatus.Error);
        Get.snackbar("Error", "Unable to update Bank");
      }
    } catch (ex) {
      _addingBankStatus(AddingBankInfoStatus.Error);
    }
  }

  Future updateBankOffline(Bank bank) async {
    bank.isUpdatingPending = true;
    bank.updatedDateTime = DateTime.now();

    await _businessController.sqliteDb.updateOfflineBank(bank);
//  Get.to(ConfirmationBank(
//           text: "Updated",
//         ));
    getOfflineBank(bank.businessId!);
  }

  Future getOfflineBank(String businessId) async {
    var result =
        await _businessController.sqliteDb.getOfflineBankInfos(businessId);
    var list = result.where((c) => c.deleted == false).toList();
    _offlineBusinessBank(list);
    // print("offline Bank found ${result.length}");
    // setBankDifferent();
  }

  Future getOnlineBank(String businessId) async {
    _addingBankStatus(AddingBankInfoStatus.Loading);
    // print("trying to get Bank online");
    final response = await http.get(
        Uri.parse(ApiLink.addBankInfo + "?businessId=" + businessId),
        headers: {"Authorization": "Bearer ${_userController.token}"});

    // print("result of get Bank online ${response.body}");
    if (response.statusCode == 200) {
      _addingBankStatus(AddingBankInfoStatus.Loading);
      var json = jsonDecode(response.body);
      if (json['success']) {
        var result =
            List.from(json['data']).map((e) => Bank.fromJson(e)).toList();
        _onlineBusinessBank(result);
        // print("Bank business lenght ${result.length}");
        await getBusinessBankYetToBeSavedLocally();
        checkIfUpdateAvailable();
      }
    } else if (response.statusCode == 500) {
      _addingBankStatus(AddingBankInfoStatus.UnAuthorized);
    } else {
      _addingBankStatus(AddingBankInfoStatus.Error);
    }
  }

  Future getBusinessBankYetToBeSavedLocally() async {
    onlineBusinessBank.forEach((element) {
      if (!checkifBankAvailable(element.id!)) {
        // print("does not contain value");

        pendingBusinessBank.add(element);
      }
    });

    savePendingJob();
  }

  Future checkIfUpdateAvailable() async {
    onlineBusinessBank.forEach((element) async {
      var item = checkifBankAvailableWithValue(element.id!);
      if (item != null) {
        // print("item Bank is found");
        // print("updated offline ${item.updatedDateTime!.toIso8601String()}");
        // print("updated online ${element.updatedDateTime!.toIso8601String()}");
        if (!element.updatedDateTime!.isAtSameMomentAs(item.updatedDateTime!)) {
          // print("found Bank to updated");
          pendingUpdatedBankList.add(element);
        }
      }
    });

    updatePendingJob();
  }

  // Future setBankDifferent() async {
  //   List<Bank> Bank = [];
  //   List<Bank> merchant = [];
  //   offlineBusinessBank.forEach((element) {
  //     if (element.businessTransactionType == "INCOME") {
  //       Bank.add(element);
  //     } else {
  //       merchant.add(element);
  //     }
  //   });
  //   _BankBank(Bank);
  //   _BankMerchant(merchant);
  // }

  Future updatePendingJob() async {
    if (pendingUpdatedBankList.isEmpty) {
      return;
    }
    var updatednext = pendingUpdatedBankList.first;
    await _businessController.sqliteDb.updateOfflineBank(updatednext);
    pendingUpdatedBankList.remove(updatednext);
    if (pendingUpdatedBankList.isNotEmpty) {
      updatePendingJob();
    }
    getOfflineBank(updatednext.businessId!);
  }

  Future savePendingJob() async {
    if (pendingBusinessBank.isEmpty) {
      return;
    }
    var savenext = pendingBusinessBank.first;
    await _businessController.sqliteDb.insertBankAccount(savenext);
    pendingBusinessBank.remove(savenext);
    if (pendingBusinessBank.isNotEmpty) {
      savePendingJob();
    }
    getOfflineBank(savenext.businessId!);
  }

  bool checkifBankAvailable(String id) {
    bool result = false;
    offlineBusinessBank.forEach((element) {
      // print("checking transaction whether exist");
      if (element.id == id) {
        // print("Bank   found");
        result = true;
      }
    });
    return result;
  }

  Bank? checkifBankAvailableWithValue(String id) {
    Bank? item;

    _offlineBusinessBank.value.forEach((element) {
      // print("bank id ${element.id} compare to $id");
      if (element.id == id) {
        // print("Bank   found");
        item = element;
      }
    });
    return item;
  }

  Future deleteBankOnline(Bank bank) async {
    var response = await http.delete(
        Uri.parse(
            ApiLink.addBankInfo + "/${bank.id}?businessId=${bank.businessId}"),
        headers: {"Authorization": "Bearer ${_userController.token}"});
    // print("delete response ${response.body}");
    if (response.statusCode == 200) {
      _businessController.sqliteDb.deleteBank(bank);
      getOfflineBank(_businessController.selectedBusiness.value!.businessId!);
    } else {
      Get.snackbar("Error", "Error deleting bank, try again!");
    }
  }

  Future deleteBankOffline(Bank bank) async {
    bank.deleted = true;

    if (!bank.isAddingPending!) {
      _businessController.sqliteDb.updateOfflineBank(bank);
    } else {
      _businessController.sqliteDb.deleteBank(bank);
    }

    getOfflineBank(_businessController.selectedBusiness.value!.businessId!);
  }

  bool checkifSelectedForDelted(String id) {
    bool result = false;
    deleteBankList.forEach((element) {
      // print("checking transaction whether exist");
      if (element.id == id) {
        // print("Bank   found");
        result = true;
      }
    });
    return result;
  }

  Future checkPendingBankToBeAddedToSever() async {
    // print("checking Bank that is pending to be added");

    var list = await _businessController.sqliteDb.getOfflineBankInfos(
        _businessController.selectedBusiness.value!.businessId!);
    // print("offline Bank lenght ${list.length}");
    list.forEach((element) {
      if (element.isAddingPending!) {
        pendingJobToBeAdded.add(element);
        // print("item is found to be added");
      }
    });
    // print("number of Bank to be added to server ${pendingJobToBeAdded.length}");
    addPendingJobBankToServer();
  }

  Future checkPendingBankTobeUpdatedToServer() async {
    var list = await _businessController.sqliteDb.getOfflineBankInfos(
        _businessController.selectedBusiness.value!.businessId!);
    list.forEach((element) {
      if (element.isUpdatingPending! && !element.isAddingPending!) {
        pendingJobToBeUpdated.add(element);
      }
    });

    updatePendingJob();
  }

  Future checkPendingBankToBeDeletedOnServer() async {
    // print("checking Bank to be deleted");
    var list = await _businessController.sqliteDb.getOfflineBankInfos(
        _businessController.selectedBusiness.value!.businessId!);
    // print("checking Bank to be deleted list ${list.length}");
    list.forEach((element) {
      if (element.deleted!) {
        pendingJobToBeDelete.add(element);
        // print("Bank to be deleted is found ");
      }
    });
    // print("Bank to be deleted ${pendingJobToBeDelete.length}");
    deletePendingJobToServer();
  }

// Future<String?> addBusinessBankOfflineWithString({bool isinvoice=false})async
//   {
// var bank= Bank(
//    bankName: bankNameController.text,
//   bankAccountName: bankAccountNameController.text,
//   bankAccountNumber: accoutNumberController.text,
//   businessId:  _businessController.selectedBusiness.value!.businessId,

//   id: uuid.v1(),

// isCreatedFromInvoice: isinvoice

// );

//    await _businessController.sqliteDb.insertBankAccount(bank);
//    getOfflineBank(_businessController.selectedBusiness.value!.businessId!);
//       clearValue();
//    return bank.id!;

//   }

  Future addPendingJobBankToServer() async {
    if (pendingJobToBeAdded.isEmpty) {
      return;
    }
    var savenext = pendingJobToBeAdded.first;

    var response = await http.post(Uri.parse(ApiLink.addBankInfo),
        body: jsonEncode({
          "businessId": savenext.businessId,
          "bankName": savenext.bankName,
          "bankAccountNumber": savenext.bankAccountNumber,
          "bankAccountName": savenext.bankAccountName
        }),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${_userController.token}"
        });

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      if (json['success']) {
        getOnlineBank(_businessController.selectedBusiness.value!.businessId!);

        _businessController.sqliteDb.deleteBank(savenext);
        // print("pending to be added is delete");
        return json['data']['id'];
      }
    }
    pendingJobToBeAdded.remove(savenext);
    if (pendingJobToBeAdded.isNotEmpty) {
      addPendingJobBankToServer();
    }
  }

  Future addPendingJobToBeUpdateToServer() async {
    if (pendingJobToBeUpdated.isEmpty) {
      return;
    }

    pendingJobToBeUpdated.forEach((element) async {
      var updatenext = element;

      var response =
          await http.put(Uri.parse(ApiLink.addBankInfo + "/" + updatenext.id!),
              body: jsonEncode({
                "businessId":
                    _businessController.selectedBusiness.value!.businessId,
                "bankName": updatenext.bankName,
                "bankAccountNumber": updatenext.bankAccountNumber,
                "bankAccountName": updatenext.bankAccountName
              }),
              headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${_userController.token}"
          });

      // print("update Bank response ${response.body}");
      if (response.statusCode == 200) {
        _addingBankStatus(AddingBankInfoStatus.Success);
        getOnlineBank(_businessController.selectedBusiness.value!.businessId!);
      }

      if (pendingJobToBeUpdated.isNotEmpty) addPendingJobToBeUpdateToServer();
    });
  }

  Future deletePendingJobToServer() async {
    if (pendingJobToBeDelete.isEmpty) {
      return;
    }

    pendingJobToBeDelete.forEach((element) async {
      var deletenext = pendingJobToBeDelete.first;
      var response = await http.delete(
          Uri.parse(ApiLink.addBankInfo +
              "/${deletenext.id}?businessId=${deletenext.businessId}"),
          headers: {"Authorization": "Bearer ${_userController.token}"});
      // print("previous deleted response ${response.body}");
      if (response.statusCode == 200) {
        _businessController.sqliteDb.deleteBank(deletenext);
        getOfflineBank(_businessController.selectedBusiness.value!.businessId!);
      } else {}

      pendingJobToBeDelete.remove(deletenext);
      if (pendingJobToBeDelete.isNotEmpty) {
        deletePendingJobToServer();
      }
    });
  }

  Future deleteSelectedItem() async {
    if (deleteBankList.isEmpty) {
      return;
    }
    var deletenext = deleteBankList.first;
    await deleteBusinessBank(deletenext);
    var list = deleteBankList;
    list.remove(deletenext);
    _deleteBankList(list);

    if (deleteBankList.isNotEmpty) {
      deleteSelectedItem();
    }
    getOfflineBank(deletenext.businessId!);
  }

  void addToDeleteList(Bank Bank) {
    var list = deleteBankList;
    list.add(Bank);
    _deleteBankList(list);
  }

  void removeFromDeleteList(Bank Bank) {
    var list = deleteBankList;
    list.remove(Bank);
    _deleteBankList(list);
  }

  void clearValue() {
    BankImage(null);
    bankNameController.text = "";
    bankAccountNameController.text = "";
    accoutNumberController.text = "";
  }

  void setItem(Bank bank) {
    bankNameController.text = bank.bankName!;
    bankAccountNameController.text = bank.bankAccountName ?? "";
    accoutNumberController.text = bank.bankAccountNumber ?? "";
  }
}
