import 'package:country_picker/country_picker.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/auth_respository.dart';
import 'package:huzz/Repository/home_respository.dart';
import 'package:huzz/colors.dart';

import 'widget/custom_form_field.dart';

class Signup extends StatefulWidget {
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<Signup> {
  final _homeController = Get.find<HomeRespository>();
  final _authController = Get.find<AuthRepository>();
// ignore: unused_field
  final _formKey = GlobalKey<FormState>();
  String countryFlag = "NG";
  String countryCode = "234";

  @override
  void initState() {
    super.initState();
    _authController.countryText = countryCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              label: "First Name",
              validatorText: "First name is needed",
              textEditingController: _authController.firstNameController,
            ),
            SizedBox(
              height: 3,
            ),
            CustomTextField(
              label: "Last Name",
              validatorText: "Last name is needed",
              textEditingController: _authController.lastNameController,
            ),
            SizedBox(
              height: 3,
            ),
            CustomTextField(
              label: "Email",
              validatorText: "Email is needed",
              textEditingController: _authController.emailController,
            ),
            SizedBox(
              height: 3,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                margin: EdgeInsets.only(
                  left: 20,
                ),
                child: Text(
                  "Phone Number",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                border:
                    Border.all(color: AppColor().backgroundColor, width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      showCountryCode(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                                color: AppColor().backgroundColor, width: 2)),
                      ),
                      height: 50,
                      width: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 10),
                          Flag.fromString(countryFlag, height: 30, width: 30),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            size: 24,
                            color: AppColor().backgroundColor.withOpacity(0.5),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _authController.phoneNumberController,
                      // ${_authController.phoneNumberController.value}
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "9034678966",
                          hintStyle: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                          prefixText: "+$countryCode ",
                          prefixStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black)),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            Spacer(),
            InkWell(
              onTap: () {
                _homeController.selectOnboardSelectedNext();
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 20),
                height: 50,
                decoration: BoxDecoration(
                    color: AppColor().backgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Continue',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Icon(
                        Icons.arrow_forward,
                        color: AppColor().backgroundColor,
                        size: 16,
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Future showCountryCode(BuildContext context) async {
    showCountryPicker(
      context: context,
      showPhoneCode:
          true, // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        countryCode = country.toJson()['e164_cc'];
        countryFlag = country.toJson()['iso2_cc'];

        country.toJson();
        setState(() {});

        print('Select country: ${country.toJson()}');
      },
    );
  }
}
