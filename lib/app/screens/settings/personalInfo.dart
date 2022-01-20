// ignore_for_file: close_sinks

import 'dart:async';

import 'package:country_picker/country_picker.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/auth_respository.dart';
import 'package:huzz/app/screens/widget/custom_form_field.dart';
import 'package:huzz/model/user.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:timer_button/timer_button.dart';

import '../../../colors.dart';

class PersonalInfo extends StatefulWidget {
  PersonalInfo({Key? key});

  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  final _controller = Get.find<AuthRepository>();
  String countryFlag = "NG";
  String countryCode = "234";

  late String email;
  late String phone;
  late String? lastName;
  late String? firstName;

  final users = Rx(User());
  User? get usersData => users.value;

  StreamController<ErrorAnimationType>? errorController;
  StreamController<ErrorAnimationType>? otpErrorController;

  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    otpErrorController = StreamController<ErrorAnimationType>();

    email = _controller.user!.email!;
    firstName = _controller.user!.firstName!;
    lastName = _controller.user!.lastName!;
    phone = _controller.user!.phoneNumber!;
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
          "Personal Information",
          style: TextStyle(
            color: AppColor().backgroundColor,
            fontSize: 18,
          ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              label: "First Name",
              validatorText: "First name is needed",
              hint: firstName,
              colors: AppColor().blackColor,
              keyType: TextInputType.name,
              textEditingController: _controller.firstNameController,
            ),
            CustomTextField(
              label: "Last Name",
              validatorText: "Last name is needed",
              hint: lastName,
              colors: AppColor().blackColor,
              keyType: TextInputType.name,
              textEditingController: _controller.lastNameController,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Phone Number',
                            style: TextStyle(color: Colors.black, fontSize: 12),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Text(
                              "*",
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
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
                            controller: _controller.updatePhoneNumberController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: phone,
                                hintStyle: TextStyle(
                                    color: Colors.black,
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
              hint: email,
              colors: AppColor().blackColor,
              keyType: TextInputType.emailAddress,
              textEditingController: _controller.emailController,
            ),
            SizedBox(
              height: 25,
            ),
            // Center(
            //   child: SvgPicture.asset(
            //     'assets/images/image-signature.svg',
            //     // height: 50,
            //   ),
            // ),
            Spacer(),
            Obx(() {
              return InkWell(
                onTap: () {
                  if (_controller.updateProfileStatus !=
                      UpdateProfileStatus.Loading) _controller.updateProfile();
                },
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      color: AppColor().backgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: (_controller.updateProfileStatus ==
                          UpdateProfileStatus.Loading)
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ],
                        ),
                ),
              );
            }),
            SizedBox(
              height: 40,
            ),
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
                  controller: _controller.otpController,
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
                  errorAnimationController: otpErrorController,
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
              TimerButton(
                label: "Send as Voice Call",
                timeOutInSeconds: 20,
                activeTextStyle:
                    TextStyle(color: AppColor().backgroundColor, fontSize: 12),
                onPressed: () {
                  _controller.sendVoiceOtp();
                },
                buttonType: ButtonType.TextButton,
                disabledColor: Colors.white,
                color: Colors.transparent,
              ),
              TimerButton(
                label: "Resend via sms",
                timeOutInSeconds: 20,
                activeTextStyle:
                    TextStyle(color: Color(0xffEF6500), fontSize: 12),
                onPressed: () {
                  _controller.sendSmsOtp(isresend: true);
                },
                buttonType: ButtonType.TextButton,
                disabledColor: Colors.white,
                color: Colors.transparent,
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
                        _controller.verifyForgotOpt();
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
}
