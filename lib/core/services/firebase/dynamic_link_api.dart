import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/core/constants/app_strings.dart';
import 'package:huzz/ui/team/join_team.dart';

enum DynamicLinkStatus { idle, loading, done, failed }

class DynamicLinksApi extends ChangeNotifier {
  DynamicLinkStatus _dynamicLinkStatus = DynamicLinkStatus.idle;

  DynamicLinkStatus get dynamicLinkStatus => _dynamicLinkStatus;

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

  Future<String> createTeamInviteLink({
    required String businessId,
    required String teamId,
    required String businessName,
  }) async {
    try {
      _dynamicLinkStatus = DynamicLinkStatus.loading;
      notifyListeners();

      final DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
        uriPrefix: 'https://huzz.page.link',
        link: Uri.parse(
            'https://huzz.africa/teamInvite?businessId=$businessId?teamId=$teamId?businessName=$businessName'),
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
      _dynamicLinkStatus = DynamicLinkStatus.done;
      notifyListeners();
      return dynamicUrl.toString();
    } catch (error) {
      _dynamicLinkStatus = DynamicLinkStatus.failed;
      notifyListeners();
      rethrow;
    }
  }

  void handleSuccessLinking(PendingDynamicLinkData? data) {
    final Uri deepLink = data!.link;

    if (deepLink != null) {
      var isInvite = deepLink.pathSegments.contains('teamInvite');
      if (isInvite) {
        var businessId = deepLink.queryParameters['businessId'];
        var teamId = deepLink.queryParameters['teamId'];
        var businessName = deepLink.queryParameters['businessName'];
        if (businessId != null) {
          Get.to(
            JoinBusinessTeam(
              businessId: businessId,
              businessName: businessName.toString(),
              teamId: teamId.toString(),
            ),
          );
        }
      }
    }
  }
}
