// ignore_for_file: close_sinks

import 'dart:async';
import 'package:country_picker/country_picker.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/data/repository/auth_respository.dart';
import 'package:huzz/ui/widget/custom_form_field.dart';
import 'package:huzz/data/model/user.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:huzz/core/constants/app_themes.dart';
import '../widget/timer_button.dart';

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

    email = _controller.user!.email ?? '';
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
          "Personal Information",
          style: GoogleFonts.inter(
            color: AppColors.backgroundColor,
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
              colors: AppColors.blackColor,
              keyType: TextInputType.name,
              textEditingController: _controller.firstNameController,
            ),
            CustomTextField(
              label: "Last Name",
              validatorText: "Last name is needed",
              hint: lastName,
              colors: AppColors.blackColor,
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
                                  color: AppColors
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
                            enabled: false,
                            controller: _controller.updatePhoneNumberController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: phone,
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
              colors: AppColors.blackColor,
              keyType: TextInputType.emailAddress,
              textEditingController: _controller.emailController,
            ),
            SizedBox(
              height: 25,
            ),
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
                      color: AppColors.backgroundColor,
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
                              style: GoogleFonts.inter(
                                  color: Colors.white, fontSize: 18),
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

  // ignore: unused_element
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
                  controller: _controller.otpController,
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
                  errorAnimationController: otpErrorController,
                  onCompleted: (v) {
                    print("Completed");
                  },
                  onChanged: (value) {
                    print(value);
                  },
                  beforeTextPaste: (text) {
                    print("Allowing to paste $text");
                    return true;
                  },
                  appContext: context,
                ),
              ),
              TimerButton(
                label: "Send as Voice Call",
                timeOutInSeconds: 20,
                activeTextStyle: GoogleFonts.inter(
                    color: AppColors.backgroundColor, fontSize: 12),
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
                    GoogleFonts.inter(color: Color(0xffEF6500), fontSize: 12),
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
}
