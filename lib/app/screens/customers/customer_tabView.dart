import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:huzz/app/screens/customers/merchants/merchants.dart';
import '../../../colors.dart';
import 'customer/customers.dart';

class ManageCustomerInformationDialog extends StatelessWidget {
  const ManageCustomerInformationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.info_outline_rounded,
          size: 27,
        ),
        SizedBox(height: 7),
        Text(
          'Your customers are the people you sell products or services to.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontFamily: "InterRegular",
          ),
        ),
      ],
    );
  }
}

class CustomerTabView extends StatefulWidget {
  const CustomerTabView({Key? key}) : super(key: key);

  @override
  _CustomerTabViewState createState() => _CustomerTabViewState();
}

class _CustomerTabViewState extends State<CustomerTabView> {
  String? customer = 'Customers';
  String? merchant = 'Merchants';
  String? pageName;
  @override
  void initState() {
    setState(() {
      if (customer == this.pageName) {
        print(customer);
      } else {
        print(merchant);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Row(
              children: [
                Text(
                  'Manage $customer',
                  style: TextStyle(
                    color: AppColor().backgroundColor,
                    fontFamily: 'InterRegular',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(width: 4),
                GestureDetector(
                  onTap: () {
                    Platform.isIOS
                        ? showCupertinoDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) => CupertinoAlertDialog(
                              content: ManageCustomerInformationDialog(),
                              actions: [
                                CupertinoButton(
                                  child: Text("OK"),
                                  onPressed: () => Get.back(),
                                ),
                              ],
                            ),
                          )
                        : showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: ManageCustomerInformationDialog(),
                              actions: [
                                CupertinoButton(
                                  child: Text("OK"),
                                  onPressed: () => Get.back(),
                                ),
                              ],
                            ),
                          );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0, top: 2.0),
                    child: SvgPicture.asset(
                      "assets/images/info.svg",
                      height: 20,
                      width: 20,
                    ),
                  ),
                ),

                //Tool tip
                // Tooltip(
                //   triggerMode: TooltipTriggerMode.tap,
                //   padding: EdgeInsets.all(6),
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(10),
                //       color: Colors.white,
                //       boxShadow: [
                //         BoxShadow(color: Colors.black38, blurRadius: 10)
                //       ]),
                //   textStyle: TextStyle(
                //       fontWeight: FontWeight.w500,
                //       fontFamily: 'InterRegular',
                //       fontSize: 10,
                //       color: Colors.black),
                //   preferBelow: false,
                //   message:
                //       'Your customers are the\npeople you sell products\nor services to',
                //   child: SvgPicture.asset(
                //     "assets/images/info.svg",
                //     height: 20,
                //     width: 20,
                //   ),
                // ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(55),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          width: 2, color: AppColor().backgroundColor)),
                  child: TabBar(
                    labelStyle: Theme.of(context).textTheme.headline2!.copyWith(
                          color: AppColor().backgroundColor,
                          fontFamily: "InterRegular",
                          fontStyle: FontStyle.normal,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                    unselectedLabelColor: AppColor().backgroundColor,
                    unselectedLabelStyle:
                        Theme.of(context).textTheme.headline2!.copyWith(
                              color: AppColor().backgroundColor,
                              fontFamily: "InterRegular",
                              fontStyle: FontStyle.normal,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    // indicatorColor: Colors.white,
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.5),
                        color: AppColor().backgroundColor),
                    tabs: [
                      Tab(text: 'Customers'),
                      Tab(text: 'Merchants'),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: TabBarView(children: <Widget>[
            Customers(
              pageName: 'Customers',
            ),
            Merchants(
              pageName: 'Merchants',
            )
          ])),
    );
  }
}
