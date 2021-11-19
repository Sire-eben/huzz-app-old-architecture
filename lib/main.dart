import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:huzz/app/screens/onboarding_main..dart';

import 'package:huzz/core/routes/app_router.dart';
import 'package:huzz/core/routes/app_routes.dart';
import 'package:provider/provider.dart';

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
      theme: ThemeData(fontFamily: 'DMSans'),
      debugShowCheckedModeBanner: true,
      onGenerateRoute: generateRoute,
    
      home: SplashScreen(),
    );
  }
}
