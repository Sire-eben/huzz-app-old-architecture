import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:huzz/app/onboarding_module/splash_screen.dart';

import 'app_routes.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case splashScreen:
      return _buildPageRoute(page: SplashScreen());
      break;
    default:
      return _errorRoute();
  }
}

Route<dynamic> _buildPageRoute({@required Widget? page}) {
  if (Platform.isIOS) {
    return CupertinoPageRoute(builder: (builder) => page!);
  } else {
    return MaterialPageRoute(builder: (builder) => page!);
  }
}

Route<dynamic> _errorRoute() {
  return MaterialPageRoute(
    builder: (context) {
      return Scaffold(
        body: Center(
          child: Text('Page not found'),
        ),
      );
    },
  );
}
