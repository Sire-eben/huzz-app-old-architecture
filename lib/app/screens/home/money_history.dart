import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/transaction_respository.dart';
import 'package:huzz/app/Utils/constants.dart';
import 'package:huzz/app/screens/widget/custom_form_field.dart';
import 'package:huzz/colors.dart';
import 'package:huzz/model/payment_item.dart';
import 'package:huzz/model/records_model.dart';
import 'package:huzz/model/transaction_model.dart';
import 'package:number_display/number_display.dart';

class MoneySummary extends StatefulWidget {
  PaymentItem? item;
  MoneySummary({this.item});
  @override
  _MoneySummaryState createState() => _MoneySummaryState();
}

class _MoneySummaryState extends State<MoneySummary> {
  final recordFilter = ['This month', 'Last month'];
  final _transactionController = Get.find<TransactionRespository>();
  String? value;
  int paymentType = 0;
  int paymentMode = 0;
  TransactionModel? transactionModel;
  final display = createDisplay(
    length: 10,
    decimal: 0,
  );
  final _amountController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    transactionModel=_transactionController.getTransactionById(widget.item!.businessTransactionId!);
    if(transactionModel!=null){
print("transaction result ${transactionModel!.toJson()}");
      print("transaction is not null");
    } else {
      print("transaction is null");
    }
  }

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
                  transactionModel!.createdTime!
                      .formatDate(pattern: "dd, MMM y")!,
                  style: TextStyle(
                    color: AppColor().blackColor,
                    fontFamily: "DMSans",
                    fontStyle: FontStyle.normal,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  transactionModel!.createdTime!
                      .formatDate(pattern: "hh:mm a")!,
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
          GestureDetector(
              onTap: () {
                _transactionController.deleteTransaction(transactionModel!);
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
                  color: AppColor().orangeBorderColor.withOpacity(0.2)),
              child: Text(
                transactionModel!.balance == 0 ? 'Fully Paid' : "Partially",
                style: TextStyle(
                  color: AppColor().orangeBorderColor,
                  fontFamily: "DMSans",
                  fontStyle: FontStyle.normal,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            (transactionModel!.balance != 0)
                ? Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.height * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Total Amt.',
                              style: TextStyle(
                                color: AppColor().blackColor,
                                fontFamily: "DMSans",
                                fontStyle: FontStyle.normal,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                            Text(
                              'N${display(transactionModel!.totalAmount!)}',
                              style: TextStyle(
                                color: AppColor().backgroundColor,
                                fontFamily: "DMSans",
                                fontStyle: FontStyle.normal,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Bal.',
                                style: TextStyle(
                                  color: AppColor().blackColor,
                                  fontFamily: "DMSans",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.01),
                              Text(
                                'N${display(transactionModel!.balance!)}',
                                style: TextStyle(
                                  color: AppColor().orangeBorderColor,
                                  fontFamily: "DMSans",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ]),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Paid Amt.',
                              style: TextStyle(
                                color: AppColor().blackColor,
                                fontFamily: "DMSans",
                                fontStyle: FontStyle.normal,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                            Text(
                              'N${display(transactionModel!.totalAmount! - transactionModel!.balance!)}',
                              style: TextStyle(
                                color: AppColor().backgroundColor,
                                fontFamily: "DMSans",
                                fontStyle: FontStyle.normal,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                : Container(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),

            (transactionModel!.balance != 0)
                ? GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20))),
                          context: context,
                          builder: (context) => buildSaveInvoice());
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppColor().backgroundColor.withOpacity(0.2)),
                      child: Center(
                        child: Text(
                          'Update payment',
                          style: TextStyle(
                            color: AppColor().blackColor,
                            fontFamily: "DMSans",
                            fontStyle: FontStyle.normal,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
//           (transactionModel!.balance==0) ?  Text(
//               'N ${display(transactionModel!.totalAmount??0)}',
//               style: TextStyle(
//                 color: AppColor().backgroundColor,
//                 fontFamily: "DMSans",
//                 fontStyle: FontStyle.normal,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ):Container(),
//           (transactionModel!.balance!=0) ?   Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
// Column(
//   children: [
//     Text(
// 'Total Amount',
//               style: TextStyle(
//                 color: AppColor().blackColor,
//                 fontFamily: "DMSans",
//                 fontStyle: FontStyle.normal,
//                 fontSize: 10,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//             Container(
//               width: MediaQuery.of(context).size.width * 0.8,
//               padding: EdgeInsets.symmetric(vertical: 12),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16),
//                   color: AppColor().backgroundColor.withOpacity(0.2)),
//               child: Center(
//                 child: Text(
//                   'Update payment',
//                   style: TextStyle(
//                     color: AppColor().blackColor,
//                     fontFamily: "DMSans",
//                     fontStyle: FontStyle.normal,
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),]),
//             Column(
//   children: [
//     Text(
// 'Bal',
//               style: TextStyle(
//                 color: AppColor().blackColor,
//                 fontFamily: "DMSans",
//                 fontStyle: FontStyle.normal,
//                 fontSize: 10,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),]),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
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
                    Expanded(
                      child: Text(
                        'Item',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'DMSans',
                            fontSize: 12,
                            color: AppColor().whiteColor),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Qty',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'DMSans',
                            fontSize: 12,
                            color: AppColor().whiteColor),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Amount',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'DMSans',
                            fontSize: 12,
                            color: AppColor().whiteColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: transactionModel!
                      .businessTransactionPaymentItemList!.length,
                  itemBuilder: (BuildContext context, int index) {
                    var item = transactionModel!
                        .businessTransactionPaymentItemList![index];
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
                            Expanded(
                              child: Text(
                                item.itemName!,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'DMSans',
                                    fontSize: 10,
                                    color: AppColor().blackColor),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${item.quality}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'DMSans',
                                    fontSize: 10,
                                    color: AppColor().blackColor),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "'N ${display(item.totalAmount)}",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'DMSans',
                                    fontSize: 10,
                                    color: AppColor().blackColor),
                              ),
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
                    Expanded(
                      child: Text(
                        'Date',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'DMSans',
                            fontSize: 12,
                            color: AppColor().whiteColor),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Amount',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'DMSans',
                            fontSize: 12,
                            color: AppColor().whiteColor),
                      ),
                    ),
                    Text(
                      '',
                      textAlign: TextAlign.right,
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
                  itemCount: transactionModel!
                      .businessTransactionPaymentHistoryList!.length,
                  itemBuilder: (BuildContext context, int index) {
                    var item = transactionModel!
                        .businessTransactionPaymentHistoryList![index];
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
                            Expanded(
                              child: Text(
                                item.createdDateTime!.formatDate()!,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'DMSans',
                                    fontSize: 10,
                                    color: AppColor().blackColor),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'N ${display(item.amountPaid)}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'DMSans',
                                    fontSize: 10,
                                    color: AppColor().blackColor),
                              ),
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

  Widget buildSaveInvoice() =>
      StatefulBuilder(builder: (BuildContext context, StateSetter myState) {
        // Future pickImgFromGallery() async {
        //   try {
        //     final image =
        //         await ImagePicker().pickImage(source: ImageSource.gallery);
        //     if (image == null) return;
        //     final imageTemporary = File(image.path);
        //     print(imageTemporary);
        //     myState(
        //       () {
        //         this.image = imageTemporary;
        //       },
        //     );
        //   } on PlatformException catch (e) {
        //     print('$e');
        //   }
        // }

        // Future pickImgFromCamera() async {
        //   try {
        //     final image =
        //         await ImagePicker().pickImage(source: ImageSource.camera);
        //     if (image == null) return;
        //     final imageTemporary = File(image.path);
        //     print(imageTemporary);
        //     myState(
        //       () {
        //         this.image = imageTemporary;
        //       },
        //     );
        //   } on PlatformException catch (e) {
        //     print('$e');
        //   }
        // }

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
                  width: 80,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.01),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor().backgroundColor.withOpacity(0.2)),
                      child: Icon(
                        Icons.close,
                        color: AppColor().backgroundColor,
                        size: 18,
                      )),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Update Payment',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "DMSans",
                    fontStyle: FontStyle.normal,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      myState(() {
                        paymentType = 1;
                      });
                    },
                    child: Row(
                      children: [
                        Radio<int>(
                          value: 1,
                          activeColor: AppColor().backgroundColor,
                          groupValue: paymentType,
                          onChanged: (value) {
                            myState(() {
                              paymentType = 1;
                            });
                          },
                        ),
                        Text(
                          'Paying Fully',
                          style: TextStyle(
                            color: AppColor().backgroundColor,
                            fontFamily: "DMSans",
                            fontStyle: FontStyle.normal,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      myState(() {
                        paymentType = 0;
                      });
                    },
                    child: Row(
                      children: [
                        Radio<int>(
                            value: 0,
                            activeColor: AppColor().backgroundColor,
                            groupValue: paymentType,
                            onChanged: (value) {
                              myState(() {
                                value = 0;
                                paymentType = 0;
                              });
                            }),
                        Text(
                          'Paying Partly',
                          style: TextStyle(
                            color: AppColor().backgroundColor,
                            fontFamily: "DMSans",
                            fontStyle: FontStyle.normal,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              paymentType == 0
                  ? CustomTextFieldInvoiceOptional(
                      label: 'Amount',
                      hint: 'N',
                      keyType: TextInputType.phone,
                      textEditingController: _amountController,
                    )
                  : Container(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     InkWell(
              //       onTap: () => myState(() => paymentMode = 0),
              //       child: Row(
              //         children: [
              //           Radio<int>(
              //               value: 0,
              //               activeColor: AppColor().backgroundColor,
              //               groupValue: paymentMode,
              //               onChanged: (value) =>
              //                   myState(() => paymentMode = 0)),
              //           Text(
              //             'Cash',
              //             style: TextStyle(
              //               color: AppColor().backgroundColor,
              //               fontFamily: "DMSans",
              //               fontStyle: FontStyle.normal,
              //               fontSize: 12,
              //               fontWeight: FontWeight.w400,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //     InkWell(
              //       onTap: () => myState(() => paymentMode = 1),
              //       child: Row(
              //         children: [
              //           Radio<int>(
              //               value: 1,
              //               activeColor: AppColor().backgroundColor,
              //               groupValue: paymentMode,
              //               onChanged: (value) =>
              //                   myState(() => paymentMode = 1)),
              //           Text(
              //             'POS',
              //             style: TextStyle(
              //               color: AppColor().backgroundColor,
              //               fontFamily: "DMSans",
              //               fontStyle: FontStyle.normal,
              //               fontSize: 12,
              //               fontWeight: FontWeight.w400,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //     InkWell(
              //       onTap: () => myState(() => paymentMode = 2),
              //       child: Row(
              //         children: [
              //           Radio<int>(
              //               value: 2,
              //               activeColor: AppColor().backgroundColor,
              //               groupValue: paymentMode,
              //               onChanged: (value) =>
              //                   myState(() => paymentMode = 2)),
              //           Text(
              //             'Transfer',
              //             style: TextStyle(
              //               color: AppColor().backgroundColor,
              //               fontFamily: "DMSans",
              //               fontStyle: FontStyle.normal,
              //               fontSize: 12,
              //               fontWeight: FontWeight.w400,
              //             ),
              //           ),
              //         ],
              //       ),
              //     )
              //   ],
              // ),
              Obx(()
              {
                  return InkWell(
                    onTap: () async{
                      
if(_transactionController.addingTransactionStatus !=
                            AddingTransactionStatus.Loading){

var result=await _transactionController.updateTransactionHistory(transactionModel!.id!, transactionModel!.businessId!, (paymentType==0)?int.parse(_amountController.text):(transactionModel!.balance??0), (paymentType==0)?"DEPOSIT":"FULLY_PAID");

if(result!=null){
print("result is not null");
  transactionModel=result;
  setState(() {
    
  });
}else{

  print("result is null");
}
  transactionModel=_transactionController.getTransactionById(widget.item!.businessTransactionId!);
  setState(() {
    
  });
                            }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.height * 0.01),
                      height: 50,
                      decoration: BoxDecoration(
                          color: AppColor().backgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: (_transactionController.addingTransactionStatus ==
                            AddingTransactionStatus.Loading)
                        ? Container(
                            width: 30,
                            height: 30,
                            child: Center(
                                child: CircularProgressIndicator(
                                    color: Colors.white)),
                          )
                        : Center(
                            child: Text(
                              'Save',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'DMSans'),
                            ),
                          ),
                  ),
                );
              }),
            ],
          ),
        );
      });
}
