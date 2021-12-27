import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/customer_repository.dart';
import 'package:huzz/Repository/product_repository.dart';
import 'package:huzz/Repository/transaction_respository.dart';
import 'package:huzz/app/screens/home/income_success.dart';
import 'package:huzz/app/screens/widget/custom_form_field.dart';
import 'package:huzz/colors.dart';
import 'package:huzz/model/customer_model.dart';
import 'package:huzz/model/payment_item.dart';
import 'package:huzz/model/product.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'itemCard.dart';

class Records extends StatefulWidget {
  const Records({Key? key}) : super(key: key);

  @override
  _RecordsState createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  final _transactionController = Get.find<TransactionRespository>();
  final _customerController = Get.find<CustomerRepository>();
  final _productController = Get.find<ProductRepository>();

  final debtStatus = ['Pending', 'Fully Paid'];

  String? value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColor().backgroundColor,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Records',
          style: TextStyle(
            color: AppColor().backgroundColor,
            fontFamily: "DMSans",
            fontStyle: FontStyle.normal,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.height * 0.03),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColor().backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage("assets/images/home_rectangle.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical:
                                MediaQuery.of(context).size.height * 0.025),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Money Out",
                              style: TextStyle(
                                color: AppColor().whiteColor,
                                fontFamily: 'DMSans',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "N55,000",
                              style: TextStyle(
                                color: AppColor().whiteColor,
                                fontFamily: 'DMSans',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Money Out",
                            style: TextStyle(
                              color: AppColor().whiteColor,
                              fontFamily: 'DMSans',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "N3,570",
                            style: TextStyle(
                              color: AppColor().whiteColor,
                              fontFamily: 'DMSans',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical:
                                MediaQuery.of(context).size.height * 0.025),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Money Out",
                              style: TextStyle(
                                color: AppColor().whiteColor,
                                fontFamily: 'DMSans',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "N55,000",
                              style: TextStyle(
                                color: AppColor().whiteColor,
                                fontFamily: 'DMSans',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.height * 0.03),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColor().orangeBorderColor),
                        ),
                        SizedBox(width: 2),
                        Text(
                          'Money Out (₦)',
                          style: TextStyle(
                            color: AppColor().blackColor,
                            fontFamily: 'DMSans',
                            fontSize: 9,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    Row(
                      children: [
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColor().blueColor),
                        ),
                        SizedBox(width: 2),
                        Text(
                          'Money in (₦)',
                          style: TextStyle(
                            color: AppColor().blackColor,
                            fontFamily: 'DMSans',
                            fontSize: 9,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
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
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.height * 0.03),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Transactions',
                          style: TextStyle(
                            color: AppColor().blackColor,
                            fontFamily: 'DMSans',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          '(This Month)',
                          style: TextStyle(
                            color: AppColor().blackColor,
                            fontFamily: 'DMSans',
                            fontSize: 9,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    SvgPicture.asset('assets/images/graph.svg'),
                    SizedBox(width: 5),
                    SvgPicture.asset('assets/images/download.svg')
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.height * 0.03),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColor().backgroundColor.withOpacity(0.2)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'DATE',
                        style: TextStyle(
                          color: AppColor().backgroundColor,
                          fontFamily: 'DMSans',
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'MONEY OUT (N)',
                        style: TextStyle(
                          color: AppColor().backgroundColor,
                          fontFamily: 'DMSans',
                          fontSize: 9,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'MONEY IN (N)',
                        style: TextStyle(
                          color: AppColor().backgroundColor,
                          fontFamily: 'DMSans',
                          fontSize: 9,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAddNewItem() =>
      StatefulBuilder(builder: (BuildContext context, StateSetter myState) {
        return Container(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.04,
              right: MediaQuery.of(context).size.width * 0.04,
              bottom: MediaQuery.of(context).size.width * 0.04,
              top: MediaQuery.of(context).size.width * 0.02),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: 6,
                  width: 80,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      myState(() {
                        _transactionController.selectedValue = 1;
                      });
                    },
                    child: Row(
                      children: [
                        Radio<int>(
                          value: 1,
                          activeColor: AppColor().backgroundColor,
                          groupValue: _transactionController.selectedValue,
                          onChanged: (value) {
                            myState(() {
                              _transactionController.selectedValue = 1;
                            });
                          },
                        ),
                        Text(
                          'Enter Item',
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
                    onTap: () {
                      myState(() {
                        _transactionController.selectedValue = 0;
                      });
                    },
                    child: Row(
                      children: [
                        Radio<int>(
                            value: 0,
                            activeColor: AppColor().backgroundColor,
                            groupValue: _transactionController.selectedValue,
                            onChanged: (value) {
                              myState(() {
                                value = 0;
                                _transactionController.selectedValue = 0;
                              });
                            }),
                        Text(
                          'Select Product',
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
              _transactionController.selectedValue == 1
                  ? CustomTextField(
                      label: 'Item Name',
                      hint: 'Television',
                      keyType: TextInputType.name,
                      validatorText: 'Item name is needed',
                      textEditingController:
                          _transactionController.itemNameController,
                    )
                  : Container(),
              _transactionController.selectedValue == 1
                  ? Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: "Amount",
                            hint: 'N 0.00',
                            validatorText: "Amount name is needed",
                            textEditingController:
                                _transactionController.amountController,
                            keyType: TextInputType.phone,
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.height * 0.03),
                        Expanded(
                          child: CustomTextField(
                              label: "Quantity",
                              hint: '4',
                              keyType: TextInputType.phone,
                              validatorText: "Quantity name is needed",
                              textEditingController:
                                  _transactionController.quantityController),
                        ),
                      ],
                    )
                  : Container(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              _transactionController.selectedValue == 1
                  ? Container()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Product',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'DMSans'),
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
                            ),
                          ),
                        ),
                      ],
                    ),
              _transactionController.selectedValue == 1
                  ? Container()
                  : SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              InkWell(
                onTap: () {
                  _transactionController.addMoreProduct();
                  setState(() {});
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

  Widget showAllItems() {
    return Container(
        margin: EdgeInsets.only(top: 20),
        width: MediaQuery.of(context).size.width,
        height: _transactionController.productList.length * 100,
        child: ListView.builder(
            itemCount: _transactionController.productList.length,
            itemBuilder: (context, index) => ItemCard(
                  item: _transactionController.productList[index],
                  onDelete: () {
                    var item = _transactionController.productList[index];
                    _transactionController.productList.remove(item);
                    if (_transactionController.productList.length == 1) {
                      _transactionController
                          .setValue(_transactionController.productList.first);
                    }
                    setState(() {});
                  },
                  onEdit: () {
                    _transactionController.selectEditValue(
                        _transactionController.productList[index]);

                    showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20))),
                        context: context,
                        builder: (context) => buildEditItem(
                            _transactionController.productList[index], index));
                  },
                )));
  }

  Widget buildEditItem(PaymentItem item, int index) =>
      StatefulBuilder(builder: (BuildContext context, StateSetter myState) {
        return Container(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.04,
              right: MediaQuery.of(context).size.width * 0.04,
              bottom: MediaQuery.of(context).size.width * 0.04,
              top: MediaQuery.of(context).size.width * 0.02),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: 6,
                  width: 80,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              CustomTextField(
                label: 'Item Name',
                hint: 'Television',
                keyType: TextInputType.name,
                validatorText: 'Item name is needed',
                enabled: item.productId == null || item.productId!.isEmpty,
                textEditingController:
                    _transactionController.itemNameController,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: "Amount",
                      hint: 'N 0.00',
                      validatorText: "Amount name is needed",
                      enabled:
                          item.productId == null || item.productId!.isEmpty,
                      textEditingController:
                          _transactionController.amountController,
                      keyType: TextInputType.phone,
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.height * 0.03),
                  Expanded(
                    child: CustomTextField(
                        label: "Quantity",
                        hint: '4',
                        keyType: TextInputType.phone,
                        validatorText: "Quantity name is needed",
                        textEditingController:
                            _transactionController.quantityController),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              InkWell(
                onTap: () {
                  _transactionController.updatePaymetItem(item, index);
                  setState(() {});
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
                      'Update',
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
