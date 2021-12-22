import 'dart:async';

import 'package:country_picker/country_picker.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/bank_account_repository.dart';
import 'package:huzz/app/screens/settings/itemCard.dart';
import 'package:huzz/app/screens/widget/custom_form_field.dart';
import 'package:huzz/model/bank.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../colors.dart';

class BusinessInfo extends StatefulWidget {
  BusinessInfo({Key? key});

  @override
  _BusinessInfoState createState() => _BusinessInfoState();
}

class _BusinessInfoState extends State<BusinessInfo> {
  final TextEditingController textEditingController = TextEditingController();
  final bankInfoController=Get.find<BankAccountRepository>();
  String countryFlag = "NG";
  String countryCode = "234";
  final addAccountKey=GlobalKey<FormState>();

  final items = [
    'Box',
    'feet',
    'kilogram',
    'meters',
  ];

  String? value;

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
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
        backgroundColor: AppColor().whiteColor,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: AppColor().backgroundColor,
          ),
        ),
        title: Text(
          "Business account settings",
          style: TextStyle(
            color: AppColor().backgroundColor,
            fontSize: 18,
          ),
        ),
        elevation: 0,
      ),
      body: Obx(
     (){
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/Group 3647.png',
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Center(
                  child: Text(
                    "Business Logo",
                    style: TextStyle(
                      color: AppColor().blackColor,
                      fontSize: 12,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                CustomTextField(
                  label: "Business Name",
                  validatorText: "Business name is needed",
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20, top: 9),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Phone Number',
                                  style:
                                      TextStyle(color: Colors.black, fontSize: 12),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: Text(
                                    "*",
                                    style:
                                        TextStyle(color: Colors.red, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: AppColor().backgroundColor, width: 2.0),
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
                                          color: AppColor().backgroundColor,
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
                                      color: AppColor()
                                          .backgroundColor
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
                                    hintText: "9034678966",
                                    hintStyle: TextStyle(
                                        color: Colors.black.withOpacity(0.5),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                    prefixText: "+$countryCode ",
                                    prefixStyle: TextStyle(
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
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  label: "Email",
                  validatorText: "Email required",
                ),
                CustomTextField(
                  label: "Address",
                  validatorText: "Address is needed",
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Currency',
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 1,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2, color: AppColor().backgroundColor),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: value,
                      focusColor: AppColor().whiteColor,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColor().backgroundColor,
                      ),
                      iconSize: 30,
                      items: items.map(buildMenuItem).toList(),
                      onChanged: (value) => setState(() => this.value = value),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Bank Accounts',
                            style: TextStyle(color: Colors.black, fontSize: 12),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          
                          bankInfoController.clearValue();
                          showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20))),
                            context: context,
                            builder: (context) => addBusiness());},
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
                              style: TextStyle(
                                  color: AppColor().backgroundColor, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
              (bankInfoController.offlineBusinessBank.isNotEmpty)?
              Expanded(child: ListView.builder(
                itemCount: bankInfoController.offlineBusinessBank.length,
                itemBuilder: (_,index){
                  var ite=bankInfoController.offlineBusinessBank[index];
                 return ItemCard(item: ite,onDelete: (){
                 bankInfoController.addToDeleteList(ite);
                 },onEdit:(){

                  bankInfoController.setItem(ite);
                  showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20))),
                            context: context,
                            builder: (context) =>  EditBankAccount(ite));
                
                 });
                }
                

              ))
              :  
                Center(
                  child: Text(
                    'No bank account has been added yet',
                    style: TextStyle(
                      color: AppColor().hintColor,
                      fontSize: 10,
                    ),
                  ),
                ),
                // Spacer(),
                InkWell(
                  onTap: () {
                    // Get.to(Confirmation());
                  },
                  child: Container(
                    height: 55,
                    margin: EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    decoration: BoxDecoration(
                        color: AppColor().backgroundColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        'Save',
                        style: TextStyle(
                          color: AppColor().whiteColor,
                          fontFamily: 'DMSans',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  Widget addBusiness() => Container(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.04,
            right: MediaQuery.of(context).size.width * 0.04,
            bottom: MediaQuery.of(context).size.width * 0.04,
            top: MediaQuery.of(context).size.width * 0.02),
        child: Form(
          key:addAccountKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
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
                      onTap:(){
                       Get.back();
                      },
                      child: Icon(
                        Icons.close,
                        color: AppColor().backgroundColor,
                      ),
                    ),
                  )
                ],
              ),
              Text(
                'Add Bank Account',
                style: TextStyle(
                  color: AppColor().blackColor,
                  fontFamily: 'DMSans',
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 10),
              CustomTextField(
                label: "Account Number ",
                validatorText: "Account Number required",
                textEditingController: bankInfoController.accoutNumberController,
                
              ),
              CustomTextField(
                label: "Account holder Name",
                validatorText: "Account holder Name required",
                textEditingController: bankInfoController.bankAccountNameController,
              ),
              CustomTextField(
                label: "Bank Name",
                validatorText: "Bank name required",
                textEditingController:bankInfoController.bankNameController
              ),
              Spacer(),
             Obx(()
                {
                  return GestureDetector(
                    onTap: (){
                      if(bankInfoController.addingBankStatus!=AddingBankInfoStatus.Loading)
                      if(addAccountKey.currentState!.validate()){

                         bankInfoController.addBusinnessBank();
                      }
                    },
                    child: Container(
                      height: 55,
                      margin: EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      decoration: BoxDecoration(
                          color: AppColor().backgroundColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child:(bankInfoController.addingBankStatus==AddingBankInfoStatus.Loading)?
                        CircularProgressIndicator(
                            color: Colors.white)
                        : Text(
                          'Add Bank Account',
                          style: TextStyle(
                            color: AppColor().whiteColor,
                            fontFamily: 'DMSans',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }
              ),
            ],
          ),
        ),
      );



       Widget EditBankAccount(Bank item) => Container(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.04,
            right: MediaQuery.of(context).size.width * 0.04,
            bottom: MediaQuery.of(context).size.width * 0.04,
            top: MediaQuery.of(context).size.width * 0.02),
        child: Form(
          key:addAccountKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
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
                  GestureDetector(
                    onTap:(){
                    Get.back(); 
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Color(0xffE6F4F2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: AppColor().backgroundColor,
                      ),
                    ),
                  )
                ],
              ),
              Text(
                'Add Bank Account',
                style: TextStyle(
                  color: AppColor().blackColor,
                  fontFamily: 'DMSans',
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 10),
              CustomTextField(
                label: "Account Number ",
                validatorText: "Account Number required",
                textEditingController: bankInfoController.accoutNumberController,
                
              ),
              CustomTextField(
                label: "Account holder Name",
                validatorText: "Account holder Name required",
                textEditingController: bankInfoController.bankAccountNameController,
              ),
              CustomTextField(
                label: "Bank Name",
                validatorText: "Bank name required",
                textEditingController:bankInfoController.bankNameController
              ),
              Spacer(),
             Obx(()
                {
                  return GestureDetector(
                    onTap: (){
                      if(bankInfoController.addingBankStatus!=AddingBankInfoStatus.Loading)
                      if(addAccountKey.currentState!.validate()){

                         bankInfoController.updateBusinessBank(item);
                      }
                    },
                    child: Container(
                      height: 55,
                      margin: EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      decoration: BoxDecoration(
                          color: AppColor().backgroundColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child:(bankInfoController.addingBankStatus==AddingBankInfoStatus.Loading)?
                        CircularProgressIndicator(
                            color: Colors.white)
                        : Text(
                          'Edit Bank Account',
                          style: TextStyle(
                            color: AppColor().whiteColor,
                            fontFamily: 'DMSans',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }
              ),
            ],
          ),
        ),
      );
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
                    style: TextStyle(
                      color: AppColor().orangeBorderColor,
                      fontFamily: 'DMSans',
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
                      style: TextStyle(color: Colors.black, fontSize: 12),
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
                          color: AppColor().backgroundColor, width: 2.0),
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
                                      color: AppColor().backgroundColor,
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
                                  color: AppColor()
                                      .backgroundColor
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
                                hintText: "9034678966",
                                hintStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.5),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                                prefixText: "+$countryCode ",
                                prefixStyle: TextStyle(
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
                            color: AppColor().whiteColor,
                            border: Border.all(
                              width: 2,
                              color: AppColor().backgroundColor,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: AppColor().backgroundColor,
                              fontFamily: 'DMSans',
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
                            color: AppColor().backgroundColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            'Continue',
                            style: TextStyle(
                              color: AppColor().whiteColor,
                              fontFamily: 'DMSans',
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
                    style: TextStyle(
                      color: AppColor().orangeBorderColor,
                      fontFamily: 'DMSans',
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
                  style: TextStyle(
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
                    inactiveColor: AppColor().backgroundColor,
                    activeColor: AppColor().backgroundColor,
                    selectedColor: AppColor().backgroundColor,
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
                style:
                    TextStyle(color: AppColor().backgroundColor, fontSize: 12),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Resend via sms",
                style: TextStyle(color: Color(0xffEF6500), fontSize: 12),
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
                            color: AppColor().whiteColor,
                            border: Border.all(
                              width: 2,
                              color: AppColor().backgroundColor,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: AppColor().backgroundColor,
                              fontFamily: 'DMSans',
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
                            color: AppColor().backgroundColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            'Continue',
                            style: TextStyle(
                              color: AppColor().whiteColor,
                              fontFamily: 'DMSans',
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
                style: TextStyle(
                  color: AppColor().blackColor,
                  fontFamily: 'DMSans',
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
                        color: AppColor().backgroundColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          color: AppColor().whiteColor,
                          fontFamily: 'DMSans',
                          fontWeight: FontWeight.bold,
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
            border: Border.all(
              width: 1,
              color: Color(0xffCFD1D2),
            ),
            borderRadius: BorderRadius.circular(10),
            color: Color(0xffDCF2EF),
          ),
          child: Center(
            child: Text(
              item,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
      );
}
