import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/ui/app_scaffold.dart';
import 'package:huzz/core/constants/app_colors.dart';
import 'package:huzz/data/model/transaction_model.dart';
import 'package:pdf/pdf.dart';
import 'package:share_plus/share_plus.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'receipt/money_in_out_pdf.dart';

class IncomeReceipt extends StatefulWidget {
  final TransactionModel transaction;
  final bool? pageCheck;

  const IncomeReceipt({Key? key, required this.transaction, this.pageCheck})
      : super(key: key);

  @override
  _IncomeReceiptState createState() => _IncomeReceiptState();
}

class _IncomeReceiptState extends State<IncomeReceipt> {
  PDFViewController? controller;
  bool isLoading = true;
  File? generatedReceipt;
  PdfColor themeColor = themeColors.first;

  @override
  void initState() {
    super.initState();
    generatePdf(themeColor);
  }

  void generatePdf(PdfColor color) async {
    generatedReceipt =
        await PdfMoneyInOutApi.generate(widget.transaction, color);
    setState(() {
      themeColor = color;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          filePath: generatedReceipt!.path,
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
                              'Change receipt theme',
                              style: GoogleFonts.inter(fontSize: 12),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.height * 0.02,
                            vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    PdfApi.openFile(generatedReceipt!);
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
                                        color: AppColors.backgroundColor
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
                                  style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.height * 0.01),
                            GestureDetector(
                              onTap: () {
                                Share.shareFiles([generatedReceipt!.path],
                                    text: 'Share Receipt');
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
                                        color: AppColors.backgroundColor
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
                                    style: GoogleFonts.inter(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      InkWell(
                        onTap: () {
                          widget.pageCheck == false
                              ? Get.back()
                              : Get.offAll(Dashboard());
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.height * 0.03),
                          height: 50,
                          decoration: BoxDecoration(
                              color: AppColors.backgroundColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Center(
                            child: Text(
                              'Continue',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 18,
                              ),
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
