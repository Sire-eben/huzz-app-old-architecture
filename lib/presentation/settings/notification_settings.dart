import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/data/repository/auth_respository.dart';
import 'package:huzz/core/constants/app_themes.dart';

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
          style: GoogleFonts.inter(
            fontSize: 14,
          ),
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
              color: AppColors.backgroundColor,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          title: Text(
            'Notification Settings',
            style: GoogleFonts.inter(
              color: AppColors.backgroundColor,
              fontWeight: FontWeight.w600,
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
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    Switch.adaptive(
                        activeColor: AppColors.backgroundColor,
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
                              style: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: 12,
                              ),
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
                                      color: AppColors.backgroundColor)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  hint: Text(
                                    'Select Notification Interval',
                                    style: GoogleFonts.inter(
                                      fontSize: 15,
                                    ),
                                  ),
                                  value: debtorsValue,
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: AppColors.backgroundColor,
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
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    Switch.adaptive(
                        activeColor: AppColors.backgroundColor,
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
                              style: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: 12,
                              ),
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
                                      color: AppColors.backgroundColor)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  hint: Text(
                                    'Select Notification Interval',
                                    style: GoogleFonts.inter(
                                      fontSize: 15,
                                    ),
                                  ),
                                  value: debtOwnedValue,
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: AppColors.backgroundColor,
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
