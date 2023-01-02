// ignore_for_file: must_call_super, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:country_currency_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:huzz/data/repository/file_upload_repository.dart';
import 'package:huzz/data/repository/miscellaneous_respository.dart';
import 'package:huzz/data/api_link.dart';
import 'package:huzz/data/model/business.dart';
import 'package:huzz/data/model/offline_business.dart';
import 'package:huzz/data/sharepreference/sharepref.dart';
import 'package:huzz/data/sqlite/sqlite_db.dart';
import 'package:huzz/presentation/business/create_business.dart';
import 'auth_repository.dart';

enum CreateBusinessStatus { Loading, Empty, Error, Success }

enum BusinessStatus { Loading, Empty, Error, Available, UnAuthorized }

enum UpdateBusinessStatus { Loading, Empty, Error, Success }

class BusinessRepository extends GetxController {
  final Rx<List<OfflineBusiness>> _offlineBusiness = Rx([]);
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
  final onlineBusinessLength = 0.obs;
  final offlineBusinessLength = 0.obs;

  final _updateBusinessStatus = UpdateBusinessStatus.Empty.obs;
  final _createBusinessStatus = CreateBusinessStatus.Empty.obs;
  final _businessStatus = BusinessStatus.Empty.obs;
  Rx<Business?> selectedBusiness = Rx(null);
  SqliteDb sqliteDb = SqliteDb();
  SharePref? pref;
  Rx<File?> businessImage = Rx(null);
  final _miscellaneousController = Get.find<MiscellaneousRepository>();
  CreateBusinessStatus get createBusinessStatus => _createBusinessStatus.value;
  UpdateBusinessStatus get updateBusinessStatus => _updateBusinessStatus.value;
  BusinessStatus get businessStatus => _businessStatus.value;

  @override
  void onInit() async {
    pref = SharePref();
    await pref!.init();

    _userController.mToken.listen((p0) {
      // print("available token is $p0");
      if (p0.isNotEmpty || p0 != "0") {
      // print("trying to get online business since is the token is valid");
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
    _businessStatus(BusinessStatus.Loading);
    businessListFromServer.clear();
    offlineBusiness.clear();
    // print("get online business is token ${_userController.token} ");
    var response = await http.get(Uri.parse(ApiLink.getUserBusiness),
        headers: {"Authorization": "Bearer ${_userController.token}"});

    // print("online business result ${response.body}");
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      if (json['success']) {
        var result = List.from(json['data']).map((e) => Business.fromJson(e));
        businessListFromServer.addAll(result);
        // print("online data business length ${result.length}");
        onlineBusinessLength(result.length);
        result.isNotEmpty
            ? _businessStatus(BusinessStatus.Available)
            : _businessStatus(BusinessStatus.Empty);
        getBusinessYetToBeSavedLocally();
        checkIfUpdateAvailable();
      }
    } else if (response.statusCode == 500) {
      _businessStatus(BusinessStatus.UnAuthorized);
    } else {
      _businessStatus(BusinessStatus.Error);
    }
  }

  Future checkOnlineBusiness() async {
    try {
      var response = await http.get(Uri.parse(ApiLink.getUserBusiness),
          headers: {"Authorization": "Bearer ${_userController.token}"});

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        if (json['success']) {
          var result = List.from(json['data']).map((e) => Business.fromJson(e));
          // print("online data business length ${result.length}");
          onlineBusinessLength(result.length);
        }
      }
    } catch (error) {
      // print(error.toString());
    }
  }

  bool checkIfBusinessAvailable(String id) {
    bool result = false;
    for (var element in offlineBusiness) {
      if (element.businessId == id) {
        // print("business  found");
        result = true;
      }
    }
    return result;
  }

  Business? checkIfBusinessAvailableWithValue(String id) {
    Business? item;

    for (var element in offlineBusiness) {
      // print("checking transaction whether exist");
      if (element.businessId == id) {
        // print("Customer   found");
        item = element.business;
      }
    }
    return item;
  }

  Future checkIfUpdateAvailable() async {
    businessListFromServer.forEach((element) async {
      var item = checkIfBusinessAvailableWithValue(element.businessId!);
      if (item != null) {
        // print("item Customer is found");
        // print("updated offline ${item.updatedTime!.toIso8601String()}");
        // print("updated online ${element.updatedTime!.toIso8601String()}");
        if (!element.updatedTime!.isAtSameMomentAs(item.updatedTime!)) {
          // print("found Customer to updated");
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
    var updatedNext = pendingUpdatedBusinessList.first;
    await sqliteDb.updateOfflineBusiness(updatedNext);
    pendingUpdatedBusinessList.remove(updatedNext);
    if (pendingUpdatedBusinessList.isNotEmpty) {
      updatePendingJob();
    }
    GetOfflineBusiness();
  }

  Future setBusinessList(List<Business> list) async {
    businessListFromServer.addAll(list);
    // print("online data business length ${list.length}");
    getBusinessYetToBeSavedLocally();
  }

  Future getBusinessYetToBeSavedLocally() async {
// if(offlineBusiness.length==businessListFromServer.length)
// return;

    for (var element in businessListFromServer) {
      if (!checkIfBusinessAvailable(element.businessId!)) {
        // print("does not contain value");
        var re =
            OfflineBusiness(businessId: element.businessId, business: element);
        pendingJob.add(re);
      }
    }

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
    // print("offline business ${results.length}");
    offlineBusinessLength(results.length);
    // print("selected business is ${selectedBusiness.value}");
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
    // print("token ${_userController.token}");
    try {
      _createBusinessStatus(CreateBusinessStatus.Loading);
      final response = await http.post(Uri.parse(ApiLink.createBusiness),
          body: jsonEncode(
            {
              "name": businessName.text,
              "address": businessAddressController.text,
              "businessCategory": selectedCategory.value,
              "phoneNumber": businessPhoneNumber.text.trim(),
              "email": businessEmail.text.trim(),
              "currency": businessCurrency.text,
              "businessLogoFileStoreId": null,
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

      // print("create business response ${response.body}");
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        if (json['success']) {
          var business = Business.fromJson(json['data']);
          selectedBusiness(business);
          clear();
          OnlineBusiness();

          _createBusinessStatus(CreateBusinessStatus.Success);
          _userController.getUserData();
          Get.offAll(() => const BusinessCreatedSuccesful());
        } else {}
      } else {
        Get.snackbar("Error", "Error creating business, try again!");
        _createBusinessStatus(CreateBusinessStatus.Error);
      }
    } catch (ex) {
      Get.snackbar("Error", "Error creating business, try again!");
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
    // print("token ${_userController.token}");

    try {
      _updateBusinessStatus(UpdateBusinessStatus.Loading);
      String? imageId;
      var uploadController = Get.find<FileUploadRepository>();
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
          Uri.parse(ApiLink.updateBusiness +
              "/${selectedBusiness.value!.businessId}"),
          body: jsonEncode(itemsToUpdate),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${_userController.token}"
          });

      // print("Update business response ${response.body}");
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
          Timer(const Duration(milliseconds: 2000), () {
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
