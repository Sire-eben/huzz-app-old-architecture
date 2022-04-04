import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:huzz/app/screens/customers/merchants/merchants.dart';
import '../../../colors.dart';
import 'customer/customers.dart';

class ManageCustomerInformationDialog extends StatelessWidget {
  final int tabIndex;
  ManageCustomerInformationDialog(this.tabIndex);

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
        if (tabIndex == 0)
          Text(
            'Your customers are the people you sell products or services to.',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          )
        else
          Text(
            'Your merchants are the people you buy products or services from.',
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
  @override
  _CustomerTabViewState createState() => _CustomerTabViewState();
}

class _CustomerTabViewState extends State<CustomerTabView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          children: [
            Text(
              'Manage ${_tabController.index == 0 ? 'Customers' : 'Merchants'}',
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
                          content: ManageCustomerInformationDialog(
                              _tabController.index),
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
                          content: ManageCustomerInformationDialog(
                              _tabController.index),
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
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(55),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(width: 2, color: AppColor().backgroundColor)),
              child: TabBar(
                controller: _tabController,

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
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Customers(
            pageName: 'Customers',
          ),
          Merchants(
            pageName: 'Merchants',
          )
        ],
      ),
    );
  }
}
