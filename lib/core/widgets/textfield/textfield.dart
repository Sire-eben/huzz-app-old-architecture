import 'package:country_picker/country_picker.dart';
import 'package:flag/flag_widget.dart';
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:gap/gap.dart";
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/util/text_input.dart';
import 'package:huzz/core/util/validators.dart';

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
        borderSide: BorderSide(color: AppColors.backgroundColor, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(10)));

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
                      const TextStyle(
                        color: Colors.black54,
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
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: Insets.md * 1.2,
                    horizontal: Insets.md,
                  )),
        ),
        const Gap(Insets.md),
      ],
    );
  }
}

class PhoneNumberTextInputField extends StatefulWidget {
  final String? labelText;
  final PhoneNumber? initialValue;
  final Function(String input)? onChanged;
  final Function(Country selectedCountry)? onSelect;
  final Function(PhoneNumber?)? onSaved;
  final FocusNode? focusNode;
  final String? hintText;
  final TextEditingController? controller;
  final bool enabled;
  final TextStyle? labelStyle, style;

  const PhoneNumberTextInputField({
    Key? key,
    this.labelText,
    this.initialValue,
    this.onChanged,
    this.onSelect,
    this.onSaved,
    this.focusNode,
    this.hintText,
    this.controller,
    this.labelStyle,
    this.style,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<PhoneNumberTextInputField> createState() =>
      _PhoneNumberTextInputFieldState();
}

class _PhoneNumberTextInputFieldState extends State<PhoneNumberTextInputField> {
  String countryFlag = "NG";
  late PhoneNumberCountry phoneNumberCountry;
  @override
  void initState() {
    super.initState();
    phoneNumberCountry = phoneNumberCountryList()[0];
  }

  @override
  Widget build(BuildContext context) {
    return TextInputField(
      style: widget.style,
      prefixIcon: GestureDetector(
        onTap: () => showCountryPicker(
          context: context,
          onSelect: (value) {},
        ),
        child: SizedBox(
          width: 44,
          child: Padding(
            padding: const EdgeInsets.all(Insets.sm),
            child: Center(
              child: Flag.fromString(countryFlag, height: 30, width: 30),
            ),
          ),
        ),
      ),
      labelText: widget.labelText ?? "Phone Number",
      hintText: widget.hintText ?? "8123456789",
      initialValue: widget.initialValue?.number,
      inputType: TextInputType.number,
      onChanged: widget.onChanged,
      onSaved: (input) => widget.onSaved?.call(
        PhoneNumber(
          number:
              "${phoneNumberCountry.countryCode}${input!.startsWith("0") ? input.substring(1) : input}",
          dialCode: phoneNumberCountry.countryCode,
        ),
      ),
      validator: (input) => Validators.validatePhoneNumber(
          maxLength: phoneNumberCountry.maxLength)(input),
      inputFormatters: [
        LengthLimitingTextInputFormatter(phoneNumberCountry.maxLength),
        FilteringTextInputFormatter.digitsOnly,
      ],
      focusNode: widget.focusNode,
      controller: widget.controller,
      enabled: widget.enabled,
      labelStyle: widget.labelStyle,
    );
  }
}
