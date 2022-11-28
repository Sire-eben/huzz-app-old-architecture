import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../util/colors.dart';
import 'Product/productlist.dart';
import 'Service/servicelist.dart';

class ProductServiceListing extends StatefulWidget {
  const ProductServiceListing({Key? key}) : super(key: key);

  @override
  _ProductServiceListingState createState() => _ProductServiceListingState();
}

class _ProductServiceListingState extends State<ProductServiceListing> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Manage Inventory',
              style: GoogleFonts.inter(
                color: AppColor().backgroundColor,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
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
                        fontWeight: FontWeight.w600,
                      ),
                  unselectedLabelStyle:
                      Theme.of(context).textTheme.headline2!.copyWith(
                            color: AppColor().backgroundColor,
                            fontFamily: "InterRegular",
                            fontStyle: FontStyle.normal,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                  indicator: BoxDecoration(
                    color: AppColor().backgroundColor,
                    border: Border.all(
                      width: 3,
                      color: AppColor().backgroundColor,
                    ),
                    borderRadius: BorderRadius.circular(10),
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
            ProductListing(),
            ServiceListing(),
          ],
        ),
      ),
    );
  }
}
