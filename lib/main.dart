import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/di/appbinding.dart';
import 'package:huzz/util/colors.dart';
import 'package:huzz/core/constants/app_pallete.dart';
import 'package:huzz/core/routes/app_router.dart';
import 'ui/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      useInheritedMediaQuery: true,
      theme: ThemeData(
          fontFamily: 'InterRegular',
          primaryColor: AppColor().backgroundColor,
          primarySwatch: Palette.primaryColor),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: generateRoute,
      home: SplashScreen(),
    );
  }
}
