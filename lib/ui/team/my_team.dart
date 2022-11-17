import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:huzz/data/model/team.dart';
import 'package:huzz/data/repository/auth_respository.dart';
import 'package:huzz/data/repository/business_respository.dart';
import 'package:huzz/data/repository/team_repository.dart';
import 'package:huzz/ui/team/update_member.dart';
import 'package:huzz/ui/widget/no_team_widget.dart';
import 'package:huzz/ui/widget/team_widget.dart';
import 'package:huzz/util/colors.dart';
import 'package:intl/intl.dart';
import 'add_member.dart';

class NoAccessDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.info_outline_rounded,
          size: 27,
        ),
        SizedBox(height: 7),
        Text(
          "You are not authorized to perform this action",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontFamily: "InterRegular",
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
    print(phone);

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
        print(
            'Team member length: ${_teamController.onlineBusinessTeam.length}');
      }
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppColor().backgroundColor,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          title: Row(
            children: [
              Text(
                'My Team',
                style: TextStyle(
                  color: AppColor().backgroundColor,
                  fontFamily: 'InterRegular',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: AppColor().whiteColor,
        floatingActionButton: (value!.teamId == null ||
                phone != _teamController.onlineBusinessTeam.first.phoneNumber)
            ? Container()
            : FloatingActionButton.extended(
                onPressed: () {
                  Get.to(() => AddMember());
                },
                icon: Icon(Icons.add),
                backgroundColor: AppColor().backgroundColor,
                label: Text(
                  'Add new member',
                  style: TextStyle(
                      fontFamily: 'InterRegular',
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
        body: RefreshIndicator(
          onRefresh: () async {
            return Future.delayed(Duration(seconds: 1), () {
              _businessController.OnlineBusiness();
            });
          },
          child: value.teamId == null
              ? NoTeamWidget()
              : Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
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
                                  child: CircularProgressIndicator(
                                    color: AppColor().backgroundColor,
                                  ),
                                );
                              } else if (_teamController.teamStatus ==
                                  TeamStatus.Available) {
                                // if(phone.length ==11){}
                                return ListView.builder(
                                  itemCount:
                                      _teamController.onlineBusinessTeam.length,
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
                                        position:
                                            item.teamMemberStatus != "CREATOR"
                                                ? "Member"
                                                : 'Admin',
                                        status:
                                            item.teamMemberStatus == "CREATOR"
                                                ? Container()
                                                : (item.teamMemberStatus !=
                                                            "CREATOR" &&
                                                        item.teamMemberStatus ==
                                                            "INVITE_LINK_SENT")
                                                    ? StatusWidget(
                                                        color: AppColor()
                                                            .backgroundColor,
                                                        text: "Pending",
                                                      )
                                                    : StatusWidget(
                                                        color: AppColor()
                                                            .orangeBorderColor,
                                                        text: "Invited",
                                                      ),
                                        editAction: item.teamMemberStatus !=
                                                'CREATOR'
                                            ? GestureDetector(
                                                onTap: () {
                                                  Get.to(() =>
                                                      UpdateMember(team: item));
                                                },
                                                child: SvgPicture.asset(
                                                  'assets/images/edit.svg',
                                                  height: 20,
                                                  width: 20,
                                                ))
                                            : Container(),
                                        deleteAction:
                                            item.teamMemberStatus != "CREATOR"
                                                ? Obx(() {
                                                    return GestureDetector(
                                                        onTap: () {
                                                          print(
                                                              'deleting team member: ${item.toJson()}');
                                                          _deleteTeamMemberDialog(
                                                              context, item);
                                                        },
                                                        child: _teamController
                                                                    .deleteTeamMemberStatus ==
                                                                DeleteTeamStatus
                                                                    .Loading
                                                            ? CupertinoActivityIndicator(
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
                              style: TextStyle(
                                color: AppColor().blackColor,
                                fontFamily: 'InterRegular',
                                fontWeight: FontWeight.bold,
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
                          SizedBox(
                              height: MediaQuery.of(context).size.height * .1),
                          Image.asset('assets/images/my_teams.png'),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2,
                          )
                        ]
                      ],
                    ),
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
            insetPadding: EdgeInsets.symmetric(
              horizontal: 50,
            ),
            title: Text(
              'Delete Team Member',
              style: TextStyle(
                color: AppColor().backgroundColor,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            content: Text(
              "You're about to delete this team member, click delete to proceed",
              style: TextStyle(
                color: AppColor().blackColor,
                fontFamily: 'InterRegular',
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
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
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                              color: AppColor().whiteColor,
                              border: Border.all(
                                width: 1.2,
                                color: AppColor().backgroundColor,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: AppColor().backgroundColor,
                                fontFamily: 'InterRegular',
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.back();
                          _teamController.deleteTeamMemberOnline(item);
                        },
                        child: Container(
                          height: 45,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                              color: AppColor().orangeBorderColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                color: AppColor().whiteColor,
                                fontFamily: 'InterRegular',
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
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1, color: color!),
          color: color!.withOpacity(0.2)),
      child: Text(
        text!,
        style: TextStyle(
            fontSize: 7,
            color: color!,
            fontFamily: 'InterRegular',
            fontWeight: FontWeight.w400),
      ),
    );
  }
}
