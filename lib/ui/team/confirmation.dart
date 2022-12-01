import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/repository/auth_respository.dart';
import '../../data/repository/business_respository.dart';
import '../../util/colors.dart';

class TeamConfirmation extends StatefulWidget {
  TeamConfirmation({Key? key}) : super(key: key);

  @override
  State<TeamConfirmation> createState() => _TeamConfirmationState();
}

class _TeamConfirmationState extends State<TeamConfirmation> {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  final controller = Get.find<AuthRepository>();
  final _businessController = Get.find<BusinessRespository>();
  bool isLoadingTeamInviteLink = false;
  String? values, teamInviteLink, busName;

  @override
  void initState() {
    controller.checkTeamInvite();
    super.initState();
    final value = _businessController.selectedBusiness.value!.businessId;
    print('BusinessId: $value');
    busName = _businessController.selectedBusiness.value!.businessName;
    final teamId = _businessController.selectedBusiness.value!.teamId;
    print('Business TeamId: $teamId');
    shareBusinessIdLink(value.toString());
  }

  Future<void> shareBusinessIdLink(String businessId) async {
    if (controller.onlineStatus == OnlineStatus.Onilne) {
      try {
        setState(() {
          isLoadingTeamInviteLink = true;
        });
        final appId = "com.app.huzz";
        final url = "https://huzz.africa/businessId=$businessId";
        final DynamicLinkParameters parameters = DynamicLinkParameters(
          uriPrefix: 'https://huzz.page.link',
          link: Uri.parse(url),
          androidParameters: AndroidParameters(
            packageName: appId,
            minimumVersion: 1,
          ),
          iosParameters: IOSParameters(
            bundleId: appId,
            appStoreId: "1596574133",
            minimumVersion: '1',
          ),
        );
        final shortLink = await dynamicLinks.buildShortLink(parameters);
        teamInviteLink = shortLink.shortUrl.toString();
        print('invite link: $teamInviteLink');
        setState(() {
          isLoadingTeamInviteLink = false;
        });
      } catch (error) {
        print(error.toString());
        setState(() {
          isLoadingTeamInviteLink = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final value = _businessController.selectedBusiness.value;
      return Scaffold(
        backgroundColor: AppColor().whiteColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColor().whiteColor,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back,
              color: AppColor().backgroundColor,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Center(
                child: Text(
                  'Team Member Successfully',
                  style: GoogleFonts.inter(
                    color: AppColor().backgroundColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ),
              Center(
                child: Text(
                  'Added',
                  style: GoogleFonts.inter(
                    color: AppColor().backgroundColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Center(
                child: Image.asset(
                  'assets/images/checker.png',
                ),
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  print(teamInviteLink);
                  Share.share(
                      'You have been invited to manage $busName on Huzz. Click this: ${teamInviteLink!}',
                      subject: 'Share team invite link');
                },
                child: Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColor().backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: isLoadingTeamInviteLink
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            'Share invite link',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                      color: AppColor().whiteColor,
                      border: Border.all(
                          width: 2, color: AppColor().backgroundColor),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      'Proceed',
                      style: GoogleFonts.inter(
                        color: AppColor().backgroundColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      );
    });
  }
}
