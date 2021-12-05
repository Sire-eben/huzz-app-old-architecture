import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:huzz/app/screens/customers/merchants/merchants.dart';

import '../../../colors.dart';
import 'customer/customers.dart';

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
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(120),
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Manage $customer",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: 'DMSans',
                              fontSize: 24,
                              color: AppColor().backgroundColor),
                        ),
                        SizedBox(width: 4),
                        Tooltip(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.black38, blurRadius: 10)
                              ]),
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: 'DMSans',
                              fontSize: 10,
                              color: Colors.black),
                          preferBelow: false,
                          message:
                              'Your customers are the\npeople you sell products\nor services to',
                          child: SvgPicture.asset(
                            "assets/images/info.svg",
                            height: 20,
                            width: 20,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              width: 2.5, color: AppColor().backgroundColor)),
                      child: TabBar(
                        labelStyle:
                            Theme.of(context).textTheme.headline2!.copyWith(
                                  color: AppColor().backgroundColor,
                                  fontFamily: "DMSans",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                        unselectedLabelColor: AppColor().backgroundColor,
                        unselectedLabelStyle:
                            Theme.of(context).textTheme.headline2!.copyWith(
                                  color: AppColor().backgroundColor,
                                  fontFamily: "DMSans",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        // indicatorColor: Colors.white,
                        indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColor().backgroundColor),
                        tabs: [
                          Tab(text: 'Customers'),
                          Tab(text: 'Merchants'),
                        ],
                      ),
                    ),
                  ],
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
