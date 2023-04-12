import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/data/repository/home_respository.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/ui/auth/create_pin.dart';
import 'package:huzz/ui/auth/enter_otp.dart';
import 'package:huzz/ui/auth/send_otp.dart';
import 'package:huzz/ui/auth/sign_up.dart';

class RegHome extends StatefulWidget {
  const RegHome({super.key});

  @override
  _RegHome createState() => _RegHome();
}

class _RegHome extends State<RegHome> {
  int stepNumber = 4;
  int selectedIndex = 1;
  List<String> bodyText = [
    'Sign up now',
    'Enter  the four digit code we sent to your phone number',
    'let’s get to know you better',
    'Set a 4-digit PIN for subsequent logins'
  ];
  List<String> topText = [
    'Join Huzz',
    'Enter OTP ',
    'Personal Details',
    'Set Your PIN'
  ];
  List<Widget> body = [
    SendOtp(),
    EnterOtp(),
    const Signup(),
    const CreatePin()
  ];
  final _homeController = Get.find<HomeRespository>();
  @override
  Widget build(BuildContext context) {
    selectedIndex = 0;
    return Obx(() {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              if (_homeController.onboardingRegSelectedIndex > 0) {
                _homeController.selectedOnboardSelectedPrevious();
              } else {
                Get.back();
              }
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Positioned(
                        top: 20,
                        child: SvgPicture.asset('assets/images/Vector.svg')),
                  ],
                ),
              ),
              Text(topText[_homeController.onboardingRegSelectedIndex],
                  style: GoogleFonts.inter(
                      color: AppColors.backgroundColor,
                      fontSize: 28,
                      fontWeight: FontWeight.w500)),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.only(left: 50, right: 50),
                child: Text(
                  bodyText[_homeController.onboardingRegSelectedIndex],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 20, right: 20),
                height: 8,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (_, index) {
                      return GestureDetector(
                        onTap: () {
                          if (index <=
                              _homeController.onboardingRegSelectedIndex) {
                            _homeController.gotoIndex(index);
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          height: 5,
                          width: MediaQuery.of(context).size.width * 0.2,
                          decoration: BoxDecoration(
                            color: (index <=
                                    _homeController.onboardingRegSelectedIndex)
                                ? AppColors.backgroundColor
                                : AppColors.backgroundColor.withOpacity(0.4),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      );
                    }),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(child: body[_homeController.onboardingRegSelectedIndex])
            ],
          ),
        ),
      );
    });
  }
}
