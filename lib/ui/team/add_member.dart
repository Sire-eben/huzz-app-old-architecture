import 'dart:convert';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/business_respository.dart';
import 'package:huzz/Repository/team_repository.dart';
import 'package:huzz/ui/widget/expandable_widget.dart';
import 'package:huzz/util/colors.dart';
import 'package:huzz/data/model/roles_model.dart';
import '../widget/custom_form_field.dart';

class AddMember extends StatefulWidget {
  AddMember({Key? key}) : super(key: key);

  @override
  State<AddMember> createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  List _authoritySet = [];
  List _roleSet = [];
  List _selectedIndex = [];
  List _selectedViewIndex = [];
  List _selectedCreateIndex = [];
  List _selectedUpdateIndex = [];
  List _selectedDeleteIndex = [];
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

  String? value;
  bool manageCustomer = false;
  bool view = false, create = false, update = false, delete = false;

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
            color: AppColor().backgroundColor,
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
              style: TextStyle(
                color: AppColor().backgroundColor,
                fontFamily: 'InterRegular',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppColor().whiteColor,
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
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'InterRegular',
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
            Container(
              height: roleSet.length * 55,
              padding: EdgeInsets.all(2),
              child: ListView.builder(
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
                      manageChild: InkWell(
                        onTap: () {
                          setState(() {
                            if (_isSelected) {
                              _selectedIndex.remove(index);

                              if (_roleSet.contains(item.titleName)) {
                                _roleSet.remove(item.titleName);

                                print(index);
                                print('RoleSet: ${_roleSet.toString()}');
                                print('AuthoritySet: $_authoritySet');
                              }
                            } else {
                              _selectedIndex.add(index);
                              _roleSet.add(item.titleName);

                              print(index);
                              print('RoleSet: $_roleSet');
                              print('AuthoritySet: $_authoritySet');
                            }
                          });
                        },
                        child: _isSelected
                            ? Icon(
                                Icons.check_box,
                                color: AppColor().backgroundColor,
                              )
                            : Icon(
                                Icons.check_box_outline_blank,
                                color: AppColor().backgroundColor,
                              ),
                      ),
                      view: InkWell(
                        onTap: () {
                          setState(() {
                            if (_isSelectedView) {
                              _selectedViewIndex.remove(index);

                              if (_authoritySet
                                  .contains(item.authoritySet![1])) {
                                _authoritySet.remove(item.authoritySet![1]);

                                print(index);
                                print('RoleSet: $_roleSet');
                                print('AuthoritySet: $_authoritySet');
                              }
                            } else {
                              _selectedViewIndex.add(index);
                              _authoritySet.add(item.authoritySet![1]);

                              print(index);
                              print('RoleSet: $_roleSet');
                              print('AuthoritySet: $_authoritySet');
                            }
                          });
                        },
                        child: _isSelectedView
                            ? Icon(
                                Icons.check_box,
                                color: AppColor().blackColor,
                              )
                            : Icon(
                                Icons.check_box_outline_blank,
                                color: AppColor().blackColor,
                              ),
                      ),
                      create: InkWell(
                        onTap: () {
                          setState(() {
                            if (_isSelectedCreate) {
                              _selectedCreateIndex.remove(index);

                              if (_authoritySet
                                  .contains(item.authoritySet![2])) {
                                _authoritySet.remove(item.authoritySet![2]);

                                print(index);
                                print('RoleSet: $_roleSet');
                                print('AuthoritySet: $_authoritySet');
                              }
                            } else {
                              _selectedCreateIndex.add(index);
                              _authoritySet.add(item.authoritySet![2]);

                              print(index);
                              print('RoleSet: $_roleSet');
                              print('AuthoritySet: $_authoritySet');
                            }
                          });
                        },
                        child: _isSelectedCreate
                            ? Icon(
                                Icons.check_box,
                                color: AppColor().blackColor,
                              )
                            : Icon(
                                Icons.check_box_outline_blank,
                                color: AppColor().blackColor,
                              ),
                      ),
                      update: InkWell(
                        onTap: () {
                          setState(() {
                            if (_isSelectedUpdate) {
                              _selectedUpdateIndex.remove(index);

                              if (_authoritySet
                                  .contains(item.authoritySet![3])) {
                                _authoritySet.remove(item.authoritySet![3]);

                                print(index);
                                print('RoleSet: $_roleSet');
                                print('AuthoritySet: $_authoritySet');
                              }
                            } else {
                              _selectedUpdateIndex.add(index);
                              _authoritySet.add(item.authoritySet![3]);

                              print(index);
                              print('RoleSet: $_roleSet');
                              print('AuthoritySet: $_authoritySet');
                            }
                          });
                        },
                        child: _isSelectedUpdate
                            ? Icon(
                                Icons.check_box,
                                color: AppColor().blackColor,
                              )
                            : Icon(
                                Icons.check_box_outline_blank,
                                color: AppColor().blackColor,
                              ),
                      ),
                      delete: InkWell(
                        onTap: () {
                          setState(() {
                            if (_isSelectedDelete) {
                              _selectedDeleteIndex.remove(index);

                              if (_authoritySet
                                  .contains(item.authoritySet![4])) {
                                _authoritySet.remove(item.authoritySet![4]);

                                print(index);
                                print('RoleSet: $_roleSet');
                                print('AuthoritySet: $_authoritySet');
                              }
                            } else {
                              _selectedDeleteIndex.add(index);
                              _authoritySet.add(item.authoritySet![4]);

                              print(index);
                              print('RoleSet: $_roleSet');
                              print('AuthoritySet: $_authoritySet');
                            }
                          });
                        },
                        child: _isSelectedDelete
                            ? Icon(
                                Icons.check_box,
                                color: AppColor().blackColor,
                              )
                            : Icon(
                                Icons.check_box_outline_blank,
                                color: AppColor().blackColor,
                              ),
                      ),
                      name: item.name,
                      titleName: item.titleName,
                      viewName: item.authoritySet![1],
                      createName: item.authoritySet![2],
                      updateName: item.authoritySet![3],
                      deleteName: item.authoritySet![4],
                      tL: item.tL,
                      tR: item.tR,
                      bL: item.bL,
                      bR: item.bR,
                      role: manageCustomer,
                    );
                  }),
            ),
            SizedBox(height: 20),
            Obx(() {
              return InkWell(
                onTap: () {
                  final value =
                      _businessController.selectedBusiness.value!.businessId;

                  final inviteTeamMemberData = {
                    "phoneNumber": _teamController.countryText +
                        _teamController.phoneNumberController.text.trim(),
                    "teamId":
                        _businessController.selectedBusiness.value!.teamId,
                    "email": _teamController.emailController.text.trim(),
                    "roleSet": _roleSet,
                    "authoritySet": _authoritySet
                  };
                  print(
                      'BusinessId: $value, Team member: ${jsonEncode(inviteTeamMemberData)}');

                  _teamController.inviteTeamMember(
                      value!, inviteTeamMemberData);
                },
                child: Container(
                  height: 55,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColor().backgroundColor,
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
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'InterRegular',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
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

        print('Select country: ${country.toJson()}');
      },
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(fontSize: 14),
        ),
      );
}
