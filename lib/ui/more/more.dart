import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/ui/team/join_team.dart';
import 'package:huzz/ui/wallet/wallet.dart';
import 'package:huzz/ui/widget/more_widget.dart';
import 'package:huzz/core/constants/app_themes.dart';
import '../../data/repository/auth_respository.dart';
import '../../data/repository/team_repository.dart';
import '../team/my_team.dart';
import '../team/no_permission_team.dart';
import 'help_and_support.dart';

class More extends StatefulWidget {
  const More({Key? key}) : super(key: key);

  @override
  _MoreState createState() => _MoreState();
}

class _MoreState extends State<More> {
  final _authController = Get.put(AuthRepository());
  final _teamController = Get.find<TeamRepository>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Text(
              'Do more with Huzz',
              style: GoogleFonts.inter(
                color: AppColors.backgroundColor,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            //my team features
            InkWell(
              onTap: (() {
                _teamController.teamStatus == TeamStatus.UnAuthorized
                    ? Get.to(() => const NoPermissionTeam())
                    : Get.to(() => const MyTeam());
              }),
              child: MoreWidget(
                image: 'assets/images/teamIcon.png',
                title: 'My Team',
                description: 'Collaborate with coworkers',
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            InkWell(
              onTap: (() {
                Get.to(() => const WalletScreen());
              }),
              child: MoreWidget(
                image: 'assets/images/wallett.png',
                title: 'Bank/wallet',
                description: 'Receive funds/transfer',
              ),
            ),

            const SizedBox(
              height: 10,
            ),
            // InkWell(
            //   onTap: (() {
            //     // Get.to(() => MyTeam());
            //   }),
            //   child: MoreWidget(
            //     image: 'assets/images/storeee 1.png',
            //     title: 'Store',
            //     description: 'Sell your products easily',
            //   ),
            // ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.asset('assets/images/my_store.png'),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: (() {
                Get.to(() => const HelpsAndSupport());
              }),
              child: MoreWidget(
                image: 'assets/images/call.png',
                title: 'Help and Support',
                description: '',
              ),
            ),

            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: (() {
                // Get.to({"routeName": "/JoinBusinessTeam"});
                Get.toNamed('/JoinBusinessTeam');
              }),
              child: MoreWidget(
                image: 'assets/images/call.png',
                title: 'Join Team',
                description: '',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBlur({
    required Widget child,
    double sigmaX = 10,
    double sigmaY = 10,
  }) =>
      BackdropFilter(
        filter: ImageFilter.blur(),
        child: child,
      );
}
