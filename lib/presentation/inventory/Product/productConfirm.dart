import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/presentation/app_scaffold.dart';
import 'package:huzz/core/constants/app_themes.dart';

// ignore: must_be_immutable
class Confirmation extends StatelessWidget {
  String text, title;
  Confirmation({Key? key, required this.text, required this.title})
      : super(key: key);

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
          child: Icon(
            Icons.arrow_back,
            color: AppColors.backgroundColor,
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
              '$title Successfully ',
              style: GoogleFonts.inter(
                color: AppColors.backgroundColor,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ),
          Center(
            child: Text(
              text,
              style: GoogleFonts.inter(
                color: AppColors.backgroundColor,
                fontWeight: FontWeight.w600,
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
              Get.offAll(Dashboard(
                selectedIndex: 2,
              ));
            },
            child: Container(
              height: 55,
              margin: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text(
                  'Continue',
                  style: GoogleFonts.inter(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600,
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
