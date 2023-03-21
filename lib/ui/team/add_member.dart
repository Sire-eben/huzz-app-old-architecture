import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/services/firebase/firebase_dynamic_linking.dart';
import 'package:huzz/core/widgets/state/loading.dart';
import 'package:huzz/data/repository/business_respository.dart';
import 'package:huzz/data/repository/team_repository.dart';
import 'package:huzz/ui/widget/expandable_widget.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/data/model/roles_model.dart';
import 'package:provider/provider.dart';
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
        const Icon(
          Icons.info_outline_rounded,
          size: 27,
        ),
        const SizedBox(height: 7),
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
  const AddMember({Key? key}) : super(key: key);

  @override
  State<AddMember> createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  final List _authoritySet = [];
  final List _roleSet = [];
  final List _selectedIndex = [];
  final List _selectedViewIndex = [];
  final List _selectedCreateIndex = [];
  final List _selectedUpdateIndex = [];
  final List _selectedDeleteIndex = [];
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
    context.read<FirebaseDynamicLinkService>().initDynamicLinks();

    super.initState();
    final value = _businessController.selectedBusiness.value!.businessId;
    // shareBusinessIdLink(value.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
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
            const SizedBox(
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
            const SizedBox(
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
                  const SizedBox(width: 5),
                  SvgPicture.asset(
                    "assets/images/info.svg",
                    height: 15,
                    width: 15,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: roleSet.length,
                itemBuilder: (context, index) {
                  RoleSet item = roleSet[index];
                  final isSelected = _selectedIndex.contains(index);
                  final isSelectedView = _selectedViewIndex.contains(index);
                  final isSelectedCreate = _selectedCreateIndex.contains(index);
                  final isSelectedUpdate = _selectedUpdateIndex.contains(index);
                  final isSelectedDelete = _selectedDeleteIndex.contains(index);
                  return ExpandableWidget(
                    info: () {
                      Platform.isIOS
                          ? showCupertinoDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) => CupertinoAlertDialog(
                                content: const InformationDialog(),
                                actions: [
                                  CupertinoButton(
                                    child: const Text(
                                      "OK",
                                      style: TextStyle(
                                          color: AppColors.primaryColor),
                                    ),
                                    onPressed: () => Get.back(),
                                  ),
                                ],
                              ),
                            )
                          : showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: const InformationDialog(),
                                actions: [
                                  CupertinoButton(
                                    child: const Text(
                                      "OK",
                                      style: TextStyle(
                                          color: AppColors.primaryColor),
                                    ),
                                    onPressed: () => Get.back(),
                                  ),
                                ],
                              ),
                            );
                    },
                    manageChild: InkWell(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
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
                          }
                        });
                      },
                      child: isSelected
                          ? const Icon(
                              Icons.check_box,
                              color: AppColors.backgroundColor,
                            )
                          : const Icon(
                              Icons.check_box_outline_blank,
                              color: AppColors.backgroundColor,
                            ),
                    ),
                    view: InkWell(
                      onTap: () {
                        setState(() {
                          if (isSelectedView) {
                            _selectedViewIndex.remove(index);

                            if (_authoritySet.contains(item.authoritySet![1])) {
                              _authoritySet.remove(item.authoritySet![1]);
                            }
                          } else {
                            _selectedViewIndex.add(index);
                            _authoritySet.add(item.authoritySet![1]);
                          }
                        });
                      },
                      child: isSelectedView
                          ? const Icon(
                              Icons.check_box,
                              color: AppColors.blackColor,
                            )
                          : const Icon(
                              Icons.check_box_outline_blank,
                              color: AppColors.blackColor,
                            ),
                    ),
                    create: InkWell(
                      onTap: () {
                        setState(() {
                          if (isSelectedCreate) {
                            _selectedCreateIndex.remove(index);

                            if (_authoritySet.contains(item.authoritySet![2])) {
                              _authoritySet.remove(item.authoritySet![2]);
                            }
                          } else {
                            _selectedCreateIndex.add(index);
                            _authoritySet.add(item.authoritySet![2]);
                          }
                        });
                      },
                      child: isSelectedCreate
                          ? const Icon(
                              Icons.check_box,
                              color: AppColors.blackColor,
                            )
                          : const Icon(
                              Icons.check_box_outline_blank,
                              color: AppColors.blackColor,
                            ),
                    ),
                    update: InkWell(
                      onTap: () {
                        setState(() {
                          if (isSelectedUpdate) {
                            _selectedUpdateIndex.remove(index);

                            if (_authoritySet.contains(item.authoritySet![3])) {
                              _authoritySet.remove(item.authoritySet![3]);
                            }
                          } else {
                            _selectedUpdateIndex.add(index);
                            _authoritySet.add(item.authoritySet![3]);
                          }
                        });
                      },
                      child: isSelectedUpdate
                          ? const Icon(
                              Icons.check_box,
                              color: AppColors.blackColor,
                            )
                          : const Icon(
                              Icons.check_box_outline_blank,
                              color: AppColors.blackColor,
                            ),
                    ),
                    delete: InkWell(
                      onTap: () {
                        setState(() {
                          if (isSelectedDelete) {
                            _selectedDeleteIndex.remove(index);

                            if (_authoritySet.contains(item.authoritySet![4])) {
                              _authoritySet.remove(item.authoritySet![4]);
                            }
                          } else {
                            _selectedDeleteIndex.add(index);
                            _authoritySet.add(item.authoritySet![4]);
                          }
                        });
                      },
                      child: isSelectedDelete
                          ? const Icon(
                              Icons.check_box,
                              color: AppColors.blackColor,
                            )
                          : const Icon(
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
            const SizedBox(height: 20),
            Obx(() {
              return InkWell(
                onTap: () {
                  int phoneLength =
                      _teamController.phoneNumberController.text.length;
                  if (_teamController.phoneNumberController.text == '' ||
                      _teamController.emailController.text == '') {
                    Get.snackbar('Alert', 'Enter required details to continue!',
                        titleText: const Text('Alert'),
                        messageText:
                            const Text('Enter required details to continue!'),
                        icon: const Icon(Icons.info,
                            color: AppColors.orangeBorderColor));
                  } else if (_teamController.phoneNumberController.text == '') {
                    Get.snackbar(
                        'Alert', 'Enter your phone number to continue!',
                        titleText: const Text('Alert'),
                        messageText:
                            const Text('Enter your phone number to continue!'),
                        icon: const Icon(Icons.info,
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

                    _teamController.inviteTeamMemberOnline(
                        value!, inviteTeamMemberData);
                  }
                },
                child: Container(
                  height: 55,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: (_teamController.addingTeamMemberStatus ==
                            AddingTeamStatus.Loading)
                        ? const LoadingWidget(
                            color: Colors.white,
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
            const SizedBox(height: 20),
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
