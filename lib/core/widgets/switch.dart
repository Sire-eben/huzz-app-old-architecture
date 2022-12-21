import 'package:flutter/material.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/util/extension.dart';
import 'package:huzz/core/widgets/image.dart';
import 'package:huzz/generated/assets.gen.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const CustomSwitch({required this.value, required this.onChanged, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return value
        ? LocalSvgIcon(
            Assets.icons.bulk.toggleOn,
            color: AppColors.whiteColor,
            size: 25,
          ).onTap(
            () => onChanged(!value),
          )
        : LocalSvgIcon(
            Assets.icons.bulk.toggleOff,
            color: AppColors.whiteColor,
            size: 25,
          ).onTap(
            () => onChanged(!value),
          );
  }
}
