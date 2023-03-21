import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/constants/app_strings.dart';
import 'package:huzz/core/widgets/state/loading.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/repository/auth_respository.dart';
import '../../data/repository/business_respository.dart';
import 'package:huzz/core/constants/app_themes.dart';

class TeamConfirmation extends StatefulWidget {
  const TeamConfirmation({Key? key}) : super(key: key);

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
    super.initState();
    final value = _businessController.selectedBusiness.value!.businessId;
    print('BusinessId: $value');
    busName = _businessController.selectedBusiness.value!.businessName;
    final teamId = _businessController.selectedBusiness.value!.teamId;
    print('Business TeamId: $teamId');
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // final value = _businessController.selectedBusiness.value;
      return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.whiteColor,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back,
              color: AppColors.backgroundColor,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(Insets.lg),
          child: Column(
            children: [
              Center(
                child: Text(
                  'Team Member\nInvited Successfully',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: AppColors.backgroundColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                  ),
                ),
              ),
              const Spacer(),
              Center(
                child: Image.asset(
                  'assets/images/checker.png',
                ),
              ),
              const Spacer(),
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
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: isLoadingTeamInviteLink
                        ? const LoadingWidget()
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
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      border: Border.all(
                          width: 2, color: AppColors.backgroundColor),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      'Go back',
                      style: GoogleFonts.inter(
                        color: AppColors.backgroundColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
