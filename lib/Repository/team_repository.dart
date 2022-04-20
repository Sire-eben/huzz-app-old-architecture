import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:huzz/Repository/auth_respository.dart';
import 'package:huzz/Repository/business_respository.dart';
import 'package:huzz/api_link.dart';
import 'package:huzz/app/screens/customers/confirmation.dart';
import 'package:huzz/model/team.dart';
import 'package:huzz/sqlite/sqlite_db.dart';
import 'package:uuid/uuid.dart';

enum AddingTeamStatus { Loading, Error, Success, Empty }
enum TeamStatus { Loading, Available, Error, Empty }

class TeamRepository extends GetxController {
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final amountController = TextEditingController();
  final totalAmountController = TextEditingController();
  final emailController = TextEditingController();
  final _userController = Get.find<AuthRepository>();
  final _businessController = Get.find<BusinessRespository>();
  var uuid = Uuid();

  final _addingTeamMemberStatus = AddingTeamStatus.Empty.obs;
  final _teamStatus = TeamStatus.Empty.obs;

  Rx<List<Teams>> _onlineBusinessTeam = Rx([]);
  Rx<List<Teams>> _offlineBusinessTeam = Rx([]);
  Rx<List<Teams>> _deleteTeamMemberList = Rx([]);
  Rx<List<Teams>> _team = Rx([]);

  List<Teams> get offlineBusinessTeam => _offlineBusinessTeam.value;
  List<Teams> get onlineBusinessTeam => _onlineBusinessTeam.value;
  List<Teams> pendingBusinessTeam = [];
  AddingTeamStatus get addingTeamMemberStatus => _addingTeamMemberStatus.value;
  List<Teams> get deleteTeamMemberList => _deleteTeamMemberList.value;
  List<Teams> get team => _team.value;
  TeamStatus get teamStatus => _teamStatus.value;

  List<Teams> pendingTeamMember = [];
  List<Teams> pendingUpdatedTeamMember = [];
  List<Contact> contactList = [];

  SqliteDb sqliteDb = SqliteDb();
  List<Teams> pendingTeamMemberToBeAdded = [];
  List<Teams> pendingTeamMemberToBeUpdated = [];
  List<Teams> pendingTeamMemberToBeDelete = [];

  @override
  void onInit() {
    _userController.Mtoken.listen((p0) {
      if (p0.isNotEmpty || p0 != "0") {
        final value = _businessController.selectedBusiness.value;
        if (value != null && value.businessId != null) {
          // getOnlineTeam(value.businessId);
          // getOnlineCustomer(value.businessId!);
          // getOfflineCustomer(value.businessId!);
        }
        _businessController.selectedBusiness.listen((p0) {
          if (p0 != null && p0.businessId != null) {
            print("business id ${p0.businessId}");
            // _offlineBusinessCustomer([]);

            // _onlineBusinessCustomer([]);
            // _customerCustomer([]);
            // _customerMerchant([]);
            // getOnlineCustomer(p0.businessId!);
            // getOfflineCustomer(p0.businessId!);
          }
        });
      }
    });

    _userController.MonlineStatus.listen((po) {
      if (po == OnlineStatus.Onilne) {
        _businessController.selectedBusiness.listen((p0) {
          // checkPendingCustomerToBeAddedToSever();
          // checkPendingCustomerToBeDeletedOnServer();
          // checkPendingCustomerTobeUpdatedToServer();
          //update server with pending job
        });
      }
    });

    // getPhoneContact();
    Future addTeamOnline(String businessId) async {
      try {
        _teamStatus(TeamStatus.Loading);
        print("trying to get team members online");
        var response = await http.post(
            Uri.parse(ApiLink.getTeamMember + '/$businessId'),
            headers: {"Authorization": "Bearer ${_userController.token}"});

        print("result of get teams online ${response.body}");
        if (response.statusCode == 200) {
          var json = jsonDecode(response.body);
          if (json['success']) {
            var result = List.from(json['data']['content'])
                .map((e) => Teams.fromJson(e))
                .toList();

            _onlineBusinessTeam(result);
            result.isNotEmpty
                ? _teamStatus(TeamStatus.Available)
                : _teamStatus(TeamStatus.Empty);
            print("Teams member length ${result.length}");
            // await getBusinessCustomerYetToBeSavedLocally();
            // checkIfUpdateAvailable();
          }
        } else {}
      } catch (error) {
        _teamStatus(TeamStatus.Error);
        print('add team feature error ${error.toString()}');
      }
    }

    Future updateTeamOnline(Teams team) async {
      try {
        _addingTeamMemberStatus(AddingTeamStatus.Loading);

        var response = await http
            .put(Uri.parse(ApiLink.updateInviteTeamStatus + "/" + team.teamId!),
                body: jsonEncode({
                  "teamMemberStatus": emailController.text,
                  "phoneNumber": phoneNumberController.text,
                  "teamId": nameController.text,
                }),
                headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer ${_userController.token}"
            });

        print("update team response ${response.body}");
        if (response.statusCode == 200) {
          _addingTeamMemberStatus(AddingTeamStatus.Success);
          // getOnlineTeam(
          //     _businessController.selectedBusiness.value!.businessId!);

          Get.to(ConfirmationCustomer(
            text: "Updated",
          ));
          // clearValue();
        } else {
          _addingTeamMemberStatus(AddingTeamStatus.Error);
          Get.snackbar("Error", "Unable to update team");
        }
      } catch (ex) {
        _addingTeamMemberStatus(AddingTeamStatus.Error);
      }
    }

    Future updateTeamOffline(Teams teams) async {
      // team.isUpdatingPending = true;
      // customer.updatedTime = DateTime.now();

      // await _businessController.sqliteDb.updateOfflineCustomer(customer);
      Get.to(ConfirmationCustomer(
        text: "Updated",
      ));
      // getOfflineTeam(customer.businessId!);
    }

    Future getOfflineTeam(String businessId) async {
      try {
        _teamStatus(TeamStatus.Loading);
        var result =
            await _businessController.sqliteDb.getOfflineCustomers(businessId);
        var list = result.where((c) => c.deleted == false).toList();
        // _offlineBusinessTeam(list);
        print("offline team found ${result.length}");
        list.isNotEmpty
            ? _teamStatus(TeamStatus.Available)
            : _teamStatus(TeamStatus.Empty);
      } catch (error) {
        _teamStatus(TeamStatus.Error);
        print(error.toString());
      }
    }

    Future getOnlineTeam(String businessId) async {
      try {
        _teamStatus(TeamStatus.Loading);
        print("trying to get team members online");
        var response = await http.post(
            Uri.parse(ApiLink.getTeamMember + '/$businessId'),
            headers: {"Authorization": "Bearer ${_userController.token}"});

        print("result of get teams online ${response.body}");
        if (response.statusCode == 200) {
          var json = jsonDecode(response.body);
          if (json['success']) {
            var result = List.from(json['data']['content'])
                .map((e) => Teams.fromJson(e))
                .toList();

            _onlineBusinessTeam(result);
            result.isNotEmpty
                ? _teamStatus(TeamStatus.Available)
                : _teamStatus(TeamStatus.Empty);
            print("Teams member length ${result.length}");
            // await getBusinessTeamYetToBeSavedLocally();
            checkAvailableTeamToUpdate();
          }
        } else {}
      } catch (error) {
        _teamStatus(TeamStatus.Error);
        print('add team feature error ${error.toString()}');
      }
    }

    Future getBusinessTeamYetToBeSavedLocally() async {
      onlineBusinessTeam.forEach((element) {
        if (!checkAvailableTeam(element.id!)) {
          print("Does not contain value");

          pendingBusinessTeam.add(element);
        }
      });

      savePendingTeam();
    }
  }

  Future savePendingTeam() async {
    if (pendingBusinessTeam.isEmpty) {
      return;
    }
    var savenext = pendingBusinessTeam.first;
    // await _businessController.sqliteDb.insertProduct(savenext);
    pendingBusinessTeam.remove(savenext);
    if (pendingBusinessTeam.isNotEmpty) {
      savePendingTeam();
    }
    // getOfflineProduct(savenext.businessId!);
  }

  Future updatePendingTeam() async {
    try {
      if (pendingUpdatedTeamMember.isEmpty) {
        return;
      }
      var updatednext = pendingUpdatedTeamMember.first;
      // await _businessController.sqliteDb.updateOfflineCustomer(updatednext);
      pendingUpdatedTeamMember.remove(updatednext);
      if (pendingUpdatedTeamMember.isNotEmpty) {
        updatePendingTeam();
      }
      // getOfflineCustomer(updatednext.businessId!);
    } catch (error) {
      print(error.toString());
    }
  }

  bool checkAvailableTeam(String id) {
    bool result = false;
    offlineBusinessTeam.forEach((element) {
      print("checking whether team exist");
      if (element.id == id) {
        print("Team found");
        result = true;
      }
    });
    return result;
  }

  Future checkAvailableTeamToUpdate() async {
    onlineBusinessTeam.forEach((element) async {
      var item = checkAvailableTeamWithValue(element.id!);
      if (item != null) {
        print("item team is found");
        print("updated offline ${item.updatedDateTime!.toIso8601String()}");
        print("updated online ${element.updatedDateTime!.toIso8601String()}");
        if (!element.updatedDateTime!.isAtSameMomentAs(item.updatedDateTime!)) {
          print("found team to be updated");
          pendingUpdatedTeamMember.add(element);
        }
      }
    });

    updatePendingTeam();
  }

  Teams? checkAvailableTeamWithValue(String id) {
    Teams? item;

    offlineBusinessTeam.forEach((element) {
      print("checking whether team member exist");
      if (element.id == id) {
        print("Team found");
        item = element;
      }
    });
    return item;
  }
}
