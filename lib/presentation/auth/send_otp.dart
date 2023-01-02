import 'package:country_picker/country_picker.dart';
import 'package:flag/flag.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/data/repository/auth_respository.dart';
import 'package:huzz/presentation/auth/sign_in.dart';
import 'package:huzz/presentation/privacy_policy.dart';
import 'package:huzz/presentation/terms_of_use.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'sign_up.dart';

class SendOtp extends StatefulWidget {
  const SendOtp({super.key});

  @override
  _SendOtpState createState() => _SendOtpState();
}

class _SendOtpState extends State<SendOtp> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _authController = Get.find<AuthRepository>();
  String countryFlag = "NG";
  String countryCode = "234";

  @override
  void initState() {
    super.initState();
    _authController.countryText = countryCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.whiteColor,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Form(
          key: _formKey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
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
                    border: Border.all(
                        color: AppColors.backgroundColor, width: 2.0),
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
                                    color: AppColors.backgroundColor,
                                    width: 2)),
                            // borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20))
                          ),
                          height: 50,
                          width: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 10),
                              Flag.fromString(countryFlag,
                                  height: 30, width: 30),
                              const SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                size: 24,
                                color:
                                    AppColors.backgroundColor.withOpacity(0.5),
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
                const Expanded(child: SizedBox()),
                GestureDetector(
                  onTap: () {
                    Get.to(SignIn());
                  },
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                          text: "Already have an account? ",
                          children: [
                            TextSpan(
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.backgroundColor,
                              ),
                              text: "Sign in",
                            )
                          ]),
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
                Container(
                    margin: const EdgeInsets.only(left: 50, right: 50),
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: "By clicking Continue, you agree to our ",
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.black,
                                letterSpacing: 1),
                            children: [
                              TextSpan(
                                text: "Terms of use ",
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppColors.backgroundColor,
                                  letterSpacing: 0.5,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = termOfUse,
                              ),
                              TextSpan(
                                text: "and ",
                                style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: Colors.black,
                                    letterSpacing: 1),
                              ),
                              TextSpan(
                                text: "and Privacy policy",
                                style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppColors.backgroundColor,
                                    letterSpacing: 0.5),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = privacyPolicy,
                              )
                            ]))),
                const SizedBox(
                  height: 20,
                ),
                Obx(() {
                  return GestureDetector(
                    onTap: () {
                      if (_authController.phoneNumberController.text == '') {
                        Get.snackbar(
                            'Alert', 'Enter your phone number to continue!',
                            titleText: const Text(
                              'Alert',
                            ),
                            messageText: const Text(
                              'Enter your phone number to continue!',
                            ),
                            icon: const Icon(Icons.info,
                                color: AppColors.orangeBorderColor));
                        // print('phone cannot be empty');
                      } else if (_authController
                              .phoneNumberController.text.length >
                          10) {
                        Get.snackbar('Alert', 'Invalid phone number!',
                            titleText: const Text(
                              'Alert',
                            ),
                            messageText: const Text(
                              'Invalid phone number!',
                            ),
                            icon: const Icon(Icons.info,
                                color: AppColors.orangeBorderColor));
                        // print('phone cannot be empty');
                      } else {
                        // _authController.sendSmsOtp();
                        // _homeController.selectOnboardSelectedNext();
                        Get.to(() => SignUp());
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(left: 50, right: 50),
                      height: 50,
                      decoration: const BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: (_authController.Otpauthstatus ==
                              OtpAuthStatus.Loading)
                          ? const SizedBox(
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
                                  'Continue',
                                  style: GoogleFonts.inter(
                                      color: Colors.white, fontSize: 18),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50))),
                                  child: const Icon(
                                    Icons.arrow_forward,
                                    color: AppColors.backgroundColor,
                                    size: 16,
                                  ),
                                )
                              ],
                            ),
                    ),
                  );
                }),
                const SizedBox(
                  height: 40,
                )
              ]),
        ),
      ),
    );
  }

  Future termOfUse() async {
    Get.to(TermsOfUse());
  }

  Future privacyPolicy() async {
    Get.to(const PrivacyPolicy());
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
}
