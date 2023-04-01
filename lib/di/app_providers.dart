import 'package:huzz/core/services/dynamic_linking/referral_dynamic_link_api.dart';
import 'package:huzz/core/services/dynamic_linking/team_dynamic_link_api.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> appProviders = [
  ChangeNotifierProvider(create: (_) => TeamDynamicLinksApi()),
  ChangeNotifierProvider(create: (_) => ReferralDynamicLinksApi()),
];
