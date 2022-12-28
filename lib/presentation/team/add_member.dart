import 'dart:convert';
import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/data/repository/business_respository.dart';
import 'package:huzz/data/repository/team_repository.dart';
import 'package:huzz/presentation/widget/expandable_widget.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/data/model/roles_model.dart';
import '../../data/repository/auth_respository.dart';
import '../../model/user_teamInvite_model.dart';
import '../widget/custom_form_field.dart';

class InformationDialog extends StatelessWidget {
  final String? title;

  const InformationDialog({super.key, this.title});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.info_outline_rounded,
          size: 27,
        ),
        SizedBox(height: 7),
        Text(
          "Manage member authorization for your business team",
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class AddMember extends StatefulWidget {
  AddMember({Key? key}) : super(key: key);

  @override
  State<AddMember> createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  List _authoritySet = [];
  List _roleSet = [];
  List _selectedIndex = [];
  List _selectedViewIndex = [];
  List _selectedCreateIndex = [];
  List _selectedUpdateIndex = [];
  List _selectedDeleteIndex = [];
  final controller = Get.find<AuthRepository>();
  final _teamController = Get.find<TeamRepository>();
  final _businessController = Get.find<BusinessRespository>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController updatePhoneNumberController =
      TextEditingController();
  String countryFlag = "NG";
  String countryCode = "234";

  final items = [
    'Owner',
    'Writer',
    'Admin',
  ];

  String? value, teamInviteLink;
  bool manageCustomer = false;
  bool view = false, create = false, update = false, delete = false;
  late Future<UserTeamInviteModel?> future;

  @override
  void initState() {
    controller.checkTeamInvite();

    super.initState();
    final value = _businessController.selectedBusiness.value!.businessId;
    // print('BusinessId: $value');
    final teamId = _businessController.selectedBusiness.value!.teamId;
    // print('Business TeamId: $teamId');
    shareBusinessIdLink(value.toString());
  }

  Future<void> shareBusinessIdLink(String businessId) async {
    if (controller.onlineStatus == OnlineStatus.Onilne) {
      try {
        final appId = "com.app.huzz";
        final url = "https://huzz.africa/businessId=$businessId";
        final DynamicLinkParameters parameters = DynamicLinkParameters(
          uriPrefix: 'https://huzz.page.link',
          link: Uri.parse(url),
          androidParameters: AndroidParameters(
            packageName: appId,
            minimumVersion: 1,
          ),
          iosParameters: IOSParameters(
            bundleId: appId,
            appStoreId: "1596574133",
            minimumVersion: '1',
          ),
        );
        final shortLink = await dynamicLinks.buildShortLink(parameters);
        teamInviteLink = shortLink.shortUrl.toString();
        // print('invite link: $teamInviteLink');
      } catch (error) {
        // print(error.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.backgroundColor,
          ),
          onPressed: () {
            _teamController.nameController.clear();
            _teamController.phoneNumberController.clear();
            _teamController.emailController.clear();
            Get.back();
          },
        ),
        title: Row(
          children: [
            Text(
              'Add Members',
              style: GoogleFonts.inter(
                color: AppColors.backgroundColor,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.whiteColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            CustomAddMemberTextField(
              contactName: _teamController.nameController,
              contactPhone: _teamController.phoneNumberController,
              contactMail: _teamController.emailController,
              label: "Member name",
              validatorText: "Member name is needed",
              hint: 'member name',
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'Privilege',
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(width: 5),
                  SvgPicture.asset(
                    "assets/images/info.svg",
                    height: 15,
                    width: 15,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: roleSet.length,
                itemBuilder: (context, index) {
                  RoleSet item = roleSet[index];
                  final _isSelected = _selectedIndex.contains(index);
                  final _isSelectedView = _selectedViewIndex.contains(index);
                  final _isSelectedCreate =
                      _selectedCreateIndex.contains(index);
                  final _isSelectedUpdate =
                      _selectedUpdateIndex.contains(index);
                  final _isSelectedDelete =
                      _selectedDeleteIndex.contains(index);
                  return ExpandableWidget(
                    info: () {
                      Platform.isIOS
                          ? showCupertinoDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) => CupertinoAlertDialog(
                                content: InformationDialog(),
                                actions: [
                                  CupertinoButton(
                                    child: Text("OK"),
                                    onPressed: () => Get.back(),
                                  ),
                                ],
                              ),
                            )
                          : showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: InformationDialog(),
                                actions: [
                                  CupertinoButton(
                                    child: Text("OK"),
                                    onPressed: () => Get.back(),
                                  ),
                                ],
                              ),
                            );
                    },
                    manageChild: InkWell(
                      onTap: () {
                        setState(() {
                          if (_isSelected) {
                            _selectedIndex.remove(index);
                            _selectedViewIndex.remove(index);
                            _selectedCreateIndex.remove(index);
                            _selectedUpdateIndex.remove(index);
                            _selectedDeleteIndex.remove(index);

                            if (_roleSet.contains(item.titleName) ||
                                _authoritySet.contains(item.authoritySet![1]) ||
                                _authoritySet.contains(item.authoritySet![2]) ||
                                _authoritySet.contains(item.authoritySet![3]) ||
                                _authoritySet.contains(item.authoritySet![4])) {
                              _roleSet.remove(item.titleName);
                              _authoritySet.remove(item.authoritySet![1]);
                              _authoritySet.remove(item.authoritySet![2]);
                              _authoritySet.remove(item.authoritySet![3]);
                              _authoritySet.remove(item.authoritySet![4]);

                              // print(index);
                              // print('RoleSet: ${_roleSet.toString()}');
                              // print('AuthoritySet: $_authoritySet');
                            }
                          } else {
                            _selectedIndex.add(index);
                            _roleSet.add(item.titleName);
                            _selectedViewIndex.add(index);
                            _authoritySet.add(item.authoritySet![1]);
                            _selectedCreateIndex.add(index);
                            _authoritySet.add(item.authoritySet![2]);
                            _selectedUpdateIndex.add(index);
                            _authoritySet.add(item.authoritySet![3]);
                            _selectedDeleteIndex.add(index);
                            _authoritySet.add(item.authoritySet![4]);

                            // print(index);
                            // print('RoleSet: $_roleSet');
                            // print('AuthoritySet: $_authoritySet');
                          }
                        });
                      },
                      child: _isSelected
                          ? Icon(
                              Icons.check_box,
                              color: AppColors.backgroundColor,
                            )
                          : Icon(
                              Icons.check_box_outline_blank,
                              color: AppColors.backgroundColor,
                            ),
                    ),
                    view: InkWell(
                      onTap: () {
                        setState(() {
                          if (_isSelectedView) {
                            _selectedViewIndex.remove(index);

                            if (_authoritySet.contains(item.authoritySet![1])) {
                              _authoritySet.remove(item.authoritySet![1]);

                              // print(index);
                              // print('RoleSet: $_roleSet');
                              // print('AuthoritySet: $_authoritySet');
                            }
                          } else {
                            _selectedViewIndex.add(index);
                            _authoritySet.add(item.authoritySet![1]);

                            // print(index);
                            // print('RoleSet: $_roleSet');
                            // print('AuthoritySet: $_authoritySet');
                          }
                        });
                      },
                      child: _isSelectedView
                          ? Icon(
                              Icons.check_box,
                              color: AppColors.blackColor,
                            )
                          : Icon(
                              Icons.check_box_outline_blank,
                              color: AppColors.blackColor,
                            ),
                    ),
                    create: InkWell(
                      onTap: () {
                        setState(() {
                          if (_isSelectedCreate) {
                            _selectedCreateIndex.remove(index);

                            if (_authoritySet.contains(item.authoritySet![2])) {
                              _authoritySet.remove(item.authoritySet![2]);

                              // print(index);
                              // print('RoleSet: $_roleSet');
                              // print('AuthoritySet: $_authoritySet');
                            }
                          } else {
                            _selectedCreateIndex.add(index);
                            _authoritySet.add(item.authoritySet![2]);

                            // print(index);
                            // print('RoleSet: $_roleSet');
                            // print('AuthoritySet: $_authoritySet');
                          }
                        });
                      },
                      child: _isSelectedCreate
                          ? Icon(
                              Icons.check_box,
                              color: AppColors.blackColor,
                            )
                          : Icon(
                              Icons.check_box_outline_blank,
                              color: AppColors.blackColor,
                            ),
                    ),
                    update: InkWell(
                      onTap: () {
                        setState(() {
                          if (_isSelectedUpdate) {
                            _selectedUpdateIndex.remove(index);

                            if (_authoritySet.contains(item.authoritySet![3])) {
                              _authoritySet.remove(item.authoritySet![3]);

                              // print(index);
                              // print('RoleSet: $_roleSet');
                              // print('AuthoritySet: $_authoritySet');
                            }
                          } else {
                            _selectedUpdateIndex.add(index);
                            _authoritySet.add(item.authoritySet![3]);

                            // print(index);
                            // print('RoleSet: $_roleSet');
                            // print('AuthoritySet: $_authoritySet');
                          }
                        });
                      },
                      child: _isSelectedUpdate
                          ? Icon(
                              Icons.check_box,
                              color: AppColors.blackColor,
                            )
                          : Icon(
                              Icons.check_box_outline_blank,
                              color: AppColors.blackColor,
                            ),
                    ),
                    delete: InkWell(
                      onTap: () {
                        setState(() {
                          if (_isSelectedDelete) {
                            _selectedDeleteIndex.remove(index);

                            if (_authoritySet.contains(item.authoritySet![4])) {
                              _authoritySet.remove(item.authoritySet![4]);

                              // print(index);
                              // print('RoleSet: $_roleSet');
                              // print('AuthoritySet: $_authoritySet');
                            }
                          } else {
                            _selectedDeleteIndex.add(index);
                            _authoritySet.add(item.authoritySet![4]);

                            // print(index);
                            // print('RoleSet: $_roleSet');
                            // print('AuthoritySet: $_authoritySet');
                          }
                        });
                      },
                      child: _isSelectedDelete
                          ? Icon(
                              Icons.check_box,
                              color: AppColors.blackColor,
                            )
                          : Icon(
                              Icons.check_box_outline_blank,
                              color: AppColors.blackColor,
                            ),
                    ),
                    name: item.name,
                    tL: item.tL,
                    tR: item.tR,
                    bL: item.bL,
                    bR: item.bR,
                    role: manageCustomer,
                  );
                }),
            SizedBox(height: 20),
            Obx(() {
              return InkWell(
                onTap: () {
                  int phoneLength =
                      _teamController.phoneNumberController.text.length;
                  // print('phone length: $phoneLength');
                  // print(
                  //     'isEmail: ${GetUtils.isEmail(_teamController.emailController.text)}');
                  if (_teamController.phoneNumberController.text == '' ||
                      _teamController.emailController.text == '') {
                    Get.snackbar('Alert', 'Enter required details to continue!',
                        titleText: Text('Alert'),
                        messageText:
                            Text('Enter required details to continue!'),
                        icon: Icon(Icons.info,
                            color: AppColors.orangeBorderColor));
                  } else if (_teamController.phoneNumberController.text == '') {
                    Get.snackbar(
                        'Alert', 'Enter your phone number to continue!',
                        titleText: Text('Alert'),
                        messageText:
                            Text('Enter your phone number to continue!'),
                        icon: Icon(Icons.info,
                            color: AppColors.orangeBorderColor));
                  } else if (GetUtils.isEmail(
                          _teamController.emailController.text) ==
                      false) {
                  } else {
                    final value =
                        _businessController.selectedBusiness.value!.businessId;

                    final inviteTeamMemberData = {
                      "phoneNumber": _teamController.countryText +
                          _teamController.phoneNumberController.text.trim(),
                      "teamId":
                          _businessController.selectedBusiness.value!.teamId,
                      "email": _teamController.emailController.text.trim(),
                      "teamInviteUrl": teamInviteLink,
                      "roleSet": _roleSet,
                      "authoritySet": _authoritySet
                    };
                    // print(
                    //     'BusinessId: $value, Team member: ${jsonEncode(inviteTeamMemberData)}');

                    _teamController.inviteTeamMemberOnline(
                        value!, inviteTeamMemberData);
                  }
                },
                child: Container(
                  height: 55,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: (_teamController.addingTeamMemberStatus ==
                            AddingTeamStatus.Loading)
                        ? Container(
                            width: 30,
                            height: 30,
                            child:
                                CircularProgressIndicator(color: Colors.white),
                          )
                        : Text(
                            'Invite Member',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              );
            }),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future showCountryCode(BuildContext context) async {
    showCountryPicker(
      context: context,
      showPhoneCode:
          true, // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        countryCode = country.toJson()['e164_cc'];
        countryFlag = country.toJson()['iso2_cc'];
        country.toJson();
        setState(() {});

        // print('Select country: ${country.toJson()}');
      },
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: GoogleFonts.inter(fontSize: 14),
        ),
      );
}
