import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/constants/app_themes.dart';

enum DialogsAction { yes, cancel }

class AlertDialogs {
  static Future<DialogsAction> yesCancelDialog(
    BuildContext context,
    String title,
    String body,
  ) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        if (Platform.isAndroid) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: Text(title),
            content: Text(body),
            actions: <Widget>[
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(DialogsAction.cancel),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.inter(
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(DialogsAction.yes),
                child: Text(
                  'Confirm',
                  style: GoogleFonts.inter(
                    color: AppColors.backgroundColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            ],
          );
        } else {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(body),
            actions: [
              CupertinoDialogAction(
                onPressed: () =>
                    Navigator.of(context).pop(DialogsAction.cancel),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.inter(
                    color: AppColors.backgroundColor,
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ),
              CupertinoDialogAction(
                onPressed: () => Navigator.of(context).pop(DialogsAction.yes),
                child: Text(
                  'Continue',
                  style: GoogleFonts.inter(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
    return (action != null) ? action : DialogsAction.cancel;
  }
}
