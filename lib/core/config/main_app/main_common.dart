import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:huzz/core/config/service_locator/services_locator.dart';
import 'package:huzz/core/constants/app_env.dart';
import 'package:huzz/main.dart';

Future<void> mainCommon({@required Environment environment}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await registerAllDependencies();

  // TODO: change this to flavouring
  // switch (environment) {
  //   case Environment.DEVELOPMENT:
  //     break;
  //   case Environment.STAGING:
  //     break;
  //   case Environment.PRODUCTION:
  //   default:
  // }

  void debugPrintSynchronouslyWithText(String message, {int wrapWidth}) {
    debugPrintSynchronously(
      "DEBUG>>>>>" + message + "<<<<<",
      wrapWidth: wrapWidth,
    );
  }

  await runZonedGuarded(
    () async => runApp(HuzzApp()),
    (dynamic error, StackTrace stackTrace) =>
        log('<<<<<<< CAUGHT DART ERROR $error >>>>>>>'),
  );
}
