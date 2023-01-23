// ignore_for_file: unused_element, body_might_complete_normally_nullable

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/data/repository/auth_respository.dart';
import 'package:huzz/data/repository/business_respository.dart';
import 'package:huzz/data/repository/customer_repository.dart';
import 'package:huzz/data/repository/debtors_repository.dart';
import 'package:huzz/ui/home/debtors/debt_updated_success.dart';
import 'package:huzz/ui/widget/custom_form_field.dart';
import 'package:huzz/data/model/customer_model.dart';
import 'package:huzz/data/model/debtor.dart';
import 'package:huzz/data/model/user.dart';
import 'package:number_display/number_display.dart';
import 'package:random_color/random_color.dart';
import 'package:share_plus/share_plus.dart';
import 'package:huzz/core/constants/app_themes.dart';
import '../../../data/repository/team_repository.dart';
import '../../../data/repository/transaction_respository.dart';
import '../../../util/util.dart';
import '../money_history.dart';
import 'debtorreminder.dart';

// ignore: must_be_immutable
class Debtors extends StatefulWidget {
  Debtor? item;
  Debtors({
    Key? key,
    this.item,
  }) : super(key: key);

  @override
  _DebtorsState createState() => _DebtorsState();
}

class _DebtorsState extends State<Debtors> {
  final _customerKey = GlobalKey<FormState>();
  // ignore: unused_field
  final _debtorController = Get.find<DebtorRepository>();
  final _customerController = Get.find<CustomerRepository>();
  final teamController = Get.find<TeamRepository>();
  final itemNameController = TextEditingController();
  final amountController = TextEditingController();
  final quantityController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final paymentController = TextEditingController();
  final paymentSourceController = TextEditingController();
  final receiptFileController = TextEditingController();
  final amountPaidController = TextEditingController();
  final TextEditingController textEditingController = TextEditingController();

  final debtStatus = ['Pending', 'Fully Paid'];
  final display = createDisplay(
    roundingType: RoundingType.floor,
    length: 15,
    decimal: 5,
  );

  final items = [
    'Box',
    'feet',
    'kilogram',
    'meters',
  ];

  String? value = "Pending";
  String? values;

  String countryFlag = "NG";
  String countryCode = "234";

  int itemValue = 0;
  int currentStep = 0;
  int customerValue = 0;
  int quantityValue = 0;

  late String firstName, lastName, phone;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return (true)
          ? Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (_debtorController.debtorStatus ==
                          DebtorStatus.UnAuthorized) ...[
                        Container(),
                      ] else ...[
                        Container(
                          height: 95,
                          decoration: BoxDecoration(
                            color: AppColors.backgroundColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Number Of Debts",
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Center(
                                      child: Text(
                                        "${_debtorController.debtorsList.length}",
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 95,
                                  decoration: BoxDecoration(
                                    color: AppColors.secondBgColor,
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      stops: [
                                        0.1,
                                        0.6,
                                        0.8,
                                      ],
                                      colors: [
                                        Color(0xff0D8372),
                                        Color(0xff07A58E),
                                        AppColors.backgroundColor
                                            .withOpacity(0.5),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Total Debts",
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        "${Utils.getCurrency()}${display(_debtorController.debtorAmount)}",
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 14),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  width: 2, color: AppColors.backgroundColor)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: value,
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                size: 14,
                                color: AppColors.backgroundColor,
                              ),
                              hint: Text(
                                'Pending',
                                style: GoogleFonts.inter(
                                    fontSize: 10, fontWeight: FontWeight.w600),
                              ),
                              isDense: true,
                              items: debtStatus.map(buildDropDown).toList(),
                              onChanged: (value) =>
                                  setState(() => this.value = value),
                            ),
                          ),
                        ),
                      ],
                      SizedBox(height: 20),
                      Expanded(
                        child: ((value == "Pending")
                                ? (_debtorController.debtorsList.isEmpty)
                                : (_debtorController.fullyPaidDebt.isEmpty))
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
                                        'assets/images/debtors.svg',
                                        height: 50,
                                        width: 50,
                                        color: AppColors.backgroundColor,
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Add Debtors',
                                        style: GoogleFonts.inter(
                                            fontSize: 13,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        _debtorController.debtorStatus !=
                                                DebtorStatus.UnAuthorized
                                            ? 'Your debtors will show here. Click the'
                                            : 'Your debtors will show here.',
                                        style: GoogleFonts.inter(
                                          fontSize: 10,
                                          color: Colors.black,
                                        ),
                                      ),
                                      if (_debtorController.debtorStatus !=
                                          DebtorStatus.UnAuthorized) ...[
                                        Text(
                                          'Add New Debtors button to add your first debtor',
                                          style: GoogleFonts.inter(
                                            fontSize: 10,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                      SizedBox(height: 20),
                                      if (_debtorController.debtorStatus ==
                                          DebtorStatus.UnAuthorized) ...[
                                        Text(
                                          'You need to be authorized\nto view this module',
                                          style: GoogleFonts.inter(
                                              fontSize: 14,
                                              color:
                                                  AppColors.orangeBorderColor,
                                              fontWeight: FontWeight.w600),
                                          textAlign: TextAlign.center,
                                        ),
                                      ]
                                    ],
                                  ),
                                ),
                              )
                            : ListView.separated(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                separatorBuilder: (context, index) => Divider(),
                                itemCount: ((value == "Pending")
                                    ? (_debtorController.debtorsList.length)
                                    : (_debtorController.fullyPaidDebt.length)),
                                itemBuilder: (context, index) {
                                  var item = ((value == "Pending")
                                      ? (_debtorController.debtorsList)
                                      : (_debtorController
                                          .fullyPaidDebt))[index];
                                  // ignore: unused_local_variable
                                  var customer = _customerController
                                      .checkifCustomerAvailableWithValue(
                                          item.customerId ?? "");
                                  print(
                                      'Debtors: ${_debtorController.debtorsList.length}, Name: ${item.customerId}');
                                  return (customer != null)
                                      ? DebtorListing(
                                          item: item,
                                        )
                                      : Container();
                                }),
                      ),
                      SizedBox(height: 20),
                      if (_debtorController.debtorStatus ==
                          DebtorStatus.UnAuthorized) ...[
                        Container(),
                      ] else ...[
                        (teamController.teamMember.teamMemberStatus ==
                                    'CREATOR' ||
                                teamController.teamMember.authoritySet!
                                    .contains('CREATE_DEBTOR'))
                            ? InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                      isScrollControlled: true,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20))),
                                      context: context,
                                      builder: (context) => buildAddDebtor());
                                },
                                child: Container(
                                  height: 55,
                                  decoration: BoxDecoration(
                                      color: AppColors.backgroundColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        size: 22,
                                        color: AppColors.whiteColor,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Center(
                                        child: Text(
                                          'Add New Debtor',
                                          style: GoogleFonts.inter(
                                            color: AppColors.whiteColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ],
            )
          // ignore: dead_code
          : DebtorListing();
    });
  }

  DropdownMenuItem<String> buildDropDown(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600),
        ),
      );

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
                    'Add Debtor',
                    style: GoogleFonts.inter(
                      color: AppColors.blackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
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
                    print('Amount to be updated: ' +
                        _debtorController.totalAmountController.text);
                    if (_debtorController.customerType == 0) {
                      if (_debtorController.selectedCustomer == null) {
                        Get.snackbar("Error", "Kindly Select a customer");
                        return;
                      }

                      if (_debtorController.addingDebtorStatus !=
                          AddingDebtorStatus.Loading) {
                        if (_customerKey.currentState!.validate()) {
                          await _debtorController.addBudinessDebtor("INCOME");
                          setState(() {});
                          Get.back();
                        }
                      }
                    } else {
                      if (_customerKey.currentState!.validate()) {
                        if (_debtorController.addingDebtorStatus !=
                            AddingDebtorStatus.Loading) {
                          await _debtorController.addBudinessDebtor("INCOME");
                          setState(() {});
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
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: (_debtorController.addingDebtorStatus ==
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
                                color: AppColors.whiteColor,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Center(
                                child: Text(
                                  'Add Debtor',
                                  style: GoogleFonts.inter(
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                );
              }),
              SizedBox(
                height: 20,
              )
            ],
          ),
        );
      });

  StatefulBuilder newCustomersInfo() =>
      StatefulBuilder(builder: (BuildContext context, StateSetter myState) {
        return Container(
          child: Form(
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
                            onTap: () => myState(
                                () => _debtorController.customerType = 1),
                            child: Row(
                              children: [
                                Radio<int>(
                                    value: 1,
                                    activeColor: AppColors.backgroundColor,
                                    groupValue: _debtorController.customerType,
                                    onChanged: (value) => myState(() =>
                                        _debtorController.customerType = 1)),
                                Text(
                                  'New Customer',
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
                            onTap: () => myState(
                                () => _debtorController.customerType = 0),
                            child: Row(
                              children: [
                                Radio<int>(
                                    value: 0,
                                    activeColor: AppColors.backgroundColor,
                                    groupValue: _debtorController.customerType,
                                    onChanged: (value) => myState(() =>
                                        _debtorController.customerType = 0)),
                                Text(
                                  'Existing Customers',
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
                      _debtorController.customerType == 1
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),

                                GestureDetector(
                                  onTap: () {
                                    _customerController
                                        .showContactPicker(context);
                                  },
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/select_from_contact.svg',
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        "Select from Contact",
                                        style: GoogleFonts.inter(
                                            color: AppColors.backgroundColor,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                CustomTextFieldInvoiceOptional(
                                  label: 'Name',
                                  keyType: TextInputType.name,
                                  textEditingController:
                                      _customerController.nameController,
                                  validatorText: "Name is required",
                                ),
                                CustomTextFieldInvoiceOptional(
                                  label: 'Phone Number',
                                  inputformater: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  keyType: Platform.isIOS
                                      ? TextInputType.numberWithOptions(
                                          signed: true, decimal: true)
                                      : TextInputType.number,
                                  textEditingController:
                                      _customerController.phoneNumberController,
                                  validatorText: "Phone number is required",
                                ),
                                // CustomTextFieldInvoiceOptional(
                                //   label: 'Balance',
                                //   inputformater: [FilteringTextInputFormatter.digitsOnly],
                                // keyType: Platform.isIOS?TextInputType.numberWithOptions(signed: true, decimal: true): TextInputType.number,
                                //   textEditingController:
                                //       _debtorController.amountController,
                                //   validatorText: "Balance is needed",
                                // ),
                                CustomTextFieldInvoiceOptional(
                                  label: 'Amount Owed',
                                  inputformater: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  keyType: Platform.isIOS
                                      ? TextInputType.numberWithOptions(
                                          signed: true, decimal: true)
                                      : TextInputType.number,
                                  textEditingController:
                                      _debtorController.totalAmountController,
                                  validatorText: "Amount Owed is required",
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Select Customer',
                                      style: GoogleFonts.inter(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "*",
                                      style: GoogleFonts.inter(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
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
                                          color: AppColors.backgroundColor)),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<Customer>(
                                      value: _debtorController.selectedCustomer,
                                      icon: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: AppColors.backgroundColor,
                                      ),
                                      iconSize: 30,
                                      items: _customerController
                                          .offlineBusinessCustomer
                                          .map((value) {
                                        return DropdownMenuItem<Customer>(
                                          value: value,
                                          child: Text(value.name!),
                                        );
                                      }).toList(),
                                      onChanged: (value) => myState(
                                        () => _debtorController
                                            .selectedCustomer = value,
                                      ),
                                    ),
                                  ),
                                ),
                                CustomTextFieldInvoiceOptional(
                                  label: 'Amount Owed',
                                  inputformater: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  keyType: Platform.isIOS
                                      ? TextInputType.numberWithOptions(
                                          signed: true, decimal: true)
                                      : TextInputType.number,
                                  validatorText: "Amount Owed is required",
                                  textEditingController:
                                      _debtorController.totalAmountController,
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ],
            ),
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
                  color: AppColors.blueColor,
                ),
                child: Center(
                  child: Text('F',
                      style: GoogleFonts.inter(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w600,
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
                  style: GoogleFonts.inter(fontSize: 12),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Center(
                child: Text(
                  '09038726495',
                  style: GoogleFonts.inter(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      );

  Widget buildAddItem() =>
      StatefulBuilder(builder: (BuildContext context, StateSetter myState) {
        return Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
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
                validatorText: "merchants name is needed",
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
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Center(
                    child: Text(
                      'Add Debtors',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      });
}

// ignore: must_be_immutable
class DebtorListing extends StatefulWidget {
  Debtor? item;
  DebtorListing({Key? key, this.item}) : super(key: key);

  @override
  _DebtorListingState createState() => _DebtorListingState();
}

class _DebtorListingState extends State<DebtorListing> {
  final _userController = Get.find<AuthRepository>();
  final _customerController = Get.find<CustomerRepository>();
  final _businessController = Get.find<BusinessRespository>();

  int statusType = 0;
  final _debtorController = Get.find<DebtorRepository>();
  final teamController = Get.find<TeamRepository>();

  RandomColor _randomColor = RandomColor();
  final _key = GlobalKey<FormState>();
  final TextEditingController textEditingController = TextEditingController();
  bool _isEditingText = false;
  late String? phone;
  late String? product;
  late String? firstName;
  late String? businessName;
  final display = createDisplay(
    roundingType: RoundingType.floor,
    length: 15,
    decimal: 5,
  );
  final users = Rx(User());
  User? get usersData => users.value;

  void initState() {
    firstName = _userController.user!.firstName!;
    phone = _businessController.selectedBusiness.value!.businessPhoneNumber;
    businessName = _businessController.selectedBusiness.value!.businessName;
    super.initState();
  }

  String? initialText;

  @override
  Widget build(BuildContext context) {
    var customer = _customerController
        .checkifCustomerAvailableWithValue(widget.item!.customerId!);
    print('Debtors: ${customer!.toJson()}');
    // ignore: unnecessary_null_comparison
    if (customer == null) {
      return Container();
    }
    initialText =
        "Dear ${customer.name!}, you have an outstanding payment of ${display(widget.item!.balance!)} for your purchase at ($businessName($phone)). Kindly pay as soon as possible. \n \nThanks for your patronage. \n  \nPowered by Huzz \n";

    // ignore: unnecessary_null_comparison
    return customer == null
        ? Container()
        : Row(
            children: [
              // Image.asset(debtorsList[index].image!),
              Expanded(
                  child: Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _randomColor.randomColor()),
                      child: Center(
                          child: Text(
                        customer.name == null || customer.name!.isEmpty
                            ? ""
                            : '${customer.name![0]}',
                        style: GoogleFonts.inter(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.normal),
                      ))),
                ),
              )),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
              Expanded(
                flex: 4,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer.name!,
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        customer.phone!,
                        style:
                            GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Balance: ${Utils.getCurrency()}${display(widget.item!.balance!)}",
                        style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.backgroundColor,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Paid: ${Utils.getCurrency()}${display((widget.item!.totalAmount! - widget.item!.balance!))}",
                        style:
                            GoogleFonts.inter(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: (teamController.teamMember.teamMemberStatus ==
                            'CREATOR' ||
                        teamController.teamMember.authoritySet!
                            .contains('UPDATE_DEBTOR'))
                    ? GestureDetector(
                        onTap: () {
                          //  print(index);
                          // item.businessTransactionId="6229ab581982280f4fd07cf5";
                          print(
                              "business transaction id  is ${widget.item!.businessTransactionId}");
                          if (widget.item!.businessTransactionId != null &&
                              widget.item!.businessTransactionId!.isNotEmpty) {
                            final _transactionController =
                                Get.find<TransactionRespository>();
                            final Titem =
                                _transactionController.getTransactionById(
                                    widget.item!.businessTransactionId!);
                            if (Titem != null) {
                              //  Get.snackbar("Error","Going to transaction page");
                              Get.to(() => MoneySummary(
                                    item: Titem
                                        .businessTransactionPaymentItemList![0],
                                    pageCheck: false,
                                  ));
                            } else {
                              Get.snackbar("Error", "Transaction is not found");
                            }
                          } else {
                            showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20))),
                                context: context,
                                isScrollControlled: true,
                                builder: (context) =>
                                    buildUpdatePayment(widget.item!));
                          }
                        },
                        child: SvgPicture.asset('assets/images/edit_pri.svg'))
                    : Container(),
              ),
              SizedBox(width: 4),

              Expanded(
                child: GestureDetector(
                  onTap: () => showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20))),
                      context: context,
                      builder: (context) => buildDebtorNotification()),
                  child: SvgPicture.asset(
                    'assets/images/bell.svg',
                    height: 20,
                    width: 20,
                  ),
                ),
              ),
              SizedBox(width: 4),
              (teamController.teamMember.teamMemberStatus == 'CREATOR' ||
                      teamController.teamMember.authoritySet!
                          .contains('DELETE_DEBTOR'))
                  ? Obx(() => GestureDetector(
                        onTap: () {
                          _deleteDebtDialog(context);
                        },
                        child:
                            _debtorController.deletingItem.value == widget.item
                                ? CupertinoActivityIndicator(
                                    radius: 10,
                                  )
                                : SvgPicture.asset(
                                    "assets/images/delete.svg",
                                    height: 20,
                                    width: 20,
                                  ),
                      ))
                  : Container(),
            ],
          );
  }

  _deleteDebtDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(
              horizontal: 50,
            ),
            title: Text(
              'Delete Debt',
              style: GoogleFonts.inter(
                color: AppColors.backgroundColor,
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
            content: Text(
              "You're about to delete this debt entry, click delete to proceed",
              style: GoogleFonts.inter(
                color: AppColors.blackColor,
                fontWeight: FontWeight.normal,
                fontSize: 12,
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
                                width: 1.2,
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
                    SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          Get.back();
                          final debtor = widget.item!;
                          await _debtorController.deleteBusinessDebtor(debtor);
                        },
                        child: Container(
                          height: 45,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                              color: AppColors.orangeBorderColor,
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

  Widget buildDebtorNotification() => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Send Reminder to debtor',
                  style: GoogleFonts.inter(
                    color: AppColors.blackColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 50,
                margin: EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Message',
                      style:
                          GoogleFonts.inter(color: Colors.black, fontSize: 12),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Text(
                        "*",
                        style:
                            GoogleFonts.inter(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: EdgeInsets.only(left: 10, top: 5, bottom: 2),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    border: Border.all(
                      width: 2,
                      color: AppColors.backgroundColor,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _editTitleTextField(),
                  //
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Text(
                        "Send Options",
                        style: GoogleFonts.inter(
                          color: AppColors.blackColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    // Expanded(
                    //   child: Image.asset('assets/images/message.png'),
                    // ),
                    // Expanded(
                    //   child: Image.asset('assets/images/chat.png'),
                    // ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Share.share("$initialText", subject: 'Send Message');
                        },
                        child: Image.asset('assets/images/share.png'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  _editTitleTextField() {
    if (_isEditingText)
      return Center(
        child: TextField(
          onSubmitted: (newValue) {
            setState(() {
              initialText = newValue;
              _isEditingText = true;
            });
          },
          autofocus: true,
          controller: textEditingController,
        ),
      );
    return InkWell(
      onTap: () {
        setState(() {
          _isEditingText = true;
        });
      },
      child: Text(
        initialText!,
        style: GoogleFonts.inter(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
    );
  }

  StatefulBuilder buildUpdatePayment(Debtor debtor) =>
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
                  style: GoogleFonts.inter(
                    color: AppColors.blackColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
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
                              activeColor: AppColors.backgroundColor,
                              groupValue: statusType,
                              onChanged: (value) {
                                myState(() {
                                  statusType = 1;
                                });
                              },
                            ),
                            Text(
                              'Paying Fully',
                              style: GoogleFonts.inter(
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
                                activeColor: AppColors.backgroundColor,
                                groupValue: statusType,
                                onChanged: (value) {
                                  myState(() {
                                    value = 0;
                                    statusType = 0;
                                  });
                                }),
                            Text(
                              'Paying Partly',
                              style: GoogleFonts.inter(
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
                                      style: GoogleFonts.inter(
                                        color: Colors.black,
                                        fontSize: 16,
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
                                        style: GoogleFonts.inter(
                                            color: Colors.red, fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Balance: ${Utils.getCurrency()}${display(debtor.balance)}',
                                      style: GoogleFonts.inter(
                                        color: AppColors.orangeBorderColor,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      // debtOwnedModel.balance!,
                                      '',
                                      style: GoogleFonts.inter(
                                        color: AppColors.orangeBorderColor,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
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
                                      color: AppColors.backgroundColor,
                                      width: 2),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.backgroundColor,
                                      width: 2),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.backgroundColor,
                                      width: 2),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                hintText: '${Utils.getCurrency()}0.0',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .copyWith(
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
                                ? debtor.balance
                                : int.parse(textEditingController.text));
                        Get.to(DebtUpdatedSuccess());
                      }
                    }
                  },
                  child: Obx(() {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                          color: AppColors.backgroundColor,
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
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
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

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(
              horizontal: 50,
              vertical: 280,
            ),
            title: Row(
              children: [
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'This will send a direct sms to the debtor.',
                      style: GoogleFonts.inter(
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.normal,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            content: Container(
              child: Center(
                child: Container(
                  child: Text(
                    'Continue?',
                    style: GoogleFonts.inter(
                      color: AppColors.backgroundColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
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
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 45,
                        width: 100,
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
                    InkWell(
                      onTap: () {
                        Get.to(DebtorsConfirmation());
                      },
                      child: Container(
                        height: 45,
                        width: 100,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                            color: AppColors.backgroundColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            'Continue',
                            style: GoogleFonts.inter(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
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
