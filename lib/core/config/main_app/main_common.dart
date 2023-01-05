import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:huzz/core/config/service_locator/services_locator.dart';
import 'package:huzz/core/constants/app_env.dart';
import 'package:huzz/main.dart';

Future<void> mainCommon({@required Environment? environment}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await registerAllDependencies();

  await runZonedGuarded(
    () async => runApp(const HuzzApp()),
    (dynamic error, StackTrace stackTrace) =>
        log('<<<<<<< CAUGHT DART ERROR $error >>>>>>>'),
  );
}
