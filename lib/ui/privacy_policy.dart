import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/util/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Privacy extends StatefulWidget {
  @override
  _PrivacyState createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  bool isLoading = true;
  final _key = UniqueKey();
  WebViewController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 16,
          ),
        ),
        backgroundColor: AppColor().backgroundColor,
        centerTitle: true,
        title: Text(
          'Privacy Policy',
          style: GoogleFonts.inter(
            color: AppColor().whiteColor,
            fontSize: 16,
          ),
        ),
      ),
      body: Stack(
        children: [
          WillPopScope(
            onWillPop: () async {
              String? url = await controller!.currentUrl();
              if (url == "https://huzz.africa/mobile/privacy-policy") {
                return true;
              } else {
                controller!.goBack();
                return false;
              }
            },
            child: Builder(builder: (context) {
              return WebView(
                  key: _key,
                  initialUrl: "https://huzz.africa/mobile/privacy-policy",
                  javascriptMode: JavascriptMode.unrestricted,
                  onPageFinished: (finish) {
                    setState(() {
                      isLoading = false;
                    });
                  },
                  onWebViewCreated: (WebViewController wc) {
                    controller = wc;
                  });
            }),
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppColor().backgroundColor,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
