import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/auth_respository.dart';
import 'package:huzz/colors.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({Key? key}) : super(key: key);

  @override
  _NotificationSettingsState createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  String? debtorsValue, debtOwnedValue;
  bool debtorRemind = false;
  bool debtOwnedRemind = false;
  final debtors = ['Daily', 'Weekly', 'Monthly'];
  final debtOwned = ['Daily', 'Weekly', 'Monthly'];
  final controller = Get.find<AuthRepository>();

  DropdownMenuItem<String> buildIntervalItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(fontSize: 14, fontFamily: 'DMSans'),
        ),
      );

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
            'Notification Settings',
            style: TextStyle(
              color: AppColor().backgroundColor,
              fontFamily: 'DMSans',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.height * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Remind me about debtors',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontFamily: 'DMSans'),
                    ),
                    Switch.adaptive(
                        activeColor: AppColor().backgroundColor,
                        value: debtorRemind,
                        onChanged: (newValue) =>
                            setState(() => this.debtorRemind = newValue))
                  ],
                ),
              ),
              debtorRemind == true
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.height * 0.03),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Interval',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'DMSans'),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 4),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      width: 2,
                                      color: AppColor().backgroundColor)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  hint: Text(
                                    'Select Notification Interval',
                                    style: TextStyle(
                                        fontSize: 15, fontFamily: 'DMSans'),
                                  ),
                                  value: debtorsValue,
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: AppColor().backgroundColor,
                                  ),
                                  iconSize: 30,
                                  items:
                                      debtors.map(buildIntervalItem).toList(),
                                  onChanged: (value) =>
                                      setState(() => this.debtorsValue = value),
                                ),
                              ),
                            ),
                          ]),
                    )
                  : Container(),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.height * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Remind me about debt Owed',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontFamily: 'DMSans'),
                    ),
                    Switch.adaptive(
                        activeColor: AppColor().backgroundColor,
                        value: debtOwnedRemind,
                        onChanged: (newValue) =>
                            setState(() => this.debtOwnedRemind = newValue))
                  ],
                ),
              ),
              debtOwnedRemind == true
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.height * 0.03),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Interval',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'DMSans'),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 4),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      width: 2,
                                      color: AppColor().backgroundColor)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  hint: Text(
                                    'Select Notification Interval',
                                    style: TextStyle(
                                        fontSize: 15, fontFamily: 'DMSans'),
                                  ),
                                  value: debtOwnedValue,
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: AppColor().backgroundColor,
                                  ),
                                  iconSize: 30,
                                  items:
                                      debtOwned.map(buildIntervalItem).toList(),
                                  onChanged: (value) => setState(
                                      () => this.debtOwnedValue = value),
                                ),
                              ),
                            ),
                          ]),
                    )
                  : Container(),
            ],
          ),
        ));
  }
}
