import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/util/extension.dart';
import 'package:huzz/core/widgets/appbar.dart';
import 'package:huzz/core/widgets/button/button.dart';
import 'package:huzz/core/widgets/state/success.dart';
import 'package:huzz/presentation/app_scaffold.dart';
import 'package:image_picker/image_picker.dart';
import 'package:huzz/core/widgets/dropdowns/buildmenuitem.dart';
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
    "National ID",
    "Int'l Passport",
    "Voter's Card",
    "Driver's License",
  ];
  String? selectedModeOfVerfication;
  bool userHasSelected = false;

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _getImage() async {
    try {
      imageXFile = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        imageXFile;
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        title: 'Upgrade',
      ),
      body: Padding(
        padding: const EdgeInsets.all(Insets.lg),
        child: SingleChildScrollView(
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
                Assets.icons.imported.scanDone.path,
                height: 80,
              ),
              const Gap(Insets.xl),
              Button(
                backgroundColor: AppColors.lightbackgroundColor,
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
                dropdownColor: AppColors.lightbackgroundColor,
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
                if (imageXFile == null)
                  UploadButton(
                    action: () {
                      uploadDocumentSheet(context);
                    },
                  )
                else
                  InkWell(
                    onTap: () {
                      uploadDocumentSheet(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(Insets.sm * 1.5),
                      decoration: BoxDecoration(
                        color: AppColors.lightbackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.image_outlined,
                          ),
                          Gap(Insets.sm),
                          Text('IMG_12398909273.jpg'),
                        ],
                      ),
                    ),
                  )
              ],
              const Gap(Insets.xl * 2),
              Button(
                  label: 'Upgrade',
                  action: () {
                    context.push(
                      SuccessPage(
                        title: 'Account Upgraded\nSuccessfully!',
                        iconUrl: Assets.icons.imported.upgradeSuccessful.path,
                        onBtnPressed: (p0) => context.pushOff(Dashboard()),
                      ),
                    );
                  }),
              const Gap(Insets.xl),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> uploadDocumentSheet(BuildContext context) {
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
            width: context.width,
            padding: const EdgeInsets.all(Insets.lg),
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
                    'Upload Document',
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
              // if(imageXFile == null)
              InkWell(
                onTap: () => _getImage(),
                child: imageXFile == null
                    ? LocalSvgIcon(
                        Assets.icons.bulk.image,
                        size: 100,
                      )
                    : Container(
                        height: 120,
                        width: context.width,
                        decoration: BoxDecoration(
                            // color: AppColors.lightbackgroundColor,
                            image: DecorationImage(
                                image: FileImage(
                          File(imageXFile!.path),
                        ))),
                      ),
              ),
              imageXFile == null
                  ? const Text('Select from device')
                  : Text(
                      'Change',
                      style:
                          TextStyles.t2.copyWith(color: AppColors.primaryColor),
                    ),
              const Spacer(),
              Button(
                label: 'Upload',
                action: () {
                  context.pop();
                },
              )
            ]),
          );
        });
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
            backgroundColor: AppColors.lightbackgroundColor,
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
