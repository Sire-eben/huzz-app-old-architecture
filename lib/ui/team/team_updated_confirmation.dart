import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../util/colors.dart';

class TeamMemberConfirmation extends StatefulWidget {
  TeamMemberConfirmation({Key? key}) : super(key: key);

  @override
  State<TeamMemberConfirmation> createState() => _TeamMemberConfirmationState();
}

class _TeamMemberConfirmationState extends State<TeamMemberConfirmation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColor().whiteColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: AppColor().backgroundColor,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Center(
              child: Text(
                'Team Member Successfully',
                style: TextStyle(
                  color: AppColor().backgroundColor,
                  fontFamily: 'InterRegular',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Center(
              child: Text(
                'Updated',
                style: TextStyle(
                  color: AppColor().backgroundColor,
                  fontFamily: 'InterRegular',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Center(
              child: Image.asset(
                'assets/images/checker.png',
              ),
            ),
            Spacer(),
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                    color: AppColor().whiteColor,
                    border:
                        Border.all(width: 2, color: AppColor().backgroundColor),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    'Proceed',
                    style: TextStyle(
                      color: AppColor().backgroundColor,
                      fontFamily: 'InterRegular',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
