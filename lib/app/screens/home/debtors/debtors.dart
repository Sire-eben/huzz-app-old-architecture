import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/customer_repository.dart';
import 'package:huzz/Repository/debtors_repository.dart';
import 'package:huzz/Repository/product_repository.dart';
import 'package:huzz/Repository/transaction_respository.dart';
import 'package:huzz/app/screens/widget/custom_form_field.dart';
import 'package:huzz/model/customer_model.dart';
import 'package:huzz/model/debtor.dart';
import 'package:huzz/model/product.dart';

import '../../../../colors.dart';
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
  final _debtorController = Get.find<DebtorRepository>();
  final _productController = Get.find<ProductRepository>();
  final _customerController = Get.find<CustomerRepository>();
  final _transactionController = Get.find<TransactionRespository>();

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

  final items = [
    'Box',
    'feet',
    'kilogram',
    'meters',
  ];

  final drugs = [
    'Vitamin C',
    'Flagyl',
    'Paracentamol',
    'Panadol',
  ];

  String? value;
  String? values;

  final customers = [
    'Folakemi Ajao',
    'Mr Bayo Akintan',
    'Mr Akintan Bayo ',
    'Mr Ojo Dada',
  ];

  int quantityValue = 0;
  String countryFlag = "NG";
  String countryCode = "234";
  int currentStep = 0;
  int customerValue = 0;
  int itemValue = 0;

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
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.66,
                      decoration: BoxDecoration(
                        color: Color(0xffF5F5F5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/images/debtors.svg'),
                            Text(
                              'Add Debtors',
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
                              'Your debtors will show here. Click the ',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black,
                                  fontFamily: 'DMSans'),
                            ),
                            Text(
                              'New Debtors button to add your first debtor',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black,
                                  fontFamily: 'DMSans'),
                            ),
                          ],
                        ),
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
                                'Add New Debtor',
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
        : DebtorListing();
  }

  Widget buildAddDebtor() => Container(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.04,
            right: MediaQuery.of(context).size.width * 0.04,
            bottom: MediaQuery.of(context).size.width * 0.04,
            top: MediaQuery.of(context).size.width * 0.02),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.max,
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
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Add Debtor',
                  style: TextStyle(
                    color: AppColor().blackColor,
                    fontFamily: 'DMSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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
                  onTap: () {
                    if (1<0) {
                      if (1!=0) {
                        _transactionController.addMoreProduct();
                      }
                      if (_transactionController.productList.isNotEmpty) {
                        if (_transactionController.selectedPaymentMode !=
                                null &&
                            _transactionController.selectedPaymentSource !=
                                null) {
                          if (_transactionController.addCustomer) {
                            if (_transactionController.selectedCustomer !=
                                    null ||
                                _customerController
                                        .nameController.text.isNotEmpty &&
                                    _customerController.phoneNumberController
                                        .text.isNotEmpty) {
                            } else {
                              Get.snackbar(
                                  "Error", "Fill up your contact details");
                              return;
                            }
                          }

                          //  _transactionController.createTransaction("INCOME");
                          _transactionController
                              .createBusinessTransaction("EXPENDITURE");
                        } else {
                          Get.snackbar(
                              "Error", "Fill up important information");
                        }
                      } else {
                        Get.snackbar("Error",
                            "You need to have at least one product to proceed");
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
                    child: (_transactionController.addingTransactionStatus ==
                            AddingTransactionStatus.Loading)
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
                                  'Add Debtor',
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
            ],
          ),
        ),
      );

  StatefulBuilder newCustomersInfo() =>
      StatefulBuilder(builder: (BuildContext context, StateSetter myState) {
        return Container(
          child: _transactionController.addCustomer == true
              ? Container()
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => setState(
                              () => _transactionController.customerType = 1),
                          child: Row(
                            children: [
                              Radio<int>(
                                  value: 1,
                                  activeColor: AppColor().backgroundColor,
                                  groupValue:
                                      _transactionController.customerType,
                                  onChanged: (value) => setState(() =>
                                      _transactionController.customerType = 1)),
                              Text(
                                'New Customer',
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
                          onTap: () => setState(
                              () => _transactionController.customerType = 0),
                          child: Row(
                            children: [
                              Radio<int>(
                                  value: 0,
                                  activeColor: AppColor().backgroundColor,
                                  groupValue:
                                      _transactionController.customerType,
                                  onChanged: (value) => setState(() =>
                                      _transactionController.customerType = 0)),
                              Text(
                                'Existing Customer',
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
                    _transactionController.customerType == 0
                        ? CustomTextFieldWithImageTransaction(
                            contactName: _customerController.nameController,
                            contactPhone:
                                _customerController.phoneNumberController,
                            contactMail: _customerController.emailController,
                            label: "Customer name",
                            validatorText: "Customer name is needed",
                            hint: 'customer name',
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Select Customer',
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
                                    value:
                                        _transactionController.selectedCustomer,
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: AppColor().backgroundColor,
                                    ),
                                    iconSize: 30,
                                    items: _customerController.customerCustomer
                                        .map((value) {
                                      return DropdownMenuItem<Customer>(
                                        value: value,
                                        child: Text(value.name!),
                                      );
                                    }).toList(),
                                    onChanged: (value) => setState(
                                      () => _transactionController
                                          .selectedCustomer = value,
                                    ),
                                    hint: Text(
                                      'Select existing customer',
                                      style: TextStyle(
                                        color: AppColor().hintColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextFieldInvoiceOptional(
                          label: 'Enter name',
                          keyType: TextInputType.name,
                          textEditingController:
                              _transactionController.contactName,
                        ),
                        CustomTextFieldInvoiceOptional(
                          label: 'Amount',
                          keyType: TextInputType.number,
                          textEditingController:
                              _transactionController.amountController,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Text(
                              'Select Product',
                              style: TextStyle(
                                color: AppColor().blackColor,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '(Optional)',
                              style: TextStyle(
                                color: AppColor().hintColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  width: 2, color: AppColor().backgroundColor)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<Product>(
                              value: _transactionController.selectedProduct,
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColor().backgroundColor,
                              ),
                              iconSize: 30,
                              items:
                                  _productController.productGoods.map((value) {
                                return DropdownMenuItem<Product>(
                                  value: value,
                                  child: Text(value.productName!),
                                );
                              }).toList(),
                              onChanged: (value) => myState(() {
                                _transactionController.selectedProduct = value;
                                _transactionController
                                    .selectedProduct!.quantity = 1;
                              }),
                              hint: Text(
                                'Select existing customer',
                                style: TextStyle(
                                  color: AppColor().hintColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          margin: EdgeInsets.only(
                            left: 5,
                            right: 20,
                            bottom: 10,
                          ),
                          child: Text(
                            'Brief Description',
                            style: TextStyle(color: Colors.black, fontSize: 12),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: AppColor().whiteColor,
                            border: Border.all(
                              width: 2,
                              color: AppColor().backgroundColor,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextFormField(
                            controller: textEditingController,
                            textInputAction: TextInputAction.none,
                            decoration: InputDecoration(
                              isDense: true,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Delivered some drugs',
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
                        ),
                      ],
                    ),
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
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.04,
              right: MediaQuery.of(context).size.width * 0.04,
              bottom: MediaQuery.of(context).size.width * 0.04,
              top: MediaQuery.of(context).size.width * 0.02),
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
                validatorText: "customers name is needed",
                hint: 'E.g.  Debtors Name',
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: "Amount",
                      validatorText: "amount is needed",
                      hint: '0',
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
                      'Add customers',
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

// ignore: must_be_immutable
class DebtorListing extends StatefulWidget {
  Debtor? item;
  DebtorListing({Key? key}) : super(key: key);

  @override
  _DebtorListingState createState() => _DebtorListingState();
}

class _DebtorListingState extends State<DebtorListing> {
  final _debtorController = Get.find<DebtorRepository>();
  final _customerController = Get.find<CustomerRepository>();
  final _transactionController = Get.find<TransactionRespository>();
  final TextEditingController textEditingController = TextEditingController();

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
                  // "Bal: ${debtorsList[index].balance!}",
                  "Bal: 1000",
                  style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'DMSans',
                      color: AppColor().backgroundColor,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  // "Paid: ${debtorsList[index].paid!}",
                  "Paid: 5000",
                  style: TextStyle(
                      fontSize: 11, fontFamily: 'DMSans', color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Image.asset('assets/images/eye.png'),
        ),
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
      ],
    );
  }

  Widget buildDebtorNotification() => Container(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.04,
            right: MediaQuery.of(context).size.width * 0.04,
            bottom: MediaQuery.of(context).size.width * 0.04,
            top: MediaQuery.of(context).size.width * 0.02),
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
                style: TextStyle(
                  color: AppColor().blackColor,
                  fontFamily: 'DMSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
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
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Text(
                      "*",
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: AppColor().whiteColor,
                  border: Border.all(
                    width: 2,
                    color: AppColor().backgroundColor,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextFormField(
                  controller: textEditingController,
                  textInputAction: TextInputAction.none,
                  decoration: InputDecoration(
                    isDense: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Type Message',
                    hintStyle: Theme.of(context).textTheme.headline4!.copyWith(
                          fontFamily: 'DMSans',
                          color: Colors.black26,
                          fontSize: 14,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
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
                      style: TextStyle(
                        color: AppColor().blackColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Image.asset('assets/images/message.png'),
                  ),
                  Expanded(
                    child: Image.asset('assets/images/chat.png'),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _displayDialog(context);
                      },
                      child: Image.asset('assets/images/share.png'),
                    ),
                  ),
                ],
              ),
            ),
            // Spacer(),
            // InkWell(
            //   onTap: () {
            //     Get.to(ServiceListing());
            //   },
            //   child: Container(
            //     height: 55,
            //     margin: EdgeInsets.symmetric(
            //       horizontal: 15,
            //     ),
            //     decoration: BoxDecoration(
            //         color: AppColor().backgroundColor,
            //         borderRadius: BorderRadius.circular(10)),
            //     child: Center(
            //       child: Text(
            //         'Save',
            //         style: TextStyle(
            //           color: AppColor().whiteColor,
            //           fontFamily: 'DMSans',
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      );

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
                      style: TextStyle(
                        color: AppColor().blackColor,
                        fontFamily: 'DMSans',
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
                    style: TextStyle(
                      color: AppColor().backgroundColor,
                      fontWeight: FontWeight.bold,
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
                            color: AppColor().backgroundColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            'Continue',
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
                  ],
                ),
              ),
            ],
          );
        });
  }
}
