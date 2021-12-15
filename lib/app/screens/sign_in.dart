import 'dart:async';

import 'package:country_currency_pickers/utils/utils.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/auth_respository.dart';
import 'package:huzz/colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'fingerprint.dart';
import 'forget_pass/forgot_pin.dart';
import 'reg_home.dart';

class Signin extends StatefulWidget {
  _SiginState createState() => _SiginState();
}

class _SiginState extends State<Signin> {
  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  String countryFlag = "NG";
  final _loginKey = GlobalKey<FormState>();
  String countryCode = "234";
  final _authController = Get.find<AuthRepository>();
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    // errorController!.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  Icons.arrow_back,
                  color: AppColor().backgroundColor,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Center(
                child: Text(
              "Welcome back",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                  color: AppColor().backgroundColor),
            )),
            SizedBox(
              height: 20,
            ),
            Center(
                child: Text(
              "Keep your business going with Huzz",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.w400),
            )),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Container(
                margin: EdgeInsets.only(
                  left: 20,
                ),
                child: Text(
                  "Phone Number",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                border:
                    Border.all(color: AppColor().backgroundColor, width: 2.0),
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
                                color: AppColor().backgroundColor, width: 2)),
                        // borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20))
                      ),
                      height: 50,
                      width: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 10),
                          Flag.fromString(countryFlag, height: 30, width: 30),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            size: 24,
                            color: AppColor().backgroundColor.withOpacity(0.5),
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
                      controller: _authController.phoneNumberController,
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
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 20),
              child: Text(
                "Enter your 4 digits PIN",
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                margin: EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: PinCodeTextField(
                  length: 4,
                  obscureText: true,
                  animationType: AnimationType.fade,
                  controller: _authController.pinController,
                  pinTheme: PinTheme(
                    inactiveColor: AppColor().backgroundColor,
                    activeColor: AppColor().backgroundColor,
                    selectedColor: AppColor().backgroundColor,
                    selectedFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 70,
                    fieldWidth: 70,
                    activeFillColor: Colors.white,
                  ),
                  animationDuration: Duration(milliseconds: 300),
                  // backgroundColor: Colors.white,
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
            ),
            SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                Get.to(FingerPrint());
              },
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.fingerprint,
                      color: AppColor().backgroundColor,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "SIGN IN WITH YOUR FINGERPRINT",
                      style: TextStyle(
                        color: AppColor().backgroundColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 120),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(ForgotPIN());
                    },
                    child: Container(
                      child: Text(
                        "Forgot PIN?",
                        style: TextStyle(
                          color: AppColor().orangeBorderColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(RegHome());
                    },
                    child: Container(
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                          color: AppColor().backgroundColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: SizedBox()),
            Obx(() {
              return GestureDetector(
                onTap: () {
                  if (_authController.signinStatus != SigninStatus.Loading)
                    _authController.signIn();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 50, right: 50),
                  height: 50,
                  decoration: BoxDecoration(
                      color: AppColor().backgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: (_authController.signinStatus == SigninStatus.Loading)
                      ? Container(
                          width: 30,
                          height: 30,
                          child: Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white)),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Login',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),

                            //  Container(padding: EdgeInsets.all(3),
                            //    decoration:BoxDecoration(
                            //      color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(50))

                            //    ),
                            //    child: Icon(Icons.arrow_forward,color: AppColor().backgroundColor,size: 16,),
                            //  )
                          ],
                        ),
                ),
              );
            }),
            SizedBox(
              height: 30,
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
        final currency = CountryPickerUtils.getCountryByIsoCode(countryFlag)
            .currencyCode
            .toString();
        print("currency of country is $currency");
        setState(() {});

        print('Select country: ${country.toJson()}');
      },
    );
  }
}
