import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:huzz/app/screens/dashboard.dart';
import 'package:huzz/app/screens/home/receipt/money_in_out_pdf.dart';
import 'package:huzz/app/screens/home/reciept.dart';
import 'package:huzz/model/money_reciept_model.dart';
import 'package:huzz/model/transaction_model.dart';
import '../../../colors.dart';

class IncomeSuccess extends StatelessWidget {
  TransactionModel transactionModel;
  String title;
  IncomeSuccess({Key? key, required this.transactionModel, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  children: [
                    Text(
                      'Your $title has',
                      style: TextStyle(
                        color: AppColor().backgroundColor,
                        fontFamily: "DMSans",
                        fontStyle: FontStyle.normal,
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'been added successfully',
                      style: TextStyle(
                        color: AppColor().backgroundColor,
                        fontFamily: "DMSans",
                        fontStyle: FontStyle.normal,
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SvgPicture.asset('assets/images/income_added.svg'),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Column(
                children: [
                  InkWell(
                    onTap: () async {
                      Get.offAll(() => Dashboard());
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.height * 0.03),
                      height: 50,
                      decoration: BoxDecoration(
                          color: AppColor().backgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Center(
                        child: Text(
                          'Proceed',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'DMSans'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  InkWell(
                    onTap: () async {
                      final date = DateTime.now();
                      final dueDate = date.add(Duration(days: 7));

                      final moneyInvoice = MoneyInOutInvoice(
                        supplier: Supplier(
                          name: 'Business Name',
                          mail: 'tunmisehassan@gmail.com',
                          phone: '+234 8123 456 789',
                        ),
                        customer: Customer(
                          name: 'Joshua Olatunde',
                          phone: '+234 903 872 6495',
                        ),
                        info: InvoiceInfo(
                          date: date,
                          dueDate: dueDate,
                          description: 'My description...',
                          number: '${DateTime.now().year}-9999',
                        ),
                        items: [
                          InvoiceItem(
                            item: 'MacBook',
                            quantity: 3,
                            amount: 500000,
                          ),
                          InvoiceItem(
                            item: 'MacBook',
                            quantity: 3,
                            amount: 500000,
                          ),
                          InvoiceItem(
                            item: 'MacBook',
                            quantity: 3,
                            amount: 500000,
                          ),
                          InvoiceItem(
                            item: 'MacBook',
                            quantity: 3,
                            amount: 500000,
                          ),
                        ],
                      );
                      final moneyInOutReceipt =
                          await PdfMoneyInOutApi.generate(transactionModel);
                      Get.to(() => IncomeReceipt(file: moneyInOutReceipt));
                      // PdfApi.openFile(invoiceReceipt);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.height * 0.03),
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColor().backgroundColor, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Center(
                        child: Text(
                          'View Receipt',
                          style: TextStyle(
                              color: AppColor().backgroundColor,
                              fontSize: 18,
                              fontFamily: 'DMSans'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
