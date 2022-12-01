// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  Color? color;
  LoadingWidget({Key? key, this.color = Colors.white}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 30,
      child: Center(
          child: Platform.isIOS
              ? CupertinoActivityIndicator(
                  color: color,
                )
              : CircularProgressIndicator(
                  color: color,
                )),
    );
  }
}
