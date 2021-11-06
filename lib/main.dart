import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huzz/core/routes/app_router.dart';
import 'package:huzz/core/routes/app_routes.dart';
import 'package:provider/provider.dart';

import 'core/config/providers/app_providers.dart';

class HuzzApp extends StatefulWidget {
  const HuzzApp({Key key}) : super(key: key);

  @override
  _HuzzAppState createState() => _HuzzAppState();
}

class _HuzzAppState extends State<HuzzApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: appProviders,
      child: MaterialApp(
        theme: ThemeData(),
        debugShowCheckedModeBanner: true,
        onGenerateRoute: generateRoute,
        initialRoute: splashScreen,
      ),
    );
  }
}
