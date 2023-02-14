// import 'package:contact_picker/contact_picker.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/data/repository/customer_repository.dart';
import 'package:huzz/data/repository/team_repository.dart';
import 'package:huzz/core/constants/app_themes.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      this.hint,
      this.label,
      this.pretext,
      this.sufText,
      this.maxLength,
      this.initialValue,
      this.icon,
      this.enabled,
      this.prefixIcon,
      this.suffixIcon,
      this.keyType,
      this.keyAction,
      this.textEditingController,
      this.onSubmited,
      this.validate,
      this.onChanged,
      this.colors,
      // ignore: non_constant_identifier_names
      this.AllowClickable = false,
      this.validatorText,
      this.inputformater,
      this.onClick});
  final VoidCallback? onClick;
  final Color? colors;
  // ignore: non_constant_identifier_names
  final bool? AllowClickable;
  final String? hint;
  final String? label;
  final String? pretext;
  final String? sufText;
  final String? initialValue;
  final int? maxLength;
  final bool? enabled;
  final Widget? icon, prefixIcon, suffixIcon;
  final TextInputType? keyType;
  final TextEditingController? textEditingController;
  final TextInputAction? keyAction;
  final String? Function(String?)? validate;
  final ValueChanged<String>? onSubmited;
  final ValueChanged<String>? onChanged;
  final String? validatorText;
  final List<TextInputFormatter>? inputformater;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(Insets.sm),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label!,
              style: GoogleFonts.inter(color: Colors.black, fontSize: 12),
            ),
            const Gap(Insets.sm),
            (validatorText != null && validatorText!.isNotEmpty)
                ? Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Text(
                      "*",
                      style: GoogleFonts.inter(color: Colors.red, fontSize: 12),
                    ))
                : const SizedBox.shrink()
          ],
        ),
        GestureDetector(
          onTap: () {
            if (AllowClickable!) onClick!();
          },
          child: TextFormField(
              inputFormatters: inputformater ?? [],
              autofocus: true,
              onChanged: onChanged,
              maxLength: maxLength,
              controller: textEditingController,
              enabled: enabled,
              keyboardType: keyType,
              textInputAction: keyAction,
              validator: (validate == null)
                  ? (value) {
                      if (value == null || value.isEmpty) {
                        return validatorText;
                      }
                      return null;
                    }
                  : validate,
              initialValue: initialValue,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: Insets.md / 0.8,
                  horizontal: Insets.md,
                ),
                isDense: true,
                prefixText: pretext,
                suffixText: sufText,
                focusedBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.backgroundColor, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                enabledBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.backgroundColor, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                border: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.backgroundColor, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                hintText: hint,
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon,
                hintStyle: Theme.of(context).textTheme.headline4!.copyWith(
                      color: colors ?? Colors.black26,
                      fontFamily: 'InterRegular',
                      fontSize: 14,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal,
                    ),
              ),
              onFieldSubmitted: onSubmited),
        )
      ],
    );
  }
}

class CustomTextFieldOptional extends StatelessWidget {
  const CustomTextFieldOptional(
      {super.key,
      this.hint,
      this.label,
      this.pretext,
      this.sufText,
      this.maxLength,
      this.initialValue,
      this.icon,
      this.enabled,
      this.prefixIcon,
      this.suffixIcon,
      this.keyType,
      this.keyAction,
      this.textEditingController,
      this.onSubmited,
      this.validate,
      this.onChanged,
      this.AllowClickable = false,
      this.validatorText,
      this.onClick,
      this.inputformater});
  final VoidCallback? onClick;
  final bool? AllowClickable;
  final String? hint;
  final String? label;
  final String? pretext;
  final String? sufText;
  final String? initialValue;
  final int? maxLength;
  final bool? enabled;
  final Widget? icon, prefixIcon, suffixIcon;
  final TextInputType? keyType;
  final TextEditingController? textEditingController;
  final TextInputAction? keyAction;
  final ValueChanged<String>? validate;
  final ValueChanged<String>? onSubmited;
  final ValueChanged<String>? onChanged;
  final String? validatorText;
  final List<TextInputFormatter>? inputformater;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 9),
              child: Text(
                label!,
                style: GoogleFonts.inter(color: Colors.black, fontSize: 12),
              )),
          GestureDetector(
            onTap: () {
              if (AllowClickable!) onClick!();
            },
            child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: TextFormField(
                  inputFormatters: inputformater ?? [],
                  onChanged: onChanged,
                  maxLength: maxLength,
                  controller: textEditingController,
                  enabled: enabled,
                  keyboardType: keyType,
                  textInputAction: keyAction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return validatorText;
                    }
                    return null;
                  },
                  initialValue: initialValue,
                  decoration: InputDecoration(
                    isDense: true,
                    prefixText: pretext,
                    suffixText: sufText,
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.backgroundColor, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.backgroundColor, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.backgroundColor, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    hintText: hint,
                    prefixIcon: prefixIcon,
                    suffixIcon: suffixIcon,
                    hintStyle: Theme.of(context).textTheme.headline4!.copyWith(
                          fontSize: 14,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                  onFieldSubmitted: onSubmited),
            ),
          )
        ],
      ),
    );
  }
}

class CustomTextFieldOnly extends StatelessWidget {
  const CustomTextFieldOnly(
      {super.key,
      this.hint,
      this.label,
      this.pretext,
      this.sufText,
      this.maxLength,
      this.initialValue,
      this.icon,
      this.enabled,
      this.prefixIcon,
      this.suffixIcon,
      this.keyType,
      this.keyAction,
      this.textEditingController,
      this.onSubmited,
      this.validate,
      this.onChanged,
      this.AllowClickable = false,
      this.validatorText,
      this.onClick,
      this.inputformater});
  final VoidCallback? onClick;
  final bool? AllowClickable;
  final String? hint;
  final String? label;
  final String? pretext;
  final String? sufText;
  final String? initialValue;
  final int? maxLength;
  final bool? enabled;
  final Widget? icon, prefixIcon, suffixIcon;
  final TextInputType? keyType;
  final TextEditingController? textEditingController;
  final TextInputAction? keyAction;
  final ValueChanged<String>? validate;
  final ValueChanged<String>? onSubmited;
  final ValueChanged<String>? onChanged;
  final String? validatorText;
  final List<TextInputFormatter>? inputformater;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(Insets.sm),
        Text(
          label!,
          style: GoogleFonts.inter(color: Colors.black, fontSize: 12),
        ),
        const Gap(Insets.md),
        TextFormField(
            inputFormatters: inputformater ?? [],
            onChanged: onChanged,
            maxLength: maxLength,
            controller: textEditingController,
            enabled: enabled,
            keyboardType: keyType,
            textInputAction: keyAction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return validatorText;
              }
              return null;
            },
            initialValue: initialValue,
            decoration: InputDecoration(
              isDense: true,
              prefixText: pretext,
              suffixText: sufText,
              focusedBorder: const OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.backgroundColor, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              enabledBorder: const OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.backgroundColor, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              border: const OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.backgroundColor, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              hintText: hint,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              hintStyle: Theme.of(context).textTheme.headline4!.copyWith(
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal,
                  ),
            ),
            onFieldSubmitted: onSubmited),
      ],
    );
  }
}

class CustomTextFieldInvoiceOptional extends StatelessWidget {
  const CustomTextFieldInvoiceOptional(
      {super.key,
      this.hint,
      this.label,
      this.pretext,
      this.sufText,
      this.maxLength,
      this.initialValue,
      this.icon,
      this.enabled,
      this.prefixIcon,
      this.suffixIcon,
      this.keyType,
      this.keyAction,
      this.textEditingController,
      this.onSubmited,
      this.validate,
      this.onChanged,
      this.AllowClickable = false,
      this.validatorText,
      this.onClick,
      this.inputformater});
  final VoidCallback? onClick;
  final bool? AllowClickable;
  final String? hint;
  final String? label;
  final String? pretext;
  final String? sufText;
  final String? initialValue;
  final int? maxLength;
  final bool? enabled;
  final Widget? icon, prefixIcon, suffixIcon;
  final TextInputType? keyType;
  final TextEditingController? textEditingController;
  final TextInputAction? keyAction;
  final ValueChanged<String>? validate;
  final ValueChanged<String>? onSubmited;
  final ValueChanged<String>? onChanged;
  final String? validatorText;
  final List<TextInputFormatter>? inputformater;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(Insets.md),
          Text(
            label!,
            style: GoogleFonts.inter(color: Colors.black, fontSize: 12),
          ),
          const Gap(Insets.sm / 2),
          GestureDetector(
            onTap: () {
              if (AllowClickable!) onClick!();
            },
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              child: TextFormField(
                  inputFormatters: inputformater ?? [],
                  onChanged: onChanged,
                  maxLength: maxLength,
                  controller: textEditingController,
                  enabled: enabled,
                  keyboardType: keyType,
                  textInputAction: keyAction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return validatorText;
                    }
                    return null;
                  },
                  initialValue: initialValue,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: Insets.md / 0.8,
                      horizontal: Insets.md,
                    ),
                    isDense: true,
                    prefixText: pretext,
                    suffixText: sufText,
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.backgroundColor, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.backgroundColor, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.backgroundColor, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    hintText: hint,
                    prefixIcon: prefixIcon,
                    suffixIcon: suffixIcon,
                    hintStyle: Theme.of(context).textTheme.headline4!.copyWith(
                          fontSize: 14,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                  onFieldSubmitted: onSubmited),
            ),
          )
        ],
      ),
    );
  }
}

class CustomTextFieldOption extends StatelessWidget {
  const CustomTextFieldOption(
      {super.key,
      this.hint,
      this.label,
      this.pretext,
      this.sufText,
      this.maxLength,
      this.initialValue,
      this.icon,
      this.enabled,
      this.prefixIcon,
      this.suffixIcon,
      this.keyType,
      this.keyAction,
      this.textEditingController,
      this.onSubmited,
      this.validate,
      this.onChanged,
      this.AllowClickable = false,
      this.validatorText,
      this.onClick,
      this.inputformater});
  final VoidCallback? onClick;
  final bool? AllowClickable;
  final String? hint;
  final String? label;
  final String? pretext;
  final String? sufText;
  final String? initialValue;
  final int? maxLength;
  final bool? enabled;
  final Widget? icon, prefixIcon, suffixIcon;
  final TextInputType? keyType;
  final TextEditingController? textEditingController;
  final TextInputAction? keyAction;
  final ValueChanged<String>? validate;
  final ValueChanged<String>? onSubmited;
  final ValueChanged<String>? onChanged;
  final String? validatorText;
  final List<TextInputFormatter>? inputformater;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 9),
              child: Row(
                children: [
                  Text(
                    label!,
                    style: GoogleFonts.inter(color: Colors.black, fontSize: 12),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(Optional)',
                    style: GoogleFonts.inter(color: Colors.grey, fontSize: 12),
                  ),
                ],
              )),
          GestureDetector(
            onTap: () {
              if (AllowClickable!) onClick!();
            },
            child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: TextFormField(
                  inputFormatters: inputformater ?? [],
                  onChanged: onChanged,
                  maxLength: maxLength,
                  controller: textEditingController,
                  enabled: enabled,
                  keyboardType: keyType,
                  textInputAction: keyAction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return validatorText;
                    }
                    return null;
                  },
                  initialValue: initialValue,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: Insets.md / 0.8,
                      horizontal: Insets.md,
                    ),
                    isDense: true,
                    prefixText: pretext,
                    suffixText: sufText,
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.backgroundColor, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.backgroundColor, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.backgroundColor, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    hintText: hint,
                    prefixIcon: prefixIcon,
                    suffixIcon: suffixIcon,
                    hintStyle: Theme.of(context).textTheme.headline4!.copyWith(
                          fontSize: 14,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                  onFieldSubmitted: onSubmited),
            ),
          )
        ],
      ),
    );
  }
}

class CustomTextFieldWithImage extends StatefulWidget {
  const CustomTextFieldWithImage(
      {super.key,
      this.hint,
      this.label,
      this.pretext,
      this.sufText,
      this.maxLength,
      this.initialValue,
      this.icon,
      this.enabled,
      this.prefixIcon,
      this.suffixIcon,
      this.keyType,
      this.keyAction,
      this.contactName,
      this.contactPhone,
      this.contactMail,
      this.onSubmited,
      this.validate,
      this.onChanged,
      this.AllowClickable = false,
      this.validatorText,
      this.onClick,
      this.inputformater});
  final VoidCallback? onClick;
  final bool? AllowClickable;
  final String? hint;
  final String? label;
  final String? pretext;
  final String? sufText;
  final String? initialValue;
  final int? maxLength;
  final bool? enabled;
  final Widget? icon, prefixIcon, suffixIcon;
  final TextInputType? keyType;
  final TextEditingController? contactName, contactPhone, contactMail;
  final TextInputAction? keyAction;
  final ValueChanged<String>? validate;
  final ValueChanged<String>? onSubmited;
  final ValueChanged<String>? onChanged;
  final String? validatorText;
  final List<TextInputFormatter>? inputformater;

  @override
  _CustomTextFieldWithImageState createState() =>
      _CustomTextFieldWithImageState();
}

class _CustomTextFieldWithImageState extends State<CustomTextFieldWithImage> {
  String countryFlag = "NG";
  String countryCode = "234";
  // final ContactPicker _contactPicker = new ContactPicker();
  // Contact? _contact;
  final _customerController = Get.find<CustomerRepository>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 9),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.label!,
                    style: GoogleFonts.inter(color: Colors.black, fontSize: 12),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  (widget.validatorText != null &&
                          widget.validatorText!.isNotEmpty)
                      ? Row(
                          children: [
                            Container(
                                margin: const EdgeInsets.only(top: 5),
                                child: Text(
                                  "*",
                                  style: GoogleFonts.inter(
                                      color: Colors.red, fontSize: 12),
                                )),
                            const SizedBox(width: 8),
                            Container(
                                child: Text(
                              "OR",
                              style: GoogleFonts.inter(
                                  color: Colors.black, fontSize: 12),
                            )),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () async {
                                _customerController.showContactPicker(context);

                                // // Contact contact =
                                // //     await _contactPicker.selectContact();
                                // // setState(() {
                                // //   _contact = contact;
                                // //   widget.contactPhone!.text =
                                // //       _contact!.phoneNumber.number;
                                // //   widget.contactName!.text = _contact!.fullName;
                                // //   print(contact);
                                // });
                              },
                              child: SvgPicture.asset(
                                  'assets/images/select_from_contact.svg'),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () async {
                                _customerController.showContactPicker(context);

                                // // Contact contact =
                                // //     await _contactPicker.selectContact();
                                // // setState(() {
                                // //   _contact = contact;
                                // //   widget.contactPhone!.text =
                                // //       _contact!.phoneNumber.number;
                                // //   widget.contactName!.text = _contact!.fullName;
                                // //   print(contact);
                                // });
                              },
                              child: Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    "Select from Contact",
                                    style: GoogleFonts.inter(
                                        color: AppColors.backgroundColor,
                                        fontSize: 12),
                                  )),
                            ),
                          ],
                        )
                      : Container()
                ],
              )),
          GestureDetector(
            onTap: () {
              if (widget.AllowClickable!) widget.onClick!();
            },
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: TextFormField(
                      onChanged: widget.onChanged,
                      maxLength: widget.maxLength,
                      controller: widget.contactName,
                      enabled: widget.enabled,
                      keyboardType: widget.keyType,
                      textInputAction: widget.keyAction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return widget.validatorText;
                        }
                        return null;
                      },
                      initialValue: widget.initialValue,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: Insets.md / 0.8,
                          horizontal: Insets.md,
                        ),
                        isDense: true,
                        prefixText: widget.pretext,
                        suffixText: widget.sufText,
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        hintText: widget.hint,
                        prefixIcon: widget.prefixIcon,
                        suffixIcon: widget.suffixIcon,
                        hintStyle:
                            Theme.of(context).textTheme.headline4!.copyWith(
                                  fontSize: 14,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.normal,
                                ),
                      ),
                      onFieldSubmitted: widget.onSubmited),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: AppColors.backgroundColor, width: 2.0),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showCountryCode(context);
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                                right: BorderSide(
                                    color: AppColors.backgroundColor,
                                    width: 2)),
                          ),
                          height: 50,
                          width: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 10),
                              Flag.fromString(countryFlag,
                                  height: 30, width: 30),
                              const SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                size: 24,
                                color:
                                    AppColors.backgroundColor.withOpacity(0.5),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: widget.contactPhone,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              hintText: "8123456789",
                              hintStyle: GoogleFonts.inter(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                              prefixText: "+$countryCode ",
                              prefixStyle: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black)),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    children: [
                      Text(
                        'Email',
                        style: GoogleFonts.inter(
                            color: Colors.black, fontSize: 12),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: TextFormField(
                      onChanged: widget.onChanged,
                      maxLength: widget.maxLength,
                      controller: widget.contactMail,
                      enabled: widget.enabled,
                      keyboardType: widget.keyType,
                      textInputAction: widget.keyAction,
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return widget.validatorText;
                      //   }
                      //   return null;
                      // },
                      initialValue: widget.initialValue,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: Insets.md / 0.8,
                          horizontal: Insets.md,
                        ),
                        isDense: true,
                        prefixText: widget.pretext,
                        suffixText: widget.sufText,
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        // labelText: label,
                        hintText: 'yourmail@mail.com',
                        prefixIcon: widget.prefixIcon,
                        suffixIcon: widget.suffixIcon,
                        // labelStyle: Theme.of(context).textTheme.headline4!.copyWith(
                        //     color: AppColors.secondary,
                        //     fontFamily: FontFamily.sofiaPro,
                        //     fontSize: 14),
                        hintStyle:
                            Theme.of(context).textTheme.headline4!.copyWith(
                                  // color: AppColors.accentcolor,
                                  // fontFamily: FontFamily.sofiaPro,
                                  fontSize: 14,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.normal,
                                ),
                      ),
                      // validator: validate,
                      onFieldSubmitted: widget.onSubmited),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future showCountryCode(BuildContext context) async {
    showCountryPicker(
      context: context,
      showPhoneCode:
          true, // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        countryCode = country.toJson()['e164_cc'];
        countryFlag = country.toJson()['iso2_cc'];
        country.toJson();
        setState(() {});

        print('Select country: ${country.toJson()}');
      },
    );
  }
}

class CustomAddMemberTextField extends StatefulWidget {
  const CustomAddMemberTextField(
      {super.key,
      this.hint,
      this.label,
      this.pretext,
      this.sufText,
      this.maxLength,
      this.initialValue,
      this.icon,
      this.enabled,
      this.prefixIcon,
      this.suffixIcon,
      this.keyType,
      this.keyAction,
      this.contactName,
      this.contactPhone,
      this.contactMail,
      this.onSubmited,
      this.validate,
      this.onChanged,
      this.AllowClickable = false,
      this.validatorText,
      this.onClick,
      this.inputformater});
  final VoidCallback? onClick;
  final bool? AllowClickable;
  final String? hint;
  final String? label;
  final String? pretext;
  final String? sufText;
  final String? initialValue;
  final int? maxLength;
  final bool? enabled;
  final Widget? icon, prefixIcon, suffixIcon;
  final TextInputType? keyType;
  final TextEditingController? contactName, contactPhone, contactMail;
  final TextInputAction? keyAction;
  final ValueChanged<String>? validate;
  final ValueChanged<String>? onSubmited;
  final ValueChanged<String>? onChanged;
  final String? validatorText;
  final List<TextInputFormatter>? inputformater;

  @override
  _CustomAddMemberTextFieldState createState() =>
      _CustomAddMemberTextFieldState();
}

class _CustomAddMemberTextFieldState extends State<CustomAddMemberTextField> {
  String countryFlag = "NG";
  String countryCode = "234";
  // final ContactPicker _contactPicker = new ContactPicker();
  // Contact? _contact;
  final _teamController = Get.find<TeamRepository>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 9),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.label!,
                    style: GoogleFonts.inter(color: Colors.black, fontSize: 12),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  (widget.validatorText != null &&
                          widget.validatorText!.isNotEmpty)
                      ? Row(
                          children: [
                            Container(
                                margin: const EdgeInsets.only(top: 5),
                                child: Text(
                                  "*",
                                  style: GoogleFonts.inter(
                                      color: Colors.red, fontSize: 12),
                                )),
                            const SizedBox(width: 8),
                            Container(
                                child: Text(
                              "OR",
                              style: GoogleFonts.inter(
                                  color: Colors.black, fontSize: 12),
                            )),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () async {
                                _teamController
                                    .showContactPickerForTeams(context);

                                // // Contact contact =
                                // //     await _contactPicker.selectContact();
                                // // setState(() {
                                // //   _contact = contact;
                                // //   widget.contactPhone!.text =
                                // //       _contact!.phoneNumber.number;
                                // //   widget.contactName!.text = _contact!.fullName;
                                // //   print(contact);
                                // });
                              },
                              child: SvgPicture.asset(
                                  'assets/images/select_from_contact.svg'),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () async {
                                _teamController
                                    .showContactPickerForTeams(context);

                                // // Contact contact =
                                // //     await _contactPicker.selectContact();
                                // // setState(() {
                                // //   _contact = contact;
                                // //   widget.contactPhone!.text =
                                // //       _contact!.phoneNumber.number;
                                // //   widget.contactName!.text = _contact!.fullName;
                                // //   print(contact);
                                // });
                              },
                              child: Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    "Select from Contact",
                                    style: GoogleFonts.inter(
                                        color: AppColors.backgroundColor,
                                        fontSize: 12),
                                  )),
                            ),
                          ],
                        )
                      : Container()
                ],
              )),
          GestureDetector(
            onTap: () {
              if (widget.AllowClickable!) widget.onClick!();
            },
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: TextFormField(
                      onChanged: widget.onChanged,
                      maxLength: widget.maxLength,
                      controller: widget.contactName,
                      enabled: widget.enabled,
                      keyboardType: widget.keyType,
                      textInputAction: widget.keyAction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return widget.validatorText;
                        }
                        return null;
                      },
                      initialValue: widget.initialValue,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: Insets.md / 0.8,
                          horizontal: Insets.md,
                        ),
                        isDense: true,
                        prefixText: widget.pretext,
                        suffixText: widget.sufText,
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        hintText: widget.hint,
                        prefixIcon: widget.prefixIcon,
                        suffixIcon: widget.suffixIcon,
                        hintStyle:
                            Theme.of(context).textTheme.headline4!.copyWith(
                                  fontSize: 14,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.normal,
                                ),
                      ),
                      onFieldSubmitted: widget.onSubmited),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: AppColors.backgroundColor, width: 2.0),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showCountryCode(context);
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                                right: BorderSide(
                                    color: AppColors.backgroundColor,
                                    width: 2)),
                          ),
                          height: 50,
                          width: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 10),
                              Flag.fromString(countryFlag,
                                  height: 30, width: 30),
                              const SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                size: 24,
                                color:
                                    AppColors.backgroundColor.withOpacity(0.5),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: widget.contactPhone,
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: Insets.md / 0.8,
                              horizontal: Insets.md,
                            ),
                            hintText: "8123456789",
                            hintStyle: GoogleFonts.inter(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                            prefixText: "+$countryCode ",
                            prefixStyle: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    children: [
                      Text(
                        'Email',
                        style: GoogleFonts.inter(
                            color: Colors.black, fontSize: 12),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      (widget.validatorText != null &&
                              widget.validatorText!.isNotEmpty)
                          ? Row(
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      "*",
                                      style: GoogleFonts.inter(
                                          color: Colors.red, fontSize: 12),
                                    )),
                                const SizedBox(width: 8),
                              ],
                            )
                          : Container()
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: TextFormField(
                      onChanged: widget.onChanged,
                      maxLength: widget.maxLength,
                      controller: widget.contactMail,
                      enabled: widget.enabled,
                      keyboardType: widget.keyType,
                      textInputAction: widget.keyAction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return widget.validatorText;
                        }
                        return null;
                      },
                      initialValue: widget.initialValue,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: Insets.md / 0.8,
                          horizontal: Insets.md,
                        ),
                        isDense: true,
                        prefixText: widget.pretext,
                        suffixText: widget.sufText,
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        // labelText: label,
                        hintText: 'yourmail@mail.com',
                        prefixIcon: widget.prefixIcon,
                        suffixIcon: widget.suffixIcon,
                        // labelStyle: Theme.of(context).textTheme.headline4!.copyWith(
                        //     color: AppColors.secondary,
                        //     fontFamily: FontFamily.sofiaPro,
                        //     fontSize: 14),
                        hintStyle:
                            Theme.of(context).textTheme.headline4!.copyWith(
                                  // color: AppColors.accentcolor,
                                  // fontFamily: FontFamily.sofiaPro,
                                  fontSize: 14,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.normal,
                                ),
                      ),
                      // validator: validate,
                      onFieldSubmitted: widget.onSubmited),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future showCountryCode(BuildContext context) async {
    showCountryPicker(
      context: context,
      showPhoneCode:
          true, // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        countryCode = country.toJson()['e164_cc'];
        countryFlag = country.toJson()['iso2_cc'];
        country.toJson();
        setState(() {});

        print('Select country: ${country.toJson()}');
      },
    );
  }
}

class CustomTextFieldWithImageTransaction extends StatefulWidget {
  const CustomTextFieldWithImageTransaction(
      {super.key,
      this.hint,
      this.label,
      this.pretext,
      this.sufText,
      this.maxLength,
      this.initialValue,
      this.icon,
      this.enabled,
      this.prefixIcon,
      this.suffixIcon,
      this.keyType,
      this.keyAction,
      this.contactName,
      this.contactPhone,
      this.contactMail,
      this.contactAmount,
      this.contactDescription,
      this.onSubmited,
      this.validate,
      this.onChanged,
      this.AllowClickable = false,
      this.validatorText,
      this.inputformater,
      this.onClick});
  final VoidCallback? onClick;
  final bool? AllowClickable;
  final String? hint;
  final String? label;
  final String? pretext;
  final String? sufText;
  final String? initialValue;
  final int? maxLength;
  final bool? enabled;
  final Widget? icon, prefixIcon, suffixIcon;
  final TextInputType? keyType;
  final TextEditingController? contactName,
      contactPhone,
      contactMail,
      contactAmount,
      contactDescription;
  final TextInputAction? keyAction;
  final ValueChanged<String>? validate;
  final ValueChanged<String>? onSubmited;
  final ValueChanged<String>? onChanged;
  final String? validatorText;
  final List<TextInputFormatter>? inputformater;

  @override
  _CustomTextFieldWithImageTransactionState createState() =>
      _CustomTextFieldWithImageTransactionState();
}

class _CustomTextFieldWithImageTransactionState
    extends State<CustomTextFieldWithImageTransaction> {
  String countryFlag = "NG";
  String countryCode = "234";
  final _customerController = Get.find<CustomerRepository>();
  // final ContactPicker _contactPicker = new ContactPicker();
  // Contact? _contact;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.label!,
                style: GoogleFonts.inter(color: Colors.black, fontSize: 12),
              ),
              const SizedBox(
                width: 5,
              ),
              (widget.validatorText != null && widget.validatorText!.isNotEmpty)
                  ? Row(
                      children: [
                        Container(
                            margin: const EdgeInsets.only(top: 5),
                            child: Text(
                              "*",
                              style: GoogleFonts.inter(
                                  color: Colors.red, fontSize: 12),
                            )),
                        const SizedBox(width: 8),
                        Container(
                            child: Text(
                          "OR",
                          style: GoogleFonts.inter(
                              color: Colors.black, fontSize: 12),
                        )),
                        const SizedBox(width: 8),
                        SvgPicture.asset(
                            'assets/images/select_from_contact.svg'),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () async {
                            print("contact should show");
                            await _customerController
                                .showContactPicker(context);
                          },
                          child: Container(
                              margin: const EdgeInsets.only(top: 5),
                              child: Text(
                                "Select from Contact",
                                style: GoogleFonts.inter(
                                    color: AppColors.backgroundColor,
                                    fontSize: 12),
                              )),
                        ),
                      ],
                    )
                  : Container()
            ],
          )),
          GestureDetector(
            onTap: () {
              if (widget.AllowClickable!) widget.onClick!();
            },
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: TextFormField(
                      onChanged: widget.onChanged,
                      maxLength: widget.maxLength,
                      controller: widget.contactName,
                      enabled: widget.enabled,
                      keyboardType: widget.keyType,
                      textInputAction: widget.keyAction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Name is required";
                        }
                        return null;
                      },
                      initialValue: widget.initialValue,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: Insets.md / 0.8,
                          horizontal: Insets.md,
                        ),
                        isDense: true,
                        prefixText: widget.pretext,
                        suffixText: widget.sufText,
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        hintText: 'customer name',
                        prefixIcon: widget.prefixIcon,
                        suffixIcon: widget.suffixIcon,
                        hintStyle:
                            Theme.of(context).textTheme.headline4!.copyWith(
                                  fontSize: 14,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.normal,
                                ),
                      ),
                      onFieldSubmitted: widget.onSubmited),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: AppColors.backgroundColor, width: 2.0),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showCountryCode(context);
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                                right: BorderSide(
                                    color: AppColors.backgroundColor,
                                    width: 2)),
                          ),
                          height: 50,
                          width: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 10),
                              Flag.fromString(countryFlag,
                                  height: 30, width: 30),
                              const SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                size: 24,
                                color:
                                    AppColors.backgroundColor.withOpacity(0.5),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: widget.contactPhone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Phone Number is required";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: Insets.md / 0.8,
                                horizontal: Insets.md,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: "8123456789",
                              hintStyle: GoogleFonts.inter(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                              prefixText: "+$countryCode ",
                              prefixStyle: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black)),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Row(
                  children: [
                    Text(
                      'Email',
                      style:
                          GoogleFonts.inter(color: Colors.black, fontSize: 12),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    // (widget.validatorText != null &&
                    //         widget.validatorText!.isNotEmpty)
                    //     ? Row(
                    //         children: [
                    //           Container(
                    //               margin: EdgeInsets.only(top: 5),
                    //               child: Text(
                    //                 "*",
                    //                 style: GoogleFonts.inter(
                    //                     color: Colors.red, fontSize: 12),
                    //               )),
                    //           SizedBox(width: 8),
                    //         ],
                    //       )
                    //     : Container()
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: TextFormField(
                      onChanged: widget.onChanged,
                      maxLength: widget.maxLength,
                      controller: widget.contactMail,
                      enabled: widget.enabled,
                      keyboardType: widget.keyType,
                      textInputAction: widget.keyAction,
                      initialValue: widget.initialValue,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: Insets.md / 0.8,
                          horizontal: Insets.md,
                        ),
                        isDense: true,
                        prefixText: widget.pretext,
                        suffixText: widget.sufText,
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        hintText: 'yourmail@mail.com',
                        prefixIcon: widget.prefixIcon,
                        suffixIcon: widget.suffixIcon,
                        hintStyle:
                            Theme.of(context).textTheme.headline4!.copyWith(
                                  fontSize: 14,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.normal,
                                ),
                      ),
                      onFieldSubmitted: widget.onSubmited),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future showCountryCode(BuildContext context) async {
    showCountryPicker(
      context: context,
      showPhoneCode:
          true, // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        countryCode = country.toJson()['e164_cc'];
        countryFlag = country.toJson()['iso2_cc'];
        country.toJson();
        setState(() {});

        print('Select country: ${country.toJson()}');
      },
    );
  }
}

class CustomTextFieldInvoice extends StatefulWidget {
  const CustomTextFieldInvoice(
      {super.key,
      this.hint,
      this.label,
      this.pretext,
      this.sufText,
      this.maxLength,
      this.initialValue,
      this.icon,
      this.enabled,
      this.prefixIcon,
      this.suffixIcon,
      this.keyType,
      this.keyAction,
      this.contactName,
      this.contactPhone,
      this.contactMail,
      this.contactAddress,
      this.onSubmited,
      this.validate,
      this.onChanged,
      // ignore: non_constant_identifier_names
      this.AllowClickable = false,
      this.validatorText,
      this.onClick,
      this.contactAmount,
      this.contactDescription,
      this.inputformater});
  final VoidCallback? onClick;
  // ignore: non_constant_identifier_names
  final bool? AllowClickable;
  final String? hint;
  final String? label;
  final String? pretext;
  final String? sufText;
  final String? initialValue;
  final int? maxLength;
  final bool? enabled;
  final Widget? icon, prefixIcon, suffixIcon;
  final TextInputType? keyType;
  final TextEditingController? contactName,
      contactPhone,
      contactMail,
      contactAmount,
      contactDescription,
      contactAddress;
  final TextInputAction? keyAction;
  final ValueChanged<String>? validate;
  final ValueChanged<String>? onSubmited;
  final ValueChanged<String>? onChanged;
  final String? validatorText;
  final List<TextInputFormatter>? inputformater;

  @override
  _CustomTextFieldInvoiceState createState() => _CustomTextFieldInvoiceState();
}

class _CustomTextFieldInvoiceState extends State<CustomTextFieldInvoice> {
  String countryFlag = "NG";
  String countryCode = "234";
  final _customerController = Get.find<CustomerRepository>();
  // final ContactPicker _contactPicker = new ContactPicker();
  // Contact? _contact;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.label!,
                style: GoogleFonts.inter(color: Colors.black, fontSize: 12),
              ),
              const SizedBox(
                width: 5,
              ),
              (widget.validatorText != null && widget.validatorText!.isNotEmpty)
                  ? Row(
                      children: [
                        const SizedBox(width: 8),
                        Container(
                            child: Text(
                          "OR",
                          style: GoogleFonts.inter(
                              color: Colors.black, fontSize: 12),
                        )),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () async {
                            print("contact should show");
                            await _customerController
                                .showContactPicker(context);
                            // Contact contact =
                            //     await _contactPicker.selectContact();
                            // setState(() {
                            //   _contact = contact;
                            //   widget.contactPhone!.text =
                            //       _contact!.phoneNumber.number;
                            //   widget.contactName!.text = _contact!.fullName;
                            //   print(contact);
                            // });
                          },
                          child: SvgPicture.asset(
                              'assets/images/select_from_contact.svg'),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () async {
                            print("contact should show");
                            await _customerController
                                .showContactPicker(context);
                            // Contact contact =
                            //     await _contactPicker.selectContact();
                            // setState(() {
                            //   _contact = contact;
                            //   widget.contactPhone!.text =
                            //       _contact!.phoneNumber.number;
                            //   widget.contactName!.text = _contact!.fullName;
                            //   print(contact);
                            // });
                          },
                          child: Container(
                              margin: const EdgeInsets.only(top: 5),
                              child: Text(
                                "Select from Contact",
                                style: GoogleFonts.inter(
                                    color: AppColors.backgroundColor,
                                    fontSize: 12),
                              )),
                        ),
                      ],
                    )
                  : Container()
            ],
          )),
          GestureDetector(
            onTap: () {
              if (widget.AllowClickable!) widget.onClick!();
            },
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: TextFormField(
                      onChanged: widget.onChanged,
                      maxLength: widget.maxLength,
                      controller: widget.contactName,
                      enabled: widget.enabled,
                      keyboardType: widget.keyType,
                      textInputAction: widget.keyAction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return widget.validatorText;
                        }
                        return null;
                      },
                      initialValue: widget.initialValue,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: Insets.md / 0.8,
                          horizontal: Insets.md,
                        ),
                        isDense: true,
                        prefixText: widget.pretext,
                        suffixText: widget.sufText,
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        hintText: 'customer name',
                        prefixIcon: widget.prefixIcon,
                        suffixIcon: widget.suffixIcon,
                        hintStyle:
                            Theme.of(context).textTheme.headline4!.copyWith(
                                  fontSize: 14,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.normal,
                                ),
                      ),
                      onFieldSubmitted: widget.onSubmited),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: AppColors.backgroundColor, width: 2.0),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showCountryCode(context);
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                                right: BorderSide(
                                    color: AppColors.backgroundColor,
                                    width: 2)),
                          ),
                          height: 50,
                          width: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 10),
                              Flag.fromString(countryFlag,
                                  height: 30, width: 30),
                              const SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                size: 24,
                                color:
                                    AppColors.backgroundColor.withOpacity(0.5),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: widget.contactPhone,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: Insets.md / 0.8,
                                horizontal: Insets.md,
                              ),
                              border: InputBorder.none,
                              hintText: "8123456789",
                              hintStyle: GoogleFonts.inter(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                              prefixText: "+$countryCode ",
                              prefixStyle: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black)),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Text(
                      'Email',
                      style:
                          GoogleFonts.inter(color: Colors.black, fontSize: 12),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: TextFormField(
                      onChanged: widget.onChanged,
                      maxLength: widget.maxLength,
                      controller: widget.contactMail,
                      enabled: widget.enabled,
                      keyboardType: widget.keyType,
                      textInputAction: widget.keyAction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return widget.validatorText;
                        }
                        return null;
                      },
                      initialValue: widget.initialValue,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: Insets.md / 0.8,
                          horizontal: Insets.md,
                        ),
                        isDense: true,
                        prefixText: widget.pretext,
                        suffixText: widget.sufText,
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        hintText: 'yourmail@mail.com',
                        prefixIcon: widget.prefixIcon,
                        suffixIcon: widget.suffixIcon,
                        hintStyle:
                            Theme.of(context).textTheme.headline4!.copyWith(
                                  fontSize: 14,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.normal,
                                ),
                      ),
                      onFieldSubmitted: widget.onSubmited),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: TextFormField(
                      onChanged: widget.onChanged,
                      maxLength: widget.maxLength,
                      controller: widget.contactAmount,
                      enabled: widget.enabled,
                      keyboardType: widget.keyType,
                      textInputAction: widget.keyAction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return widget.validatorText;
                        }
                        return null;
                      },
                      initialValue: widget.initialValue,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: Insets.md / 0.8,
                          horizontal: Insets.md,
                        ),
                        isDense: true,
                        prefixText: widget.pretext,
                        suffixText: widget.sufText,
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        hintText: '0.0',
                        prefixIcon: widget.prefixIcon,
                        suffixIcon: widget.suffixIcon,
                        hintStyle:
                            Theme.of(context).textTheme.headline4!.copyWith(
                                  fontSize: 14,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.normal,
                                ),
                      ),
                      onFieldSubmitted: widget.onSubmited),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Row(
                  children: [
                    Text(
                      'Address',
                      style:
                          GoogleFonts.inter(color: Colors.black, fontSize: 12),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "(Optional)",
                      style:
                          GoogleFonts.inter(color: Colors.grey, fontSize: 12),
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: TextFormField(
                      onChanged: widget.onChanged,
                      maxLength: widget.maxLength,
                      controller: widget.contactAddress,
                      enabled: widget.enabled,
                      keyboardType: widget.keyType,
                      textInputAction: widget.keyAction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return widget.validatorText;
                        }
                        return null;
                      },
                      initialValue: widget.initialValue,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: Insets.md / 0.8,
                          horizontal: Insets.md,
                        ),
                        isDense: true,
                        prefixText: widget.pretext,
                        suffixText: widget.sufText,
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        prefixIcon: widget.prefixIcon,
                        suffixIcon: widget.suffixIcon,
                        hintStyle:
                            Theme.of(context).textTheme.headline4!.copyWith(
                                  fontSize: 14,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.normal,
                                ),
                      ),
                      onFieldSubmitted: widget.onSubmited),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future showCountryCode(BuildContext context) async {
    showCountryPicker(
      context: context,
      showPhoneCode:
          true, // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        countryCode = country.toJson()['e164_cc'];
        countryFlag = country.toJson()['iso2_cc'];
        country.toJson();
        setState(() {});

        print('Select country: ${country.toJson()}');
      },
    );
  }
}
