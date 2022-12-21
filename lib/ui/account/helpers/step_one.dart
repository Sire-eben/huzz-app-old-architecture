import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gap/gap.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/widgets/button/button.dart';
import 'package:huzz/generated/assets.gen.dart';

class StepOne extends StatefulWidget {
  const StepOne({super.key});

  @override
  State<StepOne> createState() => _StepOneState();
}

class _StepOneState extends State<StepOne> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Ensure you are in a well-lit environment'),
        const Gap(Insets.xl * 2),
        Image.asset(Assets.icons.imported.faceScan.path),
        // const Spacer(),
        Button(
          label: 'Verify',
          action: () {},
        ),
        const Gap(Insets.xl),
      ],
    );
  }
}
