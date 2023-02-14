import 'package:flutter/material.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/util/extension.dart';
import 'package:huzz/core/widgets/image.dart';
import 'package:huzz/generated/assets.gen.dart';

enum AppbarType {
  light,
  dark,
}

class Appbar extends AppBar {
  Appbar({
    String title = "",
    List<Widget> actions = const [],
    bool showLeading = true,
    bool centerTitle = false,
    double elevation = 0.0,
    AppbarType appbarType = AppbarType.light,
    Color? backgroundColor,
    Key? key,
  }) : super(
          key: key,
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: appbarType == AppbarType.light
                  ? AppColors.primaryColor
                  : AppColors.whiteColor,
              fontFamily: Fonts.primary,
            ),
          ),
          // ignore: prefer_if_null_operators
          backgroundColor: backgroundColor != null
              ? backgroundColor
              : appbarType == AppbarType.light
                  ? AppColors.whiteColor
                  : AppColors.primaryColor,
          leading: showLeading ? _AppbarBackButton(appbarType) : null,
          actions: actions,
          elevation: elevation,
          automaticallyImplyLeading: showLeading,
          centerTitle: centerTitle,
        );
}

class _AppbarBackButton extends StatelessWidget {
  final AppbarType appbarType;
  const _AppbarBackButton(this.appbarType, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        height: 40,
        width: 40,
        margin: const EdgeInsets.only(left: Insets.md),
        decoration: BoxDecoration(
          color: appbarType == AppbarType.light
              ? AppColors.whiteColor
              : AppColors.primaryColor,
          shape: BoxShape.circle,
        ),
        child: LocalSvgIcon(
          Assets.icons.linear.arrowLeft,
          size: 24,
          color: appbarType == AppbarType.light
              ? AppColors.primaryColor
              : AppColors.whiteColor,
        ),
      ).onTap(
        () => context.pop(),
      );
}
