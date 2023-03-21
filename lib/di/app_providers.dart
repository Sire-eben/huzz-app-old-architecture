import 'package:huzz/core/services/firebase/firebase_dynamic_linking.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> appProviders = [
  ChangeNotifierProvider(create: (_) => FirebaseDynamicLinkService()),
];
