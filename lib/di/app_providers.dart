import 'package:huzz/core/services/firebase/dynamic_link_api.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> appProviders = [
  ChangeNotifierProvider(create: (_) => DynamicLinksApi()),
];
