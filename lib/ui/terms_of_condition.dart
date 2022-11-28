import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../util/colors.dart';

class TermsOfUse extends StatefulWidget {
  @override
  _TermsOfUseState createState() => _TermsOfUseState();
}

class _TermsOfUseState extends State<TermsOfUse> {
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
          'Terms of use',
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
              if (url == "https://huzz.africa/mobile/terms-of-use") {
                return true;
              } else {
                controller!.goBack();
                return false;
              }
            },
            child: Builder(builder: (context) {
              return WebView(
                  key: _key,
                  initialUrl: "https://huzz.africa/mobile/terms-of-use",
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
