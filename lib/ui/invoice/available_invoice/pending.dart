import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/util/constants.dart';
import 'package:huzz/core/widgets/state/loading.dart';
import 'package:huzz/data/repository/business_respository.dart';
import 'package:huzz/data/repository/customer_repository.dart';
import 'package:huzz/data/repository/invoice_repository.dart';
import 'package:huzz/ui/invoice/available_invoice/empty_invoice_info.dart';
import 'package:huzz/ui/invoice/available_invoice/single_invoice_preview.dart';
import 'package:huzz/data/model/invoice.dart';
import 'package:number_display/number_display.dart';
import '../../../data/repository/team_repository.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/util/util.dart';
import '../create_invoice.dart';

class Pending extends StatefulWidget {
  const Pending({Key? key}) : super(key: key);

  @override
  _PendingState createState() => _PendingState();
}

class _PendingState extends State<Pending> {
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
                        '(${_invoiceController.InvoicePendingList.length})',
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 2),
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
              SizedBox(height: MediaQuery.of(context).size.width * 0.03),
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
                          ? Center(child: LoadingWidget())
                          : (_invoiceController.InvoicePendingList.length != 0)
                              ? ListView.builder(
                                  itemCount: _invoiceController
                                      .InvoicePendingList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var item = _invoiceController
                                        .InvoicePendingList[index];
                                    var customer = _customerController
                                        .checkifCustomerAvailableWithValue(
                                            item.customerId ?? "");
                                    return GestureDetector(
                                      onTap: () async {
                                        Get.to(() => PreviewSingleInvoice(
                                            invoice: item));
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.03),
                                        child: Container(
                                          padding: EdgeInsets.all(
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.015),
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
                                                    //   Text(
                                                    //  item.paymentItemRequestList!.isNotEmpty?   item.paymentItemRequestList!.first.itemName!:"",
                                                    //     style: GoogleFonts.inter(
                                                    //         fontWeight: FontWeight.w600,
                                                    //
                                                    //         fontSize: 14,
                                                    //         color: Colors.black),
                                                    //   ),
                                                    SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.02),
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
                                    );
                                  })
                              : EmptyInvoiceInfo()
                      : (_invoiceController.invoiceStatus ==
                              InvoiceStatus.Loading)
                          ? Center(child: LoadingWidget())
                          : (_invoiceController.InvoicePendingList.length != 0)
                              ? ListView.builder(
                                  itemCount: _invoiceController
                                      .InvoicePendingList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var item = _invoiceController
                                        .InvoicePendingList[index];
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
                                                    // Text(
                                                    // item.paymentItemRequestList!.first.itemName!,
                                                    //   style: GoogleFonts.inter(
                                                    //       fontWeight: FontWeight.w600,
                                                    //
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
                                                      0.05),
                                              // _isSelected
                                              //     ? SvgPicture.asset(
                                              //         'assets/images/circle.svg')
                                              //     : SvgPicture.asset(
                                              //         'assets/images/selectedItem.svg')
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
                                  })
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
                    'You are about to delete invoice(s). Are you sure you want to continue?',
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
                height: 50,
                width: 50,
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
}
