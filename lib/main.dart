import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/data/sharepreference/sharepref.dart';
import 'package:huzz/di/appbinding.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/constants/app_pallete.dart';
import 'package:huzz/core/routes/app_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'di/app_providers.dart';
import 'ui/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        theme: AppThemes.defaultTheme(context),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: generateRoute,
        home: const SplashScreen(),
      ),
    );
  }
}
