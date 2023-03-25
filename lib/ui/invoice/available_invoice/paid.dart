import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/util/constants.dart';
import 'package:huzz/core/widgets/state/loading.dart';
import 'package:huzz/data/repository/business_respository.dart';
import 'package:huzz/data/repository/customer_repository.dart';
import 'package:huzz/data/repository/invoice_repository.dart';
import 'package:huzz/ui/invoice/available_invoice/single_invoice_preview.dart';
import 'package:huzz/data/model/invoice.dart';
import 'package:huzz/core/util/util.dart';
import 'package:huzz/ui/widget/huzz_dialog/delete_dialog.dart';
import 'package:number_display/number_display.dart';
import '../../../data/repository/team_repository.dart';
import 'package:huzz/core/constants/app_themes.dart';
import '../create_invoice.dart';
import 'empty_invoice_info.dart';

class Paid extends StatefulWidget {
  const Paid({super.key});

  @override
  _PaidState createState() => _PaidState();
}

class _PaidState extends State<Paid> {
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
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 50),
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
                        '(${_invoiceController.paidInvoiceList.length})',
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
                  return Future.delayed(const Duration(seconds: 1), () {
                    _invoiceController.getOnlineInvoice(value!.businessId!);
                    _invoiceController.GetOfflineInvoices(value.businessId!);
                  });
                },
                child: !deleteItem
                    ? (_invoiceController.invoiceStatus ==
                            InvoiceStatus.Loading)
                        ? const Center(child: LoadingWidget())
                        : (_invoiceController.invoiceStatus ==
                                    InvoiceStatus.Available &&
                                _invoiceController.paidInvoiceList.isNotEmpty)
                            ? ListView.builder(
                                itemCount:
                                    _invoiceController.paidInvoiceList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var item =
                                      _invoiceController.paidInvoiceList[index];
                                  var customer = _customerController
                                      .checkifCustomerAvailableWithValue(
                                          item.customerId ?? "");
                                  return GestureDetector(
                                    onTap: () async {
                                      Get.to(() =>
                                          PreviewSingleInvoice(invoice: item));
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.02),
                                      child: Container(
                                        padding: EdgeInsets.all(
                                            MediaQuery.of(context).size.height *
                                                0.02),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.grey.withOpacity(0.1),
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
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
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
                                                                FontWeight.w600,
                                                            fontSize: 14,
                                                            color: const Color(
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
                                            const Icon(
                                              Icons.arrow_forward_ios,
                                              color: AppColors.backgroundColor,
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
                        ? const Center(child: LoadingWidget())
                        : (_invoiceController.invoiceStatus ==
                                    InvoiceStatus.Available &&
                                _invoiceController.paidInvoiceList.isNotEmpty)
                            ? ListView.builder(
                                itemCount:
                                    _invoiceController.paidInvoiceList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var item =
                                      _invoiceController.paidInvoiceList[index];
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
                                            MediaQuery.of(context).size.height *
                                                0.02),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.grey.withOpacity(0.1),
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
                                                  const SizedBox(
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
                                                                FontWeight.w600,
                                                            fontSize: 14,
                                                            color: const Color(
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
                                                duration: const Duration(
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
                                                        ? const Color(
                                                            0xffEF6500)
                                                        : Colors.transparent,
                                                    width: 2,
                                                  ),
                                                ),
                                                child: Visibility(
                                                  visible: visible,
                                                  child: const Icon(
                                                    Icons.check,
                                                    size: 15,
                                                    color: AppColors.whiteColor,
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
              ))
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
                          showDialog(
                              context: context,
                              builder: (_) {
                                return HuzzDeleteDialog(
                                  title: 'Invoice(s)',
                                  content: 'invoice',
                                  action: () {
                                    _invoiceController.deleteItems();
                                    setState(() {
                                      deleteItem = false;
                                    });

                                    Get.back();
                                  },
                                );
                              });
                        }
                      } else {
                        Get.to(() => const CreateInvoice());
                      }
                    },
                    icon: (!deleteItem) ? Container() : const Icon(Icons.add),
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
