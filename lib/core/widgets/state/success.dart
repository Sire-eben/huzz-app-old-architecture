import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/widgets/appbar.dart';
import 'package:huzz/core/widgets/button/button.dart';
import 'package:huzz/core/widgets/image.dart';
import 'package:huzz/generated/assets.gen.dart';

class SuccessPage extends StatelessWidget {
  final String title, subtitle, btnLabel;
  final String? iconUrl;
  final Function(BuildContext)? onBtnPressed;
  const SuccessPage(
      {this.title = "",
      this.subtitle = "",
      this.btnLabel = "Continue",
      this.iconUrl,
      this.onBtnPressed,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final iconUrl = this.iconUrl ?? Assets.icons.bulk.medal;
    return Scaffold(
      appBar: Appbar(
        showLeading: false,
        appbarType: AppbarType.dark,
      ),
      backgroundColor: AppColors.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(Insets.lg),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(Insets.lg),
                    decoration: const BoxDecoration(
                      color: Colors.white10,
                      shape: BoxShape.circle,
                    ),
                    child: LocalSvgIcon(
                      iconUrl,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const Gap(Insets.md),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(Insets.sm),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Button(
              backgroundColor: Colors.white,
              color: Colors.black,
              label: btnLabel,
              action: () => onBtnPressed?.call(context),
            ),
            const Gap(Insets.lg),
          ],
        ),
      ),
    );
  }
}
