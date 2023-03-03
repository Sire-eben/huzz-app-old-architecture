// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/util/extension.dart';
import 'package:huzz/core/util/url.dart';
import 'package:huzz/ui/more/widget/help_tile.dart';
import 'package:huzz/ui/privacy_policy.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/constants/app_icons.dart';
import 'package:huzz/core/constants/app_strings.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/repository/auth_respository.dart';
import '../terms_of_condition.dart';
import 'faq_webview.dart';

class HelpsAndSupport extends StatefulWidget {
  const HelpsAndSupport({Key? key}) : super(key: key);

  @override
  _HelpsAndSupportState createState() => _HelpsAndSupportState();
}

class _HelpsAndSupportState extends State<HelpsAndSupport> {
  final _authController = Get.put(AuthRepository());
  String emailSubject = '';
  String emailMessage = '';

  @override
  void initState() {
    super.initState();
    _authController.checkTeamInvite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
              AppStrings.helpAndSupport,
              style: GoogleFonts.inter(
                color: AppColors.backgroundColor,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 20,
            left: 10,
            right: 10,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //PRIVACY
                  HelpTile(
                    action: () => Get.to(const Privacy()),
                    icon: AppIcons.privacyPolicy,
                    title: AppStrings.privacyPolicy,
                  ),
                  HelpTile(
                    action: () => Get.to(TermsOfUse()),
                    icon: AppIcons.privacyPolicy,
                    title: AppStrings.termsOfUse,
                  ),
                  HelpTile(
                    action: () => Get.to(const FaqWeb()),
                    icon: AppIcons.faq,
                    isSVG: true,
                    title: AppStrings.faq,
                  ),
                  HelpTile(
                    action: () async {
                      if (_authController.onlineStatus == OnlineStatus.Onilne) {
                        const toEmail = 'info@huzz.africa';
                        final subject = emailSubject;
                        final messageBody = emailMessage;
                        final url =
                            'mailto:$toEmail?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(messageBody)}';
                        if (await canLaunch(url)) {
                          launch(url);
                        }
                      }
                    },
                    icon: AppIcons.mail,
                    isSVG: true,
                    title: AppStrings.mail,
                  ),
                  HelpTile(
                    action: () => _displayDialog(
                        context: context,
                        title: 'Open WhatsApp..?',
                        onContinuePressed: () =>
                            launchWhatsAppUrl(AppStrings.supportPhone)),
                    icon: AppIcons.whatsapp,
                    isSVG: true,
                    title: AppStrings.connectOnWhatsApp,
                  ),
                  HelpTile(
                    action: () => _displayDialog(
                      context: context,
                      title: 'Open Telegram..?',
                      onContinuePressed: () =>
                          launch(AppStrings.huzzTelegramContactURI),
                    ),
                    icon: AppIcons.telegram,
                    title: AppStrings.connectOnTelegram,
                  ),

                  HelpTile(
                    action: () => _displayDialog(
                      context: context,
                      title: 'Open User Manual..?',
                      onContinuePressed: () {
                        launch(AppStrings.huzzUserManualURI);
                      },
                    ),
                    icon: AppIcons.privacyPolicy,
                    title: AppStrings.userManual,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _displayDialog({
    required BuildContext context,
    required String title,
    // required String url,
    required VoidCallback onContinuePressed,
  }) async {
    return showDialog(
        context: context,
        builder: (context) {
          return Platform.isAndroid
              ? AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  insetPadding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    // vertical: 280,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Gap(Insets.lg),
                      Expanded(
                        child: Text(
                          title,
                          style: GoogleFonts.inter(
                            color: AppColors.backgroundColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  content: Text(
                    AppStrings.continueToProceed,
                    style: GoogleFonts.inter(
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              height: 45,
                              width: 100,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  border: Border.all(
                                    width: 2,
                                    color: AppColors.backgroundColor,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Text(
                                  'Cancel',
                                  style: GoogleFonts.inter(
                                    color: AppColors.backgroundColor,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: onContinuePressed,
                            child: Container(
                              height: 45,
                              width: 100,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                  color: AppColors.backgroundColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Text(
                                  'Continue',
                                  style: GoogleFonts.inter(
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : CupertinoAlertDialog(
                  title: Text(
                    title,
                    style: GoogleFonts.inter(
                      color: AppColors.backgroundColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  content: Text(
                    AppStrings.continueToProceed,
                  ),
                  actions: [
                    CupertinoDialogAction(
                      onPressed: () => context.pop(),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.inter(
                          color: AppColors.backgroundColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    CupertinoDialogAction(
                      onPressed: onContinuePressed,
                      child: Text(
                        'Continue',
                        style: GoogleFonts.inter(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                );
        });
  }
}
