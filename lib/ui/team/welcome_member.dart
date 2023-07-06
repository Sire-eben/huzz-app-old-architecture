import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/util/extension.dart';
import 'package:huzz/data/repository/business_respository.dart';
import 'package:huzz/ui/app_scaffold.dart';

class WelcomeNewMember extends StatefulWidget {
  const WelcomeNewMember({super.key});

  @override
  State<WelcomeNewMember> createState() => _WelcomeNewMemberState();
}

class _WelcomeNewMemberState extends State<WelcomeNewMember> {
  final businessController = Get.find<BusinessRespository>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
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
        body: Padding(
          padding: const EdgeInsets.all(Insets.lg),
          child: Column(
            children: [
              Center(
                child: Text(
                  'You Joined The \n'
                  "${businessController.selectedBusiness.value!.businessName}"
                  ' Successfully',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: AppColors.backgroundColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                  ),
                ),
              ),
              const Spacer(),
              Center(
                child: Image.asset(
                  'assets/images/checker.png',
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  context.replace(Dashboard());
                },
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      border: Border.all(
                          width: 2, color: AppColors.backgroundColor),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      'Continue',
                      style: GoogleFonts.inter(
                        color: AppColors.backgroundColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
