import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/core/constants/app_strings.dart';
import 'package:huzz/ui/team/join_team.dart';

enum DynamicLinkStatus { idle, loading, done, failed }

enum CreateLinkStatus { idle, loading, done, failed }

class DynamicLinksApi extends ChangeNotifier {
  DynamicLinkStatus _dynamicLinkStatus = DynamicLinkStatus.idle;
  CreateLinkStatus _createLinkStatus = CreateLinkStatus.idle;

  DynamicLinkStatus get dynamicLinkStatus => _dynamicLinkStatus;
  CreateLinkStatus get createLinkStatus => _createLinkStatus;

  final dynamicLink = FirebaseDynamicLinks.instance;

  handleDynamicLink() async {
    print('checking for invite');
    await dynamicLink.getInitialLink();
    dynamicLink.onLink(
      onSuccess: (PendingDynamicLinkData? data) async {
        handleSuccessLinking(data);
      },
      onError: (OnLinkErrorException error) async {
        print(error.toString());
      },
    );
  }

  void handleSuccessLinking(PendingDynamicLinkData? data) {
    final Uri deepLink = data!.link;

    if (deepLink != null) {
      var isInvite = deepLink.pathSegments.contains('teamInvite');
      if (isInvite) {
        var businessId = deepLink.queryParameters['businessId'];
        // var teamId = deepLink.queryParameters['teamId'];
        // var businessName = deepLink.queryParameters['businessName'];
        if (businessId != null) {
          Get.to(
            JoinBusinessTeam(
              businessId: businessId,
              teamInviteUrl: deepLink.toString(),
            ),
          );
        }
      }
    }
  }

  Future<String> createTeamInviteLink({
    required String businessId,
  }) async {
    final DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
      uriPrefix: 'https://huzz.page.link',
      link: Uri.parse('https://huzz.africa/teamInvite?businessId=$businessId'),
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

    final ShortDynamicLink shortLink =
        await dynamicLinkParameters.buildShortLink();
    final Uri dynamicUrl = shortLink.shortUrl;

    return dynamicUrl.toString();
  }
}
