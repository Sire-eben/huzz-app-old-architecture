import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:huzz/data/repository/auth_respository.dart';
import 'package:huzz/data/repository/business_respository.dart';
import 'package:huzz/data/repository/team_repository.dart';
import 'package:huzz/ui/team/update_member.dart';
import 'package:huzz/ui/widget/no_team_widget.dart';
import 'package:huzz/ui/widget/team_widget.dart';
import 'package:huzz/util/colors.dart';
import 'package:share_plus/share_plus.dart';
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
  bool isLoadingTeamInviteLink = false;

  final items = [
    'Owner',
    'Writer',
    'Admin',
  ];

  String? values, teamInviteLink;
  late String firstName, lastName;

  @override
  void initState() {
    firstName = controller.user!.firstName!;
    lastName = controller.user!.lastName!;

    controller.checkTeamInvite();
    super.initState();
    final value = _businessController.selectedBusiness.value!.businessId;
    print('BusinessId: $value');
    final teamId = _businessController.selectedBusiness.value!.teamId;
    print('Business TeamId: $teamId');
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final value = _businessController.selectedBusiness.value;
      if (kDebugMode) {
        print(
            'Team member length: ${_teamController.onlineBusinessTeam.length}');
      }
      return RefreshIndicator(
        onRefresh: () async {
          return Future.delayed(Duration(seconds: 1), () {
            _teamController.getOnlineTeam(value!.teamId);
          });
        },
        child: Scaffold(
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
          floatingActionButton: value!.teamId == null
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
          body: value.teamId == null
              ? NoTeamWidget()
              : Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    children: [
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
                            return ListView.builder(
                              itemCount:
                                  _teamController.onlineBusinessTeam.length,
                              itemBuilder: (context, index) {
                                var item =
                                    _teamController.onlineBusinessTeam[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: TeamsWidget(
                                    name: item.email == null
                                        ? '$firstName $lastName'
                                        : item.email!,
                                    position: item.teamMemberStatus != "CREATOR"
                                        ? "Member"
                                        : 'Admin',
                                    status: item.teamMemberStatus == "CREATOR"
                                        ? Container()
                                        : (item.teamMemberStatus != "CREATOR" &&
                                                item.teamMemberStatus ==
                                                    "INVITE_LINK_SENT")
                                            ? StatusWidget(
                                                color:
                                                    AppColor().backgroundColor,
                                                text: "Pending",
                                              )
                                            : StatusWidget(
                                                color: AppColor()
                                                    .orangeBorderColor,
                                                text: "Invited",
                                              ),
                                    editAction:
                                        item.teamMemberStatus != 'CREATOR'
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
                                    deleteAction: item.teamMemberStatus !=
                                            "CREATOR"
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
                                                        DeleteTeamStatus.Loading
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
                          } else {
                            return Container();
                          }
                        }),
                      ),
                    ],
                  ),
                ),
        ),
      );
    });
  }

  Widget buildEditTeam() =>
      StatefulBuilder(builder: (BuildContext context, StateSetter myState) {
        return Container(
          margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.04,
            right: MediaQuery.of(context).size.width * 0.04,
          ),
          padding: MediaQuery.of(context).viewInsets,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 6,
                    width: 80,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Edit Team',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "InterRegular",
                    fontStyle: FontStyle.normal,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 40),
              Text(
                'Select Item',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'InterRegular'),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        width: 2, color: AppColor().backgroundColor)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: values,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColor().backgroundColor,
                    ),
                    iconSize: 30,
                    items: items.map(buildEditItem).toList(),
                    onChanged: (value) => myState(() {
                      values = value;
                      print(value);
                    }),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              InkWell(
                onTap: () async {
                  print('Editing team member details');
                  Get.back();
                  // if (_transactionController.addingTransactionStatus !=
                  //     AddingTransactionStatus.Loading) {
                  //   print('Amount to be updated: ' +
                  //       _transactionController.amountController!.text
                  //           .replaceAll('₦', ''));

                  //   var result =
                  //       await _transactionController.updateTransactionHistory(
                  //           transactionModel!.id!,
                  //           transactionModel!.businessId!,
                  //           (paymentType == 0)
                  //               ? _transactionController
                  //                   .amountController!.text
                  //                   .replaceAll('₦', '')
                  //                   .replaceAll(',', '')
                  //               : (transactionModel!.balance ?? 0),
                  //           (paymentType == 0) ? "DEPOSIT" : "FULLY_PAID");

                  //   if (result != null) {
                  //     print("result is not null");
                  //     transactionModel = result;
                  //     setState(() {});
                  //   } else {
                  //     print("result is null");
                  //   }
                  //   transactionModel =
                  //       _transactionController.getTransactionById(
                  //           widget.item!.businessTransactionId!);
                  //   setState(() {});
                  // }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.height * 0.01),
                  height: 50,
                  decoration: BoxDecoration(
                      color: AppColor().backgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child:
                      // (_team.addingTransactionStatus ==
                      //         AddingTransactionStatus.Loading)
                      //     ? Container(
                      //         width: 30,
                      //         height: 30,
                      //         child: Center(
                      //             child: CircularProgressIndicator(
                      //                 color: Colors.white)),
                      //       )
                      //     :
                      Center(
                    child: Text(
                      'Save',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'InterRegular'),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        );
      });

  DropdownMenuItem<String> buildEditItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(fontSize: 14),
        ),
      );

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
