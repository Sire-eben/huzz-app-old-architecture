import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:huzz/app/screens/onboarding_main..dart';
import 'package:huzz/colors.dart';

class SplashScreen extends StatefulWidget{

 _SplashScreenState createState()=>_SplashScreenState();  
}
class _SplashScreenState extends State<SplashScreen>{

    @override
  void initState() {
    super.initState();
    // pref.init();
    startTime();
  }

  startTime() async {
    var duration = new Duration(seconds: 4);
    return new Timer(duration, route);
  }

  route() async {
Get.off(OnboardingMain());
    // Get.off(AboutUs());
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
     body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: AppColor().backgroundColor,
      child: Center(

        child: Row(
           mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Container(
             width:70,
             height: 70,
             decoration: BoxDecoration(
               color: Colors.white,
               borderRadius: BorderRadius.all(Radius.circular(5))
             ),
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: SvgPicture.asset("assets/images/Vector (1).svg"),
             )),
             SizedBox(width: 10,),
           SvgPicture.asset("assets/images/Huzz.svg")
          ],
        ),
      ),

     ),



    );
  }
}