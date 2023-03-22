import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/util/extension.dart';
import 'package:huzz/core/widgets/button/button.dart';
import 'package:huzz/ui/app_scaffold.dart';

class TeamSuccessView extends StatelessWidget {
  final String businessName;

  const TeamSuccessView({Key? key, required this.businessName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
            Text(
              'You\'ve been added\nto $businessName team successfully.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: AppColors.backgroundColor,
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
            Gap(context.getHeight(.2)),
            Center(
              child: Image.asset(
                'assets/images/checker.png',
              ),
            ),
            const Spacer(),
            Button(
              label: 'Proceed',
              action: () => context.pushOff(Dashboard()),
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
