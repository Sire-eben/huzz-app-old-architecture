import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/widgets/app_bar.dart';
import 'package:huzz/core/widgets/button/button.dart';
import 'package:huzz/core/widgets/button/outlined_button.dart';
import 'package:huzz/generated/assets.gen.dart';

class SuccessPage extends StatelessWidget {
  final String title, subtitle, btnLabel;
  final String? iconUrl;
  final Function(BuildContext)? onBtnPressed;
  final bool isMoneySent;

  const SuccessPage(
      {this.title = "",
      this.subtitle = "",
      this.btnLabel = "Continue",
      this.iconUrl,
      this.onBtnPressed,
      this.isMoneySent = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final iconUrl = this.iconUrl ?? Assets.icons.imported.success;
    return Scaffold(
      appBar: Appbar(
        showLeading: false,
      ),
      backgroundColor: AppColors.whiteColor,
      body: Padding(
        padding: const EdgeInsets.all(Insets.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(Insets.md),
            Image.asset(
              iconUrl ?? Assets.icons.imported.success.path,
            ),
            Button(
              label: 'Proceed',
              action: () => onBtnPressed?.call(context),
            ),
            const Gap(Insets.sm),
            if (isMoneySent) ...[
              OutlineButton(
                label: 'View Receipt',
                action: () {},
              )
            ]
          ],
        ),
      ),
    );
  }
}
