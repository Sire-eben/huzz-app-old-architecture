import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/util/constants.dart';
import 'package:huzz/data/repository/business_respository.dart';
import 'package:huzz/data/repository/customer_repository.dart';
import 'package:huzz/data/repository/invoice_repository.dart';
import 'package:huzz/ui/invoice/create_invoice.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/data/model/invoice_receipt_model.dart';
import 'package:huzz/core/util/util.dart';
import 'package:number_display/number_display.dart';
import '../../../data/repository/team_repository.dart';
import 'empty_invoice_info.dart';
import 'single_invoice_preview.dart';

class All extends StatefulWidget {
  const All({Key? key}) : super(key: key);

  @override
  _AllState createState() => _AllState();
}

class _AllState extends State<All> {
  final _businessController = Get.find<BusinessRespository>();
  final _invoiceController = Get.find<InvoiceRespository>();
  final _customerController = Get.find<CustomerRepository>();
  final teamController = Get.find<TeamRepository>();
  bool deleteItem = false;
  bool visible = true;
  List<Invoice> _items = [];
  List _selectedIndex = [];
  final display = createDisplay(
    length: 10,
    decimal: 0,
  );

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
                    'You are about to delete this invoice(s). Are you sure you want to continue?',
                    style: GoogleFonts.inter(
                      color: AppColors.blackColor,
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
                // fit: BoxFit.fitHeight,
                height: 60,
                width: 60,
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
                              color: AppColors.whiteColor,
                              border: Border.all(
                                width: 2,
                                color: AppColors.backgroundColor,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.inter(
                                color: AppColors.backgroundColor,
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
                          setState(() {
                            deleteItem = false;
                          });
                          Get.back();
                        },
                        child: Container(
                          height: 45,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                              color: AppColors.backgroundColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              'Delete',
                              style: GoogleFonts.inter(
                                color: AppColors.whiteColor,
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

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final value = _businessController.selectedBusiness.value;
      return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 50),
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
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.black),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      Text(
                        '(${_invoiceController.offlineInvoices.length})',
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.black),
                      ),
                    ],
                  ),
                  (teamController.teamMember.teamMemberStatus == 'CREATOR' ||
                          teamController.teamMember.authoritySet!
                              .contains('DELETE_BUSINESS_INVOICE'))
                      ? InkWell(
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
                                  color: !deleteItem
                                      ? Colors.transparent
                                      : AppColors.backgroundColor
                                          .withOpacity(0.2),
                                  shape: BoxShape.circle),
                              child:
                                  SvgPicture.asset('assets/images/trash.svg')),
                        )
                      : Container(),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.02),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    return Future.delayed(Duration(seconds: 1), () {
                      _invoiceController.getOnlineInvoice(value!.businessId!);
                      _invoiceController.GetOfflineInvoices(value.businessId!);
                    });
                  },
                  child: !deleteItem
                      ? (_invoiceController.invoiceStatus ==
                              InvoiceStatus.Loading)
                          ? Center(child: CircularProgressIndicator())
                          : (_invoiceController.offlineInvoices.length != 0)
                              ? ListView.builder(
                                  itemCount:
                                      _invoiceController.offlineInvoices.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var item = _invoiceController
                                        .offlineInvoices[index];
                                    var customer = _customerController
                                        .checkifCustomerAvailableWithValue(
                                            item.customerId ?? "");
                                    if (customer == null) {
                                      print("customer is null");
                                    }
                                    return Visibility(
                                      child: GestureDetector(
                                        onTap: () async {
                                          final date = DateTime.now();
                                          // ignore: unused_local_variable
                                          final dueDate =
                                              date.add(Duration(days: 7));

                                          // final singleInvoiceReceipt =
                                          //     await PdfInvoiceApi.generate(item);
                                          Get.to(() => PreviewSingleInvoice(
                                              invoice: item));
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02),
                                          child: Container(
                                            padding: EdgeInsets.all(
                                                MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.grey
                                                    .withOpacity(0.1),
                                                border: Border.all(
                                                    width: 2,
                                                    color: Colors.grey
                                                        .withOpacity(0.1))),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        customer == null
                                                            ? ""
                                                            : customer.name!,
                                                        style:
                                                            GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            "${Utils.getCurrency()}${display(item.totalAmount)}",
                                                            style: GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 14,
                                                                color: Color(
                                                                    0xffEF6500)),
                                                          ),
                                                          Text(
                                                            "",
                                                            style: GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          Text(
                                                            item.createdDateTime!
                                                                .formatDate()!,
                                                            style: GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.05),
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  color:
                                                      AppColors.backgroundColor,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  })
                              : EmptyInvoiceInfo()
                      : (_invoiceController.invoiceStatus ==
                              InvoiceStatus.Loading)
                          ? Center(child: CircularProgressIndicator())
                          : (_invoiceController.invoiceStatus ==
                                      InvoiceStatus.Available &&
                                  _invoiceController.offlineInvoices.length !=
                                      0)
                              ? ListView.builder(
                                  itemCount:
                                      _invoiceController.offlineInvoices.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var item = _invoiceController
                                        .offlineInvoices[index];
                                    // ignore: unused_local_variable
                                    final _isSelected =
                                        _selectedIndex.contains(index);
                                    var customer = _customerController
                                        .checkifCustomerAvailableWithValue(
                                            item.customerId ?? "");
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
                                            bottom: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.02),
                                        child: Container(
                                          padding: EdgeInsets.all(
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.02),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                              border: Border.all(
                                                  width: 2,
                                                  color: Colors.grey
                                                      .withOpacity(0.1))),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      customer == null
                                                          ? ""
                                                          : customer.name!,
                                                      style: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 16,
                                                          color: Colors.black),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "${Utils.getCurrency()}${display(item.totalAmount)}",
                                                          style: GoogleFonts.inter(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 14,
                                                              color: Color(
                                                                  0xffEF6500)),
                                                        ),
                                                        Text(
                                                          "",
                                                          style:
                                                              GoogleFonts.inter(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                        Text(
                                                          item.createdDateTime!
                                                              .formatDate()!,
                                                          style:
                                                              GoogleFonts.inter(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.05,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  if (_invoiceController
                                                      .checkifSelectedForDeleted(
                                                          item.id!)) {
                                                    _invoiceController
                                                        .deletedItem
                                                        .remove(item);
                                                  } else {
                                                    _invoiceController
                                                        .deletedItem
                                                        .add(item);
                                                  }
                                                  setState(() {});
                                                },
                                                child: AnimatedContainer(
                                                  duration: Duration(
                                                      milliseconds: 200),
                                                  height: 25,
                                                  width: 25,
                                                  decoration: BoxDecoration(
                                                    color: (!_invoiceController
                                                            .checkifSelectedForDeleted(
                                                                item.id!))
                                                        ? AppColors.whiteColor
                                                        : AppColors
                                                            .orangeBorderColor,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: (!_invoiceController
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
                                                      color:
                                                          AppColors.whiteColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : EmptyInvoiceInfo(),
                ),
              )
            ],
          ),
        ),
        floatingActionButton:
            (teamController.teamMember.teamMemberStatus == 'CREATOR' ||
                    teamController.teamMember.authoritySet!
                        .contains('CREATE_BUSINESS_INVOICE'))
                ? FloatingActionButton.extended(
                    onPressed: () {
                      if (deleteItem) {
                        if (_invoiceController.deletedItem.isEmpty) {
                          Get.snackbar('Alert', 'No item selected');
                        } else {
                          _displayDialog(context);
                        }
                      } else {
                        Get.to(() => CreateInvoice());
                      }
                    },
                    icon: (!deleteItem) ? Container() : Icon(Icons.add),
                    backgroundColor: AppColors.backgroundColor,
                    label: Text(
                      deleteItem ? 'Delete Item' : 'New Invoice',
                      style: GoogleFonts.inter(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                : Container(),
      );
    });
  }
}
