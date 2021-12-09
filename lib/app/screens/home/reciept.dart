import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:huzz/app/screens/dashboard.dart';
import '../../../colors.dart';

class IncomeReceipt extends StatefulWidget {
  final File? file;

  const IncomeReceipt({Key? key, @required this.file}) : super(key: key);

  @override
  _IncomeReceiptState createState() => _IncomeReceiptState();
}

class _IncomeReceiptState extends State<IncomeReceipt> {
  PDFViewController? controller;
  // final name = basename(widget.file!.path);
  bool receiptTheme = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Color(0xff0065D3)),
                  ),
                  child: PDFView(
                    filePath: widget.file!.path,
                    // autoSpacing: false,
                    // swipeHorizontal: true,
                    // pageSnap: false,
                    // pageFling: false,
                    onViewCreated: (controller) =>
                        setState(() => this.controller = controller),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Row(
                children: [
                  Container(
                    child: Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      activeColor: AppColor().backgroundColor,
                      value: receiptTheme,
                      onChanged: (bool? value) {
                        setState(() {
                          receiptTheme = value!;
                        });
                      },
                    ),
                  ),
                  Container(
                    child: Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      activeColor: Color(0xff0065D3),
                      value: !receiptTheme,
                      onChanged: (bool? value) {
                        setState(() {
                          receiptTheme = value!;
                        });
                      },
                    ),
                  ),
                  Text(
                    'Change receipt theme',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'DMSans'),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.015),
                        width: MediaQuery.of(context).size.height * 0.06,
                        height: MediaQuery.of(context).size.height * 0.06,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColor().backgroundColor.withOpacity(0.2)),
                        child: SvgPicture.asset('assets/images/download.svg'),
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
                      Container(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.015),
                        width: MediaQuery.of(context).size.height * 0.06,
                        height: MediaQuery.of(context).size.height * 0.06,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColor().backgroundColor.withOpacity(0.2)),
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
                            fontFamily: 'DMSans'),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
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
            ],
          ),
        ),
      ),
    );
  }
}
