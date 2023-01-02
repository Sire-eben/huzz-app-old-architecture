import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/data/repository/auth_repository.dart';
import 'package:huzz/data/repository/fingerprint_repository.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'sign_in.dart';

class FingerPrint extends StatelessWidget {
  final _authController = Get.find<AuthRepository>();
  FingerPrint({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.backgroundColor,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          Center(
            child: Text(
              'Sign in with',
              style: GoogleFonts.inter(
                color: AppColors.backgroundColor,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ),
          Center(
            child: Text(
              'your fingerprint',
              style: GoogleFonts.inter(
                color: AppColors.backgroundColor,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          InkWell(
            onTap: () async {
              final isAuthenticated = await LocalAuthApi.authenticate();
              if (isAuthenticated) {
                // Get.off(() => Dashboard());
                if (_authController.signInStatus != SigninStatus.Loading) {
                  _authController.fingerPrintSignIn();
                }
              }
            },
            child: Center(
              child: (_authController.signInStatus == SigninStatus.Loading)
                  ? const SizedBox(
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
          const SizedBox(
            height: 50,
          ),
          Center(
            child: Text(
              'Please place your finger',
              style: GoogleFonts.inter(
                color: AppColors.blackColor,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          GestureDetector(
            onTap: () {
              Get.to(SignIn());
            },
            child: Center(
              child: Text(
                'OR SIGN IN WITH PIN',
                style: GoogleFonts.inter(
                  color: AppColors.orangeBorderColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
