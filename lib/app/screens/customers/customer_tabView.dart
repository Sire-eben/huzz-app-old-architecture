import 'package:flutter/material.dart';
import 'package:huzz/app/screens/customers/customers.dart';
import 'package:huzz/app/screens/customers/merchants.dart';
import '../../../colors.dart';

class CustomerTabView extends StatefulWidget {
  const CustomerTabView({Key? key}) : super(key: key);

  @override
  _CustomerTabViewState createState() => _CustomerTabViewState();
}

class _CustomerTabViewState extends State<CustomerTabView> {
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
                    Text(
                      "Manage Customers",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                          color: AppColor().backgroundColor),
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
          body: TabBarView(children: <Widget>[Customers(), Merchants()])),
    );
  }
}
