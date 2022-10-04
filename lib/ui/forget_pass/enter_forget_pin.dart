// ignore_for_file: unused_field, close_sinks

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:huzz/data/repository/auth_respository.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../util/colors.dart';
import '../widget/timer_button.dart';

class EnterForgotPIN extends StatefulWidget {
  const EnterForgotPIN({Key? key}) : super(key: key);

  @override
  State<EnterForgotPIN> createState() => _EnterForgotPINState();
}

class _EnterForgotPINState extends State<EnterForgotPIN> {
  StreamController<ErrorAnimationType>? pinErrorController;
  StreamController<ErrorAnimationType>? errorController;
  final _authController = Get.find<AuthRepository>();
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
    return Obx(() {
      if (_authController.Otpverifystatus == OtpVerifyStatus.Error) {
        errorController!.add(ErrorAnimationType.shake);
      }

      return Scaffold(
        resizeToAvoidBottomInset: false,
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
                        top: 50,
                        left: 20,
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
                    ],
                  ),
                ),
                Text('Enter OTP & PIN',
                    style: TextStyle(
                        color: AppColor().orangeBorderColor,
                        fontSize: 28,
                        fontWeight: FontWeight.w500)),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(left: 50, right: 50),
                  child: Text(
                    'Enter  the four digit code we sent to your phone number',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Container(
                    margin: EdgeInsets.only(
                      left: 20,
                    ),
                    child: Text(
                      "Enter OTP sent to your phone",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: PinCodeTextField(
                      controller: _authController.forgotOtpController,
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
                ),
                SizedBox(
                  height: 20,
                ),
                TimerButton(
                  label: "Send as Voice Call",
                  timeOutInSeconds: 20,
                  activeTextStyle: TextStyle(
                      color: AppColor().backgroundColor, fontSize: 12),
                  onPressed: () {
                    _authController.sendVoiceOtp();
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
                    _authController.sendSmsOtp(isresend: true);
                  },
                  buttonType: ButtonType.TextButton,
                  disabledColor: Colors.white,
                  color: Colors.transparent,
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                    margin: EdgeInsets.only(
                      left: 20,
                    ),
                    child: Text(
                      "Create a 4-digit PIN",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: PinCodeTextField(
                      controller: _authController.forgetpinController,
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
                      errorAnimationController: pinErrorController,
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
                Expanded(child: SizedBox()),
                Obx(() {
                  return GestureDetector(
                    onTap: () {
                      if (_authController.Otpforgotverifystatus !=
                          OtpForgotVerifyStatus.Loading)
                        _authController.verifyForgotOpt();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(left: 50, right: 50),
                      height: 50,
                      decoration: BoxDecoration(
                          color: AppColor().backgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: (_authController.Otpforgotverifystatus ==
                              OtpForgotVerifyStatus.Loading)
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
                                  'Continue',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50))),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: AppColor().backgroundColor,
                                    size: 16,
                                  ),
                                )
                              ],
                            ),
                    ),
                  );
                }),
                SizedBox(
                  height: 40,
                )
              ]),
        ),
      );
    });
  }
}
