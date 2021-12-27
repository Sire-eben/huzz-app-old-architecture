import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:huzz/model/debtor.dart';
import 'package:huzz/sqlite/sqlite_db.dart';
import 'package:uuid/uuid.dart';

import '../api_link.dart';
import 'auth_respository.dart';
import 'business_respository.dart';
import 'file_upload_respository.dart';

enum AddingDebtorsStatus { Loading, Error, Success, Empty }

class DebtorsRepository extends GetxController
    with GetSingleTickerProviderStateMixin {
  final _userController = Get.find<AuthRepository>();
  final _businessController = Get.find<BusinessRespository>();
  final _uploadFileController = Get.find<FileUploadRespository>();

  final _addingDebtorsStatus = AddingDebtorsStatus.Empty.obs;
  AddingDebtorsStatus get addingDebtorsStatus => _addingDebtorsStatus.value;

  Rx<List<DebtorsModel>> _onlineBusinessDebtor = Rx([]);
  Rx<List<DebtorsModel>> _offlineBusinessDebtor = Rx([]);

  List<DebtorsModel> get offlineBusinessDebtor => _offlineBusinessDebtor.value;
  List<DebtorsModel> get onlineBusinessDebtor => _onlineBusinessDebtor.value;

  SqliteDb sqliteDb = SqliteDb();
  TabController? tabController;

  List<DebtorsModel> pendingBusinessDebtor = [];

  Rx<List<DebtorsModel>> _debtorService = Rx([]);
  Rx<List<DebtorsModel>> _debtorGoods = Rx([]);

  List<DebtorsModel> get debtorService => _debtorService.value;
  List<DebtorsModel> get debtorGoods => _debtorGoods.value;

  List<DebtorsModel> pendingUpdatedDebtorList = [];
  List<DebtorsModel> pendingToUpdatedDebtorToServer = [];
  List<DebtorsModel> pendingToBeAddedDebtorToServer = [];
  List<DebtorsModel> pendingDeletedDebtorToServer = [];
  var uuid = Uuid();

  final debtorNameController = TextEditingController();
  final productCostPriceController = TextEditingController();
  final productSellingPriceController = TextEditingController();
  final debtorQuantityController = TextEditingController();
  final productUnitController = TextEditingController();
  final serviceDescription = TextEditingController();

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
          getOnlineDebtors(value.businessId!);
          getOfflineDebtors(value.businessId!);
        }
        _businessController.selectedBusiness.listen((p0) {
          if (p0 != null) {
            print("business id ${p0.businessId}");
            _offlineBusinessDebtor([]);

            _onlineBusinessDebtor([]);
            _debtorService([]);
            _debtorGoods([]);
            getOnlineDebtors(p0.businessId!);
            getOfflineDebtors(p0.businessId!);
          }
        });
      }
    });
    _userController.MonlineStatus.listen((po) {
      if (po == OnlineStatus.Onilne) {
        _businessController.selectedBusiness.listen((p0) {
          // checkPendingCustomerTobeUpdatedToServer();
          // checkPendingDebtorsToBeAddedToSever();
          // checkPendingCustomerToBeDeletedOnServer();
          //update server with pending job
        });
      }
    });
  }

  Future getBusinessDebtorYetToBeSavedLocally() async {
    onlineBusinessDebtor.forEach((element) {
      if (!checkifDebtorAvailable(element.debtorId!)) {
        print("doesnt contain value");

        pendingBusinessDebtor.add(element);
      }
    });

    savePendingJob();
  }

  Future getOnlineDebtors(String businessId) async {
    print("trying to get debtor online");
    final response = await http.get(
        Uri.parse(ApiLink.add_debtor + "?businessId=" + businessId),
        headers: {"Authorization": "Bearer ${_userController.token}"});

    print("result of get debtor online ${response.body}");
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      if (json['success']) {
        var result = List.from(json['data']['content'])
            .map((e) => DebtorsModel.fromJson(e))
            .toList();
        _onlineBusinessDebtor(result);
        print("debtor business lenght ${result.length}");
        await getBusinessDebtorYetToBeSavedLocally();
        checkIfUpdateAvailable();
      }
    } else {}
  }

  Future getOfflineDebtors(String businessId) async {
    var result =
        await _businessController.sqliteDb.getOfflineDebtors(businessId);
    _offlineBusinessDebtor(result);
    print("offline debtor found ${result.length}");
    setDebtorDifferent();
  }

  Future setDebtorDifferent() async {
    List<DebtorsModel> goods = [];
    List<DebtorsModel> services = [];
    offlineBusinessDebtor.forEach((element) {
      if (element.businessTransactionType == "EXPENDITURE") {
        services.add(element);
      } else {
        goods.add(element);
      }
    });
    _debtorGoods(goods);
    _debtorService(services);
  }

  Future checkIfUpdateAvailable() async {
    onlineBusinessDebtor.forEach((element) async {
      var item = checkifDebtorAvailableWithValue(element.debtorId!);
      if (item != null) {
        print("item debtor is found");
        print("updated offline ${item.updatedTime!.toIso8601String()}");
        print("updated online ${element.updatedTime!.toIso8601String()}");
        if (!element.updatedTime!.isAtSameMomentAs(item.updatedTime!)) {
          print("found debtor to updated");
          pendingUpdatedDebtorList.add(element);
        }
      }
    });

    updatePendingJob();
  }

  DebtorsModel? checkifDebtorAvailableWithValue(String id) {
    DebtorsModel? item;

    offlineBusinessDebtor.forEach((element) {
      print("checking transaction whether exist");
      if (element.debtorId == id) {
        print("debtor   found");
        item = element;
      }
    });
    return item;
  }

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
    getOfflineDebtors(updatednext.businessId!);
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
    getOfflineDebtors(savenext.businessId!);
  }

  bool checkifDebtorAvailable(String id) {
    bool result = false;
    offlineBusinessDebtor.forEach((element) {
      print("checking transaction whether exist");
      if (element.debtorId == id) {
        print("debtor   found");
        result = true;
      }
    });
    return result;
  }
}
