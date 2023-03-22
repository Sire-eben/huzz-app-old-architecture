import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huzz/ui/team/my_team.dart';

import 'app_routes.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case myTeamView:
      return _buildPageRoute(page: const MyTeam());
    // case joinTeam:
    //   return _buildPageRoute(page: const JoinBusinessTeam());

    // break;
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
      return const Scaffold(
        body: Center(
          child: Text('Page not found'),
        ),
      );
    },
  );
}

typedef PageBuilder = Widget Function();

class PageRouter {
  static const double kDefaultDuration = .25;

  static Route<T> transitTo<T>(PageBuilder pageBuilder,
      [String? tag, double duration = kDefaultDuration]) {
    return MaterialPageRoute(
      builder: (context) => pageBuilder(),
      settings: RouteSettings(name: tag),
    );
  }
}
