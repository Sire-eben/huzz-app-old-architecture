import 'dart:async';
import 'package:country_currency_pickers/utils/utils.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/data/repository/auth_respository.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/ui/forget_pass/forgot_pin.dart';
import 'package:huzz/ui/reg_home.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class Signin extends StatefulWidget {
  _SiginState createState() => _SiginState();
}

class _SiginState extends State<Signin> {
  final _authController = Get.find<AuthRepository>();
  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  String countryFlag = "NG";
  String countryCode = "234";

  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    _authController.pinController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // errorController!.close();
    // _authController.phoneNumberController.dispose();
    // _authController.pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.whiteColor,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40,
            ),
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.backgroundColor,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
                child: Text(
              "Welcome back",
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                  color: AppColors.backgroundColor),
            )),
            const SizedBox(
              height: 20,
            ),
            Center(
                child: Text(
              "Keep your business going with Huzz",
              style: GoogleFonts.inter(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            )),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Container(
                margin: const EdgeInsets.only(
                  left: 20,
                ),
                child: Text(
                  "Phone Number",
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                )),
            const SizedBox(
              height: 10,
            ),

            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                border:
                    Border.all(color: AppColors.backgroundColor, width: 2.0),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(
                              color: AppColors.backgroundColor, width: 2),
                        ),
                      ),
                      height: 50,
                      width: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 10),
                          Flag.fromString(countryFlag, height: 30, width: 30),
                          const SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            size: 24,
                            color: AppColors.backgroundColor.withOpacity(0.5),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: _authController.phoneNumberController,
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
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 20),
              child: Text(
                "Enter your 4 digits PIN",
                style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                margin: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: PinCodeTextField(
                  keyboardType: TextInputType.number,
                  length: 4,
                  obscureText: true,
                  animationType: AnimationType.fade,
                  controller: _authController.pinController,
                  pinTheme: PinTheme(
                    inactiveColor: AppColors.backgroundColor,
                    activeColor: AppColors.backgroundColor,
                    selectedColor: AppColors.backgroundColor,
                    selectedFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 70,
                    fieldWidth: 70,
                    activeFillColor: Colors.white,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  errorAnimationController: errorController,
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
            // SizedBox(height: 40),
            // GestureDetector(
            //   onTap: () {
            //     Get.to(FingerPrint());
            //   },
            //   child: Container(
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Icon(
            //           Icons.fingerprint,
            //           color: AppColors.backgroundColor,
            //         ),
            //         SizedBox(
            //           width: 10,
            //         ),
            //         Text(
            //           "SIGN IN WITH YOUR FINGERPRINT",
            //           style: GoogleFonts.inter(
            //             color: AppColors.backgroundColor,
            //             fontSize: 12,
            //             fontWeight: FontWeight.w700,
            //           ),
            //         )
            //       ],
            //     ),
            //   ),
            // ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(ForgotPIN());
                  },
                  child: Text(
                    "Forgot PIN?",
                    style: GoogleFonts.inter(
                      color: AppColors.orangeBorderColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(RegHome());
                  },
                  child: Text(
                    "Sign up",
                    style: GoogleFonts.inter(
                      color: AppColors.backgroundColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const Expanded(child: SizedBox()),
            Obx(() {
              return GestureDetector(
                onTap: () {
                  if (_authController.phoneNumberController.text == '') {
                    Get.snackbar(
                        'Alert', 'Enter your phone number to continue!',
                        titleText: const Text(
                          'Alert',
                          // style: AppThemes.style14blackBold,
                        ),
                        messageText: const Text(
                          'Enter your phone number to continue!',
                          // style: AppThemes.style14black,
                        ),
                        icon: const Icon(Icons.info,
                            color: AppColors.orangeBorderColor));
                    print('phone cannot be empty');
                  } else if (_authController.signinStatus !=
                      SigninStatus.Loading) _authController.signIn();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 50, right: 50),
                  height: 50,
                  decoration: const BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: (_authController.signinStatus == SigninStatus.Loading)
                      ? Container(
                          width: 30,
                          height: 30,
                          child: const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white)),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Login',
                              style: GoogleFonts.inter(
                                  color: Colors.white, fontSize: 18),
                            ),
                          ],
                        ),
                ),
              );
            }),
            const SizedBox(
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
