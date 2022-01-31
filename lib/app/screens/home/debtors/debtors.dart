import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/auth_respository.dart';
import 'package:huzz/Repository/business_respository.dart';
import 'package:huzz/Repository/customer_repository.dart';
import 'package:huzz/Repository/debtors_repository.dart';
import 'package:huzz/Repository/product_repository.dart';
import 'package:huzz/app/screens/widget/custom_form_field.dart';
import 'package:huzz/model/customer_model.dart';
import 'package:huzz/model/debtor.dart';
import 'package:huzz/model/user.dart';
import 'package:number_display/number_display.dart';
import 'package:random_color/random_color.dart';

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
  final _customerKey = GlobalKey<FormState>();
  // ignore: unused_field
  final _debtorController = Get.find<DebtorRepository>();
  final _customerController = Get.find<CustomerRepository>();
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

  String? value="Pending";
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
  final _createKey = GlobalKey<FormState>();

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
                        child: Container(
                          decoration: BoxDecoration(
                            // color: Color(0xffF5F5F5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ((value=="Pending") ?(_debtorController.debtorsList.isEmpty):(_debtorController.fullyPaidDebt.isEmpty))
                              ? Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                          'assets/images/debtors.svg'),
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
                                        'Add New Debtors button to add your first debtor',
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
                                  separatorBuilder: (context, index) =>
                                      Divider(),
                                  itemCount:
                                      ((value=="Pending") ?(_debtorController.debtorsList.length):(_debtorController.fullyPaidDebt.length)),
                                  itemBuilder: (context, index) {
                                
                                    
                                    var item =
                                    ((value=="Pending") ?(_debtorController.debtorsList):(_debtorController.fullyPaidDebt))[index];    
                                    var customer = _customerController
                                        .checkifCustomerAvailableWithValue(
                                            item.customerId!);
                                    return DebtorListing(
                                      item: item,
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
          // ignore: dead_code
          : DebtorListing();
    });
  }

  DropdownMenuItem<String> buildDropDown(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(
              fontFamily: 'DMSans', fontSize: 10, fontWeight: FontWeight.bold),
        ),
      );

  StatefulBuilder buildAddDebtor() =>
      StatefulBuilder(builder: (BuildContext context, StateSetter myState) {
        return Container(
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
                InkWell(
                  child: Padding(
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
                      if (_customerKey.currentState!.validate()) {
                        if (_debtorController.addingDebtorStatus !=
                            AddingDebtorStatus.Loading) {
                          await _debtorController.addBudinessDebtor("INCOME");
                          setState(() {});
                          Get.back();
                        }
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.height * 0.03),
                      height: 50,
                      decoration: BoxDecoration(
                          color: AppColor().backgroundColor,
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
      });

  StatefulBuilder newCustomersInfo() =>
      StatefulBuilder(builder: (BuildContext context, StateSetter myState) {
        return Container(
          child: SingleChildScrollView(
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
                                      activeColor: AppColor().backgroundColor,
                                      groupValue:
                                          _debtorController.customerType,
                                      onChanged: (value) => myState(() =>
                                          _debtorController.customerType = 1)),
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
                              onTap: () => myState(
                                  () => _debtorController.customerType = 0),
                              child: Row(
                                children: [
                                  Radio<int>(
                                      value: 0,
                                      activeColor: AppColor().backgroundColor,
                                      groupValue:
                                          _debtorController.customerType,
                                      onChanged: (value) => myState(() =>
                                          _debtorController.customerType = 0)),
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
                        _debtorController.customerType == 1
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTextFieldInvoiceOptional(
                                    label: 'Name',
                                    keyType: TextInputType.name,
                                    textEditingController:
                                        _customerController.nameController,
                                    validatorText: "Name is needed",
                                  ),
                                  CustomTextFieldInvoiceOptional(
                                    label: 'Phone Number',
                                    keyType: TextInputType.name,
                                    textEditingController: _customerController
                                        .phoneNumberController,
                                    validatorText: "Phone number is needed",
                                  ),
                                  CustomTextFieldInvoiceOptional(
                                    label: 'Balance',
                                    keyType: TextInputType.number,
                                    textEditingController:
                                        _debtorController.amountController,
                                    validatorText: "Balance is needed",
                                  ),
                                  CustomTextFieldInvoiceOptional(
                                    label: 'Amount Paid',
                                    keyType: TextInputType.number,
                                    textEditingController:
                                        _debtorController.totalAmountController,
                                    validatorText: "Amount Paid is needed",
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
                                            _debtorController.selectedCustomer,
                                        icon: Icon(
                                          Icons.keyboard_arrow_down,
                                          color: AppColor().backgroundColor,
                                        ),
                                        iconSize: 30,
                                        items: _customerController
                                            .customerCustomer
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
                                    label: 'Balance',
                                    keyType: TextInputType.number,
                                    textEditingController:
                                        _debtorController.amountController,
                                  ),
                                  CustomTextFieldInvoiceOptional(
                                    label: 'Total Amount',
                                    keyType: TextInputType.number,
                                    textEditingController:
                                        _debtorController.totalAmountController,
                                  ),
                                ],
                              ),
                      ],
                    ),
                  )
                ],
              ),
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
                validatorText: "merchants name is needed",
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
                      'Add Debtors',
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
  DebtorListing({Key? key, this.item}) : super(key: key);

  @override
  _DebtorListingState createState() => _DebtorListingState();
}

class _DebtorListingState extends State<DebtorListing> {
  final _userController = Get.find<AuthRepository>();
  final _productController = Get.find<ProductRepository>();
  final _customerController = Get.find<CustomerRepository>();
  final _businessController = Get.find<BusinessRespository>();

  int statusType = 0;
  final _debtorController = Get.find<DebtorRepository>();

  RandomColor _randomColor = RandomColor();
  final _key = GlobalKey<FormState>();
  final TextEditingController textEditingController = TextEditingController();

  bool _isEditingText = false;

  late String? phone;
  late String? product;
  late String? firstName;
  late String? businessName;
final display = createDisplay(
      length: 5, decimal: 0, placeholder: 'N', units: ['K', 'M', 'B', 'T']);
  final users = Rx(User());
  User? get usersData => users.value;

  void initState() {
    firstName = _userController.user!.firstName!;
    // product = _productController.productGoods.first as String;
    phone = _businessController.selectedBusiness.value!.businessPhoneNumber;
    businessName = _businessController.selectedBusiness.value!.businessName;
    super.initState();
  }

  String? initialText =
      // "Dear $firstName, you have an outstanding payment of N500 for your purchase of $product at $businessName, $phone. \n \n Kindly pay as soon as possible.Thanks for your patronage. \n Powered by Huzz.";
      "Dear Tunde, you have an outstanding payment of N500 for your purchase of Melon seeds at Huzz technologies  (08133150074). Kindly pay as soon as possible. \n \nThanks for your patronage. \n  \nPowered by Huzz \n";

  @override
  Widget build(BuildContext context) {
    var customer = _customerController
        .checkifCustomerAvailableWithValue(widget.item!.customerId!);
        if(customer==null){
          return Container();
        }
        initialText="Dear ${customer.name!}, you have an outstanding payment of NGN ${display(widget.item!.balance!)} for your purchase at  $businessName  ($phone). Kindly pay as soon as possible. \n \nThanks for your patronage. \n  \nPowered by Huzz \n";
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
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontFamily: 'DMSans',
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
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'DMSans',
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bal: ${display(widget.item!.balance!)}",
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'DMSans',
                            color: AppColor().backgroundColor,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Paid: ${display((widget.item!.totalAmount! - widget.item!.balance!))}",
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
                child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20))),
                          context: context,
                          builder: (context) =>
                              buildUpdatePayment(widget.item!));
                    },
                    child: SvgPicture.asset('assets/images/edit_pri.svg')),
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

  Widget buildDebtorNotification() => SingleChildScrollView(
        child: Container(
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
                  padding: EdgeInsets.only(left: 10, top: 5, bottom: 2),
                  // height: MediaQuery.of(context).size.height * 0.2,
                  // width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: AppColor().whiteColor,
                    border: Border.all(
                      width: 2,
                      color: AppColor().backgroundColor,
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
            ],
          ),
        ),
      );

  // _editTitleTextField() {
  //   if (_isEditingText)
  //     return Center(
  //       child: TextFormField(
  //         controller: textEditingController,
  //         textInputAction: TextInputAction.none,
  //         decoration: InputDecoration(
  //           isDense: true,
  //           enabledBorder: OutlineInputBorder(
  //             borderSide: BorderSide.none,
  //           ),
  //           hintText: 'Type Message',
  //           hintStyle: Theme.of(context).textTheme.headline4!.copyWith(
  //                 fontFamily: 'DMSans',
  //                 color: Colors.black26,
  //                 fontSize: 14,
  //                 fontStyle: FontStyle.normal,
  //                 fontWeight: FontWeight.normal,
  //               ),
  //         ),
  //       ),
  //     );
  // }

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
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
    );
  }

  StatefulBuilder buildUpdatePayment(Debtor debtor) =>
      StatefulBuilder(builder: (BuildContext context, StateSetter myState) {
        ScrollController? controller;
        return SingleChildScrollView(
          physics: ScrollPhysics(),
          controller: controller,
          child: Container(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.04,
                right: MediaQuery.of(context).size.width * 0.04,
                bottom: MediaQuery.of(context).size.width * 0.04,
                top: MediaQuery.of(context).size.width * 0.02),
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
                                  ? debtor.balance
                                  : int.parse(textEditingController.text));
                          Get.back();
                        }
                      }
                    },
                    child: Obx(
                    (){
                        return Container(
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
                        );
                      }
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
