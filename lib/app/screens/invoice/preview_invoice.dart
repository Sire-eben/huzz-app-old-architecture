import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:huzz/app/screens/invoice/invoice_pdf.dart';
import 'package:huzz/app/screens/widget/custom_form_field.dart';
import 'package:huzz/colors.dart';
import 'package:image_picker/image_picker.dart';

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
  File? image;

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
        title: Row(
          children: [
            Text(
              'Create Invoice',
              style: TextStyle(
                color: AppColor().backgroundColor,
                fontFamily: "DMSans",
                fontStyle: FontStyle.normal,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 4),
            Text(
              '(#00000001)',
              style: TextStyle(
                color: Colors.black,
                fontFamily: "DMSans",
                fontStyle: FontStyle.normal,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
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
              Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
                child: Row(
                  children: [
                    Container(
                      child: Checkbox(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        activeColor: AppColor().backgroundColor,
                        value: previewTheme,
                        onChanged: (bool? value) {
                          setState(() {
                            previewTheme = value!;
                          });
                        },
                      ),
                    ),
                    Container(
                      child: Checkbox(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        activeColor: Color(0xff0065D3),
                        value: !previewTheme,
                        onChanged: (bool? value) {
                          setState(() {
                            previewTheme = value!;
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
                              fontFamily: 'DMSans'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20))),
                      context: context,
                      builder: (context) => buildSaveInvoice());
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

  Widget buildSaveInvoice() =>
      StatefulBuilder(builder: (BuildContext context, StateSetter myState) {
        Future pickImgFromGallery() async {
          try {
            final image =
                await ImagePicker().pickImage(source: ImageSource.gallery);
            if (image == null) return;
            final imageTemporary = File(image.path);
            print(imageTemporary);
            myState(
              () {
                this.image = imageTemporary;
              },
            );
          } on PlatformException catch (e) {
            print('$e');
          }
        }

        Future pickImgFromCamera() async {
          try {
            final image =
                await ImagePicker().pickImage(source: ImageSource.camera);
            if (image == null) return;
            final imageTemporary = File(image.path);
            print(imageTemporary);
            myState(
              () {
                this.image = imageTemporary;
              },
            );
          } on PlatformException catch (e) {
            print('$e');
          }
        }

        return Container(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.04,
              right: MediaQuery.of(context).size.width * 0.04,
              bottom: MediaQuery.of(context).size.width * 0.04,
              top: MediaQuery.of(context).size.width * 0.02),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
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
                          color: AppColor().backgroundColor.withOpacity(0.2)),
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
                    fontFamily: "DMSans",
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
                            fontFamily: "DMSans",
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
                            fontFamily: "DMSans",
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
              paymentType == 1
                  ? CustomTextFieldInvoiceOptional(
                      label: 'Amount',
                      hint: 'N',
                      keyType: TextInputType.phone,
                    )
                  : Container(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              InkWell(
                onTap: () {
                  Get.bottomSheet(Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0)),
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.end,
                      crossAxisAlignment: WrapCrossAlignment.end,
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.camera,
                            color: AppColor().backgroundColor,
                          ),
                          title: Text('Camera'),
                          onTap: () {
                            Get.back();
                            pickImgFromCamera();
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.image,
                            color: AppColor().backgroundColor,
                          ),
                          title: Text('Gallery'),
                          onTap: () {
                            Get.back();
                            pickImgFromGallery();
                          },
                        ),
                      ],
                    ),
                  ));
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                      color: image != null
                          ? AppColor().backgroundColor.withOpacity(0.2)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: image != null
                          ? null
                          : Border.all(
                              width: 2, color: AppColor().backgroundColor)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: Image.asset(
                              'assets/images/image.png',
                              height: 40,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: AutoSizeText(
                          image != null
                              ? image!.path.toString()
                              : 'Add any supporting image (Optional)',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: image != null ? Colors.black : Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'DMSans'),
                        ),
                      ),
                      image != null
                          ? Expanded(
                              child: SvgPicture.asset(
                                'assets/images/edit.svg',
                              ),
                            )
                          : Container(),
                      image != null
                          ? Expanded(
                              child: InkWell(
                                onTap: () {
                                  myState(() {
                                    image = null;
                                  });
                                },
                                child: SvgPicture.asset(
                                  'assets/images/delete.svg',
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
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
                            fontFamily: "DMSans",
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
                            fontFamily: "DMSans",
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
                            fontFamily: "DMSans",
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
                onTap: () {},
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.height * 0.01),
                  height: 50,
                  decoration: BoxDecoration(
                      color: AppColor().backgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Center(
                    child: Text(
                      'Save',
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
        );
      });
}
