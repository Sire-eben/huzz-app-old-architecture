import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/auth_respository.dart';
import 'package:huzz/Repository/fingerprint_repository.dart';

import '../../colors.dart';
import 'sign_in.dart';

class FingerPrint extends StatelessWidget {
  final _authController = Get.find<AuthRepository>();
  FingerPrint({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColor().whiteColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: AppColor().backgroundColor,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          Center(
            child: Text(
              'Sign in with',
              style: TextStyle(
                color: AppColor().backgroundColor,
                fontFamily: 'DMSans',
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Center(
            child: Text(
              'your fingerprint',
              style: TextStyle(
                color: AppColor().backgroundColor,
                fontFamily: 'DMSans',
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          InkWell(
            onTap: () async {
              final isAuthenticated = await LocalAuthApi.authenticate();
              if (isAuthenticated) {
                // Get.off(() => Dashboard());
                if (_authController.signinStatus != SigninStatus.Loading)
                  _authController.fingerPrintSignIn();
              }
            },
            child: Center(
              child: (_authController.signinStatus == SigninStatus.Loading)
                  ? Container(
                      width: 30,
                      height: 30,
                      child: Center(
                          child:
                              CircularProgressIndicator(color: Colors.white)),
                    )
                  : Image.asset(
                      'assets/images/finger.png',
                    ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Center(
            child: Text(
              'Please place your finger',
              style: TextStyle(
                color: AppColor().blackColor,
                fontFamily: 'DMSans',
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          GestureDetector(
            onTap: () {
              Get.to(Signin());
            },
            child: Center(
              child: Text(
                'OR SIGN IN WITH PIN',
                style: TextStyle(
                  color: AppColor().orangeBorderColor,
                  fontFamily: 'DMSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
