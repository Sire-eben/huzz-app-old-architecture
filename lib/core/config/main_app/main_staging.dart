import 'package:huzz/core/constants/app_env.dart';
import 'main_common.dart';

Future<void> main() async {
  await mainCommon(environment: Environment.STAGING);
}
