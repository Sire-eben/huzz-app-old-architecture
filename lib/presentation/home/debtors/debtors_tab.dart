import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:huzz/core/constants/app_themes.dart';
import 'debtors.dart';
import 'debt_owed.dart';

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
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.backgroundColor,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          title: Text(
            'Debt Management',
            style: GoogleFonts.inter(
              color: AppColors.backgroundColor,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(55),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: AppColors.backgroundColor,
                  ),
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TabBar(
                  labelColor: AppColors.whiteColor,
                  unselectedLabelColor: AppColors.backgroundColor,
                  labelStyle: Theme.of(context).textTheme.headline2!.copyWith(
                        color: AppColors.backgroundColor,
                        fontFamily: "InterRegular",
                        fontStyle: FontStyle.normal,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                  unselectedLabelStyle:
                      Theme.of(context).textTheme.headline2!.copyWith(
                            color: AppColors.backgroundColor,
                            fontFamily: "InterRegular",
                            fontStyle: FontStyle.normal,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                  indicator: BoxDecoration(
                    color: AppColors.backgroundColor,
                    border: Border.all(
                      width: 3,
                      color: AppColors.backgroundColor,
                    ),
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                  tabs: const [
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
