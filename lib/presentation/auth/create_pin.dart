import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/data/repository/auth_repository.dart';
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
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                child: Text('Set Your PIN',
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
                  'Set a 4-digit PIN for subsequent logins',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(
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
              const SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                margin: const EdgeInsets.only(top: 5),
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
                    fieldHeight: 50,
                    fieldWidth: 50,
                    activeFillColor: Colors.white,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.white,
                  enableActiveFill: true,
                  errorAnimationController: errorController,
                  // controller: textEditingController,
                  onCompleted: (v) {
                    // print("Completed");
                  },
                  onChanged: (value) {
                    // print(value);
                    // setState(() {
                    //   currentText = value;
                    // });
                  },
                  beforeTextPaste: (text) {
                    // print("Allowing to paste $text");
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },
                  appContext: context,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                  child: Text(
                "Confirm a 4 digit pin",
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              )),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                margin: const EdgeInsets.only(top: 5),
                child: PinCodeTextField(
                  length: 4,
                  obscureText: true,
                  animationType: AnimationType.fade,
                  controller: _authController.confirmPinController,
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
                  // errorAnimationController: errorController,
                  // controller: textEditingController,
                  onCompleted: (v) {
                    // print("Completed");
                  },
                  onChanged: (value) {
                    // print(value);
                    // setState(() {
                    //   currentText = value;
                    // });
                  },
                  beforeTextPaste: (text) {
                    // print("Allowing to paste $text");
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },
                  appContext: context,
                ),
              ),
              const Expanded(child: SizedBox()),
              Obx(() {
                return GestureDetector(
                  onTap: () {
                    if (_authController.pinController == '' ||
                        _authController.confirmPinController.text == '') {
                      Get.snackbar('Alert', 'Enter your pin to continue!',
                          titleText: const Text(
                            'Alert',
                          ),
                          messageText: const Text(
                            'Enter your pin to continue!',
                          ),
                          icon: const Icon(Icons.info,
                              color: AppColors.orangeBorderColor));
                      // print('pin cannot be empty');
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
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(left: 50, right: 50),
                    height: 50,
                    decoration: const BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child:
                        (_authController.signupStatus == SignupStatus.Loading)
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
                                    'Create User',
                                    style: GoogleFonts.inter(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  //  Container(padding: EdgeInsets.all(3),
                                  //    decoration:BoxDecoration(
                                  //      color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(50))

                                  //    ),
                                  //    child: Icon(Icons.arrow_forward,color: AppColors.backgroundColor,size: 16,),
                                  //  )
                                ],
                              ),
                  ),
                );
              }),
              const SizedBox(
                height: 30,
              )
            ]),
      ),
    );
  }
}
