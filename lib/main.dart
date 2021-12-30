import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/app/appbinding.dart';
import 'package:huzz/colors.dart';
import 'package:huzz/core/constants/app_pallete.dart';
import 'package:huzz/core/routes/app_router.dart';

// import 'package:huzz/model/reciept_model.dart';
import 'app/screens/splashscreen.dart';

void main() {
  runApp(HuzzApp());
}

class HuzzApp extends StatefulWidget {
  const HuzzApp({Key? key}) : super(key: key);

  @override
  _HuzzAppState createState() => _HuzzAppState();
}

class _HuzzAppState extends State<HuzzApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: AppBinding(),
      theme: ThemeData(
          fontFamily: 'DMSans',
          primaryColor: AppColor().backgroundColor,
          primarySwatch: Palette.primaryColor),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: generateRoute,
      home: SplashScreen(),
    );
  }
}
