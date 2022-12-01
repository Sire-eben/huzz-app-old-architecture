import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/repository/auth_respository.dart';
import '../../data/repository/business_respository.dart';
import '../../util/colors.dart';

class TeamSuccess extends StatelessWidget {
  TeamSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().whiteColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
            Text(
              'You\'ve been invited',
              style: GoogleFonts.inter(
                color: AppColor().backgroundColor,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            Text(
              'to a team successfully',
              style: GoogleFonts.inter(
                color: AppColor().backgroundColor,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 50),
            Center(
              child: Image.asset(
                'assets/images/checker.png',
              ),
            ),
            Spacer(),
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                    color: AppColor().whiteColor,
                    border:
                        Border.all(width: 2, color: AppColor().backgroundColor),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    'Proceed',
                    style: GoogleFonts.inter(
                      color: AppColor().backgroundColor,
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
      ),
    );
  }
}
