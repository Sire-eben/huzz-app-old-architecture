import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:huzz/colors.dart';
import 'package:huzz/model/invoice_model.dart';

class All extends StatefulWidget {
  const All({Key? key}) : super(key: key);

  @override
  _AllState createState() => _AllState();
}

class _AllState extends State<All> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Invoices',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'DMSans',
                          fontSize: 14,
                          color: Colors.black),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    Text(
                      '(3)',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'DMSans',
                          fontSize: 14,
                          color: Colors.black),
                    ),
                  ],
                ),
                Container(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.02),
                    decoration: BoxDecoration(
                        color: AppColor().backgroundColor.withOpacity(0.2),
                        shape: BoxShape.circle),
                    child: SvgPicture.asset('assets/images/trash.svg'))
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.02),
            Expanded(
              child: ListView.builder(
                  itemCount: invoiceList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.width * 0.02),
                      child: Container(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.02),
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
                                    'Labour',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'DMSans',
                                        fontSize: 14,
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.02),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'N20,000',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'DMSans',
                                            fontSize: 14,
                                            color: Color(0xffEF6500)),
                                      ),
                                      Text(
                                        'DEPOSIT',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'DMSans',
                                            fontSize: 14,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        '23, NOV. 2021',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'DMSans',
                                            fontSize: 14,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.height * 0.1),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: AppColor().backgroundColor,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
