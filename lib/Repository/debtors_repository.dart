import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:huzz/Repository/business_respository.dart';
import 'package:huzz/api_link.dart';
import 'package:huzz/app/screens/inventory/Debtor/DebtorConfirm.dart';
import 'package:huzz/model/Debtor.dart';
import 'package:huzz/model/debtor.dart';
import 'package:huzz/sqlite/sqlite_db.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'auth_respository.dart';
import 'file_upload_respository.dart';
import 'package:path/path.dart' as path;

enum AddingDebtorStatus { Loading, Error, Success, Empty }

class DebtorRepository extends GetxController
    with GetSingleTickerProviderStateMixin {
  final _userController = Get.find<AuthRepository>();
  Rx<List<Debtor>> _onlineBusinessDebtor = Rx([]);
  Rx<List<Debtor>> _offlineBusinessDebtor = Rx([]);
  List<Debtor> get offlineBusinessDebtor => _offlineBusinessDebtor.value;
  List<Debtor> get onlineBusinessDebtor => _onlineBusinessDebtor.value;
  List<Debtor> pendingBusinessDebtor = [];
  final _uploadImageController = Get.find<FileUploadRespository>();
  Rx<List<Debtor>> _DebtorService = Rx([]);
  Rx<List<Debtor>> _DebtorGoods = Rx([]);
  final isDebtorService = false.obs;
  List<Debtor> get DebtorServices => _DebtorService.value;
  List<Debtor> get DebtorGoods => _DebtorGoods.value;
  Rx<File?> DebtorImage = Rx(null);
  SqliteDb sqliteDb = SqliteDb();
  final DebtorNameController = TextEditingController();
  final DebtorCostPriceController = TextEditingController();
  final DebtorSellingPriceController = TextEditingController();
  final DebtorQuantityController = TextEditingController();
  final DebtorUnitController = TextEditingController();
  final serviceDescription = TextEditingController();
  final _businessController = Get.find<BusinessRespository>();
  final _addingDebtorStatus = AddingDebtorStatus.Empty.obs;
  final _uploadFileController = Get.find<FileUploadRespository>();
  AddingDebtorStatus get addingDebtorStatus => _addingDebtorStatus.value;
  TabController? tabController;
  Rx<List<Debtor>> _deleteDebtorList = Rx([]);
  List<Debtor> get deleteDebtorList => _deleteDebtorList.value;
  List<Debtor> pendingUpdatedDebtorList = [];
  List<Debtor> pendingToUpdatedDebtorToServer = [];
  List<Debtor> pendingToBeAddedDebtorToServer = [];
  List<Debtor> pendingDeletedDebtorToServer = [];
  var uuid = Uuid();
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    tabController = TabController(length: 2, vsync: this);

    //  await sqliteDb.openDatabae();
    _userController.Mtoken.listen((p0) {
      if (p0.isNotEmpty || p0 != "0") {
        final value = _businessController.selectedBusiness.value;
        if (value != null) {
          getOnlineDebtor(value.businessId!);
          getOfflineDebtor(value.businessId!);
        }
        _businessController.selectedBusiness.listen((p0) {
          if (p0 != null) {
            print("business id ${p0.businessId}");
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
    _userController.MonlineStatus.listen((po) {
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

  Future addDebtorOnline(String type, String title) async {
    try {
      _addingDebtorStatus(AddingDebtorStatus.Loading);
      String? fileId = null;
      if (DebtorImage.value != null) {
        fileId =
            await _uploadFileController.uploadFile(DebtorImage.value!.path);
      }
      var response = await http.post(Uri.parse(ApiLink.add_debtor),
          body: jsonEncode({
            "name": DebtorNameController.text,
            "costPrice": DebtorCostPriceController.text,
            "sellingPrice": DebtorSellingPriceController.text,
            "quantity": DebtorQuantityController.text,
            "businessId":
                _businessController.selectedBusiness.value!.businessId!,
            "DebtorType": type,
            "DebtorLogoFileStoreId": fileId
          }),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${_userController.token}"
          });

      print("add Debtor response ${response.body}");
      if (response.statusCode == 200) {
        _addingDebtorStatus(AddingDebtorStatus.Success);
        getOnlineDebtor(
            _businessController.selectedBusiness.value!.businessId!);
        clearValue();
        Get.to(Confirmation(
          text: "Added",
          title: title,
        ));
      } else {
        _addingDebtorStatus(AddingDebtorStatus.Error);
        Get.snackbar("Error", "Unable to add Debtor");
      }
    } catch (ex) {
      Get.snackbar("Error", "Unknown error occurred.. try again");
      _addingDebtorStatus(AddingDebtorStatus.Error);
    }
  }

  Future addBudinessDebtor(String type, String title) async {
    if (_userController.onlineStatus == OnlineStatus.Onilne) {
      addDebtorOnline(type, title);
    } else {
      addBusinessDebtorOffline(type, title);
    }
  }

  Future UpdateBusinessDebtor(Debtor Debtor, String title) async {
    if (_userController.onlineStatus == OnlineStatus.Onilne) {
      updateBusinessDebtorOnline(Debtor, title);
    } else {
      updateBusinessDebtorOffline(Debtor, title);
    }
  }

  Future addBusinessDebtorOffline(String type, String title) async {
    File? outFile;
    if (DebtorImage.value != null) {
      var list = await getApplicationDocumentsDirectory();

      Directory appDocDir = list;
      String appDocPath = appDocDir.path;

      String basename = path.basename(DebtorImage.value!.path);
      var newPath = appDocPath + basename;
      print("new file path is ${newPath}");
      outFile = File(newPath);
      DebtorImage.value!.copySync(outFile.path);
    }

    Debtor debtor = Debtor(
    );

    print("Debtor offline saving ${debtor.toJson()}");
    _businessController.sqliteDb.insertDebtor(Debtor);
    clearValue();
    getOfflineDebtor(_businessController.selectedBusiness.value!.businessId!);
    Get.to(Confirmation(
      text: "Added",
      title: title,
    ));
  }

  Future updateBusinessDebtorOffline(Debtor newDebtor, String title) async {
    File? outFile;
    if (DebtorImage != null) {
      var list = await getApplicationDocumentsDirectory();

      Directory appDocDir = list;
      String appDocPath = appDocDir.path;

      String basename = path.basename(DebtorImage.value!.path!);
      var newPath = appDocPath + basename;
      print("new file path is ${newPath}");
      outFile = File(newPath);
      DebtorImage.value!.copySync(outFile.path);
    }
    Debtor debtor = Debtor(
        isUpdatingPending: true,
        DebtorName: DebtorNameController.text,
        sellingPrice: int.parse(DebtorSellingPriceController.text),
        costPrice: int.parse(DebtorCostPriceController.text),
        quantity: int.parse(DebtorQuantityController.text),
        DebtorLogoFileStoreId:
            outFile == null ? newDebtor.DebtorLogoFileStoreId : outFile.path);

    print("Debtor offline saving ${Debtor.toJson()}");
    _businessController.sqliteDb.updateOfflineProdcut(Debtor);
    clearValue();
    Get.to(Confirmation(
      text: "Updated",
      title: title,
    ));
  }

  void clearValue() {
    DebtorImage(null);
    DebtorNameController.text = "";
    DebtorQuantityController.text = "";
    DebtorCostPriceController.text = "";
    DebtorSellingPriceController.text = "";
    DebtorUnitController.text = "";
    serviceDescription.text = "";
  }

  Future updateBusinessDebtorOnline(Debtor Debtor, String title) async {
    try {
      _addingDebtorStatus(AddingDebtorStatus.Loading);
      String? fileId = null;

      if (DebtorImage.value != null) {
        fileId =
            await _uploadFileController.uploadFile(DebtorImage.value!.path);
      }
      var response = await http
          .put(Uri.parse(ApiLink.add_debtor + "/" + Debtor.debtorId!),
              body: jsonEncode({
                "name": DebtorNameController.text,
                "costPrice": DebtorCostPriceController.text,
                "sellingPrice": DebtorSellingPriceController.text,
// "quantity":DebtorQuantityController.text,
                "businessId": Debtor.businessId,
                "DebtorType": tabController!.index == 0 ? "GOODS" : "SERVICES",
                "DebtorLogoFileStoreId": fileId
              }),
              headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${_userController.token}"
          });

      print("update Debtor response ${response.body}");
      if (response.statusCode == 200) {
        _addingDebtorStatus(AddingDebtorStatus.Success);
        getOnlineDebtor(
            _businessController.selectedBusiness.value!.businessId!);

        Get.to(Confirmation(
          text: "Updated",
          title: title,
        ));
        clearValue();
      } else {
        _addingDebtorStatus(AddingDebtorStatus.Error);
        Get.snackbar("Error", "Unable to update Debtor");
      }
    } catch (ex) {
      _addingDebtorStatus(AddingDebtorStatus.Error);
    }
  }

  void setItem(Debtor Debtor) {
    DebtorNameController.text = Debtor.DebtorName!;
    DebtorQuantityController.text = Debtor.quantity!.toString();
    DebtorCostPriceController.text = Debtor.costPrice.toString();
    DebtorSellingPriceController.text = Debtor.sellingPrice.toString();
    DebtorUnitController.text = "";
    serviceDescription.text = "";
  }

  Future getOfflineDebtor(String businessId) async {
    var result =
        await _businessController.sqliteDb.getOfflineDebtors(businessId);
    _offlineBusinessDebtor(result);
    print("offline Debtor found ${result.length}");
    setDebtorDifferent();
  }

  Future getOnlineDebtor(String businessId) async {
    print("trying to get Debtor online");
    final response = await http.get(
        Uri.parse(ApiLink.get_business_Debtor + "?businessId=" + businessId),
        headers: {"Authorization": "Bearer ${_userController.token}"});

    print("result of get Debtor online ${response.body}");
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      if (json['success']) {
        var result = List.from(json['data']['content'])
            .map((e) => Debtor.fromJson(e))
            .toList();
        _onlineBusinessDebtor(result);
        print("Debtor business lenght ${result.length}");
        await getBusinessDebtorYetToBeSavedLocally();
        checkIfUpdateAvailable();
      }
    } else {}
  }

  Future getBusinessDebtorYetToBeSavedLocally() async {
    onlineBusinessDebtor.forEach((element) {
      if (!checkifDebtorAvailable(element.DebtorId!)) {
        print("doesnt contain value");

        pendingBusinessDebtor.add(element);
      }
    });

    savePendingJob();
  }

  Future checkIfUpdateAvailable() async {
    onlineBusinessDebtor.forEach((element) async {
      var item = checkifDebtorAvailableWithValue(element.DebtorId!);
      if (item != null) {
        print("item Debtor is found");
        print("updated offline ${item.updatedTime!.toIso8601String()}");
        print("updated online ${element.updatedTime!.toIso8601String()}");
        if (!element.updatedTime!.isAtSameMomentAs(item.updatedTime!)) {
          print("found Debtor to updated");
          pendingUpdatedDebtorList.add(element);
        }
      }
    });

    updatePendingJob();
  }

  Future setDebtorDifferent() async {
    List<Debtor> goods = [];
    List<Debtor> services = [];
    offlineBusinessDebtor.forEach((element) {
      if (element.DebtorType == "SERVICES") {
        services.add(element);
      } else {
        goods.add(element);
      }
    });
    _DebtorGoods(goods);
    _DebtorService(services);
  }

  Future updatePendingJob() async {
    if (pendingUpdatedDebtorList.isEmpty) {
      return;
    }

    var updatednext = pendingUpdatedDebtorList.first;
    await _businessController.sqliteDb.updateOfflineProdcut(updatednext);
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
      print("checking transaction whether exist");
      if (element.DebtorId == id) {
        print("Debtor   found");
        result = true;
      }
    });
    return result;
  }

  Debtor? checkifDebtorAvailableWithValue(String id) {
    Debtor? item;

    offlineBusinessDebtor.forEach((element) {
      print("checking transaction whether exist");
      if (element.DebtorId == id) {
        print("Debtor   found");
        item = element;
      }
    });
    return item;
  }

  Future deleteDebtorOnline(Debtor Debtor) async {
    var response = await http.delete(
        Uri.parse(ApiLink.add_Debtor +
            "/${Debtor.DebtorId}?businessId=${Debtor.businessId}"),
        headers: {"Authorization": "Bearer ${_userController.token}"});
    print("delete response ${response.body}");
    if (response.statusCode == 200) {
    } else {}
    _businessController.sqliteDb.deleteDebtor(Debtor);
  }

  Future deleteBusinessDebtor(Debtor Debtor) async {
    if (_userController.onlineStatus == OnlineStatus.Onilne) {
      deleteDebtorOnline(Debtor);
    } else {
      deleteBusinessDebtorOffline(Debtor);
    }
  }

  Future deleteBusinessDebtorOffline(Debtor Debtor) async {
    Debtor.deleted = true;

    if (!Debtor.isAddingPending!) {
      _businessController.sqliteDb.updateOfflineProdcut(Debtor);
    } else {
      _businessController.sqliteDb.deleteDebtor(Debtor);
    }
    getOfflineDebtor(_businessController.selectedBusiness.value!.businessId!);
  }

  bool checkifSelectedForDelted(String id) {
    bool result = false;
    deleteDebtorList.forEach((element) {
      print("checking transaction whether exist");
      if (element.DebtorId == id) {
        print("Debtor   found");
        result = true;
      }
    });
    return result;
  }

  Future deleteSelectedItem() async {
    if (deleteDebtorList.isEmpty) {
      return;
    }
    var deletenext = deleteDebtorList.first;
    await deleteBusinessDebtor(deletenext);
    var list = deleteDebtorList;
    list.remove(deletenext);
    _deleteDebtorList(list);

    if (deleteDebtorList.isNotEmpty) {
      deleteSelectedItem();
    }
    getOfflineDebtor(deletenext.businessId!);
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
    var list = await _businessController.sqliteDb.getOfflineDebtors(
        _businessController.selectedBusiness.value!.businessId!);
    offlineBusinessDebtor.forEach((element) {
      if (element.isAddingPending!) {
        pendingToBeAddedDebtorToServer.add(element);
      }

      print(
          "Debtor available for uploading to server ${pendingToBeAddedDebtorToServer.length}");
    });
    addPendingJobDebtorToServer();
  }

  Future checkPendingCustomerTobeUpdatedToServer() async {
    offlineBusinessDebtor.forEach((element) {
      if (element.isUpdatingPending! && !element.isAddingPending!) {
        pendingToUpdatedDebtorToServer.add(element);
      }
    });

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

      if (savenext.DebtorLogoFileStoreId != null &&
          savenext.DebtorLogoFileStoreId != '') {
        String image = await _uploadImageController
            .uploadFile(savenext.DebtorLogoFileStoreId!);

        File _file = File(savenext.DebtorLogoFileStoreId!);
        savenext.DebtorLogoFileStoreId = image;
        _file.deleteSync();
      }

      var response = await http.post(Uri.parse(ApiLink.add_Debtor),
          body: jsonEncode(savenext.toJson()),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${_userController.token}"
          });
      print("pendong uploading response ${response.body}");
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        if (json['success']) {
          getOnlineDebtor(
              _businessController.selectedBusiness.value!.businessId!);

          _businessController.sqliteDb.deleteDebtor(savenext);

          pendingToBeAddedDebtorToServer.remove(savenext);
        }
      }

      if (pendingToBeAddedDebtorToServer.isNotEmpty) {
        print(
            "pendon Debtor remained ${pendingToBeAddedDebtorToServer.length}");
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
          Uri.parse(ApiLink.add_Debtor + "/" + updatenext.DebtorId!),
          body: jsonEncode(updatenext.toJson()),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${_userController.token}"
          });

      print("update Customer response ${response.body}");
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
      var deletenext = element;
      var response = await http.delete(
          Uri.parse(ApiLink.add_Debtor +
              "/${deletenext.DebtorId}?businessId=${deletenext.businessId}"),
          headers: {"Authorization": "Bearer ${_userController.token}"});
      print("delete response ${response.body}");
      if (response.statusCode == 200) {
        _businessController.sqliteDb.deleteDebtor(deletenext);
        getOfflineDebtor(
            _businessController.selectedBusiness.value!.businessId!);
      } else {}

      pendingDeletedDebtorToServer.remove(deletenext);
      if (pendingDeletedDebtorToServer.isNotEmpty) {
        deletePendingJobToServer();
      }
    });
  }
}
