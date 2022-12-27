import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/mixins/form_mixin.dart';
import 'package:huzz/core/util/extension.dart';
import 'package:huzz/core/util/validators.dart';
import 'package:huzz/core/widgets/appbar.dart';
import 'package:huzz/core/widgets/button/button.dart';
import 'package:huzz/core/widgets/dropdowns/buildmenuitem.dart';
import 'package:huzz/core/widgets/dropdowns/dropdown_outline.dart';
import 'package:huzz/core/widgets/state/success.dart';
import 'package:huzz/core/widgets/textfield/textfield.dart';
import 'package:huzz/data/repository/auth_respository.dart';
import 'package:huzz/generated/assets.gen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> with FormMixin {
  final listOfBanks = [
    "First bank",
    "GTBank",
    "UBA Bank",
    "Moniepoint mfb",
  ];

  String? selectedBank;

  // StreamController<ErrorAnimationType>? errorController;

  final _authController = Get.find<AuthRepository>();

  @override
  void initState() {
    // errorController = StreamController<ErrorAnimationType>();
    _authController.pinController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: Appbar(
        title: 'Transfer',
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: EdgeInsets.only(
            left: Insets.lg,
            right: Insets.lg,
            top: Insets.lg,
            bottom: bottom,
          ),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'ID Verification',
                      style: TextStyles.b2,
                    )),
                const Gap(Insets.md),
                DropdownButtonFormField<String>(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Select One Option';
                    }
                    return null;
                  },

                  hint: const Text('Select'),
                  disabledHint: const Text('Choose category'),
                  dropdownColor: AppColors.lightbackgroundColor,
                  elevation: 0,
                  decoration: const InputDecoration(
                    errorBorder: dropdownErrorBorder,
                    focusedBorder: dropdownNormalBorder,
                    border: dropdownNormalBorder,
                    disabledBorder: dropdownNormalBorder,
                    enabledBorder: dropdownNormalBorder,
                  ),

                  value: selectedBank,
                  // isExpanded: true,
                  items: listOfBanks.map(buildMenuItem).toList(),

                  onChanged: (optionSelected) {
                    setState(() {
                      selectedBank = optionSelected;
                    });
                  },
                ),
                const Gap(Insets.md),
                TextInputField(
                  labelText: 'Account Number',
                  inputType: TextInputType.number,
                  validator: (input) => Validators.validateAccountNumber(input),
                ),
                TextInputField(
                  labelText: 'Amount',
                  inputType: TextInputType.number,
                  validator: Validators.validateAmount(1000),
                ),
                TextInputField(
                  labelText: 'Narration',
                  inputType: TextInputType.text,
                  validator: Validators.validateString(minLength: 5),
                ),
                const Gap(Insets.xl * 3),
                Button(
                  label: 'Continue',
                  action: () {
                    enterPinBottomSheet(context, bottom);
                    // TODO: Implement form validation first later
                    // if (formKey.currentState!.validate()) {
                    //   enterPinBottomSheet(context, bottom);
                    // }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> enterPinBottomSheet(
    BuildContext context,
    double bottom,
  ) {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22),
          ),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (context) {
          return Container(
            height: 325,
            width: context.getWidth(),
            padding: EdgeInsets.only(
              left: Insets.lg,
              right: Insets.lg,
              top: Insets.lg,
              bottom: bottom,
            ),
            child: Column(children: [
              Container(
                height: 4,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.shade500,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const Gap(Insets.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Enter your Huzz pin',
                    style: TextStyles.t1.copyWith(),
                  ),
                  InkWell(
                    onTap: () => context.pop(),
                    child: Container(
                      padding: const EdgeInsets.all(Insets.sm),
                      decoration: const BoxDecoration(
                        color: AppColors.lightbackgroundColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(Insets.lg),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  margin: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: PinCodeTextField(
                    keyboardType: TextInputType.number,
                    length: 4,
                    obscureText: true,
                    animationType: AnimationType.fade,
                    // controller: _authController.pinController,
                    pinTheme: PinTheme(
                      inactiveColor: AppColors.backgroundColor,
                      activeColor: AppColors.backgroundColor,
                      selectedColor: AppColors.backgroundColor,
                      selectedFillColor: Colors.white,
                      inactiveFillColor: Colors.white,
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 70,
                      fieldWidth: 70,
                      activeFillColor: Colors.white,
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    // errorAnimationController: errorController,
                    onCompleted: (v) {},
                    onChanged: (value) {
                      // setState(() {
                      //   currentText = value;
                      // });
                    },
                    beforeTextPaste: (text) {
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    },
                    appContext: context,
                  ),
                ),
              ),
              const Spacer(),
              Button(
                label: 'Transfer',
                action: () {
                  context.replace(SuccessPage(
                    isMoneySent: true,
                    title: 'Money sent\nsuccessfully',
                    iconUrl: Assets.icons.imported.success.path,
                  ));
                },
              )
            ]),
          );
        });
  }
}
