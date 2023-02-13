import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/util/constants.dart';
import 'package:huzz/data/repository/customer_repository.dart';
import 'package:huzz/data/repository/transaction_respository.dart';
import 'package:huzz/ui/home/reciept.dart';
import 'package:huzz/ui/widget/custom_form_field.dart';
import 'package:huzz/data/model/customer_model.dart';
import 'package:huzz/data/model/payment_item.dart';
import 'package:huzz/data/model/records_model.dart';
import 'package:huzz/data/model/transaction_model.dart';
import 'package:huzz/core/util/util.dart';
import 'package:number_display/number_display.dart';
import '../../data/repository/team_repository.dart';

class TransactionHistoryInformationDialog extends StatelessWidget {
  const TransactionHistoryInformationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.info_outline_rounded,
          size: 27,
        ),
        const SizedBox(height: 7),
        Text(
          "This is where you can get more information about a money in or money out transaction.",
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class MoneySummary extends StatefulWidget {
  PaymentItem? item;
  bool? pageCheck;
  MoneySummary({super.key, this.item, this.pageCheck});
  @override
  _MoneySummaryState createState() => _MoneySummaryState();
}

class _MoneySummaryState extends State<MoneySummary> {
  final recordFilter = ['This month', 'Last month'];
  final _transactionController = Get.find<TransactionRespository>();
  final _customerController = Get.find<CustomerRepository>();
  final teamController = Get.find<TeamRepository>();
  String? value;
  int paymentType = 0;
  int paymentMode = 0;
  TransactionModel? transactionModel;
  Customer? customer;
  final display = createDisplay(
    length: 10,
    decimal: 0,
  );
  final _amountController = TextEditingController();
  @override
  void initState() {
    // _customerController
    //     .checkifCustomerAvailableWithValue(transactionModel!.customerId!);
    super.initState();
    // print("my customerId: " + transactionModel!.customerId!.toString());
    // if (transactionModel!.customerId != null) {
    //   print("my customer id ${transactionModel!.customerId}");
    //   customer = _customerController
    //       .checkifCustomerAvailableWithValue(transactionModel!.customerId!);
    // }

    transactionModel = _transactionController
        .getTransactionById(widget.item!.businessTransactionId!);
    if (transactionModel != null) {
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
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.backgroundColor,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Transaction',
                  style: GoogleFonts.inter(
                    color: AppColors.backgroundColor,
                    fontStyle: FontStyle.normal,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () {
                    Platform.isIOS
                        ? showCupertinoDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) => CupertinoAlertDialog(
                              content: TransactionHistoryInformationDialog(),
                              actions: [
                                CupertinoButton(
                                  child: const Text("OK",
                                    style: TextStyle(color: AppColors.primaryColor),),
                                  onPressed: () => Get.back(),
                                ),
                              ],
                            ),
                          )
                        : showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: TransactionHistoryInformationDialog(),
                              actions: [
                                CupertinoButton(
                                  child: const Text("OK",
                                    style: TextStyle(color: AppColors.primaryColor),),
                                  onPressed: () => Get.back(),
                                ),
                              ],
                            ),
                          );
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(left: 4.0, top: 2.0),
                    child: Icon(
                      Icons.info_outline_rounded,
                      size: 18,
                      color: AppColors.backgroundColor,
                    ),
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transactionModel!.entryDateTime!
                      .formatDate(pattern: "dd, MMM y")!,
                  style: GoogleFonts.inter(
                    color: AppColors.blackColor,
                    fontStyle: FontStyle.normal,
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  transactionModel!.entryDateTime!
                      .formatDate(pattern: "hh:mm a")!,
                  style: GoogleFonts.inter(
                    color: AppColors.blackColor,
                    fontStyle: FontStyle.normal,
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          (teamController.teamMember.teamMemberStatus == 'CREATOR' ||
                  teamController.teamMember.authoritySet!
                      .contains('DELETE_BUSINESS_TRANSACTION'))
              ? GestureDetector(
                  onTap: () {
                    if (teamController.teamMember.teamMemberStatus ==
                            'CREATOR' ||
                        teamController.teamMember.authoritySet!
                            .contains('DELETE_BUSINESS_TRANSACTION')) {
                      _displayDialog(context);
                    } else {
                      Get.snackbar('Alert',
                          'You need to be authorized to perform this operation');
                    }
                  },
                  child: SvgPicture.asset('assets/images/delete.svg'))
              : Container(),
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.orangeBorderColor.withOpacity(0.2)),
              child: Text(
                transactionModel!.balance == 0 ? 'Fully Paid' : "Partially",
                style: GoogleFonts.inter(
                  color: AppColors.orangeBorderColor,
                  fontStyle: FontStyle.normal,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
                height: (transactionModel!.balance == 0)
                    ? 0
                    : MediaQuery.of(context).size.height * 0.01),
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
                              style: GoogleFonts.inter(
                                color: AppColors.blackColor,
                                fontStyle: FontStyle.normal,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                            Text(
                              '${Utils.getCurrency()}${display(transactionModel!.totalAmount!)}',
                              style: GoogleFonts.inter(
                                color: AppColors.backgroundColor,
                                fontStyle: FontStyle.normal,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Bal.',
                                style: GoogleFonts.inter(
                                  color: AppColors.blackColor,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.01),
                              Text(
                                '${Utils.getCurrency()}${display(transactionModel!.balance!)}',
                                style: GoogleFonts.inter(
                                  color: AppColors.orangeBorderColor,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ]),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Paid Amt.',
                              style: GoogleFonts.inter(
                                color: AppColors.blackColor,
                                fontStyle: FontStyle.normal,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                            Text(
                              '${Utils.getCurrency()}${display(transactionModel!.totalAmount! - transactionModel!.balance!)}',
                              style: GoogleFonts.inter(
                                color: AppColors.backgroundColor,
                                fontStyle: FontStyle.normal,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                : Container(),
            SizedBox(
                height: (transactionModel!.balance == 0)
                    ? 0
                    : MediaQuery.of(context).size.height * 0.01),
            (transactionModel!.balance != 0)
                ? (teamController.teamMember.teamMemberStatus == 'CREATOR' ||
                        teamController.teamMember.authoritySet!
                            .contains('UPDATE_BUSINESS_TRANSACTION'))
                    ? GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20))),
                              context: context,
                              builder: (context) => buildSaveInvoice());
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color:
                                  AppColors.backgroundColor.withOpacity(0.2)),
                          child: Center(
                            child: Text(
                              'Update payment',
                              style: GoogleFonts.inter(
                                color: AppColors.blackColor,
                                fontStyle: FontStyle.normal,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container()
                : Container(),
            (transactionModel!.customerId != null)
                ? Obx(() {
                    if (transactionModel!.customerId != null) {
                      print("my customer id ${transactionModel!.customerId}");
                      customer =
                          _customerController.checkifCustomerAvailableWithValue(
                              transactionModel!.customerId!);
                    }
                    return Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.height * 0.05,
                          vertical: MediaQuery.of(context).size.height * 0.02),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Customer`s Name',
                                style: GoogleFonts.inter(
                                  color: AppColors.backgroundColor,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                customer!.name!,
                                style: GoogleFonts.inter(
                                  color: AppColors.blackColor,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Phone Number',
                                style: GoogleFonts.inter(
                                  color: AppColors.backgroundColor,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                customer!.phone!,
                                style: GoogleFonts.inter(
                                  color: AppColors.blackColor,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height: (customer!.email == null ||
                                      customer!.email == '')
                                  ? 0
                                  : 5),
                          (customer!.email == null || customer!.email == '')
                              ? Container()
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Email',
                                      style: GoogleFonts.inter(
                                        color: AppColors.backgroundColor,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      customer!.email!,
                                      style: GoogleFonts.inter(
                                        color: AppColors.blackColor,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                          SizedBox(
                              height: (transactionModel!
                                              .businessTransactionFileStoreId ==
                                          null ||
                                      transactionModel!
                                          .businessTransactionFileStoreId!
                                          .isEmpty)
                                  ? 0
                                  : 5),
                          (customer!.email == null || customer!.email == '')
                              ? Container()
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Transaction Image',
                                      style: GoogleFonts.inter(
                                        color: AppColors.backgroundColor,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 12,
                                      ),
                                    ),
                                    (transactionModel!
                                                    .businessTransactionFileStoreId ==
                                                null ||
                                            transactionModel!
                                                .businessTransactionFileStoreId!
                                                .isEmpty)
                                        ? Image.asset(
                                            "assets/images/Rectangle 1015.png",
                                            height: 50,
                                          )
                                        : Image.network(
                                            transactionModel!
                                                .businessTransactionFileStoreId!,
                                            height: 50,
                                          ),
                                  ],
                                )
                        ],
                      ),
                    );
                  })
                : Container(),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.height * 0.03),
                child: Text(
                  'Items',
                  style: GoogleFonts.inter(
                    color: AppColors.blackColor,
                    fontStyle: FontStyle.normal,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.height * 0.03),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12)),
                    color: AppColors.backgroundColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Item',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: AppColors.whiteColor),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Qty',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: AppColors.whiteColor),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Amount',
                        textAlign: TextAlign.right,
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: AppColors.whiteColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
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
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                    color: AppColors.blackColor),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${item.quality}",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                    color: AppColors.blackColor),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${Utils.getCurrency()}${display(item.totalAmount)}",
                                textAlign: TextAlign.right,
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                    color: AppColors.blackColor),
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
                  style: GoogleFonts.inter(
                    color: AppColors.blackColor,
                    fontStyle: FontStyle.normal,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.height * 0.03),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12)),
                    color: AppColors.backgroundColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Date',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: AppColors.whiteColor),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Amount',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: AppColors.whiteColor),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '',
                        textAlign: TextAlign.right,
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: AppColors.whiteColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
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
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                    color: AppColors.blackColor),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${Utils.getCurrency()}${display(item.amountPaid)}',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                    color: AppColors.blackColor),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  print(
                                      "Payment Mode: ${transactionModel!.paymentMethod}");
                                  Get.to(() => IncomeReceipt(
                                        transaction: transactionModel!,
                                        pageCheck: widget.pageCheck,
                                      ));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'View Receipt',
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10,
                                          color: AppColors.backgroundColor),
                                    ),
                                    const SizedBox(width: 4),
                                    Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.backgroundColor),
                                        child: const Icon(
                                          Icons.arrow_forward,
                                          color: AppColors.whiteColor,
                                          size: 15,
                                        ))
                                  ],
                                ),
                              ),
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
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 50,
              vertical: 300,
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    'You are about to delete this transaction. Are you sure you want to continue?',
                    style: GoogleFonts.inter(
                      color: AppColors.blackColor,
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
                padding: const EdgeInsets.symmetric(
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              border: Border.all(
                                width: 2,
                                color: AppColors.backgroundColor,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.inter(
                                color: AppColors.backgroundColor,
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                              color: AppColors.backgroundColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              'Delete',
                              style: GoogleFonts.inter(
                                color: AppColors.whiteColor,
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
                      color: AppColors.blackColor,
                      fontStyle: FontStyle.normal,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        myState(() {
                          Get.back();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.backgroundColor.withOpacity(0.2)),
                        child: const Icon(
                          Icons.close,
                          size: 20,
                          color: AppColors.backgroundColor,
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
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                  color: AppColors.blackColor),
                            ),
                            Text(
                              recordModel.date!,
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                  color: AppColors.blackColor),
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
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                  color: AppColors.blackColor),
                            ),
                            Text(
                              recordModel.moneyOut!,
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                  color: AppColors.orangeBorderColor),
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
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                    color: AppColors.blackColor),
                              ),
                              Text(
                                recordModel.moneyIn!,
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                    color: AppColors.blueColor),
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
                    separatorBuilder: (context, index) => const Divider(),
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
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name!,
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10,
                                          color: AppColors.blackColor),
                                    ),
                                    Text(
                                      item.time!,
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10,
                                          color: AppColors.blackColor),
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
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10,
                                          color: AppColors.blackColor),
                                    ),
                                    Text(
                                      item.detail!,
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10,
                                          color: AppColors.blackColor),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.visibility,
                                color: AppColors.backgroundColor,
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
          style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600),
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
          // padding: EdgeInsets.only(
          //     left: MediaQuery.of(context).size.width * 0.04,
          //     right: MediaQuery.of(context).size.width * 0.04,
          //     bottom: MediaQuery.of(context).size.width * 0.04,
          //     top: MediaQuery.of(context).size.width * 0.02),
          margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.04,
            right: MediaQuery.of(context).size.width * 0.04,
          ),
          padding: MediaQuery.of(context).viewInsets,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 10,
              ),
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
                          color: AppColors.backgroundColor.withOpacity(0.2)),
                      child: const Icon(
                        Icons.close,
                        color: AppColors.backgroundColor,
                        size: 18,
                      )),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Update Payment',
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontStyle: FontStyle.normal,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              (teamController.teamMember.teamMemberStatus == 'CREATOR' ||
                      teamController.teamMember.authoritySet!
                          .contains('UPDATE_BUSINESS_TRANSACTION'))
                  ? Row(
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
                                activeColor: AppColors.backgroundColor,
                                groupValue: paymentType,
                                onChanged: (value) {
                                  myState(() {
                                    paymentType = 1;
                                  });
                                },
                              ),
                              Text(
                                'Paying Fully',
                                style: GoogleFonts.inter(
                                  color: AppColors.backgroundColor,
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
                                  activeColor: AppColors.backgroundColor,
                                  groupValue: paymentType,
                                  onChanged: (value) {
                                    myState(() {
                                      value = 0;
                                      paymentType = 0;
                                    });
                                  }),
                              Text(
                                'Paying Partly',
                                style: GoogleFonts.inter(
                                  color: AppColors.backgroundColor,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  : Container(),
              paymentType == 0
                  ? CustomTextFieldInvoiceOptional(
                      label: 'Amount',
                      hint: '${Utils.getCurrency()} 0.00',
                      inputformater: [FilteringTextInputFormatter.digitsOnly],
                      keyType: Platform.isIOS
                          ? const TextInputType.numberWithOptions(
                              signed: true, decimal: true)
                          : TextInputType.number,
                      textEditingController:
                          _transactionController.amountController,
                    )
                  : Container(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Obx(() {
                return InkWell(
                  onTap: () async {
                    if (_transactionController.addingTransactionStatus !=
                        AddingTransactionStatus.Loading) {
                      print('Amount to be updated: ' +
                          _transactionController.amountController!.text
                              .replaceAll('₦', ''));

                      var result =
                          await _transactionController.updateTransactionHistory(
                              transactionModel!.id!,
                              transactionModel!.businessId!,
                              (paymentType == 0)
                                  ? _transactionController
                                      .amountController!.text
                                      .replaceAll('₦', '')
                                      .replaceAll(',', '')
                                  : (transactionModel!.balance ?? 0),
                              (paymentType == 0) ? "DEPOSIT" : "FULLY_PAID");

                      if (result != null) {
                        print("result is not null");
                        transactionModel = result;
                        setState(() {});
                      } else {
                        print("result is null");
                      }
                      transactionModel =
                          _transactionController.getTransactionById(
                              widget.item!.businessTransactionId!);
                      setState(() {});
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.height * 0.01),
                    height: 50,
                    decoration: const BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: (_transactionController.addingTransactionStatus ==
                            AddingTransactionStatus.Loading)
                        ? Container(
                            width: 30,
                            height: 30,
                            child: const Center(
                                child: CircularProgressIndicator(
                                    color: Colors.white)),
                          )
                        : Center(
                            child: Text(
                              'Save',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                  ),
                );
              }),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        );
      });
}
