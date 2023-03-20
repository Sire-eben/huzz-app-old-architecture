import 'package:country_picker/country_picker.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/util/extension.dart';
import 'package:huzz/core/util/validators.dart';
import 'package:huzz/core/widgets/app_bar.dart';
import 'package:huzz/core/widgets/button/button.dart';
import 'package:huzz/core/widgets/button/outlined_button.dart';
import 'package:huzz/core/widgets/textfield/textfield.dart';
import 'package:huzz/data/repository/auth_respository.dart';
import 'package:huzz/data/repository/team_repository.dart';
import 'package:huzz/ui/app_scaffold.dart';

class JoinBusinessTeam extends StatefulWidget {
  const JoinBusinessTeam({super.key});

  @override
  State<JoinBusinessTeam> createState() => _JoinBusinessTeamState();
}

class _JoinBusinessTeamState extends State<JoinBusinessTeam> {
  final teamController = Get.find<TeamRepository>();
  String countryFlag = "NG";
  String countryCode = "234";

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
            Center(
              child: Text(
                'Accept Invitation To\nJoin This Team?',
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

  Future showCountryCode(BuildContext context) async {
    showCountryPicker(
      context: context,
      showPhoneCode:
          true, // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        countryCode = country.toJson()['e164_cc'];
        countryFlag = country.toJson()['iso2_cc'];

        country.toJson();
        setState(() {});

        print('Select country: ${country.toJson()}');
      },
    );
  }
}
