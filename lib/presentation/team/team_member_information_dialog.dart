import 'dart:io';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/data/repository/business_repository.dart';
import 'package:huzz/data/repository/team_repository.dart';
import 'package:huzz/presentation/widget/expandable_widget.dart';
import 'package:huzz/core/constants/app_themes.dart';
import '../../data/model/team.dart';
import '../../data/repository/auth_repository.dart';
import '../../model/user_team_invite_model.dart';

class TeamMemberInformationDialog extends StatelessWidget {
  final String? title;

  const TeamMemberInformationDialog({super.key, this.title});
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

class UpdateMember extends StatefulWidget {
  Teams? team;
  UpdateMember({Key? key, this.team}) : super(key: key);

  @override
  State<UpdateMember> createState() => _UpdateMemberState();
}

class _UpdateMemberState extends State<UpdateMember> {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  List _authoritySet = [];
  List _roleSet = [];

  bool? _isManageCustomer, _isMCView, _isMCCreate, _isMCUpdate, _isMCDelete;
  bool? _isManageProduct, _isMPView, _isMPCreate, _isMPUpdate, _isMPDelete;
  bool? _isManageBusiness,
      _isMBusView,
      _isMBusCreate,
      _isMBusUpdate,
      _isMBusDelete;
  bool? _isManageBank,
      _isMBankView,
      _isMBankCreate,
      _isMBankUpdate,
      _isMBankDelete;
  bool? _isManageTeam, _isMTView, _isMTCreate, _isMTUpdate, _isMTDelete;
  bool? _isManageDebtor, _isMDView, _isMDCreate, _isMDUpdate, _isMDDelete;
  bool? _isManageInvoice,
      _isMInvView,
      _isMInvCreate,
      _isMInvUpdate,
      _isMInvDelete;

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
    // print(widget.team!.toJson());

    _roleSet = widget.team!.roleSet!;
    _authoritySet = widget.team!.authoritySet!;

    // MANAGE CUSTOMER
    if (_roleSet.any((element) => element == 'MANAGE_CUSTOMER')) {
      _isManageCustomer = true;
    }
    if (_authoritySet.any((element) => element == 'VIEW_CUSTOMER')) {
      _isMCView = true;
    }
    if (_authoritySet.any((element) => element == 'CREATE_CUSTOMER')) {
      _isMCCreate = true;
    }
    if (_authoritySet.any((element) => element == 'UPDATE_CUSTOMER')) {
      _isMCUpdate = true;
    }
    if (_authoritySet.any((element) => element == 'DELETE_CUSTOMER')) {
      _isMCDelete = true;
    }
    // MANAGE PRODUCT
    if (_roleSet.any((element) => element == 'MANAGE_PRODUCT')) {
      _isManageProduct = true;
    }
    if (_authoritySet.any((element) => element == 'VIEW_PRODUCT')) {
      _isMPView = true;
    }
    if (_authoritySet.any((element) => element == 'CREATE_PRODUCT')) {
      _isMPCreate = true;
    }
    if (_authoritySet.any((element) => element == 'UPDATE_PRODUCT')) {
      _isMPUpdate = true;
    }
    if (_authoritySet.any((element) => element == 'DELETE_PRODUCT')) {
      _isMPDelete = true;
    }
    // MANAGE BUSINESS
    if (_roleSet.any((element) => element == 'MANAGE_BUSINESS_TRANSACTIONS')) {
      _isManageBusiness = true;
    }
    if (_authoritySet
        .any((element) => element == 'VIEW_BUSINESS_TRANSACTION')) {
      _isMBusView = true;
    }
    if (_authoritySet
        .any((element) => element == 'CREATE_BUSINESS_TRANSACTION')) {
      _isMBusCreate = true;
    }
    if (_authoritySet
        .any((element) => element == 'UPDATE_BUSINESS_TRANSACTION')) {
      _isMBusUpdate = true;
    }
    if (_authoritySet
        .any((element) => element == 'DELETE_BUSINESS_TRANSACTION')) {
      _isMBusDelete = true;
    }
    // MANAGE BANK
    if (_roleSet.any((element) => element == 'MANAGE_BANK_INFO')) {
      _isManageBank = true;
    }
    if (_authoritySet.any((element) => element == 'VIEW_BANK_INFO')) {
      _isMBankView = true;
    }
    if (_authoritySet.any((element) => element == 'CREATE_BANK_INFO')) {
      _isMBankCreate = true;
    }
    if (_authoritySet.any((element) => element == 'UPDATE_BANK_INFO')) {
      _isMBankUpdate = true;
    }
    if (_authoritySet.any((element) => element == 'DELETE_BANK_INFO')) {
      _isMBankDelete = true;
    }
    // MANAGE TEAM
    if (_roleSet.any((element) => element == 'MANAGE_TEAM')) {
      _isManageTeam = true;
    }
    if (_authoritySet.any((element) => element == 'VIEW_TEAM_MEMBER')) {
      _isMTView = true;
    }
    if (_authoritySet.any((element) => element == 'CREATE_TEAM_MEMBER')) {
      _isMTCreate = true;
    }
    if (_authoritySet.any((element) => element == 'UPDATE_TEAM_MEMBER')) {
      _isMTUpdate = true;
    }
    if (_authoritySet.any((element) => element == 'DELETE_TEAM_MEMBER')) {
      _isMTDelete = true;
    }
    // MANAGE DEBTOR
    if (_roleSet.any((element) => element == 'MANAGE_DEBTOR')) {
      _isManageDebtor = true;
    }
    if (_authoritySet.any((element) => element == 'VIEW_DEBTOR')) {
      _isMDView = true;
    }
    if (_authoritySet.any((element) => element == 'CREATE_DEBTOR')) {
      _isMDCreate = true;
    }
    if (_authoritySet.any((element) => element == 'UPDATE_DEBTOR')) {
      _isMDUpdate = true;
    }
    if (_authoritySet.any((element) => element == 'DELETE_DEBTOR')) {
      _isMDDelete = true;
    }
    // MANAGE BUSINESS INVOICE
    if (_roleSet.any((element) => element == 'MANAGE_BUSINESS_INVOICE')) {
      _isManageInvoice = true;
    }
    if (_authoritySet.any((element) => element == 'VIEW_BUSINESS_INVOICE')) {
      _isMInvView = true;
    }
    if (_authoritySet.any((element) => element == 'CREATE_BUSINESS_INVOICE')) {
      _isMInvCreate = true;
    }
    if (_authoritySet.any((element) => element == 'UPDATE_BUSINESS_INVOICE')) {
      _isMInvUpdate = true;
    }
    if (_authoritySet.any((element) => element == 'DELETE_BUSINESS_INVOICE')) {
      _isMInvDelete = true;
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
              'Edit Privilege',
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
            EditDetails(
              name: 'Name:',
              value: widget.team!.email,
            ),
            SizedBox(height: 10),
            EditDetails(
              name: 'Phone:',
              value: '+${widget.team!.phoneNumber}',
            ),
            SizedBox(height: 10),
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
            SizedBox(height: 10),
            ExpandableWidget(
              info: () {
                Platform.isIOS
                    ? showCupertinoDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => CupertinoAlertDialog(
                          content: TeamMemberInformationDialog(),
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
                          content: TeamMemberInformationDialog(),
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
                    if (_isManageCustomer == true) {
                      _isManageCustomer = false;
                      _isMCView = false;
                      _isMCCreate = false;
                      _isMCUpdate = false;
                      _isMCDelete = false;
                      _authoritySet.removeWhere((element) {
                        return element == 'DELETE_CUSTOMER';
                      });
                      _authoritySet.removeWhere((element) {
                        return element == 'UPDATE_CUSTOMER';
                      });
                      _authoritySet.removeWhere((element) {
                        return element == 'CREATE_CUSTOMER';
                      });
                      _authoritySet.removeWhere((element) {
                        return element == 'VIEW_CUSTOMER';
                      });
                      _roleSet.removeWhere((element) {
                        return element == 'MANAGE_CUSTOMER';
                      });
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    } else {
                      _isManageCustomer = true;
                      _isMCView = true;
                      _isMCCreate = true;
                      _isMCUpdate = true;
                      _isMCDelete = true;
                      _authoritySet.add('DELETE_CUSTOMER');
                      _authoritySet.add('UPDATE_CUSTOMER');
                      _authoritySet.add('CREATE_CUSTOMER');
                      _authoritySet.add('VIEW_CUSTOMER');
                      _roleSet.add('MANAGE_CUSTOMER');
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    }
                  });
                },
                child: _isManageCustomer == true
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
                    if (_isMCView == true) {
                      _isMCView = false;
                      _authoritySet.removeWhere((element) {
                        return element == 'VIEW_CUSTOMER';
                      });
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    } else {
                      _isMCView = true;
                      _authoritySet.add('VIEW_CUSTOMER');
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    }
                  });
                },
                child: _isMCView == true
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
                    if (_isMCCreate == true) {
                      _isMCCreate = false;
                      _authoritySet.removeWhere((element) {
                        return element == 'CREATE_CUSTOMER';
                      });
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    } else {
                      _isMCCreate = true;
                      _authoritySet.add('CREATE_CUSTOMER');
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    }
                  });
                },
                child: _isMCCreate == true
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
                    if (_isMCUpdate == true) {
                      _isMCUpdate = false;
                      _authoritySet.removeWhere((element) {
                        return element == 'UPDATE_CUSTOMER';
                      });
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    } else {
                      _isMCUpdate = true;
                      _authoritySet.add('UPDATE_CUSTOMER');
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    }
                  });
                },
                child: _isMCUpdate == true
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
                    if (_isMCDelete == true) {
                      _isMCDelete = false;
                      _authoritySet.removeWhere((element) {
                        return element == 'DELETE_CUSTOMER';
                      });
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    } else {
                      _isMCDelete = true;
                      _authoritySet.add('DELETE_CUSTOMER');
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    }
                  });
                },
                child: _isMCDelete == true
                    ? Icon(
                        Icons.check_box,
                        color: AppColors.blackColor,
                      )
                    : Icon(
                        Icons.check_box_outline_blank,
                        color: AppColors.blackColor,
                      ),
              ),
              name: 'MANAGE CUSTOMER',
              tL: 10,
              tR: 10,
              bL: 0,
              bR: 0,
              role: _isManageCustomer,
            ),
            ExpandableWidget(
              info: () {
                Platform.isIOS
                    ? showCupertinoDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => CupertinoAlertDialog(
                          content: TeamMemberInformationDialog(),
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
                          content: TeamMemberInformationDialog(),
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
                    if (_isManageProduct == true) {
                      _isManageProduct = false;
                      _isMPView = false;
                      _isMPCreate = false;
                      _isMPUpdate = false;
                      _isMPDelete = false;
                      _authoritySet.removeWhere((element) {
                        return element == 'DELETE_PRODUCT';
                      });
                      _authoritySet.removeWhere((element) {
                        return element == 'UPDATE_PRODUCT';
                      });
                      _authoritySet.removeWhere((element) {
                        return element == 'CREATE_PRODUCT';
                      });
                      _authoritySet.removeWhere((element) {
                        return element == 'VIEW_PRODUCT';
                      });
                      _roleSet.removeWhere((element) {
                        return element == 'MANAGE_PRODUCT';
                      });
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    } else {
                      _isManageProduct = true;
                      _isMPView = true;
                      _isMPCreate = true;
                      _isMPUpdate = true;
                      _isMPDelete = true;
                      _authoritySet.add('DELETE_PRODUCT');
                      _authoritySet.add('UPDATE_PRODUCT');
                      _authoritySet.add('CREATE_PRODUCT');
                      _authoritySet.add('VIEW_PRODUCT');
                      _roleSet.add('MANAGE_PRODUCT');
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    }
                  });
                },
                child: _isManageProduct == true
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
                    if (_isMPView == true) {
                      _isMPView = false;
                      _authoritySet.removeWhere((element) {
                        return element == 'VIEW_PRODUCT';
                      });
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    } else {
                      _isMPView = true;
                      _authoritySet.add('VIEW_PRODUCT');
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    }
                  });
                },
                child: _isMPView == true
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
                    if (_isMPCreate == true) {
                      _isMPCreate = false;
                      _authoritySet.removeWhere((element) {
                        return element == 'CREATE_PRODUCT';
                      });
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    } else {
                      _isMPCreate = true;
                      _authoritySet.add('CREATE_PRODUCT');
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    }
                  });
                },
                child: _isMPCreate == true
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
                    if (_isMPUpdate == true) {
                      _isMPUpdate = false;
                      _authoritySet.removeWhere((element) {
                        return element == 'UPDATE_PRODUCT';
                      });
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    } else {
                      _isMPUpdate = true;
                      _authoritySet.add('UPDATE_PRODUCT');
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    }
                  });
                },
                child: _isMPUpdate == true
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
                    if (_isMPDelete == true) {
                      _isMPDelete = false;
                      _authoritySet.removeWhere((element) {
                        return element == 'DELETE_PRODUCT';
                      });
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    } else {
                      _isMPDelete = true;
                      _authoritySet.add('DELETE_PRODUCT');
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    }
                  });
                },
                child: _isMPDelete == true
                    ? Icon(
                        Icons.check_box,
                        color: AppColors.blackColor,
                      )
                    : Icon(
                        Icons.check_box_outline_blank,
                        color: AppColors.blackColor,
                      ),
              ),
              name: 'MANAGE PRODUCT',
              tL: 0,
              tR: 0,
              bL: 0,
              bR: 0,
              role: _isManageProduct,
            ),
            ExpandableWidget(
              info: () {
                Platform.isIOS
                    ? showCupertinoDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => CupertinoAlertDialog(
                          content: TeamMemberInformationDialog(),
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
                          content: TeamMemberInformationDialog(),
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
                    if (_isManageBusiness == true) {
                      _isManageBusiness = false;
                      _isMBusView = false;
                      _isMBusCreate = false;
                      _isMBusUpdate = false;
                      _isMBusDelete = false;
                      _authoritySet.removeWhere((element) {
                        return element == 'DELETE_BUSINESS_TRANSACTION';
                      });
                      _authoritySet.removeWhere((element) {
                        return element == 'UPDATE_BUSINESS_TRANSACTION';
                      });
                      _authoritySet.removeWhere((element) {
                        return element == 'CREATE_BUSINESS_TRANSACTION';
                      });
                      _authoritySet.removeWhere((element) {
                        return element == 'VIEW_BUSINESS_TRANSACTION';
                      });
                      _roleSet.removeWhere((element) {
                        return element == 'MANAGE_BUSINESS_TRANSACTIONS';
                      });
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    } else {
                      _isManageBusiness = true;
                      _isMBusView = true;
                      _isMBusCreate = true;
                      _isMBusUpdate = true;
                      _isMBusDelete = true;
                      _authoritySet.add('DELETE_BUSINESS_TRANSACTION');
                      _authoritySet.add('UPDATE_BUSINESS_TRANSACTION');
                      _authoritySet.add('CREATE_BUSINESS_TRANSACTION');
                      _authoritySet.add('VIEW_BUSINESS_TRANSACTION');
                      _roleSet.add('MANAGE_BUSINESS_TRANSACTIONS');
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    }
                  });
                },
                child: _isManageBusiness == true
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
                    if (_isMBusView == true) {
                      _isMBusView = false;
                      _authoritySet.removeWhere((element) {
                        return element == 'VIEW_BUSINESS_TRANSACTION';
                      });
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    } else {
                      _isMBusView = true;
                      _authoritySet.add('VIEW_BUSINESS_TRANSACTION');
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    }
                  });
                },
                child: _isMBusView == true
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
                    if (_isMBusCreate == true) {
                      _isMBusCreate = false;
                      _authoritySet.removeWhere((element) {
                        return element == 'CREATE_BUSINESS_TRANSACTION';
                      });
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    } else {
                      _isMBusCreate = true;
                      _authoritySet.add('CREATE_BUSINESS_TRANSACTION');
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    }
                  });
                },
                child: _isMBusCreate == true
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
                    if (_isMBusUpdate == true) {
                      _isMBusUpdate = false;
                      _authoritySet.removeWhere((element) {
                        return element == 'UPDATE_BUSINESS_TRANSACTION';
                      });
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    } else {
                      _isMBusUpdate = true;
                      _authoritySet.add('UPDATE_BUSINESS_TRANSACTION');
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    }
                  });
                },
                child: _isMBusUpdate == true
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
                    if (_isMBusDelete == true) {
                      _isMBusDelete = false;
                      _authoritySet.removeWhere((element) {
                        return element == 'DELETE_BUSINESS_TRANSACTION';
                      });
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    } else {
                      _isMBusDelete = true;
                      _authoritySet.add('DELETE_BUSINESS_TRANSACTION');
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    }
                  });
                },
                child: _isMBusDelete == true
                    ? Icon(
                        Icons.check_box,
                        color: AppColors.blackColor,
                      )
                    : Icon(
                        Icons.check_box_outline_blank,
                        color: AppColors.blackColor,
                      ),
              ),
              name: 'MANAGE BUSINESS TRANSACTION',
              tL: 0,
              tR: 0,
              bL: 0,
              bR: 0,
              role: _isManageBusiness,
            ),
            ExpandableWidget(
              info: () {
                Platform.isIOS
                    ? showCupertinoDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => CupertinoAlertDialog(
                          content: TeamMemberInformationDialog(),
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
                          content: TeamMemberInformationDialog(),
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
                    if (_isManageBank == true) {
                      _isManageBank = false;
                      _isMBankView = false;
                      _isMBankCreate = false;
                      _isMBankUpdate = false;
                      _isMBankDelete = false;
                      _authoritySet.removeWhere((element) {
                        return element == 'DELETE_BANK_INFO';
                      });
                      _authoritySet.removeWhere((element) {
                        return element == 'UPDATE_BANK_INFO';
                      });
                      _authoritySet.removeWhere((element) {
                        return element == 'CREATE_BANK_INFO';
                      });
                      _authoritySet.removeWhere((element) {
                        return element == 'VIEW_BANK_INFO';
                      });
                      _roleSet.removeWhere((element) {
                        return element == 'MANAGE_BANK_INFO';
                      });
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    } else {
                      _isManageBank = true;
                      _isMBankView = true;
                      _isMBankCreate = true;
                      _isMBankUpdate = true;
                      _isMBankDelete = true;
                      _authoritySet.add('DELETE_BANK_INFO');
                      _authoritySet.add('UPDATE_BANK_INFO');
                      _authoritySet.add('CREATE_BANK_INFO');
                      _authoritySet.add('VIEW_BANK_INFO');
                      _roleSet.add('MANAGE_BANK_INFO');
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    }
                  });
                },
                child: _isManageBank == true
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
                    if (_isMBankView == true) {
                      _isMBankView = false;
                      _authoritySet.removeWhere((element) {
                        return element == 'VIEW_BANK_INFO';
                      });
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    } else {
                      _isMBankView = true;
                      _authoritySet.add('VIEW_BANK_INFO');
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    }
                  });
                },
                child: _isMBankView == true
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
                    if (_isMBankCreate == true) {
                      _isMBankCreate = false;
                      _authoritySet.removeWhere((element) {
                        return element == 'CREATE_BANK_INFO';
                      });
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    } else {
                      _isMBankCreate = true;
                      _authoritySet.add('CREATE_BANK_INFO');
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    }
                  });
                },
                child: _isMBankCreate == true
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
                    if (_isMBankUpdate == true) {
                      _isMBankUpdate = false;
                      _authoritySet.removeWhere((element) {
                        return element == 'UPDATE_BANK_INFO';
                      });
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    } else {
                      _isMBankUpdate = true;
                      _authoritySet.add('UPDATE_BANK_INFO');
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    }
                  });
                },
                child: _isMBankUpdate == true
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
                    if (_isMBankDelete == true) {
                      _isMBankDelete = false;
                      _authoritySet.removeWhere((element) {
                        return element == 'DELETE_BANK_INFO';
                      });
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    } else {
                      _isMBankDelete = true;
                      _authoritySet.add('DELETE_BANK_INFO');
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    }
                  });
                },
                child: _isMBankDelete == true
                    ? Icon(
                        Icons.check_box,
                        color: AppColors.blackColor,
                      )
                    : Icon(
                        Icons.check_box_outline_blank,
                        color: AppColors.blackColor,
                      ),
              ),
              name: 'MANAGE BANK INFO',
              tL: 0,
              tR: 0,
              bL: 0,
              bR: 0,
              role: _isManageBank,
            ),
            ExpandableWidget(
              info: () {
                Platform.isIOS
                    ? showCupertinoDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => CupertinoAlertDialog(
                          content: TeamMemberInformationDialog(),
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
                          content: TeamMemberInformationDialog(),
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
                    if (_isManageTeam == true) {
                      _isManageTeam = false;
                      _isMTView = false;
                      _isMTCreate = false;
                      _isMTUpdate = false;
                      _isMTDelete = false;
                      _authoritySet.removeWhere((element) {
                        return element == 'DELETE_TEAM_MEMBER';
                      });
                      _authoritySet.removeWhere((element) {
                        return element == 'UPDATE_TEAM_MEMBER';
                      });
                      _authoritySet.removeWhere((element) {
                        return element == 'CREATE_TEAM_MEMBER';
                      });
                      _authoritySet.removeWhere((element) {
                        return element == 'VIEW_TEAM_MEMBER';
                      });
                      _roleSet.removeWhere((element) {
                        return element == 'MANAGE_TEAM';
                      });
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    } else {
                      _isManageTeam = true;
                      _isMTView = true;
                      _isMTCreate = true;
                      _isMTUpdate = true;
                      _isMTDelete = true;
                      _authoritySet.add('DELETE_TEAM_MEMBER');
                      _authoritySet.add('UPDATE_TEAM_MEMBER');
                      _authoritySet.add('CREATE_TEAM_MEMBER');
                      _authoritySet.add('VIEW_TEAM_MEMBER');
                      _roleSet.add('MANAGE_TEAM');
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    }
                  });
                },
                child: _isManageTeam == true
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
                    if (_isMTView == true) {
                      _isMTView = false;
                      _authoritySet.removeWhere((element) {
                        return element == 'VIEW_TEAM_MEMBER';
                      });
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    } else {
                      _isMTView = true;
                      _authoritySet.add('VIEW_TEAM_MEMBER');
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    }
                  });
                },
                child: _isMTView == true
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
                    if (_isMTCreate == true) {
                      _isMTCreate = false;
                      _authoritySet.removeWhere((element) {
                        return element == 'CREATE_TEAM_MEMBER';
                      });
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    } else {
                      _isMTCreate = true;
                      _authoritySet.add('CREATE_TEAM_MEMBER');
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    }
                  });
                },
                child: _isMTCreate == true
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
                    if (_isMTUpdate == true) {
                      _isMTUpdate = false;
                      _authoritySet.removeWhere((element) {
                        return element == 'UPDATE_TEAM_MEMBER';
                      });
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    } else {
                      _isMTUpdate = true;
                      _authoritySet.add('UPDATE_TEAM_MEMBER');
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    }
                  });
                },
                child: _isMTUpdate == true
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
                    if (_isMTDelete == true) {
                      _isMTDelete = false;
                      _authoritySet.removeWhere((element) {
                        return element == 'DELETE_TEAM_MEMBER';
                      });
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    } else {
                      _isMTDelete = true;
                      _authoritySet.add('DELETE_TEAM_MEMBER');
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    }
                  });
                },
                child: _isMTDelete == true
                    ? Icon(
                        Icons.check_box,
                        color: AppColors.blackColor,
                      )
                    : Icon(
                        Icons.check_box_outline_blank,
                        color: AppColors.blackColor,
                      ),
              ),
              name: 'MANAGE TEAM',
              tL: 0,
              tR: 0,
              bL: 0,
              bR: 0,
              role: _isManageTeam,
            ),
            ExpandableWidget(
              info: () {
                Platform.isIOS
                    ? showCupertinoDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => CupertinoAlertDialog(
                          content: TeamMemberInformationDialog(),
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
                          content: TeamMemberInformationDialog(),
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
                    if (_isManageDebtor == true) {
                      _isManageDebtor = false;
                      _isMDView = false;
                      _isMDCreate = false;
                      _isMDUpdate = false;
                      _isMDDelete = false;
                      _authoritySet.removeWhere((element) {
                        return element == 'DELETE_DEBTOR';
                      });
                      _authoritySet.removeWhere((element) {
                        return element == 'UPDATE_DEBTOR';
                      });
                      _authoritySet.removeWhere((element) {
                        return element == 'CREATE_DEBTOR';
                      });
                      _authoritySet.removeWhere((element) {
                        return element == 'VIEW_DEBTOR';
                      });
                      _roleSet.removeWhere((element) {
                        return element == 'MANAGE_DEBTOR';
                      });

                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    } else {
                      _isManageDebtor = true;
                      _isMDView = true;
                      _isMDCreate = true;
                      _isMDUpdate = true;
                      _isMDDelete = true;
                      _authoritySet.add('DELETE_DEBTOR');
                      _authoritySet.add('UPDATE_DEBTOR');
                      _authoritySet.add('CREATE_DEBTOR');
                      _authoritySet.add('VIEW_DEBTOR');
                      _roleSet.add('MANAGE_DEBTOR');
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    }
                  });
                },
                child: _isManageDebtor == true
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
                    if (_isMDView == true) {
                      _isMDView = false;
                      _authoritySet.removeWhere((element) {
                        return element == 'VIEW_DEBTOR';
                      });
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    } else {
                      _isMDView = true;
                      _authoritySet.add('VIEW_DEBTOR');
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    }
                  });
                },
                child: _isMDView == true
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
                    if (_isMDCreate == true) {
                      _isMDCreate = false;
                      _authoritySet.removeWhere((element) {
                        return element == 'CREATE_DEBTOR';
                      });
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    } else {
                      _isMDCreate = true;
                      _authoritySet.add('CREATE_DEBTOR');
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    }
                  });
                },
                child: _isMDCreate == true
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
                    if (_isMDUpdate == true) {
                      _isMDUpdate = false;
                      _authoritySet.removeWhere((element) {
                        return element == 'UPDATE_DEBTOR';
                      });
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    } else {
                      _isMDUpdate = true;
                      _authoritySet.add('UPDATE_DEBTOR');
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    }
                  });
                },
                child: _isMDUpdate == true
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
                    if (_isMDDelete == true) {
                      _isMDDelete = false;
                      _authoritySet.removeWhere((element) {
                        return element == 'DELETE_DEBTOR';
                      });
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    } else {
                      _isMDDelete = true;
                      _authoritySet.add('DELETE_DEBTOR');
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    }
                  });
                },
                child: _isMDDelete == true
                    ? Icon(
                        Icons.check_box,
                        color: AppColors.blackColor,
                      )
                    : Icon(
                        Icons.check_box_outline_blank,
                        color: AppColors.blackColor,
                      ),
              ),
              name: 'MANAGE DEBTOR',
              tL: 0,
              tR: 0,
              bL: 0,
              bR: 0,
              role: _isManageDebtor,
            ),
            ExpandableWidget(
              info: () {
                Platform.isIOS
                    ? showCupertinoDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => CupertinoAlertDialog(
                          content: TeamMemberInformationDialog(),
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
                          content: TeamMemberInformationDialog(),
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
                    if (_isManageInvoice == true) {
                      _isManageInvoice = false;
                      _isMInvView = false;
                      _isMInvCreate = false;
                      _isMInvUpdate = false;
                      _isMInvDelete = false;
                      _roleSet.removeWhere((element) {
                        return element == 'MANAGE_BUSINESS_INVOICE';
                      });
                      _authoritySet.removeWhere((element) {
                        return element == 'DELETE_BUSINESS_INVOICE';
                      });
                      _authoritySet.removeWhere((element) {
                        return element == 'UPDATE_BUSINESS_INVOICE';
                      });
                      _authoritySet.removeWhere((element) {
                        return element == 'CREATE_BUSINESS_INVOICE';
                      });
                      _authoritySet.removeWhere((element) {
                        return element == 'VIEW_BUSINESS_INVOICE';
                      });
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    } else {
                      _isManageInvoice = true;
                      _isMInvView = true;
                      _isMInvCreate = true;
                      _isMInvUpdate = true;
                      _isMInvDelete = true;
                      _roleSet.add('MANAGE_BUSINESS_INVOICE');
                      _authoritySet.add('DELETE_BUSINESS_INVOICE');
                      _authoritySet.add('UPDATE_BUSINESS_INVOICE');
                      _authoritySet.add('CREATE_BUSINESS_INVOICE');
                      _authoritySet.add('VIEW_BUSINESS_INVOICE');
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    }
                  });
                },
                child: _isManageInvoice == true
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
                    if (_isMInvView == true) {
                      _isMInvView = false;
                      _authoritySet.removeWhere((element) {
                        return element == 'VIEW_BUSINESS_INVOICE';
                      });
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    } else {
                      _isMInvView = true;
                      _authoritySet.add('VIEW_BUSINESS_INVOICE');
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    }
                  });
                },
                child: _isMInvView == true
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
                    if (_isMInvCreate == true) {
                      _isMInvCreate = false;
                      _authoritySet.removeWhere((element) {
                        return element == 'CREATE_BUSINESS_INVOICE';
                      });
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    } else {
                      _isMInvCreate = true;
                      _authoritySet.add('CREATE_BUSINESS_INVOICE');
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    }
                  });
                },
                child: _isMInvCreate == true
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
                    if (_isMInvUpdate == true) {
                      _isMInvUpdate = false;
                      _authoritySet.removeWhere((element) {
                        return element == 'UPDATE_BUSINESS_INVOICE';
                      });
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    } else {
                      _isMInvUpdate = true;
                      _authoritySet.add('UPDATE_BUSINESS_INVOICE');
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    }
                  });
                },
                child: _isMInvUpdate == true
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
                    if (_isMInvDelete == true) {
                      _isMInvDelete = false;
                      _authoritySet.removeWhere((element) {
                        return element == 'DELETE_BUSINESS_INVOICE';
                      });
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    } else {
                      _isMInvDelete = true;
                      _authoritySet.add('DELETE_BUSINESS_INVOICE');
                      // print('RoleSet: $_roleSet');
                      // print('AuthoritySet: $_authoritySet');
                    }
                  });
                },
                child: _isMInvDelete == true
                    ? Icon(
                        Icons.check_box,
                        color: AppColors.blackColor,
                      )
                    : Icon(
                        Icons.check_box_outline_blank,
                        color: AppColors.blackColor,
                      ),
              ),
              name: 'MANAGE BUSINESS INVOICE',
              tL: 0,
              tR: 0,
              bL: 10,
              bR: 10,
              role: _isManageInvoice,
            ),
            SizedBox(height: 10),
            // ListView.builder(
            //     shrinkWrap: true,
            //     physics: ScrollPhysics(),
            //     itemCount: roleSet.length,
            //     itemBuilder: (context, index) {
            //       RoleSet item = roleSet[index];
            //       var roleItem = widget.team!.roleSet![index];
            //       final _isSelected = _selectedIndex.contains(index);
            //       final _isSelectedView = _selectedViewIndex.contains(index);
            //       final _isSelectedCreate =
            //           _selectedCreateIndex.contains(index);
            //       final _isSelectedUpdate =
            //           _selectedUpdateIndex.contains(index);
            //       final _isSelectedDelete =
            //           _selectedDeleteIndex.contains(index);
            //       return ExpandableWidget(
            //         manageChild: InkWell(
            //           onTap: () {
            //             setState(() {
            //               if (_isSelected) {
            //                 _selectedIndex.remove(index);
            //                 _selectedViewIndex.remove(index);
            //                 _selectedCreateIndex.remove(index);
            //                 _selectedUpdateIndex.remove(index);
            //                 _selectedDeleteIndex.remove(index);

            //                 if (_roleSet.contains(item.titleName) ||
            //                     _authoritySet.contains(item.authoritySet![1]) ||
            //                     _authoritySet.contains(item.authoritySet![2]) ||
            //                     _authoritySet.contains(item.authoritySet![3]) ||
            //                     _authoritySet.contains(item.authoritySet![4])) {
            //                   _roleSet.remove(item.titleName);
            //                   _authoritySet.remove(item.authoritySet![1]);
            //                   _authoritySet.remove(item.authoritySet![2]);
            //                   _authoritySet.remove(item.authoritySet![3]);
            //                   _authoritySet.remove(item.authoritySet![4]);

            //                   print(index);
            //                   print('RoleSet: ${_roleSet.toString()}');
            //                   print('AuthoritySet: $_authoritySet');
            //                 }
            //               } else {
            //                 _selectedIndex.add(index);
            //                 _roleSet.add(item.titleName);
            //                 _selectedViewIndex.add(index);
            //                 _authoritySet.add(item.authoritySet![1]);
            //                 _selectedCreateIndex.add(index);
            //                 _authoritySet.add(item.authoritySet![2]);
            //                 _selectedUpdateIndex.add(index);
            //                 _authoritySet.add(item.authoritySet![3]);
            //                 _selectedDeleteIndex.add(index);
            //                 _authoritySet.add(item.authoritySet![4]);

            //                 print(index);
            //                 print('RoleSet: $_roleSet');
            //                 print('AuthoritySet: $_authoritySet');
            //               }
            //             });
            //           },
            //           child: _isSelected
            //               ? Icon(
            //                   Icons.check_box,
            //                   color: AppColors.backgroundColor,
            //                 )
            //               : Icon(
            //                   Icons.check_box_outline_blank,
            //                   color: AppColors.backgroundColor,
            //                 ),
            //         ),
            //         view: InkWell(
            //           onTap: () {
            //             setState(() {
            //               if (_isSelectedView) {
            //                 _selectedViewIndex.remove(index);

            //                 if (_authoritySet.contains(item.authoritySet![1])) {
            //                   _authoritySet.remove(item.authoritySet![1]);

            //                   print(index);
            //                   print('RoleSet: $_roleSet');
            //                   print('AuthoritySet: $_authoritySet');
            //                 }
            //               } else {
            //                 _selectedViewIndex.add(index);
            //                 _authoritySet.add(item.authoritySet![1]);

            //                 print(index);
            //                 print('RoleSet: $_roleSet');
            //                 print('AuthoritySet: $_authoritySet');
            //               }
            //             });
            //           },
            //           child: _isSelectedView
            //               ? Icon(
            //                   Icons.check_box,
            //                   color: AppColors.blackColor,
            //                 )
            //               : Icon(
            //                   Icons.check_box_outline_blank,
            //                   color: AppColors.blackColor,
            //                 ),
            //         ),
            //         create: InkWell(
            //           onTap: () {
            //             setState(() {
            //               if (_isSelectedCreate) {
            //                 _selectedCreateIndex.remove(index);

            //                 if (_authoritySet.contains(item.authoritySet![2])) {
            //                   _authoritySet.remove(item.authoritySet![2]);

            //                   print(index);
            //                   print('RoleSet: $_roleSet');
            //                   print('AuthoritySet: $_authoritySet');
            //                 }
            //               } else {
            //                 _selectedCreateIndex.add(index);
            //                 _authoritySet.add(item.authoritySet![2]);

            //                 print(index);
            //                 print('RoleSet: $_roleSet');
            //                 print('AuthoritySet: $_authoritySet');
            //               }
            //             });
            //           },
            //           child: _isSelectedCreate
            //               ? Icon(
            //                   Icons.check_box,
            //                   color: AppColors.blackColor,
            //                 )
            //               : Icon(
            //                   Icons.check_box_outline_blank,
            //                   color: AppColors.blackColor,
            //                 ),
            //         ),
            //         update: InkWell(
            //           onTap: () {
            //             setState(() {
            //               if (_isSelectedUpdate) {
            //                 _selectedUpdateIndex.remove(index);

            //                 if (_authoritySet.contains(item.authoritySet![3])) {
            //                   _authoritySet.remove(item.authoritySet![3]);

            //                   print(index);
            //                   print('RoleSet: $_roleSet');
            //                   print('AuthoritySet: $_authoritySet');
            //                 }
            //               } else {
            //                 _selectedUpdateIndex.add(index);
            //                 _authoritySet.add(item.authoritySet![3]);

            //                 print(index);
            //                 print('RoleSet: $_roleSet');
            //                 print('AuthoritySet: $_authoritySet');
            //               }
            //             });
            //           },
            //           child: _isSelectedUpdate
            //               ? Icon(
            //                   Icons.check_box,
            //                   color: AppColors.blackColor,
            //                 )
            //               : Icon(
            //                   Icons.check_box_outline_blank,
            //                   color: AppColors.blackColor,
            //                 ),
            //         ),
            //         delete: InkWell(
            //           onTap: () {
            //             setState(() {
            //               if (_isSelectedDelete) {
            //                 _selectedDeleteIndex.remove(index);

            //                 if (_authoritySet.contains(item.authoritySet![4])) {
            //                   _authoritySet.remove(item.authoritySet![4]);

            //                   print(index);
            //                   print('RoleSet: $_roleSet');
            //                   print('AuthoritySet: $_authoritySet');
            //                 }
            //               } else {
            //                 _selectedDeleteIndex.add(index);
            //                 _authoritySet.add(item.authoritySet![4]);

            //                 print(index);
            //                 print('RoleSet: $_roleSet');
            //                 print('AuthoritySet: $_authoritySet');
            //               }
            //             });
            //           },
            //           child: _isSelectedDelete
            //               ? Icon(
            //                   Icons.check_box,
            //                   color: AppColors.blackColor,
            //                 )
            //               : Icon(
            //                   Icons.check_box_outline_blank,
            //                   color: AppColors.blackColor,
            //                 ),
            //         ),
            //         name: item.name,
            //         tL: item.tL,
            //         tR: item.tR,
            //         bL: item.bL,
            //         bR: item.bR,
            //         role: manageCustomer,
            //       );
            //     }),
            SizedBox(height: 20),
            Obx(() {
              return InkWell(
                onTap: () {
                  final updateTeamMemberData = {
                    "phoneNumber": widget.team!.phoneNumber,
                    "teamId": widget.team!.businessId,
                    "email": widget.team!.email,
                    "roleSet": _roleSet,
                    "authoritySet": _authoritySet
                  };

                  _teamController.updateTeamMember(
                      widget.team!.teamId, updateTeamMemberData);
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
                    child: (_teamController.updatingTeamMemberStatus ==
                            UpdateTeamStatus.Loading)
                        ? Container(
                            width: 30,
                            height: 30,
                            child:
                                CircularProgressIndicator(color: Colors.white),
                          )
                        : Text(
                            'Update Privilege',
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
}

class EditDetails extends StatelessWidget {
  final String? name, value;
  const EditDetails({
    Key? key,
    this.name,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            name!,
            style: GoogleFonts.inter(
              color: AppColors.blackColor,
              fontSize: 12,
            ),
          ),
          SizedBox(width: 10),
          Text(
            value!,
            style: GoogleFonts.inter(
              color: AppColors.blackColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
