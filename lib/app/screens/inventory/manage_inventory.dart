import 'package:flutter/material.dart';
import 'package:huzz/app/screens/inventory/products.dart';
import 'package:huzz/app/screens/inventory/services.dart';
import '../../../colors.dart';

class ManageInventory extends StatefulWidget {
  const ManageInventory({Key? key}) : super(key: key);

  @override
  _ManageInventoryState createState() => _ManageInventoryState();
}

class _ManageInventoryState extends State<ManageInventory> {
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
              preferredSize: Size.fromHeight(90),
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Manage Inventory",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                          color: AppColor().backgroundColor),
                    ),
                    SizedBox(height: 20),
                    TabBar(
                      labelColor: AppColor().backgroundColor,
                      unselectedLabelColor: Colors.black,
                      labelStyle:
                          Theme.of(context).textTheme.headline2!.copyWith(
                                color: Colors.black,
                                fontFamily: "SofiaPro",
                                fontStyle: FontStyle.normal,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                      unselectedLabelStyle:
                          Theme.of(context).textTheme.headline2!.copyWith(
                                color: AppColor().backgroundColor,
                                fontFamily: "SofiaPro",
                                fontStyle: FontStyle.normal,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: AppColor().backgroundColor,
                      tabs: [
                        Tab(text: 'Products'),
                        Tab(text: 'Services'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(children: <Widget>[Products(), Services()])),
    );
  }
}
