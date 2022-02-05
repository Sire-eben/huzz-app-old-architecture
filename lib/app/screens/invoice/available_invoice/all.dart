import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/invoice_repository.dart';
import 'package:huzz/app/Utils/constants.dart';
import 'package:huzz/app/screens/invoice/create_invoice.dart';
import 'package:huzz/colors.dart';
import 'package:huzz/model/invoice_receipt_model.dart';
import 'package:number_display/number_display.dart';

import '../invoice_pdf.dart';
import 'single_invoice_preview.dart';

class All extends StatefulWidget {
  const All({Key? key}) : super(key: key);

  @override
  _AllState createState() => _AllState();
}

class _AllState extends State<All> {
  final _invoiceController = Get.find<InvoiceRespository>();
  bool deleteItem = true;
  bool visible = true;
  List<Invoice> _items = [];
  List _selectedIndex = [];
  final display = createDisplay(
    length: 10,
    decimal: 0,
  );
  @override
  Widget build(BuildContext context) {
    return Obx(() {
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
                        '(${_invoiceController.offlineInvoices.length})',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'DMSans',
                            fontSize: 14,
                            color: Colors.black),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        deleteItem = !deleteItem;
                        print(deleteItem);
                      });
                    },
                    child: Container(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.02),
                        decoration: BoxDecoration(
                            color: deleteItem
                                ? Colors.transparent
                                : AppColor().backgroundColor.withOpacity(0.2),
                            shape: BoxShape.circle),
                        child: SvgPicture.asset('assets/images/trash.svg')),
                  )
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.02),
              Expanded(
                child: deleteItem
                    ? ListView.builder(
                        itemCount: _invoiceController.offlineInvoices.length,
                        itemBuilder: (BuildContext context, int index) {
                          var item = _invoiceController.offlineInvoices[index];
                          return GestureDetector(
                            onTap: () async {
                              final date = DateTime.now();
                              // ignore: unused_local_variable
                              final dueDate = date.add(Duration(days: 7));

                              final singleInvoiceReceipt =
                                  await PdfInvoiceApi.generate(item);
                              Get.to(() => PreviewSingleInvoice(
                                  invoice: item, file: singleInvoiceReceipt));
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).size.width * 0.02),
                              child: Container(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.height * 0.02),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.withOpacity(0.1),
                                    border: Border.all(
                                        width: 2,
                                        color: Colors.grey.withOpacity(0.1))),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "N${display(item.totalAmount)}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'DMSans',
                                                    fontSize: 14,
                                                    color: Color(0xffEF6500)),
                                              ),
                                              Text(
                                                "",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'DMSans',
                                                    fontSize: 14,
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                item.createdDateTime!
                                                    .formatDate()!,
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
                                            MediaQuery.of(context).size.width *
                                                0.05),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: AppColor().backgroundColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        })
                    : ListView.builder(
                        itemCount: _invoiceController.offlineInvoices.length,
                        itemBuilder: (BuildContext context, int index) {
                          var item = _invoiceController.offlineInvoices[index];
                          // ignore: unused_local_variable
                          final _isSelected = _selectedIndex.contains(index);
                          return InkWell(
                            onTap: () {
                              setState(() {
                                if (_items.contains(index)) {
                                  _selectedIndex.add(index);
                                } else {
                                  _selectedIndex.remove(index);
                                }
                              });
                              print('selected');
                              print(_items.toString());
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).size.width * 0.02),
                              child: Container(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.height * 0.02),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.withOpacity(0.1),
                                    border: Border.all(
                                        width: 2,
                                        color: Colors.grey.withOpacity(0.1))),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "N${display(item.totalAmount)}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'DMSans',
                                                    fontSize: 14,
                                                    color: Color(0xffEF6500)),
                                              ),
                                              Text(
                                                "",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'DMSans',
                                                    fontSize: 14,
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                item.createdDateTime!
                                                    .formatDate()!,
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
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (_invoiceController
                                            .checkifSelectedForDeleted(
                                                item.id!)) {
                                          _invoiceController.deletedItem
                                              .remove(item);
                                        } else {
                                          _invoiceController.deletedItem
                                              .add(item);
                                        }
                                        setState(() {});
                                      },
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 200),
                                        height: 25,
                                        width: 25,
                                        decoration: BoxDecoration(
                                          color: (_invoiceController
                                                  .checkifSelectedForDeleted(
                                                      item.id!))
                                              ? AppColor().whiteColor
                                              : AppColor().orangeBorderColor,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: (_invoiceController
                                                    .checkifSelectedForDeleted(
                                                        item.id!))
                                                ? Color(0xffEF6500)
                                                : Colors.transparent,
                                            width: 2,
                                          ),
                                        ),
                                        child: Visibility(
                                          visible: visible,
                                          child: Icon(
                                            Icons.check,
                                            size: 15,
                                            color: AppColor().whiteColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            deleteItem
                ? Get.to(() => CreateInvoice())
                : _displayDialog(context);
          },
          icon: Icon(Icons.add),
          backgroundColor: AppColor().backgroundColor,
          label: Text(
            deleteItem ? 'New Invoice' : 'Delete Item',
            style: TextStyle(
                fontFamily: 'DMSans',
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
      );
    });
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(
              horizontal: 50,
              vertical: 300,
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    'You are about to delete this transaction. Are you sure you want to continue?',
                    style: TextStyle(
                      color: AppColor().blackColor,
                      fontFamily: 'DMSans',
                      fontWeight: FontWeight.normal,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            content: Center(
              child: SvgPicture.asset(
                'assets/images/delete_alert.svg',
                fit: BoxFit.fitHeight,
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _invoiceController.deleteItems();
                          Get.back();
                        },
                        child: Container(
                          height: 45,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                              color: AppColor().whiteColor,
                              border: Border.all(
                                width: 2,
                                color: AppColor().backgroundColor,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: AppColor().backgroundColor,
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _invoiceController.deleteItems();
                          Get.back();
                        },
                        child: Container(
                          height: 45,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                              color: AppColor().backgroundColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                color: AppColor().whiteColor,
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
