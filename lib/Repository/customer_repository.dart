import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/auth_respository.dart';
import 'package:huzz/Repository/business_respository.dart';
import 'package:http/http.dart' as http;
import 'package:huzz/Repository/file_upload_respository.dart';
import 'package:huzz/api_link.dart';
import 'package:huzz/app/screens/inventory/Product/productConfirm.dart';
import 'package:huzz/colors.dart';
import 'package:huzz/model/customer_model.dart';
import 'package:huzz/sqlite/sqlite_db.dart';
import 'package:random_color/random_color.dart';

enum AddingCustomerStatus { Loading, Error, Success, Empty }

class CustomerRepository extends GetxController {
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final _businessController = Get.find<BusinessRespository>();
  final _userController = Get.find<AuthRepository>();
  final _addingCustomerStatus = AddingCustomerStatus.Empty.obs;

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
  List<Customer> get customerCustomer => _customerCustomer.value;
  List<Customer> get customerMerchant => _customerMerchant.value;
  List<Contact> contactList = [];
  Rx<File?> CustomerImage = Rx(null);
  final _uploadFileController = Get.find<FileUploadRespository>();
  SqliteDb sqliteDb = SqliteDb();
  RandomColor _randomColor = RandomColor();
  @override
  void onInit() {
    // TODO: implement onInit
    _userController.Mtoken.listen((p0) {
      if (p0.isNotEmpty || p0 != "0") {
        final value = _businessController.selectedBusiness.value;
        if (value != null) {
          getOnlineCustomer(value.businessId!);
          getOfflineCustomer(value.businessId!);
        }
        _businessController.selectedBusiness.listen((p0) {
          if (p0 != null) {
            print("business id ${p0.businessId}");
            _offlineBusinessCustomer([]);

            _onlineBusinessCustomer([]);
            _customerCustomer([]);
            _customerMerchant([]);
            getOnlineCustomer(p0.businessId!);
            getOfflineCustomer(p0.businessId!);
          }
        });
      }
    });
    getPhoneContact();
  }

  Future getPhoneContact() async {
    print("trying phone contact list");
    if (await FlutterContacts.requestPermission()) {
      contactList = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      print("phone contact ${contactList.length}");
    }
  }

  Future addBusinessCustomer(String transactionType) async {
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

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        if (json['success']) {
          _addingCustomerStatus(AddingCustomerStatus.Success);
          getOnlineCustomer(
              _businessController.selectedBusiness.value!.businessId!);
          clearValue();
          Get.to(Confirmation(
            text: "Added",
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
      _addingCustomerStatus(AddingCustomerStatus.Error);
      Get.snackbar("Error", "Unknown error occurred.. try again");
    }
  }

Future<String?> addBusinessCustomerWithString(String transactionType) async {
    try {
    
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

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        if (json['success']) {
         
          getOnlineCustomer(
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

  Future updateCustomer(Customer customer) async {
    try {
      _addingCustomerStatus(AddingCustomerStatus.Loading);
      String? fileId = null;

      if (CustomerImage.value != null) {
        fileId =
            await _uploadFileController.uploadFile(CustomerImage.value!.path);
      }
      var response = await http
          .put(Uri.parse(ApiLink.add_customer + "/" + customer.customerId!),
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

        Get.to(Confirmation(
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

  Future getOfflineCustomer(String businessId) async {
    var result =
        await _businessController.sqliteDb.getOfflineCustomers(businessId);
    _offlineBusinessCustomer(result);
    print("offline Customer found ${result.length}");
    setCustomerDifferent();
  }

  Future getOnlineCustomer(String businessId) async {
    print("trying to get Customer online");
    final response = await http.get(
        Uri.parse(ApiLink.get_business_customer + "?businessId=" + businessId),
        headers: {"Authorization": "Bearer ${_userController.token}"});

    print("result of get Customer online ${response.body}");
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      if (json['success']) {
        var result = List.from(json['data']['content'])
            .map((e) => Customer.fromJson(e))
            .toList();
        _onlineBusinessCustomer(result);
        print("Customer business lenght ${result.length}");
        await getBusinessCustomerYetToBeSavedLocally();
        checkIfUpdateAvailable();
      }
    } else {}
  }

  Future getBusinessCustomerYetToBeSavedLocally() async {
    onlineBusinessCustomer.forEach((element) {
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
  }

  Future updatePendingJob() async {
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
      print("checking transaction whether exist");
      if (element.customerId == id) {
        print("Customer   found");
        item = element;
      }
    });
    return item;
  }

  Future deleteCustomer(Customer customer) async {
    var response = await http.delete(
        Uri.parse(ApiLink.add_customer +
            "/${customer.customerId}?businessId=${customer.businessId}"),
        headers: {"Authorization": "Bearer ${_userController.token}"});
    print("delete response ${response.body}");
    if (response.statusCode == 200) {
      _businessController.sqliteDb.deleteCustomer(customer);
      getOfflineCustomer(
          _businessController.selectedBusiness.value!.businessId!);
    } else {}
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

  Future deleteSelectedItem() async {
    if (deleteCustomerList.isEmpty) {
      return;
    }
    var deletenext = deleteCustomerList.first;
    await deleteCustomer(deletenext);
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
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: context,
        builder: (context) => buildSelectContact(context));
  }

  Widget buildSelectContact(BuildContext context) => Container(
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
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: AppColor().backgroundColor,
                  fontFamily: 'DMSans'),
              // controller: _searchcontroller,
              cursorColor: Colors.white,
              autofocus: false,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColor().backgroundColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: BorderSide(color: Colors.black12),
                ),
                fillColor: Colors.white,
                filled: true,
                hintText: 'Search Customers',
                hintStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                    fontFamily: 'DMSans'),
                contentPadding:
                    EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    width: 2,
                    color: AppColor().backgroundColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    width: 2,
                    color: AppColor().backgroundColor,
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),
            Expanded(
              // width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  var item = contactList[index];
                  return GestureDetector(
                    onTap: () {
                      nameController.text = item.displayName;
                      phoneNumberController.text = item.phones.first.number;
                      emailController.text = item.emails.first.address;
                      Get.back();
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
                                  '${item.displayName[0]}',
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.white,
                                      fontFamily: 'DMSans',
                                      fontWeight: FontWeight.bold),
                                ))),
                          ),
                        )),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02),
                        Expanded(
                          flex: 3,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${item.displayName}",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'DMSans',
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  "${item.phones.first.number}",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'DMSans',
                                      color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                itemCount: contactList.length,
              ),
            ),
            // SizedBox(height: MediaQuery.of(context).size.height * 0.02),

            // SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          ],
        ),
      );
}