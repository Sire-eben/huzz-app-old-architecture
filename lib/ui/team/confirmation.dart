import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/services/dynamic_linking/dynamic_link_api.dart';
import 'package:huzz/core/widgets/app_bar.dart';
import 'package:huzz/core/widgets/state/loading.dart';
import 'package:provider/provider.dart';
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
  final controller = Get.find<AuthRepository>();
  final _businessController = Get.find<BusinessRespository>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: Appbar(showLeading: false),
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
              onTap: () async {
                setState(() => isLoading = true);
                final deeplink =
                    await context.read<DynamicLinksApi>().createTeamInviteLink(
                          businessId: _businessController
                              .selectedBusiness.value!.businessId
                              .toString(),
                          teamId: _businessController
                              .selectedBusiness.value!.teamId
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
                      ? const LoadingWidget(
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
            const SizedBox(height: 10),
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
  }
}
