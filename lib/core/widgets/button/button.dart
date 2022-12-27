import "package:flutter/material.dart";
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/widgets/state/loading.dart';

class Button extends StatelessWidget {
  final String label;
  final VoidCallback action;
  final bool? showLoading;
  final Color? color, backgroundColor;
  final Widget? child;
  final bool
      shrinkWrap; // if true, the button will not take more space than it needs
  const Button({
    required this.label,
    required this.action,
    this.shrinkWrap = false,
    this.showLoading,
    this.color,
    this.backgroundColor,
    this.child,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final btnChild = ElevatedButton(
      style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
          backgroundColor: backgroundColor != null
              ? MaterialStateProperty.all<Color>(backgroundColor!)
              : null,
          shape: MaterialStateProperty.all(const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Corners.smRadius)))),
      onPressed: showLoading == true ? null : action,
      child: showLoading == true
          ? LoadingWidget(
              color: backgroundColor != null && backgroundColor != Colors.white
                  ? Colors.white
                  : color ?? Colors.white,
            )
          : child ??
              Text(
                label,
                style: TextStyles.t2.copyWith(
                  color: color ?? Colors.white,
                  fontSize: FontSizes.md,
                ),
              ),
    );
    return shrinkWrap
        ? Center(child: btnChild)
        : SizedBox(
            height: 52,
            width: double.maxFinite,
            child: btnChild,
          );
  }
}
