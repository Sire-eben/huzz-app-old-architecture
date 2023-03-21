import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/constants/app_themes.dart';
import '../../data/repository/auth_respository.dart';
import '../../data/repository/business_respository.dart';
import '../widget/team_widget.dart';

class NoPermissionTeam extends StatefulWidget {
  const NoPermissionTeam({Key? key}) : super(key: key);

  @override
  State<NoPermissionTeam> createState() => _NoPermissionTeamState();
}

class _NoPermissionTeamState extends State<NoPermissionTeam> {
  final controller = Get.find<AuthRepository>();
  final _businessController = Get.find<BusinessRespository>();

  String? values, date;
  late String firstName, lastName;

  @override
  void initState() {
    firstName = controller.user!.firstName!;
    lastName = controller.user!.lastName!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final value = _businessController.selectedBusiness.value;
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.backgroundColor,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          title: Row(
            children: [
              Text(
                'My Team',
                style: GoogleFonts.inter(
                  color: AppColors.backgroundColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: AppColors.whiteColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(children: [
            Center(
              child: Text(
                'You`re a member of ${value!.businessName} team.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(height: 20),
            NoTeamsWidget(
              fName: firstName,
              lName: lastName,
              position: "Member",
            ),
          ]),
        ),
      );
    });
  }
}
