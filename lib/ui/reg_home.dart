import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/home_respository.dart';
import 'package:huzz/ui/create_pin.dart';
import 'package:huzz/ui/enter_otp.dart';
import 'package:huzz/ui/sign_up.dart';
import 'package:huzz/util/colors.dart';
import 'send_otp.dart';

class RegHome extends StatefulWidget {
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
  List<Widget> body = [SendOtp(), EnterOtp(), Signup(), CreatePin()];
  final _homeController = Get.find<HomeRespository>();
  @override
  Widget build(BuildContext context) {
    selectedIndex = 0;
    return Obx(() {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Positioned(
                        top: 20,
                        child: SvgPicture.asset('assets/images/Vector.svg')),
                    Positioned(
                      top: 50,
                      left: 20,
                      child: GestureDetector(
                        onTap: () {
                          if (_homeController.onboardingRegSelectedIndex > 0) {
                            _homeController.selectedOnboardSelectedPrevious();
                          } else {
                            Get.back();
                          }
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: AppColor().backgroundColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(topText[_homeController.onboardingRegSelectedIndex],
                  style: TextStyle(
                      color: AppColor().backgroundColor,
                      fontSize: 28,
                      fontWeight: FontWeight.w500)),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(left: 50, right: 50),
                child: Text(
                  bodyText[_homeController.onboardingRegSelectedIndex],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20, right: 20),
                height: 8,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (_, index) {
                      return GestureDetector(
                        onTap: () {
                          print("index number is $index");
                          if (index <=
                              _homeController.onboardingRegSelectedIndex)
                            _homeController.gotoIndex(index);
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          height: 5,
                          width: MediaQuery.of(context).size.width * 0.2,
                          decoration: BoxDecoration(
                            color: (index <=
                                    _homeController.onboardingRegSelectedIndex)
                                ? AppColor().backgroundColor
                                : AppColor().backgroundColor.withOpacity(0.4),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      );
                    }),
              ),
              SizedBox(
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
