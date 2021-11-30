import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:huzz/app/screens/home/receipt/pdf_receipt.dart';
import 'package:huzz/app/screens/home/reciept.dart';
import 'package:huzz/model/reciept_model.dart';
import '../../../colors.dart';

class IncomeSuccess extends StatelessWidget {
  const IncomeSuccess({Key? key}) : super(key: key);

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
                      'Your income has been',
                      style: TextStyle(
                        color: AppColor().backgroundColor,
                        fontFamily: "DMSans",
                        fontStyle: FontStyle.normal,
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'added successfully',
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
                      Get.to(() => IncomeReceipt());
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

                      final invoice = Invoice(
                        supplier: Supplier(
                          name: 'Sarah Field',
                          mail: 'tunmisehassan@gmail.com',
                          phone: '+234 8123 456 789',
                        ),
                        customer: Customer(
                          name: 'Apple Inc.',
                          address: 'Apple Street, Cupertino, CA 95014',
                        ),
                        info: InvoiceInfo(
                          date: date,
                          dueDate: dueDate,
                          description: 'My description...',
                          number: '${DateTime.now().year}-9999',
                        ),
                        items: [
                          InvoiceItem(
                            item: 'Coffee',
                            quantity: 3,
                            amount: 5.99,
                          ),
                          InvoiceItem(
                            item: 'Water',
                            quantity: 8,
                            amount: 0.99,
                          ),
                          InvoiceItem(
                            item: 'Orange',
                            quantity: 3,
                            amount: 2.99,
                          ),
                          InvoiceItem(
                            item: 'Apple',
                            quantity: 8,
                            amount: 3.99,
                          ),
                        ],
                      );
                      final invoiceReceipt =
                          await PdfInvoiceApi.generate(invoice);

                      PdfApi.openFile(invoiceReceipt);
                      // Get.to(() => IncomeSuccess());
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
