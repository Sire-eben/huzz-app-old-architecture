import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/auth_respository.dart';
import 'package:huzz/Repository/business_respository.dart';
import 'package:huzz/Repository/file_upload_respository.dart';
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
  Rx<List<Team>> _onlineTeamMember = Rx([]);
  Rx<List<Team>> _offlineTeamMember = Rx([]);
  Rx<List<Team>> _deleteTeamMemberList = Rx([]);
  Rx<List<Team>> _team = Rx([]);

  List<Team> get offlineTeamMember => _offlineTeamMember.value;
  List<Team> get onlineTeamMember => _onlineTeamMember.value;
  AddingTeamStatus get addingTeamMemberStatus => _addingTeamMemberStatus.value;
  List<Team> get deleteTeamMemberList => _deleteTeamMemberList.value;
  List<Team> get team => _team.value;
  TeamStatus get teamStatus => _teamStatus.value;

  List<Team> pendingTeamMember = [];
  List<Team> pendingUpdatedTeamMember = [];

  List<Contact> contactList = [];

  Rx<File?> CustomerImage = Rx(null);
  final _uploadFileController = Get.find<FileUploadRespository>();
  SqliteDb sqliteDb = SqliteDb();
  List<Team> pendingTeamMemberToBeAdded = [];
  List<Team> pendingTeamMemberToBeUpdated = [];
  List<Team> pendingTeamMemberToBeDelete = [];

  @override
  void onInit() {
    _userController.Mtoken.listen((p0) {
      if (p0.isNotEmpty || p0 != "0") {
        final value = _businessController.selectedBusiness.value;
        if (value != null && value.businessId != null) {
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
  }
}
