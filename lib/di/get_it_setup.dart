import 'package:get_it/get_it.dart';
import 'package:huzz/core/services/firebase/dynamic_link_api.dart';

void setUpGetIt() {
  GetIt.I.registerSingleton<DynamicLinksApi>(DynamicLinksApi());
}
