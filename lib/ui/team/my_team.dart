import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/services/dynamic_linking/team_dynamic_link_api.dart';
import 'package:huzz/core/util/extension.dart';
import 'package:huzz/core/util/extensions/string.dart';
import 'package:huzz/core/widgets/app_bar.dart';
import 'package:huzz/data/model/team.dart';
import 'package:huzz/data/repository/auth_respository.dart';
import 'package:huzz/data/repository/business_respository.dart';
import 'package:huzz/data/repository/team_repository.dart';
import 'package:huzz/ui/team/update_member.dart';
import 'package:huzz/ui/widget/no_team_widget.dart';
import 'package:huzz/ui/widget/team_widget.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:random_color/random_color.dart';
import 'package:share_plus/share_plus.dart';
import '../widget/huzz_dialog/delete_dialog.dart';
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
  static const String routeName = "myTeam";

  const MyTeam({Key? key}) : super(key: key);

  @override
  State<MyTeam> createState() => _MyTeamState();
}

class _MyTeamState extends State<MyTeam> {
  final controller = Get.find<AuthRepository>();
  final _businessController = Get.find<BusinessRespository>();
  final _teamController = Get.find<TeamRepository>();

  final RandomColor _randomColor = RandomColor();

  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  bool isLoadingTeamInviteLink = false;
  String? values, teamInviteLink, busName, date;

  late String firstName, lastName, phone;

  @override
  void initState() {
    firstName = controller.user!.firstName!;
    lastName = controller.user!.lastName!;
    phone = controller.user!.phoneNumber!;
    context.read<TeamDynamicLinksApi>().handleDynamicLink();
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
                appBar: Appbar(title: "My Team"),
                backgroundColor: AppColors.whiteColor,
                floatingActionButton: (value!.teamId == null ||
                        phone !=
                            _teamController
                                .onlineBusinessTeam.first.phoneNumber)
                    ? const SizedBox.shrink()
                    : FloatingActionButton.extended(
                        heroTag: "first",
                        elevation: 0,
                        onPressed: () {
                          Get.to(() => const AddMember());
                        },
                        icon: const Icon(Icons.add, size: 14),
                        backgroundColor: AppColors.backgroundColor,
                        label:
                            const Text('Add new member', style: TextStyles.t10),
                      ),
                body: Column(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: Insets.lg),
                      margin: const EdgeInsets.only(bottom: Insets.md),
                      height: 50,
                      width: context.getWidth(),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: _randomColor.randomColor(),
                            child: Text(
                              _businessController
                                  .selectedBusiness.value!.businessName![0],
                              style: TextStyles.h4.copyWith(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          const Gap(Insets.md),
                          Text(
                            _businessController
                                .selectedBusiness.value!.businessName
                                .toString(),
                            style:
                                TextStyles.t12B.copyWith(color: Colors.black),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: value.teamId == null
                          ? NoTeamWidget()
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Insets.lg),
                              child: Column(
                                children: [
                                  if (phone ==
                                      _teamController.onlineBusinessTeam.first
                                          .phoneNumber) ...[
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
                                                padding: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: TeamsWidget(
                                                  name: item.email == null
                                                      ? '$firstName $lastName'
                                                      : item.email!,
                                                  position:
                                                      item.teamMemberStatus !=
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
                                                  editAction:
                                                      item.teamMemberStatus !=
                                                              'CREATOR'
                                                          ? GestureDetector(
                                                              onTap: () {
                                                                Get.to(() =>
                                                                    UpdateMember(
                                                                        team:
                                                                            item));
                                                              },
                                                              child: SvgPicture
                                                                  .asset(
                                                                'assets/images/edit.svg',
                                                                height: 20,
                                                                width: 20,
                                                              ))
                                                          : Container(),
                                                  deleteAction:
                                                      item.teamMemberStatus !=
                                                              "CREATOR"
                                                          ? Obx(() {
                                                              return GestureDetector(
                                                                  onTap: () {
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (_) {
                                                                          return HuzzDeleteDialog(
                                                                            title:
                                                                                "Team Member",
                                                                            content:
                                                                                "team member",
                                                                            action:
                                                                                () {
                                                                              Get.back();
                                                                              _teamController.deleteTeamMemberOnline(item);
                                                                            },
                                                                          );
                                                                        });
                                                                  },
                                                                  child: _teamController
                                                                              .deleteTeamMemberStatus ==
                                                                          DeleteTeamStatus
                                                                              .Loading
                                                                      ? LoadingWidget()
                                                                      : SvgPicture
                                                                          .asset(
                                                                          'assets/images/delete.svg',
                                                                          height:
                                                                              20,
                                                                          width:
                                                                              20,
                                                                        ));
                                                            })
                                                          : Container(),
                                                ),
                                              );
                                            },
                                          );
                                        } else if (_teamController
                                                .onlineBusinessTeam.length ==
                                            0) {
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
                                            MediaQuery.of(context).size.height *
                                                .1),
                                    Image.asset('assets/images/my_teams.png'),
                                  ]
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              ),
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
