import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/team_repository.dart';
import 'package:huzz/app/screens/widget/expandable_widget.dart';
import 'package:huzz/colors.dart';
import '../widget/custom_form_field.dart';

class AddMember extends StatefulWidget {
  AddMember({Key? key}) : super(key: key);

  @override
  State<AddMember> createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  final _teamController = Get.find<TeamRepository>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController updatePhoneNumberController =
      TextEditingController();
  String countryFlag = "NG";
  String countryCode = "234";

  final items = [
    'Owner',
    'Writer',
    'Admin',
  ];

  String? value;
  bool manageCustomer = false;
  bool view = false, create = false, update = false, delete = false;

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
              'Add Members',
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            CustomTextFieldWithImage(
              contactName: _teamController.nameController,
              contactPhone: _teamController.phoneNumberController,
              contactMail: _teamController.emailController,
              label: "Member name",
              validatorText: "Member name is needed",
              hint: 'member name',
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'Privilege',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'InterRegular',
                    ),
                  ),
                  SizedBox(width: 5),
                  SvgPicture.asset(
                    "assets/images/info.svg",
                    height: 15,
                    width: 15,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            ExpandableWidget(
              name: 'MANAGE CUSTOMERS',
              tL: 10,
              tR: 10,
              bL: 0,
              bR: 0,
            ),
            ExpandableWidget(
              name: 'MANAGE INVENTORY',
              tL: 0,
              tR: 0,
              bL: 0,
              bR: 0,
            ),
            ExpandableWidget(
              name: 'MANAGE BUSINESS TRANSACTION',
              tL: 0,
              tR: 0,
              bL: 0,
              bR: 0,
            ),
            ExpandableWidget(
              name: 'MANAGE BANK INFO',
              tL: 0,
              tR: 0,
              bL: 0,
              bR: 0,
            ),
            ExpandableWidget(
              name: 'MANAGE TEAM',
              tL: 0,
              tR: 0,
              bL: 0,
              bR: 0,
            ),
            ExpandableWidget(
              name: 'MANAGE REMINDER',
              tL: 0,
              tR: 0,
              bL: 0,
              bR: 0,
            ),
            ExpandableWidget(
              name: 'MANAGE BUSINESS INVOICE',
              tL: 0,
              tR: 0,
              bL: 10,
              bR: 10,
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                _teamController.showContactPickerForTeams(context);
              },
              child: Container(
                height: 55,
                margin: EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: AppColor().backgroundColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    'Invite Member',
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
            SizedBox(height: 20),
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

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(fontSize: 14),
        ),
      );
}
