import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/widgets/app_bar.dart';
import 'package:huzz/core/widgets/button/button.dart';
import 'package:huzz/core/widgets/image.dart';
import 'package:huzz/generated/assets.gen.dart';

enum UpgradeSteps { first, second }

enum FaceCapture { initial, loading, successful, unsuccessful }

class UpgradeStepsScreen extends StatefulWidget {
  UpgradeSteps upgradeSteps;
  FaceCapture faceCapture;

  UpgradeStepsScreen({
    super.key,
    this.upgradeSteps = UpgradeSteps.first,
    this.faceCapture = FaceCapture.initial,
  });

  @override
  State<UpgradeStepsScreen> createState() => _UpgradeStepsScreenState();
}

class _UpgradeStepsScreenState extends State<UpgradeStepsScreen> {
  bool successful = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        title: 'Upgrade',
      ),
      body: Padding(
          padding: const EdgeInsets.all(Insets.lg),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.upgradeSteps == UpgradeSteps.first
                      ? 'STEP ONE'
                      : 'STEP TWO',
                  style: TextStyles.t2.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),

                //Indicator
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 4,
                          width: 42,
                          margin: const EdgeInsets.only(
                            right: Insets.sm,
                          ),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Corners.smRadius),
                              color: widget.upgradeSteps == UpgradeSteps.first
                                  ? AppColors.primaryColor
                                  : Colors.grey.shade300),
                        ),
                        Container(
                          height: 4,
                          width: 42,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Corners.smRadius),
                              color: widget.upgradeSteps == UpgradeSteps.second
                                  ? AppColors.primaryColor
                                  : Colors.grey.shade300),
                        )
                      ]),
                ),
                const Gap(Insets.xl * 2),

                widget.faceCapture == FaceCapture.initial
                    ? const Text('Ensure you are in a well-lit environment')
                    : Text('Facial Capture\nSuccessful!',
                        textAlign: TextAlign.center,
                        style: TextStyles.h3.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w500,
                          // fontSize: 14,
                        )),
                const Gap(Insets.xl * 2),
                widget.faceCapture == FaceCapture.initial
                    ? Image.asset(Assets.icons.imported.faceScan.path)
                    : widget.faceCapture == FaceCapture.successful
                        ? LocalSvgIcon(
                            Assets.icons.bulk.copySuccess,
                            size: 100,
                          )
                        : LocalSvgIcon(
                            Assets.images.huzz,
                            size: 100,
                          ),
                const Spacer(),
                widget.faceCapture == FaceCapture.initial
                    ? Button(
                        label: 'Verify',
                        action: () {
                          setState(() {
                            widget.faceCapture = FaceCapture.successful;
                          });
                        },
                      )
                    : widget.faceCapture == FaceCapture.successful
                        ? Button(
                            label: 'Proceed',
                            action: () {
                              setState(() {
                                widget.upgradeSteps = UpgradeSteps.second;
                              });
                            },
                          )
                        : Button(
                            label: 'Proceed',
                            action: () {},
                          ),
                const Gap(Insets.xl),
              ],
            ),
          )),
    );
  }
}
