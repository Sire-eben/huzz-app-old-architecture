import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:huzz/data/repository/auth_respository.dart';
import 'package:huzz/data/repository/business_respository.dart';
import 'package:huzz/data/api_link.dart';
import 'package:huzz/ui/team/team_updated_confirmation.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/data/model/team.dart';
import 'package:huzz/data/sqlite/sqlite_db.dart';
import 'package:random_color/random_color.dart';
import 'package:uuid/uuid.dart';
import '../../ui/team/confirmation.dart';

enum AddingTeamStatus { Loading, Error, Success, Empty }

enum UpdateTeamStatus { Loading, Error, Success, Empty }

enum TeamMemberStatus { Loading, Error, UnAuthorized, Success, Empty }

enum DeleteTeamStatus { Loading, Error, Success, Empty }

enum TeamStatus { Loading, Available, Error, Empty, UnAuthorized }

class TeamRepository extends GetxController {
  RandomColor _randomColor = RandomColor();
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final amountController = TextEditingController();
  final totalAmountController = TextEditingController();
  final emailController = TextEditingController();
  final _userController = Get.find<AuthRepository>();
  final _businessController = Get.find<BusinessRespository>();
  var uuid = Uuid();

  final _addingTeamMemberStatus = AddingTeamStatus.Empty.obs;
  final _deleteTeamMemberStatus = DeleteTeamStatus.Empty.obs;
  final _updatingTeamMemberStatus = UpdateTeamStatus.Empty.obs;
  final _teamStatus = TeamStatus.Empty.obs;
  final teamMembersStatus = TeamMemberStatus.Empty.obs;
  final hasTeamInviteDeeplink = false.obs;

  final teamMemberData = Rx(Teams());
  Teams get teamMember => teamMemberData.value;

  Rx<List<Teams>> _onlineBusinessTeam = Rx([]);
  Rx<List<Teams>> _offlineBusinessTeam = Rx([]);
  Rx<List<Teams>> _deleteTeamMemberList = Rx([]);
  Rx<List<Teams>> _team = Rx([]);

  List<Teams> get offlineBusinessTeam => _offlineBusinessTeam.value;
  List<Teams> get onlineBusinessTeam => _onlineBusinessTeam.value;
  List<Teams> pendingBusinessTeam = [];
  AddingTeamStatus get addingTeamMemberStatus => _addingTeamMemberStatus.value;
  DeleteTeamStatus get deleteTeamMemberStatus => _deleteTeamMemberStatus.value;
  UpdateTeamStatus get updatingTeamMemberStatus =>
      _updatingTeamMemberStatus.value;
  List<Teams> get deleteTeamMemberList => _deleteTeamMemberList.value;
  List<Teams> get team => _team.value;
  TeamStatus get teamStatus => _teamStatus.value;
  TeamMemberStatus get teamMemberStatus => teamMembersStatus.value;

  List<Teams> pendingTeamMember = [];
  List<Teams> pendingUpdatedTeamMember = [];
  List<Contact> contactList = [];

  SqliteDb sqliteDb = SqliteDb();
  List<Teams> pendingTeamMemberToBeAdded = [];
  List<Teams> pendingTeamMemberToBeUpdated = [];
  List<Teams> pendingTeamMemberToBeDelete = [];

  String countryText = "234";
  String countryCodeFLag = "NG";

  @override
  void onInit() {
    _userController.Mtoken.listen((p0) {
      if (p0.isNotEmpty || p0 != "0") {
        final value = _businessController.selectedBusiness.value;
        if (value != null && value.teamId != null) {
          getOnlineTeam(value.teamId!);
          getOnlineTeamMember(value.teamId);
          // getOfflineTeam(value.teamId!);
        }
        _businessController.selectedBusiness.listen((p0) {
          if (p0 != null && p0.teamId != null) {
            print("team id ${p0.teamId}");
            // _offlineBusinessTeam([]);
            _onlineBusinessTeam([]);
            _team([]);
            getOnlineTeam(p0.teamId!);
            getOnlineTeamMember(p0.teamId!);
            // getOfflineTeam(p0.teamId!);
          }
        });
      }
    });

    _userController.MonlineStatus.listen((po) {
      if (po == OnlineStatus.Onilne) {
        _businessController.selectedBusiness.listen((p0) {
          getOnlineTeamMember(p0!.teamId);
          // checkPendingCustomerToBeAddedToSever();
          // checkPendingCustomerToBeDeletedOnServer();
          // checkPendingCustomerTobeUpdatedToServer();
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

  Future showContactPickerForTeams(BuildContext context) async {
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
              height: Get.width - 50,
              child: buildSelectTeam(context),
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
                //
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
                  //
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
                                              // ,
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
                                              // ,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                          (item.phones.isNotEmpty)
                                              ? "${item.phones.first.number}"
                                              : "No Phone Number",
                                          style: GoogleFonts.inter(
                                              fontSize: 12,
                                              // ,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
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
                              if (item.phones.first.number.length == 11) {
                                var no = item.phones.first.number
                                    .replaceFirst('0', '');
                                print('contact selected $no');
                                phoneNumberController.text = no;
                              } else {
                                var no = item.phones.first.number
                                    .replaceAll('+', '')
                                    .replaceAll('234', '')
                                    .replaceAll('+234', '')
                                    .replaceAll(' ', '')
                                    .replaceAll('-', '')
                                    .replaceAll('(', '')
                                    .replaceAll(')', '');
                                print('contact selected $no');
                                phoneNumberController.text = no;
                              }
                              nameController.text = item.displayName;
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
                                              // ,
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
                                              // ,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                          (item.phones.isNotEmpty)
                                              ? "${item.phones.first.number}"
                                              : "No Phone Number",
                                          style: GoogleFonts.inter(
                                              fontSize: 12,
                                              // ,
                                              color: Colors.grey),
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
          ],
        ),
      );
    });
  }

  Future createTeam(String businessId) async {
    try {
      _addingTeamMemberStatus(AddingTeamStatus.Loading);
      print("trying to create team feature");
      var response = await http.post(
          Uri.parse(ApiLink.createTeam + '$businessId'),
          headers: {"Authorization": "Bearer ${_userController.token}"});

      // print("result of create team ${response.body}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("result of create team ${response.body}");
        var json = jsonDecode(response.body);

        _businessController.OnlineBusiness();
        _businessController.updateBusiness(
            _businessController.selectedBusiness.value!.businessCurrency!);

        var value = _businessController.selectedBusiness.value;
        print(value!.teamId);
        getOfflineTeam(value.teamId!);
        Get.snackbar(
          "Success",
          "Team created successfully",
        );

        _addingTeamMemberStatus(AddingTeamStatus.Success);
      } else {
        Get.snackbar("Error", "Error creating team, try again!");
        _addingTeamMemberStatus(AddingTeamStatus.Error);
      }
    } catch (error) {
      _addingTeamMemberStatus(AddingTeamStatus.Error);
      print('creating team feature error ${error.toString()}');
    }
  }

  Future inviteTeamMember(String businessId, Map<String, dynamic> item) async {
    if (_userController.onlineStatus == OnlineStatus.Onilne) {
      inviteTeamMemberOnline(businessId, item);
    }
  }

  Future inviteTeamMemberOnline(
      String? businessId, Map<String, dynamic> item) async {
    try {
      print('Team Member Phone: ${item['phoneNumber']}');
      print('Team Member TeamId: ${item['teamId']}');
      print('Team Member Email: ${item['email']}');
      print('Team Member Invite Link: ${item['teamInviteUrl']}');
      _addingTeamMemberStatus(AddingTeamStatus.Loading);
      var value = _businessController.selectedBusiness.value;
      print("trying to invite team members: ${jsonEncode(item)}");
      var response = await http.post(
          Uri.parse(ApiLink.inviteTeamMember + '/${value!.businessId}'),
          body: json.encode(item),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${_userController.token}"
          });

      print("result of invite team member online: ${response.body}");
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);

        Get.back();
        if (json['success']) {
          Get.snackbar('Success', json['message']);
          _addingTeamMemberStatus(AddingTeamStatus.Success);
          print(value.teamId);
          // getOnlineTeam(value.teamId!);
          var teamMemberId = json['data']['id'];
          print('Added Member MemberId: ${json['data']['id']}');
          updateTeamInviteStatusOnline(teamMemberId, item);
          clearValue();

          print('invite sent successfully');
          // await getBusinessCustomerYetToBeSavedLocally();
          // checkIfUpdateAvailable();
        }
      } else {
        var json = jsonDecode(response.body);
        Get.snackbar('Error', json['message']);
        _addingTeamMemberStatus(AddingTeamStatus.Error);
      }
    } catch (error) {
      _addingTeamMemberStatus(AddingTeamStatus.Error);
      Get.snackbar("Error", "Error inviting team, try again!");
      print('add team feature error ${error.toString()}');
    }
  }

  Future updateTeamMember(String? id, Map<String, dynamic> item) async {
    try {
      print('Team Member TeamId: ${item['teamId']}');
      print('Team Member Id: $id');

      _updatingTeamMemberStatus(UpdateTeamStatus.Loading);
      var value = _businessController.selectedBusiness.value;
      print("trying to update team members: ${jsonEncode(item)}");
      var response = await http.put(
          Uri.parse(ApiLink.updateInviteTeamStatus + '/$id'),
          body: json.encode(item),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${_userController.token}"
          });

      print("result of update team member: ${response.body}");
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);

        Get.back();
        if (json['success']) {
          Get.snackbar('Success', json['message']);
          _updatingTeamMemberStatus(UpdateTeamStatus.Success);
          print(value!.teamId);
          getOnlineTeam(value.teamId!);
          getOnlineTeamMember(value.teamId!);

          clearValue();
          print('team member updated successfully');
          Get.to(TeamMemberConfirmation());
        }
      } else {
        var json = jsonDecode(response.body);
        Get.snackbar('Error', json['message']);
        _updatingTeamMemberStatus(UpdateTeamStatus.Error);
      }
    } catch (error) {
      _updatingTeamMemberStatus(UpdateTeamStatus.Error);
      Get.snackbar("Error", "Error updating team member, try again!");
      print('update team member error ${error.toString()}');
    }
  }

  Future updateTeamInviteStatusOnline(
      String teamMemberId, Map<String, dynamic> item) async {
    try {
      _addingTeamMemberStatus(AddingTeamStatus.Loading);
      var value = _businessController.selectedBusiness.value;

      var response = await http
          .put(Uri.parse(ApiLink.updateInviteTeamStatus + '/$teamMemberId'),
              body: jsonEncode({
                "teamMemberStatus": 'ACCEPTED',
                "phoneNumber": item['phoneNumber'],
                "teamId": item['teamId'],
              }),
              headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${_userController.token}"
          });

      print("update team response ${response.body}");
      if (response.statusCode == 200) {
        _addingTeamMemberStatus(AddingTeamStatus.Success);
        getOnlineTeam(value!.teamId!);
        getOnlineTeamMember(value.teamId!);

        Get.to(TeamConfirmation());
      } else {
        _addingTeamMemberStatus(AddingTeamStatus.Error);
        Get.snackbar("Error", "Unable to update team");
      }
    } catch (ex) {
      Get.snackbar("Error", "Error updating team, try again!");
      _addingTeamMemberStatus(AddingTeamStatus.Error);
    }
  }

  Future updateTeamOffline(Teams teams) async {
    // team.isUpdatingPending = true;
    // customer.updatedTime = DateTime.now();

    // await _businessController.sqliteDb.updateOfflineCustomer(customer);
    // Get.to(ConfirmationCustomer(
    //   text: "Updated",
    // ));
    // getOfflineTeam(customer.businessId!);
  }

  Future getOfflineTeam(String businessId) async {
    // try {
    //   _teamStatus(TeamStatus.Loading);
    //   var result =
    //       await _businessController.sqliteDb.getOfflineTeams(businessId);
    //   var list = result.where((c) => c.deleted == false).toList();
    //   _offlineBusinessTeam(list);
    //   print("offline team found ${result.length}");
    //   list.isNotEmpty
    //       ? _teamStatus(TeamStatus.Available)
    //       : _teamStatus(TeamStatus.Empty);
    // } catch (error) {
    //   _teamStatus(TeamStatus.Error);
    //   print(error.toString());
    // }
  }

  Future getOnlineTeam(String? businessId) async {
    try {
      _teamStatus(TeamStatus.Loading);
      print("trying to get team members online");
      var response = await http.get(
          Uri.parse(ApiLink.getTeamMember + '/$businessId'),
          headers: {"Authorization": "Bearer ${_userController.token}"});

      print("result of get teams online ${response.body}");
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        if (json['success']) {
          print('here 1');
          var result =
              List.from(json['data']).map((e) => Teams.fromJson(e)).toList();
          print('here 2');
          _onlineBusinessTeam(result);
          result.isNotEmpty
              ? _teamStatus(TeamStatus.Available)
              : _teamStatus(TeamStatus.Empty);
          print("Teams member length ${result.length}");
          // await getBusinessTeamYetToBeSavedLocally();
          // checkAvailableTeamToUpdate();
        }
      } else if (response.statusCode == 500) {
        _teamStatus(TeamStatus.UnAuthorized);
      } else {
        _teamStatus(TeamStatus.Error);
      }
    } catch (error) {
      _teamStatus(TeamStatus.Error);
      print('add team feature error ${error.toString()}');
    }
  }

  Future getOnlineTeamMember(String? businessId) async {
    try {
      teamMembersStatus(TeamMemberStatus.Loading);
      print("trying to get team member data online");
      var response = await http.get(
          Uri.parse(ApiLink.getTeamMemberData +
              '/$businessId' +
              '/${_userController.user!.phoneNumber}'),
          headers: {"Authorization": "Bearer ${_userController.token}"});

      print("result of get team member data ${response.body}");
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        teamMembersStatus(TeamMemberStatus.Success);
        if (json['success']) {
          var teamMember = Teams.fromJson(json['data']);
          teamMemberData(teamMember);
        }
      } else if (response.statusCode == 500) {
        print("result of get team member error data ${response.body}");
        teamMembersStatus(TeamMemberStatus.UnAuthorized);
      }
    } catch (error) {
      teamMembersStatus(TeamMemberStatus.Error);
      print('team member data error ${error.toString()}');
    }
  }

  Future getBusinessTeamYetToBeSavedLocally() async {
    onlineBusinessTeam.forEach((element) {
      if (!checkAvailableTeam(element.teamId!)) {
        print("Does not contain value");

        pendingBusinessTeam.add(element);
      }
    });

    savePendingTeam();
  }

  Future savePendingTeam() async {
    if (pendingBusinessTeam.isEmpty) {
      return;
    }
    var savenext = pendingBusinessTeam.first;
    // await _businessController.sqliteDb.insertTeam(savenext);
    pendingBusinessTeam.remove(savenext);
    if (pendingBusinessTeam.isNotEmpty) {
      savePendingTeam();
    }
    getOfflineTeam(savenext.teamId!);
  }

  Future updatePendingTeam() async {
    try {
      if (pendingUpdatedTeamMember.isEmpty) {
        return;
      }
      var updatednext = pendingUpdatedTeamMember.first;
      // await _businessController.sqliteDb.updateOfflineTeam(updatednext);
      pendingUpdatedTeamMember.remove(updatednext);
      if (pendingUpdatedTeamMember.isNotEmpty) {
        updatePendingTeam();
      }
      getOfflineTeam(updatednext.teamId!);
    } catch (error) {
      print(error.toString());
    }
  }

  bool checkAvailableTeam(String id) {
    bool result = false;
    offlineBusinessTeam.forEach((element) {
      print("checking whether team exist");
      if (element.teamId == id) {
        print("Team found");
        result = true;
      }
    });
    return result;
  }

  Future checkAvailableTeamToUpdate() async {
    onlineBusinessTeam.forEach((element) async {
      var item = checkAvailableTeamWithValue(element.teamId!);
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
      if (element.teamId == id) {
        print("Team found");
        item = element;
      }
    });
    return item;
  }

  Future deleteTeamMember(Teams item) async {
    print('deleting team member...');
    if (_userController.onlineStatus == OnlineStatus.Onilne) {
      await deleteTeamMemberOnline(item);
      // await getOnlineTeam(
      //     _businessController.selectedBusiness.value!.businessId!);
    }
    await deleteTeamMemberOffline(item);
    // getOfflineDebtor(_businessController.selectedBusiness.value!.businessId!);
  }

  Future deleteTeamMemberOnline(Teams teams) async {
    try {
      print('deleting team member online...');
      _deleteTeamMemberStatus(DeleteTeamStatus.Loading);
      print(teams.teamId);
      var response = await http.delete(
          Uri.parse(ApiLink.deleteTeamMember + "/${teams.teamId}"),
          headers: {"Authorization": "Bearer ${_userController.token}"});

      print("delete response ${response.body}");
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Team member deleted successfully');
        _deleteTeamMemberStatus(DeleteTeamStatus.Success);
        getOnlineTeam(teams.businessId);
        getOnlineTeamMember(teams.businessId);
        // _businessController.sqliteDb.deleteCustomer(customer);
        // getOfflineCustomer(
        //     _businessController.selectedBusiness.value!.businessId!);
      } else {
        Get.snackbar('Error', 'Error deleting team member, try again!');
        _deleteTeamMemberStatus(DeleteTeamStatus.Success);
        getOnlineTeam(teams.businessId);
        getOnlineTeamMember(teams.businessId);
        // _businessController.sqliteDb.deleteCustomer(customer);
        // getOfflineCustomer(
        //     _businessController.selectedBusiness.value!.businessId!);
      }
    } catch (error) {
      _deleteTeamMemberStatus(DeleteTeamStatus.Error);
      print('delete online team member error: ' + error.toString());
    }
  }

  Future deleteTeamMemberOffline(Teams teams) async {
    // await http.delete(Uri.parse(ApiLink.deleteTeamMember + "${teams.teamId}"),
    //     headers: {"Authorization": "Bearer ${_userController.token}"});
  }

  void clearValue() {
    nameController.text = "";
    emailController.text = "";
    phoneNumberController.text = "";
  }
}
