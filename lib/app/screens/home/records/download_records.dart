import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:huzz/colors.dart';
import 'package:share_plus/share_plus.dart';
import '../records.dart';
import 'records_pdf.dart';

class DownloadRecordReceipt extends StatefulWidget {
  final File? file;

  const DownloadRecordReceipt({Key? key, @required this.file})
      : super(key: key);

  @override
  _DownloadRecordReceiptState createState() => _DownloadRecordReceiptState();
}

class _DownloadRecordReceiptState extends State<DownloadRecordReceipt> {
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
                            PdfRecordApi.openFile(widget.file!);
                            Get.back();
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
                    GestureDetector(
                      onTap: () {
                        Share.shareFiles([widget.file!.path],
                            text: 'Share Receipt');
                        Get.back();
                      },
                      child: Column(
                        children: [
                          Container(
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
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.01),
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              InkWell(
                onTap: () {
                  Get.to(() => Records());
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
