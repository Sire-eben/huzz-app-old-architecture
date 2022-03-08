import 'package:flutter/material.dart';
import 'package:huzz/app/screens/inventory/Service/services.dart';

import '../../../colors.dart';
import 'Product/products.dart';

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
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Manage Inventory',
            style: TextStyle(
              color: AppColor().backgroundColor,
              fontFamily: 'InterRegular',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(55),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: AppColor().backgroundColor,
                  ),
                  color: AppColor().whiteColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TabBar(
                  labelColor: AppColor().whiteColor,
                  unselectedLabelColor: AppColor().backgroundColor,
                  labelStyle: Theme.of(context).textTheme.headline2!.copyWith(
                        color: AppColor().backgroundColor,
                        fontFamily: "InterRegular",
                        fontStyle: FontStyle.normal,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                  unselectedLabelStyle:
                      Theme.of(context).textTheme.headline2!.copyWith(
                            color: AppColor().backgroundColor,
                            fontFamily: "InterRegular",
                            fontStyle: FontStyle.normal,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                  indicator: BoxDecoration(
                    color: AppColor().backgroundColor,
                    border: Border.all(
                      width: 3,
                      color: AppColor().backgroundColor,
                    ),
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                  tabs: [
                    Tab(
                      text: 'Products',
                    ),
                    Tab(
                      text: 'Services',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Products(),
            Services(),
          ],
        ),
      ),
    );
  }
}
