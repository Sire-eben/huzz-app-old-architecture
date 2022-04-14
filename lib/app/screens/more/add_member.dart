import 'package:country_picker/country_picker.dart';
import 'package:expandable/expandable.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/customer_repository.dart';
import 'package:huzz/colors.dart';
import '../widget/custom_form_field.dart';

class AddMember extends StatefulWidget {
  AddMember({Key? key}) : super(key: key);

  @override
  State<AddMember> createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  final _customerController = Get.find<CustomerRepository>();
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
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
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'InterRegular',
                              ),
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
                  _customerController.showContactPickerForTeams(context);
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

class ExpandableWidget extends StatefulWidget {
  String? name;
  double? tL, tR, bL, bR;
  ExpandableWidget({Key? key, this.name, this.tL, this.tR, this.bL, this.bR})
      : super(key: key);

  @override
  State<ExpandableWidget> createState() => _ExpandableWidgetState();
}

class _ExpandableWidgetState extends State<ExpandableWidget> {
  bool manageCustomer = false;
  bool view = false, create = false, update = false, delete = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(widget.tL!),
              topRight: Radius.circular(widget.tR!),
              bottomLeft: Radius.circular(widget.bL!),
              bottomRight: Radius.circular(widget.bR!)),
          color: AppColor().backgroundColor.withOpacity(0.1)),
      child: ExpandablePanel(
        theme: ExpandableThemeData(
          headerAlignment: ExpandablePanelHeaderAlignment.center,
          tapBodyToCollapse: true,
          hasIcon: true,
          iconColor: AppColor().backgroundColor,
        ),
        collapsed: Container(),
        expanded: Column(
          children: [
            SizedBox(
              height: 30,
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  "View",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'InterRegular',
                  ),
                ),
                value: view,
                onChanged: (newValue) {
                  setState(() {
                    view = newValue!;
                  });
                },
              ),
            ),
            SizedBox(
              height: 30,
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  "Create",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'InterRegular',
                  ),
                ),
                value: create,
                onChanged: (newValue) {
                  setState(() {
                    create = newValue!;
                  });
                },
              ),
            ),
            SizedBox(
              height: 30,
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  "Update",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'InterRegular',
                  ),
                ),
                value: update,
                onChanged: (newValue) {
                  setState(() {
                    update = newValue!;
                  });
                },
              ),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                "Delete",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'InterRegular',
                ),
              ),
              value: delete,
              onChanged: (newValue) {
                setState(() {
                  delete = newValue!;
                });
              },
            )
          ],
        ),
        header: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
              child: Checkbox(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                activeColor: AppColor().backgroundColor,
                value: manageCustomer,
                onChanged: (value) {
                  setState(() {
                    manageCustomer = value!;
                  });
                },
              ),
            ),
            SizedBox(width: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.name!,
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                        color: AppColor().backgroundColor,
                        fontFamily: "InterRegular",
                        fontStyle: FontStyle.normal,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
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
          ],
        ),
      ),
    );
  }
}
