import 'package:country_picker/country_picker.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/colors.dart';

import '../widget/custom_form_field.dart';

class AddMember extends StatefulWidget {
  AddMember({Key? key}) : super(key: key);

  @override
  State<AddMember> createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
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
                fontFamily: 'DMSans',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            CustomTextField(
              label: "Email (Optional)",
              hint: 'youremail@gmail.com',
              colors: AppColor().blackColor,
              keyType: TextInputType.emailAddress,
              textEditingController: emailController,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Phone Number',
                            style: TextStyle(color: Colors.black, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: AppColor().backgroundColor, width: 2.0),
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
                                      color: AppColor().backgroundColor,
                                      width: 2)),
                            ),
                            height: 50,
                            width: 80,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 10),
                                Flag.fromString(countryFlag,
                                    height: 30, width: 30),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  size: 24,
                                  color: AppColor()
                                      .backgroundColor
                                      .withOpacity(0.5),
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
                            enabled: false,
                            controller: updatePhoneNumberController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '+234 903 872 6495',
                              hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                              prefixText: "+$countryCode ",
                              prefixStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  'Privilege',
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 2,
                  color: AppColor().backgroundColor,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: value,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    size: 14,
                    color: AppColor().backgroundColor,
                  ),
                  hint: Text(
                    'Privilege',
                    style: TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                  isDense: true,
                  items: items.map(buildMenuItem).toList(),
                  onChanged: (value) {
                    setState(() => this.value = value);
                  },
                  onTap: () {},
                ),
              ),
            ),
            Expanded(
              child: SizedBox(),
            ),
            InkWell(
              onTap: () {
                Get.to(AddMember());
              },
              child: Container(
                height: 55,
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
                      fontFamily: 'DMSans',
                      color: Colors.white,
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
