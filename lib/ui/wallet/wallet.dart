import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/util/util.dart';
import 'package:huzz/core/constants/app_themes.dart';

class WalletInInformationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.info_outline_rounded,
          size: 27,
        ),
        SizedBox(height: 7),
        Text(
          'This is where you can have access to your wallet.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class Wallet extends StatefulWidget {
  const Wallet({Key? key}) : super(key: key);

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  bool viewBal = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
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
              'My Wallet',
              style: GoogleFonts.inter(
                color: AppColors.backgroundColor,
                fontStyle: FontStyle.normal,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 4),
            GestureDetector(
              onTap: () {
                Platform.isIOS
                    ? showCupertinoDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => CupertinoAlertDialog(
                          content: WalletInInformationDialog(),
                          actions: [
                            CupertinoButton(
                              child: Text("OK"),
                              onPressed: () => Get.back(),
                            ),
                          ],
                        ),
                      )
                    : showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: WalletInInformationDialog(),
                          actions: [
                            CupertinoButton(
                              child: Text("OK"),
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
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
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
                          value: viewBal,
                          onChanged: (newValue) =>
                              setState(() => viewBal = newValue))
                    ],
                  ),
                  Center(
                    child: Text(
                      '${Utils.getCurrency()}0.0',
                      style: GoogleFonts.inter(
                        color: AppColors.whiteColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WalletOption(
                        onTap: () {},
                        image: 'assets/images/transfer.png',
                        name: 'Transfer',
                      ),
                      SizedBox(width: 20),
                      WalletOption(
                        onTap: () {},
                        image: 'assets/images/payment.svg',
                        name: 'Request Payment',
                      )
                    ],
                  ),
                ],
              ),
              height: 140,
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage("assets/images/home_rectangle.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.015),
          ],
        ),
      ),
    );
  }
}

class WalletOption extends StatelessWidget {
  final String? image, name;
  final VoidCallback? onTap;
  const WalletOption({
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
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Color(0xff056B5C),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
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
            SizedBox(width: 6),
            Text(
              name!,
              style: GoogleFonts.inter(
                color: AppColors.whiteColor,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 6),
          ],
        ),
      ),
    );
  }
}
