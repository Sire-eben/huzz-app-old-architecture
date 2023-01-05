import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FaqWebView extends StatefulWidget {
  const FaqWebView({super.key});

  @override
  _FaqWebViewState createState() => _FaqWebViewState();
}

class _FaqWebViewState extends State<FaqWebView> {
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
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 16,
          ),
        ),
        backgroundColor: AppColors.backgroundColor,
        centerTitle: true,
        title: Text(
          'FAQs',
          style: GoogleFonts.inter(
            color: AppColors.whiteColor,
            fontSize: 16,
          ),
        ),
      ),
      body: Stack(
        children: [
          WillPopScope(
            onWillPop: () async {
              String? url = await controller!.currentUrl();
              if (url == "https://huzz.africa/mobile/faq") {
                return true;
              } else {
                controller!.goBack();
                return false;
              }
            },
            child: Builder(builder: (context) {
              return WebView(
                  key: _key,
                  initialUrl: "https://huzz.africa/mobile/faq",
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
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.backgroundColor,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
