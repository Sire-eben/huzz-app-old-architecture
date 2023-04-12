import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/data/repository/auth_respository.dart';
import 'package:huzz/ui/app_scaffold.dart';
import 'package:huzz/ui/business/create_business.dart';
import 'package:huzz/core/constants/app_themes.dart';

class PinSuccesful extends StatelessWidget {
  const PinSuccesful({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthRepository>();
    return Scaffold(
        body: SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          SizedBox(
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Positioned(
                  top: 20,
                  child: SvgPicture.asset('assets/images/Vector.svg'),
                ),
                Positioned(
                  top: 50,
                  left: 20,
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
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
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Text(
                "Account Created Successfully",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    fontSize: 30, color: AppColors.backgroundColor),
              )),
          const Spacer(),
          Center(
            child: Image.asset(
              'assets/images/checker.png',
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              authController.hasTeamInviteDeeplink.value == true
                  ? Get.offAll(() => Dashboard())
                  : Get.to(const CreateBusiness());
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 50, right: 50),
              height: 50,
              decoration: const BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Proceed',
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          )
        ],
      ),
    ));
  }
}
