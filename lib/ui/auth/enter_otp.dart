import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/widgets/state/loading.dart';
import 'package:huzz/data/repository/auth_respository.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/ui/widget/timer_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class EnterOtp extends StatefulWidget {
  _EnterOtpState createState() => _EnterOtpState();
}

class _EnterOtpState extends State<EnterOtp> {
  StreamController<ErrorAnimationType>? errorController;
  final _authController = Get.find<AuthRepository>();

  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    _authController.otpController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_authController.Otpverifystatus == OtpVerifyStatus.Error) {
        errorController!.add(ErrorAnimationType.shake);
      }

      return Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Positioned(
                          top: 20,
                          child: SvgPicture.asset('assets/images/Vector.svg')),
                      Positioned(
                        top: 40,
                        left: 20,
                        child: GestureDetector(
                          onTap: () {
                            Get.back();
                            // if (_homeController.onboardingRegSelectedIndex > 0) {
                            //   _homeController.selectedOnboardSelectedPrevious();
                            // } else {
                            //   Get.back();
                            // }
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
                  child: Text('Enter OTP',
                      style: GoogleFonts.inter(
                          color: AppColors.backgroundColor,
                          fontSize: 28,
                          fontWeight: FontWeight.w500)),
                ),
                const SizedBox(
                  height: 2,
                ),
                Center(
                  child: Text(
                    'Enter the four digit code we sent to your phone number',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                ),
                const Spacer(),
                Center(
                    child: Text(
                  "Enter OTP sent to your phone",
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                )),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: PinCodeTextField(
                      controller: _authController.otpController,
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
                      animationDuration: const Duration(milliseconds: 300),
                      backgroundColor: Colors.white,
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      // controller: textEditingController,
                      onCompleted: (v) {},
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
                ),
                const SizedBox(
                  height: 20,
                ),
                TimerButton(
                  label: "Send as Voice Call",
                  timeOutInSeconds: 20,
                  activeTextStyle: GoogleFonts.inter(
                      color: AppColors.backgroundColor, fontSize: 12),
                  onPressed: () {
                    _authController.sendVoiceOtp();
                  },
                  buttonType: ButtonType.TextButton,
                  disabledColor: Colors.white,
                  color: Colors.transparent,
                ),
                const SizedBox(
                  height: 20,
                ),
                TimerButton(
                  label: "Resend via sms",
                  timeOutInSeconds: 20,
                  activeTextStyle: GoogleFonts.inter(
                      color: const Color(0xffEF6500), fontSize: 12),
                  onPressed: () {
                    _authController.sendSmsOtp(isresend: true);
                  },
                  buttonType: ButtonType.TextButton,
                  disabledColor: Colors.white,
                  color: Colors.transparent,
                ),
                GestureDetector(
                    onTap: () {
                      _authController.sendSmsOtp();
                    },
                    child: Text(
                      "Resend via sms",
                      style: GoogleFonts.inter(
                          color: const Color(0xffEF6500), fontSize: 12),
                    )),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    _authController.verifyOpt();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(left: 50, right: 50),
                    height: 50,
                    decoration: const BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: (_authController.Otpverifystatus ==
                            OtpVerifyStatus.Loading)
                        ? const LoadingWidget()
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                child: const Icon(
                                  Icons.arrow_forward,
                                  color: AppColors.backgroundColor,
                                  size: 16,
                                ),
                              )
                            ],
                          ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                )
              ]),
        ),
      );
    });
  }
}
