import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/widgets/state/loading.dart';

class AppOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback action;
  final bool? showLoading;
  final Color? outlineColor, backgroundColor;
  final Widget? child;
  const AppOutlineButton({
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
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(width: 1, color: AppColors.primaryColor),
            ),
            elevation: 0),
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
