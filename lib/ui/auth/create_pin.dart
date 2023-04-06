import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/widgets/app_bar.dart';
import 'package:huzz/core/widgets/button/button.dart';
import 'package:huzz/data/repository/auth_respository.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CreatePin extends StatefulWidget {
  const CreatePin({super.key});

  @override
  _CreatePinState createState() => _CreatePinState();
}

class _CreatePinState extends State<CreatePin> {
  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;
  final _authController = Get.find<AuthRepository>();
  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    _authController.pinController = TextEditingController();
    _authController.confirmPinController = TextEditingController();

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
      backgroundColor: AppColors.whiteColor,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: Appbar(
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(Insets.lg),
        child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 70,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Positioned(
                        top: 20,
                        child: SvgPicture.asset('assets/images/Vector.svg')),
                  ],
                ),
              ),
              const Gap(Insets.lg),
              Center(
                child: Text('Set Your PIN',
                    style: GoogleFonts.inter(
                        color: AppColors.backgroundColor,
                        fontSize: 28,
                        fontWeight: FontWeight.w500)),
              ),
              SizedBox(
                height: 2,
              ),
              Center(
                child: Text(
                  'Set a 4-digit PIN for subsequent logins',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Center(
                  child: Text(
                "Create a 4 digit pin",
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              )),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Insets.xl),
                child: PinCodeTextField(
                  length: 4,
                  obscureText: true,
                  animationType: AnimationType.fade,
                  controller: _authController.pinController,
                  keyboardType: TextInputType.number,
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
              const Gap(Insets.xl),
              Center(
                  child: Text(
                "Confirm your pin",
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Insets.xl),
                child: PinCodeTextField(
                  length: 4,
                  obscureText: true,
                  animationType: AnimationType.fade,
                  controller: _authController.confirmPinController,
                  keyboardType: TextInputType.number,
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
                  // errorAnimationController: errorController,
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
              const Gap(Insets.xl * 3),
              Obx(() {
                return Button(
                  action: () {
                    if (_authController.pinController == '' ||
                        _authController.confirmPinController.text == '') {
                      Get.snackbar('Alert', 'Enter your pin to continue!',
                          titleText: Text(
                            'Alert',
                          ),
                          messageText: Text(
                            'Enter your pin to continue!',
                          ),
                          icon: Icon(Icons.info,
                              color: AppColors.orangeBorderColor));
                      print('pin cannot be empty');
                    } else {
                      if (_authController.confirmPinController.text ==
                          _authController.pinController.text) {
                        //  if(_authController.signupStatus!=SignupStatus.Loading)
                        _authController.signUp();
                      } else {
                        errorController!.add(ErrorAnimationType.shake);
                      }
                    }

                    // Get.to(PinSuccesful());
                  },
                  showLoading:
                      _authController.signupStatus == SignupStatus.Loading
                          ? true
                          : false,
                  label: 'Sign up',
                );
              }),
              SizedBox(
                height: 30,
              )
            ]),
      ),
    );
  }
}
