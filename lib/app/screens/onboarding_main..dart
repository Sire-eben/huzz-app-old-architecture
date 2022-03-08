import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/auth_respository.dart';
import 'package:huzz/app/screens/reg_home.dart';
import 'package:huzz/colors.dart';
import 'package:huzz/model/onboarding_model.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class OnboardingMain extends StatefulWidget {
  _OnboardingMainState createState() => _OnboardingMainState();
}

class _OnboardingMainState extends State<OnboardingMain> {
  int selectedIndex = 0;
  List<OnBoardingModel> boards = OnBoardingModel.values;
  final _authController = Get.find<AuthRepository>();
  double progress = 14;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Positioned(
                        left: 0,
                        top: 20,
                        child: SvgPicture.asset('assets/images/Vector.svg')),
                    // Positioned(
                    //   top: 40,
                    //   left: 20,
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       Get.back();
                    //     },
                    //     child: Icon(
                    //       Icons.arrow_back,
                    //       color: AppColor().backgroundColor,
                    //     ),
                    //   ),
                    // ),
                    Positioned(
                      right: 20,
                      top: 40,
                      child: GestureDetector(
                        onTap: () {
                          _authController.pref!.setFirstTimeOpen(false);
                          Get.offAll(RegHome());
                        },
                        child: Text(
                          "Skip",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                child: Image.asset(boards[selectedIndex].asset!),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
              ),
              Container(
                margin: EdgeInsets.only(left: 50, right: 50),
                child: AutoSizeText(
                  boards[selectedIndex].title!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    fontFamily: 'DMSans',
                    color: Colors.black,
                  ),
                  maxLines: 1,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Container(
                margin: EdgeInsets.only(left: 30, right: 30),
                child: AutoSizeText(
                  boards[selectedIndex].body!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    color: Colors.black,
                    fontSize: 12,
                    letterSpacing: 0.5,
                    height: 1.5,
                  ),
                  maxLines: 3,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              (selectedIndex < boards.length - 1)
                  ? GestureDetector(
                      onTap: () {
                        if (selectedIndex < boards.length - 1) {
                          ++selectedIndex;
                          progress = 22;
                        }

                        setState(() {});
                      },
                      child: Stack(
                        children: [
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                  color: AppColor().backgroundColor),
                              child: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                          SleekCircularSlider(
                            appearance: CircularSliderAppearance(
                              size: 90,
                              angleRange: 360.0,
                              startAngle: -90,
                              counterClockwise: false,
                              infoProperties: InfoProperties(
                                topLabelText: "",
                                bottomLabelText: "",
                              ),
                              customColors: CustomSliderColors(
                                  trackColor: Colors.white,
                                  progressBarColor: AppColor().backgroundColor,
                                  gradientEndAngle: 360.0,
                                  trackGradientEndAngle: 360),
                              customWidths:
                                  CustomSliderWidths(progressBarWidth: 2),
                            ),
                            min: 10,
                            max: 28,
                            initialValue: progress,
                            innerWidget: (value) {
                              return Container();
                            },
                          ),
                        ],
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        _authController.pref!.setFirstTimeOpen(false);
                        Get.offAll(RegHome());
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(left: 50, right: 50),
                        height: 50,
                        decoration: BoxDecoration(
                            color: AppColor().backgroundColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Start Using Huzz',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                              child: Icon(
                                Icons.arrow_forward,
                                color: AppColor().backgroundColor,
                                size: 16,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
