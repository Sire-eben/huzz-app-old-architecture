import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final double size;
  final Color? color;

  const LoadingWidget({this.size = 15, this.color, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: Platform.isIOS
            ? CupertinoActivityIndicator(
                color: color ?? Theme.of(context).primaryColor,
              )
            : CircularProgressIndicator(
                strokeWidth: 2,
                color: color ?? Theme.of(context).primaryColor,
              ),
      ),
    );
  }
}
