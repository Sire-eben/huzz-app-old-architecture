import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/auth_respository.dart';
import 'package:huzz/app/screens/settings/businessInfo.dart';
import 'package:huzz/colors.dart';

import 'notification.dart';
import 'personalInfo.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final controller = Get.find<AuthRepository>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        title: Text(
          'Settings',
          style: TextStyle(
            color: AppColor().backgroundColor,
            fontFamily: 'DMSans',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 20,
            left: 100,
            right: 100,
            child: Center(
              child: Image.asset(
                "assets/images/profileImg.png",
                // height: 100,
                // width: 100,
              ),
            ),
          ),
          Positioned(
            top: 70,
            left: 200,
            right: 150,
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: AppColor().whiteColor,
                border: Border.all(
                  width: 2,
                  color: AppColor().backgroundColor,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  "assets/images/addcamera.svg",
                  height: 15,
                  width: 15,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        controller.user!.firstName == null
                            ? 'First Name'
                            : controller.user!.firstName!,
                        style: TextStyle(
                          color: AppColor().blackColor,
                          fontFamily: 'DMSans',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: Text(
                        controller.user!.lastName == null
                            ? 'Last Name'
                            : controller.user!.lastName!,
                        style: TextStyle(
                          color: AppColor().blackColor,
                          fontFamily: 'DMSans',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 60,
                ),
                // Personal Account
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  height: 55,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(0xffE6F4F2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: AppColor().whiteColor,
                          border: Border.all(
                            width: 2,
                            color: AppColor().whiteColor,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            "assets/images/user.svg",
                            height: 20,
                            width: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Personal Account',
                        style: TextStyle(
                          color: AppColor().blackColor,
                          fontFamily: 'DMSans',
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Get.to(PersonalInfo());
                          // controller.;
                        },
                        child: SvgPicture.asset(
                          "assets/images/setting.svg",
                          height: 20,
                          width: 20,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          _displayDialog(
                              context,
                              "are you sure want to delete your account",
                              () {});
                        },
                        child: SvgPicture.asset(
                          "assets/images/delete.svg",
                          height: 20,
                          width: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // Business Account
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  height: 55,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(0xffE6F4F2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: AppColor().whiteColor,
                          border: Border.all(
                            width: 2,
                            color: AppColor().whiteColor,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            "assets/images/business.svg",
                            height: 15,
                            width: 15,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Business Account',
                        style: TextStyle(
                          color: AppColor().blackColor,
                          fontFamily: 'DMSans',
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Get.to(BusinessInfo());
                        },
                        child: SvgPicture.asset(
                          "assets/images/setting.svg",
                          height: 20,
                          width: 20,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          _displayBusinessDialog(
                            context,
                            'You are about to delete your Huzz account and all associated data. This is an irreversible action. Are you sure you want to continue?',
                            () {},
                          );
                        },
                        child: SvgPicture.asset(
                          "assets/images/delete.svg",
                          height: 20,
                          width: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // Notification
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  height: 55,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(0xffE6F4F2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: AppColor().whiteColor,
                          border: Border.all(
                            width: 2,
                            color: AppColor().whiteColor,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            "assets/images/bell.svg",
                            height: 20,
                            width: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Notification Settings',
                        style: TextStyle(
                          color: AppColor().blackColor,
                          fontFamily: 'DMSans',
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Get.to(Notifications());
                        },
                        child: SvgPicture.asset(
                          "assets/images/setting.svg",
                          height: 20,
                          width: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // LogOut
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  height: 55,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(0xffE6F4F2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: InkWell(
                    onTap: () {
                      _displayDialog(
                          context, "Are you sure you want to log out", () {
                        controller.logout();
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(
                          "assets/images/logout.svg",
                          height: 30,
                          width: 30,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Logout',
                          style: TextStyle(
                            color: AppColor().blackColor,
                            fontFamily: 'DMSans',
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _displayDialog(
      BuildContext context, String title, VoidCallback onContinue) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(
              horizontal: 55,
              vertical: 250,
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    '$title',
                    style: TextStyle(
                      color: AppColor().blackColor,
                      fontFamily: 'DMSans',
                      fontWeight: FontWeight.normal,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            content: Column(
              children: [
                SizedBox(
                  height: 8,
                ),
                SvgPicture.asset(
                  'assets/images/polygon.svg',
                ),
              ],
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
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 45,
                        width: 100,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                            color: AppColor().whiteColor,
                            border: Border.all(
                              width: 2,
                              color: AppColor().backgroundColor,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: AppColor().backgroundColor,
                              fontFamily: 'DMSans',
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        onContinue();
                      },
                      child: Container(
                        height: 45,
                        width: 100,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                            color: AppColor().backgroundColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            'Continue',
                            style: TextStyle(
                              color: AppColor().whiteColor,
                              fontFamily: 'DMSans',
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
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

  _displayBusinessDialog(
      BuildContext context, String title, VoidCallback onContinue) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(
              horizontal: 55,
              vertical: 225,
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    '$title',
                    style: TextStyle(
                      color: AppColor().blackColor,
                      fontFamily: 'DMSans',
                      fontWeight: FontWeight.normal,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            content: Column(
              children: [
                SvgPicture.asset(
                  'assets/images/polygon.svg',
                ),
              ],
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
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 45,
                        width: 100,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                            color: AppColor().whiteColor,
                            border: Border.all(
                              width: 2,
                              color: AppColor().backgroundColor,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: AppColor().backgroundColor,
                              fontFamily: 'DMSans',
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        onContinue();
                      },
                      child: Container(
                        height: 45,
                        width: 100,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                            color: AppColor().backgroundColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            'Continue',
                            style: TextStyle(
                              color: AppColor().whiteColor,
                              fontFamily: 'DMSans',
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
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
