import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/app/screens/dashboard.dart';

import '../../../../colors.dart';

// ignore: must_be_immutable
class Confirmation extends StatefulWidget {
  Confirmation({
    Key? key,
  }) : super(key: key);

  @override
  State<Confirmation> createState() => _ConfirmationState();
}

class _ConfirmationState extends State<Confirmation> {
  String? text;

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
              'Product Successfully ',
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
              text!,
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
              'assets/images/checker.png',
            ),
          ),
          Spacer(),
          InkWell(
            onTap: () {
              Get.to(Dashboard());
            },
            child: Container(
              height: 55,
              margin: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                  color: AppColor().backgroundColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text(
                  'Proceed',
                  style: TextStyle(
                    color: AppColor().whiteColor,
                    fontFamily: 'DMSans',
                    fontWeight: FontWeight.bold,
                  ),
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
