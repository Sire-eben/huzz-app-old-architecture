import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/app/screens/widget/custom_form_field.dart';
import 'package:huzz/colors.dart';

import 'sign_in.dart';

class CreateBusiness extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Container(
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: AppColor().backgroundColor,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    "Create Your Business",
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColor().backgroundColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            CustomTextField(
              label: "Business Name",
              validatorText: "Business name is required",
            ),
            SizedBox(
              height: 5,
            ),
            CustomTextField(
              label: "Address (Optional)",
            ),
            SizedBox(
              height: 5,
            ),
            CustomTextField(
              label: "Phone Number",
              validatorText: "Phone Number is needed",
            ),
            SizedBox(
              height: 5,
            ),
            CustomTextField(
              label: "Email",
              validatorText: "Email is required",
            ),
            SizedBox(
              height: 5,
            ),
            CustomTextField(
              label: "Business Category",
              validatorText: "Business Category is required",
            ),
            Expanded(child: SizedBox()),
            GestureDetector(
              onTap: () {
                Get.to(Signin());
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 50, right: 50),
                height: 50,
                decoration: BoxDecoration(
                    color: AppColor().backgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Icon(
                        Icons.add,
                        color: AppColor().backgroundColor,
                        size: 16,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Continue',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
          ],
        ),
      ),
    );
  }
}
