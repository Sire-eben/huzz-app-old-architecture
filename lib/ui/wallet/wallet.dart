import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/util/extension.dart';
import 'package:huzz/core/util/util.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/widgets/image.dart';
import 'package:huzz/core/widgets/switch.dart';
import 'package:huzz/core/widgets/wallet/wallet_info_dialog.dart';
import 'package:huzz/generated/assets.gen.dart';
import 'package:huzz/ui/account/upgrade_account.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool showBal = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.backgroundColor,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Row(
          children: [
            Text(
              'My WalletScreen',
              style: GoogleFonts.inter(
                color: AppColors.backgroundColor,
                fontStyle: FontStyle.normal,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () {
                Platform.isIOS
                    ? showCupertinoDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => CupertinoAlertDialog(
                          content: const WalletInfoDialog(),
                          actions: [
                            CupertinoButton(
                              child: const Text("OK"),
                              onPressed: () => Get.back(),
                            ),
                          ],
                        ),
                      )
                    : showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: const WalletInfoDialog(),
                          actions: [
                            CupertinoButton(
                              child: const Text("OK"),
                              onPressed: () => Get.back(),
                            ),
                          ],
                        ),
                      );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0, top: 2.0),
                child: SvgPicture.asset(
                  "assets/images/info.svg",
                  height: 20,
                  width: 20,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(Insets.lg),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: Insets.lg,
                horizontal: Insets.md,
              ),
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage("assets/images/home_rectangle.png"),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "WEMA BANK",
                            style: GoogleFonts.inter(
                              color: AppColors.whiteColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "3066856680",
                            style: GoogleFonts.inter(
                              color: AppColors.whiteColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "JOSHUA OLATUNDE",
                        style: GoogleFonts.inter(
                          color: AppColors.whiteColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Switch.adaptive(
                          activeColor: AppColors.orangeBorderColor,
                          activeTrackColor: AppColors.orangeBorderColor,
                          inactiveThumbColor: AppColors.orangeColor,
                          inactiveTrackColor: AppColors.whiteColor,
                          value: showBal,
                          onChanged: (newValue) =>
                              setState(() => showBal = newValue))
                    ],
                  ),
                  Center(
                    child: Text(
                      showBal ? '${Utils.getCurrency()}0.0' : '******',
                      style: GoogleFonts.inter(
                        color: AppColors.whiteColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WalletScreenOption(
                        onTap: () {},
                        image: 'assets/images/transfer.png',
                        name: 'Transfer',
                      ),
                      const SizedBox(width: 20),
                      WalletScreenOption(
                        onTap: () {},
                        image: 'assets/images/payment.svg',
                        name: 'Request Payment',
                      )
                    ],
                  ),
                ],
              ),
            ),
            const Gap(Insets.lg),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: Insets.sm,
                      horizontal: Insets.md,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.secondbgColor.withOpacity(.1),
                    ),
                    child: Row(children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryColor,
                        ),
                        child: LocalSvgIcon(
                          Assets.icons.linear.star1,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                      const Gap(Insets.sm),
                      const Text(
                        'Tier One',
                        style: TextStyles.t3,
                      ),
                      const Spacer(),
                      const Text(
                        'Max. #20,000',
                        style: TextStyles.t2,
                      )
                    ]),
                  ),
                ),
                const Gap(Insets.md),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(Insets.sm),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.orangeBorderColor,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Upgrade',
                          style: TextStyles.t3.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        LocalSvgIcon(
                          Assets.icons.bulk.arrowCircleRight,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ).onTap(
                    (() => context.push(const UpgradeAccountScreen())),
                  ),
                ),
              ],
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LocalSvgIcon(
                  Assets.icons.twotone.timer1,
                  size: 80,
                ),
                const Gap(Insets.md),
                const Text(
                  'Transaction History',
                  style: TextStyles.h5,
                ),
                const Gap(Insets.sm),
                const Text(
                  'Your recent transactions will show here. Click the\nAdd transaction button to record your first transaction',
                  textAlign: TextAlign.center,
                  style: TextStyles.t3,
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}

class WalletScreenOption extends StatelessWidget {
  final String? image, name;
  final VoidCallback? onTap;
  const WalletScreenOption({
    Key? key,
    this.image,
    this.name,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xff056B5C),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: name == 'Request Payment'
                  ? SvgPicture.asset(
                      image!,
                      height: 16,
                      width: 16,
                    )
                  : Image.asset(
                      image!,
                      height: 16,
                      width: 16,
                    ),
            ),
            const SizedBox(width: 6),
            Text(
              name!,
              style: GoogleFonts.inter(
                color: AppColors.whiteColor,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
          ],
        ),
      ),
    );
  }
}
