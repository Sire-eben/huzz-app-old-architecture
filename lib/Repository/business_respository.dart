// ignore_for_file: must_call_super, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:country_currency_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:huzz/Repository/file_upload_respository.dart';
import 'package:huzz/Repository/miscellaneous_respository.dart';
import 'package:huzz/api_link.dart';
import 'package:huzz/model/business.dart';
import 'package:huzz/model/offline_business.dart';
import 'package:huzz/sharepreference/sharepref.dart';
import 'package:huzz/sqlite/sqlite_db.dart';
import '../app/screens/create_business.dart';
import 'auth_respository.dart';

enum CreateBusinessStatus { Loading, Empty, Error, Success }
enum UpdateBusinessStatus { Loading, Empty, Error, Success }

class BusinessRespository extends GetxController {
  Rx<List<OfflineBusiness>> _offlineBusiness = Rx([]);
  List<OfflineBusiness> get offlineBusiness => _offlineBusiness.value;
  List<OfflineBusiness> pendingJob = [];
  List<Business> businessListFromServer = [];
  List<String> businessCategory = ["PERSONAL", "FINANCE", "TRADE"];
  List<OfflineBusiness> pendingUpdatedBusinessList = [];
  final selectedCategory = "".obs;
  final businessName = TextEditingController();
  final businessEmail = TextEditingController();
  final businessPhoneNumber = TextEditingController();
  final businessAddressController = TextEditingController();
  final businessCurrency = TextEditingController();
  final _userController = Get.find<AuthRepository>();

  final _updateBusinessStatus = UpdateBusinessStatus.Empty.obs;
  final _createBusinessStatus = CreateBusinessStatus.Empty.obs;
  Rx<Business?> selectedBusiness = Rx(null);
  SqliteDb sqliteDb = SqliteDb();
  SharePref? pref;
  Rx<File?> businessImage = Rx(null);
  final _miscellaneousController = Get.find<MiscellaneousRepository>();
  CreateBusinessStatus get createBusinessStatus => _createBusinessStatus.value;
  UpdateBusinessStatus get updateBusinessStatus => _updateBusinessStatus.value;

  @override
  void onInit() async {
    pref = SharePref();
    await pref!.init();

    _userController.Mtoken.listen((p0) {
      print("available token is $p0");
      if (p0.isNotEmpty || p0 != "0") {
        print("trying to get online business since is the token is valid");
        OnlineBusiness();
      }
    });
    OnlineBusiness();
    sqliteDb.openDatabae().then((value) {
      GetOfflineBusiness();
    });

    _miscellaneousController.businessCategoryList.listen((p0) {
      if (p0.isNotEmpty) {
        businessCategory = p0;
      }
    });
  }

  void setLastBusiness(Business business) {
    pref!.setLastSelectedBusiness(business.businessId!);
  }

  Future OnlineBusiness() async {
    businessListFromServer.clear();
    offlineBusiness.clear();
    print("get online business is token ${_userController.token} ");
    var response = await http.get(Uri.parse(ApiLink.get_user_business),
        headers: {"Authorization": "Bearer ${_userController.token}"});

    print("online busines result ${response.body}");
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      if (json['success']) {
        var result = List.from(json['data']).map((e) => Business.fromJson(e));
        businessListFromServer.addAll(result);
        print("online data business lenght ${result.length}");
        getBusinessYetToBeSavedLocally();
        checkIfUpdateAvailable();
      }
    } else {}
  }

  bool checkifBusinessAvailable(String id) {
    bool result = false;
    offlineBusiness.forEach((element) {
      if (element.businessId == id) {
        print("business  found");
        result = true;
      }
    });
    return result;
  }

  Business? checkifBusinessAvailableWithValue(String id) {
    Business? item;

    offlineBusiness.forEach((element) {
      print("checking transaction whether exist");
      if (element.businessId == id) {
        print("Customer   found");
        item = element.business;
      }
    });
    return item;
  }

  Future checkIfUpdateAvailable() async {
    businessListFromServer.forEach((element) async {
      var item = checkifBusinessAvailableWithValue(element.businessId!);
      if (item != null) {
        print("item Customer is found");
        print("updated offline ${item.updatedTime!.toIso8601String()}");
        print("updated online ${element.updatedTime!.toIso8601String()}");
        if (!element.updatedTime!.isAtSameMomentAs(item.updatedTime!)) {
          print("found Customer to updated");
          pendingUpdatedBusinessList.add(OfflineBusiness(
              business: element, businessId: element.businessId));
        }
      }
    });

    updatePendingJob();
  }

  Future updatePendingJob() async {
    if (pendingUpdatedBusinessList.isEmpty) {
      return;
    }
    var updatednext = pendingUpdatedBusinessList.first;
    await sqliteDb.updateOfflineBusiness(updatednext);
    pendingUpdatedBusinessList.remove(updatednext);
    if (pendingUpdatedBusinessList.isNotEmpty) {
      updatePendingJob();
    }
    GetOfflineBusiness();
  }

  Future setBusinessList(List<Business> list) async {
    businessListFromServer.addAll(list);
    print("online data business lenght ${list.length}");
    getBusinessYetToBeSavedLocally();
  }

  Future getBusinessYetToBeSavedLocally() async {
// if(offlineBusiness.length==businessListFromServer.length)
// return;

    businessListFromServer.forEach((element) {
      if (!checkifBusinessAvailable(element.businessId!)) {
        print("doesnt contain value");
        var re =
            OfflineBusiness(businessId: element.businessId, business: element);
        pendingJob.add(re);
      }
    });

    savePendingJob();
  }

  Future savePendingJob() async {
    if (pendingJob.isEmpty) {
      return;
    }
    var savenext = pendingJob.first;
    await sqliteDb.insertBusiness(savenext);
    pendingJob.remove(savenext);
    if (pendingJob.isNotEmpty) {
      savePendingJob();
    }
    GetOfflineBusiness();
  }

  Future GetOfflineBusiness() async {
    var results = await sqliteDb.getOfflineBusinesses();
    print("offline business ${results.length}");

    print("selected business is ${selectedBusiness.value}");
    _offlineBusiness(results);
    if (selectedBusiness.value == null ||
        selectedBusiness.value!.businessId == null) if (results.isNotEmpty) {
      var business = results.firstWhereOrNull(
          (e) => e.businessId == pref!.getLastSelectedBusiness());
      if (business == null)
        selectedBusiness(results.first.business);
      else
        selectedBusiness(business.business);
    }
  }

  Future createBusiness() async {
    print("token ${_userController.token}");
    try {
      _createBusinessStatus(CreateBusinessStatus.Loading);
      final currency = CountryPickerUtils.getCountryByIsoCode(
              _userController.countryCodeFLag)
          .currencyCode
          .toString();
      final response = await http.post(Uri.parse(ApiLink.create_business),
          body: jsonEncode(
            {
              "name": businessName.text,
              "address": businessAddressController.text,
              "businessCategory": selectedCategory.value,
              "phoneNumber": businessPhoneNumber.text.trim(),
              "email": businessEmail.text.trim(),
              "currency": businessCurrency.text,
              "buisnessLogoFileStoreId": null,
              "yearFounded": "",
              "businessRegistered": false,
              "businessRegistrationType": null,
              "businessRegistrationNumber": null,
              "bankInfoId": null
            },
          ),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${_userController.token}"
          });

      print("create business response ${response.body}");
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        if (json['success']) {
          var business = Business.fromJson(json['data']);
          selectedBusiness(business);
          clear();
          OnlineBusiness();

          _createBusinessStatus(CreateBusinessStatus.Success);

          Get.offAll(() => BusinessCreatedSuccesful());
        } else {}
      } else {
        _createBusinessStatus(CreateBusinessStatus.Error);
      }
    } catch (ex) {
      _createBusinessStatus(CreateBusinessStatus.Error);
    }
  }

  void clear() {
    businessAddressController.clear();
    selectedCategory(null);
    businessEmail.clear();
    businessName.clear();
    businessImage(null);
    businessPhoneNumber.clear();
  }

  Future updateBusiness(String selectedCurrency) async {
    print("token ${_userController.token}");

    try {
      _updateBusinessStatus(UpdateBusinessStatus.Loading);
      String? imageId;
      var uploadController = Get.find<FileUploadRespository>();
      if (businessImage.value != null) {
        imageId = await uploadController.uploadFile(businessImage.value!.path);
      }
      final selectedCurrency = CountryPickerUtils.getCountryByIsoCode(
              _userController.countryCodeFLag)
          .currencyCode
          .toString();
      final itemsToUpdate = {
        "address": businessAddressController.text,
        "phoneNumber": businessPhoneNumber.text.trim(),
        "email": businessEmail.text.trim(),
        "buisnessLogoFileStoreId": imageId,
        "currency": selectedCurrency,
      };
      if (businessName.text != selectedBusiness.value!.businessName) {
        itemsToUpdate.putIfAbsent("name", () => businessName.text);
      }
      final response = await http.put(
          Uri.parse(ApiLink.update_business +
              "/${selectedBusiness.value!.businessId}"),
          body: jsonEncode(itemsToUpdate),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${_userController.token}"
          });

      print("Update business response ${response.body}");
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        if (json['success']) {
          OnlineBusiness();
          var business = Business.fromJson(json['data']);
          selectedBusiness(business);
          _updateBusinessStatus(UpdateBusinessStatus.Success);
          Get.snackbar(
            "Success",
            "Business Information Updated",
          );
          Timer(Duration(milliseconds: 2000), () {
            Get.back();
          });
        } else {
          _updateBusinessStatus(UpdateBusinessStatus.Empty);
          Get.snackbar(
            "Error",
            "Failed to update Business Information",
          );
        }
      } else {
        _updateBusinessStatus(UpdateBusinessStatus.Error);
      }
    } catch (ex) {
      _updateBusinessStatus(UpdateBusinessStatus.Error);
    }
  }
}
