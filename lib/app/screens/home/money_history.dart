import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:huzz/colors.dart';
import 'package:huzz/model/records_model.dart';
import 'package:huzz/model/transaction_model.dart';

class MoneySummary extends StatefulWidget {
  @override
  _MoneySummaryState createState() => _MoneySummaryState();
}

class _MoneySummaryState extends State<MoneySummary> {
  final recordFilter = ['This month', 'Last month'];

  String? value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Transaction',
              style: TextStyle(
                color: AppColor().backgroundColor,
                fontFamily: "DMSans",
                fontStyle: FontStyle.normal,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '10, NOV. 2021',
                  style: TextStyle(
                    color: AppColor().blackColor,
                    fontFamily: "DMSans",
                    fontStyle: FontStyle.normal,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '10:00 AM',
                  style: TextStyle(
                    color: AppColor().blackColor,
                    fontFamily: "DMSans",
                    fontStyle: FontStyle.normal,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          SvgPicture.asset('assets/images/delete.svg'),
          SizedBox(
            width: MediaQuery.of(context).size.height * 0.02,
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColor().backgroundColor.withOpacity(0.2)),
              child: Text(
                'Fully Paid',
                style: TextStyle(
                  color: AppColor().blackColor,
                  fontFamily: "DMSans",
                  fontStyle: FontStyle.normal,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Text(
              'Total Amount',
              style: TextStyle(
                color: AppColor().blackColor,
                fontFamily: "DMSans",
                fontStyle: FontStyle.normal,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Text(
              'N100,000',
              style: TextStyle(
                color: AppColor().backgroundColor,
                fontFamily: "DMSans",
                fontStyle: FontStyle.normal,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.height * 0.03),
                child: Text(
                  'Items',
                  style: TextStyle(
                    color: AppColor().blackColor,
                    fontFamily: "DMSans",
                    fontStyle: FontStyle.normal,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.height * 0.03),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12)),
                    color: AppColor().backgroundColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Item',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'DMSans',
                          fontSize: 12,
                          color: AppColor().whiteColor),
                    ),
                    Text(
                      'Qty',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'DMSans',
                          fontSize: 12,
                          color: AppColor().whiteColor),
                    ),
                    Text(
                      'Amount',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'DMSans',
                          fontSize: 12,
                          color: AppColor().whiteColor),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: itemsRecordList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var item = itemsRecordList[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.height * 0.03),
                      child: Container(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.01),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.name!,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'DMSans',
                                  fontSize: 10,
                                  color: AppColor().blackColor),
                            ),
                            Text(
                              item.quantity!,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'DMSans',
                                  fontSize: 10,
                                  color: AppColor().blackColor),
                            ),
                            Text(
                              item.price!,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'DMSans',
                                  fontSize: 10,
                                  color: AppColor().blackColor),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.height * 0.03),
                child: Text(
                  'Payment History',
                  style: TextStyle(
                    color: AppColor().blackColor,
                    fontFamily: "DMSans",
                    fontStyle: FontStyle.normal,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.height * 0.03),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12)),
                    color: AppColor().backgroundColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Date',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'DMSans',
                          fontSize: 12,
                          color: AppColor().whiteColor),
                    ),
                    Text(
                      'Amount',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'DMSans',
                          fontSize: 12,
                          color: AppColor().whiteColor),
                    ),
                    Text(
                      '',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'DMSans',
                          fontSize: 12,
                          color: AppColor().whiteColor),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: paymentHistoryList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var item = paymentHistoryList[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.height * 0.03),
                      child: Container(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.01),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.date!,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'DMSans',
                                  fontSize: 10,
                                  color: AppColor().blackColor),
                            ),
                            Text(
                              item.price!,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'DMSans',
                                  fontSize: 10,
                                  color: AppColor().blackColor),
                            ),
                            Row(
                              children: [
                                Text(
                                  'View Receipt',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'DMSans',
                                      fontSize: 10,
                                      color: AppColor().backgroundColor),
                                ),
                                SizedBox(width: 4),
                                Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColor().backgroundColor),
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: AppColor().whiteColor,
                                      size: 15,
                                    ))
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRecordSummary(RecordModel recordModel) =>
      StatefulBuilder(builder: (BuildContext context, StateSetter myState) {
        return Container(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.04,
              right: MediaQuery.of(context).size.width * 0.04,
              bottom: MediaQuery.of(context).size.width * 0.04,
              top: MediaQuery.of(context).size.width * 0.02),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: 6,
                  width: 60,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '10, Nov. 2021',
                    style: TextStyle(
                      color: AppColor().blackColor,
                      fontFamily: "DMSans",
                      fontStyle: FontStyle.normal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        myState(() {
                          Get.back();
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColor().backgroundColor.withOpacity(0.2)),
                        child: Icon(
                          Icons.close,
                          size: 20,
                          color: AppColor().backgroundColor,
                        ),
                      ))
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.width * 0.02),
                child: Container(
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).size.height * 0.015),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withOpacity(0.1),
                      border: Border.all(
                          width: 2, color: Colors.grey.withOpacity(0.1))),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'DMSans',
                                  fontSize: 10,
                                  color: AppColor().blackColor),
                            ),
                            Text(
                              recordModel.date!,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'DMSans',
                                  fontSize: 10,
                                  color: AppColor().blackColor),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Money Out',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'DMSans',
                                  fontSize: 10,
                                  color: AppColor().blackColor),
                            ),
                            Text(
                              recordModel.moneyOut!,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'DMSans',
                                  fontSize: 10,
                                  color: AppColor().orangeBorderColor),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Money In',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'DMSans',
                                    fontSize: 10,
                                    color: AppColor().blackColor),
                              ),
                              Text(
                                recordModel.moneyIn!,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'DMSans',
                                    fontSize: 10,
                                    color: AppColor().blueColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Expanded(
                child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: recordSummaryList.length,
                    itemBuilder: (BuildContext context, int index) {
                      var item = recordSummaryList[index];
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.width * 0.02),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.height * 0.015),
                          child: Row(
                            children: [
                              Image.asset(item.image!),
                              SizedBox(width: 10),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'DMSans',
                                          fontSize: 10,
                                          color: AppColor().blackColor),
                                    ),
                                    Text(
                                      item.time!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'DMSans',
                                          fontSize: 10,
                                          color: AppColor().blackColor),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.price!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'DMSans',
                                          fontSize: 10,
                                          color: AppColor().blackColor),
                                    ),
                                    Text(
                                      item.detail!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'DMSans',
                                          fontSize: 10,
                                          color: AppColor().blackColor),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.visibility,
                                color: AppColor().backgroundColor,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        );
      });

  DropdownMenuItem<String> buildDropDown(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(
              fontFamily: 'DMSans', fontSize: 10, fontWeight: FontWeight.bold),
        ),
      );
}
