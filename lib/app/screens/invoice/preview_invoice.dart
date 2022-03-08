import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:huzz/app/screens/dashboard.dart';
import 'package:huzz/app/screens/invoice/invoice_pdf.dart';
import 'package:huzz/colors.dart';

class PreviewInvoice extends StatefulWidget {
  final File? file;

  const PreviewInvoice({Key? key, this.file}) : super(key: key);

  @override
  _PreviewInvoiceState createState() => _PreviewInvoiceState();
}

class _PreviewInvoiceState extends State<PreviewInvoice> {
  PDFViewController? controller;
  bool previewTheme = true;
  int paymentType = 0;
  int paymentMode = 0;

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
          children: [
            Text(
              'View Invoice',
              style: TextStyle(
                color: AppColor().backgroundColor,
                fontFamily: "InterRegular",
                fontStyle: FontStyle.normal,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 4),
            // Text(
            //   '(#00000001)',
            //   style: TextStyle(
            //     color: Colors.black,
            //     fontFamily: "InterRegular",
            //     fontStyle: FontStyle.normal,
            //     fontSize: 16,
            //     fontWeight: FontWeight.w500,
            //   ),
            // ),
          ],
        ),
      ),
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
              //           value: previewTheme,
              //           onChanged: (bool? value) {
              //             setState(() {
              //               previewTheme = value!;
              //             });
              //           },
              //         ),
              //       ),
              //       Container(
              //         child: Checkbox(
              //           materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //           activeColor: Color(0xff0065D3),
              //           value: !previewTheme,
              //           onChanged: (bool? value) {
              //             setState(() {
              //               previewTheme = value!;
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
              //             fontFamily: 'InterRegular'),
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
                              fontFamily: 'InterRegular'),
                        ),
                      ],
                    ),
                    SizedBox(width: MediaQuery.of(context).size.height * 0.01),
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.height * 0.015),
                          width: MediaQuery.of(context).size.height * 0.06,
                          height: MediaQuery.of(context).size.height * 0.06,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color:
                                  AppColor().backgroundColor.withOpacity(0.2)),
                          child: SvgPicture.asset('assets/images/share.svg'),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        Text(
                          'Share',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'InterRegular'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              InkWell(
                onTap: () {
                  Get.offAll(Dashboard(
                    selectedIndex: 3,
                  ));
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
                          fontFamily: 'InterRegular'),
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
