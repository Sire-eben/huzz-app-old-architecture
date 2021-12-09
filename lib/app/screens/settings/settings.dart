import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/auth_respository.dart';
import 'package:huzz/app/screens/settings/businessInfo.dart';
import 'package:huzz/colors.dart';

import 'notification.dart';
import 'personalInfo.dart';

class Settings extends GetView<AuthRepository> {
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
            top: 100,
            left: 100,
            right: 100,
            child: Center(
              child: Image.asset(
                "assets/images/profileImg.png",
              ),
            ),
          ),
          Positioned(
            top: 150,
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
              child: Image.asset(
                "assets/images/addcamera.png",
                scale: 0.9,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'First Name',
                        style: TextStyle(
                          color: AppColor().blackColor,
                          fontFamily: 'DMSans',
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Last Name',
                        style: TextStyle(
                          color: AppColor().blackColor,
                          fontFamily: 'DMSans',
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
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
                        child: Image.asset(
                          "assets/images/user.png",
                          scale: 0.9,
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
                        },
                        child: Container(
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
                          child: Image.asset(
                            "assets/images/settings.png",
                            scale: 0.9,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          _displayDialog(context);
                        },
                        child: Container(
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
                          child: Image.asset(
                            "assets/images/delete.png",
                            scale: 0.9,
                          ),
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
                        child: Image.asset(
                          "assets/images/user.png",
                          scale: 0.9,
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
                        child: Container(
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
                          child: Image.asset(
                            "assets/images/settings.png",
                            scale: 0.9,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          _displayDialog(context);
                        },
                        child: Container(
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
                          child: Image.asset(
                            "assets/images/delete.png",
                            scale: 0.9,
                          ),
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
                        child: Image.asset(
                          "assets/images/bell.png",
                          scale: 0.9,
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
                          Get.to(NotificationSettings());
                        },
                        child: Container(
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
                          child: Image.asset(
                            "assets/images/settings.png",
                            scale: 0.9,
                          ),
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
                            "assets/images/money_in.svg",
                            color: AppColor().backgroundColor,
                            height: 20,
                            width: 20,
                          ),
                        ),
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
                      GestureDetector(
                        onTap: () {
                          controller.logout();
                        },
                        child: Container(
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
                              "assets/images/money_out.svg",
                              color: AppColor().orangeBorderColor,
                              height: 20,
                              width: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(
              horizontal: 50,
              vertical: 200,
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    'You are about to delete your Huzz account and all associated data. This is an irreversible action. Are you sure you want to continue?',
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
                  height: 30,
                ),
                Image.asset(
                  'assets/images/Polygon 3.png',
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
                      onTap: () {},
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
