import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/core/di/app_binding.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/routes/app_router.dart';
import 'presentation/splash_screen.dart';

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
    return GetMaterialApp(
      initialBinding: AppBinding(),
      useInheritedMediaQuery: true,
      theme: AppThemes.defaultTheme(context),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: generateRoute,
      home: const SplashScreen(),
    );
  }
}
