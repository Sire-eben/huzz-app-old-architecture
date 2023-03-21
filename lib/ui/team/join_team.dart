import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/util/extension.dart';
import 'package:huzz/core/widgets/app_bar.dart';
import 'package:huzz/core/widgets/button/button.dart';
import 'package:huzz/core/widgets/button/outlined_button.dart';
import 'package:huzz/data/repository/team_repository.dart';
import 'package:huzz/ui/app_scaffold.dart';

class JoinBusinessTeam extends StatefulWidget {
  final String businessId;

  const JoinBusinessTeam({
    super.key,
    required this.businessId,
  });

  @override
  State<JoinBusinessTeam> createState() => _JoinBusinessTeamState();
}

class _JoinBusinessTeamState extends State<JoinBusinessTeam> {
  final teamController = Get.find<TeamRepository>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Appbar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/team 1.png',
              width: context.getWidth(.7),
            ),
            const Gap(Insets.lg),
            Center(
              child: Text(
                'Accept Invitation\nTo Join Team',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: AppColors.backgroundColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                ),
              ),
            ),
            const Gap(Insets.xl),
            Button(
              label: "Yes",
              action: () {
                teamController.joinTeamWithInviteLink();
              },
            ),
            const Gap(Insets.lg),
            AppOutlineButton(
              action: () => context.pushOff(Dashboard()),
              label: "No",
            )
          ],
        ),
      ),
    );
  }
}
