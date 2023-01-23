import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:huzz/data/repository/auth_respository.dart';
import 'package:huzz/ui/create_business.dart';
import 'package:huzz/ui/dashboard.dart';
import 'package:huzz/ui/onboarding_main..dart';
import 'package:huzz/ui/sign_in.dart';
import 'package:huzz/core/constants/app_themes.dart';

class SplashScreen extends StatefulWidget {
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _controller = Get.find<AuthRepository>();
  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = new Duration(seconds: 4);
    return new Timer(duration, route);
  }

  route() async {
    if (_controller.authStatus == AuthStatus.IsFirstTime) {
      Get.off(() => OnboardingMain());
    } else if (_controller.authStatus == AuthStatus.Authenticated) {
      if (_controller.user!.businessList!.isEmpty ||
          _controller.user!.businessList!.length == 0) {
        print('Business List: ${_controller.user!.businessList!.length}');
        Get.off(() => CreateBusiness());
      } else {
        _controller.checkTeamInvite();
        Get.off(() => Dashboard());
      }
    } else {
      Get.off(() => Signin());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: AppColors.backgroundColor,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset("assets/images/Vector (1).svg"),
                  )),
              SizedBox(
                width: 10,
              ),
              SvgPicture.asset("assets/images/Huzz.svg")
            ],
          ),
        ),
      ),
    );
  }
}
