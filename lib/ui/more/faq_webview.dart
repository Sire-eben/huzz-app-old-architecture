import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/widgets/state/loading.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FaqWeb extends StatefulWidget {
  const FaqWeb({super.key});

  @override
  _FaqWebState createState() => _FaqWebState();
}

class _FaqWebState extends State<FaqWeb> {
  bool isLoading = true;
  final _key = UniqueKey();
  WebViewController? controller;

  _openMail() async {
    const url = 'mailto:info@huzz.africa';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _openPhone() async {
    const url = 'tel:+234 813 289 4616';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

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
                  navigationDelegate: (NavigationRequest request) async{

                    if (request.url.startsWith('mailto:info@huzz.africa')) {
                      _openMail;
                      return _openMail();
                    }
                    if (request.url.startsWith('tel:+234 813 289 4616')) {
                      _openPhone;
                      return _openPhone();
                    }else {
                      return NavigationDecision.navigate;
                    }
                  },
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
          isLoading ? const LoadingWidget() : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
