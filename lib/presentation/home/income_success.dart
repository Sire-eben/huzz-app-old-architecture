import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/presentation/app_scaffold.dart';
import 'package:huzz/presentation/home/reciept.dart';
import 'package:huzz/data/model/money_reciept_model.dart';
import 'package:huzz/data/model/transaction_model.dart';

// ignore: must_be_immutable
class IncomeSuccess extends StatelessWidget {
  TransactionModel transactionModel;
  String title;
  String status;
  IncomeSuccess(
      {Key? key,
      required this.transactionModel,
      required this.title,
      required this.status})
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
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.backgroundColor,
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
              Column(
                children: [
                  Text(
                    'Your $title has',
                    style: GoogleFonts.inter(
                      color: AppColors.backgroundColor,
                      fontStyle: FontStyle.normal,
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'been added successfully',
                    style: GoogleFonts.inter(
                      color: AppColors.backgroundColor,
                      fontStyle: FontStyle.normal,
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
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
                      decoration: const BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Center(
                        child: Text(
                          'Proceed',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  status == "EXPENDITURE"
                      ? Container()
                      : InkWell(
                          onTap: () async {
                            final date = DateTime.now();
                            final dueDate = date.add(const Duration(days: 7));

                            // ignore: unused_local_variable
                            final moneyInvoice = MoneyInOutInvoice(
                              supplier: const Supplier(
                                name: 'Business Name',
                                mail: 'tunmisehassan@gmail.com',
                                phone: '+234 8123 456 789',
                              ),
                              customer: const Customer(
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
                                const InvoiceItem(
                                  item: 'MacBook',
                                  quantity: 3,
                                  amount: 500000,
                                ),
                                const InvoiceItem(
                                  item: 'MacBook',
                                  quantity: 3,
                                  amount: 500000,
                                ),
                                const InvoiceItem(
                                  item: 'MacBook',
                                  quantity: 3,
                                  amount: 500000,
                                ),
                                const InvoiceItem(
                                  item: 'MacBook',
                                  quantity: 3,
                                  amount: 500000,
                                ),
                              ],
                            );
                            Get.to(() => IncomeReceipt(
                                transaction: transactionModel,
                                pageCheck: true));
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
                                    color: AppColors.backgroundColor, width: 2),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10))),
                            child: Center(
                              child: Text(
                                'View Receipt',
                                style: GoogleFonts.inter(
                                  color: AppColors.backgroundColor,
                                  fontSize: 18,
                                ),
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
