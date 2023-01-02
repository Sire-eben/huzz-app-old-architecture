// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/presentation/privacy_policy.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/constants/app_icons.dart';
import 'package:huzz/core/constants/app_strings.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/repository/auth_respository.dart';
import '../terms_of_condition.dart';
import 'faq_web_view.dart';

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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Material(
                      child: InkWell(
                        highlightColor:
                            AppColors.backgroundColor.withOpacity(0.3),
                        splashColor: AppColors.secondbgColor.withOpacity(0.3),
                        onTap: () {
                          Get.to(const Privacy());
                        },
                        child: Ink(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          height: 55,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: const Color(0xffE6F4F2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  border: Border.all(
                                    width: 2,
                                    color: AppColors.whiteColor,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Image(
                                      image: AssetImage(AppIcons.privacyPolicy),
                                      width: 20,
                                      height: 20),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                AppStrings.privacyPolicy,
                                style: GoogleFonts.inter(
                                  color: AppColors.blackColor,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                ),
                              ),
                              const Spacer(),
                              SvgPicture.asset(
                                AppIcons.chevronRight,
                                height: 20,
                                width: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //TERMS OF USE
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Material(
                      child: InkWell(
                        highlightColor:
                            AppColors.backgroundColor.withOpacity(0.3),
                        splashColor: AppColors.secondbgColor.withOpacity(0.3),
                        onTap: () {
                          Get.to(TermsOfUse());
                        },
                        child: Ink(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          height: 55,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: const Color(0xffE6F4F2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  border: Border.all(
                                    width: 2,
                                    color: AppColors.whiteColor,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Image(
                                      image: AssetImage(AppIcons.privacyPolicy),
                                      width: 20,
                                      height: 20),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                AppStrings.termsOfUse,
                                style: GoogleFonts.inter(
                                  color: AppColors.blackColor,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                ),
                              ),
                              const Spacer(),
                              SvgPicture.asset(
                                AppIcons.chevronRight,
                                height: 20,
                                width: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // FAQ
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Material(
                      child: InkWell(
                        highlightColor:
                            AppColors.backgroundColor.withOpacity(0.3),
                        splashColor: AppColors.secondbgColor.withOpacity(0.3),
                        onTap: () {
                          Get.to(const FaqWebView());
                        },
                        child: Ink(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          height: 55,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: const Color(0xffE6F4F2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  border: Border.all(
                                    width: 2,
                                    color: AppColors.whiteColor,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    AppIcons.faq,
                                    height: 15,
                                    width: 15,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                AppStrings.faq,
                                style: GoogleFonts.inter(
                                  color: AppColors.blackColor,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                ),
                              ),
                              const Spacer(),
                              SvgPicture.asset(
                                AppIcons.chevronRight,
                                height: 20,
                                width: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Mail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Material(
                      child: InkWell(
                        highlightColor:
                            AppColors.backgroundColor.withOpacity(0.3),
                        splashColor: AppColors.secondbgColor.withOpacity(0.3),
                        onTap: () async {
                          if (_authController.onlineStatus ==
                              OnlineStatus.Onilne) {
                            const toEmail = 'info@huzz.africa';
                            final subject = emailSubject;
                            final messageBody = emailMessage;
                            final url =
                                'mailto:$toEmail?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(messageBody)}';
                            if (await canLaunch(url)) {
                              launch(url);
                              // final action = await AlertDialogs.yesCancelDialog(
                              //     context, 'Open Gmail', 'Click confirm to proceed');
                              // if (action == DialogsAction.yes) {

                              // } else {
                              //   return null;
                            }
                          }
                        },
                        child: Ink(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          height: 55,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: const Color(0xffE6F4F2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  border: Border.all(
                                    width: 2,
                                    color: AppColors.whiteColor,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    AppIcons.mail,
                                    height: 18,
                                    width: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                AppStrings.mail,
                                style: GoogleFonts.inter(
                                  color: AppColors.blackColor,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                ),
                              ),
                              const Spacer(),
                              SvgPicture.asset(
                                AppIcons.chevronRight,
                                height: 20,
                                width: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // WhatsApp Connect
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Material(
                      child: InkWell(
                        highlightColor:
                            AppColors.backgroundColor.withOpacity(0.3),
                        splashColor: AppColors.secondbgColor.withOpacity(0.3),
                        onTap: () async {
                          // final action = await AlertDialogs.yesCancelDialog(
                          //     context, 'Open WhatsApp', 'Click confirm to proceed');
                          // if (action == DialogsAction.yes) {
                          //   launch(
                          //       'https://api.whatsapp.com/send?phone=+2348133258252');
                          // } else {
                          //   return null;
                          // }
                          _displayDialog(context);
                        },
                        child: Ink(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          height: 55,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: const Color(0xffE6F4F2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  border: Border.all(
                                    width: 2,
                                    color: AppColors.whiteColor,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    AppIcons.whatsapp,
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                AppStrings.connectOnWhatsApp,
                                style: GoogleFonts.inter(
                                  color: AppColors.blackColor,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                ),
                              ),
                              const Spacer(),
                              SvgPicture.asset(
                                AppIcons.chevronRight,
                                height: 20,
                                width: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Telegram Connect
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Material(
                      child: InkWell(
                        highlightColor:
                            AppColors.backgroundColor.withOpacity(0.3),
                        splashColor: AppColors.secondbgColor.withOpacity(0.3),
                        onTap: () async {
                          // final action = await AlertDialogs.yesCancelDialog(
                          //     context, 'Open WhatsApp', 'Click confirm to proceed');
                          // if (action == DialogsAction.yes) {
                          //   launch(
                          //       'https://api.whatsapp.com/send?phone=+2348133258252');
                          // } else {
                          //   return null;
                          // }
                          _displayTelegramDialog(context);
                        },
                        child: Ink(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          height: 55,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: const Color(0xffE6F4F2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  border: Border.all(
                                    width: 2,
                                    color: AppColors.whiteColor,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    AppIcons.whatsapp,
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                AppStrings.connectOnTelegram,
                                style: GoogleFonts.inter(
                                  color: AppColors.blackColor,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                ),
                              ),
                              const Spacer(),
                              SvgPicture.asset(
                                AppIcons.chevronRight,
                                height: 20,
                                width: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future openBrowserURl({
    required String url,
    bool inApp = false,
  }) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: inApp,
        forceWebView: inApp,
        enableJavaScript: true,
      );
    }
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 50,
              vertical: 280,
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Text(
                    'Open WhatsApp..?',
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
                fontSize: 11,
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
                      onTap: () {
                        launch(AppStrings.huzzWhatsAppContactURI);
                      },
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
          );
        });
  }

  _displayTelegramDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 50,
              vertical: 280,
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Text(
                    'Open Telegram..?',
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
                fontSize: 11,
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
                      onTap: () {
                        launch(AppStrings.huzzTelegramContactURI);
                      },
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
          );
        });
  }
}
