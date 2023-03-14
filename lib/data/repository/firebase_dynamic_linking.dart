import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:huzz/core/util/extension.dart';
import 'package:share_plus/share_plus.dart';

class FirebaseDynamicLinkService {
  static Future<void> initDynamicLinks() async {
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

    // Incoming Links Listener
    dynamicLinks.onLink.listen((dynamicLinkData) {
      final Uri uri = dynamicLinkData.link;
      final queryParams = uri.queryParameters;
      if (queryParams.isNotEmpty) {
        //  your code here
      } else {
        // your code here
      }
    });

    // Search for Firebase Dynamic Links
    PendingDynamicLinkData? data = await dynamicLinks
        .getDynamicLink(Uri.parse("https://huzz.page.link/refcode"));
    final Uri uri = data!.link;
    if (uri != null) {
      // your code here
    } else {
      // your code here
    }
  }

  static Future<void> initFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    // await Future.delayed(Duration(seconds: 3));
    initDynamicLinks();
  }

  static Future<void> initDynamicLinkinking(BuildContext context) async {
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

    dynamicLinks.onLink.listen((dynamicLinkData) {
      final Uri uri = dynamicLinkData.link;
      final queryParams = uri.queryParameters;
      if (queryParams.isNotEmpty) {
        //  your code hERE
        // context.push(page)

        Navigator.pushNamed(context, dynamicLinkData.link.path);
      } else {
        // your code here
        return;
      }
    }).onError((error) {
      print('onLink error');
      print(error.message);
    });

    // FirebaseDynamicLinks.instance.onLink(
    //   onSuccess: (PendingDynamicLinkData? dynamicLink) async {
    //     final Uri? deepLink = dynamicLink!.link;

    //     if (deepLink != null) {
    //       try {
    //         List<String> separatedLink = [];
    //         separatedLink.addAll(deepLink.path.split("/"));
    //         print(separatedLink[1]);
    //       } catch (error) {
    //         print(error);
    //       }
    //     } else {
    //       return;
    //     }
    //   },
    //   onError: (OnLinkErrorException error) async {
    //     print('link error $error');
    //   },
    // );
  }

  //Create dynamic link

  createDynamicLink(
    String teamId,
    String businessName,
  ) async {
    // String _linkMessage;
    String webUrl = "https://huzz.page.link";

    DynamicLinkParameters(
      link: Uri.parse("$webUrl/$teamId"),
      uriPrefix: webUrl,
      androidParameters: AndroidParameters(
        fallbackUrl: Uri.parse(webUrl),
        packageName: "com.app.huzz",
        minimumVersion: 0,
      ),
      iosParameters: IOSParameters(
        fallbackUrl: Uri.parse(webUrl),
        bundleId: "com.app.huzz",
        appStoreId: "123456789",
        minimumVersion: '0',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        description: "You have invited to join $businessName",
        title: businessName,
      ),
    );
    // final ShortDynamicLink shortLink = await parameters;
    // String? desc =
    //     "${shortLink.shortUrl}\nThis is the link to $businessName's store on Buuka";

    await Share.share(
      'desc',
      subject: businessName.toString(),
    );
  }
}
