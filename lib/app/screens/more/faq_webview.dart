import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FaqWeb extends StatefulWidget {
  @override
  _FaqWebState createState() => _FaqWebState();
}

class _FaqWebState extends State<FaqWeb> {
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
          'FAQs',
          style: TextStyle(
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
