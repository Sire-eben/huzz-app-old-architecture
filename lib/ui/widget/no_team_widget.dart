import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:huzz/data/repository/business_respository.dart';
import 'package:huzz/data/repository/team_repository.dart';
import 'package:huzz/util/colors.dart';

class NoTeamWidget extends GetView<TeamRepository> {
  final _businessController = Get.find<BusinessRespository>();
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
              Obx(() {
                return InkWell(
                  onTap: () {
                    final value = _businessController.selectedBusiness.value;
                    print(value!.businessName!);
                    controller.createTeam(value.businessId!);
                  },
                  child: Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: AppColor().backgroundColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: (controller.addingTeamMemberStatus ==
                            AddingTeamStatus.Loading)
                        ? Container(
                            width: 30,
                            height: 30,
                            child: Center(
                                child: CircularProgressIndicator(
                                    color: Colors.white)),
                          )
                        : Center(
                            child: Text(
                              'Create Team',
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'InterRegular',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
