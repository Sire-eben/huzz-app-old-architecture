// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:huzz/Repository/auth_respository.dart';
// import 'package:huzz/Repository/home_respository.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';

// import '../../../colors.dart';

// class SetForgotPIN extends StatefulWidget {
//   const SetForgotPIN({Key? key}) : super(key: key);

//   @override
//   _SetForgotPINState createState() => _SetForgotPINState();
// }

// class _SetForgotPINState extends State<SetForgotPIN> {
//   // ignore: unused_field
//   final _homeController = Get.find<HomeRespository>();

//   StreamController<ErrorAnimationType>? errorController;
//   StreamController<ErrorAnimationType>? verifyErrorController;

//   final _authController = Get.find<AuthRepository>();
//   void initState() {
//     errorController = StreamController<ErrorAnimationType>();
//     verifyErrorController = StreamController<ErrorAnimationType>();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     errorController!.close();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       if (_authController.Otpverifystatus == OtpVerifyStatus.Error) {
//         errorController!.add(ErrorAnimationType.shake);
//       }

//       return Scaffold(
//         body: Container(
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height,
//           child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Container(
//                   height: 100,
//                   width: MediaQuery.of(context).size.width,
//                   child: Stack(
//                     children: [
//                       Positioned(
//                           top: 20,
//                           child: SvgPicture.asset('assets/images/Vector.svg')),
//                       Positioned(
//                         top: 50,
//                         left: 20,
//                         child: GestureDetector(
//                           onTap: () {
//                             Get.back();
//                           },
//                           child: Icon(
//                             Icons.arrow_back,
//                             color: AppColor().backgroundColor,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Text('Set Your PIN',
//                     style: TextStyle(
//                         color: AppColor().orangeBorderColor,
//                         fontSize: 28,
//                         fontWeight: FontWeight.w500)),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                   margin: EdgeInsets.only(left: 50, right: 50),
//                   child: Text(
//                     'Set a 4-digit PIN for subsequent logins',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 SizedBox(height: MediaQuery.of(context).size.height * 0.05),
//                 Container(
//                     margin: EdgeInsets.only(
//                       left: 20,
//                     ),
//                     child: Text(
//                       "Create a 4-digit PIN",
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     )),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Center(
//                   child: Container(
//                     width: MediaQuery.of(context).size.width * 0.6,
//                     child: PinCodeTextField(
//                       controller: _authController.forgetpinController,
//                       length: 4,
//                       obscureText: true,
//                       animationType: AnimationType.fade,
//                       pinTheme: PinTheme(
//                         inactiveColor: AppColor().backgroundColor,
//                         activeColor: AppColor().backgroundColor,
//                         selectedColor: AppColor().backgroundColor,
//                         selectedFillColor: Colors.white,
//                         inactiveFillColor: Colors.white,
//                         shape: PinCodeFieldShape.box,
//                         borderRadius: BorderRadius.circular(5),
//                         fieldHeight: 50,
//                         fieldWidth: 50,
//                         activeFillColor: Colors.white,
//                       ),
//                       animationDuration: Duration(milliseconds: 300),
//                       backgroundColor: Colors.white,
//                       enableActiveFill: true,
//                       errorAnimationController: errorController,
//                       // controller: textEditingController,
//                       onCompleted: (v) {
//                         print("Completed");
//                       },
//                       onChanged: (value) {
//                         print(value);
//                         // setState(() {
//                         //   currentText = value;
//                         // });
//                       },
//                       beforeTextPaste: (text) {
//                         print("Allowing to paste $text");
//                         //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
//                         //but you can show anything you want here, like your pop up saying wrong paste format or etc
//                         return true;
//                       },
//                       appContext: context,
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Container(
//                     margin: EdgeInsets.only(
//                       left: 20,
//                     ),
//                     child: Text(
//                       "Confirm your 4-digit PIN",
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     )),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Center(
//                   child: Container(
//                     width: MediaQuery.of(context).size.width * 0.6,
//                     child: PinCodeTextField(
//                       controller: _authController.verifypinController,
//                       length: 4,
//                       obscureText: true,
//                       animationType: AnimationType.fade,
//                       pinTheme: PinTheme(
//                         inactiveColor: AppColor().backgroundColor,
//                         activeColor: AppColor().backgroundColor,
//                         selectedColor: AppColor().backgroundColor,
//                         selectedFillColor: Colors.white,
//                         inactiveFillColor: Colors.white,
//                         shape: PinCodeFieldShape.box,
//                         borderRadius: BorderRadius.circular(5),
//                         fieldHeight: 50,
//                         fieldWidth: 50,
//                         activeFillColor: Colors.white,
//                       ),
//                       animationDuration: Duration(milliseconds: 300),
//                       backgroundColor: Colors.white,
//                       enableActiveFill: true,
//                       errorAnimationController: verifyErrorController,
//                       // controller: textEditingController,
//                       onCompleted: (v) {
//                         print("Completed");
//                       },
//                       onChanged: (value) {
//                         print(value);
//                         // setState(() {
//                         //   currentText = value;
//                         // });
//                       },
//                       beforeTextPaste: (text) {
//                         print("Allowing to paste $text");
//                         //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
//                         //but you can show anything you want here, like your pop up saying wrong paste format or etc
//                         return true;
//                       },
//                       appContext: context,
//                     ),
//                   ),
//                 ),
//                 Expanded(child: SizedBox()),
//                 GestureDetector(
//                   onTap: () {
//                     // _authController.verifyOpt();
//                     if (_authController.confirmPinController.text ==
//                         _authController.pinController.text) {
//                       //  if(_authController.signupStatus!=SignupStatus.Loading)
//                       _authController.signUp();
//                     } else {
//                       errorController!.add(ErrorAnimationType.shake);
//                     }
//                   },
//                   child: Container(
//                     width: MediaQuery.of(context).size.width,
//                     margin: EdgeInsets.only(left: 50, right: 50),
//                     height: 50,
//                     decoration: BoxDecoration(
//                         color: AppColor().backgroundColor,
//                         borderRadius: BorderRadius.all(Radius.circular(10))),
//                     child: (_authController.Otpverifystatus ==
//                             OtpVerifyStatus.Loading)
//                         ? Container(
//                             width: 30,
//                             height: 30,
//                             child: Center(
//                                 child: CircularProgressIndicator(
//                                     color: Colors.white)),
//                           )
//                         : Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Text(
//                                 'Continue',
//                                 style: TextStyle(
//                                     color: Colors.white, fontSize: 18),
//                               ),
//                               SizedBox(
//                                 width: 10,
//                               ),
//                               Container(
//                                 padding: EdgeInsets.all(3),
//                                 decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(50))),
//                                 child: Icon(
//                                   Icons.arrow_forward,
//                                   color: AppColor().backgroundColor,
//                                   size: 16,
//                                 ),
//                               )
//                             ],
//                           ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 40,
//                 )
//               ]),
//         ),
//       );
//     });
//   }
// }
