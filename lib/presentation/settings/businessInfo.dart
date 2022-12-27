// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/data/repository/auth_respository.dart';
import 'package:huzz/data/repository/bank_account_repository.dart';
import 'package:huzz/data/repository/business_respository.dart';
import 'package:huzz/presentation/widget/custom_form_field.dart';
import 'package:huzz/data/model/bank.dart';
import 'package:huzz/data/model/business.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../data/repository/team_repository.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'bankCard.dart';

class BusinessInfo extends StatefulWidget {
  BusinessInfo({Key? key});

  @override
  _BusinessInfoState createState() => _BusinessInfoState();
}

class _BusinessInfoState extends State<BusinessInfo> {
  final controller = Get.find<AuthRepository>();
  final businessController = Get.find<BusinessRespository>();
  final bankInfoController = Get.find<BankAccountRepository>();
  final teamController = Get.find<TeamRepository>();

  final TextEditingController textEditingController = TextEditingController();

  String countryFlag = "NG";
  String countryCode = "234";
  final addAccountKey = GlobalKey<FormState>();

  final items = [
    'NGN',
    'USD',
    'EUR',
    'POUNDS',
  ];

  String? value;
  late String? businessImage;
  late String? businessName;
  late String? businessEmail;
  late String? businessAddress;
  late String? businessCurrency;
  late String? businessPhoneNumber;

  final business = Rx(Business());
  Business? get businessData => business.value;

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;
  ScrollController _scrollController = ScrollController();
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    // businessImage = bankInfoController.BankImage as String?;
    businessName = businessController.selectedBusiness.value!.businessName;
    businessController.businessName.text = businessName!;
    businessEmail = businessController.selectedBusiness.value!.businessEmail;
    businessAddress =
        businessController.selectedBusiness.value!.businessAddress;
    businessCurrency =
        businessController.selectedBusiness.value!.businessCurrency;
    businessPhoneNumber =
        businessController.selectedBusiness.value!.businessPhoneNumber;
    value = businessController.selectedBusiness.value!.businessCurrency;
    businessController.businessAddressController.text = businessAddress ?? "";
    print(
        "current business json ${businessController.selectedBusiness.value!.toJson()}");
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.whiteColor,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: AppColors.backgroundColor,
          ),
        ),
        title: Text(
          "Business account settings",
          style: GoogleFonts.inter(
            color: AppColors.backgroundColor,
            fontSize: 18,
          ),
        ),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          return Future.delayed(Duration(seconds: 1), () {
            businessController.OnlineBusiness();
          });
        },
        child: Obx(() {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              // width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () => showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20))),
                          context: context,
                          builder: (context) => buildAddImage()),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // ignore: unnecessary_null_comparison
                            (businessController.businessImage.value != null)
                                ? Image.file(
                                    businessController.businessImage.value!,
                                    width: 100,
                                    height: 100,
                                  )
                                : businessController.selectedBusiness.value!
                                            .buisnessLogoFileStoreId ==
                                        null
                                    ? Image.asset(
                                        'assets/images/Group 3647.png',
                                      )
                                    : CircleAvatar(
                                        radius: 50.0,
                                        backgroundImage: NetworkImage(
                                            "${businessController.selectedBusiness.value!.buisnessLogoFileStoreId}"),
                                        backgroundColor: Colors.transparent,
                                      )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                        child: Text(
                      "Business Logo",
                      style: GoogleFonts.inter(
                        color: AppColors.blackColor,
                        fontSize: 12,
                      ),
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      label: "Business Name",
                      validatorText: "Business Name required",
                      colors: AppColors.blackColor,
                      hint:
                          "${businessController.selectedBusiness.value!.businessName}",
                      textEditingController: businessController.businessName,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Phone Number',
                                style: GoogleFonts.inter(
                                    color: Colors.black, fontSize: 12),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Text(
                                  "*",
                                  style: GoogleFonts.inter(
                                      color: Colors.red, fontSize: 12),
                                ),
                              ),
                            ],
                          )
                        ]),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: AppColors.backgroundColor, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showCountryCode(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                    right: BorderSide(
                                        color: AppColors.backgroundColor,
                                        width: 2)),
                              ),
                              height: 50,
                              width: 80,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: 10),
                                  Flag.fromString(countryFlag,
                                      height: 30, width: 30),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    size: 24,
                                    color: AppColors.backgroundColor
                                        .withOpacity(0.5),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextFormField(
                              enabled: false,
                              controller:
                                  businessController.businessPhoneNumber,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText:
                                      "${businessController.selectedBusiness.value!.businessPhoneNumber}",
                                  hintStyle: GoogleFonts.inter(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                  prefixText: "+$countryCode ",
                                  prefixStyle: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 30,
                      margin: EdgeInsets.only(
                        right: 20,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Email',
                            style: GoogleFonts.inter(
                                color: Colors.black, fontSize: 12),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ),
                    TextFormField(
                      controller: businessController.businessEmail,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        isDense: true,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        hintText:
                            "${businessController.selectedBusiness.value!.businessEmail}",
                        hintStyle:
                            Theme.of(context).textTheme.headline4!.copyWith(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.normal,
                                ),
                      ),
                    ),
                    CustomTextField(
                      label: "Address",
                      validatorText: "Address is needed",
                      colors: AppColors.blackColor,
                      hint:
                          "${businessController.selectedBusiness.value!.businessAddress}",
                      textEditingController:
                          businessController.businessAddressController,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Currency',
                          style: GoogleFonts.inter(
                              color: Colors.black, fontSize: 12),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '*',
                          style: GoogleFonts.inter(
                              color: Colors.red, fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 1,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            width: 2, color: AppColors.backgroundColor),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: value,
                          focusColor: AppColors.whiteColor,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.backgroundColor,
                          ),
                          iconSize: 30,
                          items: items.map(buildMenuItem).toList(),
                          onChanged: (value) =>
                              setState(() => this.value = value),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    teamController.teamMember.teamMemberStatus == 'CREATOR' ||
                            teamController.teamMember.authoritySet!
                                .contains('VIEW_BANK_INFO')
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Bank Accounts',
                                    style: GoogleFonts.inter(
                                        color: Colors.black, fontSize: 12),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (teamController
                                              .teamMember.teamMemberStatus ==
                                          'CREATOR' ||
                                      teamController.teamMember.authoritySet!
                                          .contains('CREATE_BANK_INFO')) {
                                    bankInfoController.clearValue();
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20))),
                                        context: context,
                                        builder: (context) => addBusiness());
                                  } else {
                                    Get.snackbar('Alert',
                                        'You need to be authorized to perform this operation');
                                  }
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      child: Image.asset(
                                        'assets/images/Group 3890.png',
                                        scale: 1.2,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Add Bank Account',
                                      style: GoogleFonts.inter(
                                          color: AppColors.backgroundColor,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    SizedBox(height: 20),
                    if (bankInfoController.addingBankStatus ==
                        AddingBankInfoStatus.UnAuthorized) ...[
                      Center(
                        child: Text(
                          'You need to be authorized\nto view this module',
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.orangeBorderColor,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ] else ...[
                      if (bankInfoController.offlineBusinessBank.isNotEmpty)
                        ...bankInfoController.offlineBusinessBank
                            .map((e) => BankCard(
                                item: e,
                                onDelete: () {
                                  if (teamController
                                              .teamMember.teamMemberStatus ==
                                          'CREATOR' ||
                                      teamController.teamMember.authoritySet!
                                          .contains('DELETE_BANK_INFO')) {
                                    print('deleting bank account...');
                                    bankInfoController.addToDeleteList(e);
                                  } else {
                                    Get.snackbar('Alert',
                                        'You need to be authorized to perform this operation');
                                  }
                                },
                                onEdit: () {
                                  if (teamController
                                              .teamMember.teamMemberStatus ==
                                          'CREATOR' ||
                                      teamController.teamMember.authoritySet!
                                          .contains('UPDATE_BANK_INFO')) {
                                    print('edit bank account');
                                    bankInfoController.setItem(e);
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20))),
                                        context: context,
                                        builder: (context) =>
                                            EditBankAccount(e));
                                  } else {
                                    Get.snackbar('Alert',
                                        'You need to be authorized to perform this operation');
                                  }
                                }))
                            .toList(),
                      if (bankInfoController.offlineBusinessBank.isEmpty)
                        Center(
                          child: Text(
                            'No bank account has been added yet',
                            style: GoogleFonts.inter(
                              color: AppColors.hintColor,
                              fontSize: 10,
                            ),
                          ),
                        ),
                    ],
                    SizedBox(
                      height: 10,
                    ),
                    Obx(() {
                      return InkWell(
                        onTap: () {
                          if (businessController.updateBusinessStatus !=
                              UpdateBusinessStatus.Loading)
                            businessController.updateBusiness(value!);
                        },
                        child: Container(
                          height: 50,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                              color: AppColors.backgroundColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: (businessController.updateBusinessStatus ==
                                  UpdateBusinessStatus.Loading)
                              ? Center(
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    child: Center(
                                        child: CircularProgressIndicator(
                                            color: Colors.white)),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Save',
                                      style: GoogleFonts.inter(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  ],
                                ),
                        ),
                      );
                    }),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget buildAddImage() => Obx(() {
        return Container(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.04,
              right: MediaQuery.of(context).size.width * 0.04,
              bottom: MediaQuery.of(context).size.width * 0.04,
              top: MediaQuery.of(context).size.width * 0.02),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 3,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Color(0xffE6F4F2),
                      shape: BoxShape.circle,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.close,
                        color: AppColors.backgroundColor,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 5),
              Text(
                'Upload Image',
                style: GoogleFonts.inter(
                  color: AppColors.blackColor,
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 100),
              GestureDetector(
                onTap: () async {
                  final ImagePicker _picker = ImagePicker();
                  // Pick an image
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  businessController.businessImage(File(image!.path));
                  print("image path ${image.path}");
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (businessController.businessImage.value != null)
                        ? Image.file(
                            businessController.businessImage.value!,
                            height: 150,
                            width: 150,
                          )
                        : SvgPicture.asset(
                            'assets/images/camera.svg',
                          ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Center(
                child: Text(
                  'Select from Device',
                  style: GoogleFonts.inter(
                    color: AppColors.blackColor,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: 55,
                  margin: EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  decoration: BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      'Done',
                      style: GoogleFonts.inter(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      });

  Widget addBusiness() {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter myState) {
      return SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.04,
            right: MediaQuery.of(context).size.width * 0.04,
          ),
          padding: MediaQuery.of(context).viewInsets,
          child: Form(
            key: addAccountKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 3,
                    width: 70,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Color(0xffE6F4F2),
                        shape: BoxShape.circle,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(
                          Icons.close,
                          color: AppColors.backgroundColor,
                        ),
                      ),
                    )
                  ],
                ),
                Text(
                  'Add Bank Account',
                  style: GoogleFonts.inter(
                    color: AppColors.blackColor,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: 10),
                CustomTextField(
                  label: "Account Number ",
                  validatorText: "Account Number required",
                  textEditingController:
                      bankInfoController.accoutNumberController,
                ),
                CustomTextField(
                  label: "Account holder Name",
                  validatorText: "Account holder Name required",
                  textEditingController:
                      bankInfoController.bankAccountNameController,
                ),
                CustomTextField(
                    label: "Bank Name",
                    validatorText: "Bank name required",
                    textEditingController:
                        bankInfoController.bankNameController),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Obx(() {
                  return GestureDetector(
                    onTap: () {
                      if (bankInfoController.addingBankStatus !=
                          AddingBankInfoStatus
                              .Loading) if (addAccountKey.currentState!
                          .validate()) {
                        bankInfoController.addBusinnessBank();
                      }
                    },
                    child: Container(
                      height: 55,
                      margin: EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
                      decoration: BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: (bankInfoController.addingBankStatus ==
                                AddingBankInfoStatus.Loading)
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                                'Add Bank Account',
                                style: GoogleFonts.inter(
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  );
                }),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget EditBankAccount(Bank item) =>
      StatefulBuilder(builder: (BuildContext context, StateSetter myState) {
        return Container(
          margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.04,
            right: MediaQuery.of(context).size.width * 0.04,
          ),
          padding: MediaQuery.of(context).viewInsets,
          child: Form(
            key: addAccountKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 6,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                CustomTextField(
                  label: "Account Number ",
                  validatorText: "Account Number required",
                  textEditingController:
                      bankInfoController.accoutNumberController,
                ),
                CustomTextField(
                  label: "Account holder Name",
                  validatorText: "Account holder Name required",
                  textEditingController:
                      bankInfoController.bankAccountNameController,
                ),
                CustomTextField(
                    label: "Bank Name",
                    validatorText: "Bank name required",
                    textEditingController:
                        bankInfoController.bankNameController),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Obx(() {
                  return GestureDetector(
                    onTap: () {
                      if (bankInfoController.addingBankStatus !=
                          AddingBankInfoStatus
                              .Loading) if (addAccountKey.currentState!
                          .validate()) {
                        bankInfoController.updateBusinessBank(item);
                      }
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: (bankInfoController.addingBankStatus ==
                                AddingBankInfoStatus.Loading)
                            ? Container(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                    color: Colors.white))
                            : Text(
                                'Update Bank Account',
                                style: GoogleFonts.inter(
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  );
                }),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                )
              ],
            ),
          ),
        );
      });
  // ignore: unused_element
  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(
              horizontal: 50,
              vertical: 250,
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    'We will send a one-time password to verify it\'s really you',
                    style: GoogleFonts.inter(
                      color: AppColors.orangeBorderColor,
                      fontWeight: FontWeight.normal,
                      fontSize: 9,
                    ),
                  ),
                ),
              ],
            ),
            content: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Text(
                      'Enter New Number',
                      style:
                          GoogleFonts.inter(color: Colors.black, fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: AppColors.backgroundColor, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showCountryCode(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                  right: BorderSide(
                                      color: AppColors.backgroundColor,
                                      width: 2)),
                            ),
                            height: 50,
                            width: 80,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 10),
                                Flag.fromString(countryFlag,
                                    height: 30, width: 30),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  size: 24,
                                  color: AppColors.backgroundColor
                                      .withOpacity(0.5),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "8123456789",
                                hintStyle: GoogleFonts.inter(
                                    color: Colors.black.withOpacity(0.5),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                                prefixText: "+$countryCode ",
                                prefixStyle: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black)),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 45,
                        width: 100,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            border: Border.all(
                              width: 2,
                              color: AppColors.backgroundColor,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.inter(
                              color: AppColors.backgroundColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _otpDialog(context);
                      },
                      child: Container(
                        height: 45,
                        width: 100,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                            color: AppColors.backgroundColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            'Continue',
                            style: GoogleFonts.inter(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
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

  _otpDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(
              horizontal: 50,
              vertical: 235,
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    'We will send a one-time password to verify it\'s really you',
                    style: GoogleFonts.inter(
                      color: AppColors.orangeBorderColor,
                      fontWeight: FontWeight.normal,
                      fontSize: 9,
                    ),
                  ),
                ),
              ],
            ),
            content:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              // SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Container(
                margin: EdgeInsets.only(
                  left: 20,
                ),
                child: Text(
                  "Enter OTP sent to your phone",
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: PinCodeTextField(
                  length: 4,
                  obscureText: true,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    inactiveColor: AppColors.backgroundColor,
                    activeColor: AppColors.backgroundColor,
                    selectedColor: AppColors.backgroundColor,
                    selectedFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 50,
                    activeFillColor: Colors.white,
                  ),
                  animationDuration: Duration(milliseconds: 300),
                  backgroundColor: Colors.white,
                  enableActiveFill: true,
                  errorAnimationController: errorController,
                  // controller: textEditingController,
                  onCompleted: (v) {
                    print("Completed");
                  },
                  onChanged: (value) {
                    print(value);
                    // setState(() {
                    //   currentText = value;
                    // });
                  },
                  beforeTextPaste: (text) {
                    print("Allowing to paste $text");
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },
                  appContext: context,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Send as Voice Call",
                style: GoogleFonts.inter(
                    color: AppColors.backgroundColor, fontSize: 12),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Resend via sms",
                style:
                    GoogleFonts.inter(color: Color(0xffEF6500), fontSize: 12),
              ),
            ]),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 45,
                        width: 100,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            border: Border.all(
                              width: 2,
                              color: AppColors.backgroundColor,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.inter(
                              color: AppColors.backgroundColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _successDialog(context);
                      },
                      child: Container(
                        height: 45,
                        width: 100,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                            color: AppColors.backgroundColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            'Continue',
                            style: GoogleFonts.inter(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  _successDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(
              horizontal: 50,
              vertical: 235,
            ),
            title: Center(
              child: Text(
                'Phone Number successfully Changed',
                style: GoogleFonts.inter(
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            ),
            content: Column(
              children: [
                Image.asset(
                  'assets/images/checker.png',
                  scale: 1.5,
                ),
              ],
            ),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 25, right: 55, bottom: 20),
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    height: 45,
                    width: 150,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        'Continue',
                        style: GoogleFonts.inter(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              item,
              style: GoogleFonts.inter(fontSize: 14),
            ),
          ),
        ),
      );
}
