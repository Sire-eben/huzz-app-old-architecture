import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/mixins/form_mixin.dart';
import 'package:huzz/core/util/extension.dart';
import 'package:huzz/core/util/validators.dart';
import 'package:huzz/core/widgets/app_bar.dart';
import 'package:huzz/core/widgets/button/button.dart';
import 'package:huzz/core/widgets/dropdowns/build_menu_item.dart';
import 'package:huzz/core/widgets/dropdowns/dropdown_outline.dart';
import 'package:huzz/core/widgets/state/success.dart';
import 'package:huzz/core/widgets/textfield/textfield.dart';
import 'package:huzz/generated/assets.gen.dart';

class CreateBankAccountScreen extends StatefulWidget {
  const CreateBankAccountScreen({super.key});

  @override
  State<CreateBankAccountScreen> createState() =>
      _CreateBankAccountScreenState();
}

class _CreateBankAccountScreenState extends State<CreateBankAccountScreen>
    with FormMixin {
  final modeOfVerification = [
    "NIN",
    "Int'l Passport",
    "Voter's Card",
    "Driver's License",
  ];

  String? selectedModeOfVerification;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        title: 'Create bank account',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Insets.lg),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextInputField(
                  labelText: 'Name',
                  inputType: TextInputType.name,
                  validator: Validators.validateString(),
                ),
                TextInputField(
                  labelText: 'Enter BVN',
                  inputType: TextInputType.number,
                  validator: (input) => Validators.validateBVN(input),
                ),
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
                  dropdownColor: AppColors.lightBackgroundColor,
                  elevation: 0,
                  decoration: const InputDecoration(
                    errorBorder: dropdownErrorBorder,
                    focusedBorder: dropdownNormalBorder,
                    border: dropdownNormalBorder,
                    disabledBorder: dropdownNormalBorder,
                    enabledBorder: dropdownNormalBorder,
                  ),

                  value: selectedModeOfVerification,
                  // isExpanded: true,
                  items: modeOfVerification.map(buildMenuItem).toList(),

                  onChanged: (optionSelected) {
                    setState(() {
                      selectedModeOfVerification = optionSelected;
                    });
                  },
                ),
                const Gap(Insets.md),
                TextInputField(
                  labelText: 'Enter ID Number',
                  inputType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field cannot be empty';
                    } else if (value.length < 8) {
                      return 'Digits cannot be less than 8';
                    }
                    return null;
                  },
                ),
                const Gap(Insets.xl * 2),
                Button(
                  label: 'Create Bank Account',
                  action: () {
                    if (formKey.currentState!.validate()) {
                      context.replace(SuccessPage(
                        title:
                            'Congratulations your\nBank Account has been\ncreated successfully',
                        iconUrl: Assets.icons.imported.bank.path,
                        onBtnPressed: (p0) => context.pop(),
                      ));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
