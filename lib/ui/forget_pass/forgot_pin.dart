import 'dart:async';
import 'package:country_currency_pickers/country_pickers.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/widgets/button/button.dart';
import 'package:huzz/data/repository/auth_respository.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:huzz/core/constants/app_themes.dart';

class ForgotPIN extends StatefulWidget {
  const ForgotPIN({super.key});

  @override
  State<ForgotPIN> createState() => _ForgotPINState();
}

class _ForgotPINState extends State<ForgotPIN> {
  final _authController = Get.find<AuthRepository>();
  StreamController<ErrorAnimationType>? errorController;

  String countryFlag = "NG";
  String countryCode = "234";

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();
    _authController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_authController.Otpverifystatus == OtpVerifyStatus.Error) {
        errorController!.add(ErrorAnimationType.shake);
      }

      return Scaffold(
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Positioned(
                          top: 20,
                          child: SvgPicture.asset('assets/images/Vector.svg')),
                      Positioned(
                        top: 50,
                        left: 20,
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
                    ],
                  ),
                ),
                Center(
                  child: Text('Forgot Pin',
                      style: GoogleFonts.inter(
                          color: AppColors.orangeBorderColor,
                          fontSize: 28,
                          fontWeight: FontWeight.w500)),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 50, right: 50),
                  child: Text(
                    'To make sure it’s really you, we’ll send a secret code to your phone number via SMS',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(
                  height: 10
                ),
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
                          controller:
                              _authController.forgotPhoneNumberController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
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
                const Expanded(child: SizedBox()),
                Padding(
                  padding: const EdgeInsets.all(Insets.lg),
                  child: Button(
                      action: () {
                        if (_authController.Otpauthstatus !=
                            OtpAuthStatus.Loading) {
                          _authController.sendForgetOtp();
                        }
                      },
                      label: "Continue",
                      children: true),
                ),
                const SizedBox(
                  height: 40,
                )
              ]),
        ),
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
        final currency = CountryPickerUtils.getCountryByIsoCode(countryFlag)
            .currencyCode
            .toString();
        setState(() {});
      },
    );
  }
}
