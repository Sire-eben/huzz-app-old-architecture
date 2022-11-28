import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/data/repository/transaction_respository.dart';
import 'package:huzz/util/colors.dart';
import 'package:huzz/data/model/records_model.dart';
import 'package:huzz/data/model/transaction_model.dart';

class TransactionHistory extends StatefulWidget {
  final RecordSummary? recordSummary;

  const TransactionHistory({Key? key, this.recordSummary}) : super(key: key);

  @override
  _TransactionHistoryState createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  final _transactionController = Get.find<TransactionRespository>();
  final recordFilter = ['This month', 'Last month'];

  TransactionModel? transactionModel;
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
              style: GoogleFonts.inter(
                color: AppColor().backgroundColor,
                
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
                  style: GoogleFonts.inter(
                    color: AppColor().blackColor,
                    
                    fontStyle: FontStyle.normal,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '10:00 AM',
                  style: GoogleFonts.inter(
                    color: AppColor().blackColor,
                    
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
          GestureDetector(
              onTap: () {
                _displayDialog(context);
              },
              child: SvgPicture.asset('assets/images/delete.svg')),
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
                widget.recordSummary!.detail!,
                style: GoogleFonts.inter(
                  color: AppColor().blackColor,
                  
                  fontStyle: FontStyle.normal,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Text(
              'Total Amount',
              style: GoogleFonts.inter(
                color: AppColor().blackColor,
                
                fontStyle: FontStyle.normal,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Text(
              widget.recordSummary!.price!,
              style: GoogleFonts.inter(
                color: AppColor().backgroundColor,
                
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
                  style: GoogleFonts.inter(
                    color: AppColor().blackColor,
                    
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
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          
                          fontSize: 12,
                          color: AppColor().whiteColor),
                    ),
                    Text(
                      'Qty',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          
                          fontSize: 12,
                          color: AppColor().whiteColor),
                    ),
                    Text(
                      'Amount',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          
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
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  
                                  fontSize: 10,
                                  color: AppColor().blackColor),
                            ),
                            Text(
                              item.quantity!,
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  
                                  fontSize: 10,
                                  color: AppColor().blackColor),
                            ),
                            Text(
                              item.price!,
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  
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
                  style: GoogleFonts.inter(
                    color: AppColor().blackColor,
                    
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
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          
                          fontSize: 12,
                          color: AppColor().whiteColor),
                    ),
                    Text(
                      'Amount',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          
                          fontSize: 12,
                          color: AppColor().whiteColor),
                    ),
                    Text(
                      '',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          
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
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  
                                  fontSize: 10,
                                  color: AppColor().blackColor),
                            ),
                            Text(
                              item.price!,
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  
                                  fontSize: 10,
                                  color: AppColor().blackColor),
                            ),
                            Row(
                              children: [
                                Text(
                                  'View Receipt',
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold,
                                      
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

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(
              horizontal: 50,
              vertical: 300,
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    'You are about to delete you want to delete this transaction. Are you sure you want to continue?',
                    style: GoogleFonts.inter(
                      color: AppColor().blackColor,
                      
                      fontWeight: FontWeight.normal,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            content: Center(
              child: SvgPicture.asset(
                'assets/images/delete_alert.svg',
                fit: BoxFit.fitHeight,
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          height: 45,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                              color: AppColor().whiteColor,
                              border: Border.all(
                                width: 2,
                                color: AppColor().backgroundColor,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.inter(
                                color: AppColor().backgroundColor,
                                
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _transactionController
                              .deleteTransaction(transactionModel!);
                          Get.back();
                        },
                        child: Container(
                          height: 45,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                              color: AppColor().backgroundColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              'Delete',
                              style: GoogleFonts.inter(
                                color: AppColor().whiteColor,
                                
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
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
                    style: GoogleFonts.inter(
                      color: AppColor().blackColor,
                      
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
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  
                                  fontSize: 10,
                                  color: AppColor().blackColor),
                            ),
                            Text(
                              recordModel.date!,
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  
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
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  
                                  fontSize: 10,
                                  color: AppColor().blackColor),
                            ),
                            Text(
                              recordModel.moneyOut!,
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  
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
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    
                                    fontSize: 10,
                                    color: AppColor().blackColor),
                              ),
                              Text(
                                recordModel.moneyIn!,
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    
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
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.bold,
                                          
                                          fontSize: 10,
                                          color: AppColor().blackColor),
                                    ),
                                    Text(
                                      item.time!,
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.bold,
                                          
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
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.bold,
                                          
                                          fontSize: 10,
                                          color: AppColor().blackColor),
                                    ),
                                    Text(
                                      item.detail!,
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.bold,
                                          
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
          style: GoogleFonts.inter(
              
              fontSize: 10,
              fontWeight: FontWeight.bold),
        ),
      );
}
