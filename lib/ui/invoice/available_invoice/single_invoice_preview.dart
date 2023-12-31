import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/widgets/state/loading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:share_plus/share_plus.dart';
import 'package:huzz/data/repository/invoice_repository.dart';
import 'package:huzz/ui/invoice/invoice_pdf.dart';
import 'package:huzz/ui/widget/custom_form_field.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/constants/app_colors.dart';
import 'package:huzz/data/model/invoice.dart';
import 'package:huzz/core/util/util.dart';

import '../../../data/repository/team_repository.dart';

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
  final teamController = Get.find<TeamRepository>();
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
              color: AppColors.backgroundColor,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          title: Text(
            'View Invoice',
            style: GoogleFonts.inter(
              color: AppColors.backgroundColor,
              fontStyle: FontStyle.normal,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: isLoading
            ? Center(
                child: LoadingWidget(),
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
                            if (widget.invoice!.businessInvoiceStatus !=
                                "PAID") ...[
                              Column(
                                children: [
                                  (teamController.teamMember.authoritySet!
                                          .contains('UPDATE_BUSINESS_INVOICE'))
                                      ? InkWell(
                                          onTap: () {
                                            if (teamController
                                                .teamMember.authoritySet!
                                                .contains(
                                                    'UPDATE_BUSINESS_INVOICE')) {
                                              showModalBottomSheet(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      20))),
                                                  context: context,
                                                  builder: (context) =>
                                                      buildUpdateSingleInvoice());
                                            } else {
                                              Get.snackbar('Alert',
                                                  'You need to be authorized to perform this operation');
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(
                                                MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.015),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.06,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.06,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: AppColors.backgroundColor
                                                    .withOpacity(0.2)),
                                            child: SvgPicture.asset(
                                                'assets/images/credit_card.svg'),
                                          ),
                                        )
                                      : Container(),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01),
                                  Text(
                                    'Update Payment',
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
                              color: AppColors.backgroundColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Center(
                            child: Text(
                              'Go back',
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
                                  AppColors.backgroundColor.withOpacity(0.2)),
                          child: Icon(
                            Icons.close,
                            color: AppColors.backgroundColor,
                            size: 18,
                          )),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Update Payment',
                      style: GoogleFonts.inter(
                        color: Colors.black,
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
                              activeColor: AppColors.backgroundColor,
                              groupValue: paymentType,
                              onChanged: (value) {
                                myState(() {
                                  paymentType = 1;
                                });
                              },
                            ),
                            Text(
                              'Paying Fully',
                              style: GoogleFonts.inter(
                                color: AppColors.backgroundColor,
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
                                activeColor: AppColors.backgroundColor,
                                groupValue: paymentType,
                                onChanged: (value) {
                                  myState(() {
                                    value = 0;
                                    paymentType = 0;
                                  });
                                }),
                            Text(
                              'Paying Partly',
                              style: GoogleFonts.inter(
                                color: AppColors.backgroundColor,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => myState(() => paymentMode = 0),
                        child: Row(
                          children: [
                            Radio<int>(
                                value: 0,
                                activeColor: AppColors.backgroundColor,
                                groupValue: paymentMode,
                                onChanged: (value) =>
                                    myState(() => paymentMode = 0)),
                            Text(
                              'Cash',
                              style: GoogleFonts.inter(
                                color: AppColors.backgroundColor,
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
                                activeColor: AppColors.backgroundColor,
                                groupValue: paymentMode,
                                onChanged: (value) =>
                                    myState(() => paymentMode = 1)),
                            Text(
                              'POS',
                              style: GoogleFonts.inter(
                                color: AppColors.backgroundColor,
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
                                activeColor: AppColors.backgroundColor,
                                groupValue: paymentMode,
                                onChanged: (value) =>
                                    myState(() => paymentMode = 2)),
                            Text(
                              'Transfer',
                              style: GoogleFonts.inter(
                                color: AppColors.backgroundColor,
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
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: (_invoiceController.addingInvoiceStatus ==
                              AddingInvoiceStatus.Loading)
                          ? Container(
                              width: 30,
                              height: 30,
                              child: Center(child: LoadingWidget()),
                            )
                          : Center(
                              child: Text(
                                'Save',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
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
