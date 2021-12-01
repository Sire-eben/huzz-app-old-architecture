import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
    // TODO: implement build
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
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
                          // color: AppColors.accentcolor,
                          // fontFamily: FontFamily.sofiaPro,
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

class CustomTextFieldWithImage extends StatelessWidget {
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
    // TODO: implement build
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
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
                                margin: EdgeInsets.only(top: 5),
                                child: Text(
                                  "OR",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12),
                                )),
                            SizedBox(width: 8),
                            SvgPicture.asset(
                                'assets/images/select_from_contact.svg'),
                            SizedBox(width: 8),
                            Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Text(
                                  "Select from Contact",
                                  style: TextStyle(
                                      color: AppColor().backgroundColor,
                                      fontSize: 12),
                                )),
                          ],
                        )
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
                          // color: AppColors.accentcolor,
                          // fontFamily: FontFamily.sofiaPro,
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
