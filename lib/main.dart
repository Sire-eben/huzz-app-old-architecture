import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/core/services/firebase/dynamic_link_api.dart';
import 'package:huzz/di/appbinding.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/constants/app_pallete.dart';
import 'package:huzz/core/routes/app_router.dart';
import 'package:huzz/di/get_it_setup.dart';
import 'package:provider/provider.dart';
import 'di/app_providers.dart';
import 'ui/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // setUpGetIt();
  runApp(const HuzzApp());
}

class HuzzApp extends StatefulWidget {
  const HuzzApp({Key? key}) : super(key: key);

  @override
  _HuzzAppState createState() => _HuzzAppState();
}

class _HuzzAppState extends State<HuzzApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: appProviders,
      child: GetMaterialApp(
        initialBinding: AppBinding(),
        useInheritedMediaQuery: true,
        theme: ThemeData(
            fontFamily: 'InterRegular',
            primaryColor: AppColors.backgroundColor,
            primarySwatch: Palette.primaryColor),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: generateRoute,
        home: SplashScreen(),
      ),
    );
  }
}
