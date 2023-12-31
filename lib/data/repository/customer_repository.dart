import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:huzz/data/repository/auth_respository.dart';
import 'package:huzz/data/repository/business_respository.dart';
import 'package:huzz/data/repository/file_upload_respository.dart';
import 'package:huzz/data/api_link.dart';
import 'package:huzz/ui/customers/confirmation.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/data/model/customer_model.dart';
import 'package:huzz/data/sqlite/sqlite_db.dart';
import 'package:random_color/random_color.dart';
import 'package:uuid/uuid.dart';

enum AddingCustomerStatus { Loading, Error, Success, Empty }

enum CustomerStatus { Loading, Available, Error, Empty, UnAuthorized }

class CustomerRepository extends GetxController {
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final amountController = TextEditingController();
  final totalAmountController = TextEditingController();
  final balanceController = TextEditingController();
  final _businessController = Get.find<BusinessRespository>();
  final _userController = Get.find<AuthRepository>();
  final _addingCustomerStatus = AddingCustomerStatus.Empty.obs;
  var uuid = Uuid();

  Rx<List<Customer>> _onlineBusinessCustomer = Rx([]);
  Rx<List<Customer>> _offlineBusinessCustomer = Rx([]);
  List<Customer> get offlineBusinessCustomer => _offlineBusinessCustomer.value;
  List<Customer> get onlineBusinessCustomer => _onlineBusinessCustomer.value;
  List<Customer> pendingBusinessCustomer = [];
  AddingCustomerStatus get addingCustomerStatus => _addingCustomerStatus.value;
  TabController? tabController;
  Rx<List<Customer>> _deleteCustomerList = Rx([]);

  List<Customer> get deleteCustomerList => _deleteCustomerList.value;
  List<Customer> pendingUpdatedCustomerList = [];

  Rx<List<Customer>> _customerCustomer = Rx([]);
  Rx<List<Customer>> _customerMerchant = Rx([]);

  final isCustomerService = false.obs;
  final _customerStatus = CustomerStatus.Empty.obs;

  List<Customer> get customerCustomer => _customerCustomer.value;
  List<Customer> get customerMerchant => _customerMerchant.value;
  CustomerStatus get customerStatus => _customerStatus.value;

  List<Contact> contactList = [];

  Rx<File?> CustomerImage = Rx(null);
  final _uploadFileController = Get.find<FileUploadRespository>();
  SqliteDb sqliteDb = SqliteDb();
  RandomColor _randomColor = RandomColor();
  List<Customer> pendingJobToBeAdded = [];
  List<Customer> pendingJobToBeUpdated = [];
  List<Customer> pendingJobToBeDelete = [];

  @override
  void onInit() {
    _userController.Mtoken.listen((p0) {
      if (p0.isNotEmpty || p0 != "0") {
        final value = _businessController.selectedBusiness.value;
        if (value != null && value.businessId != null) {
          getOnlineCustomer(value.businessId!);
          getOfflineCustomer(value.businessId!);
        }
        _businessController.selectedBusiness.listen((p0) async {
          if (p0 != null && p0.businessId != null) {
            print("business id ${p0.businessId}");
            _offlineBusinessCustomer([]);

            _onlineBusinessCustomer([]);
            _customerCustomer([]);
            _customerMerchant([]);
            await getOfflineCustomer(p0.businessId!);
            getOnlineCustomer(p0.businessId!);
          }
        });
      }
    });

    _userController.MonlineStatus.listen((po) {
      if (po == OnlineStatus.Onilne) {
        _businessController.selectedBusiness.listen((p0) {
          checkPendingCustomerToBeAddedToSever();
          checkPendingCustomerToBeDeletedOnServer();
          checkPendingCustomerTobeUpdatedToServer();
          //update server with pending job
        });
      }
    });

    getPhoneContact();
  }

  Future getPhoneContact() async {
    print("trying phone contact list");
    try {
      if (await FlutterContacts.requestPermission()) {
        contactList = await FlutterContacts.getContacts(
            withProperties: true, withPhoto: false);
        print("phone contacts ${contactList.length}");
      }
    } catch (ex) {
      print("contact error is ${ex.toString()}");
    }
  }

  Future addBusinnessCustomer(String type, String name) async {
    if (_userController.onlineStatus == OnlineStatus.Onilne) {
      addBusinessCustomerOnline(type, name);
    } else {
      addBusinessCustomerOffline(type, name);
    }
  }

  Future updateBusinesscustomer(Customer item) async {
    if (_userController.onlineStatus == OnlineStatus.Onilne) {
      updateCustomerOnline(item);
    } else {
      updateCustomerOffline(item);
    }
  }

  Future deleteBusinessCustomer(Customer item) async {
    if (_userController.onlineStatus == OnlineStatus.Onilne) {
      deleteCustomerOnline(item);
    } else {
      deleteCustomerOffline(item);
    }
  }

  Future addBusinessCustomerOnline(String transactionType, String name) async {
    try {
      _addingCustomerStatus(AddingCustomerStatus.Loading);
      var response = await http.post(Uri.parse(ApiLink.addCustomer),
          body: jsonEncode({
            "email": emailController.text,
            "phone": phoneNumberController.text,
            "name": nameController.text,
            "businessId":
                _businessController.selectedBusiness.value!.businessId,
            "businessTransactionType": transactionType,
          }),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${_userController.token}"
          });
      print("customer adding response ${response.body}");
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        if (json['success']) {
          _addingCustomerStatus(AddingCustomerStatus.Success);
          getOnlineCustomer(
              _businessController.selectedBusiness.value!.businessId!);
          clearValue();
          Get.to(ConfirmationCustomer(
            text: name,
          ));
          return json['data']['id'];
        } else {
          _addingCustomerStatus(AddingCustomerStatus.Error);
          Get.snackbar("Error", "Unable to add customer");
        }
      } else {
        _addingCustomerStatus(AddingCustomerStatus.Error);
        Get.snackbar("Error", "Unable to add customer");
      }
    } catch (ex) {
      print("error occurred ${ex.toString()}");
      _addingCustomerStatus(AddingCustomerStatus.Error);
      Get.snackbar("Error", "Unknown error occurred.. try again");
    }
  }

  Future<String?> addBusinessCustomerWithString(String transactionType) async {
    try {
      print(
          "adding customer phone ${phoneNumberController.text} name ${nameController.text}");
      var response = await http.post(Uri.parse(ApiLink.addCustomer),
          body: jsonEncode({
            "email": emailController.text,
            "phone": phoneNumberController.text,
            "name": nameController.text,
            "businessId":
                _businessController.selectedBusiness.value!.businessId,
            "businessTransactionType": transactionType,
          }),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${_userController.token}"
          });
      print("adding customer response ${response.body}");
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        if (json['success']) {
          await getOnlineCustomer(
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

  Future<String?> addBusinessCustomerWithStringWithValue(
      Customer customer) async {
    try {
      print(
          "adding customer phone ${phoneNumberController.text} name ${nameController.text}");
      var response = await http.post(Uri.parse(ApiLink.addCustomer),
          body: jsonEncode(customer.toJson()),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${_userController.token}"
          });
      print("adding customer response ${response.body}");
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        if (json['success']) {
          getOnlineCustomer(
              _businessController.selectedBusiness.value!.businessId!);
          // clearValue();

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

  Future<String?> addBusinessCustomerOfflineWithString(String transactionType,
      {bool isinvoice = false,
      bool istransaction = false,
      bool isdebtor = false}) async {
    var customer = Customer(
        name: nameController.text,
        phone: phoneNumberController.text,
        email: emailController.text,
        businessId: _businessController.selectedBusiness.value!.businessId,
        businessTransactionType: transactionType,
        customerId: uuid.v1(),
        isCreatedFromTransaction: istransaction,
        isCreatedFromInvoice: isinvoice,
        isCreatedFromDebtors: isdebtor);

    await _businessController.sqliteDb.insertCustomer(customer);
    getOfflineCustomer(customer.businessId!);
    clearValue();
    return customer.customerId!;
  }

  Future addBusinessCustomerOffline(String transactionType, String name) async {
    var customer = Customer(
        name: nameController.text,
        phone: phoneNumberController.text,
        email: emailController.text,
        businessId: _businessController.selectedBusiness.value!.businessId,
        businessTransactionType: transactionType,
        customerId: uuid.v1(),
        isAddingPending: true);

    await _businessController.sqliteDb.insertCustomer(customer);
    getOfflineCustomer(customer.businessId!);
    clearValue();
    Get.to(ConfirmationCustomer(
      text: name,
    ));
  }

  Future updateCustomerOnline(Customer customer) async {
    try {
      _addingCustomerStatus(AddingCustomerStatus.Loading);
      String? fileId;

      if (CustomerImage.value != null) {
        fileId =
            await _uploadFileController.uploadFile(CustomerImage.value!.path);
      }
      var response = await http
          .put(Uri.parse("${ApiLink.add_customer}/${customer.customerId!}"),
              body: jsonEncode({
                "email": emailController.text,
                "phone": phoneNumberController.text,
                "name": nameController.text,
                "businessId":
                    _businessController.selectedBusiness.value!.businessId,
                "businessTransactionType": customer.businessTransactionType
              }),
              headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${_userController.token}"
          });

      print("update Customer response ${response.body}");
      if (response.statusCode == 200) {
        _addingCustomerStatus(AddingCustomerStatus.Success);
        getOnlineCustomer(
            _businessController.selectedBusiness.value!.businessId!);

        Get.to(ConfirmationCustomer(
          text: "Updated",
        ));
        clearValue();
      } else {
        _addingCustomerStatus(AddingCustomerStatus.Error);
        Get.snackbar("Error", "Unable to update Customer");
      }
    } catch (ex) {
      _addingCustomerStatus(AddingCustomerStatus.Error);
    }
  }

  Future updateCustomerOffline(Customer customer) async {
    customer.isUpdatingPending = true;
    customer.updatedTime = DateTime.now();

    await _businessController.sqliteDb.updateOfflineCustomer(customer);
    Get.to(ConfirmationCustomer(
      text: "Updated",
    ));
    getOfflineCustomer(customer.businessId!);
  }

  Future getOfflineCustomer(String businessId) async {
    try {
      _customerStatus(CustomerStatus.Loading);
      var result =
          await _businessController.sqliteDb.getOfflineCustomers(businessId);
      var list = result.where((c) => c.deleted == false).toList();
      _offlineBusinessCustomer(list);
      print("offline Customer found ${result.length}");
      setCustomerDifferent();
      list.isNotEmpty
          ? _customerStatus(CustomerStatus.Available)
          : _customerStatus(CustomerStatus.Empty);
    } catch (error) {
      _customerStatus(CustomerStatus.Error);
      print(error.toString());
    }
  }

  Future getOnlineCustomer(String businessId) async {
    try {
      _customerStatus(CustomerStatus.Loading);
      print("trying to get Customer online for $businessId");

      final response = await http.get(
          Uri.parse(ApiLink.getBusinessCustomer +
              "?businessId=" +
              businessId +
              '&businessTransactionType=INCOME'),
          headers: {"Authorization": "Bearer ${_userController.token}"});

      final response1 = await http.get(
          Uri.parse(ApiLink.getBusinessCustomer +
              "?businessId=" +
              businessId +
              '&businessTransactionType=EXPENDITURE'),
          headers: {"Authorization": "Bearer ${_userController.token}"});

      print("result of get Customer online ${response.body}");
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        var json1 = jsonDecode(response1.body);
        if (json['success']) {
          final result = List.from(json['data']['content'])
              .map((e) => Customer.fromJson(e))
              .toList();
          final result1 = List.from(json1['data']['content'])
              .map((e) => Customer.fromJson(e))
              .toList();
          result.addAll(result1.toList());
          _onlineBusinessCustomer(result);

          result.isNotEmpty
              ? _customerStatus(CustomerStatus.Available)
              : _customerStatus(CustomerStatus.Empty);
          debugPrint("Customer business length ${result.length}");
          await getBusinessCustomerYetToBeSavedLocally();
          checkIfUpdateAvailable();
        }
      } else if (response.statusCode == 500) {
        _customerStatus(CustomerStatus.UnAuthorized);
      } else {
        _customerStatus(CustomerStatus.Error);
      }
    } catch (error) {
      _customerStatus(CustomerStatus.Error);
      print(error.toString());
    }
  }

  Future getBusinessCustomerYetToBeSavedLocally() async {
    onlineBusinessCustomer.forEach((element) {
      print("value is customer id is${element.customerId}");
      if (!checkifCustomerAvailable(element.customerId!)) {
        print("doesnt contain value");

        pendingBusinessCustomer.add(element);
      }
    });

    savePendingJob();
  }

  Future checkIfUpdateAvailable() async {
    onlineBusinessCustomer.forEach((element) async {
      var item = checkifCustomerAvailableWithValue(element.customerId!);
      if (item != null) {
        print("item Customer is found");
        print("updated offline ${item.updatedTime!.toIso8601String()}");
        print("updated online ${element.updatedTime!.toIso8601String()}");
        if (!element.updatedTime!.isAtSameMomentAs(item.updatedTime!)) {
          print("found Customer to updated");
          pendingUpdatedCustomerList.add(element);
        }
      }
    });

    updatePendingJob();
  }

  Future setCustomerDifferent() async {
    try {
      _customerStatus(CustomerStatus.Loading);
      List<Customer> customer = [];
      List<Customer> merchant = [];
      offlineBusinessCustomer.forEach((element) {
        if (element.businessTransactionType == "INCOME") {
          customer.add(element);
        } else {
          merchant.add(element);
        }
      });
      _customerCustomer(customer);
      _customerMerchant(merchant);
      (customer.isNotEmpty && merchant.isNotEmpty)
          ? _customerStatus(CustomerStatus.Available)
          : _customerStatus(CustomerStatus.Empty);
    } catch (error) {
      _customerStatus(CustomerStatus.Error);
    }
  }

  Future updatePendingJob() async {
    try {
      if (pendingUpdatedCustomerList.isEmpty) {
        return;
      }
      var updatednext = pendingUpdatedCustomerList.first;
      await _businessController.sqliteDb.updateOfflineCustomer(updatednext);
      pendingUpdatedCustomerList.remove(updatednext);
      if (pendingUpdatedCustomerList.isNotEmpty) {
        updatePendingJob();
      }
      getOfflineCustomer(updatednext.businessId!);
    } catch (error) {
      print(error.toString());
    }
  }

  Future savePendingJob() async {
    if (pendingBusinessCustomer.isEmpty) {
      return;
    }
    var savenext = pendingBusinessCustomer.first;
    await _businessController.sqliteDb.insertCustomer(savenext);
    pendingBusinessCustomer.remove(savenext);
    if (pendingBusinessCustomer.isNotEmpty) {
      savePendingJob();
    }
    getOfflineCustomer(savenext.businessId!);
  }

  bool checkifCustomerAvailable(String id) {
    bool result = false;
    offlineBusinessCustomer.forEach((element) {
      print("checking transaction whether exist");
      if (element.customerId == id) {
        print("Customer   found");
        result = true;
      }
    });
    return result;
  }

  Customer? checkifCustomerAvailableWithValue(String id) {
    Customer? item;

    offlineBusinessCustomer.forEach((element) {
      print("checking customer whether exist");
      if (element.customerId == id) {
        print("Customer   found");
        item = element;
      } else {
        print("customer not found");
      }
    });
    return item;
  }

  Future deleteCustomerOnline(Customer customer) async {
    var response = await http.delete(
        Uri.parse(
            "${ApiLink.add_customer}/${customer.customerId}?businessId=${customer.businessId}"),
        headers: {"Authorization": "Bearer ${_userController.token}"});
    print("delete response ${response.body}");
    if (response.statusCode == 200) {
      _businessController.sqliteDb.deleteCustomer(customer);
      getOfflineCustomer(
          _businessController.selectedBusiness.value!.businessId!);
    } else {
      Get.snackbar("Error", "Error deleting customer, try again!");
      _businessController.sqliteDb.deleteCustomer(customer);
      getOfflineCustomer(
          _businessController.selectedBusiness.value!.businessId!);
    }
  }

  Future deleteCustomerOffline(Customer customer) async {
    customer.deleted = true;

    if (!customer.isAddingPending!) {
      _businessController.sqliteDb.updateOfflineCustomer(customer);
    } else {
      _businessController.sqliteDb.deleteCustomer(customer);
    }

    getOfflineCustomer(_businessController.selectedBusiness.value!.businessId!);
  }

  bool checkifSelectedForDelted(String id) {
    bool result = false;
    deleteCustomerList.forEach((element) {
      print("checking transaction whether exist");
      if (element.customerId == id) {
        print("Customer   found");
        result = true;
      }
    });
    return result;
  }

  Future checkPendingCustomerToBeAddedToSever() async {
    print("checking customer that is pending to be added");

    var list = await _businessController.sqliteDb.getOfflineCustomers(
        _businessController.selectedBusiness.value!.businessId!);
    print("offline customer lenght ${list.length}");
    list.forEach((element) {
      if (element.isAddingPending!) {
        pendingJobToBeAdded.add(element);
        print("item is found to be added");
      }
    });
    print(
        "number of customer to be added to server ${pendingJobToBeAdded.length}");
    addPendingJobCustomerToServer();
  }

  Future checkPendingCustomerTobeUpdatedToServer() async {
    var list = await _businessController.sqliteDb.getOfflineCustomers(
        _businessController.selectedBusiness.value!.businessId!);
    list.forEach((element) {
      if (element.isUpdatingPending! && !element.isAddingPending!) {
        pendingJobToBeUpdated.add(element);
      }
    });

    addPendingJobToBeUpdateToServer();
  }

  Future checkPendingCustomerToBeDeletedOnServer() async {
    print("checking customer to be deleted");
    var list = await _businessController.sqliteDb.getOfflineCustomers(
        _businessController.selectedBusiness.value!.businessId!);
    print("checking customer to be deleted list ${list.length}");
    list.forEach((element) {
      if (element.deleted!) {
        pendingJobToBeDelete.add(element);
        print("Customer to be deleted is found ");
      }
    });
    print("customer to be deleted ${pendingJobToBeDelete.length}");
    deletePendingJobToServer();
  }

  Future addPendingJobCustomerToServer() async {
    if (pendingJobToBeAdded.isEmpty) {
      return;
    }
    var savenext = pendingJobToBeAdded.first;

    var response = await http.post(Uri.parse(ApiLink.addCustomer),
        body: jsonEncode({
          "email": savenext.email,
          "phone": savenext.phone,
          "name": savenext.name,
          "businessId": savenext.businessId,
          "businessTransactionType": savenext.businessTransactionType,
        }),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${_userController.token}"
        });

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      if (json['success']) {
        getOnlineCustomer(
            _businessController.selectedBusiness.value!.businessId!);

        _businessController.sqliteDb.deleteCustomer(savenext);
        print("pending to be added is delete");
        return json['data']['id'];
      }
    }
    pendingJobToBeAdded.remove(savenext);
    if (pendingJobToBeAdded.isNotEmpty) {
      addPendingJobCustomerToServer();
    }
  }

  Future addPendingJobToBeUpdateToServer() async {
    if (pendingJobToBeUpdated.isEmpty) {
      return;
    }

    pendingJobToBeUpdated.forEach((element) async {
      var updatenext = element;

      var response = await http
          .put(Uri.parse("${ApiLink.add_customer}/${updatenext.customerId!}"),
              body: jsonEncode({
                "email": updatenext.email,
                "phone": updatenext.phone,
                "name": updatenext.name,
                "businessId": updatenext.businessId,
                "businessTransactionType": updatenext.businessTransactionType
              }),
              headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${_userController.token}"
          });

      print("update Customer response ${response.body}");
      if (response.statusCode == 200) {
        _addingCustomerStatus(AddingCustomerStatus.Success);
        getOnlineCustomer(
            _businessController.selectedBusiness.value!.businessId!);
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
          Uri.parse(
              "${ApiLink.add_customer}/${deletenext.customerId}?businessId=${deletenext.businessId}"),
          headers: {"Authorization": "Bearer ${_userController.token}"});
      print("previous deleted response ${response.body}");
      if (response.statusCode == 200) {
        _businessController.sqliteDb.deleteCustomer(deletenext);
        getOfflineCustomer(
            _businessController.selectedBusiness.value!.businessId!);
      } else {
        _businessController.sqliteDb.deleteCustomer(deletenext);
        getOfflineCustomer(
            _businessController.selectedBusiness.value!.businessId!);
      }

      pendingJobToBeDelete.forEach((element) async {
        var deletenext = pendingJobToBeDelete.first;
        var response = await http.delete(
            Uri.parse(
                "${ApiLink.add_customer}/${deletenext.customerId}?businessId=${deletenext.businessId}"),
            headers: {"Authorization": "Bearer ${_userController.token}"});
        print("previous deleted response ${response.body}");
        if (response.statusCode == 200) {
          _businessController.sqliteDb.deleteCustomer(deletenext);
          getOfflineCustomer(
              _businessController.selectedBusiness.value!.businessId!);
        } else {}

        pendingJobToBeDelete.remove(deletenext);
        if (pendingJobToBeDelete.isNotEmpty) {
          deletePendingJobToServer();
        }
      });
    });
  }

  Future deleteSelectedItem() async {
    if (deleteCustomerList.isEmpty) {
      return;
    }
    var deletenext = deleteCustomerList.first;
    await deleteBusinessCustomer(deletenext);
    var list = deleteCustomerList;
    list.remove(deletenext);
    _deleteCustomerList(list);

    if (deleteCustomerList.isNotEmpty) {
      deleteSelectedItem();
    }
    getOfflineCustomer(deletenext.businessId!);
  }

  void addToDeleteList(Customer Customer) {
    var list = deleteCustomerList;
    list.add(Customer);
    _deleteCustomerList(list);
  }

  void removeFromDeleteList(Customer Customer) {
    var list = deleteCustomerList;
    list.remove(Customer);
    _deleteCustomerList(list);
  }

  void clearValue() {
    CustomerImage(null);
    nameController.text = "";
    emailController.text = "";
    phoneNumberController.text = "";
  }

  void setItem(Customer customer) {
    nameController.text = customer.name!;
    phoneNumberController.text = customer.phone!;
    emailController.text = customer.email!;
  }

  Future showContactPicker(BuildContext context) async {
    print("contact picker is selected");
    _searchtext("");
    _searchResult([]);
    await showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              height: Get.width -
                  100, //height or you can use Get.width-100 to set height
              child: buildSelectContact(context),
            )));
  }

  Rx<List<Contact>> _searchResult = Rx([]);
  Rx<String> _searchtext = Rx('');
  List<Contact> get searchResult => _searchResult.value;
  String get searchtext => _searchtext.value;

  void searchItem(String val) {
    _searchtext(val);

    _searchResult([]);
    List<Contact> list = [];
    contactList.forEach((element) {
      if (element.displayName.isNotEmpty &&
          element.displayName.toLowerCase().contains(val.toLowerCase())) {
        print("contact found");
        list.add(element);
      }
    });

    _searchResult(list);
  }

  Widget buildSelectContact(BuildContext context) {
    print("contact on phone ${contactList.length}");
    return Obx(() {
      return Container(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.04,
            right: MediaQuery.of(context).size.width * 0.04,
            bottom: MediaQuery.of(context).size.width * 0.04,
            top: MediaQuery.of(context).size.width * 0.02),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 6,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(4)),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),

            TextField(
              onChanged: searchItem,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w400,
                color: AppColors.backgroundColor,
              ),
              // controller: _searchcontroller,
              cursorColor: Colors.white,
              autofocus: false,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.backgroundColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: BorderSide(color: Colors.black12),
                ),
                fillColor: Colors.white,
                filled: true,
                hintText: 'Search Customers',
                hintStyle: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
                contentPadding:
                    EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    width: 2,
                    color: AppColors.backgroundColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    width: 2,
                    color: AppColors.backgroundColor,
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),
            Expanded(
              // width: MediaQuery.of(context).size.width,
              child: (searchtext.isEmpty || searchResult.isNotEmpty)
                  ? ListView.builder(
                      itemBuilder: (context, index) {
                        var item = (searchResult.isEmpty)
                            ? contactList[index]
                            : searchResult[index];
                        return Visibility(
                          visible: item.phones.isNotEmpty,
                          child: GestureDetector(
                            onTap: () {
                              Get.back();
                              nameController.text = item.displayName;
                              phoneNumberController.text =
                                  item.phones.first.number;
                              if (item.emails.isNotEmpty)
                                emailController.text =
                                    item.emails.first.address;
                            },
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: _randomColor.randomColor()),
                                        child: Center(
                                            child: Text(
                                          item.displayName.isEmpty
                                              ? ""
                                              : '${item.displayName[0]}',
                                          style: GoogleFonts.inter(
                                              fontSize: 30,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                        ))),
                                  ),
                                )),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.02),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${item.displayName}",
                                          style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                          (item.phones.isNotEmpty)
                                              ? "${item.phones.first.number}"
                                              : "No Phone Number",
                                          style: GoogleFonts.inter(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: SvgPicture.asset(
                                        'assets/images/plus-circle.svg'),
                                  ),
                                )),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: (searchResult.isEmpty)
                          ? contactList.length
                          : searchResult.length,
                    )
                  : Container(
                      child: Center(
                        child: Text("No Contact(s) Found"),
                      ),
                    ),
            ),
            // SizedBox(height: MediaQuery.of(context).size.height * 0.02),

            // SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          ],
        ),
      );
    });
  }

  Widget buildSelectTeam(BuildContext context) {
    print("contact on phone ${contactList.length}");
    return Obx(() {
      return Container(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.04,
            right: MediaQuery.of(context).size.width * 0.04,
            bottom: MediaQuery.of(context).size.width * 0.04,
            top: MediaQuery.of(context).size.width * 0.02),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 6,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(4)),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),

            TextField(
              onChanged: searchItem,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w400,
                color: AppColors.backgroundColor,
              ),
              // controller: _searchcontroller,
              cursorColor: Colors.white,
              autofocus: false,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.backgroundColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: BorderSide(color: Colors.black12),
                ),
                fillColor: Colors.white,
                filled: true,
                hintText: 'Search Customers',
                hintStyle: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
                contentPadding:
                    EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    width: 2,
                    color: AppColors.backgroundColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    width: 2,
                    color: AppColors.backgroundColor,
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),
            Expanded(
              child: (searchtext.isEmpty || searchResult.isNotEmpty)
                  ? ListView.separated(
                      separatorBuilder: (context, index) => Divider(),
                      itemBuilder: (context, index) {
                        var item = (searchResult.isEmpty)
                            ? contactList[index]
                            : searchResult[index];
                        return Visibility(
                          visible: item.phones.isNotEmpty,
                          child: GestureDetector(
                            onTap: () {
                              Get.back();
                              nameController.text = item.displayName;
                              phoneNumberController.text =
                                  item.phones.first.number;
                              if (item.emails.isNotEmpty)
                                emailController.text =
                                    item.emails.first.address;
                              //  Navigator.pop(context);
                            },
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: _randomColor.randomColor()),
                                        child: Center(
                                            child: Text(
                                          item.displayName.isEmpty
                                              ? ""
                                              : '${item.displayName[0]}',
                                          style: GoogleFonts.inter(
                                              fontSize: 30,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                        ))),
                                  ),
                                )),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.02),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${item.displayName}",
                                          style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                          (item.phones.isNotEmpty)
                                              ? "${item.phones.first.number}"
                                              : "No Phone Number",
                                          style: GoogleFonts.inter(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Column(children: [
                                      SvgPicture.asset(
                                          'assets/images/plus-circle.svg'),
                                      Text(
                                        'Invite',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: AppColors.backgroundColor,
                                        ),
                                      )
                                    ]),
                                  ),
                                )),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: (searchResult.isEmpty)
                          ? contactList.length
                          : searchResult.length,
                    )
                  : Container(
                      child: Center(
                        child: Text("No Contact(s) Found"),
                      ),
                    ),
            ),
            // SizedBox(height: MediaQuery.of(context).size.height * 0.02),

            // SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          ],
        ),
      );
    });
  }
}
