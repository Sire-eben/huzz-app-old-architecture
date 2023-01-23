import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/util/extension.dart';
import 'package:huzz/core/widgets/app_bar.dart';
import 'package:huzz/core/widgets/button/button.dart';
import 'package:huzz/generated/assets.gen.dart';
import 'package:huzz/ui/account/face_capture.dart';

class UpgradeAccountScreen extends StatefulWidget {
  const UpgradeAccountScreen({super.key});

  @override
  State<UpgradeAccountScreen> createState() => _UpgradeAccountScreenState();
}

class _UpgradeAccountScreenState extends State<UpgradeAccountScreen> {
  @override
  Widget build(BuildContext context) {
    String upgradeText =
        'Upgrading your account tier will enable you to process transactions up to N1,000,000 per day. We will need to capture your face and match it with the photo in the ID document you will provide. To start the verification process, please click the "Face capture" button';

    return Scaffold(
      appBar: Appbar(
        title: 'Upgrade',
      ),
      body: Padding(
        padding: const EdgeInsets.all(Insets.lg),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              upgradeText,
              textAlign: TextAlign.center,
              style: TextStyles.t3.copyWith(
                height: 1.5,
                color: Colors.black54,
              ),
            ),
            const Gap(Insets.xl),
            Image.asset(
              Assets.icons.imported.faceScan.path,
              height: 80,
            ),
            const Gap(Insets.xl),
            Button(
              label: 'Face Capture',
              action: () => context.push(FaceCaptureCreen()),
            ),
            const Gap(Insets.md),
            const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'ID Verification',
                  style: TextStyles.t3,
                )),
            const Gap(Insets.md),
            DropdownButtonFormField(
                elevation: 3,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.lightBackgroundColor,
                    width: 1,
                  ),
                )),
                items: const <DropdownMenuItem>[],
                onChanged: (value) {}),
            const Spacer(),
            Button(
                backgroundColor: AppColors.lightBackgroundColor,
                label: 'Upgrade',
                action: () {}),
            const Gap(Insets.xl),
          ],
        ),
      ),
    );
  }
}
