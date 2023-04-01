import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/services/dynamic_linking/team_dynamic_link_api.dart';
import 'package:huzz/data/repository/business_respository.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../widget/loading_widget.dart';

class TeamMemberConfirmation extends StatefulWidget {
  TeamMemberConfirmation({Key? key}) : super(key: key);

  @override
  State<TeamMemberConfirmation> createState() => _TeamMemberConfirmationState();
}

class _TeamMemberConfirmationState extends State<TeamMemberConfirmation> {
  final _businessController = Get.find<BusinessRespository>();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
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
          child: Icon(
            Icons.arrow_back,
            color: AppColors.backgroundColor,
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
                  color: AppColors.backgroundColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
            Center(
              child: Text(
                'Updated',
                style: GoogleFonts.inter(
                  color: AppColors.backgroundColor,
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
            GestureDetector(
              onTap: () async {
                setState(() {
                  isLoading = true;
                });
                final deeplink = await context
                    .read<TeamDynamicLinksApi>()
                    .createTeamInviteLink(
                      businessId: _businessController
                          .selectedBusiness.value!.businessId
                          .toString(),
                      teamId: _businessController.selectedBusiness.value!.teamId
                          .toString(),
                      businessName: _businessController
                          .selectedBusiness.value!.businessName
                          .toString(),
                    );
                setState(() => isLoading = false);
                Share.share(
                    'You have been invited to manage ${_businessController.selectedBusiness.value!.businessName} on Huzz. Click this: $deeplink',
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
                  child: isLoading
                      ? Container(
                          width: 30,
                          height: 30,
                          child: LoadingWidget(
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Reshare Invite Link',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
            const Gap(Insets.lg),
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    border:
                        Border.all(width: 2, color: AppColors.backgroundColor),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    'Proceed',
                    style: GoogleFonts.inter(
                      color: AppColors.backgroundColor,
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
  }
}
