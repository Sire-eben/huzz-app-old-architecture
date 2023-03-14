import 'dart:async';
import 'package:country_currency_pickers/utils/utils.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/mixins/form_mixin.dart';
import 'package:huzz/core/util/validators.dart';
import 'package:huzz/core/widgets/app_bar.dart';
import 'package:huzz/core/widgets/button/button.dart';
import 'package:huzz/core/widgets/textfield/textfield.dart';
import 'package:huzz/core/widgets/unfocus_scope.dart';
import 'package:huzz/data/repository/auth_respository.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/ui/forget_pass/forgot_pin.dart';
import 'package:huzz/ui/auth/reg_home.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  _SiginState createState() => _SiginState();
}

class _SiginState extends State<Signin> {
  final _authController = Get.find<AuthRepository>();
  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  String countryFlag = "NG";
  String countryCode = "234";

  @override
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
      extendBodyBehindAppBar: true,
      appBar: Appbar(
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: UnfocusScope(
          child: Padding(
            padding: const EdgeInsets.all(Insets.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(Insets.xl * 3),
                Center(
                    child: Text(
                  "Welcome back",
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                      color: AppColors.backgroundColor),
                )),
                const Gap(Insets.lg),
                const Center(
                    child: Text("Keep your business going with Huzz",
                        style: TextStyles.b2)),
                const Gap(Insets.xl * 2),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Phone Number",
                    style: TextStyles.b2,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: context.width,
                  height: 68,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: AppColors.backgroundColor, width: 2.0),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                        child: TextInputField(
                          controller: _authController.phoneNumberController,
                          validator: Validators.validatePhoneNumber(),
                          inputType: TextInputType.number,
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            border: InputBorder.none,
                            hintText: "8123456789",
                            hintStyle: TextStyles.t3,
                            prefixText: "+$countryCode ",
                            prefixStyle: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
                const Gap(Insets.lg),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Enter your 4 digits PIN",
                    style: TextStyles.b2,
                  ),
                ),
                const Gap(Insets.md),
                Center(
                  child: PinCodeTextField(
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
                    keyboardType: TextInputType.number,
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    errorAnimationController: errorController,
                    onCompleted: (v) {
                      // print("Completed");
                    },
                    onChanged: (value) {
                      // setState(() {
                      //   currentText = value;
                      // });
                    },
                    beforeTextPaste: (text) {
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    },
                    appContext: context,
                  ),
                ),
                const Gap(Insets.lg),
                InkWell(
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
                const Gap(Insets.lg),
                InkWell(
                  onTap: () {
                    Get.to(const RegHome());
                  },
                  child: Text(
                    "Don't have an account? Sign up",
                    style: GoogleFonts.inter(
                      color: AppColors.backgroundColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Gap(Insets.lg),
                Obx(() {
                  return Button(
                    label: "Login",
                    showLoading:
                        _authController.signinStatus == SigninStatus.Loading
                            ? true
                            : false,
                    action: () {
                      if (_authController.phoneNumberController.text.isEmpty) {
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
                      } else if (_authController.signinStatus !=
                          SigninStatus.Loading) {
                        _authController.signIn();
                      }
                    },
                  );
                }),
                // Obx(() {
                //   return GestureDetector(
                //     onTap: () {
                //       if (_authController.phoneNumberController.text == '') {
                //         Get.snackbar(
                //             'Alert', 'Enter your phone number to continue!',
                //             titleText: const Text(
                //               'Alert',
                //               // style: AppThemes.style14blackBold,
                //             ),
                //             messageText: const Text(
                //               'Enter your phone number to continue!',
                //               // style: AppThemes.style14black,
                //             ),
                //             icon: const Icon(Icons.info,
                //                 color: AppColors.orangeBorderColor));
                //         print('phone cannot be empty');
                //       } else if (_authController.signinStatus !=
                //           SigninStatus.Loading) _authController.signIn();
                //     },
                //     child: Container(
                //       width: MediaQuery.of(context).size.width,
                //       margin: const EdgeInsets.only(left: 50, right: 50),
                //       height: 50,
                //       decoration: const BoxDecoration(
                //           color: AppColors.backgroundColor,
                //           borderRadius:
                //               BorderRadius.all(Radius.circular(10))),
                //       child: (_authController.signinStatus ==
                //               SigninStatus.Loading)
                //           ? Container(
                //               width: 30,
                //               height: 30,
                //               child: const Center(
                //                   child: CircularProgressIndicator(
                //                       color: Colors.white)),
                //             )
                //           : Row(
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               crossAxisAlignment: CrossAxisAlignment.center,
                //               children: [
                //                 Text(
                //                   'Login',
                //                   style: GoogleFonts.inter(
                //                       color: Colors.white, fontSize: 18),
                //                 ),
                //               ],
                //             ),
                //     ),
                //   );
                // }),

                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
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
        setState(() {});
      },
    );
  }
}
