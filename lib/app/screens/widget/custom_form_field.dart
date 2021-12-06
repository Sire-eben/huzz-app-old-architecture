// import 'package:contact_picker/contact_picker.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:huzz/colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {this.hint,
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
  final TextEditingController? textEditingController;
  final TextInputAction? keyAction;
  final ValueChanged<String>? validate;
  final ValueChanged<String>? onSubmited;
  final ValueChanged<String>? onChanged;
  final String? validatorText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 9),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    label!,
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  (validatorText != null && validatorText!.isNotEmpty)
                      ? Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Text(
                            "*",
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ))
                      : Container()
                ],
              )),
          GestureDetector(
            onTap: () {
              if (AllowClickable!) onClick!();
            },
            child: Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 10),
              child: TextFormField(
                  onChanged: this.onChanged,
                  maxLength: this.maxLength,
                  controller: textEditingController,
                  enabled: enabled,
                  keyboardType: this.keyType,
                  textInputAction: this.keyAction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return validatorText;
                    }
                    return null;
                  },
                  initialValue: this.initialValue,
                  decoration: InputDecoration(
                    isDense: true,
                    prefixText: this.pretext,
                    suffixText: this.sufText,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().backgroundColor, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().backgroundColor, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().backgroundColor, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    // labelText: label,
                    hintText: hint,
                    prefixIcon: prefixIcon,
                    suffixIcon: suffixIcon,
                    // labelStyle: Theme.of(context).textTheme.headline4!.copyWith(
                    //     color: AppColors.secondary,
                    //     fontFamily: FontFamily.sofiaPro,
                    //     fontSize: 14),
                    hintStyle: Theme.of(context).textTheme.headline4!.copyWith(
                          color: Colors.black26,
                          fontFamily: 'DMSans',
                          fontSize: 14,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                  // validator: validate,
                  onFieldSubmitted: onSubmited),
            ),
          )
        ],
      ),
    );
  }
}

class CustomTextFieldOptional extends StatelessWidget {
  const CustomTextFieldOptional(
      {this.hint,
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
  final TextEditingController? textEditingController;
  final TextInputAction? keyAction;
  final ValueChanged<String>? validate;
  final ValueChanged<String>? onSubmited;
  final ValueChanged<String>? onChanged;
  final String? validatorText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 9),
              child: Text(
                label!,
                style: TextStyle(color: Colors.black, fontSize: 12),
              )),
          GestureDetector(
            onTap: () {
              if (AllowClickable!) onClick!();
            },
            child: Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 10),
              child: TextFormField(
                  onChanged: this.onChanged,
                  maxLength: this.maxLength,
                  controller: textEditingController,
                  enabled: enabled,
                  keyboardType: this.keyType,
                  textInputAction: this.keyAction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return validatorText;
                    }
                    return null;
                  },
                  initialValue: this.initialValue,
                  decoration: InputDecoration(
                    isDense: true,
                    prefixText: this.pretext,
                    suffixText: this.sufText,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().backgroundColor, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().backgroundColor, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().backgroundColor, width: 2),
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
      {this.hint,
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
  final TextEditingController? textEditingController;
  final TextInputAction? keyAction;
  final ValueChanged<String>? validate;
  final ValueChanged<String>? onSubmited;
  final ValueChanged<String>? onChanged;
  final String? validatorText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: TextFormField(
          onChanged: this.onChanged,
          maxLength: this.maxLength,
          controller: textEditingController,
          enabled: enabled,
          keyboardType: this.keyType,
          textInputAction: this.keyAction,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return validatorText;
            }
            return null;
          },
          initialValue: this.initialValue,
          decoration: InputDecoration(
            isDense: true,
            prefixText: this.pretext,
            suffixText: this.sufText,
            focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: AppColor().backgroundColor, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: AppColor().backgroundColor, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            border: OutlineInputBorder(
                borderSide:
                    BorderSide(color: AppColor().backgroundColor, width: 2),
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
    );
  }
}

class CustomTextFieldInvoiceOptional extends StatelessWidget {
  const CustomTextFieldInvoiceOptional(
      {this.hint,
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
  final TextEditingController? textEditingController;
  final TextInputAction? keyAction;
  final ValueChanged<String>? validate;
  final ValueChanged<String>? onSubmited;
  final ValueChanged<String>? onChanged;
  final String? validatorText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                label!,
                style: TextStyle(color: Colors.black, fontSize: 12),
              )),
          GestureDetector(
            onTap: () {
              if (AllowClickable!) onClick!();
            },
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: TextFormField(
                  onChanged: this.onChanged,
                  maxLength: this.maxLength,
                  controller: textEditingController,
                  enabled: enabled,
                  keyboardType: this.keyType,
                  textInputAction: this.keyAction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return validatorText;
                    }
                    return null;
                  },
                  initialValue: this.initialValue,
                  decoration: InputDecoration(
                    isDense: true,
                    prefixText: this.pretext,
                    suffixText: this.sufText,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().backgroundColor, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().backgroundColor, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().backgroundColor, width: 2),
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
      {this.hint,
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
  final TextEditingController? textEditingController;
  final TextInputAction? keyAction;
  final ValueChanged<String>? validate;
  final ValueChanged<String>? onSubmited;
  final ValueChanged<String>? onChanged;
  final String? validatorText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 9),
              child: Row(
                children: [
                  Text(
                    label!,
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                  SizedBox(width: 4),
                  Text(
                    '(Optional)',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              )),
          GestureDetector(
            onTap: () {
              if (AllowClickable!) onClick!();
            },
            child: Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 10),
              child: TextFormField(
                  onChanged: this.onChanged,
                  maxLength: this.maxLength,
                  controller: textEditingController,
                  enabled: enabled,
                  keyboardType: this.keyType,
                  textInputAction: this.keyAction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return validatorText;
                    }
                    return null;
                  },
                  initialValue: this.initialValue,
                  decoration: InputDecoration(
                    isDense: true,
                    prefixText: this.pretext,
                    suffixText: this.sufText,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().backgroundColor, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().backgroundColor, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().backgroundColor, width: 2),
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
      {this.hint,
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
  final TextEditingController? contactName, contactPhone, contactMail;
  final TextInputAction? keyAction;
  final ValueChanged<String>? validate;
  final ValueChanged<String>? onSubmited;
  final ValueChanged<String>? onChanged;
  final String? validatorText;

  @override
  _CustomTextFieldWithImageState createState() =>
      _CustomTextFieldWithImageState();
}

class _CustomTextFieldWithImageState extends State<CustomTextFieldWithImage> {
  String countryFlag = "NG";
  String countryCode = "234";
  // final ContactPicker _contactPicker = new ContactPicker();
  // Contact? _contact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 9),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.label!,
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  (widget.validatorText != null &&
                          widget.validatorText!.isNotEmpty)
                      ? Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Text(
                                  "*",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12),
                                )),
                            SizedBox(width: 8),
                            Container(
                                child: Text(
                              "OR",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            )),
                            SizedBox(width: 8),
                            SvgPicture.asset(
                                'assets/images/select_from_contact.svg'),
                            SizedBox(width: 8),
                            InkWell(
                              onTap: () async {
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
                                  margin: EdgeInsets.only(top: 5),
                                  child: Text(
                                    "Select from Contact",
                                    style: TextStyle(
                                        color: AppColor().backgroundColor,
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
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: TextFormField(
                      onChanged: this.widget.onChanged,
                      maxLength: this.widget.maxLength,
                      controller: widget.contactName,
                      enabled: widget.enabled,
                      keyboardType: this.widget.keyType,
                      textInputAction: this.widget.keyAction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return widget.validatorText;
                        }
                        return null;
                      },
                      initialValue: this.widget.initialValue,
                      decoration: InputDecoration(
                        isDense: true,
                        prefixText: this.widget.pretext,
                        suffixText: this.widget.sufText,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor().backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor().backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor().backgroundColor, width: 2),
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
                  margin: EdgeInsets.only(left: 20, right: 20),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: AppColor().backgroundColor, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
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
                          decoration: BoxDecoration(
                            border: Border(
                                right: BorderSide(
                                    color: AppColor().backgroundColor,
                                    width: 2)),
                          ),
                          height: 50,
                          width: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 10),
                              Flag.fromString(countryFlag,
                                  height: 30, width: 30),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                size: 24,
                                color:
                                    AppColor().backgroundColor.withOpacity(0.5),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: widget.contactPhone,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "9034678966",
                              hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 14,
                                  fontFamily: 'DMSans',
                                  fontWeight: FontWeight.w500),
                              prefixText: "+$countryCode ",
                              prefixStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'DMSans',
                                  color: Colors.black)),
                        ),
                      ),
                      SizedBox(
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
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      (widget.validatorText != null &&
                              widget.validatorText!.isNotEmpty)
                          ? Row(
                              children: [
                                Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Text(
                                      "*",
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 12),
                                    )),
                                SizedBox(width: 8),
                              ],
                            )
                          : Container()
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: TextFormField(
                      onChanged: this.widget.onChanged,
                      maxLength: this.widget.maxLength,
                      controller: widget.contactMail,
                      enabled: widget.enabled,
                      keyboardType: this.widget.keyType,
                      textInputAction: this.widget.keyAction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return widget.validatorText;
                        }
                        return null;
                      },
                      initialValue: this.widget.initialValue,
                      decoration: InputDecoration(
                        isDense: true,
                        prefixText: this.widget.pretext,
                        suffixText: this.widget.sufText,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor().backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor().backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor().backgroundColor, width: 2),
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
      {this.hint,
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
  final TextEditingController? contactName, contactPhone, contactMail;
  final TextInputAction? keyAction;
  final ValueChanged<String>? validate;
  final ValueChanged<String>? onSubmited;
  final ValueChanged<String>? onChanged;
  final String? validatorText;

  @override
  _CustomTextFieldWithImageTransactionState createState() =>
      _CustomTextFieldWithImageTransactionState();
}

class _CustomTextFieldWithImageTransactionState
    extends State<CustomTextFieldWithImageTransaction> {
  String countryFlag = "NG";
  String countryCode = "234";
  // final ContactPicker _contactPicker = new ContactPicker();
  // Contact? _contact;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
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
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
              SizedBox(
                width: 5,
              ),
              (widget.validatorText != null && widget.validatorText!.isNotEmpty)
                  ? Row(
                      children: [
                        Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Text(
                              "*",
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            )),
                        SizedBox(width: 8),
                        Container(
                            child: Text(
                          "OR",
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        )),
                        SizedBox(width: 8),
                        SvgPicture.asset(
                            'assets/images/select_from_contact.svg'),
                        SizedBox(width: 8),
                        InkWell(
                          onTap: () async {
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
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                "Select from Contact",
                                style: TextStyle(
                                    color: AppColor().backgroundColor,
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
                  margin: EdgeInsets.only(top: 10),
                  child: TextFormField(
                      onChanged: this.widget.onChanged,
                      maxLength: this.widget.maxLength,
                      controller: widget.contactName,
                      enabled: widget.enabled,
                      keyboardType: this.widget.keyType,
                      textInputAction: this.widget.keyAction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return widget.validatorText;
                        }
                        return null;
                      },
                      initialValue: this.widget.initialValue,
                      decoration: InputDecoration(
                        isDense: true,
                        prefixText: this.widget.pretext,
                        suffixText: this.widget.sufText,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor().backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor().backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor().backgroundColor, width: 2),
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
                        color: AppColor().backgroundColor, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
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
                          decoration: BoxDecoration(
                            border: Border(
                                right: BorderSide(
                                    color: AppColor().backgroundColor,
                                    width: 2)),
                          ),
                          height: 50,
                          width: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 10),
                              Flag.fromString(countryFlag,
                                  height: 30, width: 30),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                size: 24,
                                color:
                                    AppColor().backgroundColor.withOpacity(0.5),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: widget.contactPhone,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "9034678966",
                              hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 14,
                                  fontFamily: 'DMSans',
                                  fontWeight: FontWeight.w500),
                              prefixText: "+$countryCode ",
                              prefixStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'DMSans',
                                  color: Colors.black)),
                        ),
                      ),
                      SizedBox(
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
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    (widget.validatorText != null &&
                            widget.validatorText!.isNotEmpty)
                        ? Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: Text(
                                    "*",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 12),
                                  )),
                              SizedBox(width: 8),
                            ],
                          )
                        : Container()
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: TextFormField(
                      onChanged: this.widget.onChanged,
                      maxLength: this.widget.maxLength,
                      controller: widget.contactMail,
                      enabled: widget.enabled,
                      keyboardType: this.widget.keyType,
                      textInputAction: this.widget.keyAction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return widget.validatorText;
                        }
                        return null;
                      },
                      initialValue: this.widget.initialValue,
                      decoration: InputDecoration(
                        isDense: true,
                        prefixText: this.widget.pretext,
                        suffixText: this.widget.sufText,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor().backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor().backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor().backgroundColor, width: 2),
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
      {this.hint,
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
      this.AllowClickable = false,
      this.validatorText,
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
      contactAddress;
  final TextInputAction? keyAction;
  final ValueChanged<String>? validate;
  final ValueChanged<String>? onSubmited;
  final ValueChanged<String>? onChanged;
  final String? validatorText;

  @override
  _CustomTextFieldInvoiceState createState() => _CustomTextFieldInvoiceState();
}

class _CustomTextFieldInvoiceState extends State<CustomTextFieldInvoice> {
  String countryFlag = "NG";
  String countryCode = "234";
  // final ContactPicker _contactPicker = new ContactPicker();
  // Contact? _contact;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
              SizedBox(
                width: 5,
              ),
              (widget.validatorText != null && widget.validatorText!.isNotEmpty)
                  ? Row(
                      children: [
                        SizedBox(width: 8),
                        Container(
                            child: Text(
                          "OR",
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        )),
                        SizedBox(width: 8),
                        SvgPicture.asset(
                            'assets/images/select_from_contact.svg'),
                        SizedBox(width: 8),
                        InkWell(
                          onTap: () async {
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
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                "Select from Contact",
                                style: TextStyle(
                                    color: AppColor().backgroundColor,
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
                  margin: EdgeInsets.only(top: 10),
                  child: TextFormField(
                      onChanged: this.widget.onChanged,
                      maxLength: this.widget.maxLength,
                      controller: widget.contactName,
                      enabled: widget.enabled,
                      keyboardType: this.widget.keyType,
                      textInputAction: this.widget.keyAction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return widget.validatorText;
                        }
                        return null;
                      },
                      initialValue: this.widget.initialValue,
                      decoration: InputDecoration(
                        isDense: true,
                        prefixText: this.widget.pretext,
                        suffixText: this.widget.sufText,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor().backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor().backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor().backgroundColor, width: 2),
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
                        color: AppColor().backgroundColor, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
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
                          decoration: BoxDecoration(
                            border: Border(
                                right: BorderSide(
                                    color: AppColor().backgroundColor,
                                    width: 2)),
                          ),
                          height: 50,
                          width: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 10),
                              Flag.fromString(countryFlag,
                                  height: 30, width: 30),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                size: 24,
                                color:
                                    AppColor().backgroundColor.withOpacity(0.5),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: widget.contactPhone,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "9034678966",
                              hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 14,
                                  fontFamily: 'DMSans',
                                  fontWeight: FontWeight.w500),
                              prefixText: "+$countryCode ",
                              prefixStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'DMSans',
                                  color: Colors.black)),
                        ),
                      ),
                      SizedBox(
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
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: TextFormField(
                      onChanged: this.widget.onChanged,
                      maxLength: this.widget.maxLength,
                      controller: widget.contactMail,
                      enabled: widget.enabled,
                      keyboardType: this.widget.keyType,
                      textInputAction: this.widget.keyAction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return widget.validatorText;
                        }
                        return null;
                      },
                      initialValue: this.widget.initialValue,
                      decoration: InputDecoration(
                        isDense: true,
                        prefixText: this.widget.pretext,
                        suffixText: this.widget.sufText,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor().backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor().backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor().backgroundColor, width: 2),
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
                Row(
                  children: [
                    Text(
                      'Address',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "(Optional)",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: TextFormField(
                      onChanged: this.widget.onChanged,
                      maxLength: this.widget.maxLength,
                      controller: widget.contactAddress,
                      enabled: widget.enabled,
                      keyboardType: this.widget.keyType,
                      textInputAction: this.widget.keyAction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return widget.validatorText;
                        }
                        return null;
                      },
                      initialValue: this.widget.initialValue,
                      decoration: InputDecoration(
                        isDense: true,
                        prefixText: this.widget.pretext,
                        suffixText: this.widget.sufText,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor().backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor().backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor().backgroundColor, width: 2),
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
