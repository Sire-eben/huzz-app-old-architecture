import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/widgets/state/loading.dart';

class Button extends StatelessWidget {
  final String label;
  final VoidCallback action;
  final bool? showLoading;
  final Color? color, backgroundColor;
  final double? height;
  final bool shrinkWrap;
  final bool children;

  const Button({
    required this.label,
    required this.action,
    this.shrinkWrap = false,
    this.showLoading,
    this.color,
    this.backgroundColor,
    Key? key,
    this.height,
    this.children = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final btnChild = ElevatedButton(
      style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
          elevation: MaterialStateProperty.all(0),
          backgroundColor: backgroundColor != null
              ? MaterialStateProperty.all<Color>(backgroundColor!)
              : null,
          shape: MaterialStateProperty.all(const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Corners.smRadius)))),
      onPressed: showLoading == true ? null : action,
      child: showLoading == true
          ? LoadingWidget(
              color: backgroundColor != null && backgroundColor != Colors.white
                  ? AppColors.primaryColor
                  : color ?? Colors.white,
            )
          : children == true
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style:
                          GoogleFonts.inter(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: AppColors.backgroundColor,
                        size: 16,
                      ),
                    )
                  ],
                )
              : Text(
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
            height: height ?? 60,
            width: double.maxFinite,
            child: btnChild,
          );
  }
}
