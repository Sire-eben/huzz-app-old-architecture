import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:huzz/app/screens/widget/custom_form_field.dart';
import 'package:huzz/model/debtors_model.dart';

import '../../../../colors.dart';
import 'debtorreminder.dart';

class Debtors extends StatefulWidget {
  const Debtors({Key? key}) : super(key: key);

  @override
  _DebtorsState createState() => _DebtorsState();
}

class _DebtorsState extends State<Debtors> {
  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

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
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.height * 0.02,
                    right: MediaQuery.of(context).size.height * 0.02,
                    bottom: MediaQuery.of(context).size.height * 0.02),
                child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: debtorsList.length,
                  itemBuilder: (context, index) {
                    if (debtorsList.length == 0) {
                      return Container(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.height * 0.02,
                            right: MediaQuery.of(context).size.height * 0.02,
                            bottom: MediaQuery.of(context).size.height * 0.02),
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
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontFamily: 'DMSans',
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Your debtors will show here. Click the ',
                                style: TextStyle(
                                    fontSize: 8,
                                    color: Colors.black,
                                    fontFamily: 'DMSans'),
                              ),
                              Text(
                                'New Debtors button to add your first debtor',
                                style: TextStyle(
                                    fontSize: 8,
                                    color: Colors.black,
                                    fontFamily: 'DMSans'),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Row(
                        children: [
                          Image.asset(debtorsList[index].image!),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.02),
                          Expanded(
                            flex: 5,
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    debtorsList[index].name!,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'DMSans',
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    debtorsList[index].phone!,
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
                                    "Bal: ${debtorsList[index].balance!}",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: 'DMSans',
                                        color: AppColor().backgroundColor,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    "Paid: ${debtorsList[index].paid!}",
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
                            child: Image.asset('assets/images/eye.png'),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => showModalBottomSheet(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20))),
                                  context: context,
                                  builder: (context) =>
                                      buildDebtorNotification()),
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
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () => showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20))),
                  context: context,
                  builder: (context) => buildAddDebtor()),
              child: Container(
                height: 55,
                margin: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
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
              InkWell(
                onTap: () => showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20))),
                    context: context,
                    builder: (context) => buildAddDebtor()),
                child: Container(
                  height: 55,
                  margin: EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
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
              ),
            ],
          ),
        ),
      );

  Container newCustomersInfo() {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => setState(() => itemValue = 1),
                child: Row(
                  children: [
                    Radio<int>(
                        value: 1,
                        activeColor: AppColor().backgroundColor,
                        groupValue: itemValue,
                        onChanged: (value) => setState(() => itemValue = 1)),
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
                onTap: () => setState(() => itemValue = 0),
                child: Row(
                  children: [
                    Radio<int>(
                        value: 0,
                        activeColor: AppColor().backgroundColor,
                        groupValue: itemValue,
                        onChanged: (value) => setState(() => itemValue = 0)),
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
          itemValue == 0
              ? Column(
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              width: 2, color: AppColor().backgroundColor)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: value,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColor().backgroundColor,
                          ),
                          iconSize: 30,
                          items: customers.map(buildExistingCustomer).toList(),
                          onChanged: (value) =>
                              setState(() => this.value = value),
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
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFieldInvoiceOptional(
                      label: 'Enter name',
                      keyType: TextInputType.name,
                    ),
                    CustomTextFieldInvoiceOptional(
                      label: 'Amount',
                      keyType: TextInputType.number,
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
                        child: DropdownButton<String>(
                          value: values,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColor().backgroundColor,
                          ),
                          iconSize: 30,
                          items: drugs.map(buildExistingCustomer).toList(),
                          onChanged: (value) =>
                              setState(() => this.values = value),
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
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget buildAddItem() => Container(
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
                  color: Colors.black, borderRadius: BorderRadius.circular(10)),
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
