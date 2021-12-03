import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:huzz/colors.dart';

class Invoice extends StatefulWidget {
  const Invoice({Key? key}) : super(key: key);

  @override
  _InvoiceState createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
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
                  fontWeight: FontWeight.w500,
                  fontFamily: 'DMSans',
                  fontSize: 24,
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
                              'Create an Invoice here',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontFamily: 'DMSans',
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Your invoices will show here. Click the',
                              style: TextStyle(
                                  fontSize: 8,
                                  color: Colors.black,
                                  fontFamily: 'DMSans'),
                            ),
                            Text(
                              'Add invoice button to add your first invoice',
                              style: TextStyle(
                                  fontSize: 8,
                                  color: Colors.black,
                                  fontFamily: 'DMSans'),
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
