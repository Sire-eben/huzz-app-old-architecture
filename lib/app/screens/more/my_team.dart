import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/team_repository.dart';
import 'package:huzz/colors.dart';
import 'add_member.dart';

class MyTeam extends StatefulWidget {
  const MyTeam({Key? key}) : super(key: key);

  @override
  State<MyTeam> createState() => _MyTeamState();
}

class _MyTeamState extends State<MyTeam> {
  final _teamController = Get.find<TeamRepository>();
  @override
  Widget build(BuildContext context) {
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
                fontFamily: 'DMSans',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppColor().whiteColor,
      floatingActionButton: FloatingActionButton.extended(
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
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: [
            Container(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColor().backgroundColor),
                        child: Center(
                          child: Text(
                            'OA',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Olatunde Joshua',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColor().blackColor,
                              fontFamily: 'DMSans',
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Owner',
                          style: TextStyle(
                              fontSize: 10,
                              color: AppColor().blackColor,
                              fontFamily: 'DMSans',
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        // _customerController
                        //     .setItem(item);
                        // Get.to(AddCustomer(
                        //   item: item,
                        // ));
                      },
                      child: SvgPicture.asset('assets/images/edit.svg')),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                      onTap: () {
                        // _displayDialog(
                        //     context, item);
                      },
                      child: SvgPicture.asset('assets/images/delete.svg')),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColor().backgroundColor),
                        child: Center(
                          child: Text(
                            'HA',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hassan Tunmise',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColor().blackColor,
                              fontFamily: 'DMSans',
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'Owner',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: AppColor().blackColor,
                                  fontFamily: 'DMSans',
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(width: 40),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(80),
                                  border: Border.all(
                                      width: 1,
                                      color: AppColor().orangeBorderColor),
                                  color: AppColor()
                                      .orangeBorderColor
                                      .withOpacity(0.2)),
                              child: Text(
                                'Pending',
                                style: TextStyle(
                                    fontSize: 6,
                                    color: AppColor().orangeBorderColor,
                                    fontFamily: 'DMSans',
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        // _customerController
                        //     .setItem(item);
                        // Get.to(AddCustomer(
                        //   item: item,
                        // ));
                      },
                      child: SvgPicture.asset('assets/images/edit.svg')),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                      onTap: () {
                        // _displayDialog(
                        //     context, item);
                      },
                      child: SvgPicture.asset('assets/images/delete.svg')),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NoTeamWidget extends StatelessWidget {
  const NoTeamWidget({
    Key? key,
  }) : super(key: key);

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
            color: Color(0xffF5F5F5),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 2, color: Colors.grey.withOpacity(0.2))),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/images/users.svg'),
              SizedBox(
                height: 10,
              ),
              Text(
                'My Team',
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontFamily: 'DMSans',
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Invite team members to help',
                style: TextStyle(
                    fontSize: 10, color: Colors.black, fontFamily: 'DMSans'),
              ),
              Text(
                'you manage your business',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.black,
                  fontFamily: 'DMSans',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Get.to(() => AddMember());
                },
                child: Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: AppColor().backgroundColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      'Add Members',
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'DMSans',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
