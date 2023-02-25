import 'package:flutter/material.dart';
import 'package:huzz/core/constants/app_themes.dart';

class IcButton extends StatelessWidget {
  const IcButton(
      {this.onPressed,
      this.child,
      this.bgColor,
      this.padding,
      this.size,
      this.radius,
      Key? key})
      : super(key: key);
  final VoidCallback? onPressed;
  final Widget? child;
  final Color? bgColor;
  final EdgeInsets? padding;
  final double? size;
  final BorderRadius? radius;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: bgColor ?? AppColors.primaryColor.withOpacity(.5),
        minimumSize: Size(size ?? 47, size ?? 47),
        shape: RoundedRectangleBorder(borderRadius: radius ?? Corners.xsBorder),
        padding: padding,
        visualDensity: VisualDensity.standard,
      ),
      child: child ?? Container(),
    );
  }
}
