import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/util/extension.dart';
import 'package:huzz/core/widgets/app_bar.dart';
import 'package:huzz/core/widgets/button/button.dart';
import 'package:huzz/core/widgets/dropdowns/build_menu_item.dart';
import 'package:huzz/core/widgets/dropdowns/dropdown_outline.dart';
import 'package:huzz/core/widgets/image.dart';
import 'package:huzz/generated/assets.gen.dart';

class IdVerificationScreen extends StatefulWidget {
  const IdVerificationScreen({super.key});

  @override
  State<IdVerificationScreen> createState() => _IdVerificationScreenState();
}

class _IdVerificationScreenState extends State<IdVerificationScreen> {
  final modeOfVerification = [
    "General",
    "Beauty",
    "Digital",
    "Lifestyle",
    "Technical",
    "Clothing",
  ];
  String? selectedModeOfVerfication;
  bool userHasSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(),
      body: Padding(
        padding: const EdgeInsets.all(Insets.lg),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'STEP TWO',
              style: TextStyles.t2.copyWith(
                color: AppColors.primaryColor,
              ),
            ),
            //Indicator
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  height: 4,
                  width: 42,
                  margin: const EdgeInsets.only(
                    right: Insets.sm,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Corners.smRadius),
                      color: Colors.grey.shade300),
                ),
                Container(
                  height: 4,
                  width: 42,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Corners.smRadius),
                      color: AppColors.primaryColor),
                )
              ]),
            ),
            const Gap(Insets.xl * 2),
            Image.asset(
              Assets.icons.imported.faceScan.path,
              height: 80,
            ),
            const Gap(Insets.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Face capture Done!'),
                Gap(Insets.sm),
                Icon(Icons.check_circle),
              ],
            ),
            const Gap(Insets.xl),
            Button(
              backgroundColor: AppColors.lightBackgroundColor,
              label: 'Face Capture',
              action: () {},
            ),
            const Gap(Insets.md),
            const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'ID Verification',
                  style: TextStyles.t3,
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

              value: selectedModeOfVerfication,
              // isExpanded: true,
              items: modeOfVerification.map(buildMenuItem).toList(),

              onChanged: (optionSelected) {
                setState(() {
                  selectedModeOfVerfication = optionSelected;
                });
                setState(() {
                  userHasSelected == true;
                });
              },
            ),
            if (selectedModeOfVerfication != '') ...[
              const Gap(Insets.md),
              UploadButton(
                action: () {
                  showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoActionSheet();
                      });
                },
              )
            ],
            const Spacer(),
            Button(label: 'Upgrade', action: () {}),
            const Gap(Insets.xl),
          ],
        ),
      ),
    );
  }
}

class UploadButton extends StatelessWidget {
  final VoidCallback action;

  const UploadButton({
    Key? key,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: context.width,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.lightBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            )),
        onPressed: action,
        icon: LocalSvgIcon(
          Assets.icons.linear.addCircle,
        ),
        label: Text(
          'Upload Document',
          style: TextStyles.t3.copyWith(
            color: AppColors.primaryColor,
          ),
        ),
      ),
    );
  }
}
