// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:huzz/core/util/extension.dart';
// import 'package:share_plus/share_plus.dart';

// class FirebaseDynamicLinkService {
//   static Future<void> initDynamicLinks() async {
//     FirebaseDynamicLinks.instance.onLink(
//         onSuccess: (PendingDynamicLinkData? dynamicLink) async {
//       final Uri deeplink = dynamicLink!.link;
//       if (deeplink != null) {
//         ///Handling of link here
//       }
//     }, onError: (OnLinkErrorException e) async {
//       Get.snackbar("Error", e.toString());
//     });
//   }
// }
