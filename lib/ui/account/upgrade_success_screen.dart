import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/util/extension.dart';
import 'package:huzz/core/widgets/appbar.dart';
import 'package:huzz/core/widgets/button/button.dart';
import 'package:huzz/core/widgets/image.dart';
import 'package:huzz/generated/assets.gen.dart';
import 'package:huzz/ui/app_scaffold.dart';
import 'package:huzz/ui/home/home_page.dart';

class AccountUpgradedSuccessFully extends StatelessWidget {
  const AccountUpgradedSuccessFully({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            const Text(
              'Account Upgraded\nSuccessfully!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(Insets.md),
            Image.asset(
              Assets.icons.imported.upgradeSuccessful.path,
            ),
            Button(
              label: 'Proceed',
              action: () => context.pushOff(Dashboard()),
            ),
            const Gap(Insets.sm),
          ],
        ),
      ),
    );
  }
}
