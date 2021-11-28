import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/app/appbinding.dart';
import 'package:huzz/app/screens/create_business.dart';
import 'package:huzz/app/screens/dashboard.dart';
import 'package:huzz/app/screens/inventory/manage_inventory.dart';
import 'package:huzz/app/screens/onboarding_main..dart';
import 'package:huzz/core/routes/app_router.dart';
import 'package:huzz/core/routes/app_routes.dart';
import 'package:provider/provider.dart';
import 'app/screens/pin_successful.dart';
import 'app/screens/reg_home.dart';
import 'app/screens/sign_in.dart';
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
      theme: ThemeData(fontFamily: 'DMSans'),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: generateRoute,
      home: Dashboard(),
    );
  }
}
