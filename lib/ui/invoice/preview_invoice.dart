import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:huzz/ui/dashboard.dart';
import 'package:huzz/ui/invoice/invoice_pdf.dart';
import 'package:huzz/util/colors.dart';
import 'package:huzz/core/constants/app_colors.dart';
import 'package:huzz/data/model/invoice.dart';
import 'package:pdf/pdf.dart';
import 'package:share_plus/share_plus.dart';

class PreviewInvoice extends StatefulWidget {
  final Invoice invoice;

  const PreviewInvoice({Key? key, required this.invoice}) : super(key: key);

  @override
  _PreviewInvoiceState createState() => _PreviewInvoiceState();
}

class _PreviewInvoiceState extends State<PreviewInvoice> {
  PDFViewController? controller;
  bool previewTheme = true;
  int paymentType = 0;
  int paymentMode = 0;
  bool isLoading = true;
  File? generatedInvoice;

  PdfColor themeColor = themeColors.first;

  @override
  void initState() {
    super.initState();
    generatePdf(themeColor);
  }

  void generatePdf(PdfColor color) async {
    generatedInvoice = await PdfInvoiceApi.generate(widget.invoice, color);
    setState(() {
      themeColor = color;
      isLoading = false;
    });
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
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SafeArea(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      Expanded(
                        child: PDFView(
                          key: ValueKey(themeColor),
                          fitPolicy: FitPolicy.WIDTH,
                          filePath: generatedInvoice!.path,
                          autoSpacing: false,
                          onViewCreated: (controller) =>
                              setState(() => this.controller = controller),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.height * 0.02,
                            vertical: 10),
                        child: Row(
                          children: [
                            ...themeColors
                                .map((color) => Container(
                                      height: 24,
                                      width: 24,
                                      margin: EdgeInsets.only(left: 10),
                                      color: Color(color.toInt()),
                                      child: GestureDetector(
                                        onTap: () => generatePdf(color),
                                        child: themeColor == color
                                            ? Icon(
                                                Icons.check,
                                                color: Colors.white,
                                              )
                                            : null,
                                      ),
                                    ))
                                .toList(),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Change invoice theme',
                              style: TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.height * 0.02,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    PdfApi.openFile(generatedInvoice!);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(
                                        MediaQuery.of(context).size.height *
                                            0.015),
                                    width: MediaQuery.of(context).size.height *
                                        0.06,
                                    height: MediaQuery.of(context).size.height *
                                        0.06,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: AppColor()
                                            .backgroundColor
                                            .withOpacity(0.2)),
                                    child: SvgPicture.asset(
                                        'assets/images/download.svg'),
                                  ),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01),
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
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.height * 0.01),
                            GestureDetector(
                              onTap: () {
                                Share.shareFiles([generatedInvoice!.path],
                                    text: 'Share Invoice');
                              },
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(
                                        MediaQuery.of(context).size.height *
                                            0.015),
                                    width: MediaQuery.of(context).size.height *
                                        0.06,
                                    height: MediaQuery.of(context).size.height *
                                        0.06,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: AppColor()
                                            .backgroundColor
                                            .withOpacity(0.2)),
                                    child: SvgPicture.asset(
                                        'assets/images/share.svg'),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01),
                                  Text(
                                    'Share',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'InterRegular'),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      InkWell(
                        onTap: () {
                          Get.offAll(Dashboard(
                            selectedIndex: 3,
                          ));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.height * 0.03),
                          height: 50,
                          decoration: BoxDecoration(
                              color: AppColor().backgroundColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
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
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                    ],
                  ),
                ),
              ));
  }
}
