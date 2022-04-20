import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:huzz/colors.dart';
import '../more/add_member.dart';

class NoTeamWidget extends StatelessWidget {
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
                    fontFamily: 'InterRegular',
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Invite team members to help',
                style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                    fontFamily: 'InterRegular'),
              ),
              Text(
                'you manage your business',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.black,
                  fontFamily: 'InterRegular',
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
                        fontFamily: 'InterRegular',
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
