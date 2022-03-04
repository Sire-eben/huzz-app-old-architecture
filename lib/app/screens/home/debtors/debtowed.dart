import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/customer_repository.dart';
import 'package:huzz/Repository/debtors_repository.dart';
import 'package:huzz/app/screens/widget/custom_form_field.dart';
import 'package:huzz/model/customer_model.dart';
import 'package:huzz/model/debtor.dart';
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
  final _customerKey = GlobalKey<FormState>();

  final debtStatus = ['Pending', 'Fully Paid'];

  int statusType = 0;
  String? value = "Pending";

  final display = createDisplay(
      length: 5, decimal: 0, placeholder: 'N', units: ['K', 'M', 'B', 'T']);
  final _key = GlobalKey<FormState>();
  final TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
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
                        child: ((value == "Pending")
                                ? (_debtorRepository.debtOwnedList.isEmpty)
                                : (_debtorRepository
                                    .fullyPaidDebtOwned.isEmpty))
                            ? Container(
                                decoration: BoxDecoration(
                                  color: Color(0xffF5F5F5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/add_debt_owned.svg',
                                        height: 50,
                                        width: 50,
                                        color: AppColor().backgroundColor,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
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
                                        'Add New Debt Owed button to add your first debt',
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.black,
                                            fontFamily: 'DMSans'),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : ListView.separated(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                separatorBuilder: (context, index) => Divider(),
                                itemCount: ((value == "Pending")
                                    ? (_debtorRepository.debtOwnedList.length)
                                    : (_debtorRepository
                                        .fullyPaidDebtOwned.length)),
                                itemBuilder: (context, index) {
                                  var item = ((value == "Pending")
                                      ? (_debtorRepository.debtOwnedList)
                                      : (_debtorRepository
                                          .fullyPaidDebtOwned))[index];
                                  var customer = _customerRepository
                                      .checkifCustomerAvailableWithValue(
                                          item.customerId!);

                                  return (customer == null)
                                      ? Container()
                                      : Row(
                                          children: [
                                            Expanded(
                                                child: Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 10),
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
                                                      // ignore: unnecessary_null_comparison
                                                      customer != null &&
                                                              customer.name !=
                                                                  null &&
                                                              customer.name!
                                                                      .length >
                                                                  0
                                                          ? '${customer.name![0]}'
                                                          : "",
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
                                                      "Bal: ${display(item.balance!)}",
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          fontFamily: 'DMSans',
                                                          color: AppColor()
                                                              .orangeBorderColor,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    Text(
                                                      "Paid: N${display((item.totalAmount! - item.balance!))}",
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
                                                        isScrollControlled:
                                                            true,
                                                        builder: (context) =>
                                                            buildUpdatePayments(
                                                                item));
                                                  },
                                                  child: SvgPicture.asset(
                                                      'assets/images/edit_pri.svg')),
                                            ),
                                          ],
                                        );
                                }),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () => showModalBottomSheet(
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20))),
                            context: context,
                            builder: (context) => buildAddDebtor()),
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
    });
  }

  StatefulBuilder buildUpdatePayments(Debtor debtor) =>
      StatefulBuilder(builder: (BuildContext context, StateSetter myState) {
        return Container(
          margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.04,
            right: MediaQuery.of(context).size.width * 0.04,
          ),
          padding: MediaQuery.of(context).viewInsets,
          child: Form(
            key: _key,
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
                                      'Bal: ' + display(debtor.balance),
                                      style: TextStyle(
                                        fontFamily: "DMSans",
                                        color: AppColor().orangeBorderColor,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      // debtOwnedModel.balance!,
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
                        : Container(),
                    SizedBox(
                      height: 5,
                    ),
                    (statusType == 0)
                        ? Container(
                            child: TextFormField(
                              controller: textEditingController,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Amount is needed";
                                } else if (int.parse(value) > debtor.balance) {
                                  return "Amount must be between the range of balance";
                                }
                              },
                              decoration: InputDecoration(
                                isDense: true,

                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColor().backgroundColor,
                                        width: 2),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColor().backgroundColor,
                                        width: 2),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColor().backgroundColor,
                                        width: 2),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                // labelText: label,
                                hintText: 'N 0.00',

                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .copyWith(
                                      fontFamily: 'DMSans',
                                      color: Colors.black26,
                                      fontSize: 14,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
                (statusType == 0)
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05)
                    : Container(),
                InkWell(
                  onTap: () async {
                    if (_debtorRepository.addingDebtorStatus !=
                        AddingDebtorStatus.Loading) {
                      if (_key.currentState!.validate()) {
                        await _debtorRepository.UpdateBusinessDebtor(
                            debtor,
                            statusType == 1
                                ? debtor.balance
                                : int.parse(textEditingController.text));
                        Get.back();
                      }
                    }
                  },
                  child: Obx(() {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                          color: AppColor().backgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Center(
                        child: (_debtorRepository.addingDebtorStatus ==
                                AddingDebtorStatus.Loading)
                            ? Container(
                                width: 30,
                                height: 30,
                                child: Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.white)),
                              )
                            : Text(
                                'Save',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: 'DMSans'),
                              ),
                      ),
                    );
                  }),
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        );
      });
  StatefulBuilder buildAddDebtor() =>
      StatefulBuilder(builder: (BuildContext context, StateSetter myState) {
        return Container(
          margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.04,
            right: MediaQuery.of(context).size.width * 0.04,
          ),
          padding: MediaQuery.of(context).viewInsets,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
                  height: 3,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              SizedBox(height: 15),
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Add Debt Owed',
                    style: TextStyle(
                      color: AppColor().blackColor,
                      fontFamily: 'DMSans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: newCustomersInfo(),
              ),
              SizedBox(
                height: 20,
              ),
              Obx(() {
                return InkWell(
                  onTap: () async {
                    if (_debtorRepository.customerType == 0) {
                      if (_debtorRepository.selectedCustomer == null) {
                        Get.snackbar("Error", "Kindly Select a customer");
                        return;
                      }

                      if (_debtorRepository.addingDebtorStatus !=
                          AddingDebtorStatus.Loading) {
                        if (_customerKey.currentState!.validate()) {
                          await _debtorRepository.addBudinessDebtor("EXPENDITURE");
                          // setState(() {});
                          Get.back();
                        }
                      }
                    } else {
                      if (_customerKey.currentState!.validate()) {
                        if (_debtorRepository.addingDebtorStatus !=
                            AddingDebtorStatus.Loading) {
                          await _debtorRepository
                              .addBudinessDebtor("EXPENDITURE");
                          // setState(() {});
                          Get.back();
                        }
                      }
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.height * 0.03),
                    height: 50,
                    decoration: BoxDecoration(
                        color: AppColor().backgroundColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: (_debtorRepository.addingDebtorStatus ==
                            AddingDebtorStatus.Loading)
                        ? Container(
                            width: 30,
                            height: 30,
                            child: Center(
                                child: CircularProgressIndicator(
                                    color: Colors.white)),
                          )
                        : Row(
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
                                  'Add Debt Owed',
                                  style: TextStyle(
                                    color: AppColor().whiteColor,
                                    fontFamily: 'DMSans',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                );
              }),
              SizedBox(
                height: 10,
              )
            ],
          ),
        );
      });
  StatefulBuilder newCustomersInfo() =>
      StatefulBuilder(builder: (BuildContext context, StateSetter myState) {
        ScrollController? controller;
        return Form(
          key: _customerKey,
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.00),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.height * 0.01),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () =>
                              myState(() => _debtorRepository.customerType = 1),
                          child: Row(
                            children: [
                              Radio<int>(
                                  value: 1,
                                  activeColor: AppColor().backgroundColor,
                                  groupValue: _debtorRepository.customerType,
                                  onChanged: (value) => myState(() =>
                                      _debtorRepository.customerType = 1)),
                              Text(
                                'New Merchant',
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
                          onTap: () =>
                              myState(() => _debtorRepository.customerType = 0),
                          child: Row(
                            children: [
                              Radio<int>(
                                  value: 0,
                                  activeColor: AppColor().backgroundColor,
                                  groupValue: _debtorRepository.customerType,
                                  onChanged: (value) => myState(() =>
                                      _debtorRepository.customerType = 0)),
                              Text(
                                'Existing Merchants',
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
                    _debtorRepository.customerType == 1
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextFieldInvoiceOptional(
                                label: 'Name',
                                keyType: TextInputType.name,
                                textEditingController:
                                    _customerRepository.nameController,
                                validatorText: "Name is required",
                              ),
                              CustomTextFieldInvoiceOptional(
                                label: 'Phone Number',
                                keyType: TextInputType.name,
                                textEditingController:
                                    _customerRepository.phoneNumberController,
                                validatorText: "Phone number is required",
                              ),
                              CustomTextFieldInvoiceOptional(
                                label: 'Amount you owe',
                                keyType: TextInputType.number,
                                textEditingController:
                                    _debtorRepository.totalAmountController,
                                validatorText: "Amount you owe is required",
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Select Merchant',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontFamily: 'DMSans'),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "*",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                        fontFamily: 'DMSans'),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        width: 2,
                                        color: AppColor().backgroundColor)),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<Customer>(
                                    value: _debtorRepository.selectedCustomer,
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: AppColor().backgroundColor,
                                    ),
                                    iconSize: 30,
                                    items: _customerRepository
                                       .customerMerchant
                                        .map((value) {
                                      return DropdownMenuItem<Customer>(
                                        value: value,
                                        child: Text(value.name!),
                                      );
                                    }).toList(),
                                    onChanged: (value) => myState(
                                      () => _debtorRepository.selectedCustomer =
                                          value,
                                    ),
                                  ),
                                ),
                              ),
                              // CustomTextFieldInvoiceOptional(
                              //   label: 'Balance',
                              //   keyType: TextInputType.number,
                              //   textEditingController:
                              //       _customerRepository.amountController,
                              // ),
                              CustomTextFieldInvoiceOptional(
                                label: 'Amount you owe',
                                keyType: TextInputType.number,
                                validatorText: "Amount you owe is required",
                                textEditingController:
                                    _debtorRepository.totalAmountController,
                              ),
                            ],
                          ),
                  ],
                ),
              )
            ],
          ),
        );
      });

  DropdownMenuItem<String> buildExistingCustomer(String item) =>
      DropdownMenuItem(
        value: item,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Color(0xffCFD1D2),
            ),
            borderRadius: BorderRadius.circular(10),
            color: Color(0xffDCF2EF),
          ),
          child: Row(
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor().blueColor,
                ),
                child: Center(
                  child: Text('F',
                      style: TextStyle(
                        color: AppColor().whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      )),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Center(
                child: Text(
                  item,
                  style: TextStyle(fontSize: 12),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Center(
                child: Text(
                  '09038726495',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      );

  Widget buildAddItem() =>
      StatefulBuilder(builder: (BuildContext context, StateSetter myState) {
        return Container(
          // padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
          margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.04,
            right: MediaQuery.of(context).size.width * 0.04,
          ),
          padding: MediaQuery.of(context).viewInsets,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                height: 6,
                width: 100,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              CustomTextField(
                label: "Enter Name *",
                validatorText: "merchant name is needed",
                hint: 'E.g.  Debtors Name',
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: "Amount",
                      validatorText: "amount is needed",
                      hint: '₦0',
                    ),
                  ),
                  Expanded(
                    child: CustomTextField(
                      label: "Select Product",
                      validatorText: "Select Product ",
                      hint: '0',
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              InkWell(
                onTap: () {},
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
                      'Add Debtors',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'DMSans'),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
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
  DebtorOwnedListing({Key? key, this.item}) : super(key: key);

  @override
  _DebtorOwnedListingState createState() => _DebtorOwnedListingState();
}

class _DebtorOwnedListingState extends State<DebtorOwnedListing> {
  int statusType = 0;
  final _debtorController = Get.find<DebtorRepository>();

  final _key = GlobalKey<FormState>();
  final TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: MediaQuery.of(context).size.width * 0.02),
        Expanded(
          flex: 5,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'name',
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'DMSans',
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                ),
                Text(
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
                  "Bahl: ${widget.item!.balance!}",
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
          child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20))),
                    context: context,
                    builder: (context) => buildUpdatePayments(widget.item!));
              },
              child: SvgPicture.asset('assets/images/edit_pri.svg')),
        ),
      ],
    );
  }

  StatefulBuilder buildUpdatePayments(Debtor debtor) =>
      StatefulBuilder(builder: (BuildContext context, StateSetter myState) {
        ScrollController? controller;
        return Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            controller: controller,
            child: Form(
              key: _key,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                        'Bal: ' + debtor.balance.toString(),
                                        style: TextStyle(
                                          fontFamily: "DMSans",
                                          color: AppColor().orangeBorderColor,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        // debtOwnedModel.balance!,
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
                          : Container(),
                      SizedBox(
                        height: 5,
                      ),
                      (statusType == 0)
                          ? Container(
                              child: TextFormField(
                                controller: textEditingController,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Amount is needed";
                                  } else if (int.parse(value) >
                                      debtor.balance) {
                                    return "Amount must be between the range of balance";
                                  }
                                },
                                decoration: InputDecoration(
                                  isDense: true,

                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColor().backgroundColor,
                                          width: 2),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColor().backgroundColor,
                                          width: 2),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColor().backgroundColor,
                                          width: 2),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  // labelText: label,
                                  hintText: 'N 0.00',

                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .copyWith(
                                        fontFamily: 'DMSans',
                                        color: Colors.black26,
                                        fontSize: 14,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.normal,
                                      ),
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ),
                  (statusType == 0)
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05)
                      : Container(),
                  InkWell(
                    onTap: () async {
                      if (_debtorController.addingDebtorStatus !=
                          AddingDebtorStatus.Loading) {
                        if (_key.currentState!.validate()) {
                          await _debtorController.UpdateBusinessDebtor(
                              debtor,
                              statusType == 1
                                  ? 0
                                  : int.parse(textEditingController.text));
                          Get.back();
                        }
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                          color: AppColor().backgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Center(
                        child: (_debtorController.addingDebtorStatus ==
                                AddingDebtorStatus.Loading)
                            ? Container(
                                width: 30,
                                height: 30,
                                child: Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.white)),
                              )
                            : Text(
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
          ),
        );
      });
}
