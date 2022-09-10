import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../util/colors.dart';
import 'debtors.dart';
import 'debtowed.dart';

class DebtorsTab extends StatefulWidget {
  const DebtorsTab({Key? key}) : super(key: key);

  @override
  _DebtorsTabState createState() => _DebtorsTabState();
}

class _DebtorsTabState extends State<DebtorsTab> {
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
            'Debt Management',
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
                      text: 'Debtors',
                    ),
                    Tab(
                      text: 'Debts Owed',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Debtors(),
            DebtOwned(),
          ],
        ),
      ),
    );
  }
}
