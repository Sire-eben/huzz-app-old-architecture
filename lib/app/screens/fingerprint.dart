import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/app/screens/reg_home.dart';

import '../../colors.dart';

class FingerPrint extends StatelessWidget {
  const FingerPrint({Key? key}) : super(key: key);

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
          Center(
            child: Image.asset(
              'assets/images/finger.png',
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
              Get.to(RegHome());
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
