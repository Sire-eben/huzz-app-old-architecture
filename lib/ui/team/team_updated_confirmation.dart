import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/constants/app_themes.dart';

class TeamMemberConfirmation extends StatefulWidget {
  TeamMemberConfirmation({Key? key}) : super(key: key);

  @override
  State<TeamMemberConfirmation> createState() => _TeamMemberConfirmationState();
}

class _TeamMemberConfirmationState extends State<TeamMemberConfirmation> {
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Center(
              child: Text(
                'Team Member Successfully',
                style: GoogleFonts.inter(
                  color: AppColors.backgroundColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
            Center(
              child: Text(
                'Updated',
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
                Get.back();
              },
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    border:
                        Border.all(width: 2, color: AppColors.backgroundColor),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    'Proceed',
                    style: GoogleFonts.inter(
                      color: AppColors.backgroundColor,
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
