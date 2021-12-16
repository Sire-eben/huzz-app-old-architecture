// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:huzz/Repository/business_respository.dart';
// import 'package:huzz/api_link.dart';
// import 'package:huzz/app/screens/inventory/Product/productConfirm.dart';
// import 'package:huzz/model/debtor.dart';
// import 'package:huzz/sqlite/sqlite_db.dart';
// import 'package:path/path.dart' as path;
// import 'package:path_provider/path_provider.dart';
// import 'package:uuid/uuid.dart';

// import 'auth_respository.dart';
// import 'file_upload_respository.dart';

// enum AddingDebtorStatus { Loading, Error, Success, Empty }

// class DebtorRepository extends GetxController
//     with GetSingleTickerProviderStateMixin {
//   final _userController = Get.find<AuthRepository>();
//   Rx<List<Debtor>> _onlineBusinessDebtor = Rx([]);
//   Rx<List<Debtor>> _offlineBusinessDebtor = Rx([]);
//   List<Debtor> get offlineBusinessDebtor => _offlineBusinessDebtor.value;
//   List<Debtor> get onlineBusinessDebtor => _onlineBusinessDebtor.value;
//   List<Debtor> pendingBusinessDebtor = [];
//   final _uploadImageController = Get.find<FileUploadRespository>();
//   Rx<List<Debtor>> _debtorService = Rx([]);
//   Rx<List<Debtor>> _debtorGoods = Rx([]);
//   final isDebtorService = false.obs;
//   List<Debtor> get debtorServices => _debtorService.value;
//   List<Debtor> get debtorGoods => _debtorGoods.value;
//   Rx<File?> debtorImage = Rx(null);
//   SqliteDb sqliteDb = SqliteDb();
//   final debtorNameController = TextEditingController();
//   final debtorCostPriceController = TextEditingController();
//   final debtorSellingPriceController = TextEditingController();
//   final debtorQuantityController = TextEditingController();
//   final debtorUnitController = TextEditingController();
//   final serviceDescription = TextEditingController();
//   final _businessController = Get.find<BusinessRespository>();
//   final _addingDebtorStatus = AddingDebtorStatus.Empty.obs;
//   final _uploadFileController = Get.find<FileUploadRespository>();
//   AddingDebtorStatus get addingDebtorStatus => _addingDebtorStatus.value;
//   TabController? tabController;
//   Rx<List<Debtor>> _deleteDebtorList = Rx([]);
//   List<Debtor> get deleteDebtorList => _deleteDebtorList.value;
//   List<Debtor> pendingUpdatedDebtorList = [];
//   List<Debtor> pendingToUpdatedDebtorToServer = [];
//   List<Debtor> pendingToBeAddedDebtorToServer = [];
//   List<Debtor> pendingDeletedDebtorToServer = [];
//   var uuid = Uuid();
//   @override
//   void onInit() async {
//     // TODO: implement onInit
//     super.onInit();
//     tabController = TabController(length: 2, vsync: this);

//     //  await sqliteDb.openDatabae();
//     _userController.Mtoken.listen((p0) {
//       if (p0.isNotEmpty || p0 != "0") {
//         final value = _businessController.selectedBusiness.value;
//         if (value != null) {
//           getOnlineDebtor(value.businessId!);
//           getOfflineDebtor(value.businessId!);
//         }
//         _businessController.selectedBusiness.listen((p0) {
//           if (p0 != null) {
//             print("business id ${p0.businessId}");
//             _offlineBusinessDebtor([]);

//             _onlineBusinessDebtor([]);
//             _debtorService([]);
//             _debtorGoods([]);
//             getOnlineDebtor(p0.businessId!);
//             getOfflineDebtor(p0.businessId!);
//           }
//         });
//       }
//     });
//     _userController.MonlineStatus.listen((po) {
//       if (po == OnlineStatus.Onilne) {
//         _businessController.selectedBusiness.listen((p0) {
//           checkPendingCustomerTobeUpdatedToServer();
//           checkPendingDebtorToBeAddedToSever();
//           checkPendingCustomerToBeDeletedOnServer();
//           //update server with pending job
//         });
//       }
//     });
//   }

//   Future addDebtorOnline(String type) async {
//     try {
//       _addingDebtorStatus(AddingDebtorStatus.Loading);
//       String? fileId = null;
//       if (debtorImage.value != null) {
//         fileId =
//             await _uploadFileController.uploadFile(debtorImage.value!.path);
//       }
//       var response = await http.post(Uri.parse(ApiLink.add_debtor),
//           body: jsonEncode({
//             "name": debtorNameController.text,
//             "costPrice": debtorCostPriceController.text,
//             "sellingPrice": debtorSellingPriceController.text,
//             "quantity": debtorQuantityController.text,
//             "businessId":
//                 _businessController.selectedBusiness.value!.businessId!,
//             "debtorType": type,
//             "debtorLogoFileStoreId": fileId
//           }),
//           headers: {
//             "Content-Type": "application/json",
//             "Authorization": "Bearer ${_userController.token}"
//           });

//       print("add debtor response ${response.body}");
//       if (response.statusCode == 200) {
//         _addingDebtorStatus(AddingDebtorStatus.Success);
//         getOnlineDebtor(
//             _businessController.selectedBusiness.value!.businessId!);
//         clearValue();
//         Get.to(Confirmation(
//           text: "Added",
//         ));
//       } else {
//         _addingDebtorStatus(AddingDebtorStatus.Error);
//         Get.snackbar("Error", "Unable to add debtor");
//       }
//     } catch (ex) {
//       Get.snackbar("Error", "Unknown error occurred.. try again");
//       _addingDebtorStatus(AddingDebtorStatus.Error);
//     }
//   }

//   Future addBudinessDebtor(String type) async {
//     if (_userController.onlineStatus == OnlineStatus.Onilne) {
//       addDebtorOnline(type);
//     } else {
//       addBusinessDebtorOffline(type);
//     }
//   }

//   Future UpdateBusinessDebtor(Debtor debtor) async {
//     if (_userController.onlineStatus == OnlineStatus.Onilne) {
//       updateBusinessDebtorOnline(debtor);
//     } else {
//       updateBusinessDebtorOffline(debtor);
//     }
//   }

//   Future addBusinessDebtorOffline(String type) async {
//     File? outFile;
//     if (debtorImage.value != null) {
//       var list = await getApplicationDocumentsDirectory();

//       Directory appDocDir = list;
//       String appDocPath = appDocDir.path;

//       String basename = path.basename(debtorImage.value!.path);
//       var newPath = appDocPath + basename;
//       print("new file path is ${newPath}");
//       outFile = File(newPath);
//       debtorImage.value!.copySync(outFile.path);
//     }

//     Debtor debtor = Debtor(
//         paid: true,
//         debtorId: uuid.v1(),
//         businessId: _businessController.selectedBusiness.value!.businessId!,
//         customerId: debtorNameController.text,
//         balance: int.parse(debtorSellingPriceController.text),
//         totalAmount: int.parse(debtorCostPriceController.text),
//         businessTransactionId: int.parse(debtorQuantityController.text),
//         businessTransactionType: type,
//         // debtorLogoFileStoreId: outFile == null ? null : outFile.path,
//         );

//     print("debtor offline saving ${debtor.toJson()}");
//     _businessController.sqliteDb.insertDebtor(debtor);
//     clearValue();
//     getOfflineDebtor(_businessController.selectedBusiness.value!.businessId!);
//     Get.to(Confirmation(
//       text: "Added",
//     ));
//   }

//   Future updateBusinessDebtorOffline(Debtor newdebtor) async {
//     File? outFile;
//     if (debtorImage != null) {
//       var list = await getApplicationDocumentsDirectory();

//       Directory appDocDir = list;
//       String appDocPath = appDocDir.path;

//       String basename = path.basename(debtorImage.value!.path!);
//       var newPath = appDocPath + basename;
//       print("new file path is ${newPath}");
//       outFile = File(newPath);
//       debtorImage.value!.copySync(outFile.path);
//     }
    
//     Debtor debtor = Debtor(
//         isUpdatingPending: true,
//         debtorName: debtorNameController.text,
//         sellingPrice: int.parse(debtorSellingPriceController.text),
//         costPrice: int.parse(debtorCostPriceController.text),
//         quantity: int.parse(debtorQuantityController.text),
//         debtorLogoFileStoreId:
//             outFile == null ? newdebtor.debtorLogoFileStoreId : outFile.path);

//     print("debtor offline saving ${debtor.toJson()}");
//     _businessController.sqliteDb.updateOfflineProdcut(debtor);
//     clearValue();
//     Get.to(Confirmation(
//       text: "Updated",
//     ));
//   }

//   void clearValue() {
//     debtorImage(null);
//     debtorNameController.text = "";
//     debtorQuantityController.text = "";
//     debtorCostPriceController.text = "";
//     debtorSellingPriceController.text = "";
//     debtorUnitController.text = "";
//     serviceDescription.text = "";
//   }

//   Future updateBusinessDebtorOnline(Debtor debtor) async {
//     try {
//       _addingDebtorStatus(AddingDebtorStatus.Loading);
//       String? fileId = null;

//       if (debtorImage.value != null) {
//         fileId =
//             await _uploadFileController.uploadFile(debtorImage.value!.path);
//       }
//       var response = await http
//           .put(Uri.parse(ApiLink.add_debtor + "/" + debtor.debtorId!),
//               body: jsonEncode({
//                 "name": debtorNameController.text,
//                 "costPrice": debtorCostPriceController.text,
//                 "sellingPrice": debtorSellingPriceController.text,
// // "quantity":debtorQuantityController.text,
//                 "businessId": debtor.businessId,
//                 "debtorType": tabController!.index == 0 ? "GOODS" : "SERVICES",
//                 "debtorLogoFileStoreId": fileId
//               }),
//               headers: {
//             "Content-Type": "application/json",
//             "Authorization": "Bearer ${_userController.token}"
//           });

//       print("update debtor response ${response.body}");
//       if (response.statusCode == 200) {
//         _addingDebtorStatus(AddingDebtorStatus.Success);
//         getOnlineDebtor(
//             _businessController.selectedBusiness.value!.businessId!);

//         Get.to(Confirmation(
//           text: "Updated",
//         ));
//         clearValue();
//       } else {
//         _addingDebtorStatus(AddingDebtorStatus.Error);
//         Get.snackbar("Error", "Unable to update debtor");
//       }
//     } catch (ex) {
//       _addingDebtorStatus(AddingDebtorStatus.Error);
//     }
//   }

//   void setItem(Debtor debtor) {
//     debtorNameController.text = debtor.debtorName!;
//     debtorQuantityController.text = debtor.quantity!.toString();
//     debtorCostPriceController.text = debtor.costPrice.toString();
//     debtorSellingPriceController.text = debtor.sellingPrice.toString();
//     debtorUnitController.text = "";
//     serviceDescription.text = "";
//   }

//   Future getOfflineDebtor(String businessId) async {
//     var result =
//         await _businessController.sqliteDb.getOfflineDebtors(businessId);
//     _offlineBusinessDebtor(result);
//     print("offline debtor found ${result.length}");
//     setDebtorDifferent();
//   }

//   Future getOnlineDebtor(String businessId) async {
//     print("trying to get debtor online");
//     final response = await http.get(
//         Uri.parse(ApiLink.get_business_debtor + "?businessId=" + businessId),
//         headers: {"Authorization": "Bearer ${_userController.token}"});

//     print("result of get debtor online ${response.body}");
//     if (response.statusCode == 200) {
//       var json = jsonDecode(response.body);
//       if (json['success']) {
//         var result = List.from(json['data']['content'])
//             .map((e) => Debtor.fromJson(e))
//             .toList();
//         _onlineBusinessDebtor(result);
//         print("debtor business lenght ${result.length}");
//         await getBusinessDebtorYetToBeSavedLocally();
//         checkIfUpdateAvailable();
//       }
//     } else {}
//   }

//   Future getBusinessDebtorYetToBeSavedLocally() async {
//     onlineBusinessDebtor.forEach((element) {
//       if (!checkifDebtorAvailable(element.debtorId!)) {
//         print("doesnt contain value");

//         pendingBusinessDebtor.add(element);
//       }
//     });

//     savePendingJob();
//   }

//   Future checkIfUpdateAvailable() async {
//     onlineBusinessDebtor.forEach((element) async {
//       var item = checkifDebtorAvailableWithValue(element.debtorId!);
//       if (item != null) {
//         print("item debtor is found");
//         print("updated offline ${item.updatedTime!.toIso8601String()}");
//         print("updated online ${element.updatedTime!.toIso8601String()}");
//         if (!element.updatedTime!.isAtSameMomentAs(item.updatedTime!)) {
//           print("found debtor to updated");
//           pendingUpdatedDebtorList.add(element);
//         }
//       }
//     });

//     updatePendingJob();
//   }

//   Future setDebtorDifferent() async {
//     List<Debtor> goods = [];
//     List<Debtor> services = [];
//     offlineBusinessDebtor.forEach((element) {
//       if (element.debtorType == "DEBTOWNED") {
//         services.add(element);
//       } else {
//         goods.add(element);
//       }
//     });
//     _debtorGoods(goods);
//     _debtorService(services);
//   }

//   Future updatePendingJob() async {
//     if (pendingUpdatedDebtorList.isEmpty) {
//       return;
//     }

//     var updatednext = pendingUpdatedDebtorList.first;
//     await _businessController.sqliteDb.updateOfflineProdcut(updatednext);
//     pendingUpdatedDebtorList.remove(updatednext);
//     if (pendingUpdatedDebtorList.isNotEmpty) {
//       updatePendingJob();
//     }
//     getOfflineDebtor(updatednext.businessId!);
//   }

//   Future savePendingJob() async {
//     if (pendingBusinessDebtor.isEmpty) {
//       return;
//     }
//     var savenext = pendingBusinessDebtor.first;
//     await _businessController.sqliteDb.insertDebtor(savenext);
//     pendingBusinessDebtor.remove(savenext);
//     if (pendingBusinessDebtor.isNotEmpty) {
//       savePendingJob();
//     }
//     getOfflineDebtor(savenext.businessId!);
//   }

//   bool checkifDebtorAvailable(String id) {
//     bool result = false;
//     offlineBusinessDebtor.forEach((element) {
//       print("checking transaction whether exist");
//       if (element.debtorId == id) {
//         print("debtor   found");
//         result = true;
//       }
//     });
//     return result;
//   }

//   Debtor? checkifDebtorAvailableWithValue(String id) {
//     Debtor? item;

//     offlineBusinessDebtor.forEach((element) {
//       print("checking transaction whether exist");
//       if (element.debtorId == id) {
//         print("debtor   found");
//         item = element;
//       }
//     });
//     return item;
//   }

//   Future deleteDebtorOnline(Debtor debtor) async {
//     var response = await http.delete(
//         Uri.parse(ApiLink.add_debtor +
//             "/${debtor.debtorId}?businessId=${debtor.businessId}"),
//         headers: {"Authorization": "Bearer ${_userController.token}"});
//     print("delete response ${response.body}");
//     if (response.statusCode == 200) {
//     } else {}
//     _businessController.sqliteDb.deleteDebtor(debtor);
//   }

//   Future deleteBusinessDebtor(Debtor debtor) async {
//     if (_userController.onlineStatus == OnlineStatus.Onilne) {
//       deleteDebtorOnline(debtor);
//     } else {
//       deleteBusinessDebtorOffline(debtor);
//     }
//   }

//   Future deleteBusinessDebtorOffline(Debtor debtor) async {
//     debtor.deleted = true;

//     if (!debtor.isAddingPending!) {
//       _businessController.sqliteDb.updateOfflineProdcut(debtor);
//     } else {
//       _businessController.sqliteDb.deleteDebtor(debtor);
//     }
//     getOfflineDebtor(_businessController.selectedBusiness.value!.businessId!);
//   }

//   bool checkifSelectedForDelted(String id) {
//     bool result = false;
//     deleteDebtorList.forEach((element) {
//       print("checking transaction whether exist");
//       if (element.debtorId == id) {
//         print("debtor   found");
//         result = true;
//       }
//     });
//     return result;
//   }

//   Future deleteSelectedItem() async {
//     if (deleteDebtorList.isEmpty) {
//       return;
//     }
//     var deletenext = deleteDebtorList.first;
//     await deleteBusinessDebtor(deletenext);
//     var list = deleteDebtorList;
//     list.remove(deletenext);
//     _deleteDebtorList(list);

//     if (deleteDebtorList.isNotEmpty) {
//       deleteSelectedItem();
//     }
//     getOfflineDebtor(deletenext.businessId!);
//   }

//   void addToDeleteList(Debtor debtor) {
//     var list = deleteDebtorList;
//     list.add(debtor);
//     _deleteDebtorList(list);
//   }

//   void removeFromDeleteList(Debtor debtor) {
//     var list = deleteDebtorList;
//     list.remove(debtor);
//     _deleteDebtorList(list);
//   }

//   Future checkPendingDebtorToBeAddedToSever() async {
//     var list = await _businessController.sqliteDb.getOfflineDebtors(
//         _businessController.selectedBusiness.value!.businessId!);
//     offlineBusinessDebtor.forEach((element) {
//       if (element.isAddingPending!) {
//         pendingToBeAddedDebtorToServer.add(element);
//       }

//       print(
//           "debtor available for uploading to server ${pendingToBeAddedDebtorToServer.length}");
//     });
//     addPendingJobDebtorToServer();
//   }

//   Future checkPendingCustomerTobeUpdatedToServer() async {
//     offlineBusinessDebtor.forEach((element) {
//       if (element.isUpdatingPending! && !element.isAddingPending!) {
//         pendingToUpdatedDebtorToServer.add(element);
//       }
//     });

//     updatePendingJob();
//   }

//   Future checkPendingCustomerToBeDeletedOnServer() async {
//     var list = await _businessController.sqliteDb.getOfflineDebtors(
//         _businessController.selectedBusiness.value!.businessId!);

//     list.forEach((element) {
//       if (element.deleted!) {
//         pendingDeletedDebtorToServer.add(element);
//       }
//     });
//     deletePendingJobToServer();
//   }

//   Future addPendingJobDebtorToServer() async {
//     if (pendingToBeAddedDebtorToServer.isEmpty) {
//       return;
//     }

//     pendingToBeAddedDebtorToServer.forEach((element) async {
//       var savenext = element;

//       if (savenext.debtorLogoFileStoreId != null &&
//           savenext.debtorLogoFileStoreId != '') {
//         String image = await _uploadImageController
//             .uploadFile(savenext.debtorLogoFileStoreId!);

//         File _file = File(savenext.debtorLogoFileStoreId!);
//         savenext.debtorLogoFileStoreId = image;
//         _file.deleteSync();
//       }

//       var response = await http.post(Uri.parse(ApiLink.add_debtor),
//           body: jsonEncode(savenext.toJson()),
//           headers: {
//             "Content-Type": "application/json",
//             "Authorization": "Bearer ${_userController.token}"
//           });
//       print("pendong uploading response ${response.body}");
//       if (response.statusCode == 200) {
//         var json = jsonDecode(response.body);
//         if (json['success']) {
//           getOnlineDebtor(
//               _businessController.selectedBusiness.value!.businessId!);

//           _businessController.sqliteDb.deleteDebtor(savenext);

//           pendingToBeAddedDebtorToServer.remove(savenext);
//         }
//       }

//       if (pendingToBeAddedDebtorToServer.isNotEmpty) {
//         print(
//             "pendon debtor remained ${pendingToBeAddedDebtorToServer.length}");
//         addPendingJobDebtorToServer();
//       }
//     });
//   }

//   Future addPendingJobToBeUpdateToServer() async {
//     if (pendingToUpdatedDebtorToServer.isEmpty) {
//       return;
//     }
//     pendingToUpdatedDebtorToServer.forEach((element) async {
//       var updatenext = element;

//       var response = await http.put(
//           Uri.parse(ApiLink.add_debtor + "/" + updatenext.debtorId!),
//           body: jsonEncode(updatenext.toJson()),
//           headers: {
//             "Content-Type": "application/json",
//             "Authorization": "Bearer ${_userController.token}"
//           });

//       print("update Customer response ${response.body}");
//       if (response.statusCode == 200) {
//         getOnlineDebtor(
//             _businessController.selectedBusiness.value!.businessId!);
//         pendingToUpdatedDebtorToServer.remove(updatenext);
//       }
//       if (pendingToUpdatedDebtorToServer.isNotEmpty)
//         addPendingJobToBeUpdateToServer();
//     });
//   }

//   Future deletePendingJobToServer() async {
//     if (pendingDeletedDebtorToServer.isEmpty) {
//       return;
//     }
//     pendingDeletedDebtorToServer.forEach((element) async {
//       var deletenext = element;
//       var response = await http.delete(
//           Uri.parse(ApiLink.add_debtor +
//               "/${deletenext.debtorId}?businessId=${deletenext.businessId}"),
//           headers: {"Authorization": "Bearer ${_userController.token}"});
//       print("delete response ${response.body}");
//       if (response.statusCode == 200) {
//         _businessController.sqliteDb.deleteDebtor(deletenext);
//         getOfflineDebtor(
//             _businessController.selectedBusiness.value!.businessId!);
//       } else {}

//       pendingDeletedDebtorToServer.remove(deletenext);
//       if (pendingDeletedDebtorToServer.isNotEmpty) {
//         deletePendingJobToServer();
//       }
//     });
//   }
// }
