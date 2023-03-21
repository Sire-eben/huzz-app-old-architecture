import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/core/constants/app_strings.dart';
import 'package:huzz/ui/team/join_team.dart';
import 'package:share_plus/share_plus.dart';

enum DynamicLinkStatus { idle, loading, done, failed }

class FirebaseDynamicLinkService extends ChangeNotifier {
  DynamicLinkStatus _dynamicLinkStatus = DynamicLinkStatus.idle;

  DynamicLinkStatus get dynamicLinkStatus => _dynamicLinkStatus;

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      final Uri? deeplink = dynamicLink!.link;

      if (deeplink != null) {
        handleTeamInviteLink(deeplink);
      }
    }, onError: (OnLinkErrorException e) async {
      print("We got error $e");
    });
  }

  void handleTeamInviteLink(Uri url) {
    List<String> seperatedLink = [];

    /// osama.link.page/Hellow --> osama.link.page and Hellow
    seperatedLink.addAll(url.path.split('/'));
    Get.to(
      () => JoinBusinessTeam(
        businessName: seperatedLink[3],
        teamId: seperatedLink[2],
        businessId: seperatedLink[1],
      ),
    );
  }

  Future<void> shareBusinessIdLink({
    required String businessId,
    required String teamId,
    required String businessName,
  }) async {
    try {
      _dynamicLinkStatus = DynamicLinkStatus.loading;

      notifyListeners();
      String url = "https://huzz.page.link";
      final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: url,
        link: Uri.parse("$url/$businessId/$teamId/$businessName"),
        androidParameters: AndroidParameters(
          packageName: AppStrings.appId,
          minimumVersion: 1,
        ),
        iosParameters: IosParameters(
          bundleId: AppStrings.appId,
          appStoreId: AppStrings.appStoreId,
          minimumVersion: '1',
        ),
      );

      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      String teamInviteLink = shortLink.shortUrl.toString();

      _dynamicLinkStatus = DynamicLinkStatus.done;
      notifyListeners();
      Share.share(
          'You have been invited to manage $businessName on Huzz. Click this: $teamInviteLink',
          subject: 'Share team invite link');
    } catch (error) {
      _dynamicLinkStatus = DynamicLinkStatus.failed;

      notifyListeners();
      Get.snackbar("Error occured", error.toString());
    }
  }
}
