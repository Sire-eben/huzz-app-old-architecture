import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:huzz/app/screens/invoice/create_invoice.dart';
import 'package:huzz/colors.dart';

class EmptyInvoice extends StatefulWidget {
  const EmptyInvoice({Key? key}) : super(key: key);

  @override
  _InvoiceState createState() => _InvoiceState();
}

class _InvoiceState extends State<EmptyInvoice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            Text(
              "Manage Invoices",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'DMSans',
                  color: AppColor().backgroundColor),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Expanded(
                child: Container(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.height * 0.02,
                        right: MediaQuery.of(context).size.height * 0.02,
                        bottom: MediaQuery.of(context).size.height * 0.02),
                    decoration: BoxDecoration(
                        color: Color(0xffF5F5F5),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            width: 2, color: Colors.grey.withOpacity(0.2))),
                    child: Container(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.height * 0.02,
                          right: MediaQuery.of(context).size.height * 0.02,
                          bottom: MediaQuery.of(context).size.height * 0.02),
                      decoration: BoxDecoration(
                        color: Color(0xffF5F5F5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/images/invoice.svg'),
                            Text(
                              'Create an invoice here',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontFamily: 'DMSans',
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Your invoices will show here. Click the',
                              style: TextStyle(
                                  fontSize: 8,
                                  color: Colors.black,
                                  fontFamily: 'DMSans'),
                            ),
                            Text(
                              'Create invoice button to add your first invoice',
                              style: TextStyle(
                                  fontSize: 8,
                                  color: Colors.black,
                                  fontFamily: 'DMSans'),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                            InkWell(
                              onTap: () {
                                Get.to(() => CreateInvoice());
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.height *
                                            0.06),
                                height: 50,
                                decoration: BoxDecoration(
                                    color: AppColor().backgroundColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Center(
                                  child: Text(
                                    'Create Invoice',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: 'DMSans'),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )))
          ],
        ),
      ),
    );
  }
}
