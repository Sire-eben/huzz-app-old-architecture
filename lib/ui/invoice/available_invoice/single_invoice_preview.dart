import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:share_plus/share_plus.dart';

import 'package:huzz/data/repository/invoice_repository.dart';
import 'package:huzz/ui/invoice/invoice_pdf.dart';
import 'package:huzz/ui/widget/custom_form_field.dart';
import 'package:huzz/util/colors.dart';
import 'package:huzz/core/constants/app_colors.dart';
import 'package:huzz/data/model/invoice.dart';

import '../../../util/util.dart';

class PreviewSingleInvoice extends StatefulWidget {
  final Invoice? invoice;

  PreviewSingleInvoice({
    Key? key,
    this.invoice,
  }) : super(key: key);

  @override
  _PreviewSingleInvoiceState createState() => _PreviewSingleInvoiceState();
}

class _PreviewSingleInvoiceState extends State<PreviewSingleInvoice> {
  PDFViewController? controller;
  bool previewTheme = true;
  int paymentType = 0;
  int paymentMode = 0;
  bool isLoading = true;
  File? image;
  File? generatedInvoice;
  final _invoiceController = Get.find<InvoiceRespository>();
  final _amountController = TextEditingController();
  PdfColor themeColor = themeColors.first;

  @override
  void initState() {
    super.initState();
    generatePdf(themeColor);
  }

  void generatePdf(PdfColor color) async {
    print("appLog: ${widget.invoice!.toJson()}");
    generatedInvoice = await PdfInvoiceApi.generate(widget.invoice!, color);
    setState(() {
      themeColor = color;
      isLoading = false;
    });
  }

  Future pickImageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      print(imageTemporary);
      setState(
        () {
          this.image = imageTemporary;
        },
      );
    } on PlatformException catch (e) {
      print('$e');
    }
  }

  Future pickImageFromCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemporary = File(image.path);
      print(imageTemporary);
      setState(
        () {
          this.image = imageTemporary;
        },
      );
    } on PlatformException catch (e) {
      print('$e');
    }
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
          title: Text(
            'View Invoice',
            style: TextStyle(
              color: AppColor().backgroundColor,
              fontFamily: "InterRegular",
              fontStyle: FontStyle.normal,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
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
                            horizontal:
                                MediaQuery.of(context).size.height * 0.02,
                            vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (widget.invoice!.businessInvoiceStatus !=
                                "PAID") ...[
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top:
                                                          Radius.circular(20))),
                                          context: context,
                                          builder: (context) =>
                                              buildUpdateSingleInvoice());
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(
                                          MediaQuery.of(context).size.height *
                                              0.015),
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.06,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.06,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: AppColor()
                                              .backgroundColor
                                              .withOpacity(0.2)),
                                      child: SvgPicture.asset(
                                          'assets/images/credit_card.svg'),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01),
                                  Text(
                                    'Update Payment',
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
                                      MediaQuery.of(context).size.height * 0.1),
                            ],
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
                                    MediaQuery.of(context).size.height * 0.1),
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
                          Get.back();
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
                              'Go back',
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

  Widget buildUpdateSingleInvoice() =>
      StatefulBuilder(builder: (BuildContext context, StateSetter myState) {
        return Obx(() {
          return SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.04,
                right: MediaQuery.of(context).size.width * 0.04,
              ),
              padding: MediaQuery.of(context).viewInsets,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      height: 6,
                      width: 80,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.01),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  AppColor().backgroundColor.withOpacity(0.2)),
                          child: Icon(
                            Icons.close,
                            color: AppColor().backgroundColor,
                            size: 18,
                          )),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Update Payment',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "InterRegular",
                        fontStyle: FontStyle.normal,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          myState(() {
                            paymentType = 1;
                          });
                        },
                        child: Row(
                          children: [
                            Radio<int>(
                              value: 1,
                              activeColor: AppColor().backgroundColor,
                              groupValue: paymentType,
                              onChanged: (value) {
                                myState(() {
                                  paymentType = 1;
                                });
                              },
                            ),
                            Text(
                              'Paying Fully',
                              style: TextStyle(
                                color: AppColor().backgroundColor,
                                fontFamily: "InterRegular",
                                fontStyle: FontStyle.normal,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          myState(() {
                            paymentType = 0;
                          });
                        },
                        child: Row(
                          children: [
                            Radio<int>(
                                value: 0,
                                activeColor: AppColor().backgroundColor,
                                groupValue: paymentType,
                                onChanged: (value) {
                                  myState(() {
                                    value = 0;
                                    paymentType = 0;
                                  });
                                }),
                            Text(
                              'Paying Partly',
                              style: TextStyle(
                                color: AppColor().backgroundColor,
                                fontFamily: "InterRegular",
                                fontStyle: FontStyle.normal,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  paymentType == 0
                      ? CustomTextFieldInvoiceOptional(
                          label: 'Amount',
                          hint: '${Utils.getCurrency()}',
                          keyType: TextInputType.phone,
                          textEditingController: _amountController,
                        )
                      : Container(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  // InkWell(
                  //   onTap: () {
                  //     Get.bottomSheet(Container(
                  //       decoration: BoxDecoration(
                  //         color: Colors.white,
                  //         borderRadius: const BorderRadius.only(
                  //             topLeft: Radius.circular(16.0),
                  //             topRight: Radius.circular(16.0)),
                  //       ),
                  //       child: Wrap(
                  //         alignment: WrapAlignment.end,
                  //         crossAxisAlignment: WrapCrossAlignment.end,
                  //         children: [
                  //           ListTile(
                  //             leading: Icon(
                  //               Icons.camera,
                  //               color: AppColor().backgroundColor,
                  //             ),
                  //             title: Text('Camera'),
                  //             onTap: () {
                  //               Get.back();
                  //               pickImgFromCamera();
                  //             },
                  //           ),
                  //           ListTile(
                  //             leading: Icon(
                  //               Icons.image,
                  //               color: AppColor().backgroundColor,
                  //             ),
                  //             title: Text('Gallery'),
                  //             onTap: () {
                  //               Get.back();
                  //               pickImgFromGallery();
                  //             },
                  //           ),
                  //         ],
                  //       ),
                  //     ));
                  //   },
                  //   child: Container(
                  //     height: MediaQuery.of(context).size.height * 0.08,
                  //     width: MediaQuery.of(context).size.width,
                  //     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  //     decoration: BoxDecoration(
                  //         color: image != null
                  //             ? AppColor().backgroundColor.withOpacity(0.2)
                  //             : Colors.white,
                  //         borderRadius: BorderRadius.circular(10),
                  //         border: image != null
                  //             ? null
                  //             : Border.all(
                  //                 width: 2, color: AppColor().backgroundColor)),
                  //     child: Row(
                  //       children: [
                  //         Expanded(
                  //           child: Align(
                  //             alignment: Alignment.centerLeft,
                  //             child: Container(
                  //               child: Image.asset(
                  //                 'assets/images/image.png',
                  //                 height: 40,
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //         Expanded(
                  //           flex: 6,
                  //           child: AutoSizeText(
                  //             image != null
                  //                 ? image!.path.toString()
                  //                 : 'Add any supporting image (Optional)',
                  //             maxLines: 1,
                  //             overflow: TextOverflow.ellipsis,
                  //             style: TextStyle(
                  //                 color: image != null ? Colors.black : Colors.grey,
                  //                 fontSize: 12,
                  //                 fontWeight: FontWeight.w400,
                  //                 fontFamily: 'InterRegular'),
                  //           ),
                  //         ),
                  //         image != null
                  //             ? Expanded(
                  //                 child: SvgPicture.asset(
                  //                   'assets/images/edit.svg',
                  //                 ),
                  //               )
                  //             : Container(),
                  //         image != null
                  //             ? Expanded(
                  //                 child: InkWell(
                  //                   onTap: () {
                  //                     myState(() {
                  //                       image = null;
                  //                     });
                  //                   },
                  //                   child: SvgPicture.asset(
                  //                     'assets/images/delete.svg',
                  //                   ),
                  //                 ),
                  //               )
                  //             : Container(),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => myState(() => paymentMode = 0),
                        child: Row(
                          children: [
                            Radio<int>(
                                value: 0,
                                activeColor: AppColor().backgroundColor,
                                groupValue: paymentMode,
                                onChanged: (value) =>
                                    myState(() => paymentMode = 0)),
                            Text(
                              'Cash',
                              style: TextStyle(
                                color: AppColor().backgroundColor,
                                fontFamily: "InterRegular",
                                fontStyle: FontStyle.normal,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => myState(() => paymentMode = 1),
                        child: Row(
                          children: [
                            Radio<int>(
                                value: 1,
                                activeColor: AppColor().backgroundColor,
                                groupValue: paymentMode,
                                onChanged: (value) =>
                                    myState(() => paymentMode = 1)),
                            Text(
                              'POS',
                              style: TextStyle(
                                color: AppColor().backgroundColor,
                                fontFamily: "InterRegular",
                                fontStyle: FontStyle.normal,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => myState(() => paymentMode = 2),
                        child: Row(
                          children: [
                            Radio<int>(
                                value: 2,
                                activeColor: AppColor().backgroundColor,
                                groupValue: paymentMode,
                                onChanged: (value) =>
                                    myState(() => paymentMode = 2)),
                            Text(
                              'Transfer',
                              style: TextStyle(
                                color: AppColor().backgroundColor,
                                fontFamily: "InterRegular",
                                fontStyle: FontStyle.normal,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  InkWell(
                    onTap: () async {
                      if (_invoiceController.addingInvoiceStatus !=
                          AddingInvoiceStatus.Loading) {
                        String? source;
                        if (paymentMode == 0) {
                          source = "CASH";
                        } else if (paymentMode == 1) {
                          source = "POS";
                        } else if (paymentMode == 2) {
                          source = "TRANSFER";
                        }
                        await _invoiceController.updateTransactionHistory(
                            widget.invoice!.id!,
                            widget.invoice!.businessId!,
                            (paymentType == 0)
                                ? int.parse(_amountController.text)
                                : 0,
                            (paymentType == 0) ? "DEPOSIT" : "FULLY_PAID",
                            source!);
                        Get.back();
                      } else {}
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.height * 0.01),
                      height: 50,
                      decoration: BoxDecoration(
                          color: AppColor().backgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: (_invoiceController.addingInvoiceStatus ==
                              AddingInvoiceStatus.Loading)
                          ? Container(
                              width: 30,
                              height: 30,
                              child: Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.white)),
                            )
                          : Center(
                              child: Text(
                                'Save',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: 'InterRegular'),
                              ),
                            ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  )
                ],
              ),
            ),
          );
        });
      });
}
