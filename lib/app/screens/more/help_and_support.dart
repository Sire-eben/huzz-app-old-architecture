// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:huzz/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'faq_webview.dart';

class HelpsAndSupport extends StatefulWidget {
  const HelpsAndSupport({Key? key}) : super(key: key);

  @override
  _HelpsAndSupportState createState() => _HelpsAndSupportState();
}

class _HelpsAndSupportState extends State<HelpsAndSupport> {
  String emailSubject = '';
  String emailMessage = '';

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
              'Help and Support',
              style: TextStyle(
                color: AppColor().backgroundColor,
                fontFamily: 'DMSans',
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
                  // FAQ
                  InkWell(
                    onTap: () {
                      Get.to(FaqWeb());
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                                "assets/images/faq.svg",
                                height: 15,
                                width: 15,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'FAQ',
                            style: TextStyle(
                              color: AppColor().blackColor,
                              fontFamily: 'DMSans',
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                          Spacer(),
                          SvgPicture.asset(
                            "assets/images/chevron-right.svg",
                            height: 20,
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Mail
                  InkWell(
                    onTap: () async {
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
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                                "assets/images/mail.svg",
                                height: 18,
                                width: 18,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Mail',
                            style: TextStyle(
                              color: AppColor().blackColor,
                              fontFamily: 'DMSans',
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                          Spacer(),
                          SvgPicture.asset(
                            "assets/images/chevron-right.svg",
                            height: 20,
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // WhatsApp Connect
                  InkWell(
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
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                                "assets/images/whatsapp.svg",
                                height: 20,
                                width: 20,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Connect on WhatsApp',
                            style: TextStyle(
                              color: AppColor().blackColor,
                              fontFamily: 'DMSans',
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                          Spacer(),
                          SvgPicture.asset(
                            "assets/images/chevron-right.svg",
                            height: 20,
                            width: 20,
                          ),
                        ],
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
                'Please click continue if you want to proceed',
                style: TextStyle(
                  color: AppColor().blackColor,
                  fontFamily: 'DMSans',
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
                              fontFamily: 'DMSans',
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        launch(
                            'https://api.whatsapp.com/send?phone=+2348132894616');
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
                              fontFamily: 'DMSans',
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
