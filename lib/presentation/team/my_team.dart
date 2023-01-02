import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/data/model/team.dart';
import 'package:huzz/data/repository/auth_repository.dart';
import 'package:huzz/data/repository/business_repository.dart';
import 'package:huzz/data/repository/team_repository.dart';
import 'package:huzz/presentation/team/team_member_information_dialog.dart';
import 'package:huzz/presentation/widget/no_team_widget.dart';
import 'package:huzz/presentation/widget/team_widget.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:intl/intl.dart';
import '../widget/loading_widget.dart';
import 'add_member.dart';

class NoAccessDialog extends StatelessWidget {
  const NoAccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.info_outline_rounded,
          size: 27,
        ),
        const SizedBox(height: 7),
        Text(
          "You are not authorized to perform this action",
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class MyTeam extends StatefulWidget {
  const MyTeam({Key? key}) : super(key: key);

  @override
  State<MyTeam> createState() => _MyTeamState();
}

class _MyTeamState extends State<MyTeam> {
  final controller = Get.find<AuthRepository>();
  final _businessController = Get.find<BusinessRespository>();
  final _teamController = Get.find<TeamRepository>();

  String? values, date;
  late String firstName, lastName, phone;

  @override
  void initState() {
    firstName = controller.user!.firstName!;
    lastName = controller.user!.lastName!;
    phone = controller.user!.phoneNumber!;
    // print(phone);

    controller.checkTeamInvite();
    super.initState();

    List<Teams> team = _teamController.onlineBusinessTeam
        .where((element) => element.phoneNumber == phone)
        .toList();

    for (var i in team) {
      var getDate = i.createdDateTime!.toLocal();
      date = DateFormat("yMMMEd").format(getDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final value = _businessController.selectedBusiness.value;
      if (kDebugMode) {
        // print(
        //     'Team member length: ${_teamController.onlineBusinessTeam.length}');
      }
      return RefreshIndicator(
        onRefresh: () async {
          return Future.delayed(const Duration(seconds: 1), () {
            _teamController.getOnlineTeam(value!.teamId);
          });
        },
        child: _teamController.teamMembersStatus == TeamMemberStatus.Loading
            ? Center(
                child: LoadingWidget(
                color: AppColors.backgroundColor,
              ))
            : Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(
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
                floatingActionButton: (value!.teamId == null ||
                        phone !=
                            _teamController
                                .onlineBusinessTeam.first.phoneNumber)
                    ? Container()
                    : FloatingActionButton.extended(
                        onPressed: () {
                          Get.to(() => const AddMember());
                        },
                        icon: const Icon(Icons.add),
                        backgroundColor: AppColors.backgroundColor,
                        label: Text(
                          'Add new member',
                          style: GoogleFonts.inter(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                body: value.teamId == null
                    ? NoTeamWidget()
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Column(
                          children: [
                            if (phone ==
                                _teamController
                                    .onlineBusinessTeam.first.phoneNumber) ...[
                              Expanded(
                                child: Obx(() {
                                  if (_teamController.teamStatus ==
                                      TeamStatus.Loading) {
                                    return Center(
                                      child: LoadingWidget(
                                        color: AppColors.backgroundColor,
                                      ),
                                    );
                                  } else if (_teamController.teamStatus ==
                                      TeamStatus.Available) {
                                    return ListView.builder(
                                      itemCount: _teamController
                                          .onlineBusinessTeam.length,
                                      itemBuilder: (context, index) {
                                        var item = _teamController
                                            .onlineBusinessTeam[index];
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: TeamsWidget(
                                            name: item.email == null
                                                ? '$firstName $lastName'
                                                : item.email!,
                                            position: item.teamMemberStatus !=
                                                    "CREATOR"
                                                ? "Member"
                                                : 'Admin',
                                            status: item.teamMemberStatus ==
                                                    "CREATOR"
                                                ? Container()
                                                : (item.teamMemberStatus !=
                                                            "CREATOR" &&
                                                        item.teamMemberStatus ==
                                                            "INVITE_LINK_SENT")
                                                    ? const StatusWidget(
                                                        color: AppColors
                                                            .backgroundColor,
                                                        text: "Pending",
                                                      )
                                                    : const StatusWidget(
                                                        color: AppColors
                                                            .orangeBorderColor,
                                                        text: "Invited",
                                                      ),
                                            editAction: item.teamMemberStatus !=
                                                    'CREATOR'
                                                ? GestureDetector(
                                                    onTap: () {
                                                      Get.to(() => UpdateMember(
                                                          team: item));
                                                    },
                                                    child: SvgPicture.asset(
                                                      'assets/images/edit.svg',
                                                      height: 20,
                                                      width: 20,
                                                    ))
                                                : Container(),
                                            deleteAction: item
                                                        .teamMemberStatus !=
                                                    "CREATOR"
                                                ? Obx(() {
                                                    return GestureDetector(
                                                        onTap: () {
                                                          // print(
                                                          //     'deleting team member: ${item.toJson()}');
                                                          _deleteTeamMemberDialog(
                                                              context, item);
                                                        },
                                                        child: _teamController
                                                                    .deleteTeamMemberStatus ==
                                                                DeleteTeamStatus
                                                                    .Loading
                                                            ? const CupertinoActivityIndicator(
                                                                radius: 10,
                                                              )
                                                            : SvgPicture.asset(
                                                                'assets/images/delete.svg',
                                                                height: 20,
                                                                width: 20,
                                                              ));
                                                  })
                                                : Container(),
                                          ),
                                        );
                                      },
                                    );
                                  } else if (_teamController
                                          .onlineBusinessTeam.isEmpty) {
                                    return NoTeamWidget();
                                  } else {
                                    return Container();
                                  }
                                }),
                              ),
                            ] else ...[
                              Center(
                                child: Text(
                                  'You joined the ${value.businessName} team on\n$date',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    color: AppColors.blackColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              NoTeamsWidget(
                                fName: firstName,
                                lName: lastName,
                                position: "Member",
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .1),
                              Image.asset('assets/images/my_teams.png'),
                            ]
                          ],
                        ),
                      ),
              ),
      );
    });
  }

  _deleteTeamMemberDialog(BuildContext context, var item) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 50,
            ),
            title: Text(
              'Delete Team Member',
              style: GoogleFonts.inter(
                color: AppColors.backgroundColor,
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
            content: Text(
              "You're about to delete this team member, click delete to proceed",
              style: GoogleFonts.inter(
                color: AppColors.blackColor,
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          height: 45,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              border: Border.all(
                                width: 1.2,
                                color: AppColors.backgroundColor,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.inter(
                                color: AppColors.backgroundColor,
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.back();
                          _teamController.deleteTeamMemberOnline(item);
                        },
                        child: Container(
                          height: 45,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                              color: AppColors.orangeBorderColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              'Delete',
                              style: GoogleFonts.inter(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}

class StatusWidget extends StatelessWidget {
  final Color? color;
  final String? text;
  const StatusWidget({
    Key? key,
    this.color,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1, color: color!),
          color: color!.withOpacity(0.2)),
      child: Text(
        text!,
        style: GoogleFonts.inter(
            fontSize: 7, color: color!, fontWeight: FontWeight.w400),
      ),
    );
  }
}
