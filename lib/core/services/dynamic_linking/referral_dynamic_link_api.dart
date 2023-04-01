import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/core/constants/app_strings.dart';
import 'package:huzz/data/repository/auth_respository.dart';
import 'package:huzz/ui/auth/sign_in.dart';
import 'package:huzz/ui/auth/sign_up.dart';
import 'package:huzz/ui/business/create_business.dart';
import 'package:huzz/ui/onboarding_main..dart';

class ReferralDynamicLinksApi extends ChangeNotifier {
  final dynamicLink = FirebaseDynamicLinks.instance;
  final _controller = Get.find<AuthRepository>();

  handleDynamicLink() async {
    await dynamicLink.getInitialLink();
    dynamicLink.onLink(
      onSuccess: (PendingDynamicLinkData? data) async {
        handleSuccessLinking(data);
      },
      onError: (OnLinkErrorException error) async {},
    );
  }

  void handleSuccessLinking(PendingDynamicLinkData? data) {
    final Uri deepLink = data!.link;

    if (deepLink != null) {
      var refer = deepLink.pathSegments.contains('refer');
      if (refer) {
        var code = deepLink.queryParameters['code'];
        if (code != null) {
          if (_controller.authStatus == AuthStatus.IsFirstTime) {
            Get.off(() => const OnboardingMain());
          } else if (_controller.authStatus == AuthStatus.Authenticated) {
            if (_controller.user!.businessList!.isEmpty) {
              Get.off(() => const CreateBusiness());
            } else {
              Get.off(
                () => Signup(referralCode: code.toString()),
              );
            }
          } else {
            Get.off(() => const Signin());
          }
        }
      }
    }
  }

  Future<String> createReferralLink({required String code}) async {
    final DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
      uriPrefix: 'https://huzz.page.link',
      link: Uri.parse('https://huzz.africa/refer?code=$code'),
      androidParameters: AndroidParameters(
        packageName: AppStrings.appId,
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: AppStrings.appId,
        appStoreId: AppStrings.appStoreId,
        minimumVersion: '1',
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
    );

    final ShortDynamicLink shortLink =
        await dynamicLinkParameters.buildShortLink();
    final Uri dynamicUrl = shortLink.shortUrl;

    return dynamicUrl.toString();
  }
}
