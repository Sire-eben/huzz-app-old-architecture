import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:gap/gap.dart";
import 'package:huzz/core/constants/app_themes.dart';

class TextInputField extends StatelessWidget {
  final String? labelText, prefixText;
  final String? initialValue;
  final Widget? suffixIcon;
  final TextInputType? inputType;
  final String? Function(String? input)? validator;
  final Function(String input)? onChanged;
  final Function(String?)? onSaved;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final FocusNode? focusNode;
  final String? hintText;
  final bool obscureText;
  final Widget? prefixIcon;
  final TextEditingController? controller;
  final bool enabled;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final String? suffixText;
  final InputDecoration? decoration;
  final AutovalidateMode? autoValidateMode;
  final TextCapitalization? textCapitalization;

  const TextInputField({
    Key? key,
    this.labelText,
    this.prefixText,
    this.initialValue,
    this.style,
    this.suffixIcon,
    this.inputType,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.inputFormatters,
    this.focusNode,
    this.hintText,
    this.prefixIcon,
    this.controller,
    this.labelStyle,
    this.hintStyle,
    this.suffixText,
    this.decoration,
    this.autoValidateMode,
    this.maxLines = 1,
    this.enabled = true,
    this.obscureText = false,
    this.textCapitalization,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const underlinedInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Corners.mdRadius),
      borderSide: BorderSide(
        color: AppColors.primaryColor,
        width: 0.9,
      ),
    );

    final underlinedInputErrorBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Corners.mdRadius),
      borderSide: underlinedInputBorder.borderSide.copyWith(
        color: AppColors.error,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(
            labelText!,
            style: TextStyles.b2,
          ),
          const Gap(4),
        ],
        TextFormField(
          controller: controller,
          onSaved: (input) => onSaved?.call((input ?? "").trim()),
          autovalidateMode: autoValidateMode,
          obscureText: obscureText,
          maxLines: maxLines,
          focusNode: focusNode,
          inputFormatters: inputFormatters,
          initialValue: initialValue,
          keyboardType: inputType,
          enabled: enabled,
          onChanged: onChanged,
          validator: validator,
          style: style,
          cursorColor: AppColors.primaryColor,
          textCapitalization: textCapitalization ?? TextCapitalization.none,
          decoration: decoration ??
              InputDecoration(
                suffixText: suffixText,
                prefixText: prefixText,
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon,
                hintText: hintText,
                labelStyle: labelStyle,
                hintStyle: hintStyle ??
                    TextStyle(
                      color: AppColors.primaryColor.withOpacity(0.8),
                    ),
                enabledBorder: underlinedInputBorder,
                focusedBorder: underlinedInputBorder.copyWith(
                  borderSide: underlinedInputBorder.borderSide
                      .copyWith(color: AppColors.primaryColor, width: 1.4),
                ),
                errorBorder: underlinedInputErrorBorder,
                focusedErrorBorder: underlinedInputErrorBorder,
                disabledBorder: underlinedInputBorder.copyWith(
                  borderSide: underlinedInputBorder.borderSide.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ),
        ),
        const Gap(Insets.md),
      ],
    );
  }
}
