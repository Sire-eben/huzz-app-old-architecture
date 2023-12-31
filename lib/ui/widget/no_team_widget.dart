import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/widgets/state/loading.dart';
import 'package:huzz/data/repository/business_respository.dart';
import 'package:huzz/data/repository/team_repository.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/data/sharepreference/sharepref.dart';
import 'package:huzz/ui/team/create_team_success.dart';

class NoTeamWidget extends StatefulWidget {
  const NoTeamWidget({super.key});

  @override
  State<NoTeamWidget> createState() => _NoTeamWidgetState();
}

class _NoTeamWidgetState extends State<NoTeamWidget> {
  final controller = Get.find<TeamRepository>();
  final pref = SharePref();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Container(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.height * 0.03,
            right: MediaQuery.of(context).size.height * 0.03,
            bottom: MediaQuery.of(context).size.height * 0.02),
        decoration: BoxDecoration(
            color: const Color(0xffF5F5F5),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 2, color: Colors.grey.withOpacity(0.2))),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/images/users.svg'),
              const SizedBox(
                height: 10,
              ),
              Text(
                'My Team',
                style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'Invite team members to help',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: Colors.black,
                ),
              ),
              Text(
                'you manage your business',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Obx(() {
                return InkWell(
                  onTap: () async {
                    await pref.setFirstTimeCreatingTeam(false);
                    Get.snackbar(
                      "Success",
                      "Team created successfully",
                    );
                    Get.to(const CreateTeamSuccess());
                  },
                  child: Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: (controller.addingTeamMemberStatus ==
                            AddingTeamStatus.Loading)
                        ? const LoadingWidget()
                        : Center(
                            child: Text(
                              'Create Team',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
