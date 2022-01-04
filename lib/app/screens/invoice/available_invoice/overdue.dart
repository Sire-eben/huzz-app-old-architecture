import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/invoice_repository.dart';
import 'package:huzz/Repository/product_repository.dart';
import 'package:huzz/app/Utils/constants.dart';
import 'package:huzz/model/invoice.dart';

import '../../../../colors.dart';

class Overdue extends StatefulWidget {
  const Overdue({Key? key}) : super(key: key);

  @override
  _OverdueState createState() => _OverdueState();
}

class _OverdueState extends State<Overdue> {
final _productController = Get.find<ProductRepository>();
  final _invoiceController=Get.find<InvoiceRespository>();
  bool deleteItem = true;
  bool visible = true;
  List<Invoice> _items = [];
  List _selectedIndex = [];
  @override
  Widget build(BuildContext context) {
    return Obx(()
     {
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
                          '(${_invoiceController.InvoiceDueList.length})',
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
                          itemCount: _invoiceController.InvoiceDueList.length,
                          itemBuilder: (BuildContext context, int index) {
                            var item = _invoiceController.InvoiceDueList[index];
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).size.width * 0.02),
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
                                        //   Text(
                                        //  item.paymentItemRequestList!.isNotEmpty?   item.paymentItemRequestList!.first.itemName!:"",
                                        //     style: TextStyle(
                                        //         fontWeight: FontWeight.bold,
                                        //         fontFamily: 'DMSans',
                                        //         fontSize: 14,
                                        //         color: Colors.black),
                                        //   ),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "N ${item.totalAmount}",
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
                                                item.createdDateTime!.formatDate()!,
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
                                        width: MediaQuery.of(context).size.width *
                                            0.05),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: AppColor().backgroundColor,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })
                      : ListView.builder(
                          itemCount: _invoiceController.InvoiceDueList.length,
                          itemBuilder: (BuildContext context, int index) {
                            var item =_invoiceController.InvoiceDueList[index];
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
                                            // Text(
                                            // item.paymentItemRequestList!.first.itemName!,
                                            //   style: TextStyle(
                                            //       fontWeight: FontWeight.bold,
                                            //       fontFamily: 'DMSans',
                                            //       fontSize: 14,
                                            //       color: Colors.black),
                                            // ),
                                            // SizedBox(
                                            //     height: MediaQuery.of(context)
                                            //             .size
                                            //             .width *
                                            //         0.02),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                    "${item.totalAmount}",
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
                                                   item.createdDateTime!.formatDate()!,
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
                                                  0.05),
                                      // _isSelected
                                      //     ? SvgPicture.asset(
                                      //         'assets/images/circle.svg')
                                      //     : SvgPicture.asset(
                                      //         'assets/images/selectedItem.svg')
                                      GestureDetector(
                                        onTap: () {
    
                                       if(_invoiceController.checkifSelectedForDeleted(item.id!)){
    
                                        _invoiceController.deletedItem.remove(item);
                                       }else{
                                        _invoiceController.deletedItem.add(item);
    
                                       }  
                                        setState(() {
                                          
                                        });
                                        },
                                        child: AnimatedContainer(
                                          duration: Duration(milliseconds: 200),
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            color: visible
                                                ? AppColor().orangeBorderColor
                                                : AppColor().whiteColor,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Color(0xffEF6500),
                                            ),
                                          ),
                                          child: Visibility(
                                            visible: visible,
                                            child: Icon(
                                              Icons.check,
                                              size: 15,
                                              color: (_invoiceController.checkifSelectedForDeleted(item.id!))
                                                  ? AppColor().whiteColor
                                                  : AppColor().orangeBorderColor,
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
          // floatingActionButton: FloatingActionButton.extended(
          //   onPressed: () {
          //     deleteItem ? Get.to(() => CreateInvoice()) : _displayDialog(context);
          //   },
          //   icon: Icon(Icons.add),
          //   backgroundColor: AppColor().backgroundColor,
          //   label: Text(
          //     deleteItem ? 'New Invoice' : 'Delete Item',
          //     style: TextStyle(
          //         fontFamily: 'DMSans',
          //         fontSize: 10,
          //         color: Colors.white,
          //         fontWeight: FontWeight.bold),
          //   ),
          // ),
        );
      }
    );
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
                    'You are about to delete you want to delete invoice(s) Are you sure you want to continue?',
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
