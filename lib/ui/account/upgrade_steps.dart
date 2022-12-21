import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/widgets/appbar.dart';
import 'package:huzz/core/widgets/button/button.dart';
import 'package:huzz/generated/assets.gen.dart';
import 'package:huzz/ui/account/helpers/step_one.dart';

enum UpgradeSteps { first, second }

class UpgradeStepsScreen extends StatefulWidget {
  final UpgradeSteps upgradeSteps;

  const UpgradeStepsScreen({
    super.key,
    this.upgradeSteps = UpgradeSteps.first,
  });

  @override
  State<UpgradeStepsScreen> createState() => _UpgradeStepsScreenState();
}

class _UpgradeStepsScreenState extends State<UpgradeStepsScreen> {
  bool successful = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(),
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
                const Text('Ensure you are in a well-lit environment'),
                const Gap(Insets.xl * 2),
                Image.asset(Assets.icons.imported.faceScan.path),
                const Spacer(),
                Button(
                  label: 'Verify',
                  action: () {},
                ),
                const Gap(Insets.xl),
              ],
            ),
          )),
    );
  }
}
