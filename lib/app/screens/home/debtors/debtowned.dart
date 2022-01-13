import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/customer_repository.dart';
import 'package:huzz/Repository/debtors_repository.dart';
import 'package:huzz/model/debtor.dart';
import 'package:huzz/model/debtors_model.dart';
import 'package:number_display/number_display.dart';
import 'package:random_color/random_color.dart';

import '../../../../colors.dart';

// ignore: must_be_immutable
class DebtOwned extends StatefulWidget {
  Debtor? item;
  DebtOwned({Key? key, this.item}) : super(key: key);

  @override
  _DebtOwnedState createState() => _DebtOwnedState();
}

class _DebtOwnedState extends State<DebtOwned> {
  // ignore: unused_field
  final _debtorRepository = Get.find<DebtorRepository>();
  final _customerRepository = Get.find<CustomerRepository>();

  RandomColor _randomColor = RandomColor();
  final itemNameController = TextEditingController();
  final amountController = TextEditingController();
  final quantityController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final paymentController = TextEditingController();
  final paymentSourceController = TextEditingController();
  final receiptFileController = TextEditingController();
  final amountPaidController = TextEditingController();

  final debtStatus = ['Pending', 'Fully Paid'];

  int statusType = 0;
  String? value;

  final display = createDisplay(
    length: 8,
    decimal: 0,
  );
  @override
  Widget build(BuildContext context) {
    return (true)
        ? Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              width: 2, color: AppColor().backgroundColor)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: value,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            size: 14,
                            color: AppColor().backgroundColor,
                          ),
                          hint: Text(
                            'Pending',
                            style: TextStyle(
                                fontFamily: 'DMSans',
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                          isDense: true,
                          items: debtStatus.map(buildDropDown).toList(),
                          onChanged: (value) =>
                              setState(() => this.value = value),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Container(
                        // height: MediaQuery.of(context).size.height * 0.5,
                        decoration: BoxDecoration(
                          color: Color(0xffF5F5F5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: (_debtorRepository.debtOwnedList.isEmpty)
                            ? Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                        'assets/images/debtors.svg'),
                                    Text(
                                      'Add Debt Owed',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontFamily: 'DMSans',
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Your debts will show here. Click the ',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.black,
                                          fontFamily: 'DMSans'),
                                    ),
                                    Text(
                                      'Add New Debt Owed button to add your first debtor',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.black,
                                          fontFamily: 'DMSans'),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.separated(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                separatorBuilder: (context, index) => Divider(),
                                itemCount:
                                    _debtorRepository.debtOwnedList.length,
                                itemBuilder: (context, index) {
                                  var item =
                                      _debtorRepository.debtOwnedList[index];
                                  var customer = _customerRepository
                                      .checkifCustomerAvailableWithValue(
                                          item.customerId!);
                                  return Row(
                                    children: [
                                      Expanded(
                                          child: Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: _randomColor
                                                      .randomColor()),
                                              child: Center(
                                                  child: Text(
                                                '${customer!.name![0]}',
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    color: Colors.white,
                                                    fontFamily: 'DMSans',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ))),
                                        ),
                                      )),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.02),
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                customer.name!,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: 'DMSans',
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Text(
                                                customer.phone!,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: 'DMSans',
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Bal: ${item.balance!}",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontFamily: 'DMSans',
                                                    color: AppColor()
                                                        .orangeBorderColor,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Text(
                                                "Paid: ${(item.totalAmount! - item.balance!)}",
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    fontFamily: 'DMSans',
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: InkWell(
                                            onTap: () {
                                              print(index);
                                              showModalBottomSheet(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      20))),
                                                  context: context,
                                                  isScrollControlled: true,
                                                  builder: (context) =>
                                                      buildUpdatePayment(
                                                          debtOwnedList[
                                                              index]));
                                            },
                                            child: SvgPicture.asset(
                                                'assets/images/edit_pri.svg')),
                                      ),
                                    ],
                                  );
                                }),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () => showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20))),
                          context: context,
                          builder: (context) =>
                              buildUpdatePayment(DebtOwnedModel())),
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                            color: AppColor().backgroundColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              size: 22,
                              color: AppColor().whiteColor,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Center(
                              child: Text(
                                'Add New Debt Owed',
                                style: TextStyle(
                                  color: AppColor().whiteColor,
                                  fontFamily: 'DMSans',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ],
          )
        // ignore: dead_code
        : DebtorOwnedListing();
  }

  StatefulBuilder buildUpdatePayment(DebtOwnedModel debtOwnedModel) =>
      StatefulBuilder(builder: (BuildContext context, StateSetter myState) {
        ScrollController? controller;
        return Container(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.04,
              right: MediaQuery.of(context).size.width * 0.04,
              bottom: MediaQuery.of(context).size.width * 0.04,
              top: MediaQuery.of(context).size.width * 0.02),
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            controller: controller,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Center(
                    child: Container(
                      height: 6,
                      width: 80,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Update Payment',
                  style: TextStyle(
                    color: AppColor().blackColor,
                    fontFamily: 'DMSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          myState(() {
                            statusType = 1;
                          });
                        },
                        child: Row(
                          children: [
                            Radio<int>(
                              value: 1,
                              activeColor: AppColor().backgroundColor,
                              groupValue: statusType,
                              onChanged: (value) {
                                myState(() {
                                  statusType = 1;
                                });
                              },
                            ),
                            Text(
                              'Paying Fully',
                              style: TextStyle(
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
                            statusType = 0;
                          });
                        },
                        child: Row(
                          children: [
                            Radio<int>(
                                value: 0,
                                activeColor: AppColor().backgroundColor,
                                groupValue: statusType,
                                onChanged: (value) {
                                  myState(() {
                                    value = 0;
                                    statusType = 0;
                                  });
                                }),
                            Text(
                              'Paying Partly',
                              style: TextStyle(
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
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    statusType == 0
                        ? Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Amount',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontFamily: 'DMSans',
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 5),
                                      child: Text(
                                        "*",
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Bal: ',
                                      style: TextStyle(
                                        fontFamily: "DMSans",
                                        color: AppColor().orangeBorderColor,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(
                                        fontFamily: "DMSans",
                                        color: AppColor().orangeBorderColor,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Amount',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'DMSans',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: Text(
                                    "*",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      child: TextFormField(
                        controller: _debtorRepository.amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          isDense: true,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColor().backgroundColor, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColor().backgroundColor, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColor().backgroundColor, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hintText: 'N 0.00',
                          hintStyle:
                              Theme.of(context).textTheme.headline4!.copyWith(
                                    fontFamily: 'DMSans',
                                    color: Colors.black26,
                                    fontSize: 14,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.normal,
                                  ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                InkWell(
                  onTap: () {
                    setState(() {
                      _debtorRepository.addBudinessDebtor("INCOME");
                    });
                    Get.back();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
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
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        );
      });

  DropdownMenuItem<String> buildDropDown(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(
              fontFamily: 'DMSans', fontSize: 10, fontWeight: FontWeight.bold),
        ),
      );
}

// ignore: must_be_immutable
class DebtorOwnedListing extends StatefulWidget {
  Debtor? item;
  DebtorOwnedListing({Key? key}) : super(key: key);

  @override
  _DebtorOwnedListingState createState() => _DebtorOwnedListingState();
}

class _DebtorOwnedListingState extends State<DebtorOwnedListing> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Image.asset(debtorsList[index].image!),
        SizedBox(width: MediaQuery.of(context).size.width * 0.02),
        Expanded(
          flex: 5,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // debtorsList[index].name!,
                  'name',
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'DMSans',
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  // debtorsList[index].phone!,
                  'phone',
                  style: TextStyle(
                      fontSize: 12, fontFamily: 'DMSans', color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Bal: ${widget.item!.balance!}",
                  style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'DMSans',
                      color: AppColor().backgroundColor,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  "Paid: ${(widget.item!.totalAmount! - widget.item!.balance!)}",
                  style: TextStyle(
                      fontSize: 11, fontFamily: 'DMSans', color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: SvgPicture.asset('assets/images/edit_pri.svg'),
        ),
      ],
    );
  }
}
