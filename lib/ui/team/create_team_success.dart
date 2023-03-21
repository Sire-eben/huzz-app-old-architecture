import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/services/firebase/dynamic_link_api.dart';
import 'package:huzz/core/widgets/state/loading.dart';
import 'package:provider/provider.dart';
import '../../data/repository/auth_respository.dart';
import '../../data/repository/business_respository.dart';

class CreateTeamSuccess extends StatefulWidget {
  const CreateTeamSuccess({Key? key}) : super(key: key);

  @override
  State<CreateTeamSuccess> createState() => _CreateTeamSuccessState();
}

class _CreateTeamSuccessState extends State<CreateTeamSuccess> {
  final controller = Get.find<AuthRepository>();
  final _businessController = Get.find<BusinessRespository>();
  // bool isLoadingTeamInviteLink = false;
  String? values, teamInviteLink, busName;

  @override
  void initState() {
    context.read<DynamicLinksApi>().handleDynamicLink();
    super.initState();
    final value = _businessController.selectedBusiness.value!.businessId;
    busName = _businessController.selectedBusiness.value!.businessName;
  }

  @override
  Widget build(BuildContext context) {
    final dynamicLinkService = context.read<DynamicLinksApi>();
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
            Center(
              child: Text(
                'Team\nCreated Successfully',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: AppColors.backgroundColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(height: 50),
            Center(
              child: Image.asset(
                'assets/images/checker.png',
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                dynamicLinkService.createTeamInviteLink(
                    businessId: _businessController
                        .selectedBusiness.value!.businessId
                        .toString());
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
                  child: dynamicLinkService.dynamicLinkStatus ==
                          DynamicLinkStatus.loading
                      ? const LoadingWidget(color: Colors.white)
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
                    'Proceed',
                    style: GoogleFonts.inter(
                      color: AppColors.backgroundColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
