// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:huzz/ui/privacy_policy.dart';
import 'package:huzz/util/colors.dart';
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
          icon: Icon(
            Icons.arrow_back,
            color: AppColor().backgroundColor,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Row(
          children: [
            Text(
              AppStrings.helpAndSupport,
              style: TextStyle(
                color: AppColor().backgroundColor,
                fontFamily: 'InterRegular',
                fontWeight: FontWeight.bold,
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
                            AppColor().backgroundColor.withOpacity(0.3),
                        splashColor: AppColor().secondbgColor.withOpacity(0.3),
                        onTap: () {
                          Get.to(Privacy());
                        },
                        child: Ink(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          height: 55,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Color(0xffE6F4F2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: AppColor().whiteColor,
                                  border: Border.all(
                                    width: 2,
                                    color: AppColor().whiteColor,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Image(
                                      image: AssetImage(AppIcons.privacyPolicy),
                                      width: 20,
                                      height: 20),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                AppStrings.privacyPolicy,
                                style: TextStyle(
                                  color: AppColor().blackColor,
                                  fontFamily: 'InterRegular',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                ),
                              ),
                              Spacer(),
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
                  SizedBox(
                    height: 20,
                  ),
                  //TERMS OF USE
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Material(
                      child: InkWell(
                        highlightColor:
                            AppColor().backgroundColor.withOpacity(0.3),
                        splashColor: AppColor().secondbgColor.withOpacity(0.3),
                        onTap: () {
                          Get.to(TermsOfUse());
                        },
                        child: Ink(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          height: 55,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Color(0xffE6F4F2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: AppColor().whiteColor,
                                  border: Border.all(
                                    width: 2,
                                    color: AppColor().whiteColor,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Image(
                                      image: AssetImage(AppIcons.privacyPolicy),
                                      width: 20,
                                      height: 20),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                AppStrings.termsOfUse,
                                style: TextStyle(
                                  color: AppColor().blackColor,
                                  fontFamily: 'InterRegular',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                ),
                              ),
                              Spacer(),
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
                  SizedBox(
                    height: 20,
                  ),
                  // FAQ
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Material(
                      child: InkWell(
                        highlightColor:
                            AppColor().backgroundColor.withOpacity(0.3),
                        splashColor: AppColor().secondbgColor.withOpacity(0.3),
                        onTap: () {
                          Get.to(FaqWeb());
                        },
                        child: Ink(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          height: 55,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Color(0xffE6F4F2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: AppColor().whiteColor,
                                  border: Border.all(
                                    width: 2,
                                    color: AppColor().whiteColor,
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
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                AppStrings.faq,
                                style: TextStyle(
                                  color: AppColor().blackColor,
                                  fontFamily: 'InterRegular',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                ),
                              ),
                              Spacer(),
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
                  SizedBox(
                    height: 20,
                  ),
                  // Mail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Material(
                      child: InkWell(
                        highlightColor:
                            AppColor().backgroundColor.withOpacity(0.3),
                        splashColor: AppColor().secondbgColor.withOpacity(0.3),
                        onTap: () async {
                          if (_authController.onlineStatus ==
                              OnlineStatus.Onilne) {
                            final toEmail = 'info@huzz.africa';
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          height: 55,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Color(0xffE6F4F2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: AppColor().whiteColor,
                                  border: Border.all(
                                    width: 2,
                                    color: AppColor().whiteColor,
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
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                AppStrings.mail,
                                style: TextStyle(
                                  color: AppColor().blackColor,
                                  fontFamily: 'InterRegular',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                ),
                              ),
                              Spacer(),
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
                  SizedBox(
                    height: 20,
                  ),
                  // WhatsApp Connect
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Material(
                      child: InkWell(
                        highlightColor:
                            AppColor().backgroundColor.withOpacity(0.3),
                        splashColor: AppColor().secondbgColor.withOpacity(0.3),
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          height: 55,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Color(0xffE6F4F2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: AppColor().whiteColor,
                                  border: Border.all(
                                    width: 2,
                                    color: AppColor().whiteColor,
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
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                AppStrings.connectOnWhatsApp,
                                style: TextStyle(
                                  color: AppColor().blackColor,
                                  fontFamily: 'InterRegular',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                ),
                              ),
                              Spacer(),
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
            insetPadding: EdgeInsets.symmetric(
              horizontal: 50,
              vertical: 280,
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Text(
                    'Open WhatsApp..?',
                    style: TextStyle(
                      color: AppColor().backgroundColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            content: Container(
              child: Text(
                AppStrings.continueToProceed,
                style: TextStyle(
                  color: AppColor().blackColor,
                  fontFamily: 'InterRegular',
                  fontWeight: FontWeight.normal,
                  fontSize: 11,
                ),
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
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
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                            color: AppColor().whiteColor,
                            border: Border.all(
                              width: 2,
                              color: AppColor().backgroundColor,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: AppColor().backgroundColor,
                              fontFamily: 'InterRegular',
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
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                            color: AppColor().backgroundColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            'Continue',
                            style: TextStyle(
                              color: AppColor().whiteColor,
                              fontFamily: 'InterRegular',
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