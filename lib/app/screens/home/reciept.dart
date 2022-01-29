import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:huzz/app/screens/dashboard.dart';
import '../../../colors.dart';
import 'receipt/money_in_out_pdf.dart';

class IncomeReceipt extends StatefulWidget {
  final File? file;

  const IncomeReceipt({Key? key, @required this.file}) : super(key: key);

  @override
  _IncomeReceiptState createState() => _IncomeReceiptState();
}

class _IncomeReceiptState extends State<IncomeReceipt> {
  PDFViewController? controller;
  bool receiptTheme = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                child: PDFView(
                  fitPolicy: FitPolicy.WIDTH,
                  filePath: widget.file!.path,
                  autoSpacing: false,
                  onViewCreated: (controller) =>
                      setState(() => this.controller = controller),
                ),
              ),
              // Padding(
              //   padding:
              //       EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
              //   child: Row(
              //     children: [
              //       Container(
              //         child: Checkbox(
              //           materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //           activeColor: AppColor().backgroundColor,
              //           value: receiptTheme,
              //           onChanged: (bool? value) {
              //             setState(() {
              //               receiptTheme = value!;
              //             });
              //           },
              //         ),
              //       ),
              //       Container(
              //         child: Checkbox(
              //           materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //           activeColor: Color(0xff0065D3),
              //           value: !receiptTheme,
              //           onChanged: (bool? value) {
              //             setState(() {
              //               receiptTheme = value!;
              //             });
              //           },
              //         ),
              //       ),
              //       Text(
              //         'Change receipt theme',
              //         style: TextStyle(
              //             color: Colors.black,
              //             fontSize: 10,
              //             fontWeight: FontWeight.w400,
              //             fontFamily: 'DMSans'),
              //       ),
              //     ],
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.height * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            PdfApi.openFile(widget.file!);
                          },
                          child: Container(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.height * 0.015),
                            width: MediaQuery.of(context).size.height * 0.06,
                            height: MediaQuery.of(context).size.height * 0.06,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColor()
                                    .backgroundColor
                                    .withOpacity(0.2)),
                            child:
                                SvgPicture.asset('assets/images/download.svg'),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        Text(
                          'Download',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'DMSans'),
                        ),
                      ],
                    ),
                    SizedBox(width: MediaQuery.of(context).size.height * 0.01),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.height * 0.015),
                            width: MediaQuery.of(context).size.height * 0.06,
                            height: MediaQuery.of(context).size.height * 0.06,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColor()
                                    .backgroundColor
                                    .withOpacity(0.2)),
                            child: SvgPicture.asset('assets/images/share.svg'),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        Text(
                          'Share',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'DMSans'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              InkWell(
                onTap: () {
                  Get.offAll(Dashboard());
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.height * 0.03),
                  height: 50,
                  decoration: BoxDecoration(
                      color: AppColor().backgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Center(
                    child: Text(
                      'Continue',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'DMSans'),
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
