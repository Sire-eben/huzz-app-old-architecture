import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/widgets/state/loading.dart';

class OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback action;
  final bool? showLoading;
  final Color? outlineColor, backgroundColor;
  final Widget? child;
  const OutlineButton({
    required this.label,
    required this.action,
    this.showLoading,
    this.outlineColor,
    this.backgroundColor,
    this.child,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.maxFinite,
      child: ElevatedButton(
        style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
              backgroundColor: backgroundColor == null
                  ? MaterialStateProperty.all<Color>(AppColors.whiteColor)
                  : MaterialStateProperty.all<Color>(backgroundColor!),
              side: MaterialStateProperty.all<BorderSide>(
                BorderSide(
                  color: outlineColor ?? AppColors.primaryColor,
                ),
              ),
            ),
        onPressed: showLoading == true ? null : action,
        child: showLoading == true
            ? LoadingWidget(color: outlineColor ?? AppColors.primaryColor)
            : child ??
                Text(
                  label,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: outlineColor ?? AppColors.primaryColor,
                    fontSize: FontSizes.md,
                  ),
                ),
      ),
    );
  }
}
