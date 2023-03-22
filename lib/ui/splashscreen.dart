import 'dart:async';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:huzz/core/services/dynamic_linking/dynamic_link_api.dart';
import 'package:huzz/data/repository/auth_respository.dart';
import 'package:huzz/data/repository/business_respository.dart';
import 'package:huzz/generated/assets.gen.dart';
import 'package:huzz/ui/auth/sign_in.dart';
import 'package:huzz/ui/business/create_business.dart';
import 'package:huzz/ui/app_scaffold.dart';
import 'package:huzz/ui/onboarding_main..dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/ui/team/join_team.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _controller = Get.find<AuthRepository>();
  @override
  void initState() {
    super.initState();
    context.read<DynamicLinksApi>().handleDynamicLink();
    startTime();
  }

  startTime() async {
    var duration = const Duration(seconds: 4);
    return Timer(duration, route);
  }

  route() async {
    if (_controller.authStatus == AuthStatus.IsFirstTime) {
      Get.off(() => const OnboardingMain());
    } else if (_controller.authStatus == AuthStatus.Authenticated) {
      if (_controller.user!.businessList!.isEmpty ||
          _controller.user!.businessList!.isEmpty) {
        Get.off(() => const CreateBusiness());
      } else {
        Get.off(() => Dashboard());
      }
    } else {
      Get.off(() => const Signin());
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
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(Assets.images.vector1),
                  )),
              const SizedBox(
                width: 10,
              ),
              SvgPicture.asset(Assets.images.huzz)
            ],
          ),
        ),
      ),
    );
  }
}
