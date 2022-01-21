import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:huzz/Repository/business_respository.dart';
import 'package:huzz/api_link.dart';
import 'package:huzz/app/screens/inventory/Product/productConfirm.dart';
import 'package:huzz/model/product.dart';
import 'package:huzz/sqlite/sqlite_db.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'auth_respository.dart';
import 'file_upload_respository.dart';
import 'package:path/path.dart' as path;

enum AddingProductStatus { Loading, Error, Success, Empty }

class ProductRepository extends GetxController
    with GetSingleTickerProviderStateMixin {
  final _userController = Get.find<AuthRepository>();
  Rx<List<Product>> _onlineBusinessProduct = Rx([]);
  Rx<List<Product>> _offlineBusinessProduct = Rx([]);
  List<Product> get offlineBusinessProduct => _offlineBusinessProduct.value;
  List<Product> get onlineBusinessProduct => _onlineBusinessProduct.value;
  List<Product> pendingBusinessProduct = [];
  final _uploadImageController = Get.find<FileUploadRespository>();
  Rx<List<Product>> _productService = Rx([]);
  Rx<List<Product>> _productGoods = Rx([]);
  final isProductService = false.obs;
  List<Product> get productServices => _productService.value;
  List<Product> get productGoods => _productGoods.value;
  Rx<dynamic> MproductImage = Rx(null);
  dynamic get productImage=>MproductImage.value;
  SqliteDb sqliteDb = SqliteDb();
  final productNameController = TextEditingController();
  final productCostPriceController = MoneyMaskedTextController(leftSymbol: 'NGN ',decimalSeparator: '.', thousandSeparator: ',');
  final productSellingPriceController = MoneyMaskedTextController(leftSymbol: 'NGN ',decimalSeparator: '.', thousandSeparator: ',');
  final productQuantityController = TextEditingController();
  final productUnitController = TextEditingController();
  final serviceDescription = TextEditingController();
  final _businessController = Get.find<BusinessRespository>();
  final _addingProductStatus = AddingProductStatus.Empty.obs;
  final _uploadFileController = Get.find<FileUploadRespository>();
  AddingProductStatus get addingProductStatus => _addingProductStatus.value;
  TabController? tabController;
  Rx<List<Product>> _deleteProductList = Rx([]);
  List<Product> get deleteProductList => _deleteProductList.value;
  List<Product> pendingUpdatedProductList = [];
  List<Product> pendingToUpdatedProductToServer = [];
  List<Product> pendingToBeAddedProductToServer = [];
  List<Product> pendingDeletedProductToServer = [];
  var uuid = Uuid();
  @override
  void onInit() async {
    // ignore: todo
    // TODO: implement onInit
    super.onInit();
    tabController = TabController(length: 2, vsync: this);

    //  await sqliteDb.openDatabae();
    _userController.Mtoken.listen((p0) {
      if (p0.isNotEmpty || p0 != "0") {
        final value = _businessController.selectedBusiness.value;
        if (value != null) {
          getOnlineProduct(value.businessId!);
          getOfflineProduct(value.businessId!);
        }
        _businessController.selectedBusiness.listen((p0) {
          if (p0 != null) {
            print("business id ${p0.businessId}");
            _offlineBusinessProduct([]);

            _onlineBusinessProduct([]);
            _productService([]);
            _productGoods([]);
            getOnlineProduct(p0.businessId!);
            getOfflineProduct(p0.businessId!);
          }
        });
      }
    });
    _userController.MonlineStatus.listen((po) {
      if (po == OnlineStatus.Onilne) {
        _businessController.selectedBusiness.listen((p0) {
          checkPendingCustomerTobeUpdatedToServer();
          checkPendingProductToBeAddedToSever();
          checkPendingCustomerToBeDeletedOnServer();
          //update server with pending job
        });
      }
    });
  }

  Future addProductOnline(String type, String title) async {
    try {
      _addingProductStatus(AddingProductStatus.Loading);
      // ignore: avoid_init_to_null
      String? fileId = null;
      if (productImage != null&&productImage!=Null) {
        fileId =
            await _uploadFileController.uploadFile(productImage!.path);
      }
      print("image link is $fileId");
      var response = await http.post(Uri.parse(ApiLink.add_product),
          body: jsonEncode({
            "name": productNameController.text,
            "costPrice": productCostPriceController.numberValue,
            "sellingPrice": productSellingPriceController.numberValue,
            "quantity": productQuantityController.text,
            "businessId":
                _businessController.selectedBusiness.value!.businessId!,
            "productType": type,
            "productLogoFileStoreId": fileId
          }),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${_userController.token}"
          });

      print("add product response ${response.body}");
      if (response.statusCode == 200) {
        _addingProductStatus(AddingProductStatus.Success);
        getOnlineProduct(
            _businessController.selectedBusiness.value!.businessId!);
        clearValue();
        Get.to(Confirmation(
          text: "Added",
          title: title,
        ));
      } else {
        _addingProductStatus(AddingProductStatus.Error);
        Get.snackbar("Error", "Unable to add product");
      }
    } catch (ex) {
      Get.snackbar("Error", "Unknown error occurred.. try again");
      _addingProductStatus(AddingProductStatus.Error);
    }
  }

  Future addBudinessProduct(String type, String title) async {
    if (_userController.onlineStatus == OnlineStatus.Onilne) {
      addProductOnline(type, title);
    } else {
      addBusinessProductOffline(type, title);
    }
  }

  // ignore: non_constant_identifier_names
  Future UpdateBusinessProduct(Product product, String title) async {
    if (_userController.onlineStatus == OnlineStatus.Onilne) {
      updateBusinessProductOnline(product, title);
    } else {
      updateBusinessProductOffline(product, title);
    }
  }

  Future addBusinessProductOffline(String type, String title) async {
    File? outFile;
    if (productImage!= null&& productImage!=Null) {
      var list = await getApplicationDocumentsDirectory();

      Directory appDocDir = list;
      String appDocPath = appDocDir.path;

      String basename = path.basename(productImage!.path);
      var newPath = appDocPath + basename;
      // ignore: unnecessary_brace_in_string_interps
      print("new file path is ${newPath}");
      outFile = File(newPath);
      productImage!.copySync(outFile.path);
    }

    Product product = Product(
        isAddingPending: true,
        productId: uuid.v1(),
        businessId: _businessController.selectedBusiness.value!.businessId!,
        productName: productNameController.text,
        sellingPrice:productSellingPriceController.numberValue,
        costPrice: productCostPriceController.numberValue,
        quantity: int.parse(productQuantityController.text),
        productType: type,
        productLogoFileStoreId: outFile == null ? null : outFile.path);

    print("product offline saving ${product.toJson()}");
    _businessController.sqliteDb.insertProduct(product);
    clearValue();
    getOfflineProduct(_businessController.selectedBusiness.value!.businessId!);
    Get.to(Confirmation(
      text: "Added",
      title: title,
    ));
  }

  Future updateBusinessProductOffline(Product newproduct, String title) async {
    File? outFile;
    // ignore: unnecessary_null_comparison
    if (productImage != null&&productImage!=Null) {
      var list = await getApplicationDocumentsDirectory();

      Directory appDocDir = list;
      String appDocPath = appDocDir.path;

      String basename = path.basename(productImage!.path);
      var newPath = appDocPath + basename;
      // ignore: unnecessary_brace_in_string_interps
      print("new file path is ${newPath}");
      outFile = File(newPath);
      productImage!.copySync(outFile.path);
    }
    Product product = Product(
        isUpdatingPending: true,
        productName: productNameController.text,
        sellingPrice: int.parse(productSellingPriceController.text),
        costPrice: int.parse(productCostPriceController.text),
        quantity: int.parse(productQuantityController.text),
        productLogoFileStoreId:
            outFile == null ? newproduct.productLogoFileStoreId : outFile.path);

    print("product offline saving ${product.toJson()}");
    _businessController.sqliteDb.updateOfflineProdcut(product);
    clearValue();
    Get.to(Confirmation(
      text: "Updated",
      title: title,
    ));
  }

  void clearValue() {
    MproductImage(Null);
    productNameController.text = "";
    productQuantityController.text = "";
    productCostPriceController.clear();
    productSellingPriceController.clear();
    productUnitController.text = "";
    serviceDescription.text = "";
  }

  Future updateBusinessProductOnline(Product product, String title) async {
    try {
      _addingProductStatus(AddingProductStatus.Loading);
      // ignore: avoid_init_to_null
      String? fileId = null;

      if (productImage != null) {
        fileId =
            await _uploadFileController.uploadFile(productImage!.path);
      }
      var response = await http
          .put(Uri.parse(ApiLink.add_product + "/" + product.productId!),
              body: jsonEncode({
                "name": productNameController.text,
                "costPrice": productCostPriceController.numberValue,
                "sellingPrice": productSellingPriceController.numberValue,
// "quantity":productQuantityController.text,
                "businessId": product.businessId,
                "productType": tabController!.index == 0 ? "GOODS" : "SERVICES",
                "productLogoFileStoreId": fileId
              }),
              headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${_userController.token}"
          });

      print("update product response ${response.body}");
      if (response.statusCode == 200) {
        _addingProductStatus(AddingProductStatus.Success);
        getOnlineProduct(
            _businessController.selectedBusiness.value!.businessId!);

        Get.to(Confirmation(
          text: "Updated",
          title: title,
        ));
        clearValue();
      } else {
        _addingProductStatus(AddingProductStatus.Error);
        Get.snackbar("Error", "Unable to update product");
      }
    } catch (ex) {
      _addingProductStatus(AddingProductStatus.Error);
    }
  }

  void setItem(Product product) {
    productNameController.text = product.productName!;
    productQuantityController.text = product.quantity!.toString();
    productCostPriceController.text = product.costPrice.toString();
    productSellingPriceController.text = product.sellingPrice.toString();
    productUnitController.text = "";
    serviceDescription.text = "";
  }

  Future getOfflineProduct(String businessId) async {
    var result =
        await _businessController.sqliteDb.getOfflineProducts(businessId);
    _offlineBusinessProduct(result);
    print("offline product found ${result.length}");
    setProductDifferent();
  }

  Future getOnlineProduct(String businessId) async {
    print("trying to get product online");
    final response = await http.get(
        Uri.parse(ApiLink.get_business_product + "?businessId=" + businessId),
        headers: {"Authorization": "Bearer ${_userController.token}"});

    print("result of get product online ${response.body}");
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      if (json['success']) {
        var result = List.from(json['data']['content'])
            .map((e) => Product.fromJson(e))
            .toList();
        _onlineBusinessProduct(result);
        print("product business lenght ${result.length}");
        await getBusinessProductYetToBeSavedLocally();
        checkIfUpdateAvailable();
      }
    } else {}
  }

  Future getBusinessProductYetToBeSavedLocally() async {
    onlineBusinessProduct.forEach((element) {
      if (!checkifProductAvailable(element.productId!)) {
        print("doesnt contain value");

        pendingBusinessProduct.add(element);
      }
    });

    savePendingJob();
  }

  Future checkIfUpdateAvailable() async {
    onlineBusinessProduct.forEach((element) async {
      var item = checkifProductAvailableWithValue(element.productId!);
      if (item != null) {
        print("item product is found");
        print("updated offline ${item.updatedTime!.toIso8601String()}");
        print("updated online ${element.updatedTime!.toIso8601String()}");
        if (!element.updatedTime!.isAtSameMomentAs(item.updatedTime!)) {
          print("found product to updated");
          pendingUpdatedProductList.add(element);
        }
      }
    });

    updatePendingJob();
  }

  Future setProductDifferent() async {
    List<Product> goods = [];
    List<Product> services = [];
    offlineBusinessProduct.forEach((element) {
      if (element.productType == "SERVICES") {
        services.add(element);
      } else {
        goods.add(element);
      }
    });
    _productGoods(goods);
    _productService(services);
  }

  Future updatePendingJob() async {
    if (pendingUpdatedProductList.isEmpty) {
      return;
    }

    var updatednext = pendingUpdatedProductList.first;
    await _businessController.sqliteDb.updateOfflineProdcut(updatednext);
    pendingUpdatedProductList.remove(updatednext);
    if (pendingUpdatedProductList.isNotEmpty) {
      updatePendingJob();
    }
    getOfflineProduct(updatednext.businessId!);
  }

  Future savePendingJob() async {
    if (pendingBusinessProduct.isEmpty) {
      return;
    }
    var savenext = pendingBusinessProduct.first;
    await _businessController.sqliteDb.insertProduct(savenext);
    pendingBusinessProduct.remove(savenext);
    if (pendingBusinessProduct.isNotEmpty) {
      savePendingJob();
    }
    getOfflineProduct(savenext.businessId!);
  }

  bool checkifProductAvailable(String id) {
    bool result = false;
    offlineBusinessProduct.forEach((element) {
      print("checking transaction whether exist");
      if (element.productId == id) {
        print("product   found");
        result = true;
      }
    });
    return result;
  }

  Product? checkifProductAvailableWithValue(String id) {
    Product? item;

    offlineBusinessProduct.forEach((element) {
      print("checking transaction whether exist");
      if (element.productId == id) {
        print("product   found");
        item = element;
      }
    });
    return item;
  }

  Future deleteProductOnline(Product product) async {
    var response = await http.delete(
        Uri.parse(ApiLink.add_product +
            "/${product.productId}?businessId=${product.businessId}"),
        headers: {"Authorization": "Bearer ${_userController.token}"});
    print("delete response ${response.body}");
    if (response.statusCode == 200) {
    } else {}
    _businessController.sqliteDb.deleteProduct(product);
  }

  Future deleteBusinessProduct(Product product) async {
    if (_userController.onlineStatus == OnlineStatus.Onilne) {
      deleteProductOnline(product);
    } else {
      deleteBusinessProductOffline(product);
    }
  }

  Future deleteBusinessProductOffline(Product product) async {
    product.deleted = true;

    if (!product.isAddingPending!) {
      _businessController.sqliteDb.updateOfflineProdcut(product);
    } else {
      _businessController.sqliteDb.deleteProduct(product);
    }
    getOfflineProduct(_businessController.selectedBusiness.value!.businessId!);
  }

  bool checkifSelectedForDelted(String id) {
    bool result = false;
    deleteProductList.forEach((element) {
      print("checking transaction whether exist");
      if (element.productId == id) {
        print("product   found");
        result = true;
      }
    });
    return result;
  }

  Future deleteSelectedItem() async {
    if (deleteProductList.isEmpty) {
      return;
    }
    var deletenext = deleteProductList.first;
    await deleteBusinessProduct(deletenext);
    var list = deleteProductList;
    list.remove(deletenext);
    _deleteProductList(list);

    if (deleteProductList.isNotEmpty) {
      deleteSelectedItem();
    }
    getOfflineProduct(deletenext.businessId!);
  }

  void addToDeleteList(Product product) {
    var list = deleteProductList;
    list.add(product);
    _deleteProductList(list);
  }

  void removeFromDeleteList(Product product) {
    var list = deleteProductList;
    list.remove(product);
    _deleteProductList(list);
  }

  Future checkPendingProductToBeAddedToSever() async {
    // ignore: unused_local_variable
    var list = await _businessController.sqliteDb.getOfflineProducts(
        _businessController.selectedBusiness.value!.businessId!);
    offlineBusinessProduct.forEach((element) {
      if (element.isAddingPending!) {
        pendingToBeAddedProductToServer.add(element);
      }

      print(
          "product available for uploading to server ${pendingToBeAddedProductToServer.length}");
    });
    addPendingJobProductToServer();
  }

  Future checkPendingCustomerTobeUpdatedToServer() async {
    offlineBusinessProduct.forEach((element) {
      if (element.isUpdatingPending! && !element.isAddingPending!) {
        pendingToUpdatedProductToServer.add(element);
      }
    });

    updatePendingJob();
  }

  Future checkPendingCustomerToBeDeletedOnServer() async {
    var list = await _businessController.sqliteDb.getOfflineProducts(
        _businessController.selectedBusiness.value!.businessId!);

    list.forEach((element) {
      if (element.deleted!) {
        pendingDeletedProductToServer.add(element);
      }
    });
    deletePendingJobToServer();
  }

  Future addPendingJobProductToServer() async {
    if (pendingToBeAddedProductToServer.isEmpty) {
      return;
    }

    pendingToBeAddedProductToServer.forEach((element) async {
      var savenext = element;

      if (savenext.productLogoFileStoreId != null &&
          savenext.productLogoFileStoreId != '') {
        String image = await _uploadImageController
            .uploadFile(savenext.productLogoFileStoreId!);

        File _file = File(savenext.productLogoFileStoreId!);
        savenext.productLogoFileStoreId = image;
        _file.deleteSync();
      }

      var response = await http.post(Uri.parse(ApiLink.add_product),
          body: jsonEncode(savenext.toJson()),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${_userController.token}"
          });
      print("pendong uploading response ${response.body}");
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        if (json['success']) {
          getOnlineProduct(
              _businessController.selectedBusiness.value!.businessId!);

          _businessController.sqliteDb.deleteProduct(savenext);

          pendingToBeAddedProductToServer.remove(savenext);
        }
      }

      if (pendingToBeAddedProductToServer.isNotEmpty) {
        print(
            "pendon product remained ${pendingToBeAddedProductToServer.length}");
        addPendingJobProductToServer();
      }
    });
  }

  Future addPendingJobToBeUpdateToServer() async {
    if (pendingToUpdatedProductToServer.isEmpty) {
      return;
    }
    pendingToUpdatedProductToServer.forEach((element) async {
      var updatenext = element;

      var response = await http.put(
          Uri.parse(ApiLink.add_product + "/" + updatenext.productId!),
          body: jsonEncode(updatenext.toJson()),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${_userController.token}"
          });

      print("update Customer response ${response.body}");
      if (response.statusCode == 200) {
        getOnlineProduct(
            _businessController.selectedBusiness.value!.businessId!);
        pendingToUpdatedProductToServer.remove(updatenext);
      }
      if (pendingToUpdatedProductToServer.isNotEmpty)
        addPendingJobToBeUpdateToServer();
    });
  }

  Future deletePendingJobToServer() async {
    if (pendingDeletedProductToServer.isEmpty) {
      return;
    }
    pendingDeletedProductToServer.forEach((element) async {
      var deletenext = element;
      var response = await http.delete(
          Uri.parse(ApiLink.add_product +
              "/${deletenext.productId}?businessId=${deletenext.businessId}"),
          headers: {"Authorization": "Bearer ${_userController.token}"});
      print("delete response ${response.body}");
      if (response.statusCode == 200) {
        _businessController.sqliteDb.deleteProduct(deletenext);
        getOfflineProduct(
            _businessController.selectedBusiness.value!.businessId!);
      } else {}

      pendingDeletedProductToServer.remove(deletenext);
      if (pendingDeletedProductToServer.isNotEmpty) {
        deletePendingJobToServer();
      }
    });
  }
}
