import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:huzz/Repository/business_respository.dart';
import 'package:huzz/Repository/miscellaneous_respository.dart';
import 'package:huzz/api_link.dart';
import 'package:huzz/app/Utils/util.dart';
import 'package:huzz/app/screens/inventory/Product/productConfirm.dart';
import 'package:huzz/model/product.dart';
import 'package:huzz/sqlite/sqlite_db.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'auth_respository.dart';
import 'file_upload_respository.dart';

enum AddingProductStatus { Loading, Error, Success, Empty }
enum AddingServiceStatus { Loading, Error, Success, Empty }
enum ProductStatus { Loading, Available, Error, Empty }

class ProductRepository extends GetxController
    with GetSingleTickerProviderStateMixin {
  final _userController = Get.find<AuthRepository>();
  Rx<List<Product>> _onlineBusinessProduct = Rx([]);
  Rx<List<Product>> _offlineBusinessProduct = Rx([]);
  List<Product> get offlineBusinessProduct => _offlineBusinessProduct.value;
  List<Product> get onlineBusinessProduct => _onlineBusinessProduct.value;
  List<Product> pendingBusinessProduct = [];
  List<String> units = ['Box', 'feet', 'kilogram', 'meters'];
  Rx<String?> selectedUnit = Rx(null);

  Product? selectedProduct;
  final _uploadImageController = Get.find<FileUploadRespository>();
  Rx<List<Product>> _productService = Rx([]);
  Rx<List<Product>> _productGoods = Rx([]);
  final isProductService = false.obs;
  final _productStatus = ProductStatus.Empty.obs;

  List<Product> get productServices => _productService.value;
  List<Product> get productGoods => _productGoods.value;
  ProductStatus get productStatus => _productStatus.value;

  Rx<dynamic> MproductImage = Rx(null);
  dynamic get productImage => MproductImage.value;
  SqliteDb sqliteDb = SqliteDb();
  final productNameController = TextEditingController();
  MoneyMaskedTextController productCostPriceController =
      MoneyMaskedTextController(
          decimalSeparator: '.', thousandSeparator: ',', precision: 1);
  MoneyMaskedTextController productSellingPriceController =
      MoneyMaskedTextController(
          decimalSeparator: '.', thousandSeparator: ',', precision: 1);
  final productQuantityController = TextEditingController();
  final productUnitController = TextEditingController();
  final serviceDescription = TextEditingController();
  final _businessController = Get.find<BusinessRespository>();
  final _addingProductStatus = AddingProductStatus.Empty.obs;
  final _addingServiceStatus = AddingServiceStatus.Empty.obs;
  final _uploadFileController = Get.find<FileUploadRespository>();
  AddingProductStatus get addingProductStatus => _addingProductStatus.value;
  AddingServiceStatus get addingServiceStatus => _addingServiceStatus.value;
  TabController? tabController;
  Rx<List<Product>> _deleteProductList = Rx([]);
  List<Product> get deleteProductList => _deleteProductList.value;
  List<Product> pendingUpdatedProductList = [];
  List<Product> pendingToUpdatedProductToServer = [];
  List<Product> pendingToBeAddedProductToServer = [];
  List<Product> pendingDeletedProductToServer = [];
  Rx<dynamic> _totalProduct = 0.0.obs;
  Rx<dynamic> _totalService = 0.0.obs;
  dynamic get totalProduct => _totalProduct.value;
  dynamic get totalService => _totalService.value;
  var uuid = Uuid();
  final _miscellaneousController = Get.find<MiscellaneousRepository>();
  @override
  void onInit() async {
    // ignore: todo
    // TODO: implement onInit
    super.onInit();
    tabController = TabController(length: 2, vsync: this);

    _miscellaneousController.unitTypeList.listen((p0) {
      if (p0.isNotEmpty) {
        units = p0;
      }
    });
    //  await sqliteDb.openDatabae();
    _userController.Mtoken.listen((p0) {
      if (p0.isNotEmpty || p0 != "0") {
        final value = _businessController.selectedBusiness.value;
        if (value != null && value.businessId != null) {
          getOnlineProduct(value.businessId!);
          getOfflineProduct(value.businessId!);
        }
        _businessController.selectedBusiness.listen((p0) {
          if (p0 != null && p0.businessId != null) {
            productCostPriceController = MoneyMaskedTextController(
                leftSymbol: '${Utils.getCurrency()} ',
                decimalSeparator: '.',
                thousandSeparator: ',',
                precision: 1);

            productSellingPriceController = MoneyMaskedTextController(
                leftSymbol: '${Utils.getCurrency()} ',
                decimalSeparator: '.',
                thousandSeparator: ',',
                precision: 1);
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
      if (productImage != null && productImage != Null) {
        fileId = await _uploadFileController.uploadFile(productImage!.path);
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
            "productLogoFileStoreUrl": fileId,
            "description": serviceDescription.text
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
      print("adding product error ${ex.toString()}");
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
    if (productImage != null && productImage != Null) {
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
        sellingPrice: productSellingPriceController.numberValue,
        costPrice: productCostPriceController.numberValue,
        quantity: int.parse(productQuantityController.text),
        productType: type,
        description: serviceDescription.text,
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
    if (productImage != null && productImage != Null) {
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
        productNameChanged: (selectedProduct!.productName!
            .contains(productNameController.text)),
        isUpdatingPending: true,
        productName: productNameController.text,
        sellingPrice: int.parse(productSellingPriceController.text),
        costPrice: int.parse(productCostPriceController.text),
        quantity: int.parse(productQuantityController.text),
        description: serviceDescription.text,
        productLogoFileStoreId:
            outFile == null ? newproduct.productLogoFileStoreId : outFile.path);

    print("product offline saving ${product.toJson()}");
    _businessController.sqliteDb.updateOfflineProdcut(product);
    clearValue();
    Get.off(Confirmation(
      text: "Updated",
      title: title,
    ));
  }

  void clearValue() {
    MproductImage(Null);
    productNameController.text = "";
    serviceDescription.text = "";
    productCostPriceController.clear();
    productSellingPriceController.clear();
    productQuantityController.clear();
    selectedUnit.value = null;
  }

  Future updateBusinessProductOnline(Product product, String title) async {
    try {
      print("product name is ${productNameController.text}");
      _addingProductStatus(AddingProductStatus.Loading);
      // ignore: avoid_init_to_null
      String? fileId = null;
      print(
          "selling Product Price ${productSellingPriceController.numberValue}");
      if (productImage != null && productImage != Null) {
        fileId = await _uploadFileController.uploadFile(productImage!.path);
      }
      var response = await http
          .put(Uri.parse(ApiLink.add_product + "/" + product.productId!),
              body: jsonEncode({
                if (!selectedProduct!.productName!
                    .contains(productNameController.text))
                  "name": productNameController.text,
                "costPrice": productCostPriceController.numberValue,
                "sellingPrice": productSellingPriceController.numberValue,
                "quantity": productQuantityController.text,
                "businessId": product.businessId,
                "productType": product.productType,
                "productLogoFileStoreUrl": fileId,
                "description": serviceDescription.text
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
        clearValue();

        Get.off(Confirmation(
          text: "Updated",
          title: title,
        ));
      } else {
        _addingProductStatus(AddingProductStatus.Error);
        Get.snackbar("Error", "Unable to update product");
      }
    } catch (ex) {
      _addingProductStatus(AddingProductStatus.Error);
      print("an error has occurred ${ex.toString()}");
    }
  }

  void setItem(Product product) {
    productNameController.text = product.productName!;
    productQuantityController.text = product.quantityLeft!.toString();
    productCostPriceController.text = product.costPrice.toString();
    productSellingPriceController.text = product.sellingPrice.toString();
    serviceDescription.text = product.description!;
    productUnitController.text = "";
    // serviceDescription.text = product.;
    selectedProduct = product;
    // print("product quantity ${product.quantityLeft}");
  }

  Future getOfflineProduct(String businessId) async {
    try {
      _productStatus(ProductStatus.Loading);
      print("trying to get product offline");
      var result =
          await _businessController.sqliteDb.getOfflineProducts(businessId);
      _offlineBusinessProduct(result);
      print("offline product found ${result.length}");
      setProductDifferent();
      result.isNotEmpty
          ? _productStatus(ProductStatus.Available)
          : _productStatus(ProductStatus.Empty);
    } catch (error) {
      print(error.toString());
      _productStatus(ProductStatus.Error);
    }
  }

  Future getOnlineProduct(String businessId) async {
    try {
      _productStatus(ProductStatus.Loading);
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
          result.isNotEmpty
              ? _productStatus(ProductStatus.Available)
              : _productStatus(ProductStatus.Empty);
        }
      } else {}
    } catch (error) {
      print(error.toString());
      _productStatus(ProductStatus.Error);
    }
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
    dynamic totalproduct = 0.0;
    dynamic totalservice = 0.0;
    offlineBusinessProduct.forEach((element) {
      if (element.productType == "SERVICES") {
        services.add(element);
        totalservice = totalservice + element.costPrice;
      } else {
        totalproduct = totalproduct + element.sellingPrice;
        goods.add(element);
      }
    });
    _productGoods(goods);
    _productService(services);
    _totalService(totalservice);
    _totalProduct(totalproduct);
    print("product price $totalproduct");
    print("service price $totalservice");
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
    print("trying to delete online");
    var response = await http.delete(
        Uri.parse(ApiLink.add_product +
            "/${product.productId}?businessId=${product.businessId}"),
        headers: {"Authorization": "Bearer ${_userController.token}"});
    print("delete response ${response.body}");
    if (response.statusCode == 200) {
    } else {}
    _businessController.sqliteDb.deleteProduct(product);
    await getOfflineProduct(product.businessId!);
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
    print("selected for deletion is ${deleteProductList.length}");
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

    await getOfflineProduct(deletenext.businessId!);
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
        if (File(savenext.productLogoFileStoreId!).existsSync()) {
          String image = await _uploadImageController
              .uploadFile(savenext.productLogoFileStoreId!);

          File _file = File(savenext.productLogoFileStoreId!);
          savenext.productLogoFileStoreId = image;
          _file.deleteSync();
        }
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
      String? fileId;
      if (updatenext.productLogoFileStoreId != null &&
          !updatenext.productLogoFileStoreId!.contains("https://")) {}

      var response = await http
          .put(Uri.parse(ApiLink.add_product + "/" + updatenext.productId!),
              body: jsonEncode({
                if (!updatenext.productNameChanged!)
                  "name": productNameController.text,
                "costPrice": updatenext.costPrice,
                "sellingPrice": updatenext.sellingPrice,
// "quantity":productQuantityController.text,
                "businessId": updatenext.businessId,
                "productType": updatenext.productType,
                "productLogoFileStoreUrl":
                    fileId ?? updatenext.productLogoFileStoreId,
                "description": updatenext.description
              }),
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
